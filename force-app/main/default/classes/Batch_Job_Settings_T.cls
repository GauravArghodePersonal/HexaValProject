@isTest
private class Batch_Job_Settings_T {
/****************************************************************************
* Test Class Batch_Job_Settings_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - Batch_Job_Settings Apex Class
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
        Batch_Job_Settings.retrieveBatchJobSettings('TEST',false);
        Batch_Job_Settings.retrieveBatchJobSettings('Batch_Job_Settings_T',false);
        Batch_Job_Settings.retrieveBatchJobSettings('Batch_Job_Settings_T',true);
    }
}