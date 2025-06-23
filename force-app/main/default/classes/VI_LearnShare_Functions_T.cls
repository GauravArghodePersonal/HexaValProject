@isTest
private class VI_LearnShare_Functions_T {
/****************************************************************************
 * Test Class VI_LearnShare_Functions_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - VI_LearnShare_Functions Apex Class
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

        //VI_LearnShare_Functions.debug('Test');
        //VI_LearnShare_Functions.getString('Test',1);
        //VI_LearnShare_Functions.sendEmail('Test');
        VI_LearnShare_Functions.refreshLearnShareRecords(10);
    }
}