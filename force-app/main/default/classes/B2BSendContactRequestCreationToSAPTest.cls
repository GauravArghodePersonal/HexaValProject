@isTest
private class B2BSendContactRequestCreationToSAPTest {
    
    @isTest static void B2BSendContactRequestCreationToSAPTest01(){
        
        User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;

        PriceFx__c setting = new PriceFx__c();
        setting.Name = 'B2BSendContactRequestCreationToSAP';
        setting.username__c = 'Whatever';
        setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
        insert setting;

        //Account Acc= TestDataFactory.createAccount(True);
        List<New_Contact_Request__c> ccrList = new List<New_Contact_Request__c>();
        New_Contact_Request__c ccr= New New_Contact_Request__c(B2B_Email_Address__c='abc@gmail.com',B2B_First_name__c='abc',B2B_Last_Name__c='abc');
        ccrList.add(ccr);
        insert ccrList;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new B2BMockGenerator());
        Test.stopTest();
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        try{
            B2BSendContactRequestCreationToSAP.processB2BSendContactRequestCreationToSAP(ccrList);
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        //HttpResponse res = CCRtoSAP.CalloutToDellBoomi(ccr.Id);
 
    }

}