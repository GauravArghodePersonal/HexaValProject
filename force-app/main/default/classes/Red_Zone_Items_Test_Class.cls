// Author: AWT Sys Admin
// Created Date : 4/22/2014 5:47 PM
// Last Modified By :  Srinivasan Muthu (TechMahindra)
// Last Modified Date: 19/02/2015

@isTest
private class Red_Zone_Items_Test_Class
{
    static List<String> objectNames = new List<String>{
        'account',
        'contact',
        'shipping_instruction__c',
        'shipping_instruction_product__c',
        'label_request__c',
        'tank_requirement__c',
        'tank_inspection__c',
        'request_for_traffic_service__c'
    };
    static Map<String, Map<String, Id>> rtmaps = RecordType_Functions.getRecordTypeNameMap(objectNames);
    static Map<String, Id> account_rtmap = rtmaps.get('account');
    static Map<String, Id> contact_rtmap = rtmaps.get('contact');
    static Map<String, Id> shpinst_rtmap = rtmaps.get('shipping_instruction__c');
    static Map<String, Id> shpinsp_rtmap = rtmaps.get('shipping_instruction_product__c');
    static Map<String, Id> lblrqst_rtmap = rtmaps.get('label_request__c');
    static Map<String, Id> tankrqm_rtmap = rtmaps.get('tank_requirement__c');
    static Map<String, Id> tankins_rtmap = rtmaps.get('tank_inspection__c');
    static Map<String, Id> trfcsvc_rtmap = rtmaps.get('request_for_traffic_service__c');

    static testMethod void myUnitTest()
    {
        // TO DO: implement unit test
        //Creating test Water Prospect, Drew Customer & Vendor accounts
        List<Account> accs = new List<Account>();

        Account testWaterProsAcc = new Account();
        //testWaterProsAcc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Water Prospect', 'Account');
        testWaterProsAcc.RecordTypeId = account_rtmap.get('Water Prospect');
        testWaterProsAcc.Name = 'Test Water Prospect Account';
        testWaterProsAcc.SAP_Street__c = 'Test Street';
        testWaterProsAcc.SAP_StreetSuppl1__c = 'Test Street1';
        testWaterProsAcc.SAP_StreetSuppl2__c = 'Test Street2';
        testWaterProsAcc.SAP_StreetSuppl3__c = 'Test Street3';
        testWaterProsAcc.SAP_City__c = 'Test City';
        testWaterProsAcc.SAP_State__c = 'Test State';
        testWaterProsAcc.SAP_Zip_Code__c = '626001';
        testWaterProsAcc.SAP_Country__c = 'Test Country';
        testWaterProsAcc.Type = 'Prospect';
        testWaterProsAcc.Rating = 'Warm';
        testWaterProsAcc.Phone = '1234567890';
        testWaterProsAcc.SAP_Division_Desc__c = 'Water Technology';
        testWaterProsAcc.SAP_Sales_District_Desc__c = 'AMERICAS';
        testWaterProsAcc.SAP_Sales_Office_Desc__c = 'RBT NORTHEAST US';
        testWaterProsAcc.SAP_Sales_Group_Desc__c = 'LCT MID-ATLANTIC';
        testWaterProsAcc.SAP_Customer_Group_Desc__c = 'C&I';
        testWaterProsAcc.SAP_Customer_Group_1_Desc__c = 'AGENTS';
        testWaterProsAcc.SAP_Customer_Group_2_Desc__c = 'C&I GOVERNMENT';

        accs.add(testWaterProsAcc);

        Account testDrewCustAcc = new Account();
        //testDrewCustAcc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Drew Customer', 'Account');
        testDrewCustAcc.RecordTypeId = account_rtmap.get('Drew Customer');
        testDrewCustAcc.Name = 'Test Drew Customer Account';
        testDrewCustAcc.SAP_Street__c = 'Test Street';
        testDrewCustAcc.SAP_StreetSuppl1__c = 'Test Street1';
        testDrewCustAcc.SAP_StreetSuppl2__c = 'Test Street2';
        testDrewCustAcc.SAP_StreetSuppl3__c = 'Test Street3';
        testDrewCustAcc.SAP_City__c = 'Test City';
        testDrewCustAcc.SAP_State__c = 'Test State';
        testDrewCustAcc.SAP_Zip_Code__c = '626001';
        testDrewCustAcc.SAP_Country__c = 'Test Country';
        testDrewCustAcc.Type = 'Customer';
        testDrewCustAcc.W_Key_Account__c = 'Yes';
        testDrewCustAcc.W_Total_Account_Potential_yr__c = 10000;
        testDrewCustAcc.SAP_Customer_Number__c = '123456';

        accs.add(testDrewCustAcc);

        Account testVendorAcc = new Account();
        //testVendorAcc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Vendor', 'Account');
        testVendorAcc.RecordTypeId = account_rtmap.get('Vendor');
        testVendorAcc.Name = 'Test Vendor Account';
        testVendorAcc.SAP_Street__c = 'Test Street';
        testVendorAcc.SAP_StreetSuppl1__c = 'Test Street1';
        testVendorAcc.SAP_StreetSuppl2__c = 'Test Street2';
        testVendorAcc.SAP_StreetSuppl3__c = 'Test Street3';
        testVendorAcc.SAP_City__c = 'Test City';
        testVendorAcc.SAP_State__c = 'Test State';
        testVendorAcc.SAP_Zip_Code__c = '626001';
        testVendorAcc.SAP_Country__c = 'Test Country';
        testVendorAcc.Type = 'Vendor';
        testVendorAcc.SAP_Customer_Number__c = '123456';

        accs.add(testVendorAcc);

        insert accs;

        //Creating test Water contacts for primary and secondary contacts
        List<Contact> cons = new List<Contact>();

        Contact primaryCon = new Contact();
        //primaryCon.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Water Contact', 'Contact');
        primaryCon.RecordTypeId = contact_rtmap.get('Water Contact');
        primaryCon.Salutation = 'Mr.';
        primaryCon.FirstName = 'Test';
        primaryCon.LastName = 'Test Primary Water Contact';
        primaryCon.AccountId = accs[0].Id;
        primaryCon.WV_Contact_Status__c = 'Active';
        primaryCon.Phone = '1234567890';
        primaryCon.W_Decision_Maker_Type__c = 'Decision Maker';

        cons.add(primaryCon);

        Contact secondaryCon = new Contact();
        //secondaryCon.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Water Contact', 'Contact');
        secondaryCon.RecordTypeId = contact_rtmap.get('Water Contact');
        secondaryCon.Salutation = 'Mr.';
        secondaryCon.FirstName = 'Test';
        secondaryCon.LastName = 'Test Secondary Water Contact';
        secondaryCon.AccountId = accs[0].Id;
        secondaryCon.WV_Contact_Status__c = 'Active';
        secondaryCon.Phone = '1234567890';
        secondaryCon.W_Decision_Maker_Type__c = 'Decision Maker';

        cons.add(secondaryCon);

        insert cons;

        //Creating test Shipping Instructions  for each of the test accounts
        List<Shipping_Instruction__c> listShpIns = new List<Shipping_Instruction__c>();

        Shipping_Instruction__c testShpIns1 = new Shipping_Instruction__c();
        testShpIns1.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New', 'Shipping_Instruction__c');
        testShpIns1.RecordTypeId = shpinst_rtmap.get('New');
        testShpIns1.Account__c = accs[0].Id;
        testShpIns1.Status__c = 'Draft';
        testShpIns1.Primary_Contact__c = cons[0].Id;
        testShpIns1.Secondary_Contact__c = cons[1].Id;
        testShpIns1.Is_Contact_with_Main_Contact_Mandatory__c = 'Yes';
        testShpIns1.Is_Delivery_Appointment_Necessary__c = 'Yes';
        testShpIns1.Delivery_Days_Hours__c = 'Monday, Wednesday and Friday from 8 a.m. to 5 p.m.';
        testShpIns1.Are_there_3rd_Party_products__c = 'Yes';
        testShpIns1.Is_there_an_UltraServ_program__c = 'Yes';
        testShpIns1.Photo_ID_Required__c = 'Yes';
        testShpIns1.Certificate_of_Analysis_Required__c = 'Yes';
        testShpIns1.Certificate_of_Analysis_attention__c = 'Test Certificate';
        testShpIns1.How_much_advance_notice__c = 'Test Notice';

        listShpIns.add(testShpIns1);

        Shipping_Instruction__c testShpIns2 = new Shipping_Instruction__c();
        testShpIns2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New', 'Shipping_Instruction__c');
        testShpIns2.RecordTypeId = shpinst_rtmap.get('New');
        testShpIns2.Account__c = accs[1].Id;
        testShpIns2.Status__c = 'Draft';
        testShpIns2.Primary_Contact__c = cons[0].Id;
        testShpIns2.Secondary_Contact__c = cons[1].Id;
        testShpIns2.Is_Contact_with_Main_Contact_Mandatory__c = 'Yes';
        testShpIns2.Is_Delivery_Appointment_Necessary__c = 'Yes';
        testShpIns2.Delivery_Days_Hours__c = 'Monday, Wednesday and Friday from 8 a.m. to 5 p.m.';
        testShpIns2.Are_there_3rd_Party_products__c = 'Yes';
        testShpIns2.Is_there_an_UltraServ_program__c = 'Yes';
        testShpIns2.Photo_ID_Required__c = 'Yes';
        testShpIns2.Certificate_of_Analysis_Required__c = 'Yes';
        testShpIns2.Certificate_of_Analysis_attention__c = 'Test Certificate';
        testShpIns2.How_much_advance_notice__c = 'Test Notice';

        listShpIns.add(testShpIns2);

        Shipping_Instruction__c testShpIns3 = new Shipping_Instruction__c();
        //testShpIns3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New', 'Shipping_Instruction__c');
        testShpIns3.RecordTypeId = shpinst_rtmap.get('New');
        testShpIns3.Account__c = accs[2].Id;
        testShpIns3.Status__c = 'Draft';
        testShpIns3.Primary_Contact__c = cons[0].Id;
        testShpIns3.Secondary_Contact__c = cons[1].Id;
        testShpIns3.Is_Contact_with_Main_Contact_Mandatory__c = 'Yes';
        testShpIns3.Is_Delivery_Appointment_Necessary__c = 'Yes';
        testShpIns3.Delivery_Days_Hours__c = 'Monday, Wednesday and Friday from 8 a.m. to 5 p.m.';
        testShpIns3.Are_there_3rd_Party_products__c = 'Yes';
        testShpIns3.Is_there_an_UltraServ_program__c = 'Yes';
        testShpIns3.Photo_ID_Required__c = 'Yes';
        testShpIns3.Certificate_of_Analysis_Required__c = 'Yes';
        testShpIns3.Certificate_of_Analysis_attention__c = 'Test Certificate';
        testShpIns3.How_much_advance_notice__c = 'Test Notice';

        listShpIns.add(testShpIns3);

        insert listShpIns;

        //Creating test Product/Material for test Water Prospect account
        CIS_Materials__c mtrl = new CIS_Materials__c();
        mtrl.Name = 'Test Material';
        mtrl.Material_Holder_Account__c = accs[0].Id;

        insert mtrl;

        //Creating test Shipping Instruction Products for all record types
        List<Shipping_Instruction_Product__c> listShpInsProd = new List<Shipping_Instruction_Product__c>();

        Shipping_Instruction_Product__c testShpInsProd1 = new Shipping_Instruction_Product__c();
        testShpInsProd1.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Bulk (3rd-Party)', 'Shipping_Instruction_Product__c');
        testShpInsProd1.RecordTypeId = shpinsp_rtmap.get('Bulk (3rd-Party)');
        testShpInsProd1.Shipping_Instruction__c = listShpIns[0].Id;
        testShpInsProd1.Account__c = accs[0].Id;
        testShpInsProd1.Status__c = 'New';
        testShpInsProd1.Program__c = 'Bulk (3rd-Party)';
        testShpInsProd1.CIS_Materials__c = mtrl.Id;
        testShpInsProd1.Req_driver_personal_protect_safety_equip__c = 'MSDS Requirements';
        testShpInsProd1.Trailer_type__c = 'Rear Unloader';
        testShpInsProd1.DREW_weight_ticket_required__c = 'Yes';
        testShpInsProd1.Multiple_drops_of_the_same_product_req_d__c = 'Yes';
        testShpInsProd1.Transfer_method__c = 'Air';
        testShpInsProd1.Fill_line_connection_size__c = 'Other';
        testShpInsProd1.Fill_line_fitting__c = 'Quick Connect';
        testShpInsProd1.Hose_length_size_required__c = 'Other';

        listShpInsProd.add(testShpInsProd1);

        Shipping_Instruction_Product__c testShpInsProd2 = new Shipping_Instruction_Product__c();
        testShpInsProd2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Bulk (Regular)', 'Shipping_Instruction_Product__c');
        testShpInsProd2.RecordTypeId = shpinsp_rtmap.get('Bulk (Regular)');
        testShpInsProd2.Shipping_Instruction__c = listShpIns[0].Id;
        testShpInsProd2.Account__c = accs[0].Id;
        testShpInsProd2.Status__c = 'New';
        testShpInsProd2.Program__c = 'Bulk (Regular)';
        testShpInsProd2.CIS_Materials__c = mtrl.Id;
        testShpInsProd2.Req_driver_personal_protect_safety_equip__c = 'MSDS Requirements';
        testShpInsProd2.Trailer_type__c = 'Rear Unloader';
        testShpInsProd2.DREW_weight_ticket_required__c = 'Yes';
        testShpInsProd2.Multiple_drops_of_the_same_product_req_d__c = 'Yes';
        testShpInsProd2.Transfer_method__c = 'Air';
        testShpInsProd2.Fill_line_connection_size__c = 'Other';
        testShpInsProd2.Fill_line_fitting__c = 'Quick Connect';
        testShpInsProd2.Hose_length_size_required__c = 'Other';

        listShpInsProd.add(testShpInsProd2);

        Shipping_Instruction_Product__c testShpInsProd3 = new Shipping_Instruction_Product__c();
        testShpInsProd3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Packaged Goods', 'Shipping_Instruction_Product__c');
        testShpInsProd3.RecordTypeId = shpinsp_rtmap.get('Packaged Goods');
        testShpInsProd3.Shipping_Instruction__c = listShpIns[0].Id;
        testShpInsProd3.Account__c = accs[0].Id;
        testShpInsProd3.Status__c = 'New';
        testShpInsProd3.Program__c = 'Packaged Goods';
        testShpInsProd3.CIS_Materials__c = mtrl.Id;
        testShpInsProd3.Is_hydraulic_liftgate_delivery_required__c = 'Yes';
        testShpInsProd3.Forklift_on_site__c = 'Yes';
        testShpInsProd3.Palletizing_required__c = 'Yes';
        testShpInsProd3.Stretch_wrapping_required__c = 'Yes';

        listShpInsProd.add(testShpInsProd3);

        Shipping_Instruction_Product__c testShpInsProd4 = new Shipping_Instruction_Product__c();
        testShpInsProd4.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Packaged Goods (3rd-Party)', 'Shipping_Instruction_Product__c');
        testShpInsProd4.RecordTypeId = shpinsp_rtmap.get('Packaged Goods (3rd-Party)');
        testShpInsProd4.Shipping_Instruction__c = listShpIns[0].Id;
        testShpInsProd4.Account__c = accs[0].Id;
        testShpInsProd4.Status__c = 'New';
        testShpInsProd4.Program__c = 'Packaged Goods (3rd-Party)';
        testShpInsProd4.CIS_Materials__c = mtrl.Id;
        testShpInsProd4.Is_hydraulic_liftgate_delivery_required__c = 'Yes';
        testShpInsProd4.Forklift_on_site__c = 'Yes';
        testShpInsProd4.Palletizing_required__c = 'Yes';
        testShpInsProd4.Stretch_wrapping_required__c = 'Yes';

        listShpInsProd.add(testShpInsProd4);

        Shipping_Instruction_Product__c testShpInsProd5 = new Shipping_Instruction_Product__c();
        testShpInsProd5.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Pro-Serv', 'Shipping_Instruction_Product__c');
        testShpInsProd5.RecordTypeId = shpinsp_rtmap.get('Pro-Serv');
        testShpInsProd5.Shipping_Instruction__c = listShpIns[0].Id;
        testShpInsProd5.Account__c = accs[0].Id;
        testShpInsProd5.Status__c = 'New';
        testShpInsProd5.Program__c = 'Pro-Serv';
        testShpInsProd5.CIS_Materials__c = mtrl.Id;
        testShpInsProd5.Req_driver_personal_protect_safety_equip__c = 'MSDS Requirements';
        testShpInsProd5.Trailer_type__c = 'Rear Unloader';
        testShpInsProd5.DREW_weight_ticket_required__c = 'Yes';
        testShpInsProd5.Multiple_drops_of_the_same_product_req_d__c = 'Yes';
        testShpInsProd5.Transfer_method__c = 'Air';
        testShpInsProd5.Fill_line_connection_size__c = 'Other';
        testShpInsProd5.Fill_line_fitting__c = 'Quick Connect';
        testShpInsProd5.Hose_length_size_required__c = 'Other';

        listShpInsProd.add(testShpInsProd5);

        Shipping_Instruction_Product__c testShpInsProd6 = new Shipping_Instruction_Product__c();
        testShpInsProd6.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Ultra-Serv', 'Shipping_Instruction_Product__c');
        testShpInsProd6.RecordTypeId = shpinsp_rtmap.get('Ultra-Serv');
        testShpInsProd6.Shipping_Instruction__c = listShpIns[0].Id;
        testShpInsProd6.Account__c = accs[0].Id;
        testShpInsProd6.Status__c = 'New';
        testShpInsProd6.Program__c = 'Ultra-Serv';
        testShpInsProd6.CIS_Materials__c = mtrl.Id;
        testShpInsProd6.Req_driver_personal_protect_safety_equip__c = 'MSDS Requirements';
        testShpInsProd6.Is_115V_grounded_outlet_w_in_10_of_tank__c = 'Yes';
        testShpInsProd6.Can_drum_be_safely_wheeled_to_tank__c ='Yes';
        testShpInsProd6.Does_driver_have_access_w_in_8_of_tank__c = 'Yes';
        testShpInsProd6.Safety_shower_eyewash_w_in_75_of_del__c = 'Yes';

        listShpInsProd.add(testShpInsProd6);

        insert listShpInsProd;
        
        //Last modified the test Class due to validation rule in Label Request Object for incidence #711057 
        // Line Number:319,333,343
        //Creating test Label Requests for each of the test accounts
        List<Label_Request__c> listLabelReq = new List<Label_Request__c>();

        Label_Request__c testLabelReq1 = new Label_Request__c();
        testLabelReq1.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Draft', 'Label_Request__c');
        testLabelReq1.RecordTypeId = lblrqst_rtmap.get('Draft');
        testLabelReq1.Delivery_Method__c = 'Standard Delivery';
        testLabelReq1.Status__c = 'Draft';
        testLabelReq1.Customer_Prospect__c = accs[0].Id;
        testLabelReq1.Contact__c = cons[0].Id;
        testLabelReq1.CIS_Materials__c = mtrl.Id;
        testLabelReq1.Program_Type__c = 'Solenis Label Covers';

        listLabelReq.add(testLabelReq1);

        Label_Request__c testLabelReq2 = new Label_Request__c();
        testLabelReq2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Draft', 'Label_Request__c');
        testLabelReq2.RecordTypeId = lblrqst_rtmap.get('Draft');
        testLabelReq2.Delivery_Method__c = 'Standard Delivery';
        testLabelReq2.Status__c = 'Draft';
        testLabelReq2.Customer_Prospect__c = accs[1].Id;
        testLabelReq2.Contact__c = cons[0].Id;
        testLabelReq2.CIS_Materials__c = mtrl.Id;
        testLabelReq2.Program_Type__c = 'Solenis Label Covers';

        listLabelReq.add(testLabelReq2);

        Label_Request__c testLabelReq3 = new Label_Request__c();
        testLabelReq3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Draft', 'Label_Request__c');
        testLabelReq3.RecordTypeId = lblrqst_rtmap.get('Draft');
        testLabelReq3.Delivery_Method__c = 'Standard Delivery';
        testLabelReq3.Status__c = 'Draft';
        testLabelReq3.Customer_Prospect__c = accs[2].Id;
        testLabelReq3.Contact__c = cons[0].Id;
        testLabelReq3.CIS_Materials__c = mtrl.Id;
        testLabelReq3.Program_Type__c = 'Solenis Label Covers';

        listLabelReq.add(testLabelReq3);

        insert listLabelReq;

        //Creating test Tank Requests for each of the test accounts
        List<Tank_Requirement__c> listTankReq = new List<Tank_Requirement__c>();

        Tank_Requirement__c testTankReq1 = new Tank_Requirement__c();
        testTankReq1.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New Order', 'Tank_Requirement__c');
        testTankReq1.RecordTypeId = tankrqm_rtmap.get('New Order');
        testTankReq1.Customer_Prospect__c = accs[0].Id;
        testTankReq1.Status__c = 'New';
        testTankReq1.Program_Type__c = 'Pro-Serv';
        testTankReq1.CIS_Materials__c = mtrl.Id;
        testTankReq1.Tank_Status__c = 'New Order';
        testTankReq1.Type__c = 'Bulk Tank';
        testTankReq1.Model__c = 'PE-500V';
        testTankReq1.Product_Change__c = 'Yes';
        testTankReq1.Number_of_Tanks__c = '10';
        testTankReq1.Heat_Traced_or_Insulated__c = 'Yes';
        testTankReq1.Tank_Orientation__c = 'Vertical';
        testTankReq1.Contact__c = cons[0].Id;

        listTankReq.add(testTankReq1);

        Tank_Requirement__c testTankReq2 = new Tank_Requirement__c();
        testTankReq2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New Order', 'Tank_Requirement__c');
        testTankReq2.RecordTypeId = tankrqm_rtmap.get('New Order');
        testTankReq2.Customer_Prospect__c = accs[1].Id;
        testTankReq2.Status__c = 'New';
        testTankReq2.Program_Type__c = 'Pro-Serv';
        testTankReq2.CIS_Materials__c = mtrl.Id;
        testTankReq2.Tank_Status__c = 'New Order';
        testTankReq2.Type__c = 'Bulk Tank';
        testTankReq2.Model__c = 'PE-500V';
        testTankReq2.Product_Change__c = 'Yes';
        testTankReq2.Number_of_Tanks__c = '10';
        testTankReq2.Heat_Traced_or_Insulated__c = 'Yes';
        testTankReq2.Tank_Orientation__c = 'Vertical';
        testTankReq2.Contact__c = cons[0].Id;

        listTankReq.add(testTankReq2);

        Tank_Requirement__c testTankReq3 = new Tank_Requirement__c();
        testTankReq3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New Order', 'Tank_Requirement__c');
        testTankReq3.RecordTypeId = tankrqm_rtmap.get('New Order');
        testTankReq3.Customer_Prospect__c = accs[2].Id;
        testTankReq3.Status__c = 'New';
        testTankReq3.Program_Type__c = 'Pro-Serv';
        testTankReq3.CIS_Materials__c = mtrl.Id;
        testTankReq3.Tank_Status__c = 'New Order';
        testTankReq3.Type__c = 'Bulk Tank';
        testTankReq3.Model__c = 'PE-500V';
        testTankReq3.Product_Change__c = 'Yes';
        testTankReq3.Number_of_Tanks__c = '10';
        testTankReq3.Heat_Traced_or_Insulated__c = 'Yes';
        testTankReq3.Tank_Orientation__c = 'Vertical';
        testTankReq3.Contact__c = cons[0].Id;

        listTankReq.add(testTankReq3);

        insert listTankReq;

        //Creating test Tank Assessment for test Water Prospect account
        List<Tank_Inspection__c> listTankAssess = new List<Tank_Inspection__c>();

        Tank_Inspection__c testTankAssess = new Tank_Inspection__c();
        testTankAssess.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New', 'Tank_Inspection__c');
        testTankAssess.RecordTypeId = tankins_rtmap.get('New');
        testTankAssess.Customer_Prospect__c = accs[0].Id;
        testTankAssess.Status__c = 'New';
        testTankAssess.CIS_Materials__c = mtrl.Id;
        testTankAssess.Tank_Model__c = 'Test Model';
        testTankAssess.Tank_Status__c = 'New Order';
        testTankAssess.Tank_Type__c = 'Bulk Tank';
        testTankAssess.Material_Construction__c = 'Test Material Construction';
        testTankAssess.Tank_Location__c = 'Indoors';
//        testTankAssess.Tank_Capacity__c = 'Test Tank Capacity';
        testTankAssess.Product_Change__c = 'Yes';
        testTankAssess.Tank_Asset_Number__c = 'Test Tank Asset Number';
        testTankAssess.Orientation__c = 'Vertical';
        testTankAssess.Is_HMIS_sign_product_label_visible__c = 'Yes';
        testTankAssess.Fill_line_tag_visible_during_delivery__c = 'Yes';
        testTankAssess.Does_the_tank_have_a_fill_line_installed__c = 'No';
        testTankAssess.Was_tank_hydrostatically_tested__c = 'Yes';
        testTankAssess.Are_there_any_leaks_to_the_tank_piping__c = 'Yes';
        testTankAssess.Any_cracks_dents_spider_cracks_to_tank__c = 'Yes';
        testTankAssess.Is_there_any_evidence_of_tank_bulging__c = 'Yes';
        testTankAssess.Does_tank_req_registration_PA_NY_MN_FL__c = 'No';
        testTankAssess.Is_vent_in_place_and_checked__c = 'Yes';
        testTankAssess.Safety_spill_procedures_reviewed_w_Cust__c = 'Yes';
        testTankAssess.Is_the_tank_stand_deteriorating__c = 'Yes';
        testTankAssess.Any_discoloration_of_the_tank_exterior__c = 'Yes';
        testTankAssess.Is_eye_wash_installed_within_75_ft__c = 'Yes';
        testTankAssess.Is_safety_shower_installed_in_75_ft__c = 'Yes';
        testTankAssess.Is_a_level_gauge_installed_on_the_tank__c = 'Yes';
        testTankAssess.Is_level_gauge_functional__c = 'Yes';
        testTankAssess.Type_gauge__c = 'External Sight';
        testTankAssess.Is_tank_heat_traced_insulated__c = 'Yes';
        testTankAssess.Has_tank_insulation_been_compromised__c = 'No';
        testTankAssess.Does_heat_trace_thermostat_operate__c = 'Yes';
        testTankAssess.Is_tank_in_a_containment_basin__c = 'Yes';
        testTankAssess.If_yes_what_are_the_dimensions__c = 'test';
        testTankAssess.What_is_cont_basin_material_of_const__c = 'Test';
        testTankAssess.Any_defects_in_the_containment_basin__c = 'Yes';
        testTankAssess.If_Yes_Explain__c  = 'Test';
        testTankAssess.Any_defects_with_tank_hose_assembly__c = 'Yes';
        testTankAssess.Problems_with_stackable_container_sys__c = 'Yes';
        testTankAssess.Was_tank_compatibility_checked__c = 'Yes';
        testTankAssess.Was_tank_thoroughly_washed_and_dried__c = 'Yes';
        testTankAssess.Was_customer_Profile_updated__c = 'Yes';
        testTankAssess.Tank_Requirement_Number__c = testTankReq1.Id;

        listTankAssess.add(testTankAssess);

        insert listTankAssess;

        //Creating test Request for Traffic Service Carrier record to associate with Request for Traffic Service
        Request_for_Traffic_Service_Carrier__c testReqTraffServCarrier = new Request_for_Traffic_Service_Carrier__c();
        testReqTraffServCarrier.Name = 'Test Request for Traffice Service Carrier';
        testReqTraffServCarrier.Address__c = 'Test Address';
        testReqTraffServCarrier.City__c = 'Test City';
        testReqTraffServCarrier.Contact_First_Name__c = 'Test Contact First Name';
        testReqTraffServCarrier.Contact_Last_Name__c = 'Test Contact Last Name';
        testReqTraffServCarrier.Contact_Phone_Number__c = '1234567890';
        testReqTraffServCarrier.Postal_Code__c = '626001';
        testReqTraffServCarrier.State__c = 'Test State';
        testReqTraffServCarrier.Vendor_Number__c = '123456';

        insert testReqTraffServCarrier;

        //Creating test Request for Traffic Services for each of the test accounts
        List<Request_for_Traffic_Service__c> listReqTraffServ = new List<Request_for_Traffic_Service__c>();

        Request_for_Traffic_Service__c testReqTraffServ1 = new Request_for_Traffic_Service__c();
        //testReqTraffServ1.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New', 'Request_for_Traffic_Service__c');
        testReqTraffServ1.RecordTypeId = trfcsvc_rtmap.get('New');
        testReqTraffServ1.Status__c = 'New';
        testReqTraffServ1.Ship_From_Account__c = accs[0].Id;
        testReqTraffServ1.Ship_From_Contact__c = cons[0].Id;
        testReqTraffServ1.Bill_Charges_To__c = 'Customer';
        testReqTraffServ1.Ship_To_Account__c = accs[0].Id;
        testReqTraffServ1.Ship_To_Contact__c = cons[0].Id;
        testReqTraffServ1.Request_for_Traffic_Service_Carrier__c = testReqTraffServCarrier.Id;

        listReqTraffServ.add(testReqTraffServ1);

        Request_for_Traffic_Service__c testReqTraffServ2 = new Request_for_Traffic_Service__c();
        //testReqTraffServ2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New', 'Request_for_Traffic_Service__c');
        testReqTraffServ2.RecordTypeId = trfcsvc_rtmap.get('New');
        testReqTraffServ2.Status__c = 'New';
        testReqTraffServ2.Ship_From_Account__c = accs[1].Id;
        testReqTraffServ2.Ship_From_Contact__c = cons[0].Id;
        testReqTraffServ2.Bill_Charges_To__c = 'Customer';
        testReqTraffServ2.Ship_To_Account__c = accs[1].Id;
        testReqTraffServ2.Ship_To_Contact__c = cons[0].Id;
        testReqTraffServ2.Request_for_Traffic_Service_Carrier__c = testReqTraffServCarrier.Id;

        listReqTraffServ.add(testReqTraffServ2);

        Request_for_Traffic_Service__c testReqTraffServ3 = new Request_for_Traffic_Service__c();
        //testReqTraffServ3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('New', 'Request_for_Traffic_Service__c');
        testReqTraffServ3.RecordTypeId = trfcsvc_rtmap.get('New');
        testReqTraffServ3.Status__c = 'New';
        testReqTraffServ3.Ship_From_Account__c = accs[2].Id;
        testReqTraffServ3.Ship_From_Contact__c = cons[0].Id;
        testReqTraffServ3.Bill_Charges_To__c = 'Customer';
        testReqTraffServ3.Ship_To_Account__c = accs[2].Id;
        testReqTraffServ3.Ship_To_Contact__c = cons[0].Id;
        testReqTraffServ3.Request_for_Traffic_Service_Carrier__c = testReqTraffServCarrier.Id;

        listReqTraffServ.add(testReqTraffServ3);

        insert listReqTraffServ;


        //Testing all the methods in UpdateShipInstrn Apex Class using the test data for Shipping Instruction
        ApexPages.Standardcontroller testStdController1 = new ApexPages.Standardcontroller(listShpIns[0]);
        ApexPages.Standardcontroller testStdController2 = new ApexPages.Standardcontroller(listShpIns[1]);
        ApexPages.Standardcontroller testStdController3 = new ApexPages.Standardcontroller(listShpIns[2]);

        UpdateShipInstrn shpIns1 = new UpdateShipInstrn(testStdController1);
        UpdateShipInstrn shpIns2 = new UpdateShipInstrn(testStdController2);
        UpdateShipInstrn shpIns3 = new UpdateShipInstrn(testStdController3);

        PageReference pageRef1 = shpIns1.updateAccCon();
        PageReference pageRef2 = shpIns2.updateAccCon();
        PageReference pageRef3 = shpIns3.updateAccCon();

        PageReference pageRef4 = shpIns1.updateStatus();

        String formattedDate = shpIns1.getFormattedDate();

        Shipping_Instruction_Product__c[] shpInsProd = shpIns1.getShipInsProd();


        //Testing all the methods in UpdateLabelReq Apex Class using the test data for Label Request
        ApexPages.Standardcontroller testStdController4 = new ApexPages.Standardcontroller(listLabelReq[0]);
        ApexPages.Standardcontroller testStdController5 = new ApexPages.Standardcontroller(listLabelReq[1]);
        ApexPages.Standardcontroller testStdController6 = new ApexPages.Standardcontroller(listLabelReq[2]);

        UpdateLabelReq labelReq1 = new UpdateLabelReq(testStdController4);
        UpdateLabelReq labelReq2 = new UpdateLabelReq(testStdController5);
        UpdateLabelReq labelReq3 = new UpdateLabelReq(testStdController6);

        PageReference pageRef5 = labelReq1.updateAccCon();
        PageReference pageRef6 = labelReq2.updateAccCon();
        PageReference pageRef7 = labelReq3.updateAccCon();

        PageReference pageRef8 = labelReq1.updateStatus();

        //Testing all the methods in UpdateTankReq Apex Class using the test data for Tank Request
        ApexPages.Standardcontroller testStdController7 = new ApexPages.Standardcontroller(listTankReq[0]);
        ApexPages.Standardcontroller testStdController8 = new ApexPages.Standardcontroller(listTankReq[1]);
        ApexPages.Standardcontroller testStdController9 = new ApexPages.Standardcontroller(listTankReq[2]);

        UpdateTankReq tankReq1 = new UpdateTankReq(testStdController7);
        UpdateTankReq tankReq2 = new UpdateTankReq(testStdController8);
        UpdateTankReq tankReq3 = new UpdateTankReq(testStdController9);

        PageReference pageRef9 = tankReq1.updateAccCon();
        PageReference pageRef10 = tankReq2.updateAccCon();
        PageReference pageRef11 = tankReq3.updateAccCon();

        //Testing all the methods in UpdateTankAssess Apex Class using the test data for Tank Assessment
        ApexPages.Standardcontroller testStdController10 = new ApexPages.Standardcontroller(listTankAssess[0]);

        UpdateTankAssess tankAssess = new UpdateTankAssess(testStdController10);

        PageReference pageRef12 = tankAssess.updateAccInfo();


        //Testing all the methods in UpdateReqTraffServ Apex Class using the test data for Request for Traffic Service
        ApexPages.Standardcontroller testStdController11 = new ApexPages.Standardcontroller(listReqTraffServ[0]);
        ApexPages.Standardcontroller testStdController12 = new ApexPages.Standardcontroller(listReqTraffServ[1]);
        ApexPages.Standardcontroller testStdController13 = new ApexPages.Standardcontroller(listReqTraffServ[2]);

        UpdateReqTraffServ reqTraffServ1 = new UpdateReqTraffServ(testStdController11);
        UpdateReqTraffServ reqTraffServ2 = new UpdateReqTraffServ(testStdController12);
        UpdateReqTraffServ reqTraffServ3 = new UpdateReqTraffServ(testStdController13);

        PageReference pageRef13 = reqTraffServ1.updateAllInfo();
        PageReference pageRef14 = reqTraffServ2.updateAllInfo();
        PageReference pageRef15 = reqTraffServ3.updateAllInfo();

        PageReference pageRef16 = reqTraffServ1.updateStatus();


    }
}