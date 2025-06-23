@isTest
private class Market_Price_Book_Entry_T {
/****************************************************************************
 * Test Class Market_Price_Book_Entry_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Market_Price_Book_Entry Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Market_Price_Book_Entry__c marketPriceBookEntry1;
    public static Market_Price_Book_Entry__c marketPriceBookEntry2;
    public static Market_Price_Book_Entry__c marketPriceBookEntry3;
    
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
    	Market_Price_Book__c marketPriceBook = new Market_Price_Book__c();
    	insert marketPriceBook; 
    	
    	marketPriceBookEntry1 = new Market_Price_Book_Entry__c();
    	marketPriceBookEntry1.Market_Price_Book__c = marketPriceBook.Id;
    	insert marketPriceBookEntry1;

    	marketPriceBookEntry2 = new Market_Price_Book_Entry__c();
    	marketPriceBookEntry2.Market_Price_Book__c = marketPriceBook.Id;
    	insert marketPriceBookEntry2;
    	
    	Market_Price_Book_Scaled_Pricing_Entry__c mpbeEntry = new Market_Price_Book_Scaled_Pricing_Entry__c();
    	mpbeEntry.Market_Price_Book_Entry__c = marketPriceBookEntry2.Id;
    	mpbeEntry.Minimum_Volume__c = 0;
    	insert mpbeEntry;
    	
    	Market_Price_Book_Scaled_Pricing_Entry__c mpbeEntry2 = new Market_Price_Book_Scaled_Pricing_Entry__c();
    	mpbeEntry2.Market_Price_Book_Entry__c = marketPriceBookEntry2.Id;
    	mpbeEntry2.Minimum_Volume__c = 0;
    	mpbeEntry2.Maximum_Volume__c = 1000;
    	insert mpbeEntry2;
    	
    	marketPriceBookEntry3 = [SELECT Id,
    	                                (SELECT Id,
    	                                        Minimum_Volume__c,
    	                                        Maximum_Volume__c,
    	                                        Floor_Price__c,
    	                                        Selling_Price__c,
    	                                        Quantity_Surcharge__c
    	                                   FROM Market_Price_Book_Scaled_Pricing_Entries__r)
    	                           FROM Market_Price_Book_Entry__c 
    	                          WHERE Id = :marketPriceBookEntry2.Id];
    }
  
    private static void executeTest01() {
        // Execute Tests
        Market_Price_Book_Entry mpbe = new Market_Price_Book_Entry();
        Market_Price_Book_Entry mpbe2 = new Market_Price_Book_Entry(marketPriceBookEntry1);
        Market_Price_Book_Entry mpbe3 = new Market_Price_Book_Entry(marketPriceBookEntry2,100);
        Market_Price_Book_Entry mpbe4 = new Market_Price_Book_Entry(marketPriceBookEntry3);
        Market_Price_Book_Entry mpbe5 = new Market_Price_Book_Entry(marketPriceBookEntry3,100);
        
        List<Id> marketPriceBookEntryIds = new List<Id>();
		
		//This should trigger exception logic        
        Market_Price_Book_Entry.processMarketPriceBookEntryChanges(marketPriceBookEntryIds);

		marketPriceBookEntryIds.add(marketPriceBookEntry1.Id);

		//This should trigger normal logic
        Market_Price_Book_Entry.processMarketPriceBookEntryChanges(marketPriceBookEntryIds);
        
        
        Account account;
        account = TestObjects.newAccount('',true);
        
        Pricing_Condition__c pc = new Pricing_Condition__c();
        pc.Account__c = account.Id;
        pc.Market_Price_Book_Entry__c = marketPriceBookEntry1.Id;
        insert pc;
        
        mpbe2.updateRelatedPricingConditions();
        
    }
}