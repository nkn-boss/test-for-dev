public with sharing class AnonymisationUtility {
    public AnonymisationUtility() {
        
    }
     /**
      * @description  : To get Case records
      * @author       : Devendra Villa
      * @param         Case ca, List<Case> caseList
      * @return       : List<Case>
      **/
      public static Case checkCases(Case ca){
        // System.debug('Id===>'+ ca.contactId);
 
         ca.ContactId=null;
         ca.AccountId=null;
         ca.SuppliedEmail=null;
         ca.SuppliedCompany	=null;
         ca.SuppliedName=null;
         ca.SuppliedPhone=null;
         ca.Is_Anonymised__c=true;
         ca.Description = null;
         ca.Status= 'Anonymised';
         
         //add supplied fields
         
         return ca;
       }
       public static Account checkAccounts( Id accountId){
 
       // Anonymize the Account as it's not associated with any other case
       Account a = new Account(Id = accountId);
       a.Is_CS_Anonymised__c = true;
       return a;
       }
 
       public static String getWhereClause(Anonymisation_Criteria__mdt retentionmdt)
       {
         Date anonymizeDate;
         String clause='';
        // Date dateClosed = date.newinstance(ca.ClosedDate.year(), ca.ClosedDate.month(), ca.ClosedDate.day());
         //if(ca.Child__c = True ||(ca.RecordType.DeveloperName = 'Internal_Case' || ca.RecordType.DeveloperName = 'Internal_Store_Support	')  ){
          // anonymizeDate = dateClosed.addYears(21);
         //}
 
         if(String.isNotBlank(retentionmdt.Tier__c)){
           clause+=' AND Tier__c IN ('+ retentionmdt.Tier__c+') ';
         }
         
       if(retentionmdt.Period_Type__c == 'Years'){
         anonymizeDate = Date.today().addYears(-(integer.valueOf(retentionmdt.Retention_Period__C)));
       } 
       else if(retentionmdt.Period_Type__c == 'Days'){
         anonymizeDate = Date.today().addDays(-(integer.valueOf(retentionmdt.Retention_Period__C)));
         System.Debug('Date ==>'+anonymizeDate);
       }
 
       if(String.isNotBlank(retentionmdt.Extra_Fields__c)){
         clause+=' AND '+ retentionmdt.Extra_Fields__c;
 
       }
 
       String anonyDate =  String.valueOfGmt(anonymizeDate);
       String newAnnonyDate=anonyDate.substringBefore(' ')+'T'+anonyDate.substringAfter(' ')+'Z';
       //anonyDate.replace(' ', 'T');
       //anonyDate=anonyDate+'Z';
       
       
       clause+=' AND ClosedDate < '+newAnnonyDate;
       //clause+=' AND ClosedDate >= TODAY';
         
 
         return clause;
       }
 
       /**
       * @description  : To get LiveChatTranscript records
       * @author       : Devendra Villa
       * @param         Case ca, List<LiveChatTranscript> transcriptList
       * @return       : List<CaseComment>
       **/
       public static void checkLiveChatTranscripts(Set<Id> currentCaseIds ){
         List<LiveChatTranscript> casetranscriptList = new List<LiveChatTranscript>();
         casetranscriptList= [Select Id from LiveChatTranscript where CaseId IN :currentCaseIds];
         Database.Delete(casetranscriptList, true);  
       }
 
     
     /**
       * @description  : To get Email Message records
       * @author       : Devendra Villa
       * @param         Set<Id> currentCaseIds
       * @return       : null
       **/
       public static void checkEmailmessages(Set<Id> currentCaseIds){
         List<EmailMessage> emailMsgList=new List<EmailMessage>();
         emailMsgList=[Select Id,ParentId from EmailMessage where ParentId IN:currentCaseIds];
         Database.Delete(emailMsgList, true);  
       }
 
        /**
       * @description  : To get ContentDocumentLink records
       * @author       : Devendra Villa
       * @param         Case ca, List<ContentDocumentLink> contentList
       * @return       : List<ContentDocumentLink>
       **/
       public static void checkContentDocumentLinks(Set<Id> currentCaseIds){
         List<ContentDocument> caseDocumentList = new List<ContentDocument>();
         for(ContentDocumentLink ccl:[Select Id,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN :currentCaseIds]){
           ContentDocument cd = new ContentDocument (Id =ccl.ContentDocumentId );
           caseDocumentList.add(cd);
         }
         Database.delete(caseDocumentList, true);
 
 
       }
 
}