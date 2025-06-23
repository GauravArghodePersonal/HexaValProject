@isTest
private class MergeboardController_T {
/****************************************************************************
 * Test Class MergeboardController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - MergeboardController Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Account account1;
    public static Account account2;
    public static Id mergeboardAccountId1;
    public static Id mergeboardAccountId2;
    
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
		MergeboardMethods.AddAccountToMergeboardResult mergeboardAddAccountToMergeboardResult1 = MergeboardMethods.addAccountToMergeboard(account1);
		MergeboardMethods.AddAccountToMergeboardResult mergeboardAddAccountToMergeboardResult2 = MergeboardMethods.addAccountToMergeboard(account2);

		mergeboardAccountId1 = mergeboardAddAccountToMergeboardResult1.id;
		mergeboardAccountId2 = mergeboardAddAccountToMergeboardResult2.id;
    }
  
    private static void executeTest01() {
        // Execute Tests
        MergeboardController c = new MergeboardController();
        c.refresh();
        
        c.doNothing();
        
        c.selectAllCheckboxValue = false;
        c.selectAll();
        
        c.selectAllCheckboxValue = true;
        c.selectAll();
        
		c.validateSelection();
        
        String url = c.mergeStep2URL;
        Boolean isAdmin = c.isAdmin;
        
        c.mergeboardAccountItemId = mergeboardAccountId1;
        //c.selectItem();

        c.mergeboardAccountItemId = mergeboardAccountId1;
        c.removeMergeboardAccountItem();

		c.clearMergeboard();
    }
}