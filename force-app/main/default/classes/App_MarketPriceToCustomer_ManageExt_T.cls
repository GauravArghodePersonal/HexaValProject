@isTest
private class App_MarketPriceToCustomer_ManageExt_T {
/****************************************************************************
 * Test Class App_MarketPriceToCustomer_ManageExt_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - App_MarketPriceToCustomer_ManageExt Apex Class
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
        Account a = TestObjects.NewAccount();
        List<account> accountList = [SELECT Name FROM Account LIMIT 20];
        
        //ApexPages.currentpage().getparameters().put('id', a.Id);
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(accountList); 
        App_MarketPriceToCustomer_ManageExt b = new App_MarketPriceToCustomer_ManageExt(sc);
    }
}