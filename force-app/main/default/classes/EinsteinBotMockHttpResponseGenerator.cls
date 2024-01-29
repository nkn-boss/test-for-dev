@isTest
global class EinsteinBotMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"messages":[{"type":"Availability", "message":{"results":[{"estimatedWaitTime":-1,"id":"5733N00000000Nj","isAvailable":true}]}}]}');
        res.setStatusCode(200);
        return res;
    }
}