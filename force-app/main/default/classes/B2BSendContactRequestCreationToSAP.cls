/*****************************************************************
* Class Name     : B2BSendContactRequestCreationToSAP                            *
* Author         : Jyoti                                   *
* Description    : Used to send send data to SAP for newly created contact after registeration process.*
*****************************************************************/

public class B2BSendContactRequestCreationToSAP {

/**
* @description invocable method called in flow to send request to SAP to create new contact when request is approved in SFDC
*/

  @InvocableMethod(Label='Contact Creation in SAP' Description='Once Request is Approved Conatct Person Needs to be created in SAP') 
  public static void processB2BSendContactRequestCreationToSAP(List<New_Contact_Request__c> ids) {
    system.debug('In Invocable method' + ids);
    callWebServiceB2BSendContactRequestCreationToSAP(ids[0].id);
  }
  
  /**
* @description method to send data to SAP through webservice via dellboomi.
*/
  
  @future(callout=true) 
  public static void callWebServiceB2BSendContactRequestCreationToSAP(String recordId) {
        system.debug('In Future method' + recordId);
        String message;
        New_Contact_Request__c CCR = [select 
                                        B2B_First_name__c,
                                        B2B_Last_Name__c,
                                        B2B_Contact_Number__c,
                                        B2B_Phone__c,
                                        B2B_Email_Address__c,
                                        B2B_Customer_Number__c,
                                        B2B_Full_Name__c,
                                        B2B_Title__c,
                                        Id                                        
                                        from New_Contact_Request__c where id =: recordId];       
        System.debug('CCR -- '+CCR);
        CCR.Contact_Person_Department__c = '0002';
        PriceFx__c px = new PriceFx__c();
        px = PriceFx__c.getInstance('B2BSendContactRequestCreationToSAP');
        String userName = px.username__c;
        String password = px.password__c;
            
        String jsonBody = json.serialize(CCR);
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
            
        Map<String, String> values = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
        String b2bContact = values.get('B2B_Contact_Number__c');
        String messageData = values.get('MESSAGE_V1');
        
        System.debug('b2b --> '+b2bContact);
        System.debug('Message --> '+messageData);
        
        if(b2bContact == '0000000000'){
            CCR.Status__c = 'Error in SAP';
            CCR.B2B_Contact_Number__c = b2bContact;
        }
        else{
            CCR.Status__c = 'Success in SAP';
            CCR.B2B_Contact_Number__c = b2bContact;
        }
        
        Update CCR;
        
    }
    else{
      System.debug('Failed'+response.getStatusCode());
        System.debug('Reason --> '+response);
        System.debug('Response --> ' + response.getBody());
        System.debug('CCR --> ' + CCR);
        CCR.Status__c = 'Error in SAP';
        Update CCR;
    }
  }
}