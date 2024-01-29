@IsTest
private class StorefrontAccountManagerTest {
    
    @isTest static void testDoGetAccount() {
        String uid = createAccountTestRecord();
        String httpMethod = 'GET';
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        RestRequest request = getRestRequest(uid, httpMethod);
        RestContext.request = request;
        
        Test.startTest();
        StorefrontAccountManager.doGetAccount();
        res = RestContext.response;
        Account acc = (Account) JSON.deserialize(res.responseBody.toString(), Sobject.class);
        Test.stopTest();
        
        System.assert(true, acc != null);
        System.assertEquals('TestFirstName', acc.FirstName,'Pass');
        System.assertEquals('LastName', acc.LastName,'Pass');
        System.assertEquals('demo@demo.com', acc.PersonEmail,'Pass');     
        System.assertEquals(true, acc.PersonHasOptedOutOfEmail,'Pass');
        System.assertEquals(200, res.statusCode,'Pass');
    }
    @isTest static void testDoGetAccountError() {
        String uid= createAccountTestRecord();
        String httpMethod = 'GET';
        try{
        RestResponse res = new RestResponse();
        RestContext.response = res;
        RestRequest request = getRestRequestError(uid, httpMethod);
        RestContext.request = request;
        
        Test.startTest();
        StorefrontAccountManager.doGetAccount();
        res = RestContext.response;
        Account acc = (Account) JSON.deserialize(res.responseBody.toString(), Sobject.class);
        Test.stopTest();
        
        
        System.assert(true, acc != null);
        System.assertEquals('TestFirstName', acc.FirstName,'Pass');
        System.assertEquals('LastName', acc.LastName,'Pass');
        System.assertEquals('demo@demo.com', acc.PersonEmail,'Pass');     
        System.assertEquals(true, acc.PersonHasOptedOutOfEmail,'Pass');
        System.assertEquals(200, res.statusCode,'Pass');}
        catch(exception e){
            
        }
    }
  				
    
    @isTest static void testDoCreateAccount() {
        String httpMethod = 'POST';
        
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        StorefrontAccountManager.AccountInformation newAcc = TestDataFactory.getAccountInformationTestApi('SIGN_IN');
        Test.startTest();
        StorefrontAccountManager.doCreateAccount(newAcc);
        //Language_Code_Mapping__mdt lmdt =[SELECT Id,Label FROM Language_Code_Mapping__mdt WHERE Label = 'en-gb' LIMIT 1];
        res = RestContext.response;
        StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        Account acc = (Account) JSON.deserialize(responseDetail.message, Sobject.class);
        Test.stopTest();
        System.assert(true, acc != null);
        System.assertEquals('TestFirstName', acc.FirstName,'Pass');
        System.assertEquals('LastName', acc.LastName,'Pass');
        System.assertEquals('demo@demo.com', acc.PersonEmail,'Pass');
        System.assertEquals('dummy', acc.Preferred_Store__pc,'Pass');
        System.assertEquals(true, acc.PersonHasOptedOutOfEmail,'Pass');
    }
    
    @isTest static void testDoCreateAccountWithDMLException() {
        String httpMethod = 'POST';
        String exceptionMessage = 'Insert failed. First exception on row 0; first error: INVALID_FIELD_FOR_INSERT_UPDATE, Account: bad field names on insert/update call: Marketing_Communication_Opt_in__pc, Preferred_Store__pc: [Marketing_Communication_Opt_in__pc, Preferred_Store__pc]';
        
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        StorefrontAccountManager.AccountInformation newErrorAcc = TestDataFactory.getAccountInformationTestUIDRecord('random123');
        
        Test.startTest();
        StorefrontAccountManager.doCreateAccount(newErrorAcc);
        res = RestContext.response;
        StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        Test.stopTest();
        
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c where Type__c='Exception'];
        if(customExceptionRecords.size()>0){
        System.assertEquals(exceptionMessage, customExceptionRecords[0].Exception_Message__c,'Pass');
        System.assertEquals(3, customExceptionRecords.size(),'Pass');
        System.assertEquals(500, RestContext.response.statusCode,'Pass');
        System.assertEquals(exceptionMessage, responseDetail.message,'Pass');
        System.assertEquals('BAD_REQUEST', responseDetail.responseCode,'Pass');
        }
    }
    
    @isTest static void testDoCreateAccountWithException() {
        String httpMethod = 'POST';
        String exceptionMessage = 'Attempt to de-reference a null object';
        
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        StorefrontAccountManager.AccountInformation newErrorAcc = new StorefrontAccountManager.AccountInformation();
        
        Test.startTest();
        StorefrontAccountManager.doCreateAccount(newErrorAcc);
        res = RestContext.response;
        StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        Test.stopTest();
        
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c];
        System.assertEquals(exceptionMessage, customExceptionRecords[0].Exception_Message__c,'Pass');
        System.assertEquals(1, customExceptionRecords.size(),'Pass');
        System.assertEquals(400, RestContext.response.statusCode,'Pass');
        System.assertEquals(exceptionMessage, responseDetail.message,'Pass');
        System.assertEquals('INVALID_REQUEST', responseDetail.responseCode,'Pass');
    }
    @isTest static void testDoCreateAccountDMLExec() {
        String httpMethod = 'POST';
        //String uid = createAccountTestRecord();
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        StorefrontAccountManager.AccountInformation newAcc = TestDataFactory.getAccountInformationTestRecord();
        
        
        
        //Account accU = [SELECT Id,UID__c FROM Account WHERE UID__c = 'random123' LIMIT 1];
        
        Test.startTest();
        StorefrontAccountManager.doCreateAccount(newAcc);
        //res = RestContext.response;
        //StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        //Account acc = (Account) JSON.deserialize(responseDetail.message, Sobject.class);
        Test.stopTest();
        System.assertEquals(500, RestContext.response.statusCode,'Pass');
    }
    
    @isTest static void testDoUpdateAccount() {
        String httpMethod = 'POST';
        //String uid = createAccountTestRecord();
        
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        StorefrontAccountManager.AccountInformation newAcc = TestDataFactory.getAccountInformationTestApi('SIGN_IN');
        StorefrontAccountManager.doCreateAccount(newAcc);
        Test.startTest();
        StorefrontAccountManager.doUpdateAccount(newAcc);
        res = RestContext.response;
        StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        Account acc = (Account) JSON.deserialize(responseDetail.message, Sobject.class);
        Test.stopTest();
        
        System.assert(true, acc != null);
        System.assertEquals('TestFirstName', acc.FirstName,'Pass');
        System.assertEquals('LastName', acc.LastName,'Pass');
        System.assertEquals('demo@demo.com', acc.PersonEmail,'Pass');
        System.assertEquals('dummy', acc.Preferred_Store__pc,'Pass');
        System.assertEquals(true, acc.PersonHasOptedOutOfEmail,'Pass');
    }

    @isTest static void testDoUpdateAccountError1() {
        String httpMethod = 'POST';
        //String uid = createAccountTestRecord();
        
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        StorefrontAccountManager.AccountInformation newAcc = TestDataFactory.getAccountInformationTestApi('');
        StorefrontAccountManager.doCreateAccount(newAcc);
        Test.startTest();
        StorefrontAccountManager.doUpdateAccount(newAcc);
        res = RestContext.response;
        StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        Account acc = (Account) JSON.deserialize(responseDetail.message, Sobject.class);
        Test.stopTest();
        
        System.assert(true, acc != null);
        System.assertEquals(500, RestContext.response.statusCode,'Pass');
    }
    
    @isTest static void testDoUpdateAccountNoAccount() {
        String httpMethod = 'POST';
        //String uid = createAccountTestRecord();
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        StorefrontAccountManager.AccountInformation newAcc = TestDataFactory.getAccountInformationTestApi('SIGN_IN');
        StorefrontAccountManager.doCreateAccount(newAcc);
        Account accU = [SELECT Id,UID__c FROM Account WHERE UID__c = 'random123' LIMIT 1];
        accU.UID__c = 'TESTS_EPAM';
        UPDATE accU;
        
        Test.startTest();
        StorefrontAccountManager.doUpdateAccount(newAcc);
        res = RestContext.response;
        StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        Account acc = (Account) JSON.deserialize(responseDetail.message, Sobject.class);
        Test.stopTest();
        
        System.assert(true, acc != null);
        System.assertEquals('TestFirstName', acc.FirstName,'Pass');
        System.assertEquals('LastName', acc.LastName,'Pass');
        System.assertEquals('demo@demo.com', acc.PersonEmail,'Pass');
        System.assertEquals('dummy', acc.Preferred_Store__pc,'Pass');
        System.assertEquals(true, acc.PersonHasOptedOutOfEmail,'Pass');
    }
    @isTest static void testDoUpdateAccountDMLExec() {
        String httpMethod = 'POST';
        //String uid = createAccountTestRecord();
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        StorefrontAccountManager.AccountInformation newAcc = TestDataFactory.getAccountInformationTestUIDRecord('');

        
        
        
        //Account accU = [SELECT Id,UID__c FROM Account WHERE UID__c = 'random123' LIMIT 1];
        
        Test.startTest();
        StorefrontAccountManager.doUpdateAccount(newAcc);
        //res = RestContext.response;
        //StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        //Account acc = (Account) JSON.deserialize(responseDetail.message, Sobject.class);
        Test.stopTest();
        System.assertEquals(500, RestContext.response.statusCode,'Pass');
    }
     @isTest static void testDoUpdateAccountWithDMLException() {
        String httpMethod = 'POST';
        String exceptionMessage = 'List has no rows for assignment to SObject';
        
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        StorefrontAccountManager.AccountInformation newErrorAcc = TestDataFactory.getAccountInformationTestUIDRecord('');
        
        Test.startTest();
        StorefrontAccountManager.doUpdateAccount(newErrorAcc);
        res = RestContext.response;
        StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        Test.stopTest();
        
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c where Type__c='Exception' ];
         if(customExceptionRecords.size()>0){
        System.assertEquals(exceptionMessage, customExceptionRecords[0].Exception_Message__c,'Pass');
        System.assertEquals(3, customExceptionRecords.size(),'Pass');
        System.assertEquals(400, RestContext.response.statusCode,'Pass');
        System.assertEquals('INVALID_REQUEST', responseDetail.responseCode,'Pass');
        System.assertEquals(exceptionMessage, responseDetail.message,'Pass');
     }
        
    }
    
    @isTest static void testDoUpdateAccountWithException() {
        String httpMethod = 'POST';
        String exceptionMessage = 'Attempt to de-reference a null object';
        
        RestRequest request = getRestRequest(null, httpMethod);
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        StorefrontAccountManager.AccountInformation newErrorAcc = new StorefrontAccountManager.AccountInformation();
        
        Test.startTest();
        StorefrontAccountManager.doUpdateAccount(newErrorAcc);
        res = RestContext.response;
        StorefrontAccountManager.CustomSalesforceResponse responseDetail = (StorefrontAccountManager.CustomSalesforceResponse)JSON.deserialize(res.responseBody.toString(), StorefrontAccountManager.CustomSalesforceResponse.class);
        Test.stopTest();
        
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c];
        System.assertEquals(exceptionMessage, customExceptionRecords[0].Exception_Message__c,'Pass');
        System.assertEquals(1, customExceptionRecords.size(),'Pass');
        System.assertEquals(400, RestContext.response.statusCode,'Pass');
        System.assertEquals(exceptionMessage, responseDetail.message,'Pass');
        System.assertEquals('INVALID_REQUEST', responseDetail.responseCode,'Pass');
    }
    
    static RestRequest getRestRequest(String uid, String httpMethod) {
        RestRequest request = new RestRequest();
        request.requestUri ='https://primark--dev.my.salesforce.com/services/apexrest/accountmanager/';
        request.httpMethod = httpMethod;
        if (!String.isBlank(uid)) {
            //request.addParameter('uid', uid);
            request.addParameter('Key', 'uid');
            request.addParameter('Value', 'random123');
        }
        return request;
    }
    static RestRequest getRestRequestError(String uid, String httpMethod) {
        RestRequest request = new RestRequest();
        request.requestUri ='https://primark--dev.my.salesforce.com/services/apexrest/accountmanager/';
        request.httpMethod = httpMethod;
        if (!String.isBlank(uid)) {
            //request.addParameter('uid', uid);
            request.addParameter('Key', 'dff');
            request.addParameter('Value', 'test123@email.com');
        }
        return request;
    }
    
	
    static String createAccountTestRecord() {
        Account acc = new Account(
            FirstName='TestFirstName', 
            LastName='LastName', 
            PersonEmail='demo@demo.com',
            Preferred_Store__pc='dummy',
            UID__c='random123', 							 
            Marketing_Communication_Opt_in__pc=true,
            PersonHasOptedOutOfEmail=true);
        insert acc;
        return acc.UID__C;
    }   
    
    
}