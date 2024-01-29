/* 
* Project:   Оscar Website
* Date:        25/02/2022
* Created By:  Anshul Sharma
* Class Description: Schedulable class to enqueue Queueable class for Yext Integration 
*/
global class SchedulableStoreInfoSyncWithYext implements Schedulable {
    /**
    * @description SchedulableContext
    * @author Anshul Sharma
    * @param  sc
    **/
    global void execute(SchedulableContext sc) {
        System.enqueueJob(new QueueableStoreInfoSyncWithYext());
    }
}