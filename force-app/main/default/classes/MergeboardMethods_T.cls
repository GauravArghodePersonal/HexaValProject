@isTest
private class MergeboardMethods_T {
/****************************************************************************
 * Test Class MergeboardMethods_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - MergeboardMethods Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Account account1;
    public static Account account2;
    
    //Test Settings
    
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    	account1 = TestObjects.newAccount();
    	account2 = TestObjects.newAccount();
    }
  
    private static void executeTest01() {
        // Execute Tests
		MergeboardMethods.addAccountToMergeboard(account1);
		MergeboardMethods.addAccountToMergeboard(account2.Id);
		MergeboardMethods.accountExistsinMergeboard(account2.Id);
		MergeboardMethods.getAccountsInMergeboardCount();
		MergeboardMethods.getAccountsInMergeboardSummary();
		MergeboardMethods.removeAccountFromMergeboard(account2.Id);
		MergeboardMethods.retrieveAccountItems();
		MergeboardMethods.mergeboardEnabled();
    }
}