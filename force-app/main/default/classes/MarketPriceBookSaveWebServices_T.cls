@isTest
private class MarketPriceBookSaveWebServices_T {
/****************************************************************************
 * Test Class MarketPriceBookSaveWebServices_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - MarketPriceBookSaveWebServices Apex Class
 ****************************************************************************/
 
    //Test Data
    private static Id accountId;
    private static Account shipTo, soldTo, cHerky, invalidAcc;
    
    private static testMethod void myUnitTest() {
    
//Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        
        
        
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = '01250000000HmZV';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        pfxCustomList.add(p1);
        
        PriceFx__c p2 = new PriceFx__c();
        p2.allowed_recordtype_id__c = '01250000000HmZV';
        p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p2.Name='callCustomerProductInfo2';
        p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p2.password__c='Testuser@123';
        p2.username__c='sfdctestuser';
        pfxCustomList.add(p2);
        
        PriceFx__c p3 = new PriceFx__c();
        p3.allowed_recordtype_id__c = '01250000000HmZV';
        p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p3.Name='callMaterialPlant2';
        p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p3.password__c='Testuser@123';
        p3.username__c='sfdctestuser';
        pfxCustomList.add(p3);
        
        insert pfxCustomList;

        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        Map<String,SObject> testData = TestScenarios.createAccountsWithRelationshipObjects();
        cHerky = (Account)testData.get('cHerky');
        soldTo = (Account)testData.get('soldTo');
        shipTo = (Account)testData.get('shipTo');
        invalidAcc = (Account)testData.get('invalidAcc');
    }
  
    private static void executeTest01() {
        // Execute Tests
        List<Id> idsToDelete = new List<Id>();
        idsToDelete.add(invalidAcc.Id);
        MarketPriceBookSaveWebServices.deleteRecords('abc',idsToDelete);
        MarketPriceBookSaveWebServices.deleteRecords('Account',idsToDelete);

        Market_Price_Book__c mpb = new Market_Price_Book__c(); 
        List<Market_Price_Book_Country__c> mpbcListToUpsert = new List<Market_Price_Book_Country__c>();          
        List<Market_Price_Book_Customer_Group_1__c> mpbcg1ListToUpsert = new List<Market_Price_Book_Customer_Group_1__c>();        
        List<Market_Price_Book_Dist_Channel__c> mpbdcListToUpsert = new List<Market_Price_Book_Dist_Channel__c>();       
        List<Market_Price_Book_Division__c> mpbdListToUpsert = new List<Market_Price_Book_Division__c>();       
        List<Market_Price_Book_Family__c> mpbfListToUpsert = new List<Market_Price_Book_Family__c>();          
        List<Market_Price_Book_IncoTerm__c> mpbitListToUpsert = new List<Market_Price_Book_IncoTerm__c>();          
        List<Market_Price_Book_PAC_Industry_Segment__c> mpbpisListToUpsert = new List<Market_Price_Book_PAC_Industry_Segment__c>();
        List<Market_Price_Book_Product_Line__c> mpbplListToUpsert = new List<Market_Price_Book_Product_Line__c>();
        List<Market_Price_Book_Sales_Org__c> mpbsoListToUpsert = new List<Market_Price_Book_Sales_Org__c>();       
        List<Market_Price_Book_Segment__c> mpbsListToUpsert = new List<Market_Price_Book_Segment__c>();          
        List<Market_Price_Book_Sub_Segment__c> mpbssListToUpsert = new List<Market_Price_Book_Sub_Segment__c>();
        List<Market_Price_Book_VCP_Rating__c> mpbvcpListToUpsert = new List<Market_Price_Book_VCP_Rating__c>();
        List<Market_Price_Book_Default_Scale__c> mpbdsListToUpsert = new List<Market_Price_Book_Default_Scale__c>();
           
        List<Market_Price_Book_Country__c> mpbcListToDelete = new List<Market_Price_Book_Country__c>();          
        List<Market_Price_Book_Customer_Group_1__c> mpbcg1ListToDelete = new List<Market_Price_Book_Customer_Group_1__c>();        
        List<Market_Price_Book_Dist_Channel__c> mpbdcListToDelete = new List<Market_Price_Book_Dist_Channel__c>();       
        List<Market_Price_Book_Division__c> mpbdListToDelete = new List<Market_Price_Book_Division__c>();       
        List<Market_Price_Book_Family__c> mpbfListToDelete = new List<Market_Price_Book_Family__c>();          
        List<Market_Price_Book_IncoTerm__c> mpbitListToDelete = new List<Market_Price_Book_IncoTerm__c>();          
        List<Market_Price_Book_PAC_Industry_Segment__c> mpbpisListToDelete = new List<Market_Price_Book_PAC_Industry_Segment__c>();
        List<Market_Price_Book_Product_Line__c> mpbplListToDelete = new List<Market_Price_Book_Product_Line__c>();
        List<Market_Price_Book_Sales_Org__c> mpbsoListToDelete = new List<Market_Price_Book_Sales_Org__c>();       
        List<Market_Price_Book_Segment__c> mpbsListToDelete = new List<Market_Price_Book_Segment__c>();          
        List<Market_Price_Book_Sub_Segment__c> mpbssListToDelete = new List<Market_Price_Book_Sub_Segment__c>();        
        List<Market_Price_Book_VCP_Rating__c> mpbvcpListToDelete = new List<Market_Price_Book_VCP_Rating__c>();
        List<Market_Price_Book_Default_Scale__c> mpbdsListToDelete = new List<Market_Price_Book_Default_Scale__c>();

        mpbcListToUpsert.add(new Market_Price_Book_Country__c());
        mpbcg1ListToUpsert.add(new Market_Price_Book_Customer_Group_1__c());
        mpbdcListToUpsert.add(new Market_Price_Book_Dist_Channel__c());
        mpbdListToUpsert.add(new Market_Price_Book_Division__c());
        mpbfListToUpsert.add(new Market_Price_Book_Family__c());
        mpbitListToUpsert.add(new Market_Price_Book_IncoTerm__c());
        mpbpisListToUpsert.add(new Market_Price_Book_PAC_Industry_Segment__c());
        mpbplListToUpsert.add(new Market_Price_Book_Product_Line__c());
        mpbsoListToUpsert.add(new Market_Price_Book_Sales_Org__c());
        mpbsListToUpsert.add(new Market_Price_Book_Segment__c());
        mpbssListToUpsert.add(new Market_Price_Book_Sub_Segment__c());
        mpbvcpListToUpsert.add(new Market_Price_Book_VCP_Rating__c());
        mpbdsListToUpsert.add(new Market_Price_Book_Default_Scale__c());

        MarketPriceBookSaveWebServices.upsertMarketPriceBook(
            mpb, 
            mpbcListToUpsert,mpbcg1ListToUpsert,mpbdcListToUpsert,mpbdListToUpsert,mpbfListToUpsert,mpbitListToUpsert,          
            mpbpisListToUpsert,mpbplListToUpsert,mpbsoListToUpsert,mpbsListToUpsert,mpbssListToUpsert,mpbvcpListToUpsert,mpbdsListToUpsert,  
            mpbcListToDelete,mpbcg1ListToDelete,mpbdcListToDelete,mpbdListToDelete,mpbfListToDelete,mpbitListToDelete,          
            mpbpisListToDelete,mpbplListToDelete,mpbsoListToDelete,mpbsListToDelete,mpbssListToDelete,mpbvcpListToDelete,mpbdsListToDelete        
        );

        Market_Price_Book_Entry__c mpbEntry = new Market_Price_Book_Entry__c();
        List<Market_Price_Book_Scaled_Pricing_Entry__c> mpbEntryScales = new List<Market_Price_Book_Scaled_Pricing_Entry__c>(); 

        MarketPriceBookSaveWebServices.upsertMarketPriceBookEntry(mpbEntry,mpbEntryScales);

        List<Market_Price_Book_Entry> mpbEntries = new List<Market_Price_Book_Entry>();
        
        Market_Price_Book_Entry mpbe1 = new Market_Price_Book_Entry();
        mpbe1.marketPriceBookEntry = new Market_Price_Book_Entry__c();
        mpbe1.marketPriceBookEntry.Market_Price_Book__c = mpb.Id;
        Market_Price_Book_Scaled_Pricing_Entry__c scale1 = new Market_Price_Book_Scaled_Pricing_Entry__c();
        mpbe1.mpbEntryScales = new List<Market_Price_Book_Scaled_Pricing_Entry__c>();
        mpbe1.mpbEntryScales.add(scale1);
        mpbEntries.add(mpbe1);

        Market_Price_Book_Entry mpbe2 = new Market_Price_Book_Entry();
        mpbe2.marketPriceBookEntry = new Market_Price_Book_Entry__c();
        mpbe2.marketPriceBookEntry.Market_Price_Book__c = mpb.Id;
        Market_Price_Book_Scaled_Pricing_Entry__c scale2 = new Market_Price_Book_Scaled_Pricing_Entry__c();
        mpbe2.mpbEntryScales = new List<Market_Price_Book_Scaled_Pricing_Entry__c>();
        mpbe2.mpbEntryScales.add(scale2);
        mpbEntries.add(mpbe2);
        
        MarketPriceBookSaveWebServices.upsertMarketPriceBookEntries(mpbEntries);
    }
        
}