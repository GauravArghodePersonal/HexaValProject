@isTest
private class AdVic_SelfRegistrationControllerTest {

    @isTest static void validateDataTest() {
        Test.setMock(HttpCalloutMock.class, new AdVic_SelfRegistrationMockResponses());
        // Prepare test data
        Map<String, String> formData = new Map<String, String>{
            'firstName' => 'Test',
            'lastName' => 'User',
            'phone' => '123456789',
            'email' => 'testuser@example.com',
            'billToAddress' => 'Main St',
            'billToCity' => 'Metropolis',
            'billToCountry' => 'USA',
            'billToState' => 'NY',
            'billToPostalCode' => '10001',
            'shipToAddress' => 'Second St',
            'shipToCity' => 'Gotham',
            'shipToCountry' => 'USA',
            'shipToState' => 'NY',
            'shipToPostalCode' => '10002',
            'vat' => '123',
            'kvk' => '123'
        };
        
        // Execute test
        Test.startTest();
        Map<String, Object> response = AdVic_SelfRegistrationController.validateData(formData);
        Test.stopTest();
        
        // Verify test
        System.assertNotEquals(null, response, 'The response should not be null');
    }
    
    @isTest static void createRegistrationTest(){
        
        WebStore ws = new Webstore();
        ws.Name = 'demoStore';
        insert ws;
        
        String webStoreId = [SELECT Id FROM WebStore WHERE Name = 'demoStore' LIMIT 1].id;
        
         Account testAccount = new Account(
            Name = 'Test Account',
            AccountNumber = '12345',
            ShippingStreet = '123 Test Lane',
            ShippingCity = 'Testville',
            ShippingState = 'TestState',
            ShippingPostalCode = '12345',
            ShippingCountry = 'TestCountry',
            SAP_Zip_Code__c = '12345',
            SAP_VAT_Registration_Number__c = 'VAT12345',
            type = 'Customer',
            SAP_Partner_Functions__c = 'Sold to'
        );

        insert testAccount;
        
        Map<String, String> formData = new Map<String, String>{
            'firstName' => 'Test',
            'lastName' => 'User',
            'phone' => '123456789',
            'email' => 'testuser@example.com',
            'billToAddress' => 'Main St',
            'billToCity' => 'Metropolis',
            'billToCountry' => 'USA',
            'billToState' => 'NY',
            'billToPostalCode' => '10001',
            'shipToAddress' => 'Second St',
            'shipToCity' => 'Gotham',
            'shipToCountry' => 'USA',
            'shipToState' => 'NY',
            'shipToPostalCode' => '10002',
            'vat' => '123',
            'kvk' => '123',
            'communityId' => webStoreId,
            'basePath' => 'basePathTest',
            'currentLanguage' => 'En_GB',
            'isDuplicate' => 'true',
            'createCase' => 'true',
            'hasExistingVat' => 'true',
           	'knowsCustomerNumber' => 'true',
            'accountWithMatchingVat' => testAccount.id,
            'accountId' => '123'
        };
            
        String response = AdVic_SelfRegistrationController.createRegistration(formData);
        
        System.assertNotEquals(null, response, 'The response should not be null');
    }

    @isTest static void getSuggestedAddressTest() {
        // Setup - create a mock address map
        Map<String, Object> address = new Map<String, Object>();
        address.put('Street', new Map<String, Object>{'string' => '123 Main St'});
        address.put('HouseNumber', new Map<String, Object>{'string' => '123'});
        address.put('Locality', new Map<String, Object>{'string' => 'Downtown'});
        address.put('PostalCode', new Map<String, Object>{'string' => '12345'});
        address.put('Country', new Map<String, Object>{'string' => 'Wonderland'});
        address.put('Province', new Map<String, Object>{'string' => new List<Object>{'StateVille'}});

        // Call the method
        Map<String, String> response = AdVic_SelfRegistrationController.getSuggestedAddress('', address);

       	System.assertNotEquals(null, response, 'The response should not be null');
    }
    
    @isTest static void isAddressValidTest() {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"StatusCode":"100","StatusMessage":"OK","JobToken":"1b1aa18d-17bf-40e9-a917-a4390abcdb32","Results":[{"ResultNumber":"1","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"1-19"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2621"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"1-19 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2621"},"FormattedAddress":{"string":["1-19 RUSSELL ST","BEVERLY MA 01915-2621","UNITED STATES"]},"AddressComplete":"1-19 RUSSELL ST;BEVERLY MA 01915-2621;UNITED STATES"}},{"ResultNumber":"2","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"2-4"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2622"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"2-4 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2622"},"FormattedAddress":{"string":["2-4 RUSSELL ST","BEVERLY MA 01915-2622","UNITED STATES"]},"AddressComplete":"2-4 RUSSELL ST;BEVERLY MA 01915-2622;UNITED STATES"}},{"ResultNumber":"3","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"20-99"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2634"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"20-99 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2634"},"FormattedAddress":{"string":["20-99 RUSSELL ST","BEVERLY MA 01915-2634","UNITED STATES"]},"AddressComplete":"20-99 RUSSELL ST;BEVERLY MA 01915-2634;UNITED STATES"}},{"ResultNumber":"4","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"6-16"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2633"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"6-16 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2633"},"FormattedAddress":{"string":["6-16 RUSSELL ST","BEVERLY MA 01915-2633","UNITED STATES"]},"AddressComplete":"6-16 RUSSELL ST;BEVERLY MA 01915-2633;UNITED STATES"}},{"ResultNumber":"5","MailabilityScore":"1","ResultPercentage":"8.00","ElementInputStatus":"60600010100000000060","ElementResultStatus":"F8F088606000000000E0","ElementRelevance":"11101000000000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2634"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2634"},"FormattedAddress":{"string":["BEVERLY MA 01915-2634","UNITED STATES"]},"AddressComplete":"BEVERLY MA 01915-2634;UNITED STATES"}}]}');
        response.setStatusCode(200);
        Boolean res = AdVic_SelfRegistrationController.isAddressValid(response);
        System.assert(!res, 'The response should be true indicating the address is valid.');
    }
    
    @isTest static void getAddressFromAPIResponseTest() {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"StatusCode":"100","StatusMessage":"OK","JobToken":"1b1aa18d-17bf-40e9-a917-a4390abcdb32","Results":[{"ResultNumber":"1","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"1-19"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2621"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"1-19 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2621"},"FormattedAddress":{"string":["1-19 RUSSELL ST","BEVERLY MA 01915-2621","UNITED STATES"]},"AddressComplete":"1-19 RUSSELL ST;BEVERLY MA 01915-2621;UNITED STATES"}},{"ResultNumber":"2","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"2-4"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2622"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"2-4 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2622"},"FormattedAddress":{"string":["2-4 RUSSELL ST","BEVERLY MA 01915-2622","UNITED STATES"]},"AddressComplete":"2-4 RUSSELL ST;BEVERLY MA 01915-2622;UNITED STATES"}},{"ResultNumber":"3","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"20-99"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2634"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"20-99 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2634"},"FormattedAddress":{"string":["20-99 RUSSELL ST","BEVERLY MA 01915-2634","UNITED STATES"]},"AddressComplete":"20-99 RUSSELL ST;BEVERLY MA 01915-2634;UNITED STATES"}},{"ResultNumber":"4","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"6-16"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2633"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"6-16 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2633"},"FormattedAddress":{"string":["6-16 RUSSELL ST","BEVERLY MA 01915-2633","UNITED STATES"]},"AddressComplete":"6-16 RUSSELL ST;BEVERLY MA 01915-2633;UNITED STATES"}},{"ResultNumber":"5","MailabilityScore":"1","ResultPercentage":"8.00","ElementInputStatus":"60600010100000000060","ElementResultStatus":"F8F088606000000000E0","ElementRelevance":"11101000000000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2634"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2634"},"FormattedAddress":{"string":["BEVERLY MA 01915-2634","UNITED STATES"]},"AddressComplete":"BEVERLY MA 01915-2634;UNITED STATES"}}]}');
        response.setStatusCode(200);
        Map<String, Object> res = AdVic_SelfRegistrationController.getAddressFromAPIResponse(response);
        System.assertNotEquals(null, res, 'The response should not be null');
    }
    
    @isTest static void validateCVRTest(){
        Test.setMock(HttpCalloutMock.class, new AdVic_SelfRegistrationMockResponses());
        Test.startTest();
        Boolean res = AdVic_SelfRegistrationController.validateCVR('123');
        Test.stopTest();
        System.assert(res, 'The response should be true indicating valid.');
    }
    @isTest static void validateEANTest(){
        Test.setMock(HttpCalloutMock.class, new AdVic_SelfRegistrationMockResponses());
        Test.startTest();
        Boolean res = AdVic_SelfRegistrationController.validateEAN('123');
        Test.stopTest();
        System.assert(res, 'The response should be true indicating valid.');
    }
    @isTest static void validateSIRETest(){
        Test.setMock(HttpCalloutMock.class, new AdVic_SelfRegistrationMockResponses());
        Test.startTest();
        Boolean res = AdVic_SelfRegistrationController.validateSIRET('123');
        Test.stopTest();
        System.assert(res, 'The response should be true indicating valid.');
    }
    
    @isTest static void testGetExistingCustomer() {
        // Set up test data
        Account testAccount = new Account(
            Name = 'Test Account',
            AccountNumber = '12345',
            ShippingStreet = '123 Test Lane',
            ShippingCity = 'Testville',
            ShippingState = 'TestState',
            ShippingPostalCode = '12345',
            ShippingCountry = 'TestCountry',
            SAP_Zip_Code__c = '12345',
            SAP_VAT_Registration_Number__c = 'VAT12345',
            type = 'Customer',
            SAP_Partner_Functions__c = 'Sold to'
        );
        System.debug('Inserting account: ' + testAccount);
        insert testAccount;
        System.debug('Account inserted with ID: ' + testAccount.Id);

        // Test for scenario where exactly one account is found
        Test.startTest();
        Map<String, Object> result = AdVic_SelfRegistrationController.getExistingCustomer('12345');
        Test.stopTest();

        System.assertEquals('Test Account', result.get('accountName'), 'Account name should match');
    }
}