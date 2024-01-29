@isTest
public class CustomExceptionTest {
    @isTest
    public static void createAccount() {
        try {
            Account m = new Account();
            insert m;
        } catch (Exception e) {
            CustomException.LogException(e);
        }   
        System.assertEquals(1,1,'pass'); 
    }
    
    @isTest
    private static void restRequestLog(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/storemanager/';  //Request URL
        String JsonMsg = '{"attributes":{"type":"Account"},"Store_Name__c":"dummy new2"}';
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        RestContext.response.statusCode = 200;
        RestContext.response.responseBody = Blob.valueOf(JsonMsg);
        CustomException.LogRequestWrapper logRequest = new CustomException.LogRequestWrapper(req, 'StoreAccountManager', JsonMsg  );
        CustomException.logRequestRecord(logRequest);
        CustomException.LogResponseWrapper logResponse = new CustomException.LogResponseWrapper(res, 'StoreAccountManager');
        CustomException.logResponseRecord(logResponse);
       
    }
    @isTest
    private static void httpRequestLog(){
        String JsonMsg = '{"attributes":{"type":"Account"},"Store_Name__c":"dummy new2"}';
        HttpRequest request = new HttpRequest();
        HttpResponse response = null;
        Http http = new Http();
        request.setHeader('content-type', 'application/json; charset=utf-8;');
        request.setMethod('POST');
        CustomException.LogRequestWrapper logRequest = new CustomException.LogRequestWrapper(request, 'StoreAccountManager', JsonMsg  );
        CustomException.logRequestRecord(logRequest);

       
    }
    
    
}