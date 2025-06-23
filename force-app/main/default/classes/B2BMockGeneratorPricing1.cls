@isTest
global class B2BMockGeneratorPricing1 implements HttpCalloutMock {
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
        res.setBody('{ "ZYSH_MD_MATERIAL_LISTING_WT": {"Status":"Success","Message":"","ET_ALLOWED_MATNR": {"item": [204944,204947,6529456]}}}');
       // res.setBody('{"ZYSH_PRICING_HYBRIS" : {"Status":"Success", "item" : [{"PRICE" : "5.93","CURRENCY" : "EUR","PRICE_UNIT" : "1","MATERIAL" : "000000000000819074" }]}}');
     
        return res; 
    }
}