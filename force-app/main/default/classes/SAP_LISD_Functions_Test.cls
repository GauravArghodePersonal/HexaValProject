@isTest
private class SAP_LISD_Functions_Test {

    static Account acc, euc;
    static SAP_Line_Item_Sales_Detail__c slisd;
    static SAP_LISD sapLisd;
    static SAP_Seller__c ss;
    static String userId = UserInfo.getUserId();
    static String sellerNum = '0000123456';
    static String accNum = '0000123456';
    static String eucNum = '0000234567';
    static String salesOrg = '1234';
    static String distChan = '12';
    static String divsn = '12';
    static String industry = 'Industry';
    static String subInd = 'SubInd';
    static String salesDst = '12345';
    static String salesOfc = '1234';
    static String salesGrp = '123';
    static String custGrp = '12';
    static String KNA1_RT_ID = SAP_LISD_Functions.KNA1_RT_ID;

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }

    static void createTestData() {
/*
        usr = TestObjects.newUser();
        usr.ProfileId = [SELECT Id FROM Profile Where Name = 'System Administrator'].Id;
        update usr;
*/
        ss = new SAP_Seller__c(Name=sellerNum,User__c=userId);
        insert ss;

        acc = new Account(Name='Test Account',OwnerId=userId);
        acc.AccountNumber = accNum;
        acc.SAP_Sales_Org__c = salesOrg;
        acc.SAP_DistChannel__c = distChan;
        acc.SAP_DivisionCode__c = divsn;
        acc.SAP_Customer_Group__c = custGrp;
        acc.SAP_Customer_Group_Desc__c = custGrp;
        acc.SAP_SalesDistrict__c = salesDst;
        acc.SAP_Sales_Office__c = salesOfc;
        acc.SAP_SalesGroup__c = salesGrp;
        acc.Account_Number__c = accNum + salesOrg + distChan + divsn;
        insert acc;

        euc = new Account(Name='EndUseCust',OwnerId=userId);
        euc.AccountNumber = eucNum;
        euc.RecordTypeId = KNA1_RT_ID;
        insert euc;

        SAP_L1_Segment__c l1 = new SAP_L1_Segment__c();
        l1.Customer_Group__c = custGrp;
        l1.Dist_Channel__c = distChan;
        l1.Industry_Name__c = industry;
        l1.L1_Segment__c = industry;
        l1.Key__c = distChan + industry;
        insert l1;

        SAP_L2_Segment__c l2 = new SAP_L2_Segment__c();
        l2.Dist_Channel__c = distChan;
        l2.L1_Segment__c = industry;
        l2.L2_Segment__c = subInd;
        l2.Sub_Industry_Name__c = subInd;
        l2.Key__c = distChan + industry + subInd;
        insert l2;

        SAP_Sales_District__c sd = new SAP_Sales_District__c();
        sd.Language_Code__c = 'EN';
        sd.Sales_District_Code__c = salesDst;
        sd.Sales_District_Name__c = 'Sales Dist';
        insert sd;

        SAP_Sales_Office__c so = new SAP_Sales_Office__c();
        so.Language_Code__c = 'EN';
        so.Sales_Office_Code__c = salesOfc;
        so.Sales_Office_Name__c = 'Sales Office';
        insert so;

        SAP_Sales_Group__c sg = new SAP_Sales_Group__c();
        sg.Language_Code__c = 'EN';
        sg.Sales_Group_Code__c = salesGrp;
        sg.Sales_Group_Name__c = 'Sales Group';
        insert sg;

        SAP_Customer_Group__c cg = new SAP_Customer_Group__c();
        cg.Language_Code__c = 'EN';
        cg.Customer_Group_Code__c = custGrp;
        cg.Customer_Group_Name__c = 'Cust Group';
        insert cg;

        slisd = new SAP_Line_Item_Sales_Detail__c();
        slisd.Customer_Group__c = custGrp;
        slisd.Dist_Channel__c = distChan;
        slisd.Division__c = divsn;
        slisd.L1_Segment__c = industry;
        slisd.EndUseCust_Number__c = eucNum;
        slisd.Sales_District__c = salesDst;
        slisd.Sales_Group__c = salesGrp;
        slisd.Sales_Office__c = salesOfc;
        slisd.Sales_Org__c = salesOrg;
        slisd.Seller_Number__c = sellerNum;
        slisd.ShipTo_Number__c = accNum;
        slisd.Key__c = salesOrg + distChan + divsn + accNum + eucNum;
        insert slisd;

        sapLisd = new SAP_LISD();
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

        createTestData();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(slisd);
        SAP_LISD_Controller c = new SAP_LISD_Controller(sc);
        c.con.AccountId = acc.Id; c.setShowLisds(true);
        c.setEnableAcc(null); c.setSapLisd(null);
    }

    static testMethod void test02() {
        
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

        createTestData();
        SAP_LISD_Services.getSapLisds(acc.Id);
    }
}