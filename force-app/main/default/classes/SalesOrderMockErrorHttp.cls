@isTest
global class SalesOrderMockErrorHttp implements HttpCalloutMock{
global HTTPResponse respond(HTTPRequest req) {
    HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"ERR_MESSAGE" : "Error"}');
        res.setStatusCode(200);
        return res;
	}
}