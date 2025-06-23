@isTest
private class Account_Rollup_Settings_T {
/****************************************************************************
 * Test Class Account_Rollup_Settings_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Account_Rollup_Settings Trigger
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
		Account_Rollup_Settings.defaultSettings();
   	}}