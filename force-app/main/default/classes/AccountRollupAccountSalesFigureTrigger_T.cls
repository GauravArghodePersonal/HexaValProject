@isTest
private class AccountRollupAccountSalesFigureTrigger_T {
/****************************************************************************
 * Test Class AccountRollupAccountSalesFigureTrigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupAccountSalesFigureTrigger Trigger
 ****************************************************************************/
 
    //Test Data
    private static Account acct;
    private static Account_Sales_Figure__c testRec;
   
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        acct = TestObjects.newAccount();
        
        Account_Rollup_Settings__c settings = Account_Rollup_Settings.defaultSettings();
        settings.Triggers_Enabled__c = true;
        update settings;
    }
  
    private static void executeTest01() {
        // Execute Tests
        testRec = TestObjects.newAccount_Sales_Figure(false);
        testRec.Account__c = acct.Id;
        testRec.Key__c = 'test';
        insert testRec;
        update testRec;
        delete testRec;
        undelete testRec;
    }
}