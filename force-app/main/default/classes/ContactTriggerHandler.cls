/**
 * @Project : Primark
 * @Author  : Devendra Villa
 * @Date    : 10/08/2022
 * @description : to check the primary contact exists on an account already
 * ************************************************************************************************
 * Name                       Date            Comments
 * Devendra Villa(EPAM)       26-DEC-22       CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
 */
public without sharing class ContactTriggerHandler {
    /**
    * @description  : To use for operations for before events
    * @author       : Devendra Villa
    * @param   contacts to fetch the contacts
**/
    public static void onBefore(Contact[] contacts){
        checkPrimaryContactHandler(contacts);
    }

    /**
    * @description  : To check the primary contact
    * @author       : Devendra Villa
    * @param   contacts to fetch the contacts
**/ 
    public static void checkPrimaryContactHandler(Contact[] contacts){
                Set<Id> setAccId = new Set<Id>();
        for(Contact con : contacts){
            if(String.isNotBlank(con.AccountId)){
               setAccId.add(con.AccountId);
            }
        }
        List<Account> lstAcc = [SELECT id , name,(SELECT id,primary_Contact__c FROM contacts WHERE primary_Contact__c = true AND ID NOT IN :contacts LIMIT 1)  FROM account WHERE Id IN:setAccId WITH SECURITY_ENFORCED];
        
        Map<Id,Boolean> mapOfAccHavingPContact = new  Map<Id,Boolean>();
        
        for(Account acc : lstAcc){
            if(acc.contacts.size() == 1){
                mapOfAccHavingPContact.put(acc.Id,true);
            }
        }
        for(Contact con : contacts){
            if(con.primary_Contact__c && mapOfAccHavingPContact.containsKey(con.AccountId)){
                con.primary_Contact__c.addError('Selected Account already have primary contact ');
            }
        }
                
            }
   
     
}