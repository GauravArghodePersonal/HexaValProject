@isTest
private class Rolling_Product_Sales_Info_Test {

    static Account acc;
    static Material_Sales_Data2__c mat;
    static Material_General_Data2__c mgd2;
    static Account_Sales_Figure__c asf;
    static Account_Sales_Plan__c asp;
    static Product_Sales_Figure__c psf;
    static Product_Sales_Plan__c psp;
    static Rolling_Product_Sales_Info__c rpsi;
    static Account_Sales_Info asi;
    static String accId;
    static String UOM = 'KG';
    static String ACCTYPE = 'SHIP';
    static String SORG = '1234';
    static String DCHAN = '50';
    static List<String> fps = new List<String>{'2012012', '2013012'};
    static List<String> drs = new List<String>{'CM', 'FYTD', 'PFYTD'};
    static List<Account> accs;
    static List<Account_Sales_Figure__c> asfs;
    static List<Account_Sales_Plan__c> asps;
    static List<Product_Sales_Figure__c> psfs;
    static List<Product_Sales_Plan__c> psps;
    static List<Material_Sales_Data2__c> mats;
    static List<Rolling_Product_Sales_Info__c> rpsis;
    static CustomSettings__c csc;

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'RPSI_Test : ' + s);
    }

    static void setup() {
        csc = new CustomSettings__c();
        csc.BW_Data_Start_Date__c = Date.newInstance(2013, 9, 1);
        insert csc;

        accs = new List<Account>();
        addAcc('TestAcc1'); addAcc('TestAcc2');
        upsert accs Account_Number__c; accId = acc.Id;
        debug('accs = ' + accs);

        mats = new List<Material_Sales_Data2__c>();
        addMat('TestMat1'); addMat('TestMat2');
        upsert mats Record_Key__c;

        mgd2 = new Material_General_Data2__c();
        mgd2.Name = 'mgd2 Name';
        mgd2.Material_Number__c = 'mgd2 Number';
        insert mgd2;

        asfs = new List<Account_Sales_Figure__c>();
        for (String fp : fps) {
            for (String dr : drs) {
                for(Account a : accs) {addAsf(fp, dr, a);}
            }
        }
        upsert asfs Key__c; debug('asfs = ' + asfs);

        asps = new List<Account_Sales_Plan__c>();
        for (String fp : fps) {
            for (String dr : drs) {
                for(Account a : accs) {addAsp(fp, dr, a);}
            }
        }
        upsert asps Key__c;

        psfs = new List<Product_Sales_Figure__c>();
        for (String fp : fps) {
            for (String dr : drs) {
                for(Material_Sales_Data2__c m : mats) {addPsf(fp, dr, m);}
            }
        }
        upsert psfs Key__c;

        psps = new List<Product_Sales_Plan__c>();
        for (String fp : fps) {
            for (String dr : drs) {
                for(Material_Sales_Data2__c m : mats) {addPsp(fp, dr, m);}
            }
        }
        upsert psps Key__c;
    }

    static void addAcc(String accNum) {
        acc = new Account(Name = accNum);
        acc.Account_Number__c = accNUM + SORG + DCHAN + DCHAN;
        accs.add(acc);
    }

    static void addMat(String matNum) {
        String rk = matNum + SORG + DCHAN;
        mat = new Material_Sales_Data2__c(Name = matNum,
                                          Material_Number__c = matNum,
                                          Sales_Org_Code__c = SORG,
                                          Dist_Channel_Code__c = DCHAN,
                                          Record_Key__c = rk);
        debug('mat = ' + mat); mats.add(mat);
    }

    static void addAsf(String fp, String dr, Account a) {
        asf = new Account_Sales_Figure__c();
        asf.CustomerType__c = ACCTYPE;
        asf.Account__c = a.Id;
        asf.Account_Number__c = a.Name;
        asf.Date_Range_Label__c = dr;
        asf.FiscalPeriod__c = fp;
        asf.Key__c = ACCTYPE + a.Id + fp + dr;
        asf.Sales_Amount_Local__c = Double.valueOf(fp) / 100 + 1;
        asf.Sales_Volume_in_KGs__c = Double.valueOf(fp) / 100 + 2;
        asf.Sales_Volume_in_LBs__c = Double.valueOf(fp) / 100 + 2;
        asf.Sales_Volume_UOM__c = UOM;
        asf.DistChan_Code__c = DCHAN;
        asf.Division_Code__c = DCHAN;
        asf.SalesOrg_Code__c = SORG;
        asfs.add(asf);
    }

    static void addAsp(String fp, String dr, Account a) {
        asp = new Account_Sales_Plan__c();
        asp.CustomerType__c = ACCTYPE;
        asp.Account__c = a.Id;
        asp.RecordType__c = dr;
        asp.FiscalPeriod__c = fp;
        asp.Key__c = ACCTYPE + a.Id + fp + dr;
        asp.Sales_Amount_Local__c = Double.valueOf(fp) / 100 + 1;
        asp.Sales_Volume__c = Double.valueOf(fp) / 100 + 2;
        asp.Sales_Volume_UOM__c = UOM;
        asps.add(asp);
    }

    static void addPsf(String fp, String dr, Material_Sales_Data2__c m) {
        psf = new Product_Sales_Figure__c();
        psf.CustomerType__c = ACCTYPE;
        psf.Account__c = accId;
        psf.Material2__c = m.Id;
        psf.Material_Number__c = m.Material_Number__c;
        psf.DistChan_Code__c = DCHAN;
        psf.Division_Code__c = DCHAN;
        psf.Date_Range_Label__c = dr;
        psf.FiscalPeriod__c = fp;
        psf.Month_Year__c = Date.today();
        psf.Key__c = ACCTYPE + acc.Id + m.Id + fp + dr;
        psf.Sales_Amount_Local__c = Double.valueOf(fp) / 100 + 1;
        psf.Sales_Volume__c = Double.valueOf(fp) / 100 + 2;
        psf.Sales_Volume_UOM__c = UOM;
        psfs.add(psf);
    }

    static void addPsp(String fp, String dr, Material_Sales_Data2__c m) {
        psp = new Product_Sales_Plan__c();
        psp.CustomerType__c = ACCTYPE;
        psp.Account__c = accId;
        psp.Material__c = m.Id;
        psp.Material_Number__c = m.Material_Number__c;
        psp.DistChan_Code__c = DCHAN;
        psp.Division_Code__c = DCHAN;
        psp.RecordType__c = dr;
        psp.FiscalPeriod__c = fp;
        psp.Key__c = ACCTYPE + acc.Id + m.Id + fp + dr;
        psp.Sales_Amount_Local__c = Double.valueOf(fp) / 100 + 1;
        psp.Sales_Volume__c = Double.valueOf(fp) / 100 + 2;
        psp.Sales_Volume_UOM__c = UOM;
        psps.add(psp);
    }

    static testMethod void test01() {
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


        setup(); Account_Sales_Info_Controller c = new Account_Sales_Info_Controller();

        rpsi = new Rolling_Product_Sales_Info__c();
        rpsi.Account__c = acc.Id; rpsi.Key__c = 'Key';
        rpsi.Month_01__c = Rolling_Product_Sales_Info.START_FP;
        rpsi.Record_Type__c = Rolling_Product_Sales_Info.RECTYPE_ACC;
        insert rpsi;

        c.setAccId(accId); c.setRpsView();

        Boolean b; Double d; String s;

        asi = new Account_Sales_Info(); asi = new Account_Sales_Info(accId); asi = c.getAccountSalesInfo();
        asi.addData('', null, null, 0, 0, 0, 0, 0, 0.0, 0.0, 0, '');

        s = asi.FYF_Amount_formatted;
        s = asi.FYF_Amount_style;
        s = asi.FYF_Label;
        s = asi.FYF_Plan_Amount_formatted;
        s = asi.FYF_Plan_Amount_style;
        s = asi.FYF_Plan_Volume_in_KG_formatted;
        s = asi.FYF_Plan_Volume_in_KG_style;
        s = asi.FYF_Plan_Volume_in_LB_formatted;
        s = asi.FYF_Plan_Volume_in_LB_style;
        s = asi.FYF_Volume_in_KG_formatted;
        s = asi.FYF_Volume_in_KG_style;
        s = asi.FYF_Volume_in_LB_formatted;
        s = asi.FYF_Volume_in_LB_style;

        s = asi.PFYF_Amount_formatted;
        s = asi.PFYF_Amount_style;
        s = asi.PFYF_Label;
        s = asi.PFYF_Plan_Amount_formatted;
        s = asi.PFYF_Plan_Amount_style;
        s = asi.PFYF_Plan_Volume_in_KG_formatted;
        s = asi.PFYF_Plan_Volume_in_KG_style;
        s = asi.PFYF_Plan_Volume_in_LB_formatted;
        s = asi.PFYF_Plan_Volume_in_LB_style;
        s = asi.PFYF_Volume_in_KG_formatted;
        s = asi.PFYF_Volume_in_KG_style;
        s = asi.PFYF_Volume_in_LB_formatted;
        s = asi.PFYF_Volume_in_LB_style;

        s = asi.FYTD_Amount_formatted;
        s = asi.FYTD_Amount_style;
        s = asi.FYTD_GM_formatted;
        s = asi.FYTD_GM_style;
        s = asi.FYTD_GMpct_formatted;
        s = asi.FYTD_GMpct_style;
        s = asi.FYTD_Label;

        s = asi.PFYTD_Amount_formatted;
        s = asi.PFYTD_Amount_style;
        s = asi.PFYTD_GM_formatted;
        s = asi.PFYTD_GM_style;
        s = asi.PFYTD_GMpct_formatted;
        s = asi.PFYTD_GMpct_style;
        s = asi.PFYTD_Label;

        s = asi.FYTD_Plan_Amount_formatted;
        s = asi.FYTD_Plan_Amount_style;
        s = asi.FYTD_Plan_Volume_in_KG_formatted;
        s = asi.FYTD_Plan_Volume_in_KG_style;
        s = asi.FYTD_Plan_Volume_in_LB_formatted;
        s = asi.FYTD_Plan_Volume_in_LB_style;

        s = asi.PFYTD_Plan_Amount_formatted;
        s = asi.PFYTD_Plan_Amount_style;
        s = asi.PFYTD_Plan_Volume_in_KG_formatted;
        s = asi.PFYTD_Plan_Volume_in_KG_style;
        s = asi.PFYTD_Plan_Volume_in_LB_formatted;
        s = asi.PFYTD_Plan_Volume_in_LB_style;

        s = asi.FYTD_Volume_in_GL_formatted;
        s = asi.FYTD_Volume_in_GL_style;
        s = asi.FYTD_Volume_in_KG_formatted;
        s = asi.FYTD_Volume_in_KG_style;
        s = asi.FYTD_Volume_in_LB_formatted;
        s = asi.FYTD_Volume_in_LB_style;
        s = asi.FYTD_Volume_in_PT_formatted;
        s = asi.FYTD_Volume_in_PT_style;
        s = asi.FYTD_Volume_in_UN_formatted;
        s = asi.FYTD_Volume_in_UN_style;

        s = asi.PFYTD_Volume_in_GL_formatted;
        s = asi.PFYTD_Volume_in_GL_style;
        s = asi.PFYTD_Volume_in_KG_formatted;
        s = asi.PFYTD_Volume_in_KG_style;
        s = asi.PFYTD_Volume_in_LB_formatted;
        s = asi.PFYTD_Volume_in_LB_style;
        s = asi.PFYTD_Volume_in_PT_formatted;
        s = asi.PFYTD_Volume_in_PT_style;
        s = asi.PFYTD_Volume_in_UN_formatted;
        s = asi.PFYTD_Volume_in_UN_style;

        b = asi.FYTDvsPFYTD_Amount_Down;
        b = asi.FYTDvsPFYTD_Amount_Up;
        s = asi.FYTDvsPFYTD_Amount_Variance_formatted;
        s = asi.FYTDvsPFYTD_Amount_Variance_style;
        s = asi.FYTDvsPFYTD_Amount_VPercent_formatted;
        s = asi.FYTDvsPFYTD_Amount_VPercent_style;

        b = asi.FYTDvsPFYTD_GM_Down;
        b = asi.FYTDvsPFYTD_GM_Up;
        s = asi.FYTDvsPFYTD_GM_Variance_formatted;
        s = asi.FYTDvsPFYTD_GM_Variance_style;
        s = asi.FYTDvsPFYTD_GM_VPercent_formatted;
        s = asi.FYTDvsPFYTD_GM_VPercent_style;

        b = asi.FYTDvsPFYTD_GMpct_Down;
        b = asi.FYTDvsPFYTD_GMpct_Up;
        s = asi.FYTDvsPFYTD_GMpct_Variance_formatted;
        s = asi.FYTDvsPFYTD_GMpct_Variance_style;
        s = asi.FYTDvsPFYTD_GMpct_VPercent_formatted;
        s = asi.FYTDvsPFYTD_GMpct_VPercent_style;

        s = asi.FYTDvsPFYTD_Label;
        s = asi.FYTDvsPFYTD_Percent_Label;

        b = asi.FYTDvsPFYTD_Plan_Amount_Down;
        b = asi.FYTDvsPFYTD_Plan_Amount_Up;
        s = asi.FYTDvsPFYTD_Plan_Amount_Variance_formatted;
        s = asi.FYTDvsPFYTD_Plan_Amount_Variance_style;
        s = asi.FYTDvsPFYTD_Plan_Amount_VPercent_formatted;
        s = asi.FYTDvsPFYTD_Plan_Amount_VPercent_style;

        b = asi.FYTDvsPFYTD_Plan_Volume_in_KG_Down;
        b = asi.FYTDvsPFYTD_Plan_Volume_in_KG_Up;
        s = asi.FYTDvsPFYTD_Plan_Volume_in_KG_Variance_formatted;
        s = asi.FYTDvsPFYTD_Plan_Volume_in_KG_Variance_style;
        s = asi.FYTDvsPFYTD_Plan_Volume_in_KG_VPercent_formatted;
        s = asi.FYTDvsPFYTD_Plan_Volume_in_KG_VPercent_style;

        b = asi.FYTDvsPFYTD_Plan_Volume_in_LB_Down;
        b = asi.FYTDvsPFYTD_Plan_Volume_in_LB_Up;
        s = asi.FYTDvsPFYTD_Plan_Volume_in_LB_Variance_formatted;
        s = asi.FYTDvsPFYTD_Plan_Volume_in_LB_Variance_style;
        s = asi.FYTDvsPFYTD_Plan_Volume_in_LB_VPercent_formatted;
        s = asi.FYTDvsPFYTD_Plan_Volume_in_LB_VPercent_style;

        b = asi.FYTDvsPFYTD_Volume_in_GL_Down;
        b = asi.FYTDvsPFYTD_Volume_in_GL_Up;
        s = asi.FYTDvsPFYTD_Volume_in_GL_Variance_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_GL_Variance_style;
        s = asi.FYTDvsPFYTD_Volume_in_GL_VPercent_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_GL_VPercent_style;

        b = asi.FYTDvsPFYTD_Volume_in_KG_Down;
        b = asi.FYTDvsPFYTD_Volume_in_KG_Up;
        s = asi.FYTDvsPFYTD_Volume_in_KG_Variance_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_KG_Variance_style;
        s = asi.FYTDvsPFYTD_Volume_in_KG_VPercent_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_KG_VPercent_style;

        b = asi.FYTDvsPFYTD_Volume_in_LB_Down;
        b = asi.FYTDvsPFYTD_Volume_in_LB_Up;
        s = asi.FYTDvsPFYTD_Volume_in_LB_Variance_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_LB_Variance_style;
        s = asi.FYTDvsPFYTD_Volume_in_LB_VPercent_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_LB_VPercent_style;

        b = asi.FYTDvsPFYTD_Volume_in_PT_Down;
        b = asi.FYTDvsPFYTD_Volume_in_PT_Up;
        s = asi.FYTDvsPFYTD_Volume_in_PT_Variance_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_PT_Variance_style;
        s = asi.FYTDvsPFYTD_Volume_in_PT_VPercent_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_PT_VPercent_style;

        b = asi.FYTDvsPFYTD_Volume_in_UN_Down;
        b = asi.FYTDvsPFYTD_Volume_in_UN_Up;
        s = asi.FYTDvsPFYTD_Volume_in_UN_Variance_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_UN_Variance_style;
        s = asi.FYTDvsPFYTD_Volume_in_UN_VPercent_formatted;
        s = asi.FYTDvsPFYTD_Volume_in_UN_VPercent_style;

        s = asi.S2P_FYTD_Amount_Variance_formatted;
        s = asi.S2P_FYTD_Amount_Variance_style;
        s = asi.S2P_FYTD_Amount_VPercent_formatted;
        s = asi.S2P_FYTD_Amount_VPercent_style;

        s = asi.S2P_FYTD_VLB_Variance_formatted;
        s = asi.S2P_FYTD_VLB_Variance_style;
        s = asi.S2P_FYTD_VLB_VPercent_formatted;
        s = asi.S2P_FYTD_VLB_VPercent_style;

        s = asi.S2P_FYTD_VKG_Variance_formatted;
        s = asi.S2P_FYTD_VKG_Variance_style;
        s = asi.S2P_FYTD_VKG_VPercent_formatted;
        s = asi.S2P_FYTD_VKG_VPercent_style;

    }

    static testMethod void test02() {
        Double f1 = -1.1, f2 = 2.2;
        Decimal d1 = Decimal.valueOf(f1), d2 = Decimal.valueOf(f2);
        Integer n1 = 1; String s = 'str';
        Date dt1 = Date.today(); Date dt2 = dt1.addDays(90);
        Rolling_Product_Sales_Info.getVariance(f1, f2);
        Rolling_Product_Sales_Info.getVariance(d1, d2);
        Rolling_Product_Sales_Info.getVPercent(f1, f2);
        Rolling_Product_Sales_Info.getVPercent(d1, d2);
        Rolling_Product_Sales_Info.isNegative(f1);
        Rolling_Product_Sales_Info.isPositive(f1);
        Rolling_Product_Sales_Info.getString(d1);
        Rolling_Product_Sales_Info.getString(d1, s);
        Rolling_Product_Sales_Info.getString(f1, s);
        Rolling_Product_Sales_Info.getString(s, dt1, dt2);
        Rolling_Product_Sales_Info.formatPercent(d1);
        Rolling_Product_Sales_Info.getStyle(d1);
        Rolling_Product_Sales_Info.getStyle(n1);
        Rolling_Product_Sales_Info.getFiscalPeriods('2013012');
    }

    static testMethod void test03() {
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


        setup();
        Rolling_Product_Sales_Info.RPSI_Field rpsiField = new Rolling_Product_Sales_Info.RPSI_Field();
        rpsiField.setStyle('bold');
        rpsiField.setValue('123');

        rpsi = new Rolling_Product_Sales_Info__c();
        rpsi.Material_General_Data2__c = mgd2.Id;
        rpsi.Account__c = acc.Id; rpsi.Key__c = 'Key';
        rpsi.Month_01__c = Rolling_Product_Sales_Info.START_FP;
        insert rpsi;

        Rolling_Product_Sales_Info.RPSI_Line rpsiLine1 = new Rolling_Product_Sales_Info.RPSI_Line(rpsi, '',1);

        Rolling_Product_Sales_Info__c rpsi2 = new Rolling_Product_Sales_Info__c();
        rpsi2.Material2__c = mat.Id;
        rpsi2.Account__c = acc.Id;
        rpsi2.Key__c = 'Key2';
        rpsi2.Month_01__c = 'Feb 99';
        insert rpsi2;
        Rolling_Product_Sales_Info.RPSI_Line rpsiLine2 = new Rolling_Product_Sales_Info.RPSI_Line(rpsi2, '',2);

        Rolling_Product_Sales_Info.getStartDate();
        Rolling_Product_Sales_Info.getStartDate('1');
        Rolling_Product_Sales_Info.getStartDate('2000001');

        Rolling_Product_Sales_Info.getMonthsBetween('','');

        List<Account_Sales_Figure__c> asfList = new List<Account_Sales_Figure__c>();

        asf = new Account_Sales_Figure__c();
        asf.CustomerType__c = ACCTYPE;
        asf.Account__c = acc.Id;
        asf.Account_Number__c = acc.Name;
        asf.Date_Range_Label__c = 'FYTD';
        asf.FiscalPeriod__c = '2010012';
        asf.Key__c = ACCTYPE + acc.Id + '2010012' + 'FYTD';
        asf.Sales_Amount_Company__c =  Double.valueOf('2010012') / 100 + 1;
        asf.Sales_Volume_in_KGs__c = Double.valueOf('2010012') / 100 + 2;
        asf.Sales_Volume_in_LBs__c = Double.valueOf('2010012') / 100 + 2;
        asf.Sales_Volume__c = 1000;
        asf.Sales_Volume_UOM__c = 'KG';
        asf.DistChan_Code__c = DCHAN;
        asf.Division_Code__c = DCHAN;
        asf.SalesOrg_Code__c = SORG;
        insert asf;
        asfList.add(asf);

        asf = new Account_Sales_Figure__c();
        asf.CustomerType__c = ACCTYPE;
        asf.Account__c = acc.Id;
        asf.Account_Number__c = acc.Name;
        asf.Date_Range_Label__c = 'FYTD';
        asf.FiscalPeriod__c = '2010012';
        asf.Key__c = ACCTYPE + acc.Id + '2010012' + 'PFYTD';
        asf.Sales_Amount_Company__c =  Double.valueOf('2010012') / 100 + 1;
        asf.Sales_Volume_in_KGs__c = Double.valueOf('2010012') / 100 + 2;
        asf.Sales_Volume_in_LBs__c = Double.valueOf('2010012') / 100 + 2;
        asf.Sales_Volume__c = 1000;
        asf.Sales_Volume_UOM__c = 'LB';
        asf.DistChan_Code__c = DCHAN;
        asf.Division_Code__c = DCHAN;
        asf.SalesOrg_Code__c = SORG;
        insert asf;
        asfList.add(asf);

        asf = new Account_Sales_Figure__c();
        asf.CustomerType__c = ACCTYPE;
        asf.Account__c = acc.Id;
        asf.Account_Number__c = acc.Name;
        asf.Date_Range_Label__c = '';
        asf.FiscalPeriod__c = '2010012';
        asf.Key__c = ACCTYPE + acc.Id + '2010012' + 'CM';
        asf.Sales_Amount_Company__c =  Double.valueOf('2010012') / 100 + 1;
        asf.Sales_Volume_in_KGs__c = Double.valueOf('2010012') / 100 + 2;
        asf.Sales_Volume_in_LBs__c = Double.valueOf('2010012') / 100 + 2;
        asf.Sales_Volume__c = 1000;
        asf.Sales_Volume_UOM__c = 'LB';
        asf.DistChan_Code__c = DCHAN;
        asf.Division_Code__c = DCHAN;
        asf.SalesOrg_Code__c = SORG;
        insert asf;
        asfList.add(asf);

        Rolling_Product_Sales_Info.upsertRPSI_ASF(asfList,'2010012');

        Rolling_Product_Sales_Info.upsertRPSI_ASP(asps,'2012012');

        List<Product_Sales_Figure__c> psfList = new List<Product_Sales_Figure__c>();

        psf = new Product_Sales_Figure__c();
        psf.CustomerType__c = ACCTYPE;
        psf.Account__c = acc.Id;
        psf.Material2__c = mat.Id;
        psf.Material_Number__c = mat.Material_Number__c;
        psf.DistChan_Code__c = DCHAN;
        psf.Division_Code__c = DCHAN;
        psf.Date_Range_Label__c = '';
        psf.FiscalPeriod__c = '2010012';
        psf.Month_Year__c = Date.today();
        psf.Key__c = ACCTYPE + acc.Id + mat.Id + '2010012' + 'CM';
        psf.Sales_Amount_Local__c = Double.valueOf('2010012') / 100 + 1;
        psf.Sales_Volume__c = Double.valueOf('2010012') / 100 + 2;
        psf.Sales_Volume_UOM__c = UOM;

        psfList.add(psf);

        Product_Sales_Figure__c psf2 = new Product_Sales_Figure__c();
        psf2.CustomerType__c = ACCTYPE;
        psf2.Account__c = acc.Id;
        psf2.Material2__c = mat.Id;
        psf2.Material_Number__c = mat.Material_Number__c;
        psf2.DistChan_Code__c = DCHAN;
        psf2.Division_Code__c = DCHAN;
        psf2.Date_Range_Label__c = '';
        psf2.FiscalPeriod__c = '';
        psf2.Month_Year__c = Date.today();
        psf2.Key__c = ACCTYPE + acc.Id + mat.Id + '2010012' + 'FYTD';
        psf2.Sales_Amount_Local__c = Double.valueOf('2010012') / 100 + 1;
        psf2.Sales_Volume__c = Double.valueOf('2010012') / 100 + 2;
        psf2.Sales_Volume_UOM__c = UOM;

        psfList.add(psf2);

        Product_Sales_Figure__c psf3 = new Product_Sales_Figure__c();
        psf3.CustomerType__c = ACCTYPE;
        psf3.Account__c = acc.Id;
        psf3.Material2__c = mat.Id;
        psf3.Material_Number__c = mat.Material_Number__c;
        psf3.DistChan_Code__c = DCHAN;
        psf3.Division_Code__c = DCHAN;
        psf3.Date_Range_Label__c = '';
        psf3.FiscalPeriod__c = '';
        psf3.Month_Year__c = Date.today();
        psf3.Key__c = ACCTYPE + acc.Id + mat.Id + '2010012' + 'PFYTD';
        psf3.Sales_Amount_Company__c = Double.valueOf('2010012') / 100 + 1;
        psf3.Sales_Volume__c = Double.valueOf('2010012') / 100 + 2;
        psf3.Sales_Volume_UOM__c = UOM;

        psfList.add(psf3);

        upsert psfList;

        Rolling_Product_Sales_Info.upsertRPSI_PSF(psfList,'2010012');
        Rolling_Product_Sales_Info.upsertRPSI_PSP(psps,'2012012');

        List<SelectOption> listSelectOptions = new List<SelectOption>();
        listSelectOptions.add(new SelectOption('1','1'));
        listSelectOptions.add(new SelectOption('2','2'));

        Rolling_Product_Sales_Info.getSelectOption(listSelectOptions,'1');
        Rolling_Product_Sales_Info.getSelectOption(listSelectOptions,'3');

        Rolling_Product_Sales_Info.getString(1.0,1);
        Rolling_Product_Sales_Info.getString(1.0);

        Rolling_Product_Sales_Info.getFieldName('1','2');

        Rolling_Product_Sales_Info.getDoubleValue(rpsi,'CM','2010012');

        Rolling_Product_Sales_Info.getField(rpsi,'CM','2010012');

        Rolling_Product_Sales_Info.getVariance(rpsi,'CM','2010012','2010012');
        
        Rolling_Product_Sales_Info.getPFYF_EndDate();
        
        Rolling_Product_Sales_Info.getMonthsBetween('test1','test2');
        Rolling_Product_Sales_Info.getFieldName('rps','time');

    }
}