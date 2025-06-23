@isTest
private class App_MarketPriceToCustomer_OverrideExt_T {
/****************************************************************************
 * Test Class App_MarketPriceToCustomer_OverrideExt_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - App_MarketPriceToCustomer_OverrideExt Apex Class
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

    	Market_Price_Book_Entry__c marketPriceBookEntry1;
    	Market_Price_Book__c marketPriceBook = new Market_Price_Book__c();
    	insert marketPriceBook; 
    	
    	Material_Sales_Data2__c material = TestObjects.newMaterial_Sales_Data2(); 
    	
    	marketPriceBookEntry1 = new Market_Price_Book_Entry__c();
    	marketPriceBookEntry1.Market_Price_Book__c = marketPriceBook.Id;
    	marketPriceBookEntry1.Material_Sales_Data2__c = material.Id;
    	insert marketPriceBookEntry1;

        
        Account_To_Market_Price_Book_Entry__c aToe = new Account_To_Market_Price_Book_Entry__c();
        aToe.Account__c = a.Id;
        aToe.Market_Price_Book_Entry__c = marketPriceBookEntry1.Id;
        aToe.Material_Sales_Data2__c = material.Id;
        insert aToe;
        
        //ApexPages.currentpage().getparameters().put('id', a.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(aToe); 
        App_MarketPriceToCustomer_OverrideExt b = new App_MarketPriceToCustomer_OverrideExt(sc);    }
}