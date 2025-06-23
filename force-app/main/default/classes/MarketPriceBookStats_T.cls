@isTest
private class MarketPriceBookStats_T {
/****************************************************************************
 * Test Class MarketPriceBookStats
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - MarketPriceBookStats Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Market_Price_Book__c marketPriceBook;
    public static Market_Price_Book_Entry__c marketPriceBookEntry1;
    public static List<Id> mpbeIds = new List<Id>();
    
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    	marketPriceBook = new Market_Price_Book__c();
    	insert marketPriceBook;
    	
    	Material_Sales_Data2__c material = TestObjects.newMaterial_Sales_Data2(); 
    	
    	marketPriceBookEntry1 = new Market_Price_Book_Entry__c();
    	marketPriceBookEntry1.Market_Price_Book__c = marketPriceBook.Id;
    	marketPriceBookEntry1.Material_Sales_Data2__c = material.Id;
    	insert marketPriceBookEntry1;
    	
    	mpbeIds.Add(marketPriceBookEntry1.Id);
    }
  
    private static void executeTest01() {
        // Execute Tests
        MarketPriceBookStats stats = new MarketPriceBookStats(marketPriceBook.Id);
    }
}