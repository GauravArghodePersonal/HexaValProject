@isTest
private class Apex_Batch_Jobs_Controller_T {
/****************************************************************************
 * Test Class for Apex_Batch_Jobs_Controller_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Apex_Batch_Jobs_Controller Apex Class
 ****************************************************************************/
 
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
        Apex_Batch_Jobs_Controller abjc = new Apex_Batch_Jobs_Controller();
        abjc.getBatchJobs();
      AsyncApexJob aaj = new AsyncApexJob();
        abjc.getBatchJob(aaj);
        Apex_Batch_Jobs_Controller.BatchJob bj = new Apex_Batch_Jobs_Controller.BatchJob();
        String status = 'Processing';
        //abjc.updateBatchJob(bj, 100, 200, status);
        //abjc.getBatchJobs();

        bj.CreatedDate = System.Now();
        bj.CompletedDate = System.Now();
        bj.Records_Processed = 100;
        bj.Total_Records = 200;
        String s1 = bj.getEstimatedCompletionDateTime();
        String s2 = bj.getFormatted_CompletedDate();
        String s3 = bj.getFormatted_CreatedDate();
        Boolean b = bj.getItemCompleted();
    }
}