@isTest(seeAllData = false)
public class MarketingCloudIntegrationUtilityTest {
    
   
    @isTest static  void testmethod2(){
        Lead[] leadList=TestDataFactory.createLeads(2);
        TestDataFactory.createCustomSetting();
        Map<Id,String> leadMap = new Map<Id,String>();
        leadMap.put(leadList[0].Id, leadList[0].Email);
        leadMap.put(leadList[1].Id, leadList[1].Email);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        MarketingCloudIntegrationUtility.sendRequest(leadMap);
        Test.stopTest();
        
    }

}