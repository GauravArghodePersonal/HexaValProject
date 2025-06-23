@isTest
private class BatchRunnerSchedulable_T {
/****************************************************************************
 * Test Class BatchRunnerSchedulable_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - BatchRunnerSchedulable Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Market_Price_Book_Entry__c marketPriceBookEntry = new Market_Price_Book_Entry__c();
    public static Id mpbeId = marketPriceBookEntry.Id; 
    
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

		// Test Scheduling the BatchRunnerSchedulable Job
		System.schedule('BatchRunnerSchedulable','0 0 * * * ?',new BatchRunnerSchedulable());
    }
}