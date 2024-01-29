/**
 * @Project : Primark
 * @Author  : Kevin Snell
 * @Date    : 16/02/2022 
 * @description : invocable method to send case email from a flow
 * ************************************************************************************************
 * Name                     Date            Comments
 * Nitin K Nayan (EPAM)     27-DEC-2022     CRM-619 - as part of the Code Refatroring for Salesfroce Code Analyzer
 */

global without sharing class CaseInvocableHandler {
    /*An invocable variable used as input*/
     /**
    * @description : CaseEmailRequest
    * @author : Kevin Snell
    **/
    global class CaseEmailRequest {
        @InvocableVariable(required=true)
        global ID caseId;
        
        @InvocableVariable(required=true)
        global String emailAddress;
        
        @InvocableVariable(required=true)
        global ID templateId;
        
        @InvocableVariable(required=true)
        global String orgWideEmailAddress ;
    }
     /**
    * @description  : Invocable Mehtod called from FLOW to send the email.
    * @author :Kevin Snell
    * @param requests 
    **/
    @InvocableMethod(label='Send Case Email' description='method description')
    global static void caseemailList(List<caseemailRequest> requests){
        try{
            //Get the Org Wide Email Address
            OrgWideEmailAddress owa = [SELECT id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = :requests[0].OrgWideEmailAddress WITH SECURITY_ENFORCED LIMIT 1];
            
            //Get TemplateID
            //EmailTemplate template = [Select id from EmailTemplate where id = :requests[0].TemplateId WITH SECURITY_ENFORCED LIMIT 1];
            List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
            List<String> toAddressList = new List<String>();
            
            for (Case c: [Select Id, AccountId , Person_Account_Email__c from Case where Id = :requests[0].CaseId WITH SECURITY_ENFORCED LIMIT 1]) {
                
                if (requests[0].EmailAddress != null) {
                    toAddressList.add(requests[0].EmailAddress);
                    //Template, WhoId, WhatId
                    Messaging.SingleEmailMessage mail =  Messaging.renderStoredEmailTemplate(requests[0].TemplateId, null, c.Id);
                    //mail.setToAddresses(new String[]{c.Person_Account_Email__c});
                    mail.toAddresses = toAddressList;
                    mail.setBccSender(false); 
                    mail.setUseSignature(false);
                    //assign org wide email address as the from address
                    mail.setOrgWideEmailAddressId(owa.Id);
                    //create a task record
                    mail.setSaveAsActivity(true); 
                    lstMsgs.add(mail);
                }
            }
            if (lstMsgs.size() >0 ) {
                Messaging.reserveSingleEmailCapacity(5);
                //Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMsgs);
            }
        }
        catch(Exception e) {
            CustomException.logException(e);
        }
    }
}