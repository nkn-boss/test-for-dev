@isTest(SeeAllData = False)
public class RedactClassTest {
   public static string caseId;
   public static List<RecordType> rc = [SELECT id FROM RecordType WHERE SobjectType = 'Case' LIMIT 1];
   
   @TestSetUp static void testData() {
        //Test Data Setup
        Case[] ca=TestDataFactory.createCases(1);
        TestDataFactory.createCaseComments(ca[0].Id);
        TestDataFactory.createLiveChatTranscript(TestDataFactory.createLiveChatVisitor());
        TestDataFactory.createEmail(ca[0].Id);
        
    }
    @isTest
    public static void testredactCreditCardDetails() {
        String description='1234-4556-7899-8756';
        String creditKey= RedactUtility.redactCreditCardDetails(Description);
        System.assertNotEquals(Description, creditKey,'Pass');
        description='ztest description';
		String creditKey1= RedactUtility.redactCreditCardDetails(Description); 
        System.assertEquals(Description,creditKey1,'Pass');        
    }
    @isTest
    public static void testredactCreditCardDetailsWithNoDesc() {
        String description=null;
        String creditKey= RedactUtility.redactCreditCardDetails(Description);
        System.assertEquals(Description, creditKey,'Pass');
        description='ztest description';
		String creditKey1= RedactUtility.redactCreditCardDetails(Description); 
        System.assertEquals(Description,creditKey1,'Pass');        
    }
    @isTest
    public static void testfetchCase() {
        Case[] ca=TestDataFactory.createCases(1);
        Case returnCase = CaseRedactController.fetchCase(ca[0].Id);
        System.assertEquals(ca[0].Id,returnCase.Id,'Pass');
        }
    @isTest
    public static void testfetchCaseWithNoId() {
        try{
        Case returnCase = CaseRedactController.fetchCase(null);
        //System.assertEquals(newCase.Id,returnCase.id,'Pass');
          }
        catch(exception e){
            CustomException.LogException(e);
        }
        }

    @isTest
    public static void testfetchCaseComments() {
        List<CaseComment> cc = CaseRedactController.fetchCaseComments(caseId);
        System.assertEquals(new List<CaseComment>{},cc,'Pass');
        try{
        CaseRedactController.fetchCaseComments(null);
        }
        catch(exception e){
            CustomException.LogException(e);
        }
    }
    
    @isTest
    public static void testupdateCase() {
        Case[] ca=TestDataFactory.createCases(1);
        String redactDescription='1245-6789-8906-8790';
        CaseRedactController.updateCase(ca[0].Id,redactDescription);
        Case c = [SELECT Id,Description FROM Case WHERE id = :ca[0].id LIMIT 1];
        System.assertEquals(redactDescription,c.Description,'Pass');
    }
    @isTest
    public static void testupdateCaseComments() {
        Case[] ca=TestDataFactory.createCases(1);
        CaseComment cc =TestDataFactory.createCaseComments(ca[0].Id);
        String redactComment='test';
        CaseRedactController.updateCaseComments(cc.Id,redactComment);
        CaseComment cc11 = [SELECT Id, CommentBody FROM CaseComment WHERE Id = :cc.id LIMIT 1];
        System.assertEquals(redactComment,cc11.CommentBody,'Pass');
    }
    @isTest
    public static void testFetchChat() {
    String chatId =TestDataFactory.createLiveChatTranscript(TestDataFactory.createLiveChatVisitor());
        CaseRedactController.fetchChat(chatId);
        CaseRedactController.updateChat(chatId,'description 1233444');
        
    }
    
}