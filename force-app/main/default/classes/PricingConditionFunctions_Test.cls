@isTest
public class PricingConditionFunctions_Test {

    public static final String ACC_TYPE_SHIPTO = Account_Partner_Functions.ACC_TYPE_SHIPTO;
    public static final String ACC_TYPE_SOLDTO = Account_Partner_Functions.ACC_TYPE_SOLDTO;
    public static final String ACC_TYPE_CHERKY = Account_Partner_Functions.ACC_TYPE_CHERKY;

    public static final String salesOrg = '1021';
    public static final String distChan = '50';
    public static final String divsnCode = '50';
    public static final String ph1Code = 'F', phc = '123';
    public static final String ph2Code = ph1Code + '12';
    public static final String ph3Code = ph2Code + phc;
    public static final String ph4Code = ph3Code + phc;
    public static final String ph5Code = ph4Code + phc;
    public static final String ph6Code = ph5Code + phc;
    public static final String ph7Code = ph6Code + phc;
    public static final String salesArea = salesOrg+distChan+divsnCode;
    public static final String sofcDesc = 'SalesOffice';
    public static final String sgrpDesc = 'SalesGroup';
    public static final String baseCodeDesc = 'BaseCode';
    public static List<Pricing_Condition__c> pcs;

    static final String SELECT_QRY_1 = PricingConditionFunctions.SELECT_QRY_1;
    static final String SUBMITTED = PricingConditionFunctions.SUBMITTED;
    static Account shipTo, soldTo, cHerky, invalidAcc;
    static Customer_Product_Info__c cpi1, cpi2, cpi3;
    static Set<String> accountIds, pcids;
    static Material_General_Data2__c mgd2;
    static Material_Sales_Data2__c msd2;
    static Pricing_Condition__c pc1, pc2, pc3, pc4, pc5, pc6;
    static Pricing_Condition_Scaled_Pricing__c pcsp1, pcsp2, pcsp3;
    static Product_Hierarchy__c ph1, ph2, ph3, ph4, ph5, ph6, ph7;
    static SAP_Distribution_Channel__c sapDistChan;
    static SAP_Plant__c sapPlant;
    static SAP_Sales_Org__c sapSalesOrg;
    static List<Pricing_Condition_Scaled_Pricing__c> pcsps;
    static List<Pricing_to_Competitor__c> p2cs;
    static List<Pricing_Condition> pclist;
    static String matnum = '010000000123456789';
    static String plantCode = '1234';
    static String langCode = 'E';

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'PricingConditionFunctions_Test : >>>>>>> ' + s);
    }

    public static void createTestData() {
        createAccounts(); createMaterial(); createCPIs(); createDPAs();
        createRebates(); createPricingConditions();
    }

    public static List<Pricing_Condition> getPclist() {
        createTestData(); return pclist;
    }

    public static SAP_Plant__c getPlant() {
        sapPlant = new SAP_Plant__c();
        sapPlant.Plant_Code__c = plantCode;
        insert sapPlant; return sapPlant;
    }

    public static Pricing_Condition__c getPc1() {
        createTestData(); return pc1;
    }

    public static Pricing_Condition__c getPc1(Account a, Material_Sales_Data2__c m, SAP_Plant__c p) {
        return getPc1(a, m, p, null);
    }

    public static Pricing_Condition__c getPc1(Account a, Material_Sales_Data2__c m, SAP_Plant__c p, Id mpbeId) {
        sapPlant = p; pc1 = getPc(ACC_TYPE_SHIPTO, a, m); pc1.Market_Price_Book_Entry__c = mpbeId;
        insert pc1; return pc1;
    }

    public static Pricing_Condition_Scaled_Pricing__c getPcsp1(Pricing_Condition__c pc) {
        pcsp1 = getPcsp(pc); insert pcsp1; return pcsp1;
    }

    static void createAccounts() {
        getPlant();

        sapSalesOrg = new SAP_Sales_Org__c();
        sapSalesOrg.Sales_Org_Code__c = salesOrg;
        sapSalesOrg.Language_Code__c = langCode;
        insert sapSalesOrg;

        sapDistChan = new SAP_Distribution_Channel__c();
        sapDistChan.Distribution_Channel_Code__c = distChan;
        sapDistChan.Language_Code__c = langCode;
        insert sapDistChan;

        cHerky = new Account(Name = 'CHerky', AccountNumber = 'CHerky');
        createAccount(cHerky);

        soldTo = new Account(Name = 'SoldTo', AccountNumber = 'SoldTo');
        soldTo.ParentId = cHerky.Id; createAccount(soldTo);

        shipTo = new Account(Name = 'ShipTo', AccountNumber = 'ShipTo');
        createAccount(shipTo);

        invalidAcc = new Account(Name = 'invalidAcc', AccountNumber = 'invalidAcc');
        createAccount(invalidAcc);

        accountIds = new Set<String>{cHerky.Id, soldTo.Id, shipTo.Id};

        createEcomCust();

    }

    static void createAccount(Account a) {
        a.Account_Number__c = a.AccountNumber + salesArea;
        a.SAP_Customer_Number__c = a.AccountNumber;
        a.SAP_DistChannel__c = distChan;
        a.SAP_DivisionCode__c = divsnCode;
        a.SAP_Sales_Org__c = salesOrg;
        a.SAP_Sales_Office_Desc__c = sofcDesc;
        a.SAP_Sales_Group_Desc__c = sgrpDesc;
        insert a; a.AccountNumber = a.AccountNumber; update a;
    }

    static void createEcomCust() {
        SAP_ECOM_Customer__c a = new SAP_ECOM_Customer__c();
        a.Ship_To__c          = shipto.Id; a.Ship_Account__c    = shipto.AccountNumber;
        a.Sold_To__c          = soldto.Id; a.Sold_Account__c    = soldto.AccountNumber;
        a.Hier__c             = cherky.Id; a.Hier_Account__c    = cherky.AccountNumber;
        a.Key__c = '' + '-' +
                   cherky.AccountNumber + '-' +
                   soldto.AccountNumber + '-' +
                   shipto.AccountNumber;
        insert a;
    }

    static void createMaterial() {
        mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        msd2 = getTestMsd2();
    }

    static void createPricingConditions() {
        pc1 = getPc(ACC_TYPE_SHIPTO, shipTo, msd2);
        pc4 = getPc(ACC_TYPE_SHIPTO, shipTo, msd2);
        pc2 = getPc(ACC_TYPE_SOLDTO, soldTo, msd2);
        pc5 = getPc(ACC_TYPE_SOLDTO, soldTo, msd2);
        pc3 = getPc(ACC_TYPE_CHERKY, cHerky, msd2);
        pc6 = getPc(ACC_TYPE_CHERKY, cHerky, msd2);
        pcs = new List<Pricing_Condition__c>{pc1, pc2, pc3, pc4, pc5, pc6};
        insert pcs;
        pcids = new Set<String>{pc1.Id, pc2.Id,  pc3.Id, pc4.Id, pc5.Id, pc6.Id};

        Map<String, String> incoTermsMap = SAP_Queries_Functions.getSapIncoTermMap();
        Map<String, SAP_Plant__c> plantsMap = SAP_Queries_Functions.getSapPlantMap();
        pclist = new List<Pricing_Condition>();
        Pricing_Condition p1 = new Pricing_Condition(pc1); p1.selected = true; pclist.add(p1);
        Pricing_Condition p2 = new Pricing_Condition(pc2); p2.selected = true; pclist.add(p2);
        Pricing_Condition p3 = new Pricing_Condition(pc3); p3.selected = true; pclist.add(p3);

        pcsp1 = getPcsp(pc1); pcsp2 = getPcsp(pc2); pcsp3 = getPcsp(pc3);
        pcsps = new List<Pricing_Condition_Scaled_Pricing__c>{pcsp1, pcsp2, pcsp3};
        insert pcsps;

        pc1 = getPc(pc1.Id);
    }

    static Material_Sales_Data2__c getTestMsd2() {

        Material_Plant2__c mp2 = getTestMp2();
        Product_Hierarchy2__c ph = getTestProdHerky2();

        msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
        msd2.SalesOrg_Code__c = sapSalesOrg.Id;
        msd2.DistChannel_Code__c = sapDistChan.Id;
        msd2.Material_General_Data__c = mgd2.Id;
        msd2.Product_Hierarchy__c = ph.Id;
        msd2.Material_Base_Code_Desc__c = baseCodeDesc;
        insert msd2; return msd2;
    }

    static Material_Plant2__c getTestMp2() {
        Material_Plant2__c mp2 = new Material_Plant2__c();
        mp2.Material_Number__c = matnum;
        mp2.Plant_Code__c = plantCode;
        mp2.SalesOrg_Code__c = salesOrg;
        mp2.Record_Key__c = matnum + plantCode + salesOrg;
        mp2.Material_General_Data__c = mgd2.Id;
        mp2.SAP_Plant__c = sapPlant.Id;
        mp2.SAP_Sales_Org__c = sapSalesOrg.Id;
        insert mp2; debug('mp2 : ' + mp2); return mp2;
    }

    static Product_Hierarchy2__c getTestProdHerky2() {
        ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = langCode;
        ph1.Product_Hierarchy_Code__c = ph1Code;
        ph1.Product_Hierarchy_Description__c = 'ph1Desc';
        insert ph1;

        ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = langCode;
        ph2.Product_Hierarchy_Code__c = ph2Code;
        ph2.Product_Hierarchy_Description__c = 'ph2Desc';
        insert ph2;

        ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = langCode;
        ph3.Product_Hierarchy_Code__c = ph3Code;
        ph3.Product_Hierarchy_Description__c = 'ph3Desc';
        insert ph3;

        ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = langCode;
        ph4.Product_Hierarchy_Code__c = ph4Code;
        ph4.Product_Hierarchy_Description__c = 'ph4Desc';
        insert ph4;

        ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = langCode;
        ph5.Product_Hierarchy_Code__c = ph5Code;
        ph5.Product_Hierarchy_Description__c = 'ph5Desc';
        insert ph5;

        ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = langCode;
        ph6.Product_Hierarchy_Code__c = ph6Code;
        ph6.Product_Hierarchy_Description__c = 'ph6Desc';
        insert ph6;

        ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = langCode;
        ph7.Product_Hierarchy_Code__c = ph7Code;
        ph7.Product_Hierarchy_Description__c = 'ph7Desc';
        insert ph7;

        Product_Hierarchy2__c pherky2 = new Product_Hierarchy2__c();
        pherky2.Product_Hierarchy__c = ph7.Product_Hierarchy_Code__c;
        pherky2.Product_Hierarchy1__c = ph1.Id;
        pherky2.Product_Hierarchy2__c = ph2.Id;
        pherky2.Product_Hierarchy3__c = ph3.Id;
        pherky2.Product_Hierarchy4__c = ph4.Id;
        pherky2.Product_Hierarchy5__c = ph5.Id;
        pherky2.Product_Hierarchy6__c = ph6.Id;
        pherky2.Product_Hierarchy7__c = ph7.Id;
        insert pherky2; return pherky2;
    }

    static Pricing_Condition__c getPc(String pcId) {
        String qry = SELECT_QRY_1 + ' where Id = :pcId';
        List<Pricing_Condition__c> alist = Database.query(qry);
        if (alist != null && !alist.isEmpty()) {return alist[0];}
        return null;
    }

    static Pricing_Condition__c getPc(String accType, Account a, Material_Sales_Data2__c m) {
        Pricing_Condition__c pc = new Pricing_Condition__c();
        pc.Account_Level_Condition_Applies_To__c = accType;
        pc.Account__c = a.Id; pc.Material2__c = m.Id; pc.SAP_Plant__c = sapPlant.Id;
        pc.Product_Hierarchy__c = m.Product_Hierarchy__c;
        pc.Valid_From_Date__c = System.today(); pc.Valid_To_Date__c = System.today().addDays(30);
        pc.Record_Status__c = 'Active'; pc.Active__c = true;
        pc.Selling_Price__c = 10.5; pc.Fleet_Cost__c = 0; pc.Program_Cost__c = 0;
        pc.Shipment_Weight__c = 1.0; pc.Selling_UOM__c = 'LB';
        return pc;
    }

    static Pricing_Condition_Scaled_Pricing__c getPcsp(Pricing_Condition__c pc) {
        Pricing_Condition_Scaled_Pricing__c pcsp = new Pricing_Condition_Scaled_Pricing__c();
        pcsp.Maximum_Volume__c = 1000;
        pcsp.Minimum_Volume__c = 10;
        pcsp.Pricing_Condition__c = pc.Id;
        pcsp.Selling_Price__c = 10.1;
        pcsp.Surcharge__c = 1.0;
        pcsp.Scaled_Selling_Price__c = 11.1;
        return pcsp;
    }

    static void createCPIs() {
        cpi1 = createCPI('1', '1');
        cpi1 = createCPI('1', '2');
        cpi2 = createCPI('2', '2');
        cpi3 = createCPI('3', '3');
    }

    static Customer_Product_Info__c createCPI(String recType, String custMat) {
        Customer_Product_Info__c cpi = new Customer_Product_Info__c();
        cpi.CPI_Record_Type__c = recType;
        cpi.Sales_Org_Code__c = salesOrg;
        cpi.Distribution_Channel_Code__c = distChan;
        cpi.Material_Number__c = matnum;
        cpi.ShipTo_Number__c = shipto.AccountNumber;
        cpi.Customer_Number__c = soldto.AccountNumber;
        cpi.Customer_Material_Number__c = custMat;
        cpi.Record_Key__c = recType + salesOrg + distChan +
                            soldto.AccountNumber + shipto.AccountNumber + custMat + matnum;
        cpi.Primary_Indicator__c = 'X';
        insert cpi; return cpi;
    }

    static void createDPAs() {
        String k1 = 'Z2D1', k2 = 'Z2D2'; Delivery_Program_Adder__c dpa;
        dpa = getDPA(k1); insert dpa;
        dpa = getDPA(k2); insert dpa;
    }

    static Delivery_Program_Adder__c getDPA(String adderType) {
        Delivery_Program_Adder__c dpa = new Delivery_Program_Adder__c();
        dpa.Adder_Type__c = adderType; dpa.Amount__c = 1.0;
        dpa.Dist_Channel_Override__c = sapDistChan.Id;
        dpa.PH3__c = phc; dpa.SAP_Plant__c = sapPlant.Id;
        dpa.Sales_Org_Override__c = sapSalesOrg.Id; dpa.SAP_Table_Name__c = 'A123';
        dpa.ValidOn__c = System.today(); dpa.ValidTo__c = System.today().addDays(30);
        return dpa;
    }

    static void createRebates() {
        Pricing_Rebate__c pr = new Pricing_Rebate__c();
        pr.Rebate_Recipient__c = soldTo.Id;
        pr.Sales_Org__c = salesOrg;
        pr.Dist_Channel__c = distChan;
        pr.Condition_Type__c = 'Z020';
        pr.Rebate_Agreement_Type__c = 'Z020';
        pr.Rebate_Start_Date__c = Date.today();
        pr.Rebate_End_Date__c = Date.today().addDays(30);
        pr.Status__c = 'Approved'; insert pr;
        Pricing_Rebate_Detail__c prd = new Pricing_Rebate_Detail__c();
        prd.Account__c = soldTo.Id; prd.Accrual__c = 1;
        prd.Material_Sales_Data2__c = msd2.Id; prd.UoM__c = 'KG';
        prd.Pricing_Rebate__c = pr.Id; insert prd;
    }

    static testMethod void test01() {
        createTestData(); Test.startTest();
        PricingConditionFunctions.getAqualonIndustryManagers();
        PricingConditionFunctions.getPricingConditionsForAccounts(accountIds);
        PricingConditionFunctions.getSelectedIds(pclist);
        PricingConditionFunctions.setSelectedFlags(pclist, pclist);
        PricingConditionFunctions.getSelectedPricingConditions(pclist);
        PricingConditionFunctions.expirePricingConditions(pclist);
        PricingConditionFunctions.getExpiredPricingConditions();
        PricingConditionFunctions.getApprovedPricingConditions();
        PricingConditionFunctions.activatePricingConditions(pcs);
        PricingConditionFunctions.getPricingConditionsPendingApproval();
        PricingConditionFunctions.getClonedPricingCondition(pc1);

        Date fdate = Date.today(); Date tdate = fdate.addDays(60);
        PricingConditionFunctions.extendPricingConditions(pclist, tdate);
        PricingConditionFunctions.setExtendToFields(pc1, tdate);
        PricingConditionFunctions.updateValidityToDate(pclist, tdate);
        pc1 = PricingConditionFunctions.getPricingCondition(pc1.Id);
        PricingConditionFunctions.getMaxDaysToExtend(pc1);
        PricingConditionFunctions.getProspectPCNDaysLimit();
        PricingConditionFunctions.getPricingScales(new Set<Id>{pc1.Id});
        PricingConditionFunctions.isActive(pc1); PricingConditionFunctions.isApproved(pc1);
        PricingConditionFunctions.isCancelled(pc1); PricingConditionFunctions.isExpired(pc1);
        PricingConditionFunctions.isSubmitted(pc1);
        PricingConditionFunctions.getFreightUpcharge(1,2,3,divsnCode);
        PricingConditionFunctions.getInvoicePrice(true, 1, 2, 3, divsnCode, true,
                                                  5, 6, 7, 8, 9, 10, 11, 12, 13,
                                                  14, 15, 16, 17);
        PricingConditionFunctions.getIncreasedBasePrice(pc1, 1, 0);
        PricingConditionFunctions.getIncreasedBasePrice(pc1, 0, 1);
        PricingConditionFunctions.increasePriceScales(pc1, 1, 0);
        PricingConditionFunctions.increasePriceScales(pc1, 0, 1);

        pc1.Active__c = true; pc1.Record_Status__c = 'Active'; update pc1;
        pc4.Active__c = true; pc4.Record_Status__c = 'Active';
        pcs = new List<Pricing_Condition__c>{pc4};
        PricingConditionFunctions.deactivatePricingConditions(pcs);

        pc1.Record_Status__c = SUBMITTED; update pc1;
        String qry = SELECT_QRY_1 + ' where Record_Status__c = :SUBMITTED limit 10';
        pcs = Database.query(qry);
        if (pcs != null && !pcs.isEmpty()) {
            PricingConditionFunctions.processBeforeUpdate = true;
            PricingConditionFunctions.getSubmittedPricingConditions(pcs);
            PricingConditionFunctions.processBeforeUpdate(pcs);
        }

        PricingConditionFunctions.getFieldValues(new Set<String>{'Active'});
        PricingConditionFunctions.setPriceBookEntries(pclist);
        PricingConditionFunctions.SubmitForApproval(pcids);
        PricingConditionFunctions.submitPricingConditionforApproval(pc1.Id);
        PricingConditionFunctions.processProspectPCNs(new Set<Id>{shipTo.Id});
        PricingConditionFunctions.processProspectPCNs(pcs, 30, fdate);
        PricingConditionFunctions.deletePricingConditions(pclist);
        Test.stopTest();
    }

//*
    static testMethod void test02() {
        createTestData(); Test.startTest();
        Map<String, String> pmap = ApexPages.currentPage().getParameters();
        pmap.put('ac', shipTo.Id); pmap.put('rs', 'actv');
        PricingConditionListController pclc = new PricingConditionListController(null);
        pclc.getPricingConditions();
        List<Pricing_Condition> plist = pclc.getPricingConditionList();
        pclc.initAction(); Boolean b;
        b = pclc.isAafiLayout; b = pclc.isAhwtLayout; b = pclc.isActive;
        b = pclc.isEditable;   b = pclc.isSelectable; b = pclc.isDefaultLayout;
        pclc.getRecordStatusList(); pclc.changeRecordStatus();
        if (!plist.isEmpty()) {plist[0].selected = true;}
        pclc.editSelectedList(); pclc.userComments = 'abcd';
        pclc.gotoExtendPage2();  pclc.gotoAccountDetails();
        pclc.gotoAddNewPage();   pclc.gotoExpirePage2();
        pclc.gotoListPage1();    pclc.getSelectedPricingConditions();
        pclc.extendPricingConditions(); pclc.expirePricingConditions();
        pclc.first(); pclc.last(); pclc.next(); pclc.previous();
        pclc.setPageSize(1); pclc.getPageSize(); pclc.setPageNumber(1);
        pclc.getPageNumber(); pclc.gotoNewContractPage();
        Test.stopTest();
    }

    static testMethod void test03() {
        createTestData(); Test.startTest();
        PricingConditionApprovalController c = new PricingConditionApprovalController();
        c.initAction(); c.init3(pcids);
        c.changePageSize(); c.gotoFirstPage(); c.gotoNextPage();
        c.gotoLastPage(); c.gotoPrevPage(); c.gotoPage();
        pclist = c.getPricingConditions();
        Pricing_Condition pc = pclist[0]; Pricing_Condition__c pcc = pc.pricingCondition;
        pc.selected = true; c.editPricingConditions();
        pc.freightCost = 1.11; pcc.Freight_Cost__c = 2.22;
        c.saveChanges(); c.saveChangesAndApprove();
        Test.stopTest();
    }

    static testMethod void test04() {
        createTestData(); Test.startTest();
        PricingConditionApprovalController c = new PricingConditionApprovalController();
        c.initAction(); c.init3(pcids); pclist = c.getPricingConditions();
        Pricing_Condition pc = pclist[0]; pc.selected = true; c.approveSelectedList();
        Test.stopTest();
    }

    static testMethod void test05() {
        createTestData(); Test.startTest();
        PricingConditionApprovalController c = new PricingConditionApprovalController();
        c.initAction(); c.init3(pcids); pclist = c.getPricingConditions();
        Pricing_Condition pc = pclist[0]; pc.selected = true;
        c.userComments = 'test comment'; c.rejectSelectedList();
        Boolean b = c.isDefaultLayout;
        Test.stopTest();
    }

    static testMethod void test06() {
        createTestData(); Test.startTest();
        PricingConditionsToExpireFunctions.MAX_RECS = 20;
        PricingConditionsToExpireController c = new PricingConditionsToExpireController(null);
        c.distChan = distChan; c.userComments = 'test'; c.init();
        c.getPricingConditionsToExpire(); c.getSelectedPricingConditions(); c.expirePricingConditions();
        c.gotoExpirePage1(); c.userComments = ''; c.gotoExpirePage2();
        c.submitExpirationBatchJob(); PricingConditionExpirationBatchable.submitBatchJob();
        List<PricingConditionsToExpireFunctions.Pricing_Condition> plist =
        PricingConditionsToExpireFunctions.getPricingConditionsToExpire(distChan);
        PricingConditionsToExpireFunctions.expirePricingConditions(plist);
        pcs = new List<Pricing_Condition__c>();
        for (PricingConditionsToExpireFunctions.Pricing_Condition p : plist) {
            pcs.add(p.p1); pcs.add(p.p2);}
        PricingConditionsToExpireFunctions.expirePricingConditions(pcs);
        Test.stopTest();
    }
//*/

}