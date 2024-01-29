/**
 * @Project : Primark
 * @Author  : Devendra Villa
 * @Date    : 04/10/2023
 * @description :  scheduler class to invoke batch class
 */
global with sharing class AccountAnonymisationScheduler implements Schedulable, Database.AllowsCallouts {
    public String retentionPolicy;
    public AccountAnonymisationScheduler(String retentionPolicy1) {
        retentionPolicy=retentionPolicy1;
    } 
    global void execute(SchedulableContext context) {
      
        AccountBatchAnonymisation batchJob = new AccountBatchAnonymisation(retentionPolicy);
         Id batchJobId = Database.executeBatch(batchJob,200);      
        
    }
}