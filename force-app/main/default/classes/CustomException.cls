/**
 * @Project : Primark
 * @Author  : 
 * @Date    : 
 * @description : To log all the execpetions in the object on the runtime.
 * ************************************************************************************************
 * Name                         Date            Comments
 * Nitin K Nayan(EPAM)          26-DEC-22       CRM-619 - as part of the Code Refatroring for Salesfroce Code Analyzer
 */
public without sharing class CustomException extends Exception {

     /**
    * @description  : Calling function which called from all the other apex classes from the catch block
    * @author       : 
    * @param     e
    * @param     notifyEmail
    **/
    public static void logException(Exception e) {

            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.');	
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            
            CustomException__c exc = new CustomException__c();
            exc.Exception_Message__c = e.getMessage();
            exc.Exception_Type__c = e.getTypeName();
            exc.Line_Number__c = e.getLineNumber();
            exc.StackTrace__c = e.getStackTraceString();
            exc.MethodName__c = methodName;
            exc.ClassName__c = className;
            exc.Notify_Email__c = queryNotifyEmail();
            exc.Type__c='Exception';
            
            //Added as part of the CODE REFACTORING. 
            DML_CRUDEnforce_Utility.dmlInsert(new List<CustomException__c>{exc});
            
            //Database.insert(exc); REMOVED AS PART OF THE CODE REFACTROING.          
    }

    public class LogRequestWrapper {
        public String requestBody;
        public String className;
        public RestRequest  req ;
        public String methodname;
        
        public LogRequestWrapper(RestRequest req, String className, String reqBody) {
            System.debug('Request in CE' + req);
            this.requestBody = (req.requestBody != null ? req.requestBody.toString() : reqBody) ;
            this.className = className;
            this.methodName= req.httpMethod;
        }
        public LogRequestWrapper(HttpRequest req, String className, String reqBody) {
            System.debug('Request in CE' + req);
            this.requestBody = (req.getBody() != null ? req.getBody(): reqBody) ;
            this.className = className;
            this.methodName= req.getMethod();
        }
       
        public String getRequestBody() {
            return requestBody;
        }
    
        public String getClassName() {
            return className;
        }
        public String getMethodName() {
            return methodName;
        }
    }

    public class LogResponseWrapper {
        public String responseBody;
        public Integer statusCode;
        public String className;
        public RestResponse res;
        public LogResponseWrapper(RestResponse res, String className) {
            this.responseBody = res.responseBody.toString();
            this.statusCode = res.statusCode;
            this.className = className;
        }
        public LogResponseWrapper(HttpResponse res, String className) {
            this.responseBody = res.getBody();
            this.statusCode = res.getStatusCode();
            this.className = className;
        }

    
        public String getResponseBody() {
            return responseBody;
        }
    
        public Integer getStatusCode() {
            return statusCode;
        }
    
        public String getClassName() {
            return className;
        }
    }

        public static void logRequestRecord(LogRequestWrapper logRequest) {
            CustomException__c exc = new CustomException__c();
            exc.ClassName__c = logRequest.getClassName();
            exc.Type__c='Request';
            if(logRequest.getRequestBody().length() < 32766)
            {
            exc.Request_Body__c= logRequest.getRequestBody();
            }
            else{
            exc.Request_Body__c=limitBody(logRequest.getRequestBody());
            }
            exc.Object_Name__c='Account';
            exc.MethodName__c = logRequest.getMethodName();
            DML_CRUDEnforce_Utility.dmlInsert(new List<CustomException__c>{exc});
        }
    
        public static void logResponseRecord(LogResponseWrapper logResponse) {
            String responseBody = logResponse.getResponseBody();
            CustomException__c exc = new CustomException__c();
            exc.ClassName__c = logResponse.getClassName();
            exc.Type__c='Response';
            exc.Status_Code__c=String.valueOf(logResponse.getStatusCode());
            if(responseBody.length() < 32766){
            exc.Response_Body__c= responseBody;
            }
            else{
            exc.Response_Body__c=limitBody(responseBody);   
            }
            exc.Object_Name__c='Account';
            DML_CRUDEnforce_Utility.dmlInsert(new List<CustomException__c>{exc});
        }

        public static void logRequestResponseRecords(LogRequestWrapper logRequest, LogResponseWrapper logResponse){
            CustomException__c exc = new CustomException__c();
            exc.ClassName__c = logRequest.getClassName();
            if(logRequest.getRequestBody().length() < 32766)
            {
            exc.Request_Body__c= logRequest.getRequestBody();
            }
            else{
            exc.Request_Body__c=limitBody(logRequest.getRequestBody());
            }
            exc.Object_Name__c='Account';
            exc.MethodName__c = logRequest.getMethodName();
            String responseBody = logResponse.getResponseBody();
            exc.Status_Code__c=String.valueOf(logResponse.getStatusCode());
            if(responseBody.length() < 32766){
            exc.Response_Body__c= responseBody;
            }
            else{
            exc.Response_Body__c=limitBody(responseBody);   
            }
            DML_CRUDEnforce_Utility.dmlInsert(new List<CustomException__c>{exc});
        }
        public static void logRequestExceptionRecords(LogRequestWrapper logRequest, Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.');	
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            CustomException__c exc = new CustomException__c();
            if(logRequest.getRequestBody().length() < 32766)
            {
            exc.Request_Body__c= logRequest.getRequestBody();
            }
            else{
            exc.Request_Body__c=limitBody(logRequest.getRequestBody());
            }
            exc.Object_Name__c='Account';
            exc.MethodName__c = logRequest.getMethodName();
            exc.Exception_Message__c = e.getMessage();
            exc.Exception_Type__c = e.getTypeName();
            exc.Line_Number__c = e.getLineNumber();
            exc.StackTrace__c = e.getStackTraceString();
            exc.MethodName__c = methodName;
            exc.ClassName__c = className;
            exc.Notify_Email__c = queryNotifyEmail();
            exc.Type__c='Exception';
            DML_CRUDEnforce_Utility.dmlInsert(new List<CustomException__c>{exc});
        }

        public static String limitBody(String inputBody){
            return inputBody.left(32766);
        }

        /**
       * @description Method to get the email for the error notification
       * @author Devendra Villa
       * @return email
       **/
      public static String queryNotifyEmail() {
        Exception_Notification__c exceptionMail= Exception_Notification__c.getInstance();      
        if(exceptionMail!= null){
            String notifyEmail = exceptionMail.Emails_For_Notification__c; 
            return notifyEmail;
        }
        return 'devendra_villa@epam.com';
    }
    
    /*
    public static void logRequest(String requestBody, String className){
        CustomException__c exc = new CustomException__c();
        exc.ClassName__c = className;
        exc.Type__c='Request';
        if(requestBody.length() < 32766){
        exc.Request_Body__c= requestBody;}
        else{
        exc.Request_Body__c=limitBody(requestBody);
        }
        exc.Object_Name__c='Account';
        DML_CRUDEnforce_Utility.dmlInsert(new List<CustomException__c>{exc});
    }
    
    public static void logResponse(String responseBody, Integer statusCode, String className){
        CustomException__c exc = new CustomException__c();
        exc.ClassName__c = className;
        exc.Type__c='Response';
        exc.Status_Code__c=String.valueOf(statusCode);
        if(responseBody.length() < 32766){
        exc.Response_Body__c= responseBody;
        }
        else{
        exc.Response_Body__c=limitBody(responseBody);   
        }
        exc.Object_Name__c='Account';
        DML_CRUDEnforce_Utility.dmlInsert(new List<CustomException__c>{exc});

    }
    
    public static void logMcRequest(HttpRequest req, String className){
        CustomException__c exc = new CustomException__c();
        exc.ClassName__c = className;
        exc.Type__c='Request';
        if(req.getBody().length() < 32766){
        exc.Request_Body__c= req.getBody();
        }
        else{
        exc.Request_Body__c=limitBody(req.getBody());
        }
        exc.MethodName__c = req.getMethod();
        DML_CRUDEnforce_Utility.dmlInsert(new List<CustomException__c>{exc});
    }

    public static void logMcResponse(HttpResponse res, String className){
        CustomException__c exc = new CustomException__c();
        exc.ClassName__c = className;
        exc.Type__c='Response';
        exc.Status_Code__c=String.valueOf(res.getStatusCode());
        if(res.getBody().length() < 32766){
        exc.Response_Body__c= res.getBody();
        }
        else{
        exc.Response_Body__c=limitBody(res.getBody());   
        }
        
        DML_CRUDEnforce_Utility.dmlInsert(new List<CustomException__c>{exc});

    }
    */
    


    

}