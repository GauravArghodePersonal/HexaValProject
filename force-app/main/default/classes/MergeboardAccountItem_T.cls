@isTest
private class MergeboardAccountItem_T {
/****************************************************************************
 * Test Class MergeboardAccountItem_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - MergeboardAccountItem Apex Class
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
		MergeboardAccountItem m = new MergeboardAccountItem();
    }
}