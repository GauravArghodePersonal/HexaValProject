public class  B2BCOADocument{

    
    Public String message = System.currentPagereference().getParameters().get('msg');
    public String currentRecordId {get;set;}
    
    public String Sales_Org {get;set;}
    public String Distribution_Channel {get;set;}
    public String Sold_To {get;set;}
    public String Delivery {get;set;}
    public String Delivery_Item {get;set;}
    public string Sequence {get;set;}
    public string Most_Recent {get;set;}
    public String Language {get;set;}
    
    
    public B2BCOADocument(ApexPages.StandardController controller) {
     	Sales_Org = ApexPages.CurrentPage().getparameters().get('Sales_Org');
        Distribution_Channel = ApexPages.CurrentPage().getparameters().get('Distribution_Channel');
        Sold_To = ApexPages.CurrentPage().getparameters().get('Sold_To');
        Delivery = ApexPages.CurrentPage().getparameters().get('Delivery');
        Delivery_Item = ApexPages.CurrentPage().getparameters().get('Delivery_Item');
        Sequence = ApexPages.CurrentPage().getparameters().get('Sequence');
        Most_Recent = ApexPages.CurrentPage().getparameters().get('Most_Recent');
        Language = ApexPages.CurrentPage().getparameters().get('Language');
        Attachment ss=callWebServiceB2bCOABlob(Sales_Org, Distribution_Channel, Sold_To, Delivery, Delivery_Item, Sequence,Most_Recent,Language);
        //Attachment ss=callWebServiceB2bCOABlob('1020','10','0006008738','861563671','20','000','X','EN');
        currentRecordId =EncodingUtil.Base64Encode(ss.Body);
    }
    
      /**
* @description controller to get the blob content from SAP
*/
    @AuraEnabled
    public static Attachment callWebServiceB2bCOABlob(String Sales_Org,String Distribution_Channel,String Sold_To,String Delivery,String Delivery_Item,String Sequence,String Most_Recent,String Language) {
        /*Sales_Org='1020';
        Distribution_Channel='10';
        Sold_To='0000554912';
        Delivery='0861852505';
        Delivery_Item='000020';
        Sequence='000';
        Most_Recent='X';
        Language='EN';*/
        String message;
        System.debug('Sales_Org'+Sales_Org);
        System.debug('Distribution_Channel'+Distribution_Channel);
        System.debug('Sold_To'+Sold_To);
        System.debug('Delivery_Number'+Delivery);
        System.debug('Delivery_Item'+Delivery_Item);
        System.debug('Sequence'+Sequence);
        System.debug('Most_Recent'+Most_Recent);
        System.debug('Language'+Language);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('Get_COA_Details');
        gen.writeStartObject();
        gen.writeStringField('Category','O');
        gen.writeStringField('Document_Type', 'ZEML');
        gen.writeStringField('Delivery', Delivery);
        gen.writeStringField('Delivery_Item', Delivery_Item);
        gen.writeStringField('Distribution_Channel', Distribution_Channel);
        gen.writeStringField('Most_Recent',Most_Recent);
        gen.writeStringField('Sales_Org', Sales_Org);
        gen.writeStringField('Sequence',Sequence);
        gen.writeStringField('Sold_To', Sold_To);            
        gen.writeStringField('Language','EN');
        gen.writeEndObject();
        gen.writeEndObject();
        system.debug('JSON String');
        system.debug('JSON String'+gen.getAsString());
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('B2BCOADocument');
        String userName = px.username__c;
        String password = px.password__c;
        String jsonBody = gen.getAsString();
        System.debug('jsonBody -- '+jsonBody);
        system.debug('End Pint URL'+px.EndpointURL__c);
        system.debug('UserName'+px.username__c);
        system.debug('Password'+px.password__c);
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
                    (parser.getText() == 'Binary_Output')){
                        system.debug('inside Binary Output');
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