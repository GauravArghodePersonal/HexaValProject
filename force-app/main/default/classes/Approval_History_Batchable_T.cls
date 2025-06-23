@isTest
private class Approval_History_Batchable_T {
/****************************************************************************
 * Test Class Approval_History_Batchable_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Approval_History_Batchable Apex Class
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

        Approval_History_Batchable b = new Approval_History_Batchable(Approval_History_Batchable.PRICING_CONDITION, 1);
        //b.debug('Test');
        //b.sendEmail('Test', 'Test');
        b.queryString += ' limit 10';
        Database.executeBatch(b);
    }
}