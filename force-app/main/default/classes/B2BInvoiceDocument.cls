/*****************************************************************
* Class Name     : B2BInvoiceDocument                            *
* Author         : Donald JP                                  	*
* Created Date   : 27-Mar-2022                                   *
* Modified Date  : 21-Apr-2021                                   *
* Description    : This is to obtain Invoice document from 
SAP*
*****************************************************************/

public class B2BInvoiceDocument {
    Public String message = System.currentPagereference().getParameters().get('msg');
    public String currentRecordId {get;set;}
    
    public String Invoice_Number {get;set;}
    public String SAP_Customer_Number {get;set;}
    public String Division {get;set;}
    public String Sales_Org {get;set;}
    public String Distribution_Channel {get;set;}
    public String Language {get;set;}
    
    /**
* @description controller to get the invoice parameter from URL and call SAP
*/
    public B2BInvoiceDocument(ApexPages.StandardController controller) {
        
        Invoice_Number = ApexPages.CurrentPage().getparameters().get('Invoice_Number');
        SAP_Customer_Number = ApexPages.CurrentPage().getparameters().get('SAP_Customer_Number');
        Division = ApexPages.CurrentPage().getparameters().get('Division');
        Sales_Org = ApexPages.CurrentPage().getparameters().get('Sales_Org');
        Distribution_Channel = ApexPages.CurrentPage().getparameters().get('Distribution_Channel');
        Language = ApexPages.CurrentPage().getparameters().get('Language');
        Attachment ss=callWebServiceB2bINVBlob(Invoice_Number, SAP_Customer_Number, Division, Sales_Org, Distribution_Channel, Language);
        currentRecordId =EncodingUtil.Base64Encode(ss.Body);
        
    }
    /**
* @description controller to get the blob content from SAP
*/
    @AuraEnabled
    public static Attachment callWebServiceB2bINVBlob(String Invoice_Number,String SAP_Customer_Number,String Division,String Sales_Org,String Distribution_Channel,String Language) {
        String message;
        System.debug('Invoice_Number'+Invoice_Number);
        System.debug('SAP_Customer_Number'+SAP_Customer_Number);
        System.debug('Division'+Division);
        System.debug('Sales_Org'+Sales_Org);
        System.debug('Distribution_Channel'+Distribution_Channel);
        System.debug('Language'+Language);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('Get_Invoice_Details');
        gen.writeStartObject();
        gen.writeStringField('Category','O');
        gen.writeStringField('Document_Type', 'ZEML');
        gen.writeStringField('Invoice_Number', Invoice_Number);
        gen.writeStringField('SAP_Customer_Number', SAP_Customer_Number);
        gen.writeStringField('Language','EN');
        gen.writeStringField('Division', Division);
        gen.writeStringField('Sales_Org',Sales_Org);
        gen.writeStringField('Distribution_Channel',Distribution_Channel);
        gen.writeEndObject();
        gen.writeEndObject();
        system.debug('JSON String');
        system.debug('JSON String'+gen.getAsString());
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('B2BInvoicePDF');
        String userName = px.username__c;
        String password = px.password__c;
        String jsonBody = gen.getAsString();
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
                    (parser.getText() == 'Invoice_Binary_Details')){
                        parser.nextToken();
                        blobcontent=parser.getText();
                    }
                
            }
            system.debug('FINAL'+blobcontent);
            Blob s;
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