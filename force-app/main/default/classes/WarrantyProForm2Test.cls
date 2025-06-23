@isTest
private class WarrantyProForm2Test {
    @isTest
    static void testcreateWarrantyPro() {
        WarrantyProForm2.WarrantyProRequest request = new WarrantyProForm2.WarrantyProRequest();
        String attachmentData = EncodingUtil.base64Encode(Blob.valueOf('Test Attachment Data'));
        
        request.firstName = 'Test First Name';
        request.lastName = 'Test Last Name';
        request.email = 'test@example.com';
        request.formDate = Date.today();
        request.Products = 'Test Product';
        request.ZipCode = '12345';
        request.PurchaseFloater = 'Test Store';
        request.address = 'Test Address';
        request.attachmentData = EncodingUtil.base64Encode(Blob.valueOf('Test Attachment Data'));
        request.attachmentName = 'Test Attachment';
        
        // Mock the request and response
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(JSON.serialize(request));
        req.requestURI = '/services/apexrest/Warrantyproinfo2';
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        
        String result = WarrantyProForm2.createWarrantyPro();
        Test.stopTest();
        
        // Verify the result
        System.assertEquals('Successfully submitted form', result);
    }
}