@isTest
private class PricingWebServices_T {
/****************************************************************************
 * Test Class PricingWebServices_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - PricingWebServices Apex Class
 ****************************************************************************/
 
    //Test Data
    private static Account shipTo, soldTo, soldTo2, cHerky, invalidAcc;
    private static Material_Sales_Data2__c msd2;
    private static Pricing_Condition__c priceCond1, priceCond2, priceCond3;
    private static List<Pricing_Condition__c> pcs;
    private static Active_Pricing__c activePrice;
    private static Market_Price_Book__c mp;
    private static Market_Price_Book_Entry__c mpe;
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        Map<String,SObject> testData = TestScenarios.createAccountsWithRelationshipMaterialandPCObjects();
        cHerky = (Account)testData.get('cHerky');
        soldTo = (Account)testData.get('soldTo');
        shipTo = (Account)testData.get('shipTo');
        invalidAcc = (Account)testData.get('invalidAcc');
        msd2 = (Material_Sales_Data2__c)testData.get('msd2');
        priceCond1 = (Pricing_Condition__c)testData.get('priceCond1');
        priceCond2 = (Pricing_Condition__c)testData.get('priceCond2');
        priceCond3 = (Pricing_Condition__c)testData.get('priceCond3');
        
        mp = new Market_Price_Book__c();
        insert mp;
        
        mpe = new Market_Price_Book_Entry__c();
        mpe.Market_Price_Book__c = mp.Id;
        insert mpe;
        
        
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
    }
  
    private static void executeTest01() {
        // Execute Tests
        PricingWebServices.getRelatedMarketPricingDetailsforAccountId(shipTo.Id);
        PricingWebServices.retrieveMarketPricingEntryforAccountMaterial(shipTo.Id,msd2.Id);

        PricingWebServices.retrieveMarketPricingEntryforId(mp.Id);

        PricingWebServices.updatePricingConditionswithMarketPricingforMarketPriceEntry(mpe.Id);
        PricingWebServices.updatePricingConditionfromMarketPriceBookEntry(priceCond1.Id, mpe.Id);
        //PricingWebServices.cloneAndSubmitForApproval(priceCond1,0,0,Date.today(),Date.today(),false);
        //PricingWebServices.cloneAndSubmitForApproval(priceCond1,0,0,Date.today(),Date.today(),true);
        
        PricingWebServices.getRelatedAccounts(soldTo.Id);
        PricingWebServices.retrievePricingWizardSettings();
        
        PricingWebServices.getPACIndustrySegments('');
        PricingWebServices.getPACIndustrySegments(mp.Id);
        PricingWebServices.retrievePricingConditionsforMPBECount(mp.Id);
        PricingWebServices.retrievePricingConditionsforMPBECount(null);
        PricingWebServices.retrievePricingConditionsforMPBE(mpe.Id);
        PricingWebServices.retrievePricingConditionsforMPBE(null);
        
        PricingWebServices.retrieveActivePricingConditionsforAccountandMPB(soldTo.Id, mp.Id);
        
        PricingWebServices.retrieveActivePricingConditionsforAccountandMPBE(soldTo.Id, mpe.Id);
        List<Id> marketPriceBookEntryIds = new List<Id>();
        marketPriceBookEntryIds.add(mpe.Id);
        PricingWebServices.retrieveActivePricingConditionsforAccountandMPBEs(soldTo.Id, marketPriceBookEntryIds);
        
        PricingWebServices.retrievePACIndustrySegmentsForMarketPriceBook(mp.Id);
        
        PricingWebServices.getAccountLisds(shipTo.Id);
        
        PricingWebServices.LISDData l = new PricingWebServices.LISDData();
        
        PricingWebServices.getLISDData(soldTo.Id,
                                       'industryValue', 
                                       'endUseCustValue', 
                                       'salesDstValue', 
                                       'salesOfcValue', 
                                       'salesGrpValue', 
                                       'custGroupValue'
                                  );
        
        PricingWebServices.retrieveActivePricingConditionsforAccountandMPBandMaterial(shipTo.Id, mp.Id, priceCond1.Material2__c);

        PricingWebServices.retrieveActivePricingConditionsforAccountandMaterial(shipTo.Id, priceCond1.Material2__c);

        PricingWebServices.newAssociatedPricingConditionCanBeCreated(priceCond1.Id, shipTo.Id, priceCond1.Material2__c, mp.Id);

        PricingWebServices.retrieveActivePricingConditionsforAccountandMPBE(shipTo.Id, mpe.Id);
    }
}