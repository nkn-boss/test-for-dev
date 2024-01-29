@IsTest
private class StoreAccountManagerTest {
    @isTest static void testDoUpsertAccount() {
        String httpMethod = 'PUT';
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        StoreAccountManager.StoreInformation newAcc = TestDataFactory.getStoreInformationTestRecord();
        Test.startTest();
        StoreAccountManager.doUpsertAccount(newAcc);
       
        Test.stopTest();
        
    }
    @isTest static void testDoUpsertAccountNoId() {
        String httpMethod = 'PUT';
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        StoreAccountManager.StoreInformation newAcc = TestDataFactory.getStoreInformationTestRecordErrorNoId();
        Test.startTest();
        StoreAccountManager.doUpsertAccount(newAcc);
       
        Test.stopTest();
        
    }
    
    @isTest static void testDoUpsertAccountWithDMLException() {
        String httpMethod = 'PUT';
        String exceptionMessage = 'Upsert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [Name]: [Name]';
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res; 
        StoreAccountManager.StoreInformation newErrorAcc = TestDataFactory.getStoreInformationTestRecordError();
        Test.startTest();
        StoreAccountManager.doUpsertAccount(newErrorAcc);
        res = RestContext.response;
        StoreAccountManager.CustomSalesforceResponse responseDetail = (StoreAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StoreAccountManager.CustomSalesforceResponse.class);
        Test.stopTest();
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c];
        if(customExceptionRecords.size()>0){
        System.assertEquals(exceptionMessage, customExceptionRecords[0].Exception_Message__c,'Pass');
        System.assertEquals(1, customExceptionRecords.size(),'Pass');
        System.assertEquals(500, RestContext.response.statusCode,'Pass');
        System.assertEquals(exceptionMessage, responseDetail.message,'Pass');
        System.assertEquals('BAD_REQUEST', responseDetail.responseCode,'Pass');
        }
    }
    
    @isTest static void testDoUpsertAccountWithException() {
        String httpMethod = 'PUT';
        String exceptionMessage = 'Attempt to de-reference a null object';
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        StoreAccountManager.StoreInformation newErrorAcc = new StoreAccountManager.StoreInformation();
        Test.startTest();
        StoreAccountManager.doUpsertAccount(newErrorAcc);
        res = RestContext.response;
        StoreAccountManager.CustomSalesforceResponse responseDetail = (StoreAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StoreAccountManager.CustomSalesforceResponse.class);
        Test.stopTest();
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c];
        System.assertEquals(exceptionMessage, customExceptionRecords[0].Exception_Message__c,'Pass');
        System.assertEquals(1, customExceptionRecords.size(),'Pass');
        System.assertEquals(400, RestContext.response.statusCode,'Pass');
        System.assertEquals(exceptionMessage, responseDetail.message,'Pass');
        System.assertEquals('INVALID_REQUEST', responseDetail.responseCode,'Pass');
    }

    static RestRequest getRestRequest(String StoreId, String httpMethod) {
        RestRequest request = new RestRequest();
        request.requestUri ='https://primark--dev.my.salesforce.com/services/apexrest/accountmanager/';
        request.httpMethod = httpMethod;
        if (!String.isBlank(StoreId)) {
            request.addParameter('Key', 'Store_Locale_ID__c');
            request.addParameter('Value', '123 # en-gb');
        }
        return request;
    }
    
    
}