/**
 * @Project : Primark
 * @Author  : Anshul Sharma
 * @Date    : 04/03/2022
 * @description : StorefrontAccountManager WebService class to insert, update and retrieve Person Account using UID and Email
 * ************************************************************************************************
 * Name                     Date            Comments
 * Nitin K Nayan (EPAM)     28-NOV-2022     Updaetd the whole class for the Multi-Territory Implemantaion
 * Nitin K Nayan (EPAM)     26-DEC-2022     CRM-619 - as part of the Code Refatroring for Salesfroce Code Analyzer
 * TANYA (EPAM)             24-JUL-2023     DIGIX-3477 - as a part of Date_of_Birth__c field.
 * Nitin K Nayan (EPAM)     27-OCT-2023     DIGIX-4149 - New Account Shoulbe be created after Anonymization
 */
@RestResource(urlmapping='/accountmanager/')
global without sharing class StorefrontAccountManager {
    private static final String METADATA_RECORD_NAME = 'Azure_Storefront';
    private static final Integer STATUS_CODE_OKAY = 200; 
    private static final Integer STATUS_CODE_CREATED = 201;
    private static final Integer STATUS_CODE_INVALID_REQUEST = 400;
    private static final Integer STATUS_CODE_NOT_FOUND = 404;
    private static final Integer STATUS_CODE_BAD_REQUEST = 500;
    private static final String STATUS_MESSAGE_CODE_OKAY = 'SUCCESS';
    private static final String STATUS_MESSAGE_CODE_CREATED = 'CREATED';
    private static final String STATUS_MESSAGE_CODE_INVALID_REQUEST = 'INVALID_REQUEST';
    private static final String STATUS_MESSAGE_CODE_NOT_FOUND = 'NOT_FOUND';
    private static final String STATUS_MESSAGE_CODE_BAD_REQUEST = 'BAD_REQUEST';
    private static final String STATUS_MESSAGE_CODE_BAD_LOCALE = 'BAD_LOCALE_MISSING_OR_INCORRECT';
    private static final String STATUS_MESSAGE_CODE_INVALID_UID = 'INVALID_UID';
    private static final String STATUS_MESSAGE_NOT_FOUND_MSG ='No Record found for ' ;

    private static final String STATUS_MESSAGE_CODE_BAD_API_OPERATION = 'MISSING_OR_BAD_API_OPERATION';
    private static final String API_OPERATION_SIGN_IN = 'SIGN_IN';
    private static final String API_OPERATION_PROFILE_UPDATE = 'PROFILE_UPDATE';
    private static final String API_OPERATION_MARKETING_OPTIN_UPDATE = 'MKT_OPTIN_UPDATE';
    private static final String API_OPERATION_EMAIL_OPTOUT_UPDATE = 'EMAIL_OPTOUT_UPDATE';
    private static String STATUS_MESSAGE_CODE_ERROR = '';

    
    /**
    * @description Get Method for the API,Retrieve Person Account using UID from Request param
    * @author 
    * @return  Account record with the given UID
    **/
    @httpGet
    global static void doGetAccount() {
        CustomException.LogRequestWrapper logRequest;
        try {
            String uid = RestContext.request.params.get('Key');
            String uidValue;
            String emailValue;
            Account[] acc;
            if(uid == 'uid'){
                uidValue = RestContext.request.params.get('Value');
                acc = [Select Id,Is_Anonymised__c,Last_Activity_Date__c, FirstName, LastName, PersonEmail,PersonContactId,Selected_Store__c, Phone,UID__c,Billing_Addresses__c,Payment_Methods__c,Date_of_Birth__c,Mens__c,Womens__c,Collections__c,Baby__c,Beauty__c,Disney__c,Home__c,Kids__c,Consent_For_Age__pc,Marketing_Communication_Opt_in__pc,Preferred_Store__pc,Opted_Out_Date__c,Opted_Out_Source__c,PersonHasOptedOutOfEmail,(SELECT Id, Country__c,Locale__c,Marketing_Communication_Opt_in__c,Marketing_Communication_Opt_in_Source__c,Marketing_Communication_Opt_in_Date__c,Email_Opt_out__c,Email_Opt_out_Date__c,Email_Opt_Out_Source__c,Preferred_Store__c,Verified_Opt_in__c,Verified_Opt_in_Date__c,Verified_Opt_in_Trigger__c from Individuals__r) From Account Where UID__c=:uidValue AND Is_Anonymised__c = false WITH SECURITY_ENFORCED LIMIT 1];
            }else if(uid == 'email'){
                emailValue = RestContext.request.params.get('Value');
                acc = [Select Id, Is_Anonymised__c,Last_Activity_Date__c,FirstName, LastName, PersonEmail,PersonContactId,Selected_Store__c, Phone,UID__c,Billing_Addresses__c,Payment_Methods__c, Date_of_Birth__c,Mens__c,Womens__c,Collections__c,Baby__c,Beauty__c,Disney__c,Home__c,Kids__c,Consent_For_Age__pc,Marketing_Communication_Opt_in__pc,Preferred_Store__pc,Opted_Out_Date__c,Opted_Out_Source__c,PersonHasOptedOutOfEmail,(SELECT Id, Country__c,Locale__c,Marketing_Communication_Opt_in__c,Marketing_Communication_Opt_in_Source__c,Marketing_Communication_Opt_in_Date__c,Email_Opt_out__c,Email_Opt_out_Date__c,Email_Opt_Out_Source__c,Preferred_Store__c,Verified_Opt_in__c,Verified_Opt_in_Date__c,Verified_Opt_in_Trigger__c from Individuals__r) From Account Where PersonEmail=:emailValue AND Is_Anonymised__c = false WITH SECURITY_ENFORCED LIMIT 1];
            
            }
            if(acc.size()> 0){
            logRequest = new CustomException.LogRequestWrapper(RestContext.request, 'StorefrontAccountManager', JSON.serialize(acc[0])  );
            //CustomException.logRequestRecord(logRequest);
            
            RestContext.response.statusCode = STATUS_CODE_OKAY;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(acc[0]));
           // responseLogging(RestContext.response);
           responseLogging(logRequest , RestContext.response);    
            }
            else{
                logRequest = new CustomException.LogRequestWrapper(RestContext.request, 'StorefrontAccountManager', uid  );
            //CustomException.logRequestRecord(logRequest);
            
            RestContext.response.statusCode = STATUS_CODE_NOT_FOUND;
            CustomSalesforceResponse errs = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_NOT_FOUND, STATUS_MESSAGE_NOT_FOUND_MSG + RestContext.request.params.get('Value'));
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(errs));
           // responseLogging(RestContext.response);
           responseLogging(logRequest , RestContext.response); 

            }
            
            
        }  catch(Exception e) {
           CustomException.logException(e);
            RestContext.response.statusCode = STATUS_CODE_BAD_REQUEST;
            CustomSalesforceResponse errs = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_BAD_REQUEST, e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(errs));
           // responseLogging(RestContext.response);
          
        }
    }

    /**
    * @description Post Method to Create Person Account using account information passed in request param
    * @author 
    * @param XML Request to be mapped into accountInformation
    * @return  Account record along with the status code with the given Email
    **/
    @httpPost
    global static void doCreateAccount(AccountInformation accountInformation) {
        CustomException.LogRequestWrapper logRequest;
        try {

                Account acc = accountInformation.accountInfo;
                logRequest = new CustomException.LogRequestWrapper(RestContext.request, 'StorefrontAccountManager', JSON.serialize(acc)  );
               // CustomException.logRequestRecord(logRequest);
                 if(localeCheck(acc.Country__pc)){
                    //insert acc; REMOVED AS PART OF THE CODE REFACTROING.
                    //Added as part of the CODE REFACTORING. 
                    DML_CRUDEnforce_Utility.dmlInsert(new List<Account>{acc});

                    Account acc2 = [Select Id,Is_Anonymised__c,Last_Activity_Date__c, FirstName, LastName, PersonEmail,PersonContactId,Selected_Store__c, Phone,UID__c,Billing_Addresses__c,Payment_Methods__c,Date_of_Birth__c,Mens__c,Womens__c,Collections__c,Baby__c,Beauty__c,Disney__c,Home__c,Kids__c,Consent_For_Age__pc,Marketing_Communication_Opt_in__pc,Preferred_Store__pc,Opted_Out_Date__c,Opted_Out_Source__c,PersonHasOptedOutOfEmail,(SELECT Id, Country__c,Locale__c,Marketing_Communication_Opt_in__c,Marketing_Communication_Opt_in_Source__c,Marketing_Communication_Opt_in_Date__c,Email_Opt_out__c,Email_Opt_out_Date__c,Email_Opt_Out_Source__c,Preferred_Store__c,Verified_Opt_in__c,Verified_Opt_in_Date__c,Verified_Opt_in_Trigger__c from Individuals__r) From Account Where PersonEmail=:acc.PersonEmail AND Is_Anonymised__c = false WITH SECURITY_ENFORCED LIMIT 1];

                    RestContext.response.statusCode = STATUS_CODE_CREATED;
                    CustomSalesforceResponse res = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_CREATED, JSON.serialize(acc2));
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
                    //responseLogging(RestContext.response);
                    responseLogging(logRequest , RestContext.response);
                }
                else{
                    RestContext.response.statusCode = STATUS_CODE_BAD_REQUEST;
                    CustomSalesforceResponse res = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_BAD_LOCALE, JSON.serialize(acc));
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
                    //responseLogging(RestContext.response); 
                    responseLogging(logRequest , RestContext.response);  
                  }
      }
        catch(System.DmlException e) {
            //CustomException.logException(e);
            
            RestContext.response.statusCode = STATUS_CODE_BAD_REQUEST;
            CustomSalesforceResponse errs = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_BAD_REQUEST, e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(errs));
            //responseLogging(RestContext.response);
            CustomException.logRequestExceptionRecords(logRequest, e);
        }
         catch(Exception e) {
           // CustomException.logException(e);
            
            RestContext.response.statusCode = STATUS_CODE_INVALID_REQUEST;
            CustomSalesforceResponse errs = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_INVALID_REQUEST, e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(errs));
            //responseLogging(RestContext.response);
            CustomException.logRequestExceptionRecords(logRequest, e);
        }
    }
    
    /**
    * @description Patch Method to Update Person Account using account information passed in request param
    * @author 
    * @param XML Request to be mapped into accountInformation get set
    * @return  Account record along with the status code with the given Email
    **/
    @httpPatch
    global static void doUpdateAccount(AccountInformation accountInformation){
        CustomException.LogRequestWrapper logRequest;
        try {
            Account acc = accountInformation.accountInfo;
            logRequest = new CustomException.LogRequestWrapper(RestContext.request, 'StorefrontAccountManager', JSON.serialize(acc)  );
            //CustomException.logRequestRecord(logRequest);
            if(localeCheck(acc.Country__pc) && apiOperation(acc.API_Operation__c)){
                List<Account> accDB = [Select Id,Is_Anonymised__c,Last_Activity_Date__c, FirstName, LastName, PersonEmail,PersonContactId,Selected_Store__c, Phone,UID__c,Billing_Addresses__c,Payment_Methods__c,Date_of_Birth__c,Mens__c,Womens__c,Collections__c,Baby__c,Beauty__c,Disney__c,Home__c,Kids__c,Consent_For_Age__pc,Marketing_Communication_Opt_in__pc,Preferred_Store__pc,Opted_Out_Date__c,Opted_Out_Source__c,PersonHasOptedOutOfEmail From Account Where UID__C=:acc.UID__c AND Is_Anonymised__c = false WITH SECURITY_ENFORCED Limit 1];
                if(accDB != null && !accDB.isEmpty()){
                    acc.Id = accDB[0].Id;
                    //UPDATE acc; REMOVED AS PART OF THE CODE REFACTROING.
                    //Added as part of the CODE REFACTORING. 
                    DML_CRUDEnforce_Utility.dmlUpdate(new List<Account>{acc});

                    Account updatedAcc = [Select Id,Is_Anonymised__c,Last_Activity_Date__c, FirstName, LastName, PersonEmail,PersonContactId,Selected_Store__c, Phone,UID__c,Billing_Addresses__c,Payment_Methods__c,Date_of_Birth__c,Mens__c,Womens__c,Collections__c,Baby__c,Beauty__c,Disney__c,Home__c,Kids__c,Consent_For_Age__pc,Marketing_Communication_Opt_in__pc,Preferred_Store__pc,Opted_Out_Date__c,Opted_Out_Source__c,PersonHasOptedOutOfEmail,(SELECT Id, Country__c,Locale__c,Marketing_Communication_Opt_in__c,Marketing_Communication_Opt_in_Source__c,Marketing_Communication_Opt_in_Date__c,Email_Opt_out__c,Email_Opt_out_Date__c,Email_Opt_Out_Source__c,Preferred_Store__c,Verified_Opt_in__c,Verified_Opt_in_Date__c,Verified_Opt_in_Trigger__c from Individuals__r) From Account Where UID__C=:acc.UID__c AND Is_Anonymised__c = false WITH SECURITY_ENFORCED Limit 1];
                    
                    RestContext.response.statusCode = STATUS_CODE_OKAY;
                    CustomSalesforceResponse res = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_OKAY, JSON.serialize(updatedAcc));
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
                    // CustomException.LogResponseWrapper logResponse = new CustomException.LogResponseWrapper(RestContext.response, 'StorefrontAccountManager');
                    // CustomException.logResponseRecord(logResponse);
                    responseLogging(logRequest , RestContext.response);
                }else{
                    RestContext.response.statusCode = STATUS_CODE_INVALID_REQUEST;
                    CustomSalesforceResponse res = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_INVALID_UID, JSON.serialize(acc));
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
                    // CustomException.LogResponseWrapper logResponse = new CustomException.LogResponseWrapper(RestContext.response, 'StorefrontAccountManager');
                    // CustomException.logResponseRecord(logResponse);
                    responseLogging(logRequest , RestContext.response);
                }
            }else{
                RestContext.response.statusCode = STATUS_CODE_BAD_REQUEST;
                CustomSalesforceResponse res = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_ERROR, JSON.serialize(acc));
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
                // CustomException.LogResponseWrapper logResponse = new CustomException.LogResponseWrapper(RestContext.response, 'StorefrontAccountManager');
                // CustomException.logResponseRecord(logResponse);
                responseLogging(logRequest , RestContext.response);
            }
           
        } catch(System.DmlException e) {
            //CustomException.logException(e);
            
            RestContext.response.statusCode = STATUS_CODE_BAD_REQUEST;
            CustomSalesforceResponse errs = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_BAD_REQUEST, e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(errs));
            //responseLogging(RestContext.response);    
            CustomException.logRequestExceptionRecords(logRequest, e);
   
         } 
            catch(Exception e) {
            //CustomException.logException(e);
            
            RestContext.response.statusCode = STATUS_CODE_INVALID_REQUEST;
            CustomSalesforceResponse errs = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_INVALID_REQUEST, e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(errs));
           // responseLogging(RestContext.response);
           CustomException.logRequestExceptionRecords(logRequest, e);
            }
    }
    
    /**
    * @description Wrapper Class to hold the acocunt record.
    * @author 
    **/
    global class AccountInformation {
        /**
        * @description To hold account record
        * @author Nitin K Nayan (EPAM)
        **/
        public Account accountInfo { get; set; }
    }
    
     /**
    * @description Wrapper Class to return the custom response.
    * @author 
    **/
    global class CustomSalesforceResponse {
        public String responseCode;
        public String message;
        /**
        * @description Custom Response with code & Meaasge
        * @author Nitin K Nayan (EPAM)
        **/
        public CustomSalesforceResponse(String responseCode, string message){
            this.responseCode = responseCode;
            this.message = message;
        }
    }
    

    /**
   * @description Method to Check the locale is correct or not.
   * @author Nitin K Nayan
   * @param Locale
   * @return Boolean
   **/
    private static Boolean localeCheck(String locale){
        List<Language_Code_Mapping__mdt> lang  = [SELECT Id,Label FROM Language_Code_Mapping__mdt WHERE Label = :locale WITH SECURITY_ENFORCED LIMIT 1];
        if(String.IsNotBlank(locale) && lang!=null && !lang.isEmpty()){
            return true;
        }else{
            STATUS_MESSAGE_CODE_ERROR = STATUS_MESSAGE_CODE_BAD_LOCALE;
            return false;
        }
    }

     /**
   * @description Method to Check the API Opretion is coming or not & correct or not
   * @author Nitin K Nayan
   * @param API Opreation
   * @return text
   **/
    private static Boolean apiOperation(String apiAction){
        if(String.isNotBlank(apiAction) && (apiAction == API_OPERATION_SIGN_IN || apiAction == API_OPERATION_PROFILE_UPDATE || apiAction == API_OPERATION_MARKETING_OPTIN_UPDATE || apiAction == API_OPERATION_EMAIL_OPTOUT_UPDATE)){
            return true;
        }
        else{
            STATUS_MESSAGE_CODE_ERROR = STATUS_MESSAGE_CODE_BAD_API_OPERATION;
            return false;
        }
    }

    private static void responseLogging(CustomException.LogRequestWrapper logRequest, RestResponse res){
        CustomException.LogResponseWrapper logResponse = new CustomException.LogResponseWrapper(res, 'StorefrontAccountManager');
        //CustomException.logResponseRecord(logResponse);
        CustomException.logRequestResponseRecords(logRequest, logResponse);
    }
}