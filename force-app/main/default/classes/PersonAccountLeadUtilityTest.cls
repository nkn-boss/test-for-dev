@isTest
public class PersonAccountLeadUtilityTest {

    @testSetup  static void setup(){
        TestDataFactory.createPersonAccounts(2);
        TestDataFactory.createCustomSetting();
        
    }
    @isTest static void testMethod1() {
        Boolean exceptionOccurred = false;
        Account acct = [SELECT Id FROM Account WHERE Lastname='Test LName0' LIMIT 1];
        Account acct1 = [SELECT Id FROM Account WHERE Lastname='Test LName1' LIMIT 1];
        String recordId = acct1.Id;
        PersonAccountLeadUtility.fetchLatestRecordID(acct.Id);
        
        try{
            delete acct1;
           PersonAccountLeadUtility.fetchLatestRecordID(recordId);
        }
        catch(Exception e){
            exceptionOccurred = true;
        }
        System.assert(exceptionOccurred, 'An Exception was not thrown');
    }
    
    
}