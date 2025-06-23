@isTest
private class PricingConditionUpdateFunctions_Test {

    static final Integer MAX_PC_RECS = 1;
    static final String dchanCode = PricingConditionFunctions_Test.distChan;
    static final String sorgCode = PricingConditionFunctions_Test.salesOrg;
    //static final String dchanCode = '50';
    //static final String sorgCode = '1021';
    static final Set<String> RECSET = PricingConditionUpdateFunctions.RECSET;
    static final Date effectFromDate = Date.today();
    static final Date effectToDate = Date.today().addDays(120);
    static final Double priceIncreaseAmount = 0.05;
    static final Integer priceIncreasePercent = 10;
    static final Boolean submitForApproval = false;
    static final String QRY = 'select Id' +
        '     , Account__r.Id' +
        '     , Account__r.SAP_Sales_District_Desc__c' +
        '     , Account__r.SAP_Sales_Group_Desc__c' +
        '     , Account__r.SAP_Sales_Office_Desc__c' +
        '     , Material2__r.Id' +
        '     , Material2__r.Material_Base_Code_Desc__c' +
        '     , Material2__r.Sales_Org_Code__c' +
        '     , Product_Hierarchy__r.Product_Hierarchy5__r.Product_Hierarchy_Description__c' +
        '     , Product_Hierarchy__r.Product_Hierarchy6__r.Product_Hierarchy_Description__c' +
        '     , Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c' +
        '  from Pricing_Condition__c' +
        ' where DistChan_Code__c = :dchanCode' +
        '   and Record_Status__c in :RECSET' +
        '   and Valid_To_Date__c >= :effectFromDate' +
        ' limit 10';
    static Set<String> sorgCodes;
    static Set<String> salesDsts;
    static Set<String> salesOfcs;
    static Set<String> salesGrps;
    static Set<String> accountIds;
    static Set<String> ph5Descs;
    static Set<String> ph6Descs;
    static Set<String> ph7Descs;
    static Set<String> baseCodes;
    static Set<String> materialIds;
    static Database.Querylocator ql;
    static List<Pricing_Condition__c> pcs;
    static List<Pricing_Condition> pclist;

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>>>>>>>>> ' + s);
    }

    static void createTestData() {
        pclist = PricingConditionFunctions_Test.getPclist();
        sorgCodes   = new Set<String>();
        salesDsts   = new Set<String>();
        salesOfcs   = new Set<String>();
        salesGrps   = new Set<String>();
        accountIds  = new Set<String>();
        ph5Descs    = new Set<String>();
        ph6Descs    = new Set<String>();
        ph7Descs    = new Set<String>();
        baseCodes   = new Set<String>();
        materialIds = new Set<String>();
        pcs = new List<Pricing_Condition__c>();
        for (Pricing_Condition__c pc : Database.query(QRY)) {
            sorgCodes.add(pc.Material2__r.Sales_Org_Code__c);
            salesDsts.add(pc.Account__r.SAP_Sales_District_Desc__c);
            salesOfcs.add(pc.Account__r.SAP_Sales_Office_Desc__c);
            salesGrps.add(pc.Account__r.SAP_Sales_Group_Desc__c);
            accountIds.add(pc.Account__c);
            ph5Descs.add(pc.Product_Hierarchy__r.Product_Hierarchy5__r.Product_Hierarchy_Description__c);
            ph6Descs.add(pc.Product_Hierarchy__r.Product_Hierarchy6__r.Product_Hierarchy_Description__c);
            ph7Descs.add(pc.Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c);
            baseCodes.add(pc.Material2__r.Material_Base_Code_Desc__c);
            materialIds.add(pc.Material2__c);
        }
        debug('sorgCodes = ' + sorgCodes); debug('salesDsts = ' + salesDsts);
        debug('salesOfcs = ' + salesOfcs); debug('salesGrps = ' + salesGrps);
        debug('ph5Descs = ' + ph5Descs); debug('ph6Descs = ' + ph6Descs); debug('ph7Descs = ' + ph7Descs);
        debug('accountIds = ' + accountIds); debug('baseCodes = ' + baseCodes); debug('materialIds = ' + materialIds);
        ql = PricingConditionUpdateFunctions.getQueryLocator(dchanCode, effectFromDate, effectToDate, sorgCodes,
             salesDsts, salesOfcs, salesGrps, accountIds, ph5Descs, ph6Descs, ph7Descs, baseCodes, materialIds);
        pcs = Database.query(ql.getQuery());
        debug('pcs = ' + pcs);
        String userId = UserInfo.getUserId(), searchName = 'test';
        PricingConditionUpdateFunctions.getSearchCriteria(userId, searchName);
        PricingConditionUpdateFunctions.saveSearchCriteria(userId, searchName, dchanCode, sorgCodes,
             salesDsts, salesOfcs, salesGrps, accountIds, ph5Descs, ph6Descs, ph7Descs, baseCodes, materialIds);
    }

    static testMethod void test01() {
        PricingConditionUpdateController c = new PricingConditionUpdateController(null);
        createTestData();
        Test.startTest();
        c.init(); c.dchanCode = dchanCode; c.pc.Valid_From_Date__c = effectFromDate;
        c.pc.Valid_To_Date__c = effectToDate;
        c.strPriceIncreasePercnt = '0.0'; c.strPriceIncreaseAmount = '0.0';
        c.submitForApproval = submitForApproval;
        c.getSavedSearchFlds(); c.searchName = 'test';

        c.getSapSalesOrgs(); c.salesOrgCodes.addAll(sorgCodes);
        c.getSorgOpts1(); c.getSorgOpts2();
        c.setSalesOrgs1(c.salesOrgCodes); c.getSalesOrgs1(); c.addSalesOrgs2();
        c.addAllSalesOrgs2(); c.getSelectedSalesOrgCodes();
        c.setSalesOrgs2(c.salesOrgCodes); c.getSalesOrgs2();
        c.removeSalesOrgs2(); c.removeAllSalesOrgs2();
        c.selectedSalesOrgCodes = sorgCodes;

        c.getSalesDistricts(); c.salesDistricts.addAll(salesDsts);
        c.getSdstOpts1(); c.getSdstOpts2();
        c.setSalesDsts1(c.salesDistricts); c.getSalesDsts1(); c.addSalesDsts2();
        c.addAllSalesDsts2(); c.getSelectedSalesDistricts();
        c.setSalesDsts2(c.salesDistricts); c.getSalesDsts2();
        c.removeSalesDsts2(); c.removeAllSalesDsts2(); c.addAllSalesDsts2();

        c.getSalesOffices(); c.salesOffices.addAll(salesOfcs);
        c.getSofcOpts1(); c.getSofcOpts2();
        c.setSalesOfcs1(c.salesOffices); c.getSalesOfcs1(); c.addSalesOfcs2();
        c.addAllSalesOfcs2(); c.getSelectedSalesOffices();
        c.setSalesOfcs2(c.salesOffices); c.getSalesOfcs2();
        c.removeSalesOfcs2(); c.removeAllSalesOfcs2(); c.addAllSalesOfcs2();

        c.getSalesGroups(); c.salesGroups.addAll(salesGrps);
        c.getSgrpOpts1(); c.getSgrpOpts2();
        c.setSalesGrps1(c.salesGroups); c.getSalesGrps1(); c.addSalesGrps2();
        c.addAllSalesGrps2(); c.getSelectedSalesGroups();
        c.setSalesGrps2(c.salesGroups); c.getSalesGrps2();
        c.removeSalesGrps2(); c.removeAllSalesGrps2(); c.addAllSalesGrps2();

        c.getAccounts(); c.accountIds.addAll(accountIds);
        c.getAccOpts1(); c.getAccOpts2();
        c.setAccountIds1(c.accountIds); c.getAccountIds1(); c.addAccountIds2();
        c.addAllAccountIds2(); c.getSelectedAccountIds();
        c.setAccountIds2(c.accountIds); c.getAccountIds2();
        c.removeAccountIds2(); c.removeAllAccountIds2(); c.addAllAccountIds2();

        c.getProductFamilies(); c.ph5list.addAll(ph5Descs);
        c.getPh5Opts1(); c.getPh5Opts2();
        c.setPh5s1(c.ph5list); c.getPh5s1(); c.addPh5s2();
        c.addAllPh5s2(); c.getSelectedPh5s();
        c.setPh5s2(c.ph5list); c.getPh5s2();
        c.removePh5s2(); c.removeAllPh5s2(); c.addAllPh5s2();

        c.getProductSegments(); c.ph6list.addAll(ph6Descs);
        c.getPh6Opts1(); c.getPh6Opts2();
        c.setPh6s1(c.ph6list); c.getPh6s1(); c.addPh6s2();
        c.addAllPh6s2(); c.getSelectedPh6s();
        c.setPh6s2(c.ph6list); c.getPh6s2();
        c.removePh6s2(); c.removeAllPh6s2(); c.addAllPh6s2();

        c.getProductSubSegments(); c.ph7list.addAll(ph7Descs);
        c.getPh7Opts1(); c.getPh7Opts2();
        c.setPh7s1(c.ph7list); c.getPh7s1(); c.addPh7s2();
        c.addAllPh7s2(); c.getSelectedPh7s();
        c.setPh7s2(c.ph7list); c.getPh7s2();
        c.removePh7s2(); c.removeAllPh7s2(); c.addAllPh7s2();

        c.getBaseCodes(); c.baseCodes.addAll(baseCodes);
        c.getBcdOpts1(); c.getBcdOpts2();
        c.setBaseCodes1(c.baseCodes); c.getBaseCodes1(); c.addBaseCodes2();
        c.addAllBaseCodes2(); c.getSelectedBaseCodes();
        c.setBaseCodes2(c.baseCodes); c.getBaseCodes2();
        c.removeBaseCodes2(); c.removeAllBaseCodes2(); c.addAllBaseCodes2();

        c.getMaterials(); c.materialIds.addAll(materialIds);
        c.getMatOpts1(); c.getMatOpts2();
        c.setMaterialIds1(c.materialIds); c.getMaterialIds1();
        c.addMaterialIds2(); c.addAllMaterialIds2(); c.getSelectedMaterialIds();
        c.setMaterialIds2(c.materialIds); c.getMaterialIds2();
        c.removeMaterialIds2(); c.removeAllMaterialIds2();
        c.addAllMaterialIds2(); c.saveSearchCriteria();

        c.getPricingConditions2(); c.getPriceIncreasePercnts();

        c.strPriceIncreasePercnt = '10.0';
        Test.stopTest();
    }

}