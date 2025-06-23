@isTest
private class UOM_Conversion_Functions2_Test{
    @isTest static void UOM_Conversion_Functions2method (){
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

        
        Account acct2 = new Account(); 
        acct2.Name = 'Test 2'; 
        acct2.Prospect_Sales_Org__c = 'Solenis LLC(1020)'; 
        acct2.country_picklist__c = 'Afghanistan (AF)'; 
        acct2.Prospect_Division__c = 'AAFI (50)'; 
        acct2.Prospect_Division__c = 'AAFI (50)'; 
        acct2.Prospect_Sales_District__c = 'ADDITIVES (11100)'; 
        acct2.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)'; 
        acct2.Prospect_Sales_Group__c = 'AM ARG/URU'; 
        acct2.Prospect_Dist_Channel__c = 'AAFI (50)'; 
        acct2.Prospect_Customer_Group1__c = 'AFFILIATE (412)'; 
        acct2.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)'; 
        acct2.Prospect_Customer_Group__c = 'ADDITIVES (11)'; 
        acct2.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)'; 
        acct2.Prospect_Customer_Price_Group_Desc__c = 'ZL'; 
        acct2.SAP_Country__c = 'US'; 
        acct2.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4'; 
        acct2.SAP_Customer_Number__c = '12345'; 
        acct2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account'); 
        insert acct2; 
    
        Sample_Request__c sr = new Sample_Request__c();
        sr.Account__c = acct2.id;
        insert sr;
        
        List<Sample_Material__c> ls = new List<Sample_Material__c>();
        Sample_Material__c sm = new Sample_Material__c();
        sm.Sample_Request__c = sr.id;
        ls.add(sm);
        
        UOM_Conversion__c uom = new UOM_Conversion__c();
        uom.UOM__c = 'test';
        insert uom;
        
        UOM_Account_Record_Type__c uo = new UOM_Account_Record_Type__c ();
        uo.Account_Record_Type__c = 'Drew Customer';
        uo.Record_Key__c = 'test';
        uo.Sample_Quantity_1__c = 1;
        uo.Sample_Quantity_2__c = 1;
        uo.Sample_Quantity_3__c = 1;
        uo.Source_System_Id__c = 'test';
        uo.UOM_Conversion__c = uom.id;
        insert uo;
        
        UOM_Conversion_Functions2.populateUOMConversions();
        UOM_Conversion_Functions2.UOMQty_Greater_Than_5_Gallons('Drew Customer',1.1);
        UOM_Conversion_Functions2.UOMQty_Greater_Than_5_Gallons('Drew Customer',0);
        UOM_Conversion_Functions2.getUomSelectOptions('Drew Customer');
        UOM_Conversion_Functions2.getSampleQuantities('Drew Customer');
        UOM_Conversion_Functions2.setRouteForApprovalFlags('Drew Customer',sr,ls);
        }
   }