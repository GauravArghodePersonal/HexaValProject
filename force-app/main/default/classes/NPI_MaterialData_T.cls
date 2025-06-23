@isTest
private class NPI_MaterialData_T
{
    static testMethod void myUnitTest(){
        // Test.startTest();
        
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
        
        Material_Sales_Data2__c matdata = new Material_Sales_Data2__c ();
        matdata.Name='Test2';
        matdata.Material_Number__c='00123';
        matdata.Dist_Channel_Code__c='10';
        matdata.Record_Key__c='tbt100';
        matdata.Sales_Org_Code__c='11';
        matdata.Fiscal_Year_Variant__c='2010';
        matdata.NP_Base_Code__c='01_0024000';
        matdata.NP_Effective_Date__c='001/2011';
        matdata.NP_Global_Region__c='EMEA_Test';
        matdata.NP_DistrChannel__c='10'; 
        matdata.Active_Material__c = 'Y';
        matdata.DistChannel_Code__c = 'a5B500000004bpM';
        matdata.Dist_Channel_Material_Status__c = 'ZL';
        matdata.Material_Base_Code__c = '01_0024000';
        matdata.Sales_Org_Code__c = 'XXX5';
        //matdata.PH5__c = '345';
        insert matdata;
     
        NPI_Sales_Data__c npdata =new NPI_Sales_Data__c();
        npdata.Name='Test1';
        npdata.Fiscal_Year_Variant__c='2010';
        npdata.NP_Base_Code__c='01_0024000'; 
        npdata.NP_Effective_Date__c='001/2011';
        npdata.NP_Global_Region__c='LA';
        npdata.NP_DistrChannel__c='10';
        npdata.NPI_Record_key__c='01_0024000LA10';
        insert npdata;

        matdata.NPI_Sales_Data__c=npdata.Id;
        update matdata;
        

        
        //Test.stopTest(); 
    }
    
}