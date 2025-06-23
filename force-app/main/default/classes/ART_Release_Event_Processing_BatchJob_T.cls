@isTest
private class ART_Release_Event_Processing_BatchJob_T {
/****************************************************************************
 * Test Class ART_Release_Event_Processing_BatchJob_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ART_Release_Event_Processing_BatchJob Apex Class
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
        ART_Release__c release = TestObjects.newART_Release();
        ART_Release__c release2 = TestObjects.newART_Release();
    }
  
    private static void executeTest01() {
        // Execute Tests
		ART_Release_Event_Processing_BatchJob.submitBatchJob();    
		ART_Release_Event_Processing_BatchJob.submitBatchJob(10);    
	}
}