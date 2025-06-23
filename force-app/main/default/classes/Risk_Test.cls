@isTest
public class Risk_Test {
    
    static Account                 acc;
    static Competitor__c           cmp;
    static Material_Sales_Data2__c mat;
    static Product_Sales_Plan__c   psp;
    static Risk__c                 rsk;
    static Risk_Detail__c          rdc;
    static List<Risk_Detail__c>  rdlist;

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }
    
    static void createTestData() {
        cmp = new Competitor__c();
        cmp.Name = 'Test';
        insert cmp;
        
        psp = Sales_Plan_Test.getProductSalesPlan();
        debug('psp : ' + psp);
        acc = Risk_Functions.getAccount(psp.Account__c);
        rsk = new Risk__c();
        rsk.Account__c = acc.Id;
        rsk.Competitor__c = cmp.Id;
        rsk.Probability_of_Risk_CY__c = 10;
        rsk.Probability_of_Risk_NY__c = 20;
        rsk.Record_Status__c = Risk_Functions.ACTIVE;
        rsk.Stage__c = 'Test'; rsk.Reason__c = 'Test';
        rsk.Region__c = 'Test'; rsk.SBU__c = 'Test';
        rsk.Business_Segment__c = 'Test'; rsk.Business_Unit__c = 'Test';
        //insert rsk;
        
        rdc = new Risk_Detail__c();
        rdc.Material__c = psp.Material__c;
        //rdc.Risk__c = rsk.Id;
        rdc.Price_CY__c = 10; 
        rdc.Price_NY__c = 20;
        rdc.Volume_at_Risk_CY__c = 1000;
        rdc.Volume_at_Risk_NY__c = 2000;
        //insert rdc;
        
        rdlist = new List<Risk_Detail__c>{rdc};
        Risk_Functions.saveRisk(rsk, rdlist);
        
        rsk = Risk_Functions.getRisk(rsk.Id);
        debug('rsk : ' + rsk);
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

        Risk_Functions.compare1('a', 'b'); Risk_Functions.compare2('a', 'b');
        createTestData();
        Test.startTest();
        PaginationController pc1 = Risk_Functions.getProductPlansPC(acc.Id, 20);
        rsk.Key_Risk_To_Plan__c = true;
        Risk_Functions.saveRisk(rsk, rdlist);
        Risk_Functions.isApproved(rsk); 
        Risk_Functions.isClosed(rsk); Risk_Functions.isDraft(rsk);
        List<Risk__c> tlist = new List<Risk__c>{rsk};
        tlist = Risk_Functions.createNextYearRisks(tlist);
        Risk_Functions.activateNextYearRisks(tlist);
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
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(rsk);
        Risk_Controller c = new Risk_Controller(sc);
        c.cancel(); c.deleteMaterials(); c.addAndReturn(); c.onAccountChange(); c.saveRisk();
        c.pc1Frst(); c.pc1Next(); c.pc1Prev(); c.pc1Last();
        c.gotoRiskPage1();
        c.activateNextYearRisks();
        c.createNextYearRisks();
        c.addMaterials();
        c.calculate();
     
    }
    
}