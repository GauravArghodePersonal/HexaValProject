@isTest
global class SalesOrderMockHttp implements HttpCalloutMock{
global HTTPResponse respond(HTTPRequest req) {
    HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"SALESDOCUMENT" : "0008356222"}');
        res.setStatusCode(200);
        return res;
	}
}