@isTest
private class MarketPriceBookExpiration_Ext_T {
/****************************************************************************
 * Test Class MarketPriceBookExpiration_Ext
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - MarketPriceBookExpiration_Ext Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Market_Price_Book__c marketPriceBook;
    
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
    }
  
    private static void executeTest01() {
        // Execute Tests
        ApexPages.currentpage().getparameters().put( 'id', marketPriceBook.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(marketPriceBook);
        MarketPriceBookExpiration_Ext e = new MarketPriceBookExpiration_Ext(sc);

		Boolean warningNeeded = e.warningNeeded;
		
		e.redirectToMarketPriceBookViewerPage();
    }
}