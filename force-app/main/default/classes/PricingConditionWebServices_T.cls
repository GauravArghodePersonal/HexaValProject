@isTest
private class PricingConditionWebServices_T {
/****************************************************************************
 * Test Class PricingConditionWebServices_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - PricingConditionWebServices Apex Class
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
            PricingConditionWebServices.getSalesOrgs();
    }
}