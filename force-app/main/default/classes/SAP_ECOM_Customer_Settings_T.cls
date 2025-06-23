@isTest
private class SAP_ECOM_Customer_Settings_T {
/****************************************************************************
 * Test Class SAP_ECOM_Customer_Settings_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - SAP_ECOM_Customer_Settings Apex Class
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
		SAP_ECOM_Customer_Settings.retrieveDefaultSettings();
		SAP_ECOM_Customer_Settings.createDefaultSettings();
		SAP_ECOM_Customer_Settings.retrieveAccountLastRunDateTime();
		SAP_ECOM_Customer_Settings.updateAccountLastRunDateTime(System.now());
		SAP_ECOM_Customer_Settings.retrieveAccountNewBatchJobStarted();
		SAP_ECOM_Customer_Settings.updateAccountNewBatchJobStarted(System.now());
		SAP_ECOM_Customer_Settings.retrieveAccountBatchJobRunning();
		SAP_ECOM_Customer_Settings.updateAccountBatchJobRunning(false);
		SAP_ECOM_Customer_Settings.updateAccountBatchJobRunning(true);
    }
}