@isTest
global class AFEcreationMockHttp implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"E_SUCCESS" : "X","E_TRACKING_NUMBER" : "fR-275","E_ZINSTANCE" : "005056B503761EEC819B4E45C5F9B841"}');
        res.setStatusCode(200);
        return res;
    }
}