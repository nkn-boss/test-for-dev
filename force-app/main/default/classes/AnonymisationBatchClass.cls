/**
 * @Project : Primark
 * @Author  : Devendra Villa
 * @Date    : 03/08/2023
 * @description :  batch class which anonymises the cases after specific timelines.
 */
public with sharing class AnonymisationBatchClass implements Database.Batchable<sObject>{
   
    
  public String retentionPolicy;
  public AnonymisationBatchClass( String retentionPolicy1){
      retentionPolicy=retentionPolicy1;

  }
  /**
    * @description  : To fetch the records
    * @author       : Devendra Villa
    * @param         Database.BatchableContext bc 
    * @return       : Database.QueryLocator
    **/
  public Database.QueryLocator start(Database.BatchableContext bc) {
        String statusClosed='Closed';  
          System.debug('retentionPolicy===>'+ retentionPolicy);
       Anonymisation_Criteria__mdt retentionmdt =[select Tier__c,Extra_Fields__c,Period_Type__c, Retention_Period__c  from Anonymisation_Criteria__mdt where DeveloperName=:retentionPolicy  LIMIT 1];


        String query='Select Id,AccountId,ClosedDate from Case where Status= \''+statusClosed +'\' AND Is_Anonymised__c = False'+ AnonymisationUtility.getWhereClause(retentionmdt); 
        system.debug('Final Query ==>' + query);
        if(string.isNotBlank(AnonymisationUtility.getWhereClause(retentionmdt))){
        return Database.getQueryLocator(query); 
        }
          return null;
        
  }
  /**
    * @description  : To execute the batch
    * @author       : Devendra Villa
    * @param         Database.BatchableContext bc List<Case> casesList
    * @return       : null
    **/
  public void execute(Database.BatchableContext bc,List<Case> casesList){
    try{    
      List<Case> casesToUpdate = new List<Case>();
      List<Account> accountsToUpdate = new List<Account>();
      Set<Id> accountIds = new Set<Id>();
      Map<Id, Set<Id> > accountAllCaseIds = new Map<Id, Set<Id> >();
      Set<Id> currentCaseIds = new Set<Id>();
      Set<Id> contentDocumentIds = new Set<Id>();
      Set<Id> relatedCaseIds = new Set<Id>();



      for (Case c : casesList)
      {
        System.debug('CAseId in for ==>'+ c.Id+'----AccountId in for ==>'+ c.AccountId);
        accountIds.add(c.AccountId);
        
        currentCaseIds.add(c.Id);

        casesToUpdate.add(AnonymisationUtility.checkCases(c)); 
      }
      for(Case relatedCases : [SELECT Id from Case WHERE ParentId IN: currentCaseIds ]){
        relatedCaseIds.add(relatedCases.Id);
        casesToUpdate.add(AnonymisationUtility.checkCases(relatedCases)); 
      }

      System.debug('AccountId==>'+ accountIds.size());
      System.debug('AccountId==>'+ accountIds);

      System.debug('currentCaseIds==>'+ currentCaseIds.size());



        if(!accountIds.isEmpty()){
            for(Case caa: [SELECT AccountId,Id FROM Case WHERE Is_Anonymised__c = False AND AccountId IN :accountIds ])  {
              if(accountAllCaseIds != null && accountAllCaseIds.containsKey(caa.AccountId)){
                Set<Id> temp = accountAllCaseIds.get(caa.AccountId);
                temp.add(caa.Id);
                accountAllCaseIds.put(caa.AccountId, temp );
              }
              else{
                accountAllCaseIds.put(caa.AccountId, new Set<Id>{caa.Id});
              }
          }
      
    
      for(Id accId:accountIds){ 
        System.debug('AccId==>'+ accId);


            if (currentCaseIds!= null && accountAllCaseIds!= null && accountAllCaseIds.containsKey(accId)  ) {
                System.debug('inside if of accId==>' );
              Set<Id> notCurrentCaseIds =new Set<Id>();
              notCurrentCaseIds=accountAllCaseIds.get(accId);
              notCurrentCaseIds.removeAll(currentCaseIds);
              System.debug('notCurrentCaseIds==>'+ notCurrentCaseIds);
              if(notCurrentCaseIds.isEmpty()){
                accountsToUpdate.add( AnonymisationUtility.checkAccounts(accId));
              }
            }  
      }
    }

     currentCaseIds.addAll(relatedCaseIds);
     if(!currentCaseIds.isEmpty()){
        //AnonymisationUtility.checkLiveChatTranscripts(currentCaseIds);
        AnonymisationUtility.checkContentDocumentLinks(currentCaseIds);
        AnonymisationUtility.checkEmailmessages(currentCaseIds);
      }
      
      if(!accountsToUpdate.isEmpty()){
        Database.update(accountsToUpdate, true);
        }
      if(!casesToUpdate.isEmpty()){
          Database.update(casesToUpdate, true);
          }
      
      
        }
        catch(Exception e){
          CustomException.logException(e);
        }
        


  }

    


    
  public void finish(database.BatchableContext bc){
      

  }
  
}