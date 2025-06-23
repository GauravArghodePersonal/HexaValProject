@isTest
private class AccountRollupAccountTrigger_T {
/****************************************************************************
 * Test Class AccountRollupAccountTrigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupAccountTrigger Trigger
 ****************************************************************************/
 
    //Test Data
    private static Id accountId;
    private static Account shipTo, soldTo, cHerky, invalidAcc;
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        executeTest02();
        executeTest03();
        Test.stopTest();
    }
  
    private static void createTestData() {
        
        // Added by Vinu
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
        // Added by Vinu
            // Adding Account
        Account rec=new Account(); 
        rec.Name = 'Test Account 2';
        rec.recordtypeId = '01250000000HmZ3AAK';
        rec.SAP_Zip_Code__c = '43081';
        rec.Account_Sales_Potential_Amount_Year__c = 52;
        rec.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        rec.Prospect_Dist_Channel__c = 'AHWT (10)';
        rec.Prospect_Division__c = 'AWT (11)';
        rec.Prospect_Sales_District__c = 'RSD IWT NA (IWNA1)';
        rec.Prospect_Sales_Office__c = 'DM  IWT NA CENTRAL (IW35)';
        rec.Prospect_Sales_Group__c = 'IWT NA ARKLATEX (27I)';
        rec.Prospect_Customer_Group__c = 'POWER (1J)';
        rec.Prospect_Customer_Group1__c = 'THIRD PARTY PRODUCER (510)';
        rec.Prospect_Customer_Group2__c = 'PWR-Coal (191)';
        rec.Related_to_Corporate__c = 'No';
        rec.SAP_Account_Name_2__c = rec.Name;
        rec.AccountNumber = '123';
        rec.BillingCity = 'City';
        rec.BillingCountry = 'US';
        rec.BillingPostalCode = '99999';
        rec.BillingState = 'Virginia';
        rec.SAP_State__c = 'Virginia';
        rec.SAP_Customer_Group_1_Desc__c = 'CustGrp1';
        rec.SAP_Customer_Group_Desc__c = 'CustGrp';
        rec.SAP_DistChannel__c = '10';
        rec.SAP_Dist_Channel_Desc__c = 'AHWT';
        rec.SAP_DivisionCode__c = '11';
        rec.SAP_Division_Desc__c = 'AHWT';
        rec.SAP_Sales_Org__c = '1020';
        rec.SAP_Sales_Org_Desc__c = 'Solenis';
        rec.Hours_of_Access__c='9 to 17';
        rec.PPE_Requirements__c='Ear Plugs';
        rec.Site_Access__c='BackGround Check';
        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
        rec.ShippingStreet = 'test street';
        //rec.Owner__r.Email  ='vinu.sankaralingam@techmahindra.com';
        //system.debug('rec.Owner.Email'+rec.Owner.Email);
        insert rec;
        // - Added by Vinu
        
        CISRelationships__c c = new CISRelationships__c();
        c.Ext_Unique_ID_c__c = rec.id+rec.AccountNumber+'Sold To';
        c.Customer_Type__c = 'Sold To';
        c.Customer_Number__c = rec.AccountNumber;
        c.Source_Customer__c = rec.id;
        insert c;
        // - Addeed by Vinu
        
        
        Map<String,SObject> testData = TestScenarios.createAccountsWithRelationshipObjects();
        cHerky = (Account)testData.get('cHerky');
        soldTo = (Account)testData.get('soldTo');
        shipTo = (Account)testData.get('shipTo');
        invalidAcc = (Account)testData.get('invalidAcc');

        Account_Rollup_Settings__c settings = Account_Rollup_Settings.defaultSettings();
        settings.Triggers_Enabled__c = true;
        update settings;
    }
  
    private static void executeTest01() {
        // Execute Tests
       
        update shipTo;
        //delete shipTo;
    }
        private static void executeTest02() {
        CISRelationships__c c = [select id from CISRelationships__c limit 1];
        System.debug('vinu>>>>CIS'+c);
        Account a = [select id,Name from Account where Name = 'Test Account 2' limit 1 ];
        System.debug('vinu>>>>Account'+a);
        a.Name = 'Test Account 2';
        update a;
        }
        
        private static void executeTest03() {
        // Added by Vinu
        // Adding Account
        Account rec=new Account(); 
        rec.Name = 'Test Account 2';
        rec.recordtypeId = '01250000000HmZ3AAK';
        rec.SAP_Zip_Code__c = '43081';
        rec.Account_Sales_Potential_Amount_Year__c = 52;
        rec.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        rec.Prospect_Dist_Channel__c = 'AHWT (10)';
        rec.Prospect_Division__c = 'AWT (11)';
        rec.Prospect_Sales_District__c = 'RSD IWT NA (IWNA1)';
        rec.Prospect_Sales_Office__c = 'DM  IWT NA CENTRAL (IW35)';
        rec.Prospect_Sales_Group__c = 'IWT NA ARKLATEX (27I)';
        rec.Prospect_Customer_Group__c = 'POWER (1J)';
        rec.Prospect_Customer_Group1__c = 'THIRD PARTY PRODUCER (510)';
        rec.Prospect_Customer_Group2__c = 'PWR-Coal (191)';
        rec.Related_to_Corporate__c = 'No';
        rec.SAP_Account_Name_2__c = rec.Name;
        rec.AccountNumber = '123';
        rec.BillingCity = 'City';
        rec.BillingCountry = 'US';
        rec.BillingPostalCode = '99999';
        rec.BillingState = 'Virginia';
        rec.SAP_State__c = 'Virginia';
        rec.SAP_Customer_Group_1_Desc__c = 'CustGrp1';
        rec.SAP_Customer_Group_Desc__c = 'CustGrp';
        rec.SAP_DistChannel__c = '10';
        rec.SAP_Dist_Channel_Desc__c = 'AHWT';
        rec.SAP_DivisionCode__c = '11';
        rec.SAP_Division_Desc__c = 'AHWT';
        rec.SAP_Sales_Org__c = '1020';
        rec.SAP_Sales_Org_Desc__c = 'Solenis';
        rec.Hours_of_Access__c='9 to 17';
        rec.PPE_Requirements__c='Ear Plugs';
        rec.Site_Access__c='BackGround Check';
        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
        rec.ShippingStreet = 'test street';
        //rec.Owner__r.Email  ='vinu.sankaralingam@techmahindra.com';
        //system.debug('rec.Owner.Email'+rec.Owner.Email);
        insert rec;
        // - Added by Vinu
    }
    
}