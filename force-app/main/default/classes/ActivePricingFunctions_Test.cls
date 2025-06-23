@isTest
private class ActivePricingFunctions_Test {

    static Account shipTo, soldTo, cHerky, invalidAcc;
    static Material_Sales_Data2__c msd2;
    static Pricing_Condition__c priceCond1, priceCond2, priceCond3;
    static List<Pricing_Condition__c> pcs;
    static Active_Pricing__c activePrice;
    static String matnum = '010000000123456789';
    static String salesOrg = '1234';
    static String distChan = '12';
    static String salesArea = '00000000';
    static String DELIM = '|';
    
    static testMethod void myUnitTest() {
        Test.startTest();
        createTestData();
        //test01();
        //test02();
        Test.stopTest();
    }
    
    static void createTestData() {

        cHerky = new Account(Name = 'CHerky');
        cHerky.Account_Number__c = 'CHerky';
        insert cHerky;

        soldTo = new Account(Name = 'SoldTo');
        soldTo.Account_Number__c = 'SoldTo';
        soldTo.ParentId = cHerky.Id;
        insert soldTo;

        shipTo = new Account(Name = 'ShipTo');
        shipTo.Account_Number__c = 'ShipTo';
        insert shipTo;

        invalidAcc = new Account(Name = 'invalidAcc');
        invalidAcc.Account_Number__c = 'invalidAcc';
        insert invalidAcc;

        createCISRelationship(shipTo, CISRelationships_Functions.SHIPTO, shipTo);
        createCISRelationship(shipTo, CISRelationships_Functions.SOLDTO, soldTo);
        createCISRelationship(soldTo, CISRelationships_Functions.SOLDTO);
        createCISRelationship(invalidAcc, 'invalidAcc');

        msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
        insert msd2;

        Date fdate1 = System.today();
        Date tdate1 = fdate1.addDays(30);
        priceCond1 = new Pricing_Condition__c();
        priceCond1.Account__c = shipTo.Id;
        priceCond1.Material2__c = msd2.Id;
        priceCond1.Valid_From_Date__c = fdate1;
        priceCond1.Valid_To_Date__c = tdate1;
        priceCond1.Selling_Price__c = 10.0;
        insert priceCond1;
        String key = priceCond1.Account__c + DELIM +
                     priceCond1.Material2__c + DELIM +
                     priceCond1.Valid_From_Date__c + DELIM +
                     priceCond1.Valid_To_Date__c;
        System.debug(key);

        priceCond2 = new Pricing_Condition__c();
        priceCond2.Account__c = soldTo.Id;
        priceCond2.Material2__c = msd2.Id;
        priceCond2.Valid_From_Date__c = fdate1;
        priceCond2.Valid_To_Date__c = tdate1;
        priceCond2.Selling_Price__c = 10.0;
        insert priceCond2;

        priceCond3 = new Pricing_Condition__c();
        priceCond3.Account__c = cHerky.Id;
        priceCond3.Material2__c = msd2.Id;
        priceCond3.Valid_From_Date__c = fdate1;
        priceCond3.Valid_To_Date__c = tdate1;
        priceCond3.Selling_Price__c = 10.0;
        insert priceCond3;

        pcs = new List<Pricing_Condition__c>{priceCond1, priceCond2, priceCond3};
    }
    
    static CISRelationships__c createCISRelationship(Account sourceAcc,
                                                     String custType) {
        return createCISRelationship(sourceAcc, custType, null);
    }
    
    static CISRelationships__c createCISRelationship(Account sourceAcc,
                                                     String custType,
                                                     Account targetAcc) {
        CISRelationships__c cr = new CISRelationships__c();
        cr.Customer_Number__c = sourceAcc.Account_Number__c;
        cr.Customer_Type__c = custType;
        cr.Source_Customer__c = sourceAcc.Id;
        if (targetAcc != null) {
            cr.Target_Customer__c = targetAcc.Id;
        }
        cr.Ext_Unique_ID_c__c = cr.Source_Customer__c+cr.Customer_Number__c+salesArea+custType;
        insert cr;
        return cr;
    }
}