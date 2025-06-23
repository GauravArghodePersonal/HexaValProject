@isTest
private class TreeViewUtils_T {
/****************************************************************************
 * Test Class TreeViewUtils_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - TreeViewUtils Apex Class
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

		TreeViewUtils.TreeNode testNode = new TreeViewUtils.TreeNode();
		TreeViewUtils.TreeSourceRec testSourceRec = new TreeViewUtils.TreeSourceRec();
		List<TreeViewUtils.TreeSourceRec> testSourceRecList = new List<TreeViewUtils.TreeSourceRec>();
		testSourceRecList.add(testSourceRec);

		TreeViewUtils.TreeSourceRecs testSourceRecs = new TreeViewUtils.TreeSourceRecs(testSourceRecList);
    }
}