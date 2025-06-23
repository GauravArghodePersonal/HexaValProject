public class ChangeReqSAPContact {
@AuraEnabled
    public static String CalloutToDellBoomi(String recordId){
        String message;
        system.debug('Inside Change Request');
        Customer_Creation_Request__c CCR = [select 
SAP_CustomerNumber__c,
SAP_Contact_Number__c,
First_Name__c,
Last_Name__c,
SAP_Email__c,
SAP_Title__c,
SAP_Fax__c,
SAP_Phone__c,
SAP_Contact_Person_FunctionCode__c,
SAP_Contact_Desc__c
from Customer_Creation_Request__c where id =: recordId];       
		System.debug('CCR -- '+CCR);

        String jsonBody = json.serialize(CCR);
        System.debug('jsonBody -- '+jsonBody);
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint('https://b2bdbprod.solenis.com:9093/ws/simple/upsertCustomerUpdate');
		request.setMethod('GET');
		request.setBody(jsonBody);
        request.setHeader('Content-type', 'application/json');
        Blob headerValue = Blob.valueOf('solenis-32DPHR:365cf474-8b9f-430a-a70b-b758666c6c0a');
        String authorizationHeader = 'Basic '+EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
		HttpResponse response = http.send(request);

		if (response.getStatusCode() == 200) {
    	System.debug('Success'+response.getStatusCode());
        System.debug('Reason --> '+response);
        System.debug('Response --> ' + response.getBody());
            
        Map<String, String> values = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
        String messageType = values.get('TYPE');
        String messageData = values.get('MESSAGE_V2');
        System.debug('Type --> '+messageType);
        System.debug('Message --> '+messageData);
            if(messageType == 'E') {
                return messageData;
            }
            
        return 'Success';
		}
		else{
    	System.debug('Failed'+response.getStatusCode());
        System.debug('Reason --> '+response);
        System.debug('Response --> ' + response.getBody());
        return 'Failed';
		}
    }
}