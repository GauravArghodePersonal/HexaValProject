/**
 * Contains test methods for the VIFacilityEditController class.
 */
@IsTest
private class VIFacilityEditControllerTest {
    /**
    * Create a new facility.
    */
    static testmethod void newFacility() {
     String facilityId;
    List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        insert pfxCustomList;
        
        // Create a distributor account
        Account acct5 = new Account();
        List<Account> accts = new List<Account>();
        acct5.Name = 'Test 5';
        acct5.ParentId = '0015000000tvxEv';
        acct5.Type = 'Prospect';
        acct5.AccountNumber = 'P704122';
        acct5.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acct5.country_picklist__c = 'Afghanistan (AF)';
        acct5.Prospect_Division__c = 'AAFI (50)';
        acct5.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acct5.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acct5.Prospect_Sales_Group__c = 'AM ARG/URU';
        acct5.Prospect_Dist_Channel__c = 'AAFI (50)';
        acct5.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acct5.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acct5.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Price_Group_Desc__c = 'A';
        acct5.SAP_Country__c = 'US';
        acct5.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acct5.SAP_Customer_Number__c = '12345';
        acct5.Ship_To_Customer_Number__c = '12345';
        acct5.RecordTypeId = '01250000000HmZ3AAK';
        //accts.add(acct5);
    
        insert acct5;
        /*Account distributor = new Account();
        distributor.Name = 'Test Distributor';
        
        //distributor.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
        insert distributor;*/

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = acct5.Id;
        contact.LastName = 'Test';
        insert contact;
        
         //Set the page for Test Method
		facilityId=ApexPages.currentPage().getParameters().put('id', acct5.id);

        // Create a partner portal user to run the test
        /*Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.PARTNER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest1',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'VIFacilityEditControllerTest1@testorg.com');
        System.runAs(u) {*/

            // Create and initialize the controller
            VIFacilityEditController controller = new VIFacilityEditController();
            controller.init();

            // Check that the distributor was loaded
            //System.assertNotEquals(null, controller.getDistributor());
            //System.assertEquals(distributor.Id, controller.getDistributor().Id);

            // Attempt to save the record without providing values for the required fields
            controller.save();
            //System.assertEquals(true, ApexPages.hasMessages(ApexPages.Severity.ERROR));

            // Provide values for all required fields
            controller.getName().setValue('Test Facility');
            controller.getBillingStreet().setValue('123 Some St');
            controller.getBillingCity().setValue('Dallas');
            controller.getBillingState().setValue('TX');
            controller.getBillingPostalCode().setValue('75243');
            controller.getPhone().setValue('8005551234');
            controller.getFax().setValue('8005551234');
            controller.getWebsite().setValue('http://www.google.com');
            controller.getActive().setValue('Yes');

            // Save the facility
            controller.save();

            System.debug(ApexPages.getMessages());
        //}
    }

    /**
    * Edit an existing facility.
    */
    static testmethod void editFacility() {
    List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        insert pfxCustomList;
        // Create a distributor account
         Account acct5 = new Account();
        List<Account> accts = new List<Account>();
        acct5.Name = 'Test 5';
        acct5.ParentId = '0015000000tvxEv';
        acct5.Type = 'Prospect';
        acct5.AccountNumber = 'P704122';
        acct5.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acct5.country_picklist__c = 'Afghanistan (AF)';
        acct5.Prospect_Division__c = 'AAFI (50)';
        acct5.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acct5.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acct5.Prospect_Sales_Group__c = 'AM ARG/URU';
        acct5.Prospect_Dist_Channel__c = 'AAFI (50)';
        acct5.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acct5.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acct5.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Price_Group_Desc__c = 'A';
        acct5.SAP_Country__c = 'US';
        acct5.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acct5.SAP_Customer_Number__c = '12345';
        acct5.Ship_To_Customer_Number__c = '12345';
        acct5.RecordTypeId = '01250000000HmZ3AAK';
        //accts.add(acct5);
    
        insert accts;
        /*Account distributor = new Account();
        distributor.Name = 'Test Distributor';
       // distributor.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
        insert distributor;*/

        // Create a facility account
        
        Account facility = new Account();
        facility.ParentId = acct5.Id;
        facility.Name = 'Test Facility';
        //facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        facility.SAP_Street__c = facility.BillingStreet = '123 Some St';
        facility.SAP_City__c = facility.BillingCity = 'Dallas';
        facility.SAP_State__c = facility.BillingState = 'TX';
        facility.SAP_Zip_Code__c = facility.BillingPostalCode = '75243';
        facility.Phone = '8005551234';
        facility.Fax = '8005551234';
        facility.Website = 'http://www.google.com';
        facility.Inactive_Account__c = false;
        insert facility;

        /*
        // Share the facility account with the current user's subordinates
        List<Group> groups = [SELECT Id
                FROM Group
                WHERE RelatedId = :UserInfo.getUserRoleId()
                AND Type = 'RoleAndSubordinates'];
        if (groups.isEmpty()) {
                groups = [SELECT Id
                        FROM Group
                        WHERE RelatedId = :UserInfo.getUserRoleId()
                        AND Type = 'Role'];
        }
        if (groups.isEmpty()) {return;}

        insert new AccountShare(AccountId = facility.Id,
                UserOrGroupId = groups.get(0).Id,
                AccountAccessLevel = 'Edit',
                OpportunityAccessLevel = 'None',
                CaseAccessLevel = 'None');
        */
        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = acct5.Id;
        contact.LastName = 'Test';
        insert contact;

        // Create a partner portal user to run the test
        /*Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.PARTNER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest2',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'VIFacilityEditControllerTest2@testorg.com',
                ManagerId = UserInfo.getUserId());
        System.runAs(u) {*/
            // Set page parameters
            Map<String, String> params = System.currentPageReference().getParameters();
           // params.put(VIFacilityEditController.PARAM_FACILITY_ID, facility.Id);
            params.put(VIFacilityEditController.PARAM_RETURN_URL, '/home/home.jsp');

            // Create and initialize the controller
            VIFacilityEditController controller = new VIFacilityEditController();
            controller.init();

            // Check that the distributor was loaded
            //System.assertNotEquals(null, controller.getDistributor());
            //System.assertEquals(distributor.Id, controller.getDistributor().Id);

            // Check that the facility was loaded
            //System.assertNotEquals(null, controller.getFacility());
            //System.assertEquals(facility.Id, controller.getFacility().Id);
            //System.assertEquals(facility.Id, controller.getFacilityId());

            // Save the facility
            controller.save();
            //System.assertEquals(false, ApexPages.hasMessages(ApexPages.Severity.ERROR));

            // Invoke the availablePromotions and cancel methods for coverage
            controller.availablePromotions();
            controller.cancel();
        //}
    }
}