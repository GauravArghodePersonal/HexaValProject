@isTest
private class DistributorEndUseCustomerTest {

    static testMethod void test01() {
    	Account a1 = new Account(Name='TestAcc1', 
    	                         AccountNumber = '0000123456',
    	                         SAP_DistChannel__c = '50',
    	                         SAP_DivisionCode__c = '50',
    	                         Account_Number__c='000012345601235050');
        Account a2 = new Account(Name='TestAcc1',
                                 AccountNumber = '0000123456',
                                 SAP_DistChannel__c = '50',
                                 SAP_DivisionCode__c = '50',
                                 Account_Number__c='000012345604565050');
        Account a3 = new Account(Name='TestAcc3',
                                 Account_Number__c='0000654321');
    	List<Account> accs = new List<Account>{a1, a2, a3};
    	insert accs;
        DistributorEndUseCustomerController c = new DistributorEndUseCustomerController();
        c.publicGroupName = 'AQ Dist Mgt Group';

        c.endUseCustomers = '654321,123456,123,50,50'; // with salesorg
        c.insertEndUseCustomers();

        c.endUseCustomers = '654321,123456,,50,50'; // without salesorg
        c.insertEndUseCustomers();
    }
}