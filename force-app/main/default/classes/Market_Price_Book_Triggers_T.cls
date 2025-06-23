@isTest
private class Market_Price_Book_Triggers_T {
/****************************************************************************
 * Test Class Market_Price_Book_Triggers_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Market_Price_Book_Country_Trigger
 *   - Market_Price_Book_Customer_Group_1_Trigger
 *   - Market_Price_Book_Dist_Channel_Trigger
 *   - Market_Price_Book_Division_Trigger
 *   - Market_Price_Book_Family_Trigger
 *   - Market_Price_Book_IncoTerm_Trigger
 *   - Market_Price_Book_PAC_Industry_Segment_Trigger
 *   - Market_Price_Book_Product_Line_Trigger
 *   - Market_Price_Book_Sales_Org_Trigger
 *   - Market_Price_Book_Segment_Trigger
 *   - Market_Price_Book_Sub_Segment_Trigger
 *   - Market_Price_Book_VCP_Rating_Trigger
 *   - MarketPriceBookEntryTrigger
 *   - MarketPriceBookScaledPricingEntryTrigger
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
        
	    Market_Price_Book_Scaled_Pricing_Entry__c sp;
        sp = new Market_Price_Book_Scaled_Pricing_Entry__c();
    	sp.Market_Price_Book_Entry__c = marketPriceBookEntry1.Id;
    	sp.Selling_Price__c = 0;
    	insert sp;
        
        update marketPriceBookEntry1;
        update sp;
        
		//Market_Price_Book_Entry__c entry = new Market_Price_Book_Entry__c();
		Market_Price_Book_Country__c country = new Market_Price_Book_Country__c();
		country.Market_Price_Book__c = marketPriceBook.Id;
		insert country;
		Market_Price_Book_Customer_Group_1__c custgrp1 = new Market_Price_Book_Customer_Group_1__c();
		custgrp1.Market_Price_Book__c = marketPriceBook.Id;
		insert custgrp1;
		Market_Price_Book_Dist_Channel__c distChannel = new Market_Price_Book_Dist_Channel__c();
		distChannel.Market_Price_Book__c = marketPriceBook.Id;
		insert distChannel;
		Market_Price_Book_Division__c div = new Market_Price_Book_Division__c();
		div.Market_Price_Book__c = marketPriceBook.Id;
		insert div;
		Market_Price_Book_Family__c family = new Market_Price_Book_Family__c();
		family.Market_Price_Book__c = marketPriceBook.Id;
		insert family;
		Market_Price_Book_IncoTerm__c incoterm = new Market_Price_Book_IncoTerm__c();
		incoterm.Market_Price_Book__c = marketPriceBook.Id;
		insert incoterm;
		Market_Price_Book_PAC_Industry_Segment__c pac = new Market_Price_Book_PAC_Industry_Segment__c();
		pac.Market_Price_Book__c = marketPriceBook.Id;
		insert pac;
		Market_Price_Book_Product_Line__c prodLine = new Market_Price_Book_Product_Line__c();
		prodLine.Market_Price_Book__c = marketPriceBook.Id;
		insert prodLine;
		Market_Price_Book_Sales_Org__c salesOrg = new Market_Price_Book_Sales_Org__c();
		salesOrg.Market_Price_Book__c = marketPriceBook.Id;
		insert salesOrg;
		Market_Price_Book_Segment__c segment = new Market_Price_Book_Segment__c();
		segment.Market_Price_Book__c = marketPriceBook.Id;
		insert segment;
		Market_Price_Book_Sub_Segment__c subsegment = new Market_Price_Book_Sub_Segment__c();
		subsegment.Market_Price_Book__c = marketPriceBook.Id;
		insert subsegment;
		Market_Price_Book_VCP_Rating__c vcpRating = new Market_Price_Book_VCP_Rating__c();
		vcpRating.Market_Price_Book__c = marketPriceBook.Id;
		vcpRating.VCP_Rating_Code__c = 'a';
		insert vcpRating;
    }
}