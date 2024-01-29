@isTest
public class SchedulableStoreInfoSyncWithYextTest {
    
    @isTest
    public static void testschedule() {
        String scheduleTime = '0 0 0 ? * SUN *';
    	String scheduleJobName = 'Test storeInfoYextIntegration';
        
        List<CronTrigger> cronJobsBeforeSchedule = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger];
        
        HttpMock mock = new HttpMock(200,'SUCCESS','', new Map<String,String>(), true);        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.StartTest();
        SchedulableStoreInfoSyncWithYext storeInfoYext = new SchedulableStoreInfoSyncWithYext();
        
        Id jobId = system.schedule(scheduleJobName, scheduleTime, storeInfoYext);
        
        List<CronTrigger> cronJobsAfterSchedule = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger];
        System.assertEquals(false, String.isBlank(jobId),'Job Id is Blank');
        System.assertEquals(cronJobsAfterSchedule.size(), cronJobsBeforeSchedule.size() + 1,'Jobs after schedule');
        
        Test.stopTest(); 
    }
}