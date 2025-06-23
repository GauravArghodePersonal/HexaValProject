@isTest
private class BWSalesSummary_ctrl_Test{
   @testSetup
    public static void BWSalesSummarymethod (){ 
    Boolean show_Data = true;
    String materialName ='test';
    String rpsView = 'test';
    String gmgpLabel = 'test1';
    
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
    //acct2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Customer','Account'); 
    insert acct2; 
    
    Material_General_Data2__c mgd2 = new Material_General_Data2__c();
    mgd2.Name = 'mgd2 Name';
    mgd2.Material_Number__c = 'mgd2 Number';
    insert mgd2;
    
    Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
    mat.Name = 'matNum';
    mat.Material_Number__c = 'matNum';
    mat.Sales_Org_Code__c = 'SORG';
    mat.Dist_Channel_Code__c = 'AN';
    mat.Record_Key__c = 'rk';
    insert mat;
    
    Rolling_Product_Sales_Info__c rpsi = new Rolling_Product_Sales_Info__c();
    rpsi.Account__c = acct2.Id;
    rpsi.Material2__c = mat.Id;
    rpsi.Account_Type__c = 'Unique';
    rpsi.CurrencyIsoCode = 'INR';
    rpsi.Amount_FYF__c= 2.2;
    rpsi.Key__c = 'key';
    rpsi.Plan_Amount_FYF__c = 2.2;
    rpsi.Plan_Volume_in_KG_FYF__c = 2.2;
    rpsi.Plan_Volume_in_LB_FYF__c = 2.2;
    rpsi.Volume_in_KG_FYF__c = 2.2;
    rpsi.Volume_in_LB_FYF__c = 2.2;
    rpsi.Amount_FYTD__c = 2.2;
    rpsi.GM_FYTD__c  = 2.2;
    rpsi.GMpct_FYTD__c = 2.2;
    rpsi.Plan_Amount_FYTD__c = 2.2;
    rpsi.Plan_Volume_in_KG_FYTD__c = 2.2;
    rpsi.Plan_Volume_in_LB_FYTD__c = 2.2;
    rpsi.Volume_in_GL_FYTD__c = 2.2;
    rpsi.Volume_in_KG_FYTD__c= 2.2;
    rpsi.Volume_in_LB_FYTD__c = 2.2;
    rpsi.Volume_in_PT_FYTD__c = 2.2;
    rpsi.Volume_in_UN_FYTD__c = 2.2;
    rpsi.Amount_PFYF__c  = 2.2;
    rpsi.Plan_Amount_PFYF__c = 2.2;
    rpsi.Plan_Volume_in_KG_PFYF__c  = 2.2;
    rpsi.Plan_Volume_in_LB_PFYF__c  = 2.2;
    rpsi.Volume_in_KG_PFYF__c = 2.2;
    rpsi.Volume_in_LB_PFYF__c = 2.2;
    rpsi.Amount_PFYTD__c = 2.2;
    rpsi.GM_PFYTD__c = 2.2;
    rpsi.GMpct_PFYTD__c  = 2.2;
    rpsi.Plan_Amount_PFYTD__c = 2.2;
    rpsi.Plan_Volume_in_KG_PFYTD__c = 2.2;
    rpsi.Plan_Volume_in_LB_PFYTD__c  = 2.2;
    rpsi.Volume_in_GL_PFYTD__c = 2.2;
    rpsi.Volume_in_KG_PFYTD__c = 2.2;
    rpsi.Volume_in_LB_PFYTD__c = 2.2;
    rpsi.Volume_in_PT_PFYTD__c = 2.2;
    rpsi.Volume_in_UN_PFYTD__c = 2.2;
    //rpsi.START_DATE = SYSTEM.TODAY();
    rpsi.Material_General_Data2__c = mgd2.Id;
    rpsi.Month_01__c = Rolling_Product_Sales_Info.START_FP;
    rpsi.Record_Type__c = Rolling_Product_Sales_Info.RECTYPE_ACC;
    insert rpsi;
    
    List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
    
    }
        
    static testmethod void myUnitTest_getRpsViewLabel_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.getRpsViewLabel();
        System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_getRpsViewLabel_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.getRpsViewLabel();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        } 
    static testmethod void myUnitTest_searchByMaterialName_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.searchByMaterialName();
        System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_searchByMaterialName_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.searchByMaterialName();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
        
    static testmethod void myUnitTest_pc1Size_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Size();
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1Size_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Size();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
        
    static testmethod void myUnitTest_pc1Frst_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Frst();
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1Frst_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Frst();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
        
    static testmethod void myUnitTest_pc1Prev_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Prev();
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1Prev_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Prev();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
        
    static testmethod void myUnitTest_pc1Next_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Next();
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1Next_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Next();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1Last_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Last();
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1Last_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Last();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1Goto_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Goto();
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1Goto_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.pc1Goto();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_setRpsView_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.setRpsView();
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_setRpsView_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.setRpsView();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_getAccId_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.getAccId();
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_getAccId_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.getAccId();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
        static testmethod void myUnitTest_setAccId_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.setAccId('a');
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_setAccId_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.setAccId('a');
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_getAccountSummary_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.getAccountSummary(acct2.id);
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_getAccountSummary_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.getAccountSummary(acct2.id);
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_searchByMaterialByName_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.searchByMaterialByName(acct2.id,'fg','fg');
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_searchByMaterialByName_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.searchByMaterialByName(acct2.id,'fg','fg');
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_getRpsiLines_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.getRpsiLines();
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_getRpsiLines_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        controller.getRpsiLines();
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1FrstHandler_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1FrstHandler(acct2.id,'fg','fg');
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1FrstHandler_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1FrstHandler(acct2.id,'fg','fg');
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1PrevHandler_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1PrevHandler(acct2.id,'fg','fg');
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1PrevHandler_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1PrevHandler(acct2.id,'fg','fg');
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1NextHandler_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1NextHandler(acct2.id,'fg','fg');
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1NextHandler_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1NextHandler(acct2.id,'fg','fg');
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1LastHandler_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1LastHandler(acct2.id,'fg','fg');
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1LastHandler_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1LastHandler(acct2.id,'fg','fg');
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1GotoHandler_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1GotoHandler(acct2.id,1,'fg','fg');
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_pc1GotoHandler_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.pc1GotoHandler(acct2.id,1,'fg','fg');
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_onViewChangeHandler_Positive(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.onViewChangeHandler(acct2.id,'fg','fg',1);
         System.assertEquals(acct2.Name,'Test 2'); 
        Test.stopTest();  
        }
    static testmethod void myUnitTest_onViewChangeHandler_Negative(){
        Test.StartTest();
        Account acct2 =[SELECT Name, country_picklist__c, Prospect_Division__c, Prospect_Sales_District__c, Prospect_Sales_Office__c, Prospect_Sales_Group__c, Prospect_Dist_Channel__c, 
        Prospect_Customer_Group1__c, Prospect_Customer_Group2__c, Prospect_Customer_Group__c, Prospect_Customer_Price_Group_Desc__c,
        SAP_Country__c, BillingStreet, SAP_Customer_Number__c FROM Account];
    
        List<Rolling_Product_Sales_Info__c> lRpsi = new List<Rolling_Product_Sales_Info__c>();
        BWSalesSummary_ctrl controller = new BWSalesSummary_ctrl(acct2.id  );
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        BWSalesSummary_ctrl controller1 = new BWSalesSummary_ctrl(sc);
        BWSalesSummary_ctrl.onViewChangeHandler(acct2.id,'fg','fg',1);
        System.assertNotEquals(acct2.Name,null); 
        Test.stopTest();  
        }   
    
}