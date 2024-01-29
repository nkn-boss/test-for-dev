@isTest
public class HttpMock implements HttpCalloutMock {
    
    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;
    protected Boolean isSuccess;
    
    public HttpMock(Integer code, String status, String body, Map<String, String> responseHeaders, Boolean isSuccess) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
        this.isSuccess = isSuccess;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        String exceptionMessage = 'Unauthorized endpoint, please check Setup->Security->Remote site settings.';
        
        if (this.isSuccess) {
            HttpResponse res = new HttpResponse();
            for (String key : this.responseHeaders.keySet()) {
                res.setHeader(key, this.responseHeaders.get(key));
            }
            res.setBody(this.body);
            res.setStatusCode(this.code);
            res.setStatus(this.status);
            return res;
        } else {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage(exceptionMessage);
            throw e;
        }
    }
}