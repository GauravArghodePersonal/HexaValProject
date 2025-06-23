@isTest
private class Pricing_Rebate_Test {

    static Account acc;
    static SAP_ECOM_Customer__c ecomc;
    static Pricing_Rebate__c pr;
    static Pricing_Rebate_Detail__c prd;
    static List<Pricing_Rebate_Detail__c> prds;
    static List<Pricing_Rebate_Account__c> pras;
    static List<Pricing_Rebate_Material__c> prms;
    static List<Material_Sales_Data2__c> materialList;
    static Pricing_Rebate_Configuration__c rebateConfig;
    static Pricing_Rebate_Approval_Controller prac;
    static ApexPages.Standardcontroller sc;
    static Pricing_Rebate_Controller c;
    static Map<String, String> pp;
    static Set<String> prids;

    static PageReference rebatePage = new PageReference('apex/Pricing_Rebate_Page1');
    static Map<String, Id> accRT = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
    static String accRecType = 'Drew Customer';
    static List<Account> accList;
    static String lang     = 'E';
    static String sorg     = '1234';
    static String dchan    = '10';
    static String divsn    = '12';
    static String matnum   = '123456';
    static String ph1code  = '!';
    static String ph2code  = '!23';
    static String ph3code  = '!23456';
    static String ph4code  = '!23456789';
    static String ph5code  = '!23456789123';
    static String ph6code  = '!23456789123456';
    static String ph7code  = '!23456789123456789';
    static String soldTo   = Account_Partner_Functions.ACC_TYPE_SOLDTO;
    static String matId;

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }

    static void setup() {
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

        SAP_Sales_Area__c sa = new SAP_Sales_Area__c();
        sa.Sales_Org_Code__c = sorg;
        sa.Distribution_Channel_Code__c = dchan;
        sa.Sales_Division_Code__c = divsn;
        sa.Record_Key__c = '12341012';
        insert sa;

        SAP_Sales_Org__c so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = sorg;
        so.Sales_Org_Description__c = '1234 desc';
        so.Language_Code__c = 'E';
        insert so;

        SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = dchan;
        dc.Distribution_Channel_Description__c = '10 desc';
        dc.Language_Code__c = 'E';
        insert dc;

        SAP_Sales_Division__c sd = new SAP_Sales_Division__c();
        sd.Language_Code__c = 'E';
        sd.Sales_Division_Code__c = divsn;
        sd.Sales_Division_Description__c = '12 desc';
        insert sd;

        debug('accRT : ' + accRT);
        accList = new List<Account>();
        for(Integer I = 0; I < 2; I++){
            acc = new Account(Name='Test Account', RecordTypeId=accRT.get(accRecType));
            acc.Active_Account__c = 'Yes';
            acc.SAP_Sales_Org__c = sorg;
            acc.SAP_Sales_Org_Desc__c = '1234 desc';
            acc.SAP_DistChannel__c = dchan;
            acc.SAP_Dist_Channel_Desc__c = '10 desc';
            acc.SAP_DivisionCode__c = divsn;
            acc.SAP_Division_Desc__c = '12 desc';
            acc.AccountNumber = '0000123456';
            acc.Account_Number__c = '000012345612341012';
            acc.SAP_Currency__c = 'USD';
            acc.SAP_City__c = 'Test City';
            accList.add(acc);
        }
        //insert accList;
        //debug('accList : '+accList);
        insert acc;
        acc.AccountNumber = '0000123456';
        acc.Account_Number__c = '000012345612341212';
        update acc;
        acc = Pricing_Rebate_Functions.getAccount(acc.Id);
        debug('acc : '+acc);

        ecomc = new SAP_ECOM_Customer__c();
        ecomc.Ship_To__c = acc.Id; ecomc.Ship_Account__c = acc.AccountNumber;
        ecomc.Sold_To__c = acc.Id; ecomc.Sold_Account__c = acc.AccountNumber;
        ecomc.Key__c = acc.AccountNumber + '-' + acc.AccountNumber;
        insert ecomc;

        materialList = new List<Material_Sales_Data2__c>();
        for(Integer n = 0; n < 2; n++){
            Material_Sales_Data2__c msd = new Material_Sales_Data2__c();
            msd.Material_Number__c = matnum + n;
            msd.Sales_Org_Code__c = sorg;
            msd.Dist_Channel_Code__c = dchan;
            msd.Record_Key__c = matnum + n + sorg + dchan;
            msd.PH5_Family__c = '726';
            materialList.add(msd);
        }
        insert materialList; matId = materialList[0].Id;
        debug('materialList : '+materialList);

        Pricing_Rebate_Approvers__c pra = new Pricing_Rebate_Approvers__c();
        pra.Approver_1__c = UserInfo.getUserId();
        pra.Process_Order__c = '01';
        pra.Recipient_Record_Type__c = accRecType;
        insert pra;

        rebateConfig = new Pricing_Rebate_Configuration__c();
        rebateConfig.Sales_Org__c = sorg;
        rebateConfig.Dist_Channel__c = dchan;
        rebateConfig.Rebate_Agreement_Type__c = 'Z020';
        rebateConfig.Rebate_Agreement_Description__c = 'Cust/Matl Rebate';
        rebateConfig.Condition_Type__c = 'Z020';
        rebateConfig.Condition_Type_Desc__c = 'Cust/MatlRebUn/Qty';
        rebateConfig.Table__c = 'A902';
        rebateConfig.Table_Description__c = 'SOrg/DC/Sold To/Matl';
        insert rebateConfig;

        Pricing_Rebate_Configuration__c rebateConfig1 = new Pricing_Rebate_Configuration__c();
        rebateConfig1.Sales_Org__c = sorg;
        rebateConfig1.Dist_Channel__c = dchan;
        rebateConfig1.Rebate_Agreement_Type__c = 'Z025';
        rebateConfig1.Rebate_Agreement_Description__c = 'Cust Rebate';
        rebateConfig1.Condition_Type__c = 'Z020';
        rebateConfig1.Condition_Type_Desc__c = 'Cust/MatlRebUn/Qty';
        rebateConfig1.Table__c = 'A902';
        rebateConfig1.Table_Description__c = 'SOrg/DC/Sold To/Matl';
        insert rebateConfig1;

        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = lang;
        ph1.Product_Hierarchy_Code__c = ph1code;
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = lang;
        ph2.Product_Hierarchy_Code__c = ph2code;
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = lang;
        ph3.Product_Hierarchy_Code__c = ph3code;
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = lang;
        ph4.Product_Hierarchy_Code__c = ph4code;
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = lang;
        ph5.Product_Hierarchy_Code__c = ph5code;
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = lang;
        ph6.Product_Hierarchy_Code__c = ph6code;
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = lang;
        ph7.Product_Hierarchy_Code__c = ph7code;
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

        Test.setCurrentPage(rebatePage);
        pp = ApexPages.currentPage().getParameters();
        pp.put('accountId', acc.Id);

        pr = new Pricing_Rebate__c();
        pr.Rebate_Recipient__c = acc.Id;
        pr.Sales_Org__c = sorg;
        pr.Dist_Channel__c = dchan;
        pr.Condition_Type__c = 'Z020';
        pr.Rebate_Agreement_Type__c = 'Z020';
        pr.Rebate_Start_Date__c = Date.today();
        pr.Rebate_End_Date__c = Date.today().addDays(30);
    }

    static void setup2() {
        setup(); pr.Status__c = 'Approved'; insert pr;
        prds = new List<Pricing_Rebate_Detail__c>();
        for (Material_Sales_Data2__c m : materialList) {
            prd = new Pricing_Rebate_Detail__c();
            prd.Account__c = acc.Id; prd.Accrual__c = 1;
            prd.Material_Sales_Data2__c = m.Id;
            prd.Pricing_Rebate__c = pr.Id;
            prds.add(prd);
        }
        insert prds;
    }

//*
    static testMethod void test01() {
    //Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p0 = new PriceFx__c();
        p0.allowed_recordtype_id__c = '01250000000HmZV';
        p0.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p0.Name='callAccount';
        p0.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p0.password__c='Testuser@123';
        p0.username__c='sfdctestuser';
        pfxCustomList.add(p0);
        
        
        
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
        Test.startTest();
        acc = new Account(Name='RebateRecipient');
        insert acc;
        acc.AccountNumber = '0000123456';
        acc.Account_Number__c = '000012345612341212';
        update acc;

        pr = new Pricing_Rebate__c();
        pr.Rebate_Recipient__c = acc.Id;
        insert pr;
        prac = new Pricing_Rebate_Approval_Controller();

        Set<String> ids = new Set<String>{pr.Id};
        prac.getPricingRebates();
        prac.setPricingRebates(ids);
        for (Pricing_Rebate p : prac.plist) {p.selected = true;}
        prac.rejectSelectedList();
        prac.userComments = 'test';
        prac.rejectSelectedList();
        prac.approveSelectedList();
    }

    static testMethod void test02() {
        Test.startTest(); setup();
        sc = new ApexPages.Standardcontroller(pr);
        c = new Pricing_Rebate_Controller(sc); c.initAction1();
        c.custSearch.accCity = acc.BillingCity;
        c.custSearch.accName = acc.Name;
        c.custSearch.accNumber = acc.AccountNumber;
        c.tables = rebateConfig.Table_Description__c;
        c.displayCustomerAndMaterial = true;
        pp.put('invokedFromAddCustomer','true');
        pp.put('invokedFromAddMaterial','true');
        debug('acc : ' + acc);
        c.addCustomer(); c.searchCustomer(); c.getAccountList();
        debug('accountList : ' + c.accountList);
        c.gotoPage2();
        for(Pricing_RebateAccountWrapper a : c.accountList){a.addToRebate = true;}
        c.addCustomersToRebate(); c.addCustomersToRebate();
        debug('customersAdded : ' + c.customersAdded);
        if (c.customersAdded.size() > 0) {
            c.customersAdded.get(0).rebateDetail.Amount__c = 5;
            c.customersAdded.get(0).rebateDetail.Accrual__c = 5;
        }
        c.setRenderShiptoLvlMsg(); c.copyCustomerValues();
        c.materialSearch.materialNumber = matnum;
        c.searchMaterial(); c.getMaterialList();
        debug('materialList : ' + c.materialList);
        for(Pricing_RebateMaterialWrapper m : c.materialList){m.addToRebate = true;}
        c.addMaterialsToRebate(); c.addMaterialsToRebate();
        debug('materialsAdded : ' + c.materialsAdded);
        if (c.materialsAdded.size() > 0) {
            c.materialsAdded.get(0).rebateDetail.Amount__c = 5;
            c.materialsAdded.get(0).rebateDetail.Accrual__c = 5;
            c.materialsAdded.get(0).rebateDetail.Unit__c = 'USD';
        }
        c.copyMaterialValues();
        debug('materialsAdded : ' + c.materialsAdded);
        c.tables = 'A902 - SOrg/DC/Sold To/Matl';
        debug('rebate : ' + c.rebate);
        c.save();
        debug('customersAdded : ' + c.customersAdded);
        if (c.customersAdded.size() > 0) {
            c.customersAdded.get(0).deleteCustomer = true;
        }
        if (c.materialsAdded.size() > 0) {
            c.materialsAdded.get(0).deleteMaterial = true;
        }
        c.deleteCustomers();
        c.deleteMaterials();
        c.populateDistChannel();
        c.populateDivision();
        c.clearCustomerSelector();
        c.cancelCustomerSelector();
        c.clearMaterialSelector();
        c.cancelMaterialSelector();
        c.onRebateTypeChange();
        c.populateProductHierarchy6();
        c.searchMaterial();
        c.displayCustomerAndMaterial = false; c.save();
    }

    static testMethod void test03() {
        Test.startTest(); setup();
        pp.put('accountId', acc.Id); pp.put('SelectedAccId', acc.Id);
        sc = new ApexPages.Standardcontroller(pr);
        c = new Pricing_Rebate_Controller(sc); c.initAction1();
        c.searchCustomer(); c.getAccountList();
        debug('accountList : ' + c.accountList);
        c.submitRecipient(); c.gotoAccountPage(); c.gotoPage1();
    }

    static testMethod void test04() {
        setup2();
        sc = new ApexPages.Standardcontroller(pr);
        c = new Pricing_Rebate_Controller(sc); c.initAction1();
        c.displayCustomerAndMaterial = true;
        debug('customersAdded : ' + c.customersAdded);
        debug('materialsAdded : ' + c.materialsAdded);
        c.gotoPricingRebatePage(); c.updateRebateInfo();
        c.validateCustomerInformation();
        c.validateMaterialInformation();
        c.validateMFD();
        c.cloneRebateAndDetailInfo();
        c.updateRebateAndDetailInfo();
        c.saveAndSubmit();
        c.expireRebate(); c.deleteRebate();
    }

    static testMethod void test05() {
        setup2();
        Pricing_RebateCustomerSelectorSearch asp = new Pricing_RebateCustomerSelectorSearch();
        asp.distChannel = dchan; asp.salesOrg = sorg; asp.division = divsn;
        asp.accNumber = '123456'; asp.accName = 'test'; asp.accCity = 'test';
        asp.isShipTo = true; asp.isSoldTo = false;
        Pricing_RebateMaterialSelectorSearch msp = new Pricing_RebateMaterialSelectorSearch();
        msp.prodHierarchy5 = '123'; msp.prodHierarchy6 = '123';
        msp.distChannel = dchan; msp.salesOrg = sorg;
        msp.materialNumber = '123456'; msp.materialDesc = 'test';
        Pricing_Rebate_Functions.getAccountsPC(asp);
        Pricing_Rebate_Functions.getMaterialsPC(msp);
        Pricing_Rebate_Functions.getRebateAmount(acc.Id, matId, Date.today(), Date.today(), 1, 'USD', 'LB');
    }
//*/

    static testMethod void test06() {
        setup2(); String r1 = pr.Id, r2;
        pr = new Pricing_Rebate__c();
        pr.Rebate_Recipient__c = acc.Id;
        insert pr; r2 = pr.Id;
        prd = new Pricing_Rebate_Detail__c();
        prd.Account__c = acc.Id; prd.Accrual__c = 1;
        prd.Material_Sales_Data2__c = matId;
        prd.Pricing_Rebate__c = pr.Id;
        insert prd;
        Pricing_Rebate_Functions.copyRebateDetails(r1, r2);
    }
}