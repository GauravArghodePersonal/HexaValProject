@isTest
global class B2BMockTestSDSresponse implements HttpCalloutMock {
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
        res.setBody('{"PT_DOC_KEYS": [{"LANGU": "E","DOCKEY": "SBRWWI-00000000000009279408 00000","GENVAR": "SDSGHS_AR","FILESIZE": "79431","FILETYPE": "PD","RECN_DH": "00000000000022875045","ACTN_DH": "00000000000000000000","MATNR": "000000000000083808","VERSION": "00002","SUBVERSION": "00001","PRODUCT_NAME": "Advantage Plus™ 1465 deposit inhibitor","REPTYPE": "MSDS" }],"PT_MSDS_BLOB": "1","PO_FILESIZE": "0","PO_SUBID": "R0370019"}');
                    return res; 
    }
}