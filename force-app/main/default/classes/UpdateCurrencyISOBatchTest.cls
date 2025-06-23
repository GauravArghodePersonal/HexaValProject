@isTest
private class UpdateCurrencyISOBatchTest {
	
    @TestSetup
    static void createTestData() {
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        List<Account> testAccounts = new List<Account>();
        for(Integer i=0;i<9;i++){
            Integer counter = i + (i+1) + (i+2) + (i+3);
            String counterStr = String.valueOf(counter);
            Account testAccount = TestDataFactory.createAccount(false);
            testAccount.Name = 'Account' + counterStr;
            testAccount.RecordTypeId = accountRecordTypeId;
            testAccount.AccountNumber = counterStr;
            testAccount.SAP_Sales_Org__c = counterStr;
            testAccount.ParentId = null;
            testAccounts.add(testAccount);
        }
        Insert testAccounts;
        
        List<INFOR_Forecast__c> infors = new List<INFOR_Forecast__c>();
        for(Integer i=0;i<9;i++){
            Integer counter = i + (i+1) + (i+2) + (i+3);
            String counterStr = String.valueOf(counter);
            INFOR_Forecast__c infor = new INFOR_Forecast__c();
            infor.Account_ID__c = testAccounts[i].Id;
            infor.Opportunity_Name__c='Test Opportunity ' + counterStr;
            infor.Material_Description__c='Material Description';
            infor.Unit_Price__c = i;
            infor.Sales_Org__c = counterStr;
            infors.add(infor);
        }      
        insert infors;
        
        List<SalesOrg_Currency__c> salesOrgCurrencies = new List<SalesOrg_Currency__c>();
        for(Integer i=0;i<9;i++){
            Integer counter = i + (i+1) + (i+2) + (i+3);
            String counterStr = String.valueOf(counter);
            SalesOrg_Currency__c salesOrgCurrency = new SalesOrg_Currency__c();
            salesOrgCurrency.Active_Sales_Org__c = true;
            salesOrgCurrency.Description__c = 'Test Description ' + counterStr;
            salesOrgCurrency.Sales_Org__c = counterStr;
            salesOrgCurrencies.add(salesOrgCurrency);
        }      
        insert salesOrgCurrencies;
        
    }
    
    @isTest
    static void executeBatchTest() {
        Test.startTest();
        Database.executeBatch(new UpdateCurrencyISOBatch());
        Test.stopTest();
        List<SalesOrg_Currency__c> salesOrgCurrencies = [SELECT Id, CurrencyIsoCode FROM SalesOrg_Currency__c WHERE CurrencyIsoCode != null ORDER BY CurrencyIsoCode ASC];
        List<INFOR_Forecast__c> infors = [SELECT Id, Sales_Org__c, CurrencyIsoCode FROM INFOR_Forecast__c WHERE CurrencyIsoCode != null ORDER BY CurrencyIsoCode ASC];
        System.assertEquals(9, infors.size(), 'Something went wrong!');
        for(Integer i=0;i<9;i++){
            System.assertEquals(salesOrgCurrencies[i].CurrencyIsoCode, infors[i].CurrencyIsoCode, 'Something went wrong!');
        }
    }
}