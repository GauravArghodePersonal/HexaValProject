@isTest
public class SolenisMSDTestclass {
  static Account acc;
    static List<Open_Orders__c> openOrders;
    static List<Material_Sales_Data2__c> mats;
    static String salesOrg1 = '1020';
    static String distChan1 = '50';
    static List<String> matNums = new List<String>{'mat1', 'mat2'};
        
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

    
    //Create Account
     public static Account shipTo, soldTo, corporateAccount, ultimateAccount;
    public static SAP_ECOM_Customer__c sapECOMCustomer;
    static String so = '1234';
    static String dc = '12';
    static String dv = '12';
     static Account createAccount(String accountNumber) {
        Account a = new Account();
        a.Name = accountNumber;
        a.AccountNumber = accountNumber;
        a.Account_Number__c = accountNumber + so + dc + dv;
         a.SAP_Sales_Org_Region_value1__c='NA';
         a.SAP_Customer_Number__c='1233';
         a.SAP_Sales_Org__c='1020';
        insert a;
        return a;
    }
    
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
    
    
     public static testMethod void testMaterial() {
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
        
        Material_General_Data__c mgd = getMatGenData(matnumbr);
        List<Material_General_Data__c> mgda = new List<Material_General_Data__c>{mgd};
        Material_General_Data_Functions.upsert_Material_General_Data2(mgda);
        Material_Sales_Data__c msd = getMatSalesData(matnumbr, salesOrg, distChan);
        List<Material_Sales_Data__c> msda = new List<Material_Sales_Data__c>{msd};
       // Material_Sales_Data_Functions.upsert_Material_Sales_Data2(msda);

       // Material_Sales_Data_Functions.getMaterialSalesData2s(new Set<Id>{msd2.id});
        List<Material_Sales_Data2__c> msd2s = new List<Material_Sales_Data2__c>{msd2};
        Set<id> msd2Ids = new Set<id>{msd2.Id};

       // Group g = new Group(Name='Test');  insert g;
       // Material_Sales_Data_Functions.createSharingRecords(new List<Material_Sales_Data2__c>{msd2});
      //  Material_Sales_Data_Functions.getMsd2share(msd2.id,g.id,'Read','Test');
      //  SAP_Material_Queries.getMaterialUoms(msd2.Id);
      //  Material_Sales_Data_Functions.getAltUOMs(msd2.Id);
      //  Material_Sales_Data_Functions.getAltUOMs(msd2);
      //  Material_Sales_Data_Functions.getMaterialSalesData2Map(msd2Ids);
      //  Material_Sales_Data_Functions.getPlants(msd2);
       // Material_Sales_Data_Functions.getPlants(msd2.Id);
       // SAP_Material_Queries.getMaterialPlants(matnumbr, salesOrg, distChan);
       // Material_Sales_Data_Functions.getPlantsMap(msd2s);
       // Material_Sales_Data_Functions.getMaterialPlantMap(msd2Ids);

       // Map<Id, String> mfdmap = new Map<Id, String>();
      //  mfdmap.put(msd2.Material_General_Data__c, 'X');
      //  Material_Sales_Data_Functions.updateDeletionFlag(mfdmap);
        
        // ultimateAccount = createAccount('ultimate');

      //  corporateAccount = createAccount('corporate');
      //  corporateAccount.ParentId = ultimateAccount.Id;
      //  update corporateAccount;

        
        soldTo = createAccount('soldTo');
       // soldTo.ParentId = corporateAccount.Id;
       // update soldTo;

        shipTo = createAccount('shipTo');
      //  shipTo.ParentId = soldTo.Id;
       // update shipTo;
        String accountsoldto=soldTo.Id;
      String accountShipto=shipTo.Id;
        
        //insert Pricing Material
        Pricing_Material__c prm=new Pricing_Material__c();
        prm.Pricing_Table__c='640';
       // prm.CustomerSalesOrg__c='1020';
        prm.BaseCode__c='E1';
        prm.Material_Number__c='010000000123456789';
        prm.Sales_Org_Code__c='1020';
        prm.Customer_Number__c='1233';
        prm.Valid_From__c=Date.newInstance(2016, 12, 9);
            prm.Valid_To__c=Date.newInstance(2022, 12, 9);
        insert prm;
          Pricing_Material__c prm1=new Pricing_Material__c();
        prm1.Pricing_Table__c='641';
       // prm.CustomerSalesOrg__c='1020';
        prm1.BaseCode__c='E1';
        prm1.Material_Number__c='010000000123456789';
        prm1.Sales_Org_Code__c='1020';
        prm1.Customer_Number__c='1233';
        prm1.Valid_From__c=Date.newInstance(2016, 12, 9);
            prm1.Valid_To__c=Date.newInstance(2022, 12, 9);
        insert prm1;
        
                  Pricing_Material__c prm2=new Pricing_Material__c();
        prm2.Pricing_Table__c='962';
       // prm.CustomerSalesOrg__c='1020';
        prm2.BaseCode__c='E1';
        prm2.Material_Number__c='010000000123456789';
        prm2.Sales_Org_Code__c='1020';
        prm2.Customer_Number__c='1233';
        prm2.Valid_From__c=Date.newInstance(2016, 12, 9);
            prm2.Valid_To__c=Date.newInstance(2022, 12, 9);
        insert prm2;
        
       // solenisReorderController src=solenisReorderController();
     //  solenisReorderController.querymaterialwithAPI(accountsoldto,'000',accountsoldto);
       //   solenisReorderController.querymaterialwithAPI(accountsoldto,'000',accountShipto);
     //  solenisReorderController.querymaterialwithAPI(accountsoldto,'HER',accountsoldto);
      //     solenisReorderController.querymaterialwithAPI(accountsoldto,'HER',accountShipto);
     //   solenisReorderController.querymaterialwithAPI(accountsoldto,'000',accountShipto);
       solenisReorderController.querymaterialwithAPI_All(accountsoldto,'000',accountShipto);
           solenisReorderController.querymaterialwithAPI_All(accountsoldto,'000',accountsoldto);
          solenisReorderController.querymaterialwithAPI_All(accountsoldto,'000',accountShipto);
       solenisReorderController.querymaterialwithAPI_All(accountsoldto,'HER',accountsoldto);
           solenisReorderController.querymaterialwithAPI_All(accountsoldto,'HER',accountShipto);
        solenisReorderController.querymaterialwithAPI_All(accountsoldto,'000',accountShipto);
        String idmsd=msd2.Id;
      solenisReorderController.materialPlantDetail(idmsd,'123','123');
        List<string> lstring=new List<string>();        
        solenisReorderController.getSelectedMaterial(lstring);
        solenisReorderController.getLeadTme(idmsd,'plant');
        solenisReorderController.OpenOrdersDetail(accountsoldto);
        solenisReorderController.querymaterial(accountsoldto,'123');
        // insert Open order
       //    acc = new Account(Name='testAcc');
       // insert acc;

      //  mats = Material_Sales_Data_Functions_Test.getTestMsd2s(salesOrg, distChan, matNums);

           solenisReorderController.materialPlantDetail(idmsd,'123','123');
       // List<string> lstring=new List<string>();        
      /*  solenisReorderController.getSelectedMaterial(lstring);
       solenisReorderController.OpenOrdersDetail(accountsoldto);
        solenisReorderController.querymaterial(accountsoldto,'123');
        solenisReorderController.AcconutDetail(lstring);
        solenisReorderController.MaterialListWrapper nn = new solenisReorderController.MaterialListWrapper();
        nn.materialId=msd2.Id;
        nn.leadTime=10;
        nn.MaterialNumber='123';
        nn.msId=msd2.Id;
        nn.plant='';
        nn.TankNumber='123';
        nn.UMO='123';*/
         
         Solenis_MSD s=new Solenis_MSD(String.valueOf(msd2.Id), true);
       //  Solenis_MSD.Solenis_MSD(oppid, filterValue);         
    
      //  solenisReorderController.orderSummary(m);
        Test.stopTest();
    }
    
}