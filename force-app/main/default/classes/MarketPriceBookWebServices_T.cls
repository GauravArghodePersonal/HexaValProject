@isTest
private class MarketPriceBookWebServices_T {
/****************************************************************************
 * Test Class MarketPriceBookWebServices_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - MarketPriceBookWebServices Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
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
        MarketPriceBookWebServices.getSalesOrgs();
        MarketPriceBookWebServices.getDistChannels();
        MarketPriceBookWebServices.getDivisions();
        MarketPriceBookWebServices.getPACIndustrySegments();
        MarketPriceBookWebServices.getCountries();
        List<String> prodFamiliesEmpty = new List<String>();
        List<String> prodFamilies = new List<String>();
        prodFamilies.add('100');
        List<String> prodSegmentsEmpty = new List<String>();
        List<String> prodSegments = new List<String>();
        MarketPriceBookWebServices.getSegments('10',prodFamilies);
        prodSegments.add('100');
        MarketPriceBookWebServices.getSegments('',prodFamilies);
        MarketPriceBookWebServices.getSegments('10',prodFamilies);
        //MarketPriceBookWebServices.getSegments('10',prodFamiliesEmpty);
        
        MarketPriceBookWebServices.getFamilies('10');
        
        MarketPriceBookWebServices.getSubSegments('',prodFamilies,prodSegments);
        //MarketPriceBookWebServices.getSubSegments('10',prodFamilies,prodSegmentsEmpty);
        //MarketPriceBookWebServices.getSubSegments('10',prodFamiliesEmpty,prodSegments);
        MarketPriceBookWebServices.getSubSegments('10',prodFamilies,prodSegments);
        MarketPriceBookWebServices.getCustomerGroup1s();
        MarketPriceBookWebServices.getIncoTerms();
        //MarketPriceBookWebServices.getMaterialUoms('');
        
        Account a = TestObjects.newAccount();
        Id blankId;
        MarketPriceBookWebServices.getAccountDetails(a.Id);
        MarketPriceBookWebServices.getEntriesAvailableforAccount(a.Id);
        //MarketPriceBookWebServices.getEntriesAvailableforAccount(blankId);
        MarketPriceBookWebServices.getEntriesRelatedtoAccount(a.Id);
        //MarketPriceBookWebServices.getEntriesRelatedtoAccount(blankId);
        
        MarketPriceBookWebServices.getAccountsRelatedtoMarketPriceBookKeyRecordCount(new List<String>(),
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
        MarketPriceBookWebServices.getMaterialsRelatedtoMarketPriceBookKeyRecordCount(new List<String>(),
                                                                                      new List<String>(),
                                                                                      new List<String>(),
                                                                                      new List<String>()
                                                                                     );   
		MarketPriceBookWebServices.getAccountsRelatedtoMarketPriceBookKey(new List<String>(),
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
                                   
        MarketPriceBookWebServices.relateMarketPriceEntrytoAccount(marketPriceBookEntry1.Id,a.Id,'Softwire');                                                  
        MarketPriceBookWebServices.relateMarketPriceEntrytoAccount(marketPriceBookEntry1.Id,a.Id,'Softwire');                                                  
        
        MarketPriceBookWebServices.unrelateMarketPriceEntrytoAccount(marketPriceBookEntry1.Id,a.Id);
        MarketPriceBookWebServices.unrelateMarketPriceEntrytoAccount(marketPriceBookEntry1.Id,a.Id);
        
		MarketPriceBookWebServices.getMaterialUoms(material.Id);
		
		MarketPriceBookWebServices.retrieveExistingMarketPriceBookCountforKey(
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
			
		MarketPriceBookWebServices.retrieveMarketPriceBookStatus(marketPriceBook.Id);
		
		List<String> results = MarketPriceBookWebServices.availableSalesOrgsForCountry('TEST');
		
		MarketPriceBookWebServices.retrieveSelectionOptions();
		MarketPriceBookWebServices.retrieveMarketPriceBookEntries('','','','',Date.today(),'','x');
    }
}