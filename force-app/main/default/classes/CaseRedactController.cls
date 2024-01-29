/**
 * @Project : Primark
 * @Author  : Nitin K Nayan (EPAM)
 * @Date    : 08-NOV-2022
 * @description : Controller for the Case Redact Component on the Case Record Page
 * ************************************************************************************************
 * Name                     Date            Comments
 * Nitin K Nayan (EPAM)     26-DEC-2022     CRM-619 - as part of the Code Refatroring for Salesfroce Code Analyzer
 */
public without sharing class CaseRedactController {
    /**
    * @description fetch the Case with the ID getting from Component & return it.
    * @author Nitin K Nayan | EPAM | 08-11-2022 
    * @param caseId
    * @return caseList
    **/
    @AuraEnabled
    public static case fetchCase(String caseId){
        try {
            
            List<Case> caseList = [SELECT Id, Description FROM Case WHERE Id = :caseId WITH SECURITY_ENFORCED LIMIT 1];
            return caseList[0];
            
        } catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    /**
    * @description fetch the Case Comments with the ID getting from Component & return it.
    * @author Nitin K Nayan | EPAM | 08-11-2022 
    * @param caseId 
    * @return List<CaseComment>
    **/
    @AuraEnabled
    public static List<CaseComment> fetchCaseComments(String caseId){
        try {
            
            List<CaseComment> comments = [SELECT Id, CommentBody FROM CaseComment WHERE ParentId = :caseId WITH SECURITY_ENFORCED];
            return comments;
            
        } catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    /**
    * @description Update the Case with the Redacted Data.
    * @author Nitin K Nayan | EPAM | 08-11-2022 
    * @param caseId to get caseId
    * @param redactDescription to get description
    **/
    @AuraEnabled
    public static void updateCase(String caseId,String redactDescription){
        try {
            List<Case> caseToUpdate = [SELECT Id, Description FROM Case WHERE Id = :caseId WITH SECURITY_ENFORCED LIMIT 1];
            if(caseToUpdate!=null && !caseToUpdate.isEmpty()){
                caseToUpdate[0].Description = redactDescription;
                //Added as part of the CODE REFACTORING. 
                DML_CRUDEnforce_Utility.dmlUpdate(caseToUpdate);

                //UPDATE caseToUpdate; //REMOVED AS PART OF THE CODE REFACTROING.
            }

        } catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    /**
    * @description Update the Selected Case Comment with the Redacted Data.
    * @author Nitin K Nayan | EPAM | 08-11-2022 
    * @param commentId to get commentId 
    * @param redactComment  to get redactComment
    **/
    @AuraEnabled
    public static void updateCaseComments(String commentId,String redactComment){
        try {
            List<CaseComment> commentToUpdate =  [SELECT Id, CommentBody FROM CaseComment WHERE Id = :commentId WITH SECURITY_ENFORCED LIMIT 1];
            if(commentToUpdate!=null && !commentToUpdate.isEmpty()){
                commentToUpdate[0].CommentBody = redactComment;
                //Added as part of the CODE REFACTORING. 
                DML_CRUDEnforce_Utility.dmlUpdate(commentToUpdate);

                //UPDATE commentToUpdate; REMOVED AS PART OF THE CODE REFACTROING.
            }

        } catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }
    /**
    * @description fetch the Chat transcript with the ID getting from Component & return it.
    * @author Tanya | EPAM | 07-20-2023
    * @param chatId
    * @return chatList
    **/
    @AuraEnabled
    public static LiveChatTranscript fetchChat(String chatId){
        try {
            
            List<LiveChatTranscript> chatList = [SELECT Id, Body FROM LiveChatTranscript WHERE Id = :chatId AND Status ='Completed' WITH SECURITY_ENFORCED LIMIT 1];
            return chatList[0];
        } catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }

    /**
    * @description Update the Chat with the Redacted Data.
    * @author Tanya | EPAM | 07-20-2023 
    * @param chatId to get chatId
    * @param redactBody to get Body
    **/
    @AuraEnabled
    public static void updateChat(String chatId,String redactBody){
        try {
            List<LiveChatTranscript> chatToUpdate = [SELECT Id, Body FROM LiveChatTranscript WHERE Id = :chatId AND Status ='Completed' WITH SECURITY_ENFORCED LIMIT 1];
            if(chatToUpdate!=null && !chatToUpdate.isEmpty()){
                chatToUpdate[0].Body = redactBody;
                //Added as part of the CODE REFACTORING. 
                DML_CRUDEnforce_Utility.dmlUpdate(chatToUpdate);

                //UPDATE chatToUpdate; REMOVED AS PART OF THE CODE REFACTROING.
            }

        } catch (Exception e) {throw new AuraHandledException(e.getMessage());}
    }


}