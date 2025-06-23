@isTest
private class ART_Release_Trigger_T {
/****************************************************************************
 * Test Class ART_Release_Trigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ART_Release_Trigger 
 ****************************************************************************/
 
    //Test Data
    public static ART_Release__c release;
    public static ART_Release__c release2;
    
    
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
        release = TestObjects.newART_Release();
        release2 = TestObjects.newART_Release();
    }
  
    private static void executeTest01() {
        // Execute Tests
        
        update release;
        
        delete release2;
        
        undelete release2;
	}
}