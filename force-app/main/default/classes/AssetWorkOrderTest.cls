@isTest
private class AssetWorkOrderTest {

    static Account                          acc1, plant1;
    static Asset                            asset1;
    static Asset_Work_Order__c              awordr;
    static Asset_Work_Order_Config__c       awocnfg;
    static Asset_Work_Order_Detail__c       awodtl;
    static List<Asset_Work_Order_Detail__c> awodtls;
    static Product2                         equip1;
    static User                             usr;
    static String                           salesgrp = '412';
    static String                           awopage = '/apex/AssetWorkOrderPage1';
    static AssetWorkOrderController         c;
    static PageReference                    pr;
    
    static void createTestData() {
        usr = TestObjects.newUser();
        usr.ProfileId = [SELECT Id FROM Profile Where Name = 'System Administrator'].Id;
        update usr;
        
        //usr = [select Id, Name, Email from User 
        //        where UserName = 'sysadmin@cisproduction.com'];

        acc1   = new Account(Name='Test Asset Account1');
        acc1.SAP_SalesGroup__c = salesgrp;
        List<Account> accs = new List<Account>{acc1};
        insert accs;
        
        equip1 = new Product2(Name='Test Asset Equipment1');
        insert equip1;
        
        asset1 = new Asset(Name='Test Asset 1', AccountId=acc1.Id, Product2Id=equip1.Id);
        insert asset1;
        
        awocnfg = new Asset_Work_Order_Config__c();
        awocnfg.Approval_Email1__c = usr.Email;
        awocnfg.Approver1__c = usr.Id; awocnfg.Approver2__c = usr.Id;
        awocnfg.Key__c = '001';
        awocnfg.Sales_Groups__c = salesgrp;
        insert awocnfg;

        awordr = new Asset_Work_Order__c();
        awordr.Account__c = acc1.Id;
        awordr.Type_of_Service__c = 'Pick up Loaned Equipment';
        insert awordr;
        
        awodtls = new List<Asset_Work_Order_Detail__c>();
        awodtl = new Asset_Work_Order_Detail__c();
        awodtl.Asset__c = asset1.Id;
        awodtl.Asset_Work_Order__c = awordr.Id;
        insert awodtl;
        awodtls.add(awodtl);

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
        pr = new PageReference(awopage + '?accountId=' + acc1.Id);
        Test.setCurrentPageReference(pr);
        c = new AssetWorkOrderController();
        c.onServiceTypeChange(); c.selectLoanedAssets();
        c.addSelectedAssets(); c.saveWorkOrder();
    }

//*
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
        ApexPages.StandardController sc = new ApexPages.StandardController(awordr);
        c = new AssetWorkOrderController(sc);
        c.addAndGoback(); 
        c.cancelWorkOrder(); c.confirmAction(); 
        c.confirmCancelWorkOrder(); c.confirmSubmitWorkOrder();
        c.createPdf(); c.deleteSelectedAssets(); c.editWorkOrder();
        c.getAssignedAssets(); c.getLoanedAssets(); c.getSelectedAssets();
        c.onServiceTypeChange(); c.selectLoanedAssets();
        c.pcFrst(); c.pcLast(); c.pcNext(); c.pcPrev(); c.pcSize();
        c.saveWorkOrder(); c.setTaxAmount(); c.submitWorkOrder();
    }
//*/
}