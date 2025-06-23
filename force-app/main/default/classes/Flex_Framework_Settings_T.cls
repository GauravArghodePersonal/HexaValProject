@isTest
private class Flex_Framework_Settings_T {

/****************************************************************************
 * Test Class Flex_Framework_Settings_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Flex_Framework_Settings Apex Class
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
    Flex_Framework_Settings.retrieveSettings();
    }
}