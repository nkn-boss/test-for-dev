@isTest
public class QueueableSyncWebSurveyWithInMomentTest {
    public static String customExceptionMessage = 'Test Custom Callout Exception';
    public static String dmlExceptionMessage = 'Insert failed. First exception on row 0; first error: INVALID_EMAIL_ADDRESS, Email: invalid email address: xyz: [Email]';
    
    @isTest static void testInMomentSurveySynchronization() {
        Test.setMock(HttpCalloutMock.class, new MockHttp(true,''));
        Test.startTest();
        System.enqueueJob(new QueueableSyncWebSurveyWithInMoment());
        Test.stopTest();

        List<Lead> leadRecords = [Select Id, FirstName, LastName, Email, LeadSource From Lead];
        System.assertEquals(1, leadRecords.size());
        System.assertEquals('Marta', leadRecords[0].FirstName);
        System.assertEquals('InMoment', leadRecords[0].LeadSource);
        System.assertEquals('Afonso', leadRecords[0].LastName);
        System.assertEquals('test11@test1.com', leadRecords[0].Email);
    }
    
    @isTest static void testInMomentSurveySync_With_DML_Exception() {
        Test.setMock(HttpCalloutMock.class, new MockHttp(false, 'DML Exception'));
        
        Test.startTest();
        System.enqueueJob(new QueueableSyncWebSurveyWithInMoment());
        Test.stopTest();
        
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c where (Type__c!= 'Response' AND Type__c!= 'Request')];
        System.assertEquals(dmlExceptionMessage, customExceptionRecords[0].Exception_Message__c, 'Pass');
        System.assertEquals(1, customExceptionRecords.size());
    }
    
    @isTest static void testInMomentSurveySync_With_Authorize_Callout_Exception() {
        Test.setMock(HttpCalloutMock.class, new MockHttp(false, 'Authorize Exception'));
        
        Test.startTest();
        System.enqueueJob(new QueueableSyncWebSurveyWithInMoment());
        Test.stopTest();
        
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c where (Type__c!= 'Response' AND Type__c!= 'Request')];
        System.assertEquals(customExceptionMessage, customExceptionRecords[0].Exception_Message__c);
        System.assertEquals(1, customExceptionRecords.size());
    }
    
    @isTest static void testInMomentSurveySync_With_SurveyID_Callout_Exception() {
        Test.setMock(HttpCalloutMock.class, new MockHttp(false, 'SurveyID Exception'));
        
        Test.startTest();
        System.enqueueJob(new QueueableSyncWebSurveyWithInMoment());
        Test.stopTest();
        
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c where (Type__c!= 'Response' AND Type__c!= 'Request') ];
        System.assertEquals(customExceptionMessage, customExceptionRecords[0].Exception_Message__c);
        System.assertEquals(1, customExceptionRecords.size());
    }
    
    @isTest static void testInMomentSurveySync_With_SurveyDetail_Callout_Exception() {
        Test.setMock(HttpCalloutMock.class, new MockHttp(false, 'SurveyDetail Exception'));
        
        Test.startTest();
        System.enqueueJob(new QueueableSyncWebSurveyWithInMoment());
        Test.stopTest();
        
        List<CustomException__c> customExceptionRecords = [Select Id, Exception_message__c From CustomException__c where (Type__c!= 'Response' AND Type__c!= 'Request') ];
        System.assertEquals(customExceptionMessage, customExceptionRecords[0].Exception_Message__c);
        System.assertEquals(1, customExceptionRecords.size());
    }
    
    private class MockHttp implements HttpCalloutMock {
        Boolean isSuccess;
        String exceptionEndPoint;
        
        public MockHttp(Boolean isSuccess, String endPoint) {
            this.isSuccess = isSuccess;
            this.exceptionEndPoint = endPoint;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            String surveyDetailResponse = '[{"beginTime":"2022-01-05T07:02:57","offerId":"6432","answers":[{"fieldName":"First Name (Private)","literalValue":"Marta"},{"fieldName":"Last Name (Private)","literalValue":"Afonso"},{"fieldName":"Email Address (Private)","literalValue":"test11@test1.com"},{"fieldName":"Country (Actual)","literalValue":"ukkkkkkkk"},{"fieldName":"Browser Locale","literalValue":"en_GB"}]},{"beginTime":"2022-01-05T07:02:57","offerId":"6432","answers":[{"fieldName":"First Name (Private)","literalValue":"Marta"},{"fieldName":"Last Name (Private)","literalValue":"Afonso"},{"fieldName":"Email Address (Private))","literalValue":"test2@test2.com"},{"fieldName":"Country (Actual)","literalValue":"potruguesss"},{"fieldName":"Browser Locale","literalValue":"pt_PT"}]}]';
            String dmlExceptionResponse = '[{"beginTime":"2022-01-05T07:02:57","offerId":"6432","answers":[{"fieldName":"First Name (Private)","literalValue":"Marta"},{"fieldName":"Last Name (Private)","literalValue":"Afonso"},{"fieldName":"Email Address (Private)","literalValue":"xyz"},{"fieldName":"Country (Actual)","literalValue":"ukkkkkkkk"},{"fieldName":"Browser Locale","literalValue":"en_GB"}]},{"beginTime":"2022-01-05T07:02:57","offerId":"6432","answers":[{"fieldName":"First Name (Private)","literalValue":"Marta"},{"fieldName":"Last Name (Private)","literalValue":"Afonso"},{"fieldName":"Email Address (Private)","literalValue":"xyz11"}]}]';
            
            if (req.getEndpoint().endsWith('authorize')) {
                if (!this.isSuccess && this.exceptionEndPoint.endsWith('Authorize Exception')){
                    CalloutException e = (CalloutException)CalloutException.class.newInstance();
                    e.setMessage(customExceptionMessage);
                    throw e;
                }
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"access_token": "demo"}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().endsWith('1583')) {
                if (!this.isSuccess && this.exceptionEndPoint.endsWith('SurveyID Exception')){
                    CalloutException e = (CalloutException)CalloutException.class.newInstance();
                    e.setMessage(customExceptionMessage);
                    throw e;
                }
                HTTPResponse res = new HTTPResponse();
                res.setBody('[11, 21]');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().endsWith('True')) {
                if (!this.isSuccess && this.exceptionEndPoint.endsWith('SurveyDetail Exception')){
                    CalloutException e = (CalloutException)CalloutException.class.newInstance();
                    e.setMessage(customExceptionMessage);
                    throw e;
                }
                if (!this.isSuccess && this.exceptionEndPoint.endsWith('DML Exception')){
                    HTTPResponse res = new HTTPResponse();
                    res.setBody(dmlExceptionResponse);
                    res.setStatusCode(404);
                    return res;
                }
                HTTPResponse res = new HTTPResponse();
                res.setBody(surveyDetailResponse);
                res.setStatusCode(200);
                system.debug('Response for Lead Correct--->'+res.getBody());
                return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        } 
    }
}