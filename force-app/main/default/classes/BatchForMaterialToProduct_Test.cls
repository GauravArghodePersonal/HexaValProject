@isTest
public class BatchForMaterialToProduct_Test {
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
    static String salesOrg = '0100';
    static String distChan = '10';
    static String matgrp1  = 'MG1';
    static String matgrp2  = 'MG2';
    static String salesUom = 'LB';
    static String matname  = 'TestMaterial';

    @isTest
    public static void testBatch(){
 		Test.startTest();
        ProductCatalog pcatalog = new ProductCatalog();
        pcatalog.Name = 'Solenis Eshop Catalog';
        insert pcatalog;
        
        ProductCategory pcategory = new ProductCategory();
        pcategory.Name = '123';
        pcategory.Brand_Code__c = '123';
        pcategory.catalogId = pcatalog.Id;
        insert pcategory;

        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();        
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = 'Test';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        pfxCustomList.add(p1);
        insert pfxCustomList;

        Material_General_Data2__c mgd2 = getMatGenData2(matnumbr);

        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnumbr;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Material_General_Data__c = mgd2.Id;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Material_Group1_Code__c = 'MG1';
        msd2.Material_Group2_Code__c = 'MG2';
        msd2.Sales_Unit__c = 'LB';
        msd2.Record_Key__c = matnumbr + salesOrg + distChan;
        msd2.SalesOrg_Code__c = getSalesOrg(salesOrg).Id;
        msd2.DistChannel_Code__c = getDistChan('1o').Id;
        msd2.Product_Hierarchy__c = getTestProdHerky2().Id;
        msd2.Material_Group4_Code__c = '123';
        msd2.Material_Group4_Desc__c = '123';

        // msd2.Material_General_Data__c = getMatGenData2(matnumbr).Id;
        msd2.Sales_UOM__c = getMatUom2s(matnumbr, new List<String>{'LB', 'KG'})[0].Id; 
        insert msd2;
       
        Database.executeBatch(new BatchForMaterialToProduct());
        Database.executeBatch(new BatchToCreateCategories());
        //Database.executeBatch(new BatchToCreateCategoriesNewOneTimeRun());
        BatchForMaterialToProduct.test_1();
        BatchToCreateCategories.test_1();
        
        BatchToCreateCategoriesNewOneTimeRun obj = new BatchToCreateCategoriesNewOneTimeRun();
        DataBase.executeBatch(obj); 
       /* delete pcatalog;
        
                Database.executeBatch(new BatchForMaterialToProduct());
        Database.executeBatch(new BatchToCreateCategories());*/
        Test.stopTest();
        
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
    private static Material_General_Data2__c getMatGenData2(String matnum) {
        Material_General_Data2__c mgd2 = null;
        try {
            mgd2 = new Material_General_Data2__c();
            mgd2.Material_Number__c = matnum;
            mgd2.Old_Material_Number__c = '456789';
            insert mgd2;
        } catch(Exception e) {}
        return mgd2;
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
}