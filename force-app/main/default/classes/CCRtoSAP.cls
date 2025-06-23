public class CCRtoSAP {
    @AuraEnabled
    public static String CalloutToDellBoomi(String recordId){
        String message;
        String lengthMsg='';
        Customer_Creation_Request__c CCR = [select SAP_CustomerNumber__c,Company_Legal_Name__c,Name_2__c,Name_3__c,CCR_Sales_Organization__c,CCR_DIst_Channel__c,CCR_Division__c,Incoterms__c,Incoterms_2__c,Currency__c,BillingStreet__c, Street_2__c,Street_3__c,House_Number1__c,House_Number2__c,PO_Box__c,PO_Box_postal_code__c, City__c,State_Region__c,Postal_Code__c,Country__c,Parent_Account_Number__c,Owner__c,SAP_Contact_Number__c,First_Name__c,Last_Name__c,SAP_Email__c,SAP_Title__c,SAP_Fax__c,SAP_Phone__c,SAP_Contact_Person_FunctionCode__c,SAP_Contact_Desc__c from Customer_Creation_Request__c where id =: recordId];
        System.debug('============='+CCR);
        if(CCR.CCR_Sales_Organization__c != ''){
        CCR.CCR_Sales_Organization__c = String_Functions.inParenthesis(CCR.CCR_Sales_Organization__c);
        } if(CCR.CCR_DIst_Channel__c != null){
        CCR.CCR_DIst_Channel__c = String_Functions.inParenthesis(CCR.CCR_DIst_Channel__c);
        }
        if(CCR.CCR_Division__c != null){
        CCR.CCR_Division__c = String_Functions.inParenthesis(CCR.CCR_Division__c);
        }
        if(CCR.Owner__c!=null)
        {
            system.debug(CCR.Owner__c.length());
            if(CCR.Owner__c.length()>10){lengthMsg+='Owner SAP Number Exceeded';}
        } if(CCR.Country__c != null){
        CCR.Country__c = String_Functions.inParenthesis(CCR.Country__c);
        }
        if(CCR.Currency__c != null){
        CCR.Currency__c = String_Functions.Beforehypen(CCR.Currency__c);
        }
        if(CCR.State_Region__c != null){
        CCR.State_Region__c = String_Functions.Beforehypen(CCR.State_Region__c);
        }
        if(CCR.Incoterms__c != null){
        CCR.Incoterms__c = String_Functions.Beforehypen(CCR.Incoterms__c);
        }String jsonBody = json.serialize(CCR);
        System.debug('jsonBody -- '+jsonBody);
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint('https://b2bdbprod.solenis.com:9093/ws/simple/upsertCustomerUpdate');
        //https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate
        //https://b2bdbprod.solenis.com:9093/ws/simple/upsertCustomerUpdate
		request.setMethod('GET');
		request.setBody(jsonBody);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf('solenis-32DPHR:365cf474-8b9f-430a-a70b-b758666c6c0a');
        //solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee
        //
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
		HttpResponse response = http.send(request);

		if (response.getStatusCode() == 200) { Map<String, String> values = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
        String messageType = values.get('TYPE');
        String messageData = values.get('MESSAGE_V2');
            messageData+='-'+values.get('MESSAGE_V1');
         if(messageType == 'E') { return messageData;
            } return 'Success';}
		else{if(lengthMsg!='')
            {return 'Failed - '+lengthMsg;}
            else{return 'Failed'; }}
    }
}