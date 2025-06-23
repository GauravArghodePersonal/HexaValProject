@isTest
private class B2BSendContactUpdationToSAPTest {
    
    @isTest static void B2BSendContactUpdationToSAPTest01(){
        
        User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        
        Account regularAccount = TestDataFactory.createAccount(false);
        regularAccount.Name = 'Account123';
        regularAccount.ownerId = user.id;
        regularAccount.RecordTypeId = accountRecordTypeId;
        regularAccount.AccountNumber = '19876';
        regularAccount.SAP_Sales_Org__c = '1020';
        regularAccount.Enable_As_Buyer_Account__c = true;
        regularAccount.SAP_Attribute1_Desc__c ='abc';
        regularAccount.ParentId = null;

        Insert regularAccount;

        PriceFx__c setting = new PriceFx__c();
        setting.Name = 'B2BSendContactUpdationToSAP';
        setting.username__c = 'Whatever';
        setting.password__c = 'solenis-32DPHR:afff1e3f-5bd8-4d49-91a1-73efcde405ee';
        setting.EndpointURL__c = 'https://b2bdbqa.solenis.com:9093/ws/simple/upsertCustomerUpdate';
        insert setting;

        Contact cc = new Contact(AccountId =regularAccount.id, FirstName = 'abc', LastName = 'abc');
        insert cc;
       
        
        AccountContactRelation acr = [Select Id,IsActive,Upgraded_to_External_Account_B2B__c from AccountContactRelation where AccountId =:regularAccount.id and ContactId = :cc.id];
        acr.IsActive= true;
        acr.Upgraded_to_External_Account_B2B__c = true;
        update acr;
        SAP_Contact__c sapc = new SAP_Contact__c(Account_Name__c = regularAccount.id, SAP_Email__c ='abc@gmail.com', SAP_Status__c = 'Active');
        insert sapc;
        List<New_Contact_Request__c> ccrList = new List<New_Contact_Request__c>();
        New_Contact_Request__c ccr= New New_Contact_Request__c(B2B_Contact_Lookup__c= cc.id,B2B_Email_Address__c='abc@gmail.com',B2B_Old_Email_Address__c ='abc@gmail.com',B2B_First_name__c='abc',B2B_Last_Name__c='abc');
        ccrList.add(ccr);
        insert ccrList;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new B2BMockGenerator());
        Test.stopTest();
        //CCRtoSAP.CalloutToDellBoomi(ccr.Id);
        String response = '';
        try{
            B2BSendContactUpdationToSAP.processB2BSendContactUpdationToSAP(ccrList);
        }
        catch(Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            response = e.getMessage();  
        }
        
        //HttpResponse res = CCRtoSAP.CalloutToDellBoomi(ccr.Id);
 
    }

}