@isTest
private class ReorderController_Test {

    static SAP_Sales_Org__c so;
    static SAP_Distribution_Channel__c dc;
    static Account shipTo, soldTo, cHerky, invalidAcc;
    static Set<String> accountIds;
    static Material_Sales_Data2__c msd2;
    static Open_Orders__c openOrder;
    static Material_Plant_Leadtime__c mpl;
    static String matnum = '010000000123456789';
    static String salesOrg = '1234';
    static String distChan = '12';
    static String salesArea = '00000000';
    static String plantCode = '1234';
    static String familycode = '123';
    static String langCode = 'E';
    static String salesOrderNumber = 'TestOrder1';
    static String lineItemNumber = '000';

    static void createTestData() {
        createAccounts();
        createMaterial();
        createOpenOrder();
        
    }

    static void createAccounts() {
//insert lead time
                                             mpl=new Material_Plant_Leadtime__c();
                                             mpl.Family_Name__c='123';
                                             mpl.Plant__c='1234';
                                             mpl.Standard_Lead_Time__c=11;
                                             mpl.Deletion_Indicator__c='Y';
        mpl.Sales_Org__c=salesOrg;
        mpl.Material_Number__c=matnum;
                                       
                                             insert mpl;
        update mpl;
        so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = salesOrg;
        so.Language_Code__c = langCode;
        insert so;

        dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = distChan;
        dc.Language_Code__c = langCode;
        insert dc;

        cHerky = new Account(Name = 'CHerky');
        cHerky.Account_Number__c = 'CHerky';
        insert cHerky;

        soldTo = new Account(Name = 'SoldTo');
        soldTo.Account_Number__c = 'SoldTo';
        soldTo.ParentId = cHerky.Id;
        insert soldTo;

        shipTo = new Account(Name = 'ShipTo');
        shipTo.Account_Number__c = 'ShipTo';
        shipTo.SAP_DistChannel__c = dc.Distribution_Channel_Code__c;
        shipTo.SAP_Sales_Org__c = so.Sales_Org_Code__c;
        insert shipTo;

        invalidAcc = new Account(Name = 'invalidAcc');
        invalidAcc.Account_Number__c = 'invalidAcc';
        insert invalidAcc;

        accountIds = new Set<String>{cHerky.Id, soldTo.Id, shipTo.Id};

    }

    static void createMaterial() {
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plantCode;
        insert sp;

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        msd2 = getTestMsd2(mgd2, sp);
        system.debug('NNN'+msd2.PH5__c);
    }

    static Material_Sales_Data2__c getTestMsd2(Material_General_Data2__c mgd2,
                                               SAP_Plant__c sp) {

        Material_Plant2__c mp2 = getTestMp2(mgd2, sp);
        //Product_Hierarchy2__c ph2 = getTestProdHerky2();
                                                     Product_Hierarchy2__c ph5 = getTestProdHerky2();
                                                   
        msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
//msd2.Material_Number__c = '000000000000';
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.PH5_Family_Code__c=familycode;                                          
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
        msd2.SalesOrg_Code__r = so;
        msd2.DistChannel_Code__r = dc;
        msd2.Material_General_Data__r = mgd2;
        //msd2.Product_Hierarchy__r = ph2;
         msd2.Product_Hierarchy__r = ph5;
                                                   
       // msd2.Net_Weight__c = 10.00;
        //msd2.Net_Weight_in_LBs__c=12.00;
        insert msd2;
                                                   system.debug('TTTT'+msd2.Product_Hierarchy__r);
                                                    system.debug('TTTT4'+msd2.Product_Hierarchy__r.PH4__c);
                                                    system.debug('TTTT5'+msd2.Product_Hierarchy__r.PH5__c);
            Material_Sales_Data2__c msd3=[select id,Material_Number__c,PH5__c,Sales_Org_Code__c,PH5_Family_Code__c,Product_Hierarchy__r.PH5__c
                                          ,Dist_Channel_Code__c,Record_Key__c,SalesOrg_Code__c,DistChannel_Code__c
                                          ,Material_General_Data__c,Product_Hierarchy__c
                                          from Material_Sales_Data2__c where id=:msd2.Id];
                                                   update msd3;
                                                   system.debug('SIZE6'+msd3);
                                                   system.debug('SIZE7'+msd3.Product_Hierarchy__r.PH5__c);
                                                   
        return msd3;
    }

    static Material_Plant2__c getTestMp2(Material_General_Data2__c mgd2,
                                         SAP_Plant__c sp) {
        Material_Plant2__c mp2 = new Material_Plant2__c();
        mp2.Material_Number__c = matnum;
        mp2.Plant_Code__c = plantCode;                                   
        mp2.SalesOrg_Code__c = salesOrg;
        mp2.Record_Key__c = matnum + plantCode + salesOrg;
        mp2.Material_General_Data__r = mgd2;
        mp2.SAP_Plant__r = sp;
        mp2.SAP_Sales_Org__r = so;
        insert mp2;
                                             
        return mp2;
    }

    static Product_Hierarchy2__c getTestProdHerky2() {
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = 'E';
        ph1.Product_Hierarchy_Code__c = '!';
        // ph6.Product_Hierarchy_Code__c='I18000000123112000';
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = 'E';
        ph2.Product_Hierarchy_Code__c = '!@#';
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = 'E';
        ph3.Product_Hierarchy_Code__c = '!@#$%^';
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = 'E';
        ph4.Product_Hierarchy_Code__c = '!@#$%^&*(';
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = 'E';
        ph5.Product_Hierarchy_Code__c = '!@#$%^&*()!@';
       // ph5.Product_Hierarchy_Code__c='I18000000123112000';
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = 'E';
        ph6.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%';
       // ph6.Product_Hierarchy_Code__c='I18000000123112000';
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = 'E';
        ph7.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%^&*';
        
        insert ph7;

        Product_Hierarchy2__c pherky2 = new Product_Hierarchy2__c();
        pherky2.Product_Hierarchy__c = 'I18000000123112000';
        pherky2.Product_Hierarchy1__r = ph1;
        pherky2.Product_Hierarchy2__r = ph2;
        pherky2.Product_Hierarchy3__r = ph3;
        pherky2.Product_Hierarchy4__r = ph4;
        pherky2.Product_Hierarchy5__r = ph5;
        pherky2.Product_Hierarchy6__r = ph6;
        pherky2.Product_Hierarchy7__r = ph7;
        
        
       
        insert pherky2;
        Product_Hierarchy2__c pherky3=[select PH5__c,PH4__c,Product_Hierarchy1__r.Language_Code__c,Product_Hierarchy1__r.Product_Hierarchy_Code__c
                                      ,Product_Hierarchy2__r.Language_Code__c,Product_Hierarchy2__r.Product_Hierarchy_Code__c
                                       ,Product_Hierarchy3__r.Language_Code__c,Product_Hierarchy3__r.Product_Hierarchy_Code__c
                                       ,Product_Hierarchy4__r.Language_Code__c,Product_Hierarchy4__r.Product_Hierarchy_Code__c
                                       ,Product_Hierarchy5__r.Language_Code__c,Product_Hierarchy5__r.Product_Hierarchy_Code__c
                                        ,Product_Hierarchy6__r.Language_Code__c,Product_Hierarchy6__r.Product_Hierarchy_Code__c
                                        ,Product_Hierarchy7__r.Language_Code__c,Product_Hierarchy7__r.Product_Hierarchy_Code__c
                                       from Product_Hierarchy2__c where id=:pherky2.Id];
       // update pherky2;
         system.debug('TTT000'+pherky2.Product_Hierarchy__c);
        system.debug('TTT111'+pherky3.PH5__c);
        return pherky3;
    }

    static void createOpenOrder() {
        openOrder = new Open_Orders__c();
        openOrder.ShipTo__c = shipTo.Id;
        openOrder.SoldTo__c = soldTo.Id;
        openOrder.Sales_Order_Number__c = salesOrderNumber;
        openOrder.Line_Item_Number__c = lineItemNumber;
        openOrder.Key__c = salesOrderNumber + lineItemNumber;
        openOrder.Material__r = msd2;
       
        insert openOrder;
    }

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
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

        Test.startTest();
        createTestData();

        ApexPages.StandardController sc;
        ApexPages.currentPage().getParameters().put('Id', openOrder.Id);

        ReorderController c = new ReorderController(sc);

        Reorder_Line_Item__c li = new Reorder_Line_Item__c(Quantity__c = 11);
        li.Material2__r = msd2;
        insert li;
        c.newRecMat = li;
        c.addMat();

        //c.OnPlantChange();

        c.delMat();
        c.delReorder();
        c.saveReorders();
        c.updateOrderType();

    }

    static testMethod void test02() {
    System.debug('test02');

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
        createTestData();

        //Test if accessed from account page
        ApexPages.StandardController sc;
        ApexPages.currentPage().getParameters().put('AccountId', openOrder.ShipTo__c);
        ApexPages.currentPage().getParameters().put('hasOrders', 'false');

        ReorderController c = new ReorderController(sc);
        PageReference pg1 = c.callReorderPage();
        PageReference pg2 = c.callIntermediatePage();
        c.SortField = 'Id'; c.SortMasterList(); c.saveReorders();
        c.OnPlantChange();c.ValidateReqDeliveryDate();c.ValidateEstShipDate();
        c.gotoAccountPage();

        Reorder_Line_Item__c li = new Reorder_Line_Item__c(Quantity__c = 11);
        c.accountId = shipTo.Id; c.materialName = msd2.Material_Number__c;
        c.newRecMat = li; c.addMat(); c.addReorder(); c.saveReorders();
    }

}