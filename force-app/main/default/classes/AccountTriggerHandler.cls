/** 
    * @Project:   Primark
    * @Date:        03/10/2022
    * @Author:  Nitin K Nayan
    * @description : Account Trigger Handler
    * ************************************************************************************************
    * Name                       Date            Comments
    * Devendra Villa(EPAM)       26-DEC-22       CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
    * Nitin K Nayan(EPAM)        12-June-23      DIGIX-2506 as part of the GDPR SC deletion event to MC.
    */
public with sharing class AccountTriggerHandler {

    public static Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();


    /**
    * @description  : Calling method to Send a Request to MC
    * @author       : Nitin K Nayan
    * @param        : Map<Id,Account> oldAccountMap Map<Id,String> Account Id & PersonEmail
    **/
    public static void afterDelete(Map<Id,Account> oldAccountMap){
        
        Map<Id,String> idEmailMap = new Map<Id,String>();
        if(oldAccountMap!= null && !oldAccountMap.isEmpty()){
            //Creating a map if Id & emails
            for(Id accid : oldAccountMap.keySet()){
                system.debug('idd-->'+accid+'email0--->'+oldAccountMap.get(accid).PersonEmail+' RT---->>'+oldAccountMap.get(accid).RecordTypeId+'--DeletedFromFlow__c--> '+oldAccountMap.get(accid).DeletedFromFlow__c);
                if(oldAccountMap.get(accid).RecordTypeId == personAccountRecordTypeId && !oldAccountMap.get(accid).DeletedFromFlow__c){
                    idEmailMap.put(oldAccountMap.get(accid).PersonContactId,oldAccountMap.get(accid).PersonEmail);
                }
                
            }
        }
        //Call Method to send a async request to MC
        MarketingCloudIntegrationUtility.sendRequest(idEmailMap);


    }
}