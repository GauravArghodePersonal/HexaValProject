@isTest
private class BatchRunnerBatchJob_T {
/****************************************************************************
 * Test Class BatchRunnerBatchJob_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - BatchRunnerBatchJob Apex Class
 *   - BatchRunnerJobs Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Market_Price_Book_Entry__c marketPriceBookEntry = new Market_Price_Book_Entry__c();
    public static Id mpbeId = marketPriceBookEntry.Id; 

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
		BatchRunner.addEntry('Market Price Book Entry Change',mpbeId);

		// Test the batch job
		BatchRunnerBatchJob.submitBatchJob();
    }
}