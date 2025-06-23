@isTest
global class B2BMockTestBOLPdf implements HttpCalloutMock {
    global HTTPResponse respond(HttpRequest request) {
        request = new HttpRequest();
        request.setEndpoint('https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate');
    request.setMethod('GET');
    request.setBody('Test');
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf('solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee');
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
                
        // Created test response
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
      res.setStatusCode(200);
        res.setBody('{"Delivery_BOL_PL_Details" : {"Doc_Name" : "PL / BOL Doc","Binary_Data" :"Output from BAPI Encoded Binary Value","Status" : "Success","Msg" : "Okay"}}');
                    return res; 
    }
}