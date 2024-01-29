/**
 * @Project : Primark
 * @Author  : Devendra Villa
 * @Date    : 23/08/2023
 * @description :  batch class which anonymises the Lead after specific timelines.
 */
public with sharing class LeadBatchAnonymisation implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
   
   
    Map<Id,String> idEmailMap = new Map<Id,String>();
    public String retentionPolicy ;
    public Datetime retentionDate;
    public LeadBatchAnonymisation( String retentionPolicy1){
      retentionPolicy=retentionPolicy1;

    }
    /**
    * @description  : To fetch the records
    * @author       : Devendra Villa
    * @param         Database.BatchableContext bc 
    * @return       : Database.QueryLocator
    **/
   public Database.QueryLocator start(Database.BatchableContext bc) {
        MC_Anonymisation_Criteria__mdt mcRetentionmdt =[SELECT Retention_Period__c,Retention_Period_Type__c,Interaction_Period_Type__c,Last_Interaction_Years__c from MC_Anonymisation_Criteria__mdt where DeveloperName=:retentionPolicy  LIMIT 1];
        Datetime interactionDate;
        retentionDate = mcRetentionmdt.Retention_Period_Type__c == 'Years' ? calculateDateInYears(-Integer.valueOf(mcRetentionmdt.Retention_Period__c)) : calculateDateInDays(-Integer.valueOf(mcRetentionmdt.Retention_Period__c));
        interactionDate=mcRetentionmdt.Interaction_Period_Type__c== 'Years' ? calculateDateInYears(-Integer.valueOf(mcRetentionmdt.Last_Interaction_Years__c)) : calculateDateInDays(-Integer.valueOf(mcRetentionmdt.Last_Interaction_Years__c));

        String formattedDate = interactionDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        System.debug('RetentionDate'+ retentionDate);
        System.debug('formattedDate'+ formattedDate);
        String query = 'SELECT Id,LastModifiedDate,Last_Activity_Date__c,Phone,PostalCode,MobilePhone,Email,Is_MC_Anonymised__c,Date_of_Birth__c,MiddleName,FirstName,LastName FROM Lead WHERE  Is_MC_Anonymised__c =false AND Last_Activity_Date__c < '+ formattedDate;
        //String query = 'SELECT Id,LastModifiedDate,Last_Activity_Date__c,Phone,PostalCode,MobilePhone,Email,Is_MC_Anonymised__c,Date_of_Birth__c,MiddleName,FirstName,LastName FROM Lead WHERE Is_MC_Anonymised__c =false AND Last_Activity_Date__c < 2023-09-05T23:47:00.891+0100  ORDER BY LastModifiedDate  Desc  limit 1';
        system.debug('Final Query ==>' + query);
        return Database.getQueryLocator(query);   
    }
    /**
    * @description  : To execute the batch
    * @author       : Devendra Villa
    * @param         Database.BatchableContext bc List<Lead> leadList
    * @return       : null
    **/
   public void execute(Database.BatchableContext bc,List<Lead> leadQueryList){
    List<Lead> leadsToUpdate = new List<Lead>();
    List<Lead> leadList = new List<Lead>();

        try{
            System.debug('RetentionDate'+ retentionDate);
            for (Lead exLead: leadQueryList){
                if(exLead.Last_Activity_Date__c < retentionDate){
                //if(exLead.Last_Activity_Date__c < DateTime.now()){ 
                    leadList.add(exLead) ;
                }
            } 
            for (Lead newLead: leadList){
                    idEmailMap.put(newLead.Id,newLead.Email);
                    //System.debug('Id'+ newLead.Id + 'Email'+newLead.Email );
                    newLead.Email	= newLead.Id+'_noreply@primark.com';
                    newLead.Phone='0010000000';
                    newLead.MobilePhone='';
                    newLead.LastName	= newLead.Id;
                    newLead.FirstName=newLead.Id;
                    newLead.MiddleName='';
                    newLead.Date_of_Birth__c=Date.today();
                    newLead.Is_MC_Anonymised__c = true;
                    newLead.PostalCode='xxxxxx';
                    newLead.Salutation = '';
                    newLead.Date_Of_Anonymisation__c= Date.today();
                    leadsToUpdate.add(newLead);
                    
                }
            if(!leadsToUpdate.isEmpty()){
                Database.update(leadsToUpdate, true);
                }
            
        }
        catch(Exception e){
            CustomException.logException(e);
        }
   }

        public static Datetime calculateDateInYears(Integer period){
            DateTime dateToday = DateTime.now();
            return  dateToday.addYears(period);
        }

        public static Datetime calculateDateInDays(Integer period){
            DateTime dateToday = DateTime.now();
            return  dateToday.addDays(period);
        }

    public void finish(database.BatchableContext bc){ 
        if(!idEmailMap.isEmpty()){
            //System.debug(idEmailMap);
            MarketingCloudIntegrationUtility.sendRequestForMarketing(idEmailMap);
        }  
    }
}