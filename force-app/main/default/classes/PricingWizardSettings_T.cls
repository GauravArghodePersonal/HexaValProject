@isTest
private class PricingWizardSettings_T {

/****************************************************************************
 * Test Class PricingWizardSettings_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - PricingWizardSettings Apex Class
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
		PricingWizardSettings.retrieveSettings();
    }



}