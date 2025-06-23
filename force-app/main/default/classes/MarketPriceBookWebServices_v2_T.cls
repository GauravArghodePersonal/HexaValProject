@isTest
private class MarketPriceBookWebServices_v2_T {
/****************************************************************************
 * Test Class MarketPriceBookWebServices_v2_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - MarketPriceBookWebServices_v2 Apex Class
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
    	XREF_Country_to_SalesOrg__c newRec = new XREF_Country_to_SalesOrg__c();
    	newRec.Cust_ShipTo_Country_Code__c = 'TEST';
    	newRec.Cust_ShipTo_Country__c = 'TEST';
    	newRec.Sales_Org__c = '1234';
    	insert newRec;
    }
  
    private static void executeTest01() {
        // Execute Tests
        MarketPriceBookWebServices_v2.getSalesOrgs();
        MarketPriceBookWebServices_v2.getDistChannels();
        MarketPriceBookWebServices_v2.getDivisions();
        MarketPriceBookWebServices_v2.getPACIndustrySegments();
        MarketPriceBookWebServices_v2.getCountries();
        List<String> prodFamiliesEmpty = new List<String>();
        List<String> prodFamilies = new List<String>();
        prodFamilies.add('100');
        List<String> prodSegmentsEmpty = new List<String>();
        List<String> prodSegments = new List<String>();
        MarketPriceBookWebServices_v2.getSegments('10',prodFamilies);
        prodSegments.add('100');
        MarketPriceBookWebServices_v2.getSegments('',prodFamilies);
        MarketPriceBookWebServices_v2.getSegments('10',prodFamilies);
        //MarketPriceBookWebServices_v2.getSegments('10',prodFamiliesEmpty);
        
        MarketPriceBookWebServices_v2.getFamilies('10');
        
        MarketPriceBookWebServices_v2.getSubSegments('',prodFamilies,prodSegments);
        //MarketPriceBookWebServices_v2.getSubSegments('10',prodFamilies,prodSegmentsEmpty);
        //MarketPriceBookWebServices_v2.getSubSegments('10',prodFamiliesEmpty,prodSegments);
        MarketPriceBookWebServices_v2.getSubSegments('10',prodFamilies,prodSegments);
        MarketPriceBookWebServices_v2.getCustomerGroup1s();
        MarketPriceBookWebServices_v2.getIncoTerms();
        //MarketPriceBookWebServices_v2.getMaterialUoms('');
        
        Account a = TestObjects.newAccount();
        Id blankId;
        MarketPriceBookWebServices_v2.getAccountDetails(a.Id);
        MarketPriceBookWebServices_v2.getEntriesAvailableforAccount(a.Id);
        //MarketPriceBookWebServices_v2.getEntriesAvailableforAccount(blankId);
        MarketPriceBookWebServices_v2.getEntriesRelatedtoAccount(a.Id);
        //MarketPriceBookWebServices_v2.getEntriesRelatedtoAccount(blankId);
        
        MarketPriceBookWebServices_v2.getAccountsRelatedtoMarketPriceBookKeyRecordCount(new List<String>(),
                                                                                     new List<String>(),
                                                                                     new List<String>(),
                                                                                     new List<String>(),
                                                                                     new List<String>(),
                                                                                     new List<String>(),
                                                                                     new List<String>(),
                                                                                     new List<String>(),
                                                                                     new List<String>(),
                                                                                     new List<String>(),
                                                                                     new List<String>()
                                                                                    );
        MarketPriceBookWebServices_v2.getMaterialsRelatedtoMarketPriceBookKeyRecordCount(new List<String>(),
                                                                                      new List<String>(),
                                                                                      new List<String>(),
                                                                                      new List<String>()
                                                                                     );   
		MarketPriceBookWebServices_v2.getAccountsRelatedtoMarketPriceBookKey(new List<String>(),
                                                                          new List<String>(),
											                              new List<String>(),
                                                                          new List<String>(),
                                                                          new List<String>(),
                                                                          new List<String>(),
                                                                          new List<String>(),
                                                                          new List<String>(),
                                                                          new List<String>(),
                                                                          new List<String>(),
                                                                          new List<String>()
                                                                         );    
                                                                         
    	Market_Price_Book_Entry__c marketPriceBookEntry1;
    	Market_Price_Book__c marketPriceBook = new Market_Price_Book__c();
    	insert marketPriceBook; 
    	
    	Material_Sales_Data2__c material = TestObjects.newMaterial_Sales_Data2(); 
    	
    	marketPriceBookEntry1 = new Market_Price_Book_Entry__c();
    	marketPriceBookEntry1.Market_Price_Book__c = marketPriceBook.Id;
    	marketPriceBookEntry1.Material_Sales_Data2__c = material.Id;
    	insert marketPriceBookEntry1;
                                   
        MarketPriceBookWebServices_v2.relateMarketPriceEntrytoAccount(marketPriceBookEntry1.Id,a.Id,'Softwire');                                                  
        MarketPriceBookWebServices_v2.relateMarketPriceEntrytoAccount(marketPriceBookEntry1.Id,a.Id,'Softwire');                                                  
        
        MarketPriceBookWebServices_v2.unrelateMarketPriceEntrytoAccount(marketPriceBookEntry1.Id,a.Id);
        MarketPriceBookWebServices_v2.unrelateMarketPriceEntrytoAccount(marketPriceBookEntry1.Id,a.Id);
        
		MarketPriceBookWebServices_v2.getMaterialUoms(material.Id);
		
		MarketPriceBookWebServices_v2.retrieveExistingMarketPriceBookCountforKey(
        'description',
        new List<String>(),       
        new List<String>(),       
        new List<String>(),       
        new List<String>(),
        new List<String>(),          
        new List<String>(),          
        new List<String>(),          
        new List<String>(),   
        new List<String>(),          
        new List<String>(),        
        new List<String>(),   
        new List<String>(),
        'segKey',
        Date.today(),
		Date.today(),
        'currencyValue'
		);
			
		MarketPriceBookWebServices_v2.retrieveMarketPriceBookStatus(marketPriceBook.Id);
		
		List<String> results = MarketPriceBookWebServices_v2.availableSalesOrgsForCountry('TEST');
		
		MarketPriceBookWebServices_v2.retrieveSelectionOptions();
		MarketPriceBookWebServices_v2.retrieveMarketPriceBookEntries('','','','',Date.today(),'','x');
    }
}