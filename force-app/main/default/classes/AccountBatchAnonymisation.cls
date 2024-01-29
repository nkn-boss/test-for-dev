/**
 * @Project : Primark
 * @Author  : Devendra Villa
 * @Date    : 22/08/2023
 * @description :  batch class which anonymises the Account after specific timelines.
 */
public with sharing class AccountBatchAnonymisation implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
   
    
    public String retentionPolicy ;
    public Datetime retentionDate;
    public AccountBatchAnonymisation( String retentionPolicy1){
        retentionPolicy=retentionPolicy1;
  
    }

    
 Map<Id,String> idEmailMap = new Map<Id,String>();
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
    String query = 'SELECT Id,LastModifiedDate,Last_Activity_Date__c,Is_CS_Anonymised__c,Is_Anonymised__c,PersonContactId,Phone,ShippingPostalCode,BillingPostalCode,PersonMailingPostalCode, Is_MC_Anonymised__c,PersonEmail,Date_of_Birth__c,PersonBirthdate,MiddleName,FirstName,PersonMobilePhone,LastName,(SELECT Id FROM Cases) FROM Account WHERE  Is_Anonymised__c= false AND IsPersonAccount=true  AND Last_Activity_Date__c <'+ formattedDate;
    //String query = 'SELECT Id,LastModifiedDate,Last_Activity_Date__c,Is_CS_Anonymised__c,Is_Anonymised__c,PersonContactId,Phone,ShippingPostalCode,BillingPostalCode,PersonMailingPostalCode, Is_MC_Anonymised__c,PersonEmail,Date_of_Birth__c,PersonBirthdate,MiddleName,FirstName,PersonMobilePhone,LastName,(SELECT Id FROM Cases) FROM Account WHERE  Is_Anonymised__c= false AND IsPersonAccount=true  AND Last_Activity_Date__c < '+formattedDate+'ORDER BY LastModifiedDate  Desc limit 1';
    //String query = 'SELECT Id,LastModifiedDate,Last_Activity_Date__c,Is_CS_Anonymised__c,Is_Anonymised__c,PersonContactId,Phone,ShippingPostalCode,BillingPostalCode,PersonMailingPostalCode, Is_MC_Anonymised__c,PersonEmail,Date_of_Birth__c,PersonBirthdate,MiddleName,FirstName,PersonMobilePhone,LastName,(SELECT Id FROM Cases) FROM Account WHERE Is_Anonymised__c= false AND IsPersonAccount=true AND Last_Activity_Date__c < \'+interactionDate +\' ORDER BY LastModifiedDate  Desc  limit 1';
    system.debug('Final Query ==>' + query);
    return Database.getQueryLocator(query);   
    
}
/**
* @description  : To execute the batch
* @author       : Devendra Villa
* @param         Database.BatchableContext bc List<Account> accountList
* @return       : null
**/
public void execute(Database.BatchableContext bc,List<Account> accountQueryList){
    List<Account> accountList = new List<Account>();
    List<Account> accountsToUpdate = new List<Account>();
    Map<Id, List<Case>> accountIdToCasesMap = new Map<Id, List<Case>>();

    try{
        System.debug('RetentionDate'+ retentionDate);
        for (Account acc: accountQueryList){
            if(acc.Last_Activity_Date__c < retentionDate){
            //if(acc.Last_Activity_Date__c < Datetime.now()){    
                System.debug('entered');
                accountList.add(acc) ;
            }
        }

        for (Account acc: accountList){
            accountIdToCasesMap.put(acc.Id, acc.Cases);
        }
        for (Account acc: accountList){
            if(!acc.Is_MC_Anonymised__c){
            idEmailMap.put(acc.PersonContactId,acc.PersonEmail);
            }
            acc.Is_MC_Anonymised__c = true;
            List<Case> associatedCases = accountIdToCasesMap.get(acc.Id);
                if(acc.Is_CS_Anonymised__c ==true){
                    anonymiseAccountDetails(acc);  
                 }
                else if (associatedCases == null || associatedCases.isEmpty()){
                    anonymiseAccountDetails(acc); 
                    }
                    accountsToUpdate.add(acc);          
                    
        }
        if(!accountsToUpdate.isEmpty()){
            Database.update(accountsToUpdate, true);
            }
           
    }
    catch(Exception e){
        CustomException.logException(e);

    }

      
}
/**
* @description  : To anonymise the account
* @author       : Devendra Villa
* @param         Account acc
* @return       : null
**/
public static void anonymiseAccountDetails (Account acc){
    acc.PersonEmail	= acc.Id+'_noreply@primark.com';
    acc.PersonMobilePhone ='';
    acc.Phone='0010000000';
    acc.LastName= acc.Id;
    acc.FirstName=acc.Id;
    acc.MiddleName='';
    acc.PersonBirthdate=null;
    acc.Date_of_Birth__c= Date.today();
    acc.ShippingPostalCode='xxxxxx';
    acc.BillingPostalCode='xxxxxx';
    acc.PersonMailingPostalCode='';
    acc.Is_Anonymised__c = True;
    acc.Date_Of_Anonymisation__c= Date.today();
    acc.Salutation = '';
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
            MarketingCloudIntegrationUtility.sendRequestForMarketing(idEmailMap);
        }  
    }


}