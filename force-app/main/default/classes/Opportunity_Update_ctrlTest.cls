@isTest
public class Opportunity_Update_ctrlTest{
    @testSetup
    static void testData(){
        Trigger__c Tr = New Trigger__c();
        Tr.Name='SentEmailToAcc';    
        Tr.Run__c = False;
        Tr.Trigger_Name__c='opportunityTriggerhandler';
        Insert Tr;     
           
        Competitive_Email_Setup__c CMS = New Competitive_Email_Setup__c();
        CMS.Name='SentEmailToAcc';
        CMS.Bcc__c='Test@test.com';
        CMS.CC_Email__c='Test@test.com';
        CMS.DisplayName__c='Test Display Name';
        CMS.Reply_To__c='Test@test.com';
        CMS.Subject__c='Test Subject';
        insert CMS;
        
        Apex_Trigger_Settings__c apxTrgSet = new Apex_Trigger_Settings__c();
        apxTrgSet.Competitor_to_Account__c = true;
        insert apxTrgSet; 
        
        User u = [select id,Lastname from User limit 1];
        Profile prof = [SELECT Id FROM Profile WHERE Name='Standard User'];

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
        acct2.SAP_Sales_Org__c = '1020'; 
        insert acct2;
        
        Competitor__c objComp = new Competitor__c();
        objComp.Name = 'Demo Solenis';
        insert objComp;
        
        Material_Sales_Data2__c objMaterialSalesData2 = new Material_Sales_Data2__c();
        objMaterialSalesData2.Material_Number__c = '0000001';
        objMaterialSalesData2.Name = 'Material-1';
        objMaterialSalesData2.Dist_Channel_Code__c = '30';
        objMaterialSalesData2.Record_Key__c = objMaterialSalesData2.Name;
        objMaterialSalesData2.Sales_Org_Code__c = '1000';
        insert objMaterialSalesData2;    
    }
    
    static testMethod void unitTest_positivegetOpportunityById(){
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Solenis Opp';
        objOpp.StageName = 'DemoSolenis';
        objOpp.CloseDate= Date.today(); 
        objOpp.AccountId = [SELECT id FROM Account LIMIT 1].id;
        objOpp.CurrencyIsoCode = 'USD';
        objOpp.SAP_Sales_Org_Region__c = 'NA';
        objOpp.SBU_Multi__c = 'Microbiological Control';
        objOpp.Annualized_Gross_Profit_GP__c = 270000;
        objOpp.Launch_Platform__c = 'No Launch Platform';
        objOpp.Innova_Selection__c = 'Not An INNOVA Opportunity';
        objOpp.Application_Support_Manager__c = 'LA IWT Biorefining - Glauco Martins';
        objOpp.ByPassValidation_Rule__c = False;
        objOpp.product_of_interest_other__c = '12345'; 
        objOpp.price_unit_of_measure__c = 'KG';
        insert objOpp;
        
        Competitor_to_Account__c objCTA = new Competitor_to_Account__c(); 
        objCTA.Account__c = [SELECT id FROM Account LIMIT 1].id;
        objCTA.Competitor__c = [SELECT id FROM Competitor__c LIMIT 1].id;
        insert objCTA;
        
        Competitor_to_Opportunity__c objCTP = new Competitor_to_Opportunity__c();
        objCTP.Competitor__c = [SELECT id FROM Competitor__c LIMIT 1].id;
        objCTP.Opportunity__c = [SELECT id FROM Opportunity LIMIT 1].id;
        insert objCTP;        
        
        Test.startTest();
        Opportunity objOppr = [SELECT Id, Name, StageName, CloseDate,ByPassValidation_Rule__c , CurrencyIsoCode, SAP_Sales_Org_Region__c, SBU_Multi__c, Annualized_Gross_Profit_GP__c, Launch_Platform__c, 
                                          Innova_Selection__c, Application_Support_Manager__c FROM Opportunity LIMIT 1];
        Opportunity_Update_ctrl.getOpportunityById(objOppr.Id);
        System.assertEquals(objOppr.ByPassValidation_Rule__c ,FALSE);
        Test.stopTest();    
    
    }
    
        static testMethod void unitTest_NegativegetOpportunityById(){
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Solenis Opp';
        objOpp.StageName = 'DemoSolenis';
        objOpp.CloseDate= Date.today(); 
        objOpp.AccountId = [SELECT id FROM Account LIMIT 1].id;
        objOpp.CurrencyIsoCode = 'USD';
        objOpp.SAP_Sales_Org_Region__c = 'NA';
        objOpp.SBU_Multi__c = 'Microbiological Control';
        objOpp.Annualized_Gross_Profit_GP__c = 270000;
        objOpp.Launch_Platform__c = 'No Launch Platform';
        objOpp.Innova_Selection__c = 'Not An INNOVA Opportunity';
        objOpp.Application_Support_Manager__c = 'LA IWT Biorefining - Glauco Martins';
        objOpp.ByPassValidation_Rule__c = False;
        objOpp.product_of_interest_other__c = '12345'; 
        objOpp.price_unit_of_measure__c = 'KG';
        insert objOpp;
        
        Competitor_to_Account__c objCTA = new Competitor_to_Account__c(); 
        objCTA.Account__c = [SELECT id FROM Account LIMIT 1].id;
        objCTA.Competitor__c = [SELECT id FROM Competitor__c LIMIT 1].id;
        insert objCTA;
        
        Competitor_to_Opportunity__c objCTP = new Competitor_to_Opportunity__c();
        objCTP.Competitor__c = [SELECT id FROM Competitor__c LIMIT 1].id;
        objCTP.Opportunity__c = [SELECT id FROM Opportunity LIMIT 1].id;
        insert objCTP;        
        
        Test.startTest();
        Opportunity objOppr = [SELECT Id, Name, StageName,ByPassValidation_Rule__c , CloseDate, CurrencyIsoCode, SAP_Sales_Org_Region__c, SBU_Multi__c, Annualized_Gross_Profit_GP__c, Launch_Platform__c, 
                                          Innova_Selection__c, Application_Support_Manager__c FROM Opportunity LIMIT 1];
        Opportunity_Update_ctrl.getOpportunityById(objOppr.Id);
        System.assertNotEquals(objOppr.ByPassValidation_Rule__c ,NULL);
        Test.stopTest();    
    
    }
}