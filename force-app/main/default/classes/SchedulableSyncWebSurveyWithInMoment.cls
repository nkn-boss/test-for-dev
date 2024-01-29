/* 
* Project:     Оscar Website
* Date:        21/03/2022
* Created By:  Anshul Sharma
* Class Description: Schedulable class to enqueue Queueable class for InMoment Survey Integration 
*/
global class SchedulableSyncWebSurveyWithInMoment implements Schedulable {
    global void execute(SchedulableContext SC) {
        System.enqueueJob(new QueueableSyncWebSurveyWithInMoment());
    }
}