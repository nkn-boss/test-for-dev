@isTest
public class DeleteIndividualResultRecordsBatchTest {
    
    // Test method to insert test data
    @isTest
    static void testBatchJob() {
        // Create test data for et4ae5__IndividualEmailResult__c object
        et4ae5__Automated_Send__c ac = new et4ae5__Automated_Send__c();
        ac.Name = 'test1email';
        INSERT ac;
        List<et4ae5__IndividualEmailResult__c> recordsToDelete = new List<et4ae5__IndividualEmailResult__c>();
        for (Integer i = 0; i < 2000; i++) {
            recordsToDelete.add(new et4ae5__IndividualEmailResult__c(Name = 'Test Record ' + i,et4ae5__TriggeredSendDefinition__c = ac.Id));
        }
        insert recordsToDelete;
        
        // Start the batch job
        Test.startTest();
        DeleteIndividualResultRecordsBatch batchJob = new DeleteIndividualResultRecordsBatch();
        Database.executeBatch(batchJob, 2000);
        Test.stopTest();
        
    }
}