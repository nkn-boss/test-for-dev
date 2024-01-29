@isTest
public class EinsteinBotEstimatedWaitTimeHandlerTest {
     @isTest static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new EinsteinBotMockHttpResponseGenerator());
        List<Integer> estWaitTimeList = EinsteinBotEstimatedWaitTimeHandler.makeGetCallout(new LIst<String>{'5733N00000000Nj'});
        System.assertEquals(estWaitTimeList.get(0),-1,'Get Estimated wait time');
    }

}