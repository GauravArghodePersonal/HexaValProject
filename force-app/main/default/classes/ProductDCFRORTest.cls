@isTest
private class ProductDCFRORTest {

    static String lang     = 'E';
    static String ph1code  = '!';
    static String ph2code  = '!23';
    static String ph3code  = '!23456';
    static String ph4code  = '!23456789';
    static String ph5code  = '!23456789123';
    static String ph6code  = '!23456789123456';
    static String ph7code  = '!23456789123456789';
    static String matnumbr = '010000000123456789';
    static String plant    = '1234';
    static String salesOrg = '1234';
    static String distChan = '10';
    static String matgrp1  = 'MG1';
    static String matgrp2  = 'MG2';
    static String salesUom = 'LB';
    static String matname  = 'TestMaterial';
    static List<String> matUoms = new List<String>{'LB', 'KG'};
    static SAP_Sales_Org__c s_so;
    static SAP_Distribution_Channel__c s_dc;
    static Product_Hierarchy2__c s_ph2;
    static Material_Pricing_Group1__c s_mg1;
    static Material_Pricing_Group2__c s_mg2;
    static SAP_Valuation_Area__c s_va;
    static SAP_Plant__c s_sp;

    private static void setup1() {
        s_so = getSalesOrg(salesOrg);
        s_dc = getDistChan(distChan);
        s_ph2 = getTestProdHerky2();
        s_mg1 = getMG1(matgrp1);
        s_mg2 = getMG2(matgrp2);
        s_va = getValuationArea(salesOrg, plant);
        s_sp = getPlant(plant);
    }
    
    private static Material_Sales_Data2__c getMsd2(String matnum) {
        Material_Description__c mdesc = getMatDesc(matnum);
        Material_General_Data2__c mgd2 = getMatGenData2(matnum);
        List<Material_UOM2__c> mu2s = getMatUom2s(matnum, matuoms);
        Material_Plant2__c mp2 = getTestMp2(mgd2, s_sp, s_so);
        Material_Valuation__c mv = getMatValuation(matnum, plant);

        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Material_Group1_Code__c = matgrp1;
        msd2.Material_Group2_Code__c = matgrp2;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
        msd2.SalesOrg_Code__c = s_so.Id;
        msd2.DistChannel_Code__c = s_dc.Id;
        msd2.Product_Hierarchy__c = s_ph2.Id;

        msd2.Material_General_Data__c = mgd2.Id;
        msd2.Sales_UOM__c = mu2s[0].Id; 
        return msd2;        
    }

    public static List<Material_Sales_Data2__c> getTestMsd2s(
        String sorg, String dchan, List<String> mnums) {
        salesOrg = sorg; distChan = dchan; setup1();
        List<Material_Sales_Data2__c> msd2s = new List<Material_Sales_Data2__c>();
        for (String mnum : mnums) {msd2s.add(getMsd2(mnum));}
        insert msd2s; return msd2s;
    }
    
    public static Material_Sales_Data2__c getTestMsd2() {
        setup1(); Material_Sales_Data2__c msd2 = getMsd2(matnumbr);
        insert msd2; return msd2;
    }

    private static Product_Hierarchy2__c getTestProdHerky2() {
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
        return pherky2;
    }

    private static Material_Plant2__c getTestMp2(Material_General_Data2__c mgd2,
                                                 SAP_Plant__c sp,
                                                 SAP_Sales_Org__c so) {
        Material_Plant2__c mp2 = new Material_Plant2__c();
        mp2.Material_Number__c = mgd2.Material_Number__c;
        mp2.Plant_Code__c = sp.Plant_Code__c;
        mp2.SalesOrg_Code__c = so.Sales_Org_Code__c;
        mp2.Record_Key__c = mp2.Material_Number__c + mp2.Plant_Code__c + mp2.SalesOrg_Code__c;
        mp2.Material_General_Data__c = mgd2.Id;
        mp2.SAP_Plant__c = sp.Id;
        mp2.SAP_Sales_Org__c = so.Id;
        insert mp2;
        return mp2;
    }
    
    private static SAP_Sales_Org__c getSalesOrg(String sorg) {
        SAP_Sales_Org__c so = null;
        try {
            so = new SAP_Sales_Org__c();
            so.Sales_Org_Code__c = sorg;
            so.Language_Code__c = lang;
            insert so;
        } catch(Exception e) {}
        return so;
    }
    
    private static SAP_Distribution_Channel__c getDistChan(String dchan) {
        SAP_Distribution_Channel__c dc = null;
        try {
            dc = new SAP_Distribution_Channel__c();
            dc.Distribution_Channel_Code__c = dchan;
            dc.Language_Code__c = lang;
            insert dc;
        } catch(Exception e) {}
        return dc;
    }
    
    private static Material_Description__c getMatDesc(String matnum) {
        Material_Description__c md = null;
        try {
            md = new Material_Description__c();
            md.Language_Code__c = lang;
            md.Material_Number__c = matnum;
            md.Material_Description__c = matname + matnum;
            insert md;
        } catch(Exception e) {}
        return md;
    }
    
    private static Material_General_Data__c getMatGenData(String matnum) {
        Material_General_Data__c mgd = null;
        try {
            mgd = new Material_General_Data__c();
            mgd.Material_Number__c = matnum;
            insert mgd;
        } catch(Exception e) {}
        return mgd;
    }
    
    private static Material_General_Data2__c getMatGenData2(String matnum) {
        Material_General_Data2__c mgd2 = null;
        try {
            mgd2 = new Material_General_Data2__c();
            mgd2.Material_Number__c = matnum;
            insert mgd2;
        } catch(Exception e) {}
        return mgd2;
    }
    
    private static Material_Sales_Data__c getMatSalesData(String matnum, 
                                                          String sorg, 
                                                          String dchan) {
        Material_Sales_Data__c msd = null;
        String recKey = matnum + sorg + dchan;
        try {
            msd = new Material_Sales_Data__c();
            msd.Material_Number__c = matnum;
            msd.Sales_Org__c = sorg;
            msd.Distribution_Channel__c = dchan;
            msd.Material_Group1__c = 'MG1';
            msd.Material_Group2__c = 'MG2';
            msd.Record_Key__c = recKey;
            msd.Sales_Unit__c = 'LB';
            msd.Product_Hierarchy__c = ph7code;
            insert msd;
        } catch(Exception e) {}
        return msd;
    }
    
    private static List<Material_UOM2__c> getMatUom2s(String matnum, 
                                                      List<String> uoms) {
        List<Material_UOM2__c> mu2s = new List<Material_UOM2__c>();
        for (String s : uoms) {
            Material_UOM2__c mu2 = new Material_UOM2__c();
            mu2.Alternative_UOM__c = s;
            mu2.Material_Number__c = matnum;
            mu2.Record_Key__c = matnum + s;
            mu2.Denominator__c = 1; mu2.Numerator__c = 1;
            mu2s.add(mu2);
        }
        try {insert mu2s;} catch(Exception e) {}
        return mu2s;
    }
    
    private static Material_Pricing_Group1__c getMG1(String mg1) {
        Material_Pricing_Group1__c mg = new Material_Pricing_Group1__c();
        mg.Language_Code__c = lang;
        mg.Material_Pricing_Group1_Code__c = mg1;
        mg.Material_Pricing_Group1_Description__c = 'Test Material Group1';
        try {insert mg;} catch(Exception e) {}
        return mg;
    }
    
    private static Material_Pricing_Group2__c getMG2(String mg2) {
        Material_Pricing_Group2__c mg = new Material_Pricing_Group2__c();
        mg.Language_Code__c = lang;
        mg.Material_Pricing_Group2_Code__c = mg2;
        mg.Material_Pricing_Group2_Description__c = 'Test Material Group2';
        try {insert mg;} catch(Exception e) {}
        return mg;
    }
    
    private static SAP_Valuation_Area__c getValuationArea(String so, String pl) {
        SAP_Valuation_Area__c va = null;
        try {
            va = new SAP_Valuation_Area__c();
            va.Company_Code__c = so;
            va.Valuation_Area__c = pl;
            insert va;
        } catch(Exception e) {}
        return va;
    }
    
    private static SAP_Plant__c getPlant(String pl) {
        SAP_Plant__c sp = null;
        try {
            sp = new SAP_Plant__c();
            sp.Plant_Code__c = pl;
            insert sp;
        } catch(Exception e) {}
        return sp;
    }
    
    private static Material_Valuation__c getMatValuation(String matnum, String pl) {
        Material_Valuation__c mv = new Material_Valuation__c();
        mv.Material_Number__c = matnum;
        mv.Price_Control_Indicator__c = 'S';
        mv.Price_Unit__c = 100.0;
        mv.Record_Key__c = matnum + pl;
        mv.Standard_Price__c = 1234.56;
        mv.Valuation_Area__c = pl;
        try {insert mv;} catch(Exception e) {}
        return mv;
    }
    
    public static testMethod void test01() {
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


        Test.startTest();
        Material_Sales_Data2__c msd2 = getTestMsd2();
         GEER_Budget_Numbers__c sg=new GEER_Budget_Numbers__c();
        sg.Budget_number__c='121212';
            sg.Name='2021_Growth_NA_IWT';
          sg.Region__c='NA';
            sg.Project_type__c='Growth';
        insert sg;
        
            AFE_Call__c setting = new AFE_Call__c();
setting.Name = 'EMEA';
setting.Project_Manager_Emp_Num__c = '1234';
insert setting;
        
          AFE_Call__c setting1 = new AFE_Call__c();
setting1.Name = 'NA';
setting1.Project_Manager_Emp_Num__c = '1234';
insert setting1;
        
         AFE_Call__c setting2 = new AFE_Call__c();
setting2.Name = 'callFiori';
setting2.EndpointURL__c = '1234';
        setting2.Username__c = '1234';
        setting2.Password__c = '1234';
insert setting2;
        //Create Account
         Account Acc = TestDataFactory.createAccount(false);
             Acc.SAP_Sales_Org__c ='1020';
             Insert Acc;
        
        //Create GEER
        Geer__c gr = new Geer__c();
         gr.Fiscal_Year__c='2021';
        gr.Ship_To__c = acc.id;
        gr.Project_type1__c = 'Growth';
        gr.Prepared_By__c = '';
        gr.Budget_Number__c = '';
        gr.Origination_Type__c = '0';
        gr.Local_Currency_Total_Amount__c = 12;
        gr.Exchange_Rate__c = 11;
        gr.GEER_Description__c = 'Test';
        gr.State__c = 'VA';
        gr.Target_Mechanical_Completion_In_Months__c = 5;
        gr.Cost_Center__c = '';
        gr.Approval_Routing_Priority__c = 'Normal';
        gr.Project_Manager_Emp_Num__c = '';
        gr.Asset_Type__c ='Machinery and Equipment(6)';
        gr.Usage_Code__c = 'Sales Support(9)';
        gr.SFDC_Link_GEER__c = '';
        gr.Market_Vertical__c = 'Pulp(11)';
        gr.Equipment_Category__c = 'Polymer - Dry(54)';
        gr.Sales_Rep_Name__c = '';
        gr.SBU__c = 'Polymer - RDC(8)';
        gr.Est_Revenue_Generated__c = 2;
        gr.Est_Gross_Profit_Generated__c = 2;
        gr.Payback_in_Months__c = 4;
        gr.Justification__c = 'Trial for new business';
        insert gr;

        //Create GEER Stay in Business
        Geer__c gr1 = new Geer__c();
        gr1.Ship_To__c = acc.id;
         gr1.Fiscal_Year__c='2021';
        gr1.Project_type1__c = 'Growth';
        gr1.Prepared_By__c = '';
        gr1.Budget_Number__c = '';
        gr1.Origination_Type__c = '0';
        gr1.Local_Currency_Total_Amount__c = 12;
        gr1.Exchange_Rate__c = 11;
        gr1.GEER_Description__c = 'Test';
        gr1.State__c = 'VA';
        gr1.Target_Mechanical_Completion_In_Months__c = 5;
        gr1.Cost_Center__c = '';
        gr1.Approval_Routing_Priority__c = 'Normal';
        gr1.Project_Manager_Emp_Num__c = '';
        gr1.Asset_Type__c ='Machinery and Equipment(6)';
        gr1.Usage_Code__c = 'Sales Support(9)';
        gr1.SFDC_Link_GEER__c = '';
        gr1.Market_Vertical__c = 'Pulp(11)';
        gr1.Equipment_Category__c = 'Polymer - Dry(54)';
        gr1.Sales_Rep_Name__c = '';
        gr1.SBU__c = 'Polymer - RDC(8)';
        gr1.Est_Revenue_Generated__c = 2;
        gr1.Est_Gross_Profit_Generated__c = 2;
        gr1.Payback_in_Months__c = 4;
        gr1.Justification__c = 'Trial for new business';
        insert gr1;
		
        //Create GEER Compliance
        Geer__c gr2 = new Geer__c();
        gr2.Ship_To__c = acc.id;
        gr2.Fiscal_Year__c='2021';
        gr2.Project_type1__c = 'Growth';
        gr2.Prepared_By__c = '';
        gr2.Budget_Number__c = '';
        gr2.Origination_Type__c = '0';
        gr2.Local_Currency_Total_Amount__c = 12;
        gr2.Exchange_Rate__c = 11;
        gr2.GEER_Description__c = 'Test';
        gr2.State__c = 'VA';
        gr2.Target_Mechanical_Completion_In_Months__c = 5;
        gr2.Cost_Center__c = '';
        gr2.Approval_Routing_Priority__c = 'Normal';
        gr2.Project_Manager_Emp_Num__c = '';
        gr2.Asset_Type__c ='Machinery and Equipment(6)';
        gr2.Usage_Code__c = 'Sales Support(9)';
        gr2.SFDC_Link_GEER__c = '';
        gr2.Market_Vertical__c = 'Pulp(11)';
        gr2.Equipment_Category__c = 'Polymer - Dry(54)';
        gr2.Sales_Rep_Name__c = '';
        gr2.SBU__c = 'Polymer - RDC(8)';
        gr2.Est_Revenue_Generated__c = 2;
        gr2.Est_Gross_Profit_Generated__c = 2;
        gr2.Payback_in_Months__c = 4;
        gr2.Justification__c = 'Trial for new business';
        insert gr2;
        
        //Create GEER E-Pool
        Geer__c gr3 = new Geer__c();
        gr3.Ship_To__c = acc.id;
        gr3.Fiscal_Year__c='2021';
        gr3.Project_type1__c = 'Growth';
        gr3.Prepared_By__c = '';
        gr3.Budget_Number__c = '';
        gr3.Origination_Type__c = '0';
        gr3.Local_Currency_Total_Amount__c = 12;
        gr3.Exchange_Rate__c = 11;
        gr3.GEER_Description__c = 'Test';
        gr3.State__c = 'VA';
        gr3.Target_Mechanical_Completion_In_Months__c = 5;
        gr3.Cost_Center__c = '';
        gr3.Approval_Routing_Priority__c = 'Normal';
        gr3.Project_Manager_Emp_Num__c = '';
        gr3.Asset_Type__c ='Machinery and Equipment(6)';
        gr3.Usage_Code__c = 'Sales Support(9)';
        gr3.SFDC_Link_GEER__c = '';
        gr3.Market_Vertical__c = 'Pulp(11)';
        gr3.Equipment_Category__c = 'Polymer - Dry(54)';
        gr3.Sales_Rep_Name__c = '';
        gr3.SBU__c = 'Polymer - RDC(8)';
        gr3.Est_Revenue_Generated__c = 2;
        gr3.Est_Gross_Profit_Generated__c = 2;
        gr3.Payback_in_Months__c = 4;
        gr3.Justification__c = 'Trial for new business';
        insert gr3;
        List<Geer__c> grlist=new List<Geer__c>();
        grlist.add(gr1);
        grlist.add(gr2);
         grlist.add(gr3);
        Map<Id,Geer__c> oldMap=new Map<Id,Geer__c>();
            oldMap.put(gr1.Id, gr1);
           Map<Id,Geer__c> NewMap=new Map<Id,Geer__c>();
            NewMap.put(gr1.Id, gr1);
        DCFROR_Project_Management_AdderPercent__c dpm=new DCFROR_Project_Management_AdderPercent__c();
        dpm.AdderPercent__c=10;
        dpm.Name='NA';
        insert dpm;
        
        DCFROR__c df=new DCFROR__c();
        df.GEER__c=gr1.Id;
        insert df;
        List<DCFROR__c> dlist=new List<DCFROR__c>();
        dlist.add(df);
     
        DCFRORTriggerOperations.processBeforeInsert(dlist);
        GEERTriggerOperations.processBeforeUpdate(grlist, oldMap, NewMap);
        Product_DCFROR__c cp=new Product_DCFROR__c();
   //cp.Actual_Chemical_Revenue__c=1;
       cp.Actual_Chemical_Sell_Price__c=1;
       cp.Actual_Equipment_Upcharge__c=1;
   //    cp.Actual_Equipment_Upcharge_Revenue__c=1;
       cp.DCFROR__c=df.id;
       cp.Estimated_Gross_Margin__c=1;
       cp.Expected_Annual_Volume__c=1;
       cp.Material_Sales_Data2__c=msd2.Id;
       cp.Product_Type__c='New Deal-Growth';
        insert cp;
        Test.stopTest();
    }}