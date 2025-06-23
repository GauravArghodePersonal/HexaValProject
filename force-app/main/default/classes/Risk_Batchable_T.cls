@isTest
private class Risk_Batchable_T {
/****************************************************************************
 * Test Class Risk_Batchable_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Risk_Batchable Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
    //Test Settings
    
    
    private static testMethod void unitTest() {
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
        Risk_Batchable.submitBatchJob(Risk_Batchable.CREATE_NEW_RISKS_DATA, 10);
        Risk_Batchable.submitBatchJob(Risk_Batchable.ACTIVATE_NEW_RISKS_DATA, 10);
    }
}