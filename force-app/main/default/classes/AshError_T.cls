@isTest
private class AshError_T {
/****************************************************************************
 * Test Class AshError_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AshError Apex Class
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
		AshError error1 = new AshError('',AshError.SEVERITY_FATAL);
		AshError error2 = new AshError(1);
		AshError error3 = new AshError(1,'',AshError.SEVERITY_FATAL);
		
		error1.errorMessage();
		
		error1.apexPagesAddMessage();
    }
}