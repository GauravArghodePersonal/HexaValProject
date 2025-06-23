@isTest
public class ChangeReqSAPContactTest {
    
    @isTest static void ChangeReqSAPContactTest01(){
        ID rctId = Schema.SObjectType.Customer_Creation_Request__c.getRecordTypeInfosByDeveloperName().get('Solenis_CCR_RecordType').getRecordTypeID();
        
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr = TestDataFactory.createCCR(false, Acc.Id);
        ccr.RecordTypeId= rctId;
        ccr.ChangeReqSAPContact__c = TRUE;
        ccr.First_Name__c = 'Test';
        ccr.Last_Name__c = 'Customer';
        ccr.SAP_Email__c = 'Solenis@test.com';
        ccr.SAP_Title__c = 'company';
        ccr.SAP_Fax__c = '10001';
        ccr.SAP_Phone__c = '+386 8 205 16 90';
        ccr.SAP_Contact_Person_FunctionCode__c = 'ZM';
        Insert ccr;       
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCCRtoSAP());
        //ChangeReqSAPContact.CalloutToDellBoomi(ccr.Id);
        Test.stopTest();
        
        String response = '';
        try{
            String responce=ChangeReqSAPContact.CalloutToDellBoomi(ccr.Id);
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
    }     

}