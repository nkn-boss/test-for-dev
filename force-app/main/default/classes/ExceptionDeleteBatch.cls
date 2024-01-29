public with sharing class ExceptionDeleteBatch implements Database.Batchable<sObject>{
    
    public Integer retentiondays;
    public ExceptionDeleteBatch( Integer retentiondays1){
      retentiondays=retentiondays1;
  }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for Custom Exceptions created more than 30 days ago
        Date thirtyDaysAgo = Date.today().addDays(-retentiondays);
        String query = 'SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, ClassName__c, Exception_Message__c, Exception_Type__c, Line_Number__c, MethodName__c, StackTrace__c, Notify_Email__c, Type__c, Request_Body__c, Response_Body__c, Method_Type__c, Status_Code__c, Object_Name__c FROM CustomException__c WHERE CreatedDate < :thirtyDaysAgo ORDER BY CreatedDate LIMIT 1';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<CustomException__c> exceptionList) {

        System.debug('Exception'+exceptionList);
        String csvContent = 'Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, ClassName__c, Exception_Message__c, Exception_Type__c, Line_Number__c, MethodName__c, StackTrace__c, Notify_Email__c, Type__c, Request_Body__c, Response_Body__c, Method_Type__c, Status_Code__c, Object_Name__c\n';
        for (CustomException__c c : exceptionList) {
            csvContent += c.Id + ',' + c.OwnerId +',' + c.IsDeleted+ ',' + c.Name +','+ c.CreatedDate +','+ c.CreatedById +','+ c.LastModifiedDate +','+ c.LastModifiedById +','+ c.SystemModstamp +','+ c.LastViewedDate +','+ c.LastReferencedDate +','+ c.ClassName__c +','+ c.Exception_Message__c +','+ c.Exception_Type__c +','+ c.Line_Number__c +','+ c.MethodName__c +','+ c.StackTrace__c +','+ c.Notify_Email__c +','+ c.Type__c +','+ c.Request_Body__c +','+ c.Response_Body__c +','+ c.Method_Type__c +','+ c.Status_Code__c +','+ c.Object_Name__c + '\n';
        }

        // Save CSV content to a file
        String fileName = 'DeletedCustomException_' + Datetime.now().formatGMT('yyyyMMdd_HHmmss') + '.csv';
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        cv.VersionData = Blob.valueOf(csvContent);
        cv.IsMajorVersion = true;
        cv.FirstPublishLocationId = UserInfo.getUserId();
        insert cv;
        delete exceptionList;
    }
    public void finish(Database.BatchableContext bc) {
        
    }

}