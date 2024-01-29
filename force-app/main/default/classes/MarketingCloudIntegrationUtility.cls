/** 
    * @Project:   Primark
    * @Date:        12/06/2023
    * @Author:  Nitin K Nayan
    * @description : Marketing Cloud Integration DIGIX-2506 for GDPR Deletion of Leads/PersonAccounts
    * ************************************************************************************************
    * Name                       Date            Comments
    * 
    */
public without sharing class MarketingCloudIntegrationUtility {

    public static Marketing_Cloud_REST_API_Config__c mySetting = Marketing_Cloud_REST_API_Config__c.getInstance();
    public static String clientId = mySetting.ClientId__c;
    public static String clientSecret = mySetting.Client_Secret__c;
    public static String externalKey = mySetting.Data_Extension_Key__c;
    public static String jsonBody = GetAccessTokenJsonBody(clientId, clientSecret).getAsString();
    public static String authURL = mySetting.Auth_URL__c;
    public static String postURL = mySetting.Post_URL__c;
    public static String accessToken;
    private static List<CustomException__c> reqResLogs = new List<CustomException__c>();


     /**
    * @description  : Get Access Token From MC
    * @author       : Nitin K Nayan
    * @param        : null
    **/
    public static void getAccessToken() {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(authURL);
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        req.setBody(jsonBody);
        HttpResponse res = h.send(req);
        String responseBody = res.getBody();
        System.debug('responseBody---' + responseBody);
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.debug('access Token'+result.get('access_token').toString());
        if (res.getStatusCode() == 200) {
            accessToken = 'Bearer ' + result.get('access_token').toString();
        }
        reqResLogs.add(logRequestResponse(req,res));
        
    }

    /**
    * @description  : Send the request & this method is called from Account and Lead Batch anonymisation
    * @author       : Nitin K Nayan
    * @param        : Map<Id,String> subscriberIdEmailMap (Lead/PersonAccountId with Email)
    **/
    
    public static void sendRequestForMarketing(Map<Id,String> subscriberIdEmailMap){
        HttpRequest req;
        try{
            getAccessToken();
            if(String.isNotBlank(accessToken) && subscriberIdEmailMap!=null && !subscriberIdEmailMap.isEmpty()){
                Http h = new Http();
                req = new HttpRequest();
                String endpoint = postURL+'key:'+externalKey+'/rows';
                req.setEndpoint(endpoint);
                req.setHeader('Authorization', accessToken);
                req.setHeader('Content-Type','application/json');
                req.setMethod('POST');
                req.setBody(generateJSON(subscriberIdEmailMap));
                HttpResponse res = h.send(req);
                String responseBody = res.getBody();
                System.debug('responseBody---' + responseBody);
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                System.debug('result---' + result);
                if (res.getStatusCode() == 200) {
                    
                }
                reqResLogs.add(logRequestResponse(req, res));
                if(reqResLogs.size()>0){
                    UPSERT reqResLogs;
                }

            }
        }catch(Exception e){
            UPSERT reqResLogs;
            CustomException.logException(e);
        }
        
    }
    /**
    * @description  : Send the request & this method is called from the Account & Lead Trigger Handler (ASYNC)
    * @author       : Nitin K Nayan
    * @param        : Map<Id,String> subscriberIdEmailMap (Lead/PersonAccountId with Email)
    **/
    @future(callout=true)
    public static void sendRequest(Map<Id,String> subscriberIdEmailMap){
        sendRequestForMarketing(subscriberIdEmailMap);
    }
    
    /**
    * @description  : Create a JSON Body for the POST Request to Add records in the DataExtenion on MC
    * @author       : Nitin K Nayan
    * @param        : Map<Id,String> subscriberIdEmailMap (Lead/PersonAccountId with Email)
    **/
    public static String generateJSON(Map<Id,String> subscriberIdEmailMap) {
        // Create a JSONGenerator instance
        JSONGenerator gen = JSON.createGenerator(true);
        
        // Start the JSON structure
        gen.writeStartObject();
        
        // Write the "items" field
        gen.writeFieldName('items');
        
        // Start the items array
        gen.writeStartArray();
        
        for(Id subId : subscriberIdEmailMap.keySet()){
            // Start the item object
            gen.writeStartObject();
            
            // Write the "SubscriberKey" field
            gen.writeStringField('SubscriberKey', subId);
            
            // Write the "Email" field
            gen.writeStringField('Email', subscriberIdEmailMap.get(subId));
            
            // End the item object
            gen.writeEndObject();
        }
        
        
        // End the items array
        gen.writeEndArray();
        
        // End the JSON structure
        gen.writeEndObject();
        
        // Get the generated JSON string
        String jsonString = gen.getAsString();
        
        // Return the JSON string
        return jsonString;
    }
    
    /**
    * @description  : Create a JSON Body for the Atuthentication to MC
    * @author       : Nitin K Nayan
    * @param        : Client Id & Secret
    **/
    public static JSONGenerator GetAccessTokenJsonBody(String clientID, String clientSecret) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('grant_type', 'client_credentials');
        gen.writeStringField('client_id', clientID);
        gen.writeStringField('client_secret', clientSecret);
        gen.writeEndObject();
        return gen;
    }
    public static CustomException__c logRequestResponse(HttpRequest req, HttpResponse res){
        CustomException__c exc = new CustomException__c();
        exc.ClassName__c = 'MarketingCloudIntegrationUtility';
        if(req.getBody().length() < 32766){
            exc.Request_Body__c= req.getBody();
        }
        else{
        exc.Request_Body__c=limitBody(req.getBody());
        }
        exc.Status_Code__c=String.valueOf(res.getStatusCode());
        if(res.getBody().length() < 32766){
            exc.Response_Body__c= res.getBody();
        }
        else{
        exc.Response_Body__c=limitBody(res.getBody());   
        }
        exc.MethodName__c = req.getMethod();
        exc.Object_Name__c='Account_Lead';
        return exc;
    }
    

    public static String limitBody(String inputBody){
        return inputBody.left(32766);
    }
    
   

}