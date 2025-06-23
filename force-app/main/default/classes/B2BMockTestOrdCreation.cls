@isTest
global class B2BMockTestOrdCreation implements HttpCalloutMock {
    global HTTPResponse respond(HttpRequest request) {
       // request = new HttpRequest();
        system.debug('request End point-->'+request.getEndpoint());
     //   request.setEndpoint('https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate');
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
        if(request.getEndpoint().endsWith('upsertCustomerUpdate'))
        {
      //  res.setBody('{"Order_Creation_Response_Details": {"Order_Status": "Success","Message": "test","Order_Number": "21212","Line_Order_Details":{"Item":[{"Line_Order_Id":"000010","Material_Code":"12","Material_Name":"tests"}]}}}');
              res.setBody('{"Order_Creation_Response_Details":{"SAP_Order_Status" : "Success", "SAP_Message" : "Thanks for Ordering","SAP_Order_Number" : "0008666230","SFDC_Order_Number" : "00015624","Line_Order_Details" : {"Item" : [{"SAP_Line_Order_Id" : "000010","SAP_Material_Code" : "000000000000251516","SAP_Material_Name" : "AS ENZYPURE 12X1QT"}]}}}');
        }
               if(request.getEndpoint().endsWith('Failure'))
        {
      //  res.setBody('{"Order_Creation_Response_Details": {"Order_Status": "Success","Message": "test","Order_Number": "21212","Line_Order_Details":{"Item":[{"Line_Order_Id":"000010","Material_Code":"12","Material_Name":"tests"}]}}}');
              res.setBody('{"Order_Creation_Response_Details":{"SAP_Order_Status" : "Failure", "SAP_Message" : "Thanks for Ordering","SAP_Order_Number" : "0008666230","SFDC_Order_Number" : "00015624","Line_Order_Details" : {"Item" : [{"SAP_Line_Order_Id" : "000010","SAP_Material_Code" : "000000000000251516","SAP_Material_Name" : "AS ENZYPURE 12X1QT"}]}}}');
        }
                if(request.getEndpoint().endsWith('Waiting for Confirmation'))
        {
      //  res.setBody('{"Order_Creation_Response_Details": {"Order_Status": "Success","Message": "test","Order_Number": "21212","Line_Order_Details":{"Item":[{"Line_Order_Id":"000010","Material_Code":"12","Material_Name":"tests"}]}}}');
              res.setBody('{"Order_Creation_Response_Details":{"SAP_Order_Status" : "Waiting for Confirmation", "SAP_Message" : "Thanks for Ordering","SAP_Order_Number" : "0008666230","SFDC_Order_Number" : "00015624","Line_Order_Details" : {"Item" : [{"SAP_Line_Order_Id" : "000010","SAP_Material_Code" : "000000000000251516","SAP_Material_Name" : "AS ENZYPURE 12X1QT"}]}}}');
        }
              if(request.getEndpoint().endsWith('Data_or_Connection_Issue'))
        {
      //  res.setBody('{"Order_Creation_Response_Details": {"Order_Status": "Success","Message": "test","Order_Number": "21212","Line_Order_Details":{"Item":[{"Line_Order_Id":"000010","Material_Code":"12","Material_Name":"tests"}]}}}');
              res.setBody('{"Order_Creation_Response_Details":{"SAP_Order_Status" : "Data_or_Connection_Issue", "SAP_Message" : "Thanks for Ordering","SAP_Order_Number" : "0008666230","SFDC_Order_Number" : "00015624","Line_Order_Details" : {"Item" : [{"SAP_Line_Order_Id" : "000010","SAP_Material_Code" : "000000000000251516","SAP_Material_Name" : "AS ENZYPURE 12X1QT"}]}}}');
        }
        
        return res; 
    }
}