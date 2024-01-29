/* Trigger handler Test class to check the primary contact exists on an account already*/
/* Author:Devendra Villa==> AUGUST-2022*/

@IsTest(SeeAllData = false)
class ContactTriggerHandlerTest {
    @IsTest
    static void testOncheckPrimaryContactHandler(){
        Contact[] con=TestDataFactory.createAccountsWithContacts(2,1);
        
        ContactTriggerHandler.onBefore(con);
        Contact[] con1=TestDataFactory.createAccountsWithContacts(2,2);
        ContactTriggerHandler.onBefore(con1);
        
    }

}