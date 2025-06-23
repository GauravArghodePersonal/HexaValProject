/*****************************************************************
* Class Name     : B2BSendContactUpdationToSAP                            *
* Author         : Jyoti                                   *
* Description    : Used to send data to SAP for updated contacts after PII process.*
*****************************************************************/

public class B2BSendContactUpdationToSAP {

  /**
  * @description invocable method called in flow to send request to SAP to update SAP contacts when PII request is approved in SFDC
  */
  
    @InvocableMethod(Label='Contact Updation in SAP' Description='Once Request is Approved All Conatct Persons Need to be updated in SAP') 
    public static void processB2BSendContactUpdationToSAP(List<New_Contact_Request__c> ids) {
      system.debug('In Invocable method' + ids);
      callWebServiceB2BSendContactUpdationToSAP(ids[0].id);
    }
    
    /**
  * @description method to send updated contact data to SAP through webservice via dellboomi.
  */
    
    @future(callout=true) 
    public static void callWebServiceB2BSendContactUpdationToSAP(String recordId) {
          system.debug('In Future method' + recordId);
          String jsonBody;
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
                                          B2B_Contact_Lookup__c,
                                          B2B_Old_Email_Address__c,
                                          Id                                        
                                          from New_Contact_Request__c where id =: recordId];       
          System.debug('CCR -- '+CCR);
          
          List<AccountContactRelation> accContactList =[SELECT AccountId,Account.ParentId,ContactId,Id,IsActive,SAP_Contact_Number__c,Sold_To_Account__c,Unique_Key__c,Upgraded_to_External_Account_B2B__c,Upgrade_to_External_Account__c FROM AccountContactRelation where ContactId = :CCR.B2B_Contact_Lookup__c and IsActive = true and Upgraded_to_External_Account_B2B__c = True];
          Set<Id> accList = new Set<Id>();
          for(AccountContactRelation acr : accContactList){
              if(acr.Account.ParentId == null){
                accList.add(acr.AccountId);
              }
              else{
                accList.add(acr.Account.ParentId);
              }
              
          }
          system.debug('accList Sold Tos++++++++' + accList);
  
          List<SAP_Contact__c> sapContacts = [Select id,SAP_Contact_Number__c,Account_Name__r.AccountNumber from SAP_Contact__c where Account_Name__c in :accList and SAP_Email__c =:CCR.B2B_Old_Email_Address__c and SAP_Status__c = 'Active'];
          system.debug('Sap contacts++++++++' + sapContacts);
          for(SAP_Contact__c sc: sapContacts){
              CCR.B2B_Customer_Number__c = sc.Account_Name__r.AccountNumber;
              CCR.B2B_Contact_Number__c = sc.SAP_Contact_Number__c;
              CCR.Contact_Person_Department__c = '0002';
              jsonBody = json.serialize(CCR);
              System.debug('jsonBody -- '+jsonBody);
              
              PriceFx__c px = new PriceFx__c();
              px = PriceFx__c.getInstance('B2BSendContactUpdationToSAP');
              String userName = px.username__c;
              String password = px.password__c;
          
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
                  
              }
              else{
                System.debug('Failed'+response.getStatusCode());
                  System.debug('Reason --> '+response);
                  System.debug('Response --> ' + response.getBody());
                  
              }
          }
          
    }
  }