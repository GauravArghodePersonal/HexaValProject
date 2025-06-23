/*****************************************************************
* Class Name     : B2BProductDetailController                            *
* Author         : Donald JP                                  	*
* Created Date   : 27-Mar-2022                                   *
* Modified Date  : 21-Apr-2021                                   *
* Description    : This is to get the product details and 
SDS document list from SAP*
*****************************************************************/


public without sharing class B2BProductDetailController {
    /**
* @description constructor
*/
    public B2BProductDetailController()
    {
    }
    /**
* @description get Product details
*/
    
    @AuraEnabled
    public static List<Product2> getProductdetails(String productID){
        try {
            
            List<Product2> productlist = new List<Product2>();
            productlist = [Select Id,Name,Description,ProductCode,Unit_of_Measure__c,Sales_Unit_Of_Mesure__c,Old_Material_Number__c From Product2 Where id = :productID ];
            
            if(productlist.size()>=0)
            {
                system.debug('Product List Found'+productlist);
                return productlist;
            }
            else {
                system.debug('Product Not Found');
                productlist=null;
                return productlist; 
            }
            
            // return !userList.isEmpty();
            
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            
            // return null;
        }
    }
    /**
* @description get SDS document list from SAP
*/
    @AuraEnabled
    public static String callWebServiceB2bSdsList(String recordId,String PI_LANGUAGE,String PI_MATERIAL) {
        system.debug('In Future method' + recordId);
        system.debug('PI_LANGUAGE' + PI_LANGUAGE);
        system.debug('PI_MATERIAL' + PI_MATERIAL);
        String message;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('PI_DOCTYPE','PDF');
        gen.writeStringField('PI_DOC_KEY','');
        gen.writeStringField('PI_GENERATION_VAR', '');
        gen.writeStringField('PI_LANGUAGE', 'E');
        gen.writeStringField('PI_MATERIAL',PI_MATERIAL);
        gen.writeStringField('PI_RECORD_NO_DOC', '');
        gen.writeStringField('PI_RETURN_BIN','X');
        gen.writeEndObject();
        system.debug('JSON String');
        system.debug('JSON String'+gen.getAsString());
        
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('B2BSDSDocument');
        String userName = px.username__c;
        system.debug('userName'+userName);
        String  password= px.password__c;
         system.debug('password'+password);
        String jsonBody = gen.getAsString();
        system.debug('jsonBody'+jsonBody);
        System.debug('jsonBody -- '+jsonBody);
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint(px.EndpointURL__c);
        request.setMethod('GET');
        request.setBody(jsonBody);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
        System.debug('request -- '+request);
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            System.debug('Success'+response.getStatusCode());
            System.debug('Reason --> '+response);
            System.debug('Response --> ' + response.getBody());
            return response.getBody();
            
        }
        else{
            System.debug('Failed'+response.getStatusCode());
            System.debug('Reason --> '+response);
            System.debug('Response --> ' + response.getBody());
            return 'Error';
            
        }
    }
}