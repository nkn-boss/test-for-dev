@isTest
public class LeadInvocableHandlerTest {
    
    @testSetup static void setup() {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        
        TestDataFactory.createPersonAccounts(2);
		testAccts = [Select Id, Name from Account ];
        List<Lead> leadList = new List<Lead>();
        List<Lead> newleadList = new List<Lead>();
        leadList=TestDataFactory.createDuplicateLeads(2,'India');
        newleadList=TestDataFactory.createDuplicateLeads(2,'China');
        List<Lead> dupLeads = [select Id, Name, Email from Lead where IsConverted = false];
        List<Individual> indList = new List<Individual>();
        for(Integer i=0;i<2;i++) {
            indList.add(TestDataFactory.createIndividuals(testAccts.get(i).Id,dupLeads.get(i).id,i));
        }
        insert indList;

        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        for(Lead lead : newleadList){
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(lead.Id);
            lc.convertedStatus = 'Qualified';
            leadConverts.add(lc);
        }
       Database.convertLead(leadConverts);
    }
    
    
    
    @isTest static void testConvertLeadsdupLeadsEmpty(){
        List<String> listOfAccount = new List<String>();
        Test.startTest();
        LeadInvocableHandler.ConvertLeads(listOfAccount);
        Test.stopTest();   
        List<Lead> dupLeads = [select Id, Name, Email from Lead where IsConverted = false];
        System.assertEquals(2,dupLeads.size(),'Match');
        System.assertEquals(true,dupLeads.get(0).Name.startsWith('TestIndia'),'Match');
        System.assertEquals(true,dupLeads.get(1).Name.startsWith('TestIndia'),'Match');
    }
    
    @isTest static void testConvertLeads(){
        List<String> listOfAccount = new List<String>();
        for(Lead leadRec : [select id, Name, email from Lead where isConverted = false]){
            listOfAccount.add(leadRec.id);
        }
        Test.startTest();
        LeadInvocableHandler.ConvertLeads(listOfAccount);
        Test.stopTest();   
        List<Lead> dupLeads = [select Id, Name, Email from Lead where IsConverted = false];
        System.assertEquals(0,dupLeads.size(),'Match');
        List<Lead> dupLeadsConverted = [select Id, Name, Email from Lead where IsConverted = true];
        System.assertEquals(4,dupLeadsConverted.size(),'Match');
        
    }

}