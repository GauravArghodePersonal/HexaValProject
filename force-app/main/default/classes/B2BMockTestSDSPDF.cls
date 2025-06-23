@isTest
global class B2BMockTestSDSPDF implements HttpCalloutMock {
    global HTTPResponse respond(HttpRequest request) {
        request = new HttpRequest();
        request.setEndpoint('test');
    request.setMethod('GET');
    request.setBody('Test');
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf('test:test');
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
                
        // Created test response
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
      res.setStatusCode(200);
        res.setBody('{"PT_MSDS_BLOB": "1","PO_BIN": "Test","PO_FILESIZE": "331066","PO_FILETYPE": "WWI"}');
                    return res; 
    }
}