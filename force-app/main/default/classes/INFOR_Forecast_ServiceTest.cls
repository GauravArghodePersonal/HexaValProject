@isTest
private class INFOR_Forecast_ServiceTest {
    
    @isTest
    static void beforeAndAfterTest() {
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        List<Account> testAccounts = new List<Account>();
        for(Integer i=0;i<9;i++){
            Integer counter = i + (i+1) + (i+2) + (i+3);
            String counterStr = String.valueOf(counter);
            Account testAccount = TestDataFactory.createAccount(false);
            testAccount.Name = 'Account' + counterStr;
            testAccount.RecordTypeId = accountRecordTypeId;
            testAccount.AccountNumber = counterStr;
            testAccount.SAP_SalesDistrict__c = 'IWNA1';
            testAccount.SAP_Sales_Office__c = 'IW31';
            testAccount.SAP_SalesGroup__c = '18I'; 
            testAccount.Prospect_Sales_Group__c = '18I';
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
            if(math.mod(i, 2) == 0){
                infor.Currency_from_Unit_Price__c = 'USD4';
            } else if(math.mod(i, 3) == 0){
                infor.Currency_from_Unit_Price__c = 'CAD4';
            } else {
                infor.Currency_from_Unit_Price__c = 'INR';
            }
            infors.add(infor); System.debug('>>> infor >>>' + infor);
        }  
        Test.startTest();
        insert infors;
        
        for(Integer i=0;i<9;i++){
            infors[i].Opportunity_Name__c='Test Opportunity ' + i;
        }      
        update infors;
        Test.stopTest();
        
        infors = [SELECT Id FROM INFOR_Forecast__c WHERE CurrencyIsoCode != null];
        System.assertEquals(9, infors.size(), 'Something went wrong!');   
        
        infors = [SELECT Id FROM INFOR_Forecast__c WHERE Group__c != null];
     //   System.assertEquals(1, infors.size(), 'Something went wrong!');   
    }
}