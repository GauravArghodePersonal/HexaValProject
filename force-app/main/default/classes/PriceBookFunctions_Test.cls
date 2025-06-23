@isTest
private class PriceBookFunctions_Test {

    static String langCode = 'E';
    static String prodLineCode = '000', prodLineCode2 = '002';
    static String prodLineDesc = 'PL1', prodLineDesc2 = 'PL2';
    static String familyCode = '000', familyCode2 = '002';
    static String sorgCode1 = '0000', sorgCode2 = '0002';
    static String salesArea = '00000000';
    static List<Price_Book__c> priceBooks;
    static Price_Book__c priceBook1, priceBook2;
    static Price_Book_Entry__c priceBookEntry;
    static Price_Book_Entry_Scaled_Pricing__c pbesp;
    static Price_Book_Service__c priceBookService;
    static SAP_Customer_Group__c customerGroup, customerGroup2;
    static SAP_Sales_Org__c salesOrg, salesOrg2;
    static SAP_Distribution_Channel__c distChan, distChan2;
    static SAP_Sales_Division__c division, division2;
    static SAP_Country_Name__c region, region2;
    static Material_Sales_Data2__c material, material2;
    static Product_Hierarchy2__c pherky;

    static Price_Book_Family__c pbFamily;
    static Price_Book_Region__c pbRegion;
    static Price_Book_Sales_Org__c pbSalesOrg;
    static Price_Book_Customer_Group__c pbCustGrp;
    static Price_Book_Product_Line__c pbProdLine;

    static Account parentAccount, acc;

//*
    static testMethod void myUnitTest01() {
        Test.startTest();
        createTestData();
        test01();
        Test.stopTest();
    }

    static testMethod void myUnitTest02() {
        Test.startTest();
        createTestData();
        test02();
        Test.stopTest();
    }

    static testMethod void myUnitTest04() {
        Test.startTest();
        String pbid = 'a3yQ000000000ZL';
        List<Price_Book__c> pbs = PriceBookFunctions.getPriceBooks(pbid);
        if (pbs != null && !pbs.isEmpty()) {
            Price_Book__c pb = pbs[0];
            pb.Record_Status__c = PriceBookFunctions.APPROVED;
            update pb;
        }
        Test.stopTest();
    }

    static testMethod void myUnitTest05() {
        Test.startTest();
        createTestData();
        test05();
        Test.stopTest();
    }

    static testMethod void myUnitTest06() {
        Test.startTest();
        createTestData();
        String accountId = acc.Id;
        String materialId = material.Id;
        Double annualVolume = 1000;
        Price_Book_Entry pbe = PriceBookEntryFunctions.getPriceBookEntry(accountId,
                                                                         materialId,
                                                                         annualVolume);
        System.debug(pbe);
        Test.stopTest();
    }

    static testMethod void myUnitTest07() {
        Test.startTest();
        createTestData();
        test07();
        Test.stopTest();
    }

    static TestMethod void myUnitTest08() {
        Test.startTest();
        createTestData();
        List<String> sorgCodes = new List<String>{sorgCode2};
        PriceBookSalesOrgExtendController c = new PriceBookSalesOrgExtendController();
        c.init();
        c.fromSalesOrg = sorgCode1;
        c.setSalesOrgs1(sorgCodes);
        c.getSalesOrgs1();
        c.setSalesOrgs2(sorgCodes);
        c.getSalesOrgs2();
        c.getSorgOpts0();
        c.getSorgOpts1();
        c.getSorgOpts2();
        c.addAllSalesOrgs2();
        c.addSalesOrgs2();
        c.removeAllSalesOrgs2();
        c.removeSalesOrgs2();
        c.backToPage1();
        c.extendPriceBookToSalesOrgs();
        c.extendPriceBookToSalesOrgs(priceBook1.Id, sorgCode1, sorgCodes);
    }

    static testMethod void myUnitTest09() {
        Test.startTest();
        createTestData();
        test09();
        Test.stopTest();
    }

    static testMethod void myUnitTest10() {
        Test.startTest();
        createTestData();
        test10();
        Test.stopTest();
    }

    static testMethod void myUnitTest12() {
        Test.startTest();
        createTestData();
        PriceBookListController c = new PriceBookListController(null);
        c.priceBooks = priceBooks;
        c.init();
        c.changeOwner();
        PriceBookListController.sendOwnerChangeEmail(priceBooks, UserInfo.getUserId());
        Test.stopTest();
    }
//*/

    static void createTestData() {
        createPBLookups();
        Date tdate = System.today();
        Date edate1 = tdate.addDays(-30);
        Date edate2 = tdate.addDays(-20);
        String desc1 = 'PriceBookFunctions_Test_1';
        String desc2 = 'PriceBookFunctions_Test_2';
        String recstatus1 = 'Active';
        String recstatus2 = 'Approved but not Active yet';
        priceBook1 = createPriceBook(desc1, recstatus1, edate1, true);
        priceBook2 = createPriceBook(desc2, recstatus2, edate2, false);
        priceBooks = new List<Price_Book__c>{priceBook1, priceBook2};
        createPriceBookEntry(priceBook1);
        createPriceBookService(priceBook1);
        parentAccount = getAccount('parentAccName', null);
        acc = getAccount('accName', parentAccount.Id);
        createCISRelationship(acc, CISRelationships_Functions.SHIPTO, acc);
    }

    static void createPBLookups() {
        region = createRegion('R1', 'region');
        region2 = createRegion('R2', 'region2');

        salesOrg = createSalesOrg(sorgCode1, 'salesOrg');
        salesOrg2 = createSalesOrg(sorgCode2, 'salesOrg2');

        distChan = createDistChan('00', 'distChan');
        distChan2 = createDistChan('02', 'distChan2');

        division = createDivision('00', 'division');
        division2 = createDivision('02', 'division2');

        customerGroup = createCustGroup('00', 'customerGroup');
        customerGroup2 = createCustGroup('02', 'customerGroup2');

        pherky = createProdHerky2();
        material = createMaterial(sorgCode1);
        material2 = createMaterial(sorgCode2);
    }

    static Material_Sales_Data2__c createMaterial(String sorgCode) {
        Material_Sales_Data2__c m = new Material_Sales_Data2__c();
        m.Material_Number__c = '010000000123456789';
        m.Sales_Org_Code__c = sorgCode;
        m.Dist_Channel_Code__c = '00';
        m.Record_Key__c = '010000000123456789'+sorgCode+'00';
        m.Product_Hierarchy__c = pherky.Id;
        insert m;
        return m;
    }

    static SAP_Sales_Org__c createSalesOrg(String c, String d) {
        SAP_Sales_Org__c s = new SAP_Sales_Org__c();
        s.Language_Code__c = langCode;
        s.Sales_Org_Code__c = c;
        s.Sales_Org_Description__c = d;
        insert s;
        return s;
    }

    static SAP_Distribution_Channel__c createDistChan(String c, String d) {
        SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = c;
        dc.Language_Code__c = langCode;
        dc.Distribution_Channel_Description__c = d;
        insert dc;
        return dc;
    }

    static SAP_Sales_Division__c createDivision(String c, String d) {
        SAP_Sales_Division__c dv = new SAP_Sales_Division__c();
        dv.Language_Code__c = langCode;
        dv.Sales_Division_Code__c = c;
        dv.Sales_Division_Description__c = d;
        insert dv;
        return dv;
    }

    static SAP_Country_Name__c createRegion(String c, String d) {
        SAP_Country_Name__c r = new SAP_Country_Name__c();
        r.Language_Code__c = langCode;
        r.Country_Code__c = c;
        r.Country_Name__c = d;
        insert r;
        return r;
    }

    static SAP_Customer_Group__c createCustGroup(String c, String d) {
        SAP_Customer_Group__c cg = new SAP_Customer_Group__c();
        cg.Language_Code__c = langCode;
        cg.Customer_Group_Code__c = c;
        cg.Customer_Group_Name__c = d;
        insert cg;
        return cg;
    }

    static Price_Book__c createPriceBook(String pbdesc,
                                         String recstatus,
                                         Date edate,
                                         Boolean isActive) {
        Price_Book__c priceBook = new Price_Book__c();
        priceBook.Active__c = isActive;
        priceBook.Description__c = pbdesc;
        priceBook.Dist_Channel__c = distChan.Id;
        priceBook.Division__c = division.Id;
        priceBook.Effective_Date__c = edate;
        //priceBook.Product_Segment_Code__c = prodLineCode;
        priceBook.Record_Status__c = recstatus;
        insert priceBook;

        pbRegion = new Price_Book_Region__c();
        pbRegion.Price_Book__c = priceBook.Id;
        pbRegion.SAP_Region__c = region.Id;
        insert pbRegion;
        pbRegion = new Price_Book_Region__c();
        pbRegion.Price_Book__c = priceBook.Id;
        pbRegion.SAP_Region__c = region.Id;
        insert pbRegion;

        pbFamily = new Price_Book_Family__c();
        pbFamily.Price_Book__c = priceBook.Id;
        pbFamily.Family_Code__c = familyCode;
        insert pbFamily;
        pbFamily = new Price_Book_Family__c();
        pbFamily.Price_Book__c = priceBook.Id;
        pbFamily.Family_Code__c = familyCode;
        insert pbFamily;

        pbProdLine = new Price_Book_Product_Line__c();
        pbProdLine.Price_Book__c = priceBook.Id;
        pbProdLine.Product_Line_Code__c = prodLineCode;
        pbProdLine.Product_Line_Desc__c = prodLineDesc;
        insert pbProdLine;
        pbProdLine = new Price_Book_Product_Line__c();
        pbProdLine.Price_Book__c = priceBook.Id;
        pbProdLine.Product_Line_Code__c = prodLineCode;
        pbProdLine.Product_Line_Desc__c = prodLineDesc;
        insert pbProdLine;

        pbSalesOrg = new Price_Book_Sales_Org__c();
        pbSalesOrg.Price_Book__c = priceBook.Id;
        pbSalesOrg.SAP_Sales_Org__c = salesOrg.Id;
        insert pbSalesOrg;
        pbSalesOrg = new Price_Book_Sales_Org__c();
        pbSalesOrg.Price_Book__c = priceBook.Id;
        pbSalesOrg.SAP_Sales_Org__c = salesOrg.Id;
        insert pbSalesOrg;

        pbCustGrp = new Price_Book_Customer_Group__c();
        pbCustGrp.Price_Book__c = priceBook.Id;
        pbCustGrp.SAP_Customer_Group__c = customerGroup.Id;
        insert pbCustGrp;
        pbCustGrp = new Price_Book_Customer_Group__c();
        pbCustGrp.Price_Book__c = priceBook.Id;
        pbCustGrp.SAP_Customer_Group__c = customerGroup.Id;
        insert pbCustGrp;

        return priceBook;
    }

    static void createPriceBookEntry(Price_Book__c priceBook) {
        priceBookEntry = new Price_Book_Entry__c();
        priceBookEntry.Bulk_Minimum_Order_Quantity__c = 1000.0;
        priceBookEntry.Material_Sales_Data2__c = material.Id;
        priceBookEntry.Price_Book__c = priceBook.Id;
        priceBookEntry.GPPct__c = 20.0;
        insert priceBookEntry;

        pbesp = new Price_Book_Entry_Scaled_Pricing__c();
        pbesp.Floor_Price__c = 10.0;
        pbesp.Maximum_Volume__c = 1000.0;
        pbesp.Minimum_Volume__c = 100.0;
        pbesp.Price_Book_Entry__c = priceBookEntry.Id;
        pbesp.Pricing_UOM__c = 'KG';
        pbesp.Selling_Price__c = 20.0;
        pbesp.Surcharge__c = 10.0;
        pbesp.Volume_UOM__c = 'LB';
        insert pbesp;
    }

    static void createPriceBookService(Price_Book__c priceBook) {
        priceBookService = new Price_Book_Service__c();
        priceBookService.Service_Cost__c = 1000.0;
        priceBookService.Service_Type__c = 'service Type';
        priceBookService.Service_UOM__c = 'per Hour';
        priceBookService.Price_Book__c = priceBook.Id;
        insert priceBookService;
    }

    static Account getAccount(String accountName,
                              Id parentId) {
        Account a = new Account();
        a.Name = accountName;
        a.SAP_Sales_Org__c = salesOrg.Sales_Org_Code__c;
        a.SAP_DistChannel__c = distChan.Distribution_Channel_Code__c;
        a.SAP_DivisionCode__c = division.Sales_Division_Code__c;
        a.SAP_Country__c = region.Country_Code__c;
        a.SAP_Customer_Group__c = customerGroup.Customer_Group_Code__c;
        if (parentId != null) {
            a.ParentId = parentId;
        }
        insert a;
        return a;
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

    private static Product_Hierarchy2__c createProdHerky2() {
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = 'E';
        ph1.Product_Hierarchy_Code__c = '!';
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = 'E';
        ph2.Product_Hierarchy_Code__c = '!@#';
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = 'E';
        ph3.Product_Hierarchy_Code__c = '!@#000';
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = 'E';
        ph4.Product_Hierarchy_Code__c = '!@#000000';
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = 'E';
        ph5.Product_Hierarchy_Code__c = '!@#000000000';
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = 'E';
        ph6.Product_Hierarchy_Code__c = '!@#000000000000';
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = 'E';
        ph7.Product_Hierarchy_Code__c = '!@#000000000000000';
        insert ph7;

        Product_Hierarchy2__c pherky2 = new Product_Hierarchy2__c();
        pherky2.Product_Hierarchy__c = ph7.Product_Hierarchy_Code__c;
        pherky2.Product_Hierarchy1__r = ph1;
        pherky2.Product_Hierarchy2__r = ph2;
        pherky2.Product_Hierarchy3__r = ph3;
        pherky2.Product_Hierarchy4__r = ph4;
        pherky2.Product_Hierarchy5__r = ph5;
        pherky2.Product_Hierarchy6__r = ph6;
        pherky2.Product_Hierarchy7__r = ph7;
        insert pherky2;
        return pherky2;
    }

    static void test01() {
        Set<Id> pbids = new Set<Id>{priceBook1.Id};

        List<Price_Book__c> pblist = [select Id,
                                            (select Id, Floor_Price__c, Market_Price__c,
                                                    Material_Name__c
                                               from PriceBookEntryPriceBooks__r),
                                            (select Sales_Org_Code__c, Sales_Org_Desc__c
                                               from Price_Book_Sales_Orgs__r),
                                            (select Family_Code__c, Family_Desc__c
                                               from Price_Book_Families__r),
                                            (select Region_Code__c, Region_Desc__c
                                               from Price_Book_Regions__r),
                                            (select Customer_Group_Code__c, Customer_Group_Desc__c
                                               from Price_Book_Customer_Groups__r)
                                        from price_book__c
                                       where id in :pbids
                                    ];
        for (Price_Book__c pb : pblist) {
            List<Price_Book_Entry__c> pbes = pb.PriceBookEntryPriceBooks__r;
            System.debug(pbes);
            List<Price_Book_Sales_Org__c> pbsos = pb.Price_Book_Sales_Orgs__r;
            System.debug(pbsos);
            List<Price_Book_Family__c> pbfs = pb.Price_Book_Families__r;
            System.debug(pbfs);
            List<Price_Book_Region__c> pbrs = pb.Price_Book_Regions__r;
            System.debug(pbrs);
            List<Price_Book_Customer_Group__c> pbcgs = pb.Price_Book_Customer_Groups__r;
            System.debug(pbcgs);
        }
    }

    static void test02() {
        PriceBookFunctions.getPriceBookTabUrl();
        //PriceBookFunctions.getPriceBooksForCustomer(parentAccount.Id, true);
        String pbid = priceBook1.Id;
        Set<String> pbids = new Set<String>{pbid};
        test03(null);
        test03(pbid);
        test04(null);
        test04(pbid);
    }

    static void test03(String pbid) {
        PriceBookCustGroupFunctions.getCustomerGroupString(pbid);
        PriceBookFamilyFunctions.getFamilyString(pbid);
        PriceBookRegionFunctions.getRegionString(pbid);
        PriceBookSalesOrgFunctions.getSalesOrgString(pbid);

        List<Price_Book__c> pbs = PriceBookFunctions.getPriceBooks(pbid);
        //PriceBookFunctions.getProductSegmentMap(pbs);
        PriceBookEntryFunctions.getPriceBookEntries(pbid);
        PriceBookServiceFunctions.getPriceBookServices(pbid);
    }

    static void test04(String pbid) {
        Set<String> pbids = new Set<String>{pbid};
        PriceBookCustGroupFunctions.getPriceBookCustomerGroupIdMap(pbids);
        PriceBookCustGroupFunctions.getPriceBookCustomerGroupCodeMap(pbids);
        PriceBookFamilyFunctions.getPriceBookFamilyCodeMap(pbids);
        PriceBookRegionFunctions.getPriceBookRegionIdMap(pbids);
        PriceBookRegionFunctions.getPriceBookRegionCodeMap(pbids);
        PriceBookSalesOrgFunctions.getPriceBookSalesOrgIdMap(pbids);
        PriceBookSalesOrgFunctions.getPriceBookSalesOrgCodeMap(pbids);
    }

    static void test05() {
        Set<Id> pbIds = new Set<Id>{priceBook1.Id};
        List<Id> salesOrgIdList = new List<Id>{salesOrg.Id, salesOrg2.Id};
        PriceBookSalesOrgFunctions.getPriceBookIdsForSalesOrgs(pbIds, salesOrgIdList);
        Set<String> salesOrgIds = new Set<String>{salesOrg.Id, salesOrg2.Id};
        Set<String> salesOrgIds2 = new Set<String>{salesOrg2.Id};
        Set<String> familyCodes = new Set<String>{familyCode};
        Set<String> familyCodes2 = new Set<String>{familyCode2};
        Set<String> prodLineCodes = new Set<String>{prodLineCode};
        Set<String> prodLineCodes2 = new Set<String>{prodLineCode2};
        Set<String> regionIds = new Set<String>{region.Id};
        Set<String> regionIds2 = new Set<String>{region2.Id};
        Set<String> custGroupIds = new Set<String>{customerGroup.Id};
        Set<String> custGroupIds2 = new Set<String>{customerGroup2.Id};
        String vcpGrade;
        test06(salesOrgIds, distChan.Id, division.Id, prodLineCodes, familyCodes, regionIds, custGroupIds,'A');
        test06(salesOrgIds2, distChan.Id, division.Id, prodLineCodes, familyCodes, regionIds, custGroupIds,'B');
        test06(salesOrgIds, distChan2.Id, division.Id, prodLineCodes, familyCodes, regionIds, custGroupIds,'C');
        test06(salesOrgIds, distChan.Id, division2.Id, prodLineCodes, familyCodes, regionIds, custGroupIds,'D');
        test06(salesOrgIds, distChan.Id, division.Id, prodLineCodes2, familyCodes, regionIds, custGroupIds,'E');
        test06(salesOrgIds, distChan.Id, division.Id, prodLineCodes, familyCodes2, regionIds, custGroupIds,'');
        test06(salesOrgIds, distChan.Id, division.Id, prodLineCodes, familyCodes, regionIds2, custGroupIds,'');
        test06(salesOrgIds, distChan.Id, division.Id, prodLineCodes, familyCodes, regionIds, custGroupIds2,'');
    }

    static void test06(Set<String> salesOrgIds,
                       Id distChanId,
                       Id divisionId,
                       Set<String> prodLineCodes,
                       Set<String> familyCodes,
                       Set<String> regionIds,
                       Set<String> custGroupIds,
                       String vcpGrade) {
        List<Price_Book__c> pbs;
        pbs = PriceBookFunctions.getPriceBooks(salesOrgIds,
                                               distChanId,
                                               divisionId,
                                               prodLineCodes,
                                               familyCodes,
                                               regionIds,
                                               custGroupIds,vcpGrade);
        System.debug(pbs);
    }

    static void test07() {
        String salesOrgIdStrings, familyCodeStrings, prodLineCodeStrings, regionIdStrings, custGroupIdStrings,vcpGrade;
        salesOrgIdStrings = salesOrg.Id;
        familyCodeStrings = familyCode;
        prodLineCodeStrings = prodLineCode;
        regionIdStrings = region.Id;
        custGroupIdStrings = customerGroup.Id;
         vcpGrade='A';
        test08(salesOrgIdStrings, distChan.Id, division.Id, prodLineCodeStrings, familyCodeStrings, regionIdStrings, custGroupIdStrings,vcpGrade);
        salesOrgIdStrings = salesOrg.Id + ':' + salesOrg2.Id;
        familyCodeStrings = familyCode + ':' + familyCode2;
        prodLineCodeStrings = prodLineCode + ':' + prodLineCode2;
        regionIdStrings = region.Id + ':' + region2.Id;
       
        custGroupIdStrings = customerGroup.Id + ':' + customerGroup2.Id;
        test08(salesOrgIdStrings, distChan.Id, division.Id, prodLineCodeStrings, familyCodeStrings, regionIdStrings, custGroupIdStrings,vcpGrade);
    }

    static void test08(String salesOrgIds,
                       String distChanId,
                       String divisionId,
                       String prodLineCodes,
                       String familyCodes,
                       String regionIds,
                       String custGroupIds,
                       String vcpGrade
                       ) {
        List<Price_Book__c> pbs;
        pbs = PriceBookFunctions.getPriceBooks(salesOrgIds,
                                               distChanId,
                                               divisionId,
                                               prodLineCodes,
                                               familyCodes,
                                               regionIds,
                                               custGroupIds,vcpGrade);
        System.debug(pbs);
        pbs = PriceBookFunctions.getPriceBooks(salesOrgIds,
                                               distChanId,
                                               divisionId,
                                               prodLineCodes,
                                               familyCodes,
                                               regionIds,
                                               custGroupIds,vcpGrade,
                                               true);
        System.debug(pbs);
    }

    static void test09() {
        List<Price_Book__c> pbs;
        Set<String> pbIds;
        Integer intVal;
        pbIds = new Set<String>{priceBook2.Id};

        pbs = PriceBookFunctions.getActivePriceBooks();
        System.debug(pbs);
        pbs = PriceBookFunctions.getApprovedPriceBooks();
        System.debug(pbs);
        pbs = PriceBookFunctions.getPriceBooks(pbIds);
        System.debug(pbs);

        pbs = PriceBookFunctions.getApprovedPriceBooks(pbIds);
        System.debug(pbs);
        PriceBookFunctions.activatePriceBooks(pbs);
        
        intVal = PriceBookFunctions.getRelatedRecordsCount(pbIds);
        System.debug(intVal);
    }

    static void test10() {
        Set<String> salesOrgCodes = new Set<String>{salesOrg.Sales_Org_Code__c, salesOrg2.Sales_Org_Code__c};
        Set<String> distChanCodes = new Set<String>{distChan.Distribution_Channel_Code__c, distChan2.Distribution_Channel_Code__c};
        Set<String> divisionCodes = new Set<String>{division.Sales_Division_Code__c, division2.Sales_Division_Code__c};
        Set<String> prodLineCodes = new Set<String>{prodLineCode, prodLineCode2};
        Set<String> familyCodes = new Set<String>{familyCode};
        Set<String> regionCodes = new Set<String>{region.Country_Code__c};
        Set<String> custGroupCodes = new Set<String>{customerGroup.Customer_Group_Code__c};
        test11(salesOrgCodes, distChanCodes, divisionCodes, prodLineCodes, familyCodes, regionCodes, custGroupCodes);
    }

    static void test11(Set<String> salesOrgCodes,
                       Set<String> distChanCodes,
                       Set<String> divisionCodes,
                       Set<String> prodLineCodes,
                       Set<String> familyCodes,
                       Set<String> regionCodes,
                       Set<String> custGroupCodes) {
        List<Price_Book__c> pbs;
        pbs = PriceBookFunctions.getActivePriceBooks(salesOrgCodes,
                                                     distChanCodes,
                                                     divisionCodes,
                                                     prodLineCodes,
                                                     familyCodes,
                                                     regionCodes,
                                                     custGroupCodes);
        System.debug(pbs);
    }

}