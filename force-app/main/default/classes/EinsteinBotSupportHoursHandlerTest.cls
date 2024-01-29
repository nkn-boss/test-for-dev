@isTest
public class EinsteinBotSupportHoursHandlerTest {
    @isTest
    static void testBusinessHours(){

        List<String> requestList = new List<String>();
        String req = 'Default';
        requestList.add(req);
        
        Test.startTest();
        List<Integer> responseList = EinsteinBotSupportHoursHandler.makeGetCallout(requestList);
        Test.stopTest();
        
        system.assert(responseList.size()>0, 'List is not Empty');
    }
}