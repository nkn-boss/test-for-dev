@IsTest
public class LeadTriggerHandlerTest {

    @isTest static void testLeadCreateConvert() {
      
        Lead[] lead=TestDataFactory.createLeads(3);
		TestDataFactory.createCustomSetting();
		Map<Id,Lead> leadMap = new Map<Id,Lead>();
        for(integer i=0; i<lead.size();i++){
        leadMap.put(lead[i].Id,lead[i]);
        }
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
		delete leadMap.get(lead[0].Id);
        /*List<Lead> leadList = [SELECT Id,Email,FirstName,LastName,MiddleName FROM Lead];
        
        
        //LeadTriggerHandler.deDuplicateLeadAccount(leadList);
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(newLead.id);

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(true,lcr.isSuccess());

        List<Lead> convertedlead = [SELECT Id,IsConverted,ConvertedAccountId from Lead WHERE Id =: newlead.id];
        //LeadTriggerHandler ld = new LeadTriggerHandler();
        //LeadTriggerHandler.updateConvertedAccount(convertedlead);
        */
        Test.stopTest();

        }
    }