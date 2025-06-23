/*****************************************************************
* Class Name     : Exp_NewContactRequestControllerTest
* Description    : Test Class for Exp_NewContactRequestController
*****************************************************************/
@isTest
private class Exp_NewContactRequestControllerTest {
		
    @testSetup
    static void makedata() {
        List<Account> accounts = new List<Account>();
        
        Account account = TestDataFactory.createAccount(false);
        account.name='Account Test';
        account.ParentId = null;
        account.AccountNumber = '12345_A';
        account.SAP_Sales_Org__c = '1000'; 
        account.SAP_Street__c = 'Blazer Parkway';
        account.SAP_City__c = 'Dublin';
        account.SAP_State__c = 'OH';
        account.SAP_Zip_Code__c = '90210'; 
        account.SAP_Country__c = 'US'; 
        account.type = 'Customer'; 
        account.SAP_DistChannel__c = '40'; 
        account.SAP_DivisionCode__c = '40'; 
        account.SAP_Dist_Channel_Desc__c = 'Valvoline';
        account.SAP_Division_Desc__c = 'Valvoline';
        account.inactive_account__c = false;
        Insert account;
        
        Account account_A = TestDataFactory.createAccount(false);
        account_A.name='Account Test A';
        account_A.ParentId = null;
        account_A.AccountNumber = '12345_A';
        account_A.SAP_Sales_Org__c = '1000'; 
        account_A.SAP_Street__c = 'Blazer Parkway';
        account_A.SAP_City__c = 'Dublin';
        account_A.SAP_State__c = 'OH';
        account_A.SAP_Zip_Code__c = '90210'; 
        account_A.SAP_Country__c = 'US'; 
        account_A.type = 'Customer'; 
        account_A.SAP_DistChannel__c = '40'; 
        account_A.SAP_DivisionCode__c = '40'; 
        account_A.SAP_Dist_Channel_Desc__c = 'Valvoline';
        account_A.SAP_Division_Desc__c = 'Valvoline';
        account_A.inactive_account__c = false; 
        account_A.SAP_Partner_Functions__c = 'Sold To';
        Insert account_A;
        
        Account account_B = TestDataFactory.createAccount(false);
        account_B.name='Account Test B';
        account_B.ParentId = null;
        account_B.AccountNumber = '12345_B';
        account_B.SAP_Sales_Org__c = '1000'; 
        account_B.SAP_Street__c = 'Blazer Parkway';
        account_B.SAP_City__c = 'Dublin';
        account_B.SAP_State__c = 'OH';
        account_B.SAP_Zip_Code__c = '90210'; 
        account_B.SAP_Country__c = 'US'; 
        account_B.type = 'Customer'; 
        account_B.SAP_DistChannel__c = '40'; 
        account_B.SAP_DivisionCode__c = '40'; 
        account_B.SAP_Dist_Channel_Desc__c = 'Valvoline';
        account_B.SAP_Division_Desc__c = 'Valvoline';
        account_B.inactive_account__c = false; 
        account_B.SAP_Partner_Functions__c = 'Ship To';
        account_B.Related_Payer__c = account_A.Id;
        account_B.ParentId = account_A.Id;
        Insert account_B;
        
        BuyerAccount buyerAccount = new BuyerAccount();
        buyerAccount.BuyerId = account_A.Id;
        buyerAccount.Name = 'Test Buyer Account_A';
        buyerAccount.IsActive = true;
        insert buyerAccount;
        
        List<Contact> contacts = new List<Contact>();
        Id sapContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SAP Contact').getRecordTypeId();
        Contact cc_A = TestDataFactory.createContact(false,account_A.id);
        cc_A.Email = 'test_A@example.org';
        cc_A.RecordTypeId = sapContactRecordTypeId;
        contacts.add(cc_A);
        
        Contact cc_B = TestDataFactory.createContact(false,account_B.id);
        cc_B.Email = 'test_B@example.org';
        cc_B.RecordTypeId = sapContactRecordTypeId;
        contacts.add(cc_B);
        Insert contacts;
        
        AccountContactRelation acr_A = [SELECT Id,
                                      		 IsActive,
                                      		 Upgraded_to_External_Account_B2B__c 
                                      FROM AccountContactRelation 
                                      WHERE AccountId =:account_A.Id 
                                      AND ContactId = :cc_A.Id];
        
        acr_A.IsActive= true;
        acr_A.Upgraded_to_External_Account_B2B__c = false;
        update acr_A;
        
        AccountContactRelation acr_B = [SELECT Id,
                                      		 IsActive,
                                      		 Upgraded_to_External_Account_B2B__c 
                                      FROM AccountContactRelation 
                                      WHERE AccountId =:account_B.Id 
                                      AND ContactId = :cc_B.Id];
        
        acr_B.IsActive= true;
        acr_B.Upgraded_to_External_Account_B2B__c = true;
        update acr_B;
        
        SAP_Contact__c sapc = new SAP_Contact__c(Account_Name__c = account_A.id, 
                                                 SAP_Email__c ='abc@gmail.com', 
                                                 SAP_Status__c = 'Active');
        insert sapc;
        
        List<New_Contact_Request__c> ccrList = new List<New_Contact_Request__c>();
        New_Contact_Request__c ccr_A = New New_Contact_Request__c(B2B_Contact_Lookup__c= cc_A.id,
                                                               B2B_Email_Address__c=UserInfo.getUserEmail(),
                                                               B2B_Old_Email_Address__c ='abc_A@gmail.com',
                                                               B2B_First_name__c='abc_A',
                                                               B2B_Last_Name__c='abc_A');
        New_Contact_Request__c ccr_B = New New_Contact_Request__c(B2B_Contact_Lookup__c= cc_B.id,
                                                               B2B_Email_Address__c=UserInfo.getUserEmail(),
                                                               B2B_Old_Email_Address__c ='abc_B@gmail.com',
                                                               B2B_First_name__c='abc_B',
                                                               B2B_Last_Name__c='abc_B');
        ccrList.add(ccr_A);
        ccrList.add(ccr_B);
        insert ccrList;
        
        for(AccountContactRelation acr : [SELECT Id, AccountId, Upgrade_to_External_Account__c, Upgraded_to_External_Account_B2B__c, Account.IsBuyer, ContactId FROM AccountContactRelation]){
            System.debug(acr.AccountId + '--' + acr.Upgrade_to_External_Account__c + '--' + acr.Upgraded_to_External_Account_B2B__c +'--' + acr.Account.IsBuyer +'--' + acr.ContactId);
        }

    }
    
    /*@isTest
    static void getAccountAddressTest(){
        List<Account> accounts = [SELECT Id, AccountNumber, SAP_Sales_Org__c FROM Account ORDER BY CreatedDate ASC];
        Test.startTest();
        List<Account> result_A = Exp_NewContactRequestController.getAccountAddress(accounts[0].AccountNumber, accounts[0].SAP_Sales_Org__c);
        List<Account> result_B = Exp_NewContactRequestController.getAccountAddress(accounts[1].AccountNumber, accounts[1].SAP_Sales_Org__c);
        Test.stopTest();
        Assert.areEqual(result_A.size(),1);
    }*/
    
    @isTest
    static void createRequestTest(){
        List<Account> accounts = [SELECT Id, AccountNumber, SAP_Sales_Org__c FROM Account ORDER BY Name ASC];
        Test.startTest();
        String result_A = Exp_NewContactRequestController.createRequest(accounts[1].AccountNumber, 'test_A@example.org');
        String result_B = Exp_NewContactRequestController.createRequest(accounts[2].AccountNumber, 'test_B@example.org');
        String result = Exp_NewContactRequestController.createRequest(accounts[0].AccountNumber, 'test@example.org');
        Test.stopTest();
        Assert.areEqual('Create~~Request is created successfully. You will receive an email with access details upon approval',result_A);
        Assert.areEqual('Failed~~You already have access to entered Sold To',result_B);
        
    }
    
    @isTest
    static void getExistingPIMRequestsTest(){
        Test.startTest();
		List <Exp_NewContactRequestController.PIMRequestDetails> result = Exp_NewContactRequestController.getExistingPIMRequests();        
        Test.stopTest();
        Assert.areEqual(result.size(),2);
    }
    
}