@isTest
private class PriceFxLogMaintenance_Test{
    @isTest static void priceFxLogMaintenancemethod(){
        List <PriceFx_Webservice_Logs__c> pricelist = new List <PriceFx_Webservice_Logs__c>();
        PriceFx_Webservice_Logs__c price = new PriceFx_Webservice_Logs__c();
        PriceFx_Webservice_Logs__c price1 = new PriceFx_Webservice_Logs__c();
        price.Name='0015000000tvrIMAAY';
        price.Object_Name__c = 'account';
        price.Response_Code__c = '111';
        price.Status_of_the_Process__c = 'Success';
        price.Exception_Message__c = 'ok';
        price.Interface_Name__c = 'test interface';
        price.Last_request_sent_date__c =system.today();
           
        price1.Name='0015000000tvrIMAAZ';
        price1.Object_Name__c = 'account';
        price1.Response_Code__c = '100';
        price1.Status_of_the_Process__c = 'Progress';
        price1.Exception_Message__c = 'ok';
        price1.Interface_Name__c = 'test interface';
        price1.Last_request_sent_date__c =system.today();
        pricelist.add(price);
        pricelist.add(price1);
        insert pricelist;
        List <PriceFx_Webservice_Logs__c> priceListUpdated = new List <PriceFx_Webservice_Logs__c>();
        for(PriceFx_Webservice_Logs__c a : pricelist){
            Datetime yesterday = Datetime.now().addDays(-418);
            Test.setCreatedDate(a.Id, yesterday);
            priceListUpdated.add(a);
        }
        update priceListUpdated;
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

            PriceFxLogMaintenance obj = new PriceFxLogMaintenance();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
       
    } 
}