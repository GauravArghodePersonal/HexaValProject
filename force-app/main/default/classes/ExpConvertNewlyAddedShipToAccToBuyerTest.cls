/*****************************************************************
* Class Name     : ExpConvertNewlyAddedShipToAccToBuyerTest
* Description    : Test Class for ExpConvertNewlyAddedShipToAccountToBuyer
*****************************************************************/
@isTest
private class ExpConvertNewlyAddedShipToAccToBuyerTest {
		
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
        account.SAP_Partner_Functions__c = 'Sold To';
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
        account_A.ParentId = account.Id;
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
        
        Id sapContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SAP Contact').getRecordTypeId();
        Contact cc = TestDataFactory.createContact(false,account_A.id);
        cc.Email = 'test@example.org';
        cc.RecordTypeId = sapContactRecordTypeId;
        Insert cc;
        
        AccountContactRelation acr = [SELECT Id,
                                      		 IsActive,
                                      		 Upgraded_to_External_Account_B2B__c 
                                      FROM AccountContactRelation 
                                      WHERE AccountId =:account_A.Id 
                                      AND ContactId = :cc.Id];
        
        acr.IsActive= true;
        acr.Upgraded_to_External_Account_B2B__c = false;
        update acr;
        System.debug([SELECT Id, ContactId, AccountId, IsActive, Contact.RecordType.Name FROM AccountContactRelation]);
        SAP_Contact__c sapc = new SAP_Contact__c(Account_Name__c = account_A.id, 
                                                 SAP_Email__c ='abc@gmail.com', 
                                                 SAP_Status__c = 'Active');
        insert sapc;
        
        List<New_Contact_Request__c> ccrList = new List<New_Contact_Request__c>();
        New_Contact_Request__c ccr= New New_Contact_Request__c(B2B_Contact_Lookup__c= cc.id,
                                                               B2B_Email_Address__c=UserInfo.getUserEmail(),
                                                               B2B_Old_Email_Address__c ='abc@gmail.com',
                                                               B2B_First_name__c='abc',
                                                               B2B_Last_Name__c='abc');
        ccrList.add(ccr);
        insert ccrList;
        
        BuyerGroup bg = new BuyerGroup(Name = 'abc');
        insert bg;

    }
    
    @isTest
    static void processExpNewlyAddedShipToTest(){
        List<Account> accounts = [SELECT Id,
                                  		 Name,
                                  		 ParentId,
                                   		 ShippingStreet,
                                  		 ShippingCity,
                                         ShippingState,
                                  		 ShippingCountry,
                                  		 ShippingPostalCode
                                  FROM Account
                                  WHERE name='Account Test B'];
        Test.startTest();
        ExpConvertNewlyAddedShipToAccountToBuyer.processExpNewlyAddedShipTo(accounts);
        Test.stopTest();
    }
}