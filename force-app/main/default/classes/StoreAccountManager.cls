/**
 * @Project : Primark
 * @Author  : Devendra Villa
 * @Date    : 15/05/2023
 * @description : StoreAccountManager WebService class to upsert Store Accounts using Store ID from CRM I
 * ************************************************************************************************
 */
@RestResource(urlmapping='/storemanager/')
global without sharing class StoreAccountManager {
    private static final String METADATA_RECORD_NAME = 'Azure_Storefront';
    private static final Integer STATUS_CODE_CREATED = 201;
    private static final Integer STATUS_CODE_BAD_REQUEST = 500;
    private static final Integer STATUS_CODE_INVALID_REQUEST = 400;
    private static final String STATUS_MESSAGE_CODE_CREATED = 'SUCCESS';
    private static final String STATUS_MESSAGE_CODE_BAD_REQUEST = 'BAD_REQUEST';
    private static final String STATUS_MESSAGE_CODE_BAD_LOCALE = 'BAD_LOCALE_MISSING_OR_INCORRECT';
    private static final String STATUS_MESSAGE_CODE_INVALID_REQUEST = 'INVALID_REQUEST';
    private static final String STATUS_MESSAGE_CODE_INVALID_ID = 'INVALID_ID';
    private static String STATUS_MESSAGE_CODE_ERROR = '';

    /**
    * @description put Method for the API,upsert Store Account using Store Id from Request param
    * @author  Devendra Villa
    * @param  storeInformation storeInformation
    * @return  null
    **/
    @httpPut
    global static void doUpsertAccount(StoreInformation storeInformation){
        CustomException.LogRequestWrapper logRequest;
        try{
            Account acc = StoreInformation.storeAccount;
            logRequest = new CustomException.LogRequestWrapper(RestContext.request, 'StoreAccountManager', JSON.serialize(acc)  );
            //CustomException.logRequestRecord(logRequest);
            if(storeLocaleCheck(acc.Store_Locale__c)){
                if(acc.Store_Id__c != null  ){
            acc.Store_Name__c= acc.Name+' '+ acc.Store_Id__c;
            acc.City__c = acc.BillingCity;
            acc.Store_Locale_ID__c = acc.Store_Id__c+'#'+ acc.Store_Locale__c;
            acc.Display_Address__c = !String.isBlank(acc.BillingStreet) ? acc.BillingStreet : '';
            acc.Display_Address__c += !String.isBlank(acc.BillingCity) ? '\n'+acc.BillingCity : '';
            acc.Display_Address__c += !String.isBlank(acc.BillingState) ? '\n'+acc.BillingState : '';
            acc.Display_Address__c += !String.isBlank(acc.BillingPostalCode) ? '\n'+acc.BillingPostalCode : '';
            acc.Display_Address__c += !String.isBlank(acc.BillingCountry) ? '\n'+acc.BillingCountry : '';
            acc.Active_Store__c = !(acc.Active_Store__c);
            upsert acc Store_Locale_ID__c;
            Account acc2 = [Select Id,Store_Locale_ID__c From Account Where Store_Locale_ID__c=:acc.Store_Locale_ID__c WITH SECURITY_ENFORCED LIMIT 1];      
            RestContext.response.statusCode = STATUS_CODE_CREATED;
            CustomSalesforceResponse res = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_CREATED, JSON.serialize(acc2));
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
            //responseLogging(RestContext.response);
            responseLogging(logRequest , RestContext.response);
                }
                else{
                    RestContext.response.statusCode = STATUS_CODE_INVALID_REQUEST;
                    CustomSalesforceResponse res = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_INVALID_ID, JSON.serialize(acc));
                    RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
                    //responseLogging(RestContext.response);
                    responseLogging(logRequest , RestContext.response);
                    }
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
            CustomSalesforceResponse errs = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_BAD_REQUEST,e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(errs));
            //responseLogging(RestContext.response);
            CustomException.logRequestExceptionRecords(logRequest, e);
        } 
        catch(Exception e) {
           // CustomException.logException(e);
            
            RestContext.response.statusCode = STATUS_CODE_INVALID_REQUEST;
            CustomSalesforceResponse errs = new CustomSalesforceResponse(STATUS_MESSAGE_CODE_INVALID_REQUEST,e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(errs));
            //responseLogging(RestContext.response);
            CustomException.logRequestExceptionRecords(logRequest, e);      
        }
          
    }
    /**
    * @description Wrapper Class to hold the store acocunt record.
    * @author Devendra Villa
    **/
    global class StoreInformation {
        
        public Account storeAccount { get; set; }
        
    }
    /**
    * @description Wrapper Class to return the custom response.
    * @author  Devendra Villa
    **/
    global class CustomSalesforceResponse {
        public String responseCode;
        public String message;
        
        public CustomSalesforceResponse(String responseCode, string message){
            this.responseCode = responseCode;
            this.message = message;
        }
    }

    /**
   * @description Method to Check the Store locale is correct or not.
   * @author Devendra Villa
   * @param String locale
   * @return Boolean
   **/
    private static Boolean storeLocaleCheck(String locale){
        List<Language_Code_Mapping__mdt> lang  = [SELECT Id,Label FROM Language_Code_Mapping__mdt WHERE Label = :locale WITH SECURITY_ENFORCED LIMIT 1];
        if(String.IsNotBlank(locale) && lang!=null && !lang.isEmpty()){
            return true;
        }
        else{
            STATUS_MESSAGE_CODE_ERROR = STATUS_MESSAGE_CODE_BAD_LOCALE;
            return false;
        }
    }

    private static void responseLogging(CustomException.LogRequestWrapper logRequest, RestResponse res){
        CustomException.LogResponseWrapper logResponse = new CustomException.LogResponseWrapper(res, 'StoreAccountManager');
           // CustomException.logResponseRecord(logResponse);
           CustomException.logRequestResponseRecords(logRequest, logResponse);
    }
}