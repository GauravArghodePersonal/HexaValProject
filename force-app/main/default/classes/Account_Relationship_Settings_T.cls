@isTest
private class Account_Relationship_Settings_T {
/****************************************************************************
 * Test Class Account_Relationship_Settings_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Account_Relationship_Settings Trigger
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
	    Account_Relationship_Settings.relationshipsNeedProcessed();
	    Account_Relationship_Settings.relationshipsNeedProcessed(true);
	    Account_Relationship_Settings.relationshipsNeedProcessed(false);
	   	Account_Relationship_Settings.retrieveDefaultSettings();
   	}
}