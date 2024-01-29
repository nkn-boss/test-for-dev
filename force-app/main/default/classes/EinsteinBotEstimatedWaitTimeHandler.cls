/**
 * @Project : Primark
 * @Author  : Kevin Snell
 * @Date    : 04/05/2022
 * @description : Check Estimate Wait Times for a Customer before transferring to a queue to connect to an agent.
 * ************************************************************************************************
 * Name                       Date            Comments
 * Devendra Villa(EPAM)       26-DEC-22       CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
 */
public class EinsteinBotEstimatedWaitTimeHandler {
	@InvocableMethod(label = 'Get Estimated Wait Time')
	/**
    * @description  : Calling function which called from all the other apex classes from the catch block
    * @author       : Kevin Snell
    * @param      ids to get ids
    * @return       : List
**/
    public static List<Integer> makeGetCallout(List<String> ids) {
		Integer estimatedWaitTime;
        estimatedWaitTime = 0;
		Http http = new Http();
		HttpRequest request = new HttpRequest();
        Live_Agent_Estimated_Wait_Time__mdt liveAgentValues = Live_Agent_Estimated_Wait_Time__mdt.getInstance('CustomerSupport');
        String endpointBaseUrl = liveAgentValues.Endpoint__c;
        String orgId = liveAgentValues.OrgID__c;
        String deploymentId = liveAgentValues.DeploymentId__c;
        String endpoint = endpointBaseUrl +'/chat/rest/Visitor/Availability?org_id='+orgId+'&deployment_id='+deploymentId+'&Availability.needEstimatedWaitTime=1&Availability.ids=' +ids[0];
        //System.debug(endpointBaseUrl); CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
		request.setEndpoint(endpoint);
		request.setHeader('X-LIVEAGENT-API-VERSION', '50');
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		//system.debug('Estimated Wait Time - raw data: ');CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
		//System.debug(response.getBody());CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer
		JSONParser parser = JSON.createParser(response.getBody());
		while (parser.nextToken() != null) {
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'estimatedWaitTime')) {
				// Get the value.
				parser.nextToken();
				estimatedWaitTime = parser.getIntegerValue();
			}
		}
		/*system.debug('Estimated Wait Time - return value: ' +
		estimatedWaitTime);CRM-619 as part of the Code Refactoring for Salesforce Code Analyzer*/
		return new List<integer>{estimatedWaitTime};
	}
}