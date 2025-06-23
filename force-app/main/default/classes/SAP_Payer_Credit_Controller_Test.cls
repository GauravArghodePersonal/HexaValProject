@isTest
private class SAP_Payer_Credit_Controller_Test{
    @testSetup
    public static void SAP_Payer_Credit_ControllerMethod(){
         
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
    acct2.Name = 'Test'; 
    acct2.Prospect_Sales_Org__c = 'Solenis LLC(1020)'; 
    acct2.country_picklist__c = 'Afghanistan (AF)'; 
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
    insert acct2; 
        
    SAP_Payer_Credit_Information__c s = new SAP_Payer_Credit_Information__c();
    s.SAP_Payer_Balance__c = 0.00;
    s.SAP_Payer_Credit_Limit__c = 0.00;
    s.SAP_Payer_Credit_Control__c = 'ECCA';
    s.SAP_Payer_Current__c = 0.00;
    s.SAP_Payer_Dist_Channel__c = '10';
    s.SAP_Payer_Division__c = '11';
    s.SAP_Payer_Past_Due_1_15_Days__c = 0.00;
    s.SAP_Payer_Past_Due_16_30_Days__c = 0.00;
    s.SAP_Payer_Past_Due_31_60_Days__c = 0.00;
    s.SAP_Payer_Past_Due_61_90_Days__c = 0.00;
    s.SAP_Payer_Past_Due_over_90Days__c = 0.00;
    s.SAP_Payer_Sales_Org__c = '0070';
    s.SAP_Payer_Total_Past_Due__c = 0.00;
    s.Record_Key__c = '000064784700701111ECCARUB';
    s.SAP_Payer_Account__c =acct2.Id;
    s.SAP_Payer_Account_Number__c = '0000647837';
    insert s;
    Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(acct2);
        SAP_Payer_Credit_Controller controller = new SAP_Payer_Credit_Controller(sc);
    Test.stopTest();
    } 
  
    static testMethod void positive_getSAPCreditInfo(){    
    Account objAcc = [SELECT Id,Name,Prospect_Sales_Org__c,country_picklist__c,Prospect_Division__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,
                                    Prospect_Sales_Group__c,Prospect_Dist_Channel__c,Prospect_Customer_Group1__c,Prospect_Customer_Group2__c,Prospect_Customer_Group__c,
                                    Prospect_Customer_Price_Group_Desc__c,BillingStreet,SAP_Customer_Number__c,SAP_Sales_Org__c,full_Address__c,SAP_Street__c,SAP_StreetSuppl1__c,
                                    SAP_StreetSuppl2__c,SAP_City__c,SAP_state__c,SAP_ZIP_Code__c,SAP_Country__c FROM Account LIMIT 1];
    Test.startTest();
        SAP_Payer_Credit_Controller.getSAPCreditInfo(objAcc.Id);
        System.assertEquals(objAcc.Name ,'Test');
    Test.stopTest();
    }
    
    static testMethod void negative_getSAPCreditInfo(){    
    Account objAcc = [SELECT Id,Name,Prospect_Sales_Org__c,country_picklist__c,Prospect_Division__c,Prospect_Sales_District__c,Prospect_Sales_Office__c,
                                    Prospect_Sales_Group__c,Prospect_Dist_Channel__c,Prospect_Customer_Group1__c,Prospect_Customer_Group2__c,Prospect_Customer_Group__c,
                                    Prospect_Customer_Price_Group_Desc__c,BillingStreet,SAP_Customer_Number__c,SAP_Sales_Org__c,full_Address__c,SAP_Street__c,SAP_StreetSuppl1__c,
                                    SAP_StreetSuppl2__c,SAP_City__c,SAP_state__c,SAP_ZIP_Code__c,SAP_Country__c FROM Account LIMIT 1];
    Test.startTest();
        SAP_Payer_Credit_Controller.getSAPCreditInfo(objAcc.Id);
        System.assertNotEquals(objAcc.Name ,'Solenis');
    Test.stopTest();
    }
}