@isTest
public  class AccountTriggerHandlerTest {
    
	@isTest static void testData() {  
        
        Account[] accts = TestDataFactory.createPersonAccounts(2);
        TestDataFactory.createCustomSetting();
        Map<Id,Account> accountMap = new Map<Id,Account>();
		accountMap.put(accts[0].Id,accts[0] );
        accountMap.put(accts[1].Id, accts[1]);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        delete accountMap.get(accts[0].Id);
        Test.stopTest();
    }
    /*
    @isTest static void testAutoPopulateFieldsDisplayAddress() {
        Account storeLocationRecord = new Account(
            Name = 'Test Name',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Store').getRecordTypeId(),
            Address_Line_1__c = 'Test Address',
            Address_Line_2__c = 'Test Address2',
            City__c = 'Test City',
            State__c = 'Test State',
            ZIP__c = 'Test Zip'
        );
        
        Test.startTest();
        
        insert storeLocationRecord;
        Id recId = storeLocationRecord.Id;
        Account storeLocationDBRec = [SELECT Id, Address_Line_1__c, Display_Address__c FROM Account WHERE Id =:recId];
        System.assertEquals(true, !String.isBlank(storeLocationDBRec.Display_Address__c), 'Display Address should not be null');
        
        Test.stopTest();
    }
    
    @isTest static void testAutoPopulateFieldsDisplayHoursWithHolidayHours() {
        String mondayHolidayDate = String.valueOf(date.today().toStartofWeek());
        String tuesdayHolidayDate = String.valueOf(date.today().toStartofWeek() + 1);
        String wednesdayHolidayDate = String.valueOf(date.today().toStartofWeek() + 2);
        String thursdayHolidayDate = String.valueOf(date.today().toStartofWeek() + 3);
        String fridayHolidayDate = String.valueOf(date.today().toStartofWeek() + 4);
        String saturdayHolidayDate = String.valueOf(date.today().toStartofWeek() + 5);
        String sunHolidayDate = String.valueOf(date.today().toStartofWeek() + 6);
        String outOfCurrentWeekHolidayDate = String.valueOf(date.today().toStartofWeek() + 10);
        
        Account storeLocationRecord = new Account(
            Name = 'Test Name',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Store').getRecordTypeId(),
            Address_Line_1__c = 'Test Address',
            Address_Line_2__c = 'Test Address2',
            City__c = 'Test City',
            State__c = 'Test State',
            ZIP__c = 'Test Zip', 
            Monday_Hours__c = 'Monday 10:00 - 22:00',
            Tuesday_Hours__c = 'Tuesday 10:00 - 22:00',
            Wednesday_Hours__c = 'Wednesday 10:00 - 22:00',
            Thursday_Hours__c = 'Thursday 10:00 - 22:00',
            Friday_Hours__c = 'Friday 10:00 - 22:00',
            Saturday_Hours__c = 'Saturday 10:00 - 22:00',
            Sunday_Hours__c = 'Sunday 10:00 - 22:00',
            
            Holiday_Hours__C = (mondayHolidayDate + '::CLOSED,' + tuesdayHolidayDate + '::CLOSED,' + wednesdayHolidayDate + '::CLOSED,' + thursdayHolidayDate + '::CLOSED,' + fridayHolidayDate + '::CLOSED,' + saturdayHolidayDate + '::CLOSED,' + sunHolidayDate + '::CLOSED,' + outOfCurrentWeekHolidayDate + '::CLOSED') 
        );
        
        Test.startTest();
        insert storeLocationRecord;
        Id recId = storeLocationRecord.Id;
        Account storeLocationDBRec = [SELECT Id, Display_Hours__c FROM Account WHERE Id =:recId];
        System.assertEquals(true, (storeLocationDBRec.Display_Hours__c).contains('CLOSED'), 'Holiday Hours should override week hours in Display');
        
        Test.stopTest();
    }
    
    @isTest static void testAutoPopulateFieldsDisplayHoursWithoutHolidayHours() {
        Account storeLocationRecord = new Account(
            Name = 'Test Name',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Store').getRecordTypeId(),
            Address_Line_1__c = 'Test Address',
            Address_Line_2__c = 'Test Address2',
            City__c = 'Test City',
            State__c = 'Test State',
            ZIP__c = 'Test Zip', 
            Monday_Hours__c = 'Monday 10:00 - 22:00',
            Tuesday_Hours__c = 'Tuesday 10:00 - 22:00',
            Wednesday_Hours__c = 'Wednesday 10:00 - 22:00',
            Thursday_Hours__c = 'Thursday 10:00 - 22:00',
            Friday_Hours__c = 'Friday 10:00 - 22:00',
            Saturday_Hours__c = 'Saturday 10:00 - 22:00',
            Sunday_Hours__c = 'Sunday 10:00 - 22:00',
            
            Holiday_Hours__c = ''
        );
        
        Test.startTest();
        insert storeLocationRecord;
        Id recId = storeLocationRecord.Id;
        Account storeLocationDBRec = [SELECT Id, Display_Hours__c FROM Account WHERE Id =:recId];
        System.assertEquals(true, !String.isBlank(storeLocationDBRec.Display_Hours__c), 'Display Hours should display week hours stored in record');
        
        Test.stopTest();
    }
   */

}