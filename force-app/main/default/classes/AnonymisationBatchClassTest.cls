@isTest
private class AnonymisationBatchClassTest {
    @isTest static void testData(){
        
        PS_Process_Deactivation__c ppd = PS_Process_Deactivation__c.getInstance();
        ppd.PS_Disable_Flows__c = true;
        UPSERT ppd;
        Account[] acc =TestDataFactory.createPersonAccountsForAnonymisation(1);
        Lead[] lead = TestDataFactory.createLeadsForAnonymisation(1);
        //List<Account> listAcc = Test.loadData(Account.sObjectType, 'testAccounts');

       Case newCase= TestDataFactory.createCasesWithRelatedCases(acc);
    	
       /* CaseComment newcct= new CaseComment(
        	ParentId= newCase.id,
            CommentBody= 'Test'
            
        );
        insert newcct;*/

        TestDataFactory.createCaseComments(newCase.id);
        
        // EmailMessage email = new EmailMessage();
        // email.FromAddress = 'test@abc.org';
        // email.Incoming = True;
        // email.ToAddress= 'test@xyz.org';
        // email.Subject = 'Test email';
        // email.HtmlBody = 'Test email body';
        // email.ParentId = newCase.Id; 
        // insert email;
        
        TestDataFactory.createEmail(newCase.id);
        TestDataFactory.createLiveChatTranscript(TestDataFactory.createLiveChatVisitor());
        // LiveChatVisitor lcv = new LiveChatVisitor();
        // insert lcv;
        // LiveChatTranscript lct = new LiveChatTranscript();
        // lct.LiveChatVisitorid = lcv.id;
        // lct.CaseId = newCase.Id;
        // insert lct;
        
        // ContentVersion content=new ContentVersion(); 
        // content.Title='Sample doc'; 
        // content.PathOnClient='/' + content.Title + '.csv'; 
        // Blob bodyBlob=Blob.valueOf('Unit Test sample'); 
        // content.VersionData=bodyBlob; 
        // insert content;
        TestDataFactory.createContentLink(newCase.id, TestDataFactory.createContent());
        // ContentDocumentLink contentlink=new ContentDocumentLink();
        // contentlink.LinkedEntityId=newCase.id;
        // //contentlink.ShareType= 'I';
        // //contentlink.LinkedEntityId = q.Id;
        // contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;  
        // insert contentlink;
        TestDataFactory.createCustomSetting();
        Test.startTest();
        Database.executeBatch(new AnonymisationBatchClass('Test'));
        Database.executeBatch(new AccountBatchAnonymisation('Test'));
        Database.executeBatch(new LeadBatchAnonymisation('Test'));
        Test.stopTest();
    }
    @isTest 
    static void runBatch(){
        				
    
    }
}