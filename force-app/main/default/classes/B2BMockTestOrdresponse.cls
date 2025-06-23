@isTest
global class B2BMockTestOrdresponse implements HttpCalloutMock {
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
        res.setBody('{"root": {"Sales_Order_Details": {"Order_Id": "","Order_Status": "","Order_LineItems": {"item": [{"Order_LineItem_Number": 8378210,"PackingList_Id": 861351838,"Invoice": 131791539,"Exp_Del_Date": "2022-03-07","Carrier_Name": "SIG - AAA Cooper","Bill_Of_Lading": "","Tracking_Id": "","Tracking_URL": "","Line_Status": ""}]},"Status": "success","Details": "Ok"}}}');
      return res; 
    }
}