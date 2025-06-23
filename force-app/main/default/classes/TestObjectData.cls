@isTest
public class TestObjectData {
    private static Integer uniqueIdx = 0;
    private static Integer newUniqueIdx() {return uniqueIdx++;}

    public static void populateSObject(String sObjectType, String templateType, SObject rec) {
        if (sObjectType == 'Account')
        {
            if (templateType == 'testAccount1') {populateAccount_TestAccount1((Account)rec);}
            else if (templateType == 'testAccount2') {populateAccount_TestAccount2((Account)rec);}
            else if (templateType == 'EmptyAccount') {populateAccount_EmptyAccount((Account)rec);}
            else {populateAccount_Default((Account)rec);}
        }
        
        if (sObjectType == 'Contact')
        {
            if (templateType == 'testContact1') {populateContact_TestContact1((Contact)rec);}
            else if (templateType == 'testContact2') {populateContact_TestContact2((Contact)rec);}
            else {populateContact_Default((Contact)rec);}
        }
        
        if (sObjectType == 'User')
        {
            if (templateType == 'testUser1') {populateUser_TestUser1((User)rec);}
            else if (templateType == 'testUser2') {populateUser_TestUser2((User)rec);}
            else {populateUser_Default((User)rec);}
        }
        
        if (sObjectType == 'CISRelationships__c')
        {
            if (templateType == 'ShipTo') {populateCISRelationships_ShipTo((CISRelationships__c)rec);}
            else if (templateType == 'SoldTo') {populateCISRelationships_SoldTo((CISRelationships__c)rec);}
            else {populateCISRelationships_Default((CISRelationships__c)rec);}
        }
        
        if (sObjectType == 'Event')
        {
            populateEvent_Default((Event)rec);
        }

        if (sObjectType == 'Account_Relationship__c')
        {
            populateAccount_Relationship_Default((Account_Relationship__c)rec);
        }

        if (sObjectType == 'Strategic_Plan__c')
        {
            populateStrategic_Plan_Default((Strategic_Plan__c)rec);
        }

        if (sObjectType == 'Material_Sales_Data2__c')
        {
            populateMaterial_Sales_Data2_Default((Material_Sales_Data2__c)rec);
        }

        if (sObjectType == 'Pricing_Condition__c')
        {
            populatePricing_Condition_Default((Pricing_Condition__c)rec);
        }

        if (sObjectType == 'Account_Sales_Figure__c')
        {
            populateAccount_Sales_Figure_Default((Account_Sales_Figure__c)rec);
        }
        
        if (sObjectType == 'Product_Sales_Figure__c')
        {
            populateProduct_Sales_Figure_Default((Product_Sales_Figure__c)rec);
        }
        
        if (sObjectType == 'Activity_User_Group__c')
        {
            populateActivity_User_Group_Default((Activity_User_Group__c)rec);
        }

        if (sObjectType == 'Competitor__c')
        {
            populateCompetitor_Default((Competitor__c)rec);
        }

        if (sObjectType == 'Competitor_to_Account__c')
        {
            populateCompetitor_to_Account_Default((Competitor_to_Account__c)rec);
        }

        if (sObjectType == 'Opportunity')
        {
            populateOpportunity_Default((Opportunity)rec);
        }

        if (sObjectType == 'Opportunity_Material__c')
        {
            populateOpportunity_Material_Default((Opportunity_Material__c)rec);
        }

        if (sObjectType == 'Competitor_to_Opportunity__c')
        {
            populateCompetitor_to_Opportunity_Default((Competitor_to_Opportunity__c)rec);
        }

        if (sObjectType == 'Pricing__c')
        {
            populatePricing_Default((Pricing__c)rec);
        }

        if (sObjectType == 'Customer_Product_Info__c')
        {
            populateCustomer_Product_Info_Default((Customer_Product_Info__c)rec);
        }

        if (sObjectType == 'SAP_Distribution_Channel__c')
        {
            populateSAP_Distribution_Channel_Default((SAP_Distribution_Channel__c)rec);
        }

        if (sObjectType == 'SAP_Customer_Group__c')
        {
            populateSAP_Customer_Group_Default((SAP_Customer_Group__c)rec);
        }

        if (sObjectType == 'SAP_Customer_Group1__c')
        {
            populateSAP_Customer_Group1_Default((SAP_Customer_Group1__c)rec);
        }

        if (sObjectType == 'SAP_Sales_Org__c')
        {
            populateSAP_Sales_Org_Default((SAP_Sales_Org__c)rec);
        }

        if (sObjectType == 'Customer_Group__c')
        {
            populateCustomer_Group_Default((Customer_Group__c)rec);
        }

/*
        if (sObjectType == 'Equipment__c')
        {
            populateEquipment_Default((Equipment__c)rec);
        }
*/
        if (sObjectType == 'ART_Project__c')
        {
            populateART_Project_Default((ART_Project__c)rec);
        }

        if (sObjectType == 'ART_Request__c')
        {
            populateART_Request_Default((ART_Request__c)rec);
        }

        if (sObjectType == 'ART_Release__c')
        {
            populateART_Release_Default((ART_Release__c)rec);
        }

        if (sObjectType == 'Lead')
        {
            populateLead_Default((Lead)rec);
        }

        if (sObjectType == 'Material_General_Data__c')
        {
            populateMaterial_General_Data_Default((Material_General_Data__c)rec);
        }

        if (sObjectType == 'SAP_Sales_Division__c')
        {
            populateSAP_Sales_Division_Default((SAP_Sales_Division__c)rec);
        }

        if (sObjectType == 'SAP_Ultimate_Parent__c')
        {
            populateSAP_Ultimate_Parent_Default((SAP_Ultimate_Parent__c)rec);
        }

        if (sObjectType == 'SAP_Country_Name__c')
        {
            populateSAP_Country_Name_Default((SAP_Country_Name__c)rec);
        }

        if (sObjectType == 'Price_Book__c')
        {
            populatePrice_Book_Default((Price_Book__c)rec);
        }

        if (sObjectType == 'Price_Book_Customer_Group__c')
        {
            populatePrice_Book_Customer_Group_Default((Price_Book_Customer_Group__c)rec);
        }

        if (sObjectType == 'Price_Book_Entry__c')
        {
            populatePrice_Book_Entry_Default((Price_Book_Entry__c)rec);
        }

        if (sObjectType == 'Price_Book_Entry_Scaled_Pricing__c')
        {
            populatePrice_Book_Entry_Scaled_Pricing_Default((Price_Book_Entry_Scaled_Pricing__c)rec);
        }

        if (sObjectType == 'Price_Book_Family__c')
        {
            populatePrice_Book_Family_Default((Price_Book_Family__c)rec);
        }

        if (sObjectType == 'Price_Book_Product_Line__c')
        {
            populatePrice_Book_Product_Line_Default((Price_Book_Product_Line__c)rec);
        }

        if (sObjectType == 'Price_Book_Region__c')
        {
            populatePrice_Book_Region_Default((Price_Book_Region__c)rec);
        }

        if (sObjectType == 'Price_Book_Sales_Org__c')
        {
            populatePrice_Book_Sales_Org_Default((Price_Book_Sales_Org__c)rec);
        }

        if (sObjectType == 'Price_Book_Service__c')
        {
            populatePrice_Book_Service_Default((Price_Book_Service__c)rec);
        }

        if (sObjectType == 'Pricing_Rebate_Configuration__c')
        {
            populatePricing_Rebate_Configuration_Default((Pricing_Rebate_Configuration__c)rec);
        }
    }

    /*******************
    * Account Templates
    ********************/

    private static void populateAccount_Default(Account rec) {
        Integer idx = newUniqueIdx();
        rec.Name = 'Default Test Account' + idx;
        rec.SAP_Zip_Code__c = '43081';
        rec.SAP_Account_Name_2__c = rec.Name + idx;
        rec.AccountNumber = '123' + idx;
        rec.BillingCity = 'City';
        rec.BillingCountry = 'US';
        rec.BillingPostalCode = '99999';
        rec.BillingState = 'OH';
        rec.SAP_Customer_Group_1_Desc__c = 'CustGrp1';
        rec.SAP_Customer_Group_Desc__c = 'CustGrp';
        rec.SAP_DistChannel__c = '10';
        rec.SAP_Dist_Channel_Desc__c = 'AHWT';
        rec.SAP_DivisionCode__c = '11';
        rec.SAP_Division_Desc__c = 'AHWT';
        rec.SAP_Sales_Org__c = '1020';
        rec.SAP_Sales_Org_Desc__c = 'Ashland';
        rec.Account_Number__c = rec.AccountNumber + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
//        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
    }

    private static void populateAccount_TestAccount1(Account rec) {
        rec.Name = 'Test Account 1';
        rec.SAP_Zip_Code__c = '43081';
        rec.SAP_Account_Name_2__c = rec.Name;
        rec.AccountNumber = '123';
        rec.BillingCity = 'City';
        rec.BillingCountry = 'US';
        rec.BillingPostalCode = '99999';
        rec.BillingState = 'OH';
        rec.SAP_Customer_Group_1_Desc__c = 'CustGrp1';
        rec.SAP_Customer_Group_Desc__c = 'CustGrp';
        rec.SAP_DistChannel__c = '10';
        rec.SAP_Dist_Channel_Desc__c = 'AHWT';
        rec.SAP_DivisionCode__c = '11';
        rec.SAP_Division_Desc__c = 'AHWT';
        rec.SAP_Sales_Org__c = '1020';
        rec.SAP_Sales_Org_Desc__c = 'Ashland';
        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
    }

    private static void populateAccount_TestAccount2(Account rec) {
        rec.Name = 'Test Account 2';
    }

    private static void populateAccount_EmptyAccount(Account rec) {
        rec.Name = 'EmptyAccount';
    }

    /*******************
    * Contact Templates
    ********************/

    private static void populateContact_Default(Contact rec) {
        rec.LastName = 'Default Test Contact';
        rec.Email = 'test@test.com';
    }

    private static void populateContact_TestContact1(Contact rec) {
        rec.LastName = 'Test Contact 1';
        rec.Email = 'testcontact1@test.com';
    }

    private static void populateContact_TestContact2(Contact rec) {
        rec.LastName = 'Test Contact 2';
        rec.Email = 'testcontact2@test.com';
    }

    /****************
    * User Templates
    *****************/

    private static void populateUser_Default(User rec) {
        Integer idx = newUniqueIdx();
        rec.LastName = 'Default Test User' + idx;
        rec.Username = 'defaultTestUser' + idx + '@solenis.com.pregolive';
        rec.Email = 'defaultTestUser' + idx + '@solenis.com.pregolive';
        rec.Alias = 'defTU' + idx;
        rec.CommunityNickname = 'defaultTestUser' + idx;
        rec.TimeZoneSidKey = 'America/New_York';
        rec.LocaleSidKey = 'en_US';
        rec.EmailEncodingKey = 'ISO-8859-1';
        rec.LanguageLocaleKey = 'en_US';
        rec.ProfileId = User_Functions.LookupProfileId('System Administrator');
    }

    private static void populateUser_TestUser1(User rec) {
        Integer idx = newUniqueIdx();
        rec.LastName = 'Test User 1' + idx;
        rec.Username = 'testUser1' + idx + '@solenis.com.pregolive';
        rec.Email = 'testUser1' + idx + '@solenis.com.pregolive';
        rec.Alias = 'tu1' + idx;
        rec.CommunityNickname = 'testUser1' + idx;
        rec.TimeZoneSidKey = 'America/New_York';
        rec.LocaleSidKey = 'en_US';
        rec.EmailEncodingKey = 'ISO-8859-1';
        rec.LanguageLocaleKey = 'en_US';
        rec.ProfileId = User_Functions.LookupProfileId('System Administrator');
    }

    private static void populateUser_TestUser2(User rec) {
        Integer idx = newUniqueIdx();
        rec.LastName = 'Test User 2' + idx;
        rec.Username = 'testUser2' + idx + '@solenis.com.pregolive';
        rec.Email = 'testUser2' + idx + '@solenis.com.pregolive';
        rec.Username = 'testUser2' + idx + '@solenis.com.pregolive';
        rec.Email = 'testUser2' + idx + '@solenis.com.pregolive';
        rec.Alias = 'tu2' + idx;
        rec.CommunityNickname = 'testUser2';
        rec.TimeZoneSidKey = 'America/New_York';
        rec.LocaleSidKey = 'en_US';
        rec.EmailEncodingKey = 'ISO-8859-1';
        rec.LanguageLocaleKey = 'en_US';
        rec.ProfileId = User_Functions.LookupProfileId('System Administrator');
    }

    /***********************************
    * Event Templates
    ************************************/

    private static void populateEvent_Default(Event rec) {
        Integer idx = newUniqueIdx();
        rec.StartDateTime = System.today();
        rec.EndDateTime = System.today();
    }

    /*******************************
    * CISRelationships__c Templates
    ********************************/

    private static void populateCISRelationships_Default(CISRelationships__c rec) {
        rec.Customer_Type__c = CISRelationships_Functions.SHIPTO;
    }

    private static void populateCISRelationships_ShipTo(CISRelationships__c rec) {
        rec.Customer_Type__c = CISRelationships_Functions.SHIPTO;
    }

    private static void populateCISRelationships_SoldTo(CISRelationships__c rec) {
        rec.Customer_Type__c = CISRelationships_Functions.SOLDTO;
    }

    /***********************************
    * Material_Sales_Data2__c Templates
    ************************************/

    private static void populateMaterial_Sales_Data2_Default(Material_Sales_Data2__c rec) {
        Integer idx = newUniqueIdx();
        rec.Dist_Channel_Code__c = '11';
        rec.Material_Number__c = '00000111111';
        rec.Record_Key__c = '987654';
        rec.Sales_Org_Code__c = '4321';
    }

    /********************************
    * Pricing_Condition__c Templates
    *********************************/

    private static void populatePricing_Condition_Default(Pricing_Condition__c rec) {
        rec.Valid_From_Date__c = System.today();
        rec.Valid_To_Date__c = rec.Valid_From_Date__c.addDays(30);
        rec.Selling_Price__c = 10.0;
    }

    /***********************************
    * Account_Relationship__c Templates
    ************************************/

    private static void populateAccount_Relationship_Default(Account_Relationship__c rec) {
    }

    /***********************************
    * Account_Sales_Figure__c Templates
    ************************************/

    private static void populateAccount_Sales_Figure_Default(Account_Sales_Figure__c rec) {
         rec.GM__c=5000;
         rec.GMpct__c=5;
         rec.Sales_Amount__c=500000;
         rec.Sales_Volume_in_LBs__c=100000;
         rec.Sales_Volume_in_KGs__c=60000;
         rec.Sales_Volume_in_UNs__c=2000;
         rec.Sales_Volume_in_GALs__c=200;
         rec.Sales_Volume_in_PTs__c=10;
    }

    /***********************************
    * Strategic_Plan__c Templates
    ************************************/

    private static void populateStrategic_Plan_Default(Strategic_Plan__c rec) {
        rec.Strategic_Plan_Name__c = 'name';
    }

    /***********************************
    * Product_Sales_Figure__c Templates
    ************************************/

    private static void populateProduct_Sales_Figure_Default(Product_Sales_Figure__c rec) {
        rec.Billed_Unit_of_Measure__c='LB';
        rec.Billed_Volume__c=100000;
        rec.GM__c=5000;
        rec.GMpct__c=5;
        rec.Month_Year__c=System.today().addMonths(-6);
        rec.Sales_Amount__c=500000;
        rec.Sales_Volume__c=100000;
        rec.Sales_Volume_UOM__c='LB';
    }

    /***********************************
    * Activity_User_Group__c Templates
    ************************************/

    private static void populateActivity_User_Group_Default(Activity_User_Group__c rec) {
    }

    /*************************
    * Competitor__c Templates
    **************************/

    private static void populateCompetitor_Default(Competitor__c rec) {
        rec.Name = 'Test Competitor';
    }

    /************************************
    * Competitor_to_Account__c Templates
    *************************************/

    private static void populateCompetitor_to_Account_Default(Competitor_to_Account__c rec) {
    }

    /***********************
    * Opportunity Templates
    ************************/

    private static void populateOpportunity_Default(Opportunity rec) {
        rec.Name='Test Opportunity';
        rec.StageName='Dead';
        rec.CloseDate=System.today();
        rec.Amount = 100;
    }

    /***********************
    * Opportunity_Material__c Templates
    ************************/

    private static void populateOpportunity_Material_Default(Opportunity_Material__c rec) {
        rec.Sales_Price__c=100.0;
        rec.Quantity__c=10.0;
        rec.Unit_of_Measure__c='LB';
    }

    /****************************************
    * Competitor_to_Opportunity__c Templates
    *****************************************/

    private static void populateCompetitor_to_Opportunity_Default(Competitor_to_Opportunity__c rec) {
    }

    /**********************
    * Pricing__c Templates
    ***********************/

    private static void populatePricing_Default(Pricing__c rec) {
        rec.Comments__c = 'Test Comment';
    }

    /**********************
    * Customer_Product_Info__c Templates
    ***********************/

    private static void populateCustomer_Product_Info_Default(Customer_Product_Info__c rec) {
        Integer idx = newUniqueIdx();
        rec.CPI_Record_Type__c = '1';
        rec.Sales_Org_Code__c = '0000';
        rec.Distribution_Channel_Code__c = '00';
        rec.Material_Number__c = '000000000000000000';
        rec.ShipTo_Number__c = 'ShipTo';
        rec.Customer_Number__c = 'SoldTo';
        rec.Customer_Material_Number__c = '1';
        rec.Record_Key__c = rec.CPI_Record_Type__c + rec.Sales_Org_Code__c + rec.Distribution_Channel_Code__c + rec.Customer_Number__c + rec.ShipTo_Number__c + rec.Customer_Material_Number__c + rec.Material_Number__c + idx;
        rec.Primary_Indicator__c = 'X';
    }

    /**********************
    * SAP_Distribution_Channel__c Templates
    ***********************/

    private static void populateSAP_Distribution_Channel_Default(SAP_Distribution_Channel__c rec) {
        Integer idx = newUniqueIdx();
        rec.Language_Code__c = '!';
        rec.Distribution_Channel_Code__c = '00';
        rec.Distribution_Channel_Description__c = 'testDistChan';
    }

    /**********************
    * SAP_Customer_Group__c Templates
    ***********************/

    private static void populateSAP_Customer_Group_Default(SAP_Customer_Group__c rec) {
        Integer idx = newUniqueIdx();
        rec.Language_Code__c = '!';
        rec.Customer_Group_Code__c = '00';
        rec.Customer_Group_Name__c = 'testCustGroup';
    }

    /**********************
    * SAP_Ultimate_Parent__c Templates
    ***********************/

    private static void populateSAP_Ultimate_Parent_Default(SAP_Ultimate_Parent__c rec) {
        Integer idx = newUniqueIdx();
        rec.Legal_Ultimate_Parent_Number__c = '000000000' + idx;
        rec.Date_Added_in_SAP__c = system.today();
        rec.Date_Changed_in_SAP__c = system.today();
        rec.Legal_Ultimate_Parent_Name__c = 'TEST ULTIMATE PARENT ' + idx;
        rec.User_Who_Added_in_SAP__c = 'User Who Added';
        rec.User_Who_Changed_in_SAP__c = 'User Who Changed';
    }

    /**********************
    * SAP_Customer_Group1__c Templates
    ***********************/

    private static void populateSAP_Customer_Group1_Default(SAP_Customer_Group1__c rec) {
        Integer idx = newUniqueIdx();
        rec.Language_Code__c = '!';
        rec.Customer_Group1_Code__c = '000';
        rec.Customer_Group1_Name__c = 'testCustGroup1';
    }

    /**********************
    * Customer_Group__c Templates
    ***********************/

    private static void populateCustomer_Group_Default(Customer_Group__c rec) {
        Integer idx = newUniqueIdx();
    }

    /**********************
    * Equipment__c Templates
    ***********************/
/*
    private static void populateEquipment_Default(Equipment__c rec) {
        Integer idx = newUniqueIdx();
        rec.Name = 'Test Equip 1';
        rec.Make__c = 'Make';
        rec.Model__c = 'Model';
        rec.Key__c = 'Test Equip Key' + idx;
    }
*/

    /**********************
    * ART_Project__c Templates
    ***********************/

    private static void populateART_Project_Default(ART_Project__c rec) {
        Integer idx = newUniqueIdx();
        rec.Name = 'Test Proj';
    }

    /**********************
    * ART_Request__c Templates
    ***********************/

    private static void populateART_Request_Default(ART_Request__c rec) {
        Integer idx = newUniqueIdx();
        
        Date nextrelease = system.today();
        String DayofWeek = System.now().format('EEEE');
        If(DayofWeek == 'Sunday'){ nextrelease = system.today().adddays(1);} 
        If(DayofWeek == 'Monday'){ nextrelease = system.today().adddays(0);}
        If(DayofWeek == 'Tuesday'){ nextrelease = system.today().adddays(6);}
        If(DayofWeek == 'Wednesday'){ nextrelease = system.today().adddays(5);}
        If(DayofWeek == 'Thursday'){ nextrelease = system.today().adddays(4);}
        If(DayofWeek == 'Friday'){ nextrelease = system.today().adddays(3);}
        If(DayofWeek == 'Saturday'){ nextrelease = system.today().adddays(2);}
        
        rec.Name = 'Test Req';
        rec.Target_Date_for_Release__c = nextrelease;
        rec.Planning_to_Test_in_Sandbox__c = true;
        rec.Planning_to_Build_in_Sanfbox__c = true;
        rec.Request_Date__c = system.today();
        rec.Status__c = 'Approved for Release';
    }

    /**********************
    * ART_Release__c Templates
    ***********************/

    private static void populateART_Release_Default(ART_Release__c rec) {
        Integer idx = newUniqueIdx();
    }

    /**********************
    * Lead Templates
    ***********************/

    private static void populateLead_Default(Lead rec) {
        Integer idx = newUniqueIdx();
        rec.FirstName = 'First';
        rec.LastName = 'Last';
        rec.Company = 'Company';
    }

    /**********************
    * SAP_Sales_Org__c Templates
    ***********************/

    private static void populateSAP_Sales_Org_Default(SAP_Sales_Org__c rec) {
        Integer idx = newUniqueIdx();
        rec.Sales_Org_Code__c = '1020';
        rec.Sales_Org_Description__c = 'test Sales Org';
        rec.Language_Code__c = 'E';
    }

    /**********************
    * SAP_Sales_Division__c Templates
    ***********************/

    private static void populateSAP_Sales_Division_Default(SAP_Sales_Division__c rec) {
        Integer idx = newUniqueIdx();
        rec.Sales_Division_Code__c = '00';
        rec.Sales_Division_Description__c = 'test Division';
        rec.Language_Code__c = 'E';
    }

    /**********************
    * Material_General_Data__c Templates
    ***********************/

    private static void populateMaterial_General_Data_Default(Material_General_Data__c rec) {
        Integer idx = newUniqueIdx();
        rec.Gross_Weight__c = 1.075;
        rec.Net_Weight__c = 1.000;
        rec.Base_UOM__c = 'ABC';
    }

    /**********************
    * SAP_Country_Name__c Templates
    ***********************/

    private static void populateSAP_Country_Name_Default(SAP_Country_Name__c rec) {
        Integer idx = newUniqueIdx();
        rec.Country_Code__c = '00';
        rec.Country_Name__c = 'test Country';
        rec.Language_Code__c = 'E';
    }

    /**********************
    * Price_Book__c Templates
    ***********************/

    private static void populatePrice_Book_Default(Price_Book__c rec) {
        Integer idx = newUniqueIdx();
        rec.Active__c = true;
        rec.Description__c = 'test Price Book';
//      rec.Dist_Channel__c = '10';
//      rec.Division__c = '11';
        rec.Effective_Date__c = System.today().addDays(-30);
        rec.Record_Status__c = 'Active';
    }

    /**********************
    * Price_Book_Customer_Group__c Templates
    ***********************/

    private static void populatePrice_Book_Customer_Group_Default(Price_Book_Customer_Group__c rec) {
        Integer idx = newUniqueIdx();
    }

    /**********************
    * Price_Book_Family__c Templates
    ***********************/

    private static void populatePrice_Book_Family_Default(Price_Book_Family__c rec) {
        Integer idx = newUniqueIdx();
        rec.Family_Code__c = '000';
    }

    /**********************
    * Price_Book_Product_Line__c Templates
    ***********************/

    private static void populatePrice_Book_Product_Line_Default(Price_Book_Product_Line__c rec) {
        Integer idx = newUniqueIdx();
        rec.Product_Line_Code__c = '000';
        rec.Product_Line_Desc__c = 'test ProdLine';
    }

    /**********************
    * Price_Book_Region__c Templates
    ***********************/

    private static void populatePrice_Book_Region_Default(Price_Book_Region__c rec) {
        Integer idx = newUniqueIdx();
    }

    /**********************
    * Price_Book_Sales_Org__c Templates
    ***********************/

    private static void populatePrice_Book_Sales_Org_Default(Price_Book_Sales_Org__c rec) {
        Integer idx = newUniqueIdx();
    }

    /**********************
    * Price_Book_Entry__c Templates
    ***********************/

    private static void populatePrice_Book_Entry_Default(Price_Book_Entry__c rec) {
        Integer idx = newUniqueIdx();
        rec.Bulk_Minimum_Order_Quantity__c = 1000.0;
        rec.GPPct__c = 20.0;
    }

    /**********************
    * Price_Book_Entry_Scaled_Pricing__c Templates
    ***********************/

    private static void populatePrice_Book_Entry_Scaled_Pricing_Default(Price_Book_Entry_Scaled_Pricing__c rec) {
        Integer idx = newUniqueIdx();
        rec.Floor_Price__c = 10.0;
        rec.Maximum_Volume__c = 1000.0;
        rec.Minimum_Volume__c = 100.0;
        rec.Pricing_UOM__c = 'KG';
        rec.Selling_Price__c = 20.0;
        rec.Surcharge__c = 10.0;
        rec.Volume_UOM__c = 'LB';
    }
    
    /**********************
    * Price_Book_Service__c Templates
    ***********************/

    private static void populatePrice_Book_Service_Default(Price_Book_Service__c rec) {
        Integer idx = newUniqueIdx();
        rec.Service_Cost__c = 1000.0;
        rec.Service_Type__c = 'service Type';
        rec.Service_UOM__c = 'per Hour';
    }

    /**********************
    * Pricing_Rebate_Configuration__c Templates
    ***********************/

    private static void populatePricing_Rebate_Configuration_Default(Pricing_Rebate_Configuration__c rec) {
        Integer idx = newUniqueIdx();
        rec.Sales_Org__c = '1234';
        rec.Dist_Channel__c = '10';
        rec.Rebate_Agreement_Type__c = 'Z020';
        rec.Rebate_Agreement_Description__c = 'Cust/Matl Rebate';
        rec.Condition_Type__c = 'Z020';
        rec.Condition_Type_Desc__c = 'Cust/MatlRebUn/Qty';
        rec.Table__c = 'A902';
        rec.Table_Description__c = 'SOrg/DC/Sold To/Matl';
    }
}