@isTest
private class SAP_Ultimate_Parent_Settings_T {
/****************************************************************************
 * Test Class SAP_Ultimate_Parent_Settings_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - SAP_Ultimate_Parent_Settings Trigger
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
		SAP_Ultimate_Parent_Settings.defaultSettings();
    }
}