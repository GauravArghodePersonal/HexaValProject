@isTest
private class AccountRollupFilterLetter_T {
/****************************************************************************
 * Test Class AccountRollupFilterLetter
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupFilterLetter Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
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
        // No Test Data Needed
    }
  
    private static void executeTest01() {
        // Execute Tests
		AccountRollupFilterLetter l = new AccountRollupFilterLetter('','');
    }
}