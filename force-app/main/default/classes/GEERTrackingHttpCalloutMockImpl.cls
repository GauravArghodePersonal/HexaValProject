@isTest
global class GEERTrackingHttpCalloutMockImpl implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"records":[{"DeveloperName":"test","CcEmails":"test@test.com"}]}');
        res.setStatusCode(200);
        return res;
    }
}