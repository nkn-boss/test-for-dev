/**
 * @Project : Primark
 * @Author  : 
 * @Date    : 
 * @description : invocable method convert lead to account
 * ************************************************************************************************
 * Name                     Date            Comments
 * Nitin K Nayan (EPAM)     27-DEC-2022     CRM-619 - as part of the Code Refatroring for Salesfroce Code Analyzer
 */
public with sharing class TaskTriggerHandler {

     /**
    * @description run on ondelete of the task
    * @author 
    * @param tasks
    **/
    public static void onDelete(Task[] tasks) {
		List<id> caseId= new list<id>();
        for (Task taskObject : tasks) {
            String taskId=taskObject.WhatId;
			if(taskId.startsWith('500')){
            caseId.add(taskObject.WhatId);
			}
		}
		 map<id,Case>mapcase = new map<id,Case>([select id, CaseNumber, Status from Case where Status!= 'In Progress' and id in :caseId]); 
		for(Task tas:tasks){
            if(mapcase.containsKey(tas.WhatId)){
                tas.addError('Task cant be deleted where case status  is not In Progress');
            }
		}     
    }
}