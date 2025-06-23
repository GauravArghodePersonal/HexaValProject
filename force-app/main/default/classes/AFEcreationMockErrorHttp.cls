@isTest
global class AFEcreationMockErrorHttp implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"MESSAGE":"Error"}');
        res.setStatusCode(200);
        return res;
    }
}