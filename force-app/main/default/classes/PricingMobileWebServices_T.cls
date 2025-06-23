@isTest
private class PricingMobileWebServices_T {
/****************************************************************************
 * Test Class PricingMobileWebServices_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - PricingMobileWebServices Apex Class
 ****************************************************************************/
 
    //Test Data
    private static Account shipTo, soldTo, soldTo2, cHerky, invalidAcc;
    private static Material_Sales_Data2__c msd2;
    private static Pricing_Condition__c priceCond1, priceCond2, priceCond3;
    private static List<Pricing_Condition__c> pcs;
    private static Active_Pricing__c activePrice;
    
    //Test Settings
    
    
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
        Map<String,SObject> testData = TestScenarios.createAccountsWithRelationshipMaterialandPCObjects();
        cHerky = (Account)testData.get('cHerky');
        soldTo = (Account)testData.get('soldTo');
        shipTo = (Account)testData.get('shipTo');
        invalidAcc = (Account)testData.get('invalidAcc');
        msd2 = (Material_Sales_Data2__c)testData.get('msd2');
        priceCond1 = (Pricing_Condition__c)testData.get('priceCond1');
        priceCond2 = (Pricing_Condition__c)testData.get('priceCond2');
        priceCond3 = (Pricing_Condition__c)testData.get('priceCond3');
    }
  
    private static void executeTest01() {
        // Execute Tests
//        Id ownerId = [SELECT Id FROM User LIMIT 1].Id;
        
//        Account account = new Account();
//        account.Name = 'Test Account';
//        insert account;
        
//        Pricing_Condition__c pc = [SELECT Id FROM Pricing_Condition__c LIMIT 1];
        
        Date dt = Date.Today();
        
        PricingMobileWebServices.retrieveAccounts(shipTo.ownerId);
        PricingMobileWebServices.retrieveAccountDetails(shipTo.Id);
        PricingMobileWebServices.retrievePricingConditions(shipTo.Id);
        PricingMobileWebServices.retrievePricingConditionDetails(priceCond1.Id);
        PricingMobileWebServices.expirePricingCondition(priceCond1.Id,''); 
        PricingMobileWebServices.extendPricingCondition(priceCond1.Id,'',dt); 
    }
}