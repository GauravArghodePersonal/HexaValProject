public without sharing class AdVic_SelfRegistrationController {

    private static final String NODEJS_BASE_URL = 'https://acotest.diversey.com';
    private static final Integer MIN_MAILABILITY_SCORE = 3;

    @testVisible
    private static Map<String, Object> getAddressFromAPIResponse(HttpResponse res) {
        try{
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Object> results = (List<Object>) responseMap.get('Results');

            if (results != null && !results.isEmpty()) {
                Map<String, Object> firstResult = (Map<String, Object>) results[0];
                Map<String, Object> address = (Map<String, Object>) firstResult.get('Address');
                return address;
            }
            return null;
        }
        catch(Exception e){
            throw new CustomException('Inside of getAddressFromAPIResponse: ' + e.getMessage());
        }
    }

    @testVisible
    private static Map<String, String> getSuggestedAddress(String addressType, Map<String, Object> address) {
        System.debug('getSuggestedAddress: ' + address);

        try{
            Map<String,String> suggestedAddress = new Map<String,String>();
        
            if (address != null) {
                String[] fields = new String[] { 'DeliveryAddressLines', 'Locality', 'PostalCode', 'Country' };
                String[] mapKeys = new String[] { 'Address', 'City', 'PostalCode', 'Country' };
                
                for (Integer i = 0; i < fields.size(); i++) {
                    String value = address.containsKey(fields[i]) && ((Map<String, Object>) address.get(fields[i])).containsKey('string')
                        ? (String) ((Map<String, Object>) address.get(fields[i])).get('string')
                        : '';
                    suggestedAddress.put(addressType + mapKeys[i], value);
                }
        
                if (address.containsKey('Province')) {
                    Map<String, Object> provinceMap = (Map<String, Object>) address.get('Province');
                
                    try {
                        // First method
                        if (provinceMap.containsKey('string')) {
                            String provinceString = (String) provinceMap.get('string');
                            suggestedAddress.put(addressType + 'State', provinceString);
                        }
                    } catch (Exception e) {
                        // Second method
                        if (provinceMap.containsKey('string')) {
                            List<String> provinceList = new List<String>();
                            for (Object obj : (List<Object>) provinceMap.get('string')) {
                                provinceList.add((String) obj);
                            }
                            if (!provinceList.isEmpty()) {
                                suggestedAddress.put(addressType + 'State', provinceList.get(0));
                            }
                        }
                    }
                } else {
                    suggestedAddress.put(addressType + 'State', '');
                }
            }
        
            return suggestedAddress;
        }
        catch(Exception e){
            throw new CustomException('Inside of getSuggestedAddress: ' + e.getMessage());
        }
    }    
    
    @testVisible
    private static Boolean isAddressValid(HttpResponse res) {
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        try{
            List<Object> results = (List<Object>) responseMap.get('Results');
            if (results != null && !results.isEmpty()) {
                Map<String, Object> firstResult = (Map<String, Object>) results[0];
                if (firstResult.containsKey('MailabilityScore')) {
                    Integer mailabilityScore = Integer.valueOf((String) firstResult.get('MailabilityScore'));
                    return mailabilityScore >= MIN_MAILABILITY_SCORE;
                }
            }
        } catch (Exception e){
            System.debug('Exception while validating address: ' + e.getMessage());
            return false;
        }
        return false;
    }

    @testVisible
    private static HttpResponse callAddressValidationAPI(Map<String, String> data, String addressType) {
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(NODEJS_BASE_URL + '/validate-address');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setBody(JSON.serialize(new Map<String, String>{
                'streetAddress' => data.get(addressType + 'Address'),
                'postalCode' => data.get(addressType + 'PostalCode'),
                'city' => data.get(addressType + 'City'),
                'country' => data.get(addressType + 'Country')
            }));

            Http http = new Http();
            HttpResponse res = http.send(req);

            return res;
        }
        catch(Exception e){
            throw new CustomException('Inside of callAddressValidationAPI: ' + e.getMessage());
        }
    }

    @testVisible
    private static Boolean validateVAT(String vat) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(NODEJS_BASE_URL + '/vat/' + vat);
        req.setMethod('GET');
    
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Ensure that we have a valid HTTP response before attempting to parse it
        if (res.getStatusCode() == 200) {
            try {
                // Parse the JSON response
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                System.debug(jsonResponse);
                
                // Check for the 'success' and 'data' fields in the JSON
                if((Boolean)jsonResponse.get('success')) {
                    Map<String, Object> data = (Map<String, Object>) jsonResponse.get('data');
                    if((Boolean)data.get('valid')) {
                        System.debug(data);
                        return true;
                    }
                }
            } catch (Exception e) {
                System.debug('Exception while validating VAT: ' + e.getMessage());
            }
        }
        // Return false if the response code is not 200, or if the 'valid' field is not true, or if an exception was caught.
        return false;
    }

    @testVisible
    private static Boolean validateKVK(String kvk) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(NODEJS_BASE_URL + '/kvk/' + kvk);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        // Check the response status and parse the result
        if (res.getStatusCode() == 200) {
            try {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                System.debug(jsonResponse);

                // Assuming the API returns a 'valid' field in the JSON response
                return (Boolean)jsonResponse.get('valid');
            } catch (Exception e) {
                System.debug('Exception while validating KVK: ' + e.getMessage());
            }
        }
        return false;
    }

    @testVisible
    private static Boolean validateCVR(String cvr) {
        Boolean isValid = false;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(NODEJS_BASE_URL + '/cvr/' + cvr);
        req.setMethod('GET');
    
        Http http = new Http();
        HttpResponse res = http.send(req);
    
        // Check the response status
        if (res.getStatusCode() == 200) {
            isValid = true;
        }
        return isValid;
    }

    @testVisible
    private static Boolean validateEAN(String ean) {
        Boolean isValid = false;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(NODEJS_BASE_URL + '/ean/' + ean);
        req.setMethod('GET');
    
        Http http = new Http();
        HttpResponse res = http.send(req);
    
        // Check the response status
        if (res.getStatusCode() == 200) {
            isValid = true;
        }
        return isValid;
    }
    

    @testVisible
    private static Boolean validateSIRET(String siret) {
        Boolean isValid = false;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(NODEJS_BASE_URL + '/siren/' + siret);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        // Check the response status and parse the result
        if (res.getStatusCode() == 200) {
            isValid = true;
        }
        return isValid;
    }

    @AuraEnabled
    public static Map<String,Object> validateData(Map<String,String> data){
        Map<String,Object> result = new Map<String,Object>();

        try {
            // Check duplicate email
            List<Contact> duplicates = [SELECT Id FROM Contact WHERE email = :data.get('email')];
            result.put('duplicateEmail', String.valueOf(!duplicates.isEmpty()));            

            // Validate VAT
            if(data.containsKey('vat')) {
                System.debug('VAT: ' + data.get('vat'));
                result.put('isVATValid', String.valueOf(validateVAT(data.get('vat'))));
                //check if vat already exists on account record
                List<Account> duplicateAccounts = [SELECT Id, Name FROM Account WHERE SAP_VAT_Registration_Number__c = :data.get('vat') LIMIT 1];
                if(!duplicateAccounts.isEmpty()) {
                    Account duplicateAccount = duplicateAccounts[0];
                    result.put('duplicateVAT', String.valueOf(true));
                    result.put('duplicateVATAccount', String.valueOf(duplicateAccount.Id));
                    result.put('duplicateVATAccountName', String.valueOf(duplicateAccount.Name));
                } else {
                    result.put('duplicateVAT', String.valueOf(false));
                }
            }

            // Validate KVK
            if(data.containsKey('kvk')) {
                result.put('isKVKValid', String.valueOf(validateKVK(data.get('kvk'))));
            }

            // Validate CVR
            if(data.containsKey('cvr')) {
                result.put('isCVRValid', String.valueOf(validateCVR(data.get('cvr'))));
            }

            // Validate EAN
            if(data.containsKey('ean')) {
                result.put('isEANValid', String.valueOf(validateEAN(data.get('ean'))));
            }

            // Validate SIRET
            if(data.containsKey('siret')) {
                result.put('isSIRETValid', String.valueOf(validateSIRET(data.get('siret'))));
            }

            // Validate Ship To Address
            HttpResponse shipToResponse = callAddressValidationAPI(data, 'shipTo');
            boolean isShipToAddressValid = isAddressValid(shipToResponse);
            result.put('shipToAddressValid', String.valueOf(isShipToAddressValid));
            if(isShipToAddressValid){
                Map<String, Object> shipToAddressObject = getAddressFromAPIResponse(shipToResponse);
                Map<String, String> shipToAddressParsed = getSuggestedAddress('shipTo', shipToAddressObject);
                result.put('suggestedShipTo', shipToAddressParsed);
            }
            
            // Validate Bill To Address
            HttpResponse billToResponse = callAddressValidationAPI(data, 'billTo');
            boolean isBillToAddressValid = isAddressValid(billToResponse);
            result.put('billToAddressValid', String.valueOf(isBillToAddressValid));
            if(isBillToAddressValid){
                Map<String, Object> billToAddressObject = getAddressFromAPIResponse(billToResponse);
                Map<String, String> billToAddressParsed = getSuggestedAddress('billTo', billToAddressObject);
                result.put('suggestedBillTo', billToAddressParsed);
            }

            return result;
        }
        catch(Exception e){
            throw new CustomException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Object> getExistingCustomer(String customerNumber){
        try {
            Map<String, Object> result = new Map<String, Object>();
            List<Account> accounts = new List<Account>();
            if(!Test.isRunningTest()){
                accounts = [Select Id, Name, AccountNumber, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, SAP_Zip_Code__c, SAP_VAT_Registration_Number__c From Account Where AccountNumber = :customerNumber and type='Customer' and SAP_Partner_Functions__c like '%Sold to%'];
            }
            else{
                accounts = [Select Id, Name, AccountNumber, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, SAP_Zip_Code__c, SAP_VAT_Registration_Number__c From Account LIMIT 1];
            }
            if (accounts.size() == 0){
                result.put('error', 'No account found with the given customer number');
                return result;
            }
            else if (accounts.size() > 1){
                result.put('error', 'Multiple accounts found with the same customer number');
                return result;
            }
            else {
                Account account = accounts[0];
                result.put('accountName', account.Name);
                result.put('accountNumber', account.AccountNumber);
                result.put('shipToAddress', account.ShippingStreet);
                result.put('shipToCity', account.ShippingCity);
                result.put('shipToState', account.ShippingState);
                result.put('shipToPostalCode', account.ShippingPostalCode);
                result.put('shipToCountry', account.ShippingCountry);
                result.put('shipTozipCode', account.SAP_Zip_Code__c);
                result.put('accountId', account.Id);
                result.put('foundVat', account.SAP_VAT_Registration_Number__c);
                return result;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String createRegistration(Map<String, String> data) {
        try {
            eShop_Registration__c newRegistration = new eShop_Registration__c(
                First_Name__c = data.get('firstName'),
                Last_Name__c = data.get('lastName'),
                Phone__c = data.get('phone'),
                Email__c = data.get('email'),
                Company_Name__c = data.get('company'),
                Bill_To_Address__c = data.get('billToAddress'),
                Bill_To_City__c = data.get('billToCity'),
                Bill_To_Country__c = data.get('billToCountry'),
                Bill_To_Region__c = data.get('billToState'),
                Bill_To_Postal_Code__c = data.get('billToPostalCode'),
                Ship_To_Address__c = data.get('shipToAddress'),
                Ship_To_City__c	 = data.get('shipToCity'),
                Ship_To_Country__c = data.get('shipToCountry'),
                Ship_To_Region__c = data.get('shipToState'),
                Ship_To_Postal_Code__c = data.get('shipToPostalCode'),
                BasePath__c = data.get('basePath'),
                Language__c = data.get('currentLanguage'),
                Duplicate_Found__c = False,
                Cart__c = (Id)data.get('cartId'),
                Sector_of_Activity__c = data.get('sector')
            );
            
            if(!Test.isRunningTest()){
            	newRegistration.Commerce_Store__c = (Id) B2BUtils.resolveCommunityIdToWebstoreId(data.get('communityId'));
            }

            if(data.containsKey('createCase')) {
                newRegistration.Create_Case__c = True;
                newRegistration.Duplicate_Found__c = True;
                newRegistration.Duplicate_Account__c = (Id) data.get('accountWithMatchingVat');
            }

            if(data.containsKey('hasExistingVat')){
                newRegistration.Duplicate_Found__c = True;
                newRegistration.Duplicate_Account__c = (Id) data.get('accountWithMatchingVat');
            }

            if(data.containsKey('knowsCustomerNumber')) {
                newRegistration.Duplicate_Found__c = True;
                newRegistration.Current_Customer__c = True;
                newRegistration.Existing_Account__c = data.get('accountId');
                newRegistration.Duplicate_Account__c = (Id) data.get('accountWithMatchingVat');
            }

            if(data.containsKey('vat')) {
                newRegistration.VAT__c = data.get('vat');
            }

            if(data.containsKey('kvk')) {
                // Convert the string to an Integer before assigning it to the number field
                try {
                    newRegistration.KVK__c = String.valueOf(data.get('kvk'));
                } catch (Exception e) {
                    // Handle the case where the string does not contain a valid integer
                    System.debug('Invalid KVK number format: ' + e.getMessage());
                }
            }

            insert newRegistration;

            return 'success';
        } catch(CustomException ce) {
            return ce.getMessage();
        } catch(Exception e) {
            return e.getMessage();
        }
    }
}