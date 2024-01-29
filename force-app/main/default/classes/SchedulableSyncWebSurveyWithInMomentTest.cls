@isTest
public class SchedulableSyncWebSurveyWithInMomentTest {
    
    @isTest
    public static void testschedule() {
        String scheduleTime = '0 0 0 ? * * *';
    	String scheduleJobName = 'Test SchedulableSyncWebSurveyWithInMoment';
        
        List<CronTrigger> cronJobsBeforeSchedule = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger];
        
        HttpMock mock = new HttpMock(200,'SUCCESS','', new Map<String,String>(), true);        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.StartTest();
        SchedulableSyncWebSurveyWithInMoment storeInfoYext = new SchedulableSyncWebSurveyWithInMoment();
        
        Id jobId = system.schedule(scheduleJobName, scheduleTime, storeInfoYext);
        
        List<CronTrigger> cronJobsAfterSchedule = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger];
        System.assertEquals(false, String.isBlank(jobId),'Job Id ');
        System.assertEquals(cronJobsAfterSchedule.size(), cronJobsBeforeSchedule.size() + 1,'Cron Job after schedule');
        
        Test.stopTest(); 
    }
}