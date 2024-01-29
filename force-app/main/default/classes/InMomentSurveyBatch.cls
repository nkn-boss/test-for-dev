/** 
    * @Project:    Primark
    * @Date:        06/07/2023
    * @Author     :  Nitin K Nayan
    * @description: Batch Class to sync Web Surveys data with Salesforce, Integration with InMoment, Created to handle Apex Head Limit Exception
    *************************************************************************************************************************************************
    * Date          Name                    Comments
    * * *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  
    *   
*/
public with sharing class InMomentSurveyBatch implements Database.Batchable<String>, Database.AllowsCallouts{

    private List<String> stringList;
    private List<CustomException__c> reqResLogs = new List<CustomException__c>();
    private String accessToken;
    private string surveyDetailEndPointURL;

    final String metadataRecordName = 'InMoment_Survey_Request';
    final String surveyFieldFirstName = 'First Name (Private)';
    final String surveyFieldLastName = 'Last Name (Private)';
    final String surveyFieldEmail = 'Email Address (Private)';
    final String surveyFieldCountry = 'Country (Actual)';
    final String surveyFieldLocale = 'Browser Locale'; //OSCWEB-11474
    final String requestTypePost = 'POST';
    
    public InMomentSurveyBatch(List<String> strings,String accessToken,String surveyDetailEndPointURL) {
        this.stringList = strings;
        this.accessToken = accessToken;
        this.surveyDetailEndPointURL=surveyDetailEndPointURL;
    }
    
    public Iterable<String> start(Database.BatchableContext context) {
        // Convert the list of strings into a query locator
        return stringList;
    }
    
    public void execute(Database.BatchableContext context, List<String> scope) {
        try{
            List<Lead> leadList = new List<Lead>();
            // Process each string in the scope
            //Callout in loop for chunked 100 ids string
            //Example: If 460 Surveys submitted then 460/100 5 callouts will be in loop
            //Salesforce limit 100 callouts and 2 callout is already used to get access token and survey ids
            //so total survey details to be fetched can be 98*100 maximum                 
            for (String surveyIdChunkToFetchDetail : scope) {
                
                HttpRequest surveyDetailRequest = prepareRequestToGetSurveyDetails(accessToken, surveyIdChunkToFetchDetail);
                HttpResponse httpResponse = new HTTPResponse();
                Http http = new Http();
                httpResponse = http.send(surveyDetailRequest);
                reqResLogs.add(QueueableSyncWebSurveyWithInMoment.logRequest(surveyDetailRequest));
                reqResLogs.add(QueueableSyncWebSurveyWithInMoment.logResponse(httpResponse));
                if (httpResponse != null && !String.isBlank(httpResponse.getBody())) {
                    //Parsing the Survey Response Detail and creating Lead records using FirstName, LastName, Email and City
                    leadList.addAll(parseSurveyResponse(httpResponse.getBody()));
                }
            }

            if(reqResLogs.size()>0){
                INSERT reqResLogs;
            }
            if (leadList.size() > 0) {
                LeadTriggerHandler.allowCalling = false;
                INSERT leadList;
            }
            
        }
        catch(Exception e) {
            UPSERT reqResLogs;
            CustomException.logException(e);         
        }

    }
    
    public void finish(Database.BatchableContext context) {
        // Optional: Perform any post-processing logic here
        System.debug('Batch processing finished');
    }

    //Method: To prepare http request object to get Survey response details i.e. First name, Last name, Email, Country
    //Input: Previously fetched access token to make API call
    //Output: This will fetch Survey response details using Survey response Ids 
    private HttpRequest prepareRequestToGetSurveyDetails(String token, String surveyIds) {
        HttpRequest tokenRequest = new HttpRequest();
        tokenRequest.setHeader('authorization', ('Bearer ' + token));
        tokenRequest.setHeader('Content-Type', 'application/json');
        tokenRequest.setEndpoint(surveyDetailEndPointURL);
        tokenRequest.setMethod(requestTypePost);
        tokenRequest.setBody(surveyIds);
        return tokenRequest;
    }

    //Method: To parse the http response to get Survey Response Details to store in CRM i.e.FirstName, LastName..etc to Lead
    //Input: Survey Details Http Response body
    //Output: This will return List of leads created using survey response details 
    private List<Lead> parseSurveyResponse(String responseBody){
        List<Lead> leadRecords = new List<Lead>();
        Set<String> emailList = new Set<String>();
        Lead leadRec = new Lead();
        
        List<InMomentSurveyDetailWrapper> surveyDetailWrapperList = (List<InMomentSurveyDetailWrapper>) JSON.deserialize(responseBody, List<InMomentSurveyDetailWrapper>.class);
        for (InMomentSurveyDetailWrapper surveyDetailWrapper : surveyDetailWrapperList) {
            if(surveyDetailWrapper.offerId == InMoment_Setting__mdt.getInstance(metadataRecordName).Offer_Id__c){
                leadRec = new Lead();
            leadRec.Opted_in_Status_Timestamp__c =  DateTime.valueOf(surveyDetailWrapper.beginTime.replace('T',' '));//Added for - OSCWEB-21806
            leadRec.Inmoment_Response_ID__c = surveyDetailWrapper.id;
            leadRec.Preferred_Store__c = surveyDetailWrapper.unitExternalId;
            for (SurveyAnswers surveyAns : surveyDetailWrapper.answers) {
                if(surveyAns.fieldName == surveyFieldFirstName) {
                    leadRec.FirstName = surveyAns.literalValue;
                } else if(surveyAns.fieldName == surveyFieldLastName) {
                    leadRec.LastName = surveyAns.literalValue;
                } else if(surveyAns.fieldName == surveyFieldEmail) {
                    leadRec.Email = surveyAns.literalValue;
                } else if(surveyAns.fieldName == surveyFieldCountry) {
                    leadRec.Country = surveyAns.literalValue;
                } //OSCWEB-11474 - Start
                else if(surveyAns.fieldName == surveyFieldLocale) {
                    leadRec.Locale__c = surveyAns.literalValue; 
                } //OSCWEB-11474 - end
            }
            if (!String.isBlank(leadRec.LastName) && String.isNotBlank(leadRec.Email) && ! emailList.contains(leadRec.Email)) {
                leadRec.LeadSource = 'InMoment';
                leadRec.Marketing_Communication_Opt_in__c = true;
                leadRec.Marketing_Communication_Opt_in_Source__c = 'InMoment';
                String campId = InMoment_Setting__mdt.getInstance(metadataRecordName).Campaign_ID__c;
                leadRec.Campaign_ID__c = String.isNotBlank(campId)?campId:null;
                system.debug('Lead---->'+leadRec);
                emailList.add(leadRec.Email);
                leadRecords.add(leadRec);
            }
        }
        }
        return leadRecords;
    }

    private class InMomentSurveyDetailWrapper {
        /**
        * @description  : To Get Time
        * @author       : Anshul Sharma
        * @param        : get, set
        * @return       : Field values 
        **/
        public String beginTime {get;set;} //Added for - OSCWEB-21806
        public String offerId {get;set;}
        public String unitExternalId {get;set;} //  Store Number
        public String id {get;set;}
        /**
        * @description  : To Get List
        * @author       : Anshul Sharma
        * @param        : get, set
        * @return       : List<SurveyAnswers> 
        **/
        public list<SurveyAnswers> answers{get;set;}
    }

    private class SurveyAnswers{
        /**
        * @description  : To Get Field Name
        * @author       : Anshul Sharma
        * @param        : getter, setters
        * @return       : Field values 
        **/
        public String fieldName{get;set;}
        /**
        * @description  : To Get Value
        * @author       : Anshul Sharma
        * @param        : getter, setters
        * @return       : Literal Values
        **/
        public String literalValue{get;set;}
    }
}