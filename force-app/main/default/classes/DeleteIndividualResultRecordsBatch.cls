global class DeleteIndividualResultRecordsBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id
            FROM et4ae5__IndividualEmailResult__c
        ]);
    }

    global void execute(Database.BatchableContext context, List<et4ae5__IndividualEmailResult__c> scope) {
        List<et4ae5__IndividualEmailResult__c> recordsToDelete = new List<et4ae5__IndividualEmailResult__c>();
        
        for (et4ae5__IndividualEmailResult__c record : scope) {
            recordsToDelete.add(record);
        }

         // Process records in chunks of 2000
        if (!recordsToDelete.isEmpty()) {
            Database.delete(recordsToDelete, false);
        }
        
    }

    global void finish(Database.BatchableContext context) {
        // Perform any post-processing tasks if needed
    }
}