@isTest
private class Trigger_Settings_Test {

  @TestVisible  static Apex_Trigger_Settings__c ats;
  @TestVisible  static Apex_Trigger_Groups__c atg;
   @TestVisible static Account acc;

   @TestVisible static void debug(String s) {System.debug(LoggingLevel.INFO, s);}

   @TestVisible static void setup() {
        ats = new Apex_Trigger_Settings__c();
        insert ats;
        atg = new Apex_Trigger_Groups__c();
        atg.Name = 'G001_N001';
        atg.Trigger_Group__c = 'G001__c';
        atg.Trigger_Name__c = 'N001__c';
        insert atg;

        atg = new Apex_Trigger_Groups__c();
        atg.Name = 'Pricing_Account';
        atg.Trigger_Group__c = 'Pricing__c';
        atg.Trigger_Name__c = 'Account__c';
        insert atg;
    }

   @TestVisible static void createAccount() {
        //acc = new Account(Name='test'); insert acc;
        //acc = [select Id, Name, Owner__c, Owner_Name__c
        //        from Account where Id = :acc.Id];
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
        debug('****************************************************');
        debug('acc = ' + rec);
        debug('****************************************************');
    }

    @TestVisible static testMethod void test01() {
        setup();
        Trigger_Settings.doNotRun('test');
        Trigger_Settings.doNotRun('N001');

        // Test for Object level setting
        ats.All_Triggers__c = false; ats.Pricing__c = false; ats.Account__c = true; update ats;
        createAccount();

        // Test for Group level setting
        ats.All_Triggers__c = false; ats.Pricing__c = true; ats.Account__c = false; update ats;
        createAccount();

        // Test for All triggers setting
        ats.All_Triggers__c = true; ats.Pricing__c = false; ats.Account__c = false; update ats;
        createAccount();

        // Test for Normal trigger execution
        ats.All_Triggers__c = false; ats.Pricing__c = false; ats.Account__c = false; update ats;
        createAccount();
    }
}