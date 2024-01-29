/** 
    * @Project:   Primark
    * @Date:        13/06/2022
    * @Author:  Nitin K Nayan
    * @description : Lead Trigger Handler
    * ************************************************************************************************
    * Name                       Date            Comments
    * Nitin K Nayan(EPAM)        13-June-23      DIGIX-2506 as part of the GDPR SC deletion event to MC.
    */
public with sharing class LeadTriggerHandler {

    public static Boolean allowCalling = true;    
    /**
    * @description  : Calling method to Send a Request to MC
    * @author       : Nitin K Nayan
    * @param        : Map<Id,Lead> oldLeadMap Map<Id,String> Lead Id & Email
    **/
    public static void afterDelete(Map<Id,Lead> oldLeadMap){
        
        system.debug('allowCalling--->'+allowCalling);
        Map<Id,String> idEmailMap = new Map<Id,String>();
        if(allowCalling && oldLeadMap!= null && !oldLeadMap.isEmpty()){
            //Creating a map if Id & emails
            for(Id leadId : oldLeadMap.keySet()){
                system.debug('idd-->'+leadId+'email0--->'+oldLeadMap.get(leadId).Email+'--DeletedFromFlow__c--> '+oldLeadMap.get(leadId).DeletedFromFlow__c);
                if(!oldLeadMap.get(leadId).IsConverted && !oldLeadMap.get(leadId).DeletedFromFlow__c){
                    system.debug('indies 3 call-->');
                    idEmailMap.put(leadId,oldLeadMap.get(leadId).Email);
                }
                
            }

            //Call Method to send a async request to MC
            if(idEmailMap!=null && !idEmailMap.isEmpty()){
                system.debug('indies mrkt call-->');
                MarketingCloudIntegrationUtility.sendRequest(idEmailMap);
            }
        }

    }
}