/*****************************************************************
* Class Name     : B2BViewPdf                            *
* Author         : Donald JP                                  	*
* Created Date   : 27-Mar-2022                                   *
* Modified Date  : 21-Apr-2021                                   *
* Description    : This is to view the 
SDS document from SAP*
*****************************************************************/

public class B2BViewPdf {
    Public String message = System.currentPagereference().getParameters().get('msg');
    public String currentRecordId {get;set;}
    
    public String recordID {get;set;}
    public String getDOCKEY {get;set;}
    public String getGENVAR {get;set;}
    public String getLANGU {get;set;}
    public String getMATNR {get;set;}
    public String getRECN_DH {get;set;}
    
 
    /**
* @description to get the parameter from VF page to view the SDS PDF document
*/   
    public B2BViewPdf(ApexPages.StandardController controller) {

        recordID = ApexPages.CurrentPage().getparameters().get('recordID');
        getDOCKEY = ApexPages.CurrentPage().getparameters().get('DOCKEY');
        getGENVAR = ApexPages.CurrentPage().getparameters().get('GENVAR');
        getLANGU = ApexPages.CurrentPage().getparameters().get('LANGU');
        getMATNR = ApexPages.CurrentPage().getparameters().get('MATNR');
        getRECN_DH = ApexPages.CurrentPage().getparameters().get('RECN_DH');
        Attachment ss=callWebServiceB2bSdsBlob(recordID, getDOCKEY, getGENVAR, getLANGU, getMATNR, getRECN_DH);
        currentRecordId =EncodingUtil.Base64Encode(ss.Body);
    }
        /**
* @description class to call the web service data from SAP
*/ 
    @AuraEnabled
    public static Attachment callWebServiceB2bSdsBlob(String recordId,String PI_DOC_KEY,String GENVAR,String PI_LANGUAGE,String PI_MATERIAL,String PI_RECORD_NO_DOC) {
        system.debug('In Future method' + recordId);
        String message;
        System.debug('RecordID'+recordID);
        System.debug('PI_DOC_KEY'+PI_DOC_KEY);
        System.debug('GENVAR'+GENVAR);
        System.debug('PI_LANGUAGE'+PI_LANGUAGE);
        System.debug('PI_MATERIAL'+PI_MATERIAL);
        System.debug('PI_RECORD_NO_DOC'+PI_RECORD_NO_DOC);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('PI_DOCTYPE','PDF');
        gen.writeStringField('PI_DOC_KEY',PI_DOC_KEY);
        gen.writeStringField('PI_GENERATION_VAR', 'SDSGHS_AR');
        gen.writeStringField('PI_LANGUAGE', 'E');
        gen.writeStringField('PI_MATERIAL',PI_MATERIAL);
        gen.writeStringField('PI_RECORD_NO_DOC', PI_RECORD_NO_DOC);
        gen.writeStringField('PI_RETURN_BIN','X');
        gen.writeEndObject();
        system.debug('JSON String');
        system.debug('JSON String'+gen.getAsString());
        
        
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('B2BSDSDocument');
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
                    (parser.getText() == 'PO_BIN')){
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