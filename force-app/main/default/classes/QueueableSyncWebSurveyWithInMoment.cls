/** 
    * @Project:    Primark
    * @Date:        14/03/2022
    * @Author     :  Anshul Sharma
    * @description: Queueable class to sync Web Surveys data with Salesforce, Integration with InMoment, preparing request_url, send http request to fetch data 
    *************************************************************************************************************************************************
    * Date          Name                    Comments
    * * *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  
    * 13-Sep-22     Nitin Nayan (EPAM)      OSCWEB-21806 - Added beginTime in the wraaper class & update it in the lead.  
    * 19-Sep-22     Tanya Jain (EPAM)       OSCWEB-11474 - Added Locale field in the Lead 
    * 26-DEC-22     Devendra Villa(EPAM)    CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
    */
    public class QueueableSyncWebSurveyWithInMoment implements Queueable, Database.AllowsCallouts {
        final String metadataRecordName = 'InMoment_Survey_Request';
        final String requestTypePost = 'POST';
        final String requestTypeGet = 'GET';
        final String grantType = 'password';
        final Integer surveydetailBatchSize = 100;
        
        String clientId;
        String clientSecret;
        String username;
        String password;
        String orgId;
        String authorizeEndPointURL;
        String surveyIdEndPointURL;
        String surveyDetailEndPointURL;
    
        public static List<CustomException__c> reqResLogs = new List<CustomException__c>();
    
        /**
        * @description  : Get Metadata 
        * @author       : Anshul Sharma
        **/
        public QueueableSyncWebSurveyWithInMoment() {
            clientId = InMoment_Setting__mdt.getInstance(metadataRecordName).Client_Id__c;
            clientSecret = InMoment_Setting__mdt.getInstance(metadataRecordName).Client_Secret__c;
            username = InMoment_Setting__mdt.getInstance(metadataRecordName).Username__c;
            password = InMoment_Setting__mdt.getInstance(metadataRecordName).Password__c;
            orgId = InMoment_Setting__mdt.getInstance(metadataRecordName).Org_Id__c;
            authorizeEndPointURL = InMoment_Setting__mdt.getInstance(metadataRecordName).Authorize_End_Point__c;
            surveyIdEndPointURL = InMoment_Setting__mdt.getInstance(metadataRecordName).Survey_Id_End_Point__c;
            surveyDetailEndPointURL = InMoment_Setting__mdt.getInstance(metadataRecordName).Survey_Detail_End_Point__c;
        }
        /**
    
        * @description  : Calling function which called from all the other apex classes from the catch block
    
        * @author       : Anshul Sharma
        * @param  qc to get the queueableContext
        **/
        public void execute(QueueableContext qc) {
            List<Lead> leadRecords = new List<Lead>();
            List<String> surveyIdsBatch = new List<String>();
            //To fetch access token
            HttpRequest tokenRequest = prepareRequestToGetAccessToken();
            HTTPResponse httpResponse = new HTTPResponse();
            try {
                httpResponse = sendHTTPRequest(tokenRequest);
                if (httpResponse != null && !String.isBlank(httpResponse.getBody())) {
                TokenResponseWrapper tokenWrapper = parseTokenResponse(httpResponse.getBody());
                
                    //To fetch submitted Survey Response Ids for given time duration
                    if (tokenWrapper != null && !String.isBlank(tokenWrapper.access_token)) {
                        HttpRequest surveyIdsRequest = prepareRequestToGetSurveyIds(tokenWrapper.access_token);
                        
                        httpResponse = new HTTPResponse();
                        httpResponse = sendHTTPRequest(surveyIdsRequest);
    
                        //To fetch Survey Response Details for given survey response Ids in chunk
                        if (httpResponse != null && !String.isBlank(httpResponse.getBody())) {
                            surveyIdsBatch = chunkSurveyIdsStringInBatch(httpResponse.getBody());
                            InMomentSurveyBatch inMoment = new InMomentSurveyBatch(surveyIdsBatch,tokenWrapper.access_token,surveyDetailEndPointURL);
                            Database.executeBatch(inMoment, 1);
                        }
                    }
                }
            //Storing into CRM as Leads
            INSERT reqResLogs;
               
            } catch (Exception e) {
                UPSERT reqResLogs;
                CustomException.logException(e);
            }
        }
        
        //Method: To prepare http request object to get access token using secure credentials
        //End point URL and credentials have been stored in Custom Metadata
        //Output: This Http Request object will fetch access token 
        private HttpRequest prepareRequestToGetAccessToken() {
            String tokenRequestBody = 'client_id='+EncodingUtil.urlEncode(clientId,'UTF-8')+'&client_secret='+EncodingUtil.urlEncode(clientSecret,'UTF-8')+'&username='+EncodingUtil.urlEncode(username,'UTF-8')+'&password='+EncodingUtil.urlEncode(password,'UTF-8')+'&grant_type='+grantType;
            HttpRequest tokenRequest = new HttpRequest();
            tokenRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            tokenRequest.setEndpoint(authorizeEndPointURL);
            tokenRequest.setMethod(requestTypePost);
            tokenRequest.setBody(tokenRequestBody);
            return tokenRequest;
        }
        
        //Method: To prepare http request object to get Survey response Ids
        //Input: Previously fetched access token to make API call
        //Output: This will fetch Survey response Ids for the time duration i.e. Yesterday 
        private HttpRequest prepareRequestToGetSurveyIds(String token) {
            String startEndDate = getStartEndDateStringToFetchSurveyId();
            HttpRequest tokenRequest = new HttpRequest();
            tokenRequest.setHeader('authorization', ('Bearer ' + token));
            tokenRequest.setEndpoint(surveyIdEndPointURL + '/' +startEndDate+ '/' + orgId);
            tokenRequest.setMethod(requestTypeGet);
            return tokenRequest;
        }
        
        
        //Method: To get start and end date range in string to be passed as time duration to fetch Survey ids from InMoment
        //Here getting the class id by passing the name of class
        //Then getting the last batch completed dateTime for this class
        //Formatting the datetime as per required by InMoment http request URL
        //If Batch is scheduled for daily or weekly then this logic will fetch the last run datetime as start date and system.now() will be the end date
        //If Batch is getting executed first time then Start Date will be Yesterday
        //Output: This will return the start-end dateTime string for InMoment end point URL 
        private String getStartEndDateStringToFetchSurveyId(){
            AsyncapexJob asynJobObj;
            try {
                ApexClass apexClassObj = [SELECT Id FROM ApexClass WHERE Name = 'QueueableSyncWebSurveyWithInMoment'];
                if(!Test.isRunningTest()){
                    asynJobObj = [SELECT CompletedDate FROM AsyncapexJob Where ApexClassId =:apexClassObj.Id And CompletedDate !=null order by CompletedDate desc limit 1];
                }
                
            } catch (Exception e) {
                CustomException.logException(e);
                //Exception will occur if there is no batch ran earlier so just handling the exception and put yesterday as start date below
            }
            String startDate;
            if (asynJobObj != null && asynJobObj.CompletedDate != null) {
                startDate = asynJobObj.CompletedDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
            } else {
                startDate = (String.valueOf(Date.today()-1) + 'T00:00:00');
            }
            Datetime dt = System.now();
            String endDate = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
            return (startDate + '/' + endDate);
            //return ('2022-06-26T00:00:00' + '/' + '2022-06-28T00:00:00'); 
        }
        
        //Method: To send the Http Request
        //Input: Http Request object
        //Output: This will return the Http Response 
        private HTTPResponse sendHTTPRequest(HttpRequest httpRequest){
            Http http = new Http();
            HTTPResponse httpResponse = http.send(httpRequest);
            reqResLogs.add(logRequest(httpRequest));
            reqResLogs.add(logResponse(httpResponse));
            return httpResponse;
        }
        
        //Method: To parse the http response to get access token
        //Input: Http Response body containing Authorization details
        //Output: This will return TokenResponseWrapper contains AccessToken 
        private TokenResponseWrapper parseTokenResponse(String responseBody){
            System.debug('Token REsponse IN-->'+responseBody);
            TokenResponseWrapper tokenWrapper = (TokenResponseWrapper) JSON.deserialize(responseBody, TokenResponseWrapper.class);
            System.debug('Token REsponse IN 2-->'+tokenWrapper);
            System.debug('Token REsponse IN 3-->'+tokenWrapper.access_token);
            return tokenWrapper;
        }
        
        //Method: To chunk the Survey Response Ids into InMoment allowed batch size of 100
        //Input: Http Response body containing Survey Response Ids
        //Output: This will return List of chunked ids string 
        private List<String> chunkSurveyIdsStringInBatch(String responseBody) { 
            List<String> surveyIdsBatch = new List<String>();
            Integer idCountForBatch = 0;
            String idsString = '';
            boolean addBracket = false;
            for(String s1 : responseBody.split(',')) {
                if (addBracket) {
                    idsString += '[';
                    addBracket = false;
                }
                idsString += s1+',';
                idCountForBatch ++;
                if (idCountForBatch == surveydetailBatchSize) {
                    surveyIdsBatch.add(idsString.substring(0, idsString.length()-1)+']');
                    idsString = '';
                    idCountForBatch = 0;
                    addBracket = true;
                }
            }
            if (!String.isBlank(idsString)){
                surveyIdsBatch.add(idsString.substring(0, idsString.length()-1));
            }
            
            return surveyIdsBatch;
        }
    
        public static CustomException__c logRequest(HttpRequest req){
            CustomException__c exc = new CustomException__c();
            exc.ClassName__c = 'QueueableSyncWebSurveyWithInMoment';
            exc.Type__c='Request';
            if(req.getBody().length() < 32766){
                exc.Request_Body__c= req.getBody();
            }
            else{
            exc.Request_Body__c=limitBody(req.getBody());
            }
            exc.MethodName__c = req.getMethod();
            exc.Object_Name__c='Account';
            return exc;
        }
        
        public static CustomException__c logResponse(HttpResponse res){
            CustomException__c exc = new CustomException__c();
            exc.ClassName__c = 'QueueableSyncWebSurveyWithInMoment';
            exc.Type__c='Response';
            exc.Status_Code__c=String.valueOf(res.getStatusCode());
            if(res.getBody().length() < 32766){
                exc.Response_Body__c= res.getBody();
            }
            else{
            exc.Response_Body__c=limitBody(res.getBody());   
            }
            exc.Object_Name__c='Account';
            return exc;
            
        }
        
        private class TokenResponseWrapper {
            public String access_token;
        }
        
       
    public static String limitBody(String inputBody){
        return inputBody.left(32766);
    }
    }