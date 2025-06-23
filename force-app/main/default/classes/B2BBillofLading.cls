/*****************************************************************
* Class Name     : B2BBillofLading                            *
* Author         : Donald JP                                  	*
* Created Date   : 27-Mar-2022                                   *
* Modified Date  : 21-Apr-2021                                   *
* Description    : This is get the packaging document
from SAP*
*****************************************************************/

public class B2BBillofLading {
    Public String message = System.currentPagereference().getParameters().get('msg');
    public String currentRecordId {get;set;}
    
    public String Delivery_Number {get;set;}
    public String SAP_Customer_Number {get;set;}
    public String Language {get;set;}
    public String Division {get;set;}
    public String Sales_Org {get;set;}
    public String Doc_Type {get;set;}
    public String Distribution_Channel {get;set;}
    
        /**
* @description controller call to obtain all the parameter from VF page
*/

    public B2BBillofLading(ApexPages.StandardController controller) {

        Distribution_Channel = ApexPages.CurrentPage().getparameters().get('Distribution_Channel');
        Delivery_Number = ApexPages.CurrentPage().getparameters().get('Delivery_Number');
        SAP_Customer_Number = ApexPages.CurrentPage().getparameters().get('SAP_Customer_Number');
        Language = ApexPages.CurrentPage().getparameters().get('Language');
        Division = ApexPages.CurrentPage().getparameters().get('Division');
        Sales_Org = ApexPages.CurrentPage().getparameters().get('Sales_Org');
        Doc_Type = ApexPages.CurrentPage().getparameters().get('Doc_Type');
        Attachment ss=callWebServiceB2bBOLBlob(Doc_Type,Distribution_Channel, Delivery_Number, SAP_Customer_Number, Language, Division, Sales_Org);
        currentRecordId =EncodingUtil.Base64Encode(ss.Body);

    }
    
           /**
* @description to the Document blob content from SAP
*/
    @AuraEnabled
    public static Attachment callWebServiceB2bBOLBlob(String Doc_Type,String Distribution_Channel,String Delivery_Number,String SAP_Customer_Number,String Language,String Division,String Sales_Org) {
        system.debug('Distribution_Channel' + Distribution_Channel);
        String message;
        System.debug('Delivery_Number'+Delivery_Number);
        System.debug('SAP_Customer_Number'+SAP_Customer_Number);
        System.debug('Language'+Language);
        System.debug('Division'+Division);
        System.debug('Sales_Org'+Sales_Org);
        System.debug('Doc_Type'+Doc_Type);
 JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('Get_Delivery_Details');
        gen.writeStartObject();
        gen.writeStringField('Category','O');
        gen.writeStringField('Delivery_Number', Delivery_Number);
        gen.writeStringField('SAP_Customer_Number',SAP_Customer_Number);
        gen.writeStringField('Language','EN');
        gen.writeStringField('Division', Division);
        gen.writeStringField('Sales_Org',Sales_Org);
        gen.writeStringField('Doc_Type',Doc_Type);
        gen.writeStringField('Distribution_Channel',Distribution_Channel);
        gen.writeEndObject();
        gen.writeEndObject();
        system.debug('JSON String');
        system.debug('JSON String'+gen.getAsString());
        String jsonBody = gen.getAsString();
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('B2BDeliveryPDF');
        String userName = px.username__c;
        String password = px.password__c;       
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
            String res= response.getBody(); 
            String blobcontent=null;
            JSONParser parser = JSON.createParser(response.getBody());
            Double grandTotal = 0.0;
            while (parser.nextToken() != null) {
                system.debug('parser.getText()'+parser.getText());
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'Binary_Data')){
                        //exit
                        parser.nextToken();
                        blobcontent=parser.getText();
                    }
                
            }
             Blob s;
            system.debug('FINAL'+blobcontent);
            if(blobcontent!=null)
            {
             s= Blob.valueOf(blobcontent);
            }
            else
            {
                s=null;
            }
            //perform insert into the attachment in salesforce
            Attachment att=new Attachment();
            att.contentType = 'application/pdf';
            system.debug('Before Att'); 
            String bodyStr='test';
            if(blobcontent!=null)
            {
            att.Body=EncodingUtil.base64Decode(blobcontent); 
            }
            else
            {
               att.Body=EncodingUtil.base64Decode('Kindly contact Admin'); 
            }
            att.Name='Rest' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.pdf';
            return att;
        }
        else{
            System.debug('Failed'+response.getStatusCode());
            System.debug('Reason --> '+response);
            System.debug('Response --> ' + response.getBody());
            return null;

        }
    }
}