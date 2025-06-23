@isTest
global class AdVic_SelfRegistrationMockResponses implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse response = new HttpResponse();
        
        if(req.getEndpoint().contains('validate-address')){
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"StatusCode":"100","StatusMessage":"OK","JobToken":"1b1aa18d-17bf-40e9-a917-a4390abcdb32","Results":[{"ResultNumber":"1","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"1-19"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2621"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"1-19 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2621"},"FormattedAddress":{"string":["1-19 RUSSELL ST","BEVERLY MA 01915-2621","UNITED STATES"]},"AddressComplete":"1-19 RUSSELL ST;BEVERLY MA 01915-2621;UNITED STATES"}},{"ResultNumber":"2","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"2-4"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2622"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"2-4 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2622"},"FormattedAddress":{"string":["2-4 RUSSELL ST","BEVERLY MA 01915-2622","UNITED STATES"]},"AddressComplete":"2-4 RUSSELL ST;BEVERLY MA 01915-2622;UNITED STATES"}},{"ResultNumber":"3","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"20-99"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2634"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"20-99 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2634"},"FormattedAddress":{"string":["20-99 RUSSELL ST","BEVERLY MA 01915-2634","UNITED STATES"]},"AddressComplete":"20-99 RUSSELL ST;BEVERLY MA 01915-2634;UNITED STATES"}},{"ResultNumber":"4","MailabilityScore":"1","ResultPercentage":"72.09","ElementInputStatus":"60600050300000000060","ElementResultStatus":"F8F088E03000000000E0","ElementRelevance":"11101010100000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Street":{"string":"RUSSELL ST"},"HouseNumber":{"string":"6-16"},"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2633"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"DeliveryAddressLines":{"string":"6-16 RUSSELL ST"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2633"},"FormattedAddress":{"string":["6-16 RUSSELL ST","BEVERLY MA 01915-2633","UNITED STATES"]},"AddressComplete":"6-16 RUSSELL ST;BEVERLY MA 01915-2633;UNITED STATES"}},{"ResultNumber":"5","MailabilityScore":"1","ResultPercentage":"8.00","ElementInputStatus":"60600010100000000060","ElementResultStatus":"F8F088606000000000E0","ElementRelevance":"11101000000000000010","ExtElementStatus":"00000000000000000000","AddressResolutionCode":"00000000300000000000","AddressType":"S","LanguageISO3":"ENG","Address":{"Locality":{"string":"BEVERLY"},"PostalCode":{"string":"01915-2634"},"Province":{"string":["MA","ESSEX"]},"Country":{"string":"UNITED STATES"},"CountrySpecificLocalityLine":{"string":"BEVERLY MA 01915-2634"},"FormattedAddress":{"string":["BEVERLY MA 01915-2634","UNITED STATES"]},"AddressComplete":"BEVERLY MA 01915-2634;UNITED STATES"}}]}');
            response.setStatusCode(200);
        }
        
        if(req.getEndpoint().contains('vat')){
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"success":true,"code":200,"data":{"valid":true,"company":{"vat_number":"23226393","country_code":"RO","company_name":"SOFTESCU SRL","company_address":"MUN. BACĂU 600192 BLD. UNIRII Nr. 30 Et. 4"}}}');
            response.setStatusCode(200);
        }
        
        if(req.getEndpoint().contains('kvk')){
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status":"success","data":{"fout":[{"code":"IPD0004","omschrijving":"Het KVK-nummer RO23226393 is niet valide."}]}}');
            response.setStatusCode(200);
        }
        
        if(req.getEndpoint().contains('ean')){
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status":"success","data":{"fout":[{"code":"IPD0004","omschrijving":"Het KVK-nummer RO23226393 is niet valide."}]}}');
            response.setStatusCode(200);
        }
        
        if(req.getEndpoint().contains('cvr')){
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status":"success","data":{"fout":[{"code":"IPD0004","omschrijving":"Het KVK-nummer RO23226393 is niet valide."}]}}');
            response.setStatusCode(200);
        }
        
        if(req.getEndpoint().contains('siren')){
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status":"success","data":{"fout":[{"code":"IPD0004","omschrijving":"Het KVK-nummer RO23226393 is niet valide."}]}}');
            response.setStatusCode(200);
        }
        
        return response;
    }
}