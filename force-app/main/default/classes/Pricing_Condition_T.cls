@isTest
private class Pricing_Condition_T {
/****************************************************************************
 * Test Class Pricing_Condition_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Pricing_Condition_T Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Market_Price_Book_Entry__c marketPriceBookEntry1;
    public static Market_Price_Book_Scaled_Pricing_Entry__c sp;
    
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
        
        sp = new Market_Price_Book_Scaled_Pricing_Entry__c();
        sp.Market_Price_Book_Entry__c = marketPriceBookEntry1.Id;
        sp.Selling_Price__c = 0;
        insert sp;
    }
  
    private static void executeTest01() {
        // Execute Tests
        Market_Price_Book_Entry mpbe = new Market_Price_Book_Entry(marketPriceBookEntry1);
        mpbe.mpbEntryScales = new List<Market_Price_Book_Scaled_Pricing_Entry__c>();
        mpbe.mpbEntryScales.add(sp);
        
        Map<String,SObject> testData = TestScenarios.createAccountsWithRelationshipMaterialandPCObjects('00000000','010000000123456789','1234','12');
        Account cHerky = (Account)testData.get('cHerky');
        Account soldTo = (Account)testData.get('soldTo');
        Account soldTo2 = (Account)testData.get('soldTo2');
        Account shipTo = (Account)testData.get('shipTo');
        Account invalidAcc = (Account)testData.get('invalidAcc');
        CISRelationships__c CR1 = (CISRelationships__c)testData.get('CR1');
        CISRelationships__c CR2 = (CISRelationships__c)testData.get('CR2');
        CISRelationships__c CR3 = (CISRelationships__c)testData.get('CR3');
        CISRelationships__c CR4 = (CISRelationships__c)testData.get('CR4');
        Material_Sales_Data2__c msd2 = (Material_Sales_Data2__c)testData.get('msd2');
        Pricing_Condition__c priceCond1 = (Pricing_Condition__c)testData.get('priceCond1');
        Pricing_Condition__c priceCond2 = (Pricing_Condition__c)testData.get('priceCond2');
        Pricing_Condition__c priceCond3 = (Pricing_Condition__c)testData.get('priceCond3');
        
        priceCond1.Market_Price_Book_Entry__c = marketPriceBookEntry1.Id;
        
        mpbe.updateRelatedPricingConditions();

        Pricing_Condition.getPricingConditionKey(priceCond1);
        //priceCond1.Dist_Channel_Code__c = '50';
        //update priceCond1;
        //Pricing_Condition.getPricingConditionKey(priceCond1);
        Pricing_Condition pr = new Pricing_Condition(priceCond1);
        Map<Id, Set<String>> amap =  new Map<Id, Set<String>>();
        pr.setApprovers(amap);
        
        priceCond1.Market_Pricing_Type__c = 'softWired';
        update priceCond1;
        
        Pricing_Condition pricing_condition1 = new Pricing_Condition(priceCond1);
        
        pricing_condition1.updatePricingwithMarketPriceBookEntry(mpbe);
    }
}