/**
 * @Project : Primark
 * @Author  : Devendra Villa
 * @Date    : 04/10/2023
 * @description :  scheduler class to invoke batch class
 */
global with sharing class LeadAnonymisationScheduler implements Schedulable, Database.AllowsCallouts {
    public String retentionPolicy;
    public LeadAnonymisationScheduler(String retentionPolicy1) {
        retentionPolicy=retentionPolicy1;
    } 
    global void execute(SchedulableContext context) {
      
        LeadBatchAnonymisation batchJob = new LeadBatchAnonymisation(retentionPolicy);
         Id batchJobId = Database.executeBatch(batchJob,200);      
        
    }
}