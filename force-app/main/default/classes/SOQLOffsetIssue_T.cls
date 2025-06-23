@isTest
private class SOQLOffsetIssue_T {
/****************************************************************************
 * Test Class SOQLOffsetIssue_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - SOQLOffsetIssue Apex Class
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
        SOQLOffsetIssue s = new SOQLOffsetIssue();
        
        s.getSOQLRowCount();
        s.getSOQLDataLimit100();
        s.getSOQLDataOffset0();
        s.getSOQLDataOffset10();
        s.getSOQLDataOffset20();
        s.getSOQLDataOffset25();
        s.getSOQLDataOffset30();
    }
}