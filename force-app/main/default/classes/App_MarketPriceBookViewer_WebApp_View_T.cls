@isTest
private class App_MarketPriceBookViewer_WebApp_View_T {
/****************************************************************************
 * Test Class App_MarketPriceBookViewer_WebApp_View_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - App_MarketPriceBookViewer_WebApp_View Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Market_Price_Book__c marketPriceBook;
    
    
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
    	marketPriceBook = new Market_Price_Book__c();
    	insert marketPriceBook; 
    }
  
    private static void executeTest01() {
        // Execute Tests
        ApexPages.currentpage().getparameters().put( 'id', marketPriceBook.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(marketPriceBook);
        App_MarketPriceBookViewer_WebApp_View_Ex e = new App_MarketPriceBookViewer_WebApp_View_Ex(sc);

		e.expireMPB();
		e.unexpireMPBandMakeDraft();
		
		e.redirectToMarketPriceBookExpirationPage();
    }
}