@isTest
private class Attachment_Relationship_Settings_T {
/****************************************************************************
 * Test Class Attachment_Relationship_Settings_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Attachment_Relationship_Settings Trigger
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
		Attachment_Relationship_Settings.defaultSettings();
    }
}