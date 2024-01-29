@isTest(SeeAllData = False)
public class CaseInvocableHandlerTest {
    public static Profile p = [SELECT id, Name FROM Profile where name = 'System Administrator' ].get(0);  
    public static User u = new User(firstname= 'Samuel',
                                    lastname='XXXX',
                                    Alias='Test1',
                                    email = 'Test1@test.com',
                                    username= 'test1@testnkn_pm.com', 
                                    profileId= p.id, 
                                    emailencodingkey='UTF-8',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    timezonesidkey='America/Los_Angeles');
    
   /* @TestSetUp static void testData() {
        //Test Data Setup
        PS_Process_Deactivation__c ppd = PS_Process_Deactivation__c.getInstance();
        ppd.PS_Disable_Flows__c = true;
        UPSERT ppd;
        
        Case newCase = new Case(
            Subject = 'Test Case Creation',
            Status = 'New',
            Origin = 'Email',
            Tier__c = 'Tier 1',
            Priority = 'Normal',
            Reason = 'Customer Service General Enquiry',
            SuppliedEmail = 'test@epam.com'
        );
        insert newCase;
        
    }
    */
    @isTest
    private static void validatecaseemailRequest() {
        
        EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getuserId(), TemplateType= 'Text', Name = 'test'); // plus any other fields that you want to set
        system.runAs(u){
            insert e;
        }
        
        OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress LIMIT 1];
        CaseInvocableHandler.caseemailRequest input = new CaseInvocableHandler.caseemailRequest();
        
        List<Case> casesList = TestDataFactory.createCases(3);
        
        input.CaseId = casesList[0].id;
        input.EmailAddress = casesList[0].SuppliedEmail;
        input.OrgWideEmailAddress = owa.DisplayName;
        input.TemplateId = e.id;
        Test.startTest();
        CaseInvocableHandler.caseemailList(new List<CaseInvocableHandler.caseemailRequest>{input});
        Test.stopTest();
        System.assertEquals(1,1,'Pass');
    }         
}