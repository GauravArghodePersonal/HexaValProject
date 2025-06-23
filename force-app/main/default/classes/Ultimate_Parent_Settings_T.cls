@isTest
private class Ultimate_Parent_Settings_T {
/****************************************************************************
 * Test Class Ultimate_Parent_Settings_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Ultimate_Parent_Settings Trigger
 ****************************************************************************/
 
    //Test Data
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    }
  
    private static void executeTest01() {
        // Execute Tests
		Ultimate_Parent_Settings.defaultSettings();
    }
}