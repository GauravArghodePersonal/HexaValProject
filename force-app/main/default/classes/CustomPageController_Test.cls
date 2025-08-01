@isTest
private class CustomPageController_Test{
    @isTest static void CustomPageControllermethod (){
        
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

        Account a = new Account(Name='ShipTo', Account_Number__c='AccountNumber');
        insert a;
        Pricing__c p = new Pricing__c();
        p.Account__c = a.Id;
        p.Pricing_Type__c = 'Ship and Bill pricing';
        p.Status__c = 'Submitted';
        p.Net_Deal_Rating__c = 'test';
        p.Number_of_Locations_Serve__c = 2;
        p.Promotions__c = 'test';
        insert p;
       ApexPages.StandardController c = new ApexPages.StandardController(p);
       CustomPageController controller = new CustomPageController(c);
       CustomPageController controller1 = new CustomPageController();
       controller.saveAndSubmit();
    }
  }