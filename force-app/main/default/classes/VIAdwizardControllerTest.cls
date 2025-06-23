/**
 * Contains tests for the VIAdwizardController class.
 */
@isTest
private class VIAdwizardControllerTest {
    // Fields
    private static Account distributor;
    private static Account facility;
    private static List<Account> locations;

    /**
     * Creates test data.
     */
    private static void setUp() {
        // Create VI_Portal_Settings__c Entry
        VI_Portal_Settings__c viPortalSettings = new VI_Portal_Settings__c();
        viPortalSettings.Adwizard_Login_URL__c = 'http://valvolineadwizard.saepio.com/ams/urlauthlogin.do';
        viPortalSettings.Adwizard_User_Group__c = 'Users/Installers';
        insert viPortalSettings;

        // Create a distributor account
        distributor = new Account();
        distributor.Name = 'Test Distributor';
        distributor.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
        insert distributor;

        // Create a facility account
        facility = new Account();
        facility.ParentId = distributor.Id;
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUTils.ACCOUNT_TYPE_FACILITY;
        insert facility;

        // Create some location accounts
        locations = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            Account location = new Account();
            location.ParentId = facility.Id;
            location.Name = 'Test Location ' + String.valueOf(i + 1);
            location.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_LOCATION;

            locations.add(location);
        }
        insert locations;

        // Share the facility and location accounts with the current user's subordinates
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

        List<Account> accounts = new List<Account>();
        accounts.add(facility);
        accounts.addAll(locations);

        List<AccountShare> accountShares = new List<AccountShare>();
        for (Account account : accounts) {
            accountShares.add(new AccountShare(AccountId = account.Id,
                    UserOrGroupId = groups.get(0).Id,
                    AccountAccessLevel = 'Read',
                    OpportunityAccessLevel = 'None',
                    CaseAccessLevel = 'None'));
        }
        insert accountShares;
    }

    /**
     * List all the locations for a facility for a user logged in at the distributor level.
     */
    static testmethod void listLocationsForDistributor() {
        //Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p0 = new PriceFx__c();
        p0.allowed_recordtype_id__c = '01250000000HmZV';
        p0.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p0.Name='callAccount';
        p0.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p0.password__c='Testuser@123';
        p0.username__c='sfdctestuser';
        pfxCustomList.add(p0);
        
        
        
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
        setUp();
        
        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = distributor.Id;
        contact.LastName = 'Test';
        insert contact;

        // Create a customer portal user to run the test
        Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.PARTNER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest7',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser7@testorg.com',
                ManagerId = UserInfo.getUserId());
        System.runAs(u) {
            // Set page parameters
            Map<String, String> params = System.currentPageReference().getParameters();
            params.put(VIAdwizardController.PARAM_FACILITY_ID, facility.Id);
            params.put(VIAdwizardController.PARAM_STATUS, 'Yes');
            params.put(VIAdwizardController.PARAM_RETURN_URL, '/home/home.jsp');

            // Create and initialize the controller
            VIAdwizardController controller = new VIAdwizardController();
            controller.initAction();

            // Users at the distributor level can edit locations
            System.assertEquals(true, controller.canEditLocation);

            // Check that the facility was correctly loaded
            System.assertEquals(facility.Id, controller.facilityId);
            System.assertEquals(facility.Name, controller.facilityName);

            // Make sure the URL was properly calculated
            System.assertNotEquals(null, controller.thisURL);

            // Check that the expected number of locations was found
            System.assertEquals(locations.size(), controller.locations.size());

        }
    }

    /**
     * List all the locations for a facility for a user logged in at the facility level.
     */
    static testmethod void listLocationsForFacility() {
        //Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p0 = new PriceFx__c();
        p0.allowed_recordtype_id__c = '01250000000HmZV';
        p0.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p0.Name='callAccount';
        p0.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p0.password__c='Testuser@123';
        p0.username__c='sfdctestuser';
        pfxCustomList.add(p0);
        
        
        
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
        setUp();

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = facility.Id;
        contact.LastName = 'Test';
        insert contact;

        // Create a customer portal user to run the test
        Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest8',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser8@testorg.com',
                ManagerId = UserInfo.getUserId());
        System.runAs(u) {
            // Set page parameters
            Map<String, String> params = System.currentPageReference().getParameters();
            params.put(VIAdwizardController.PARAM_STATUS, 'No');
            params.put(VIAdwizardController.PARAM_RETURN_URL, '/home/home.jsp');

            // Create and initialize the controller
            VIAdwizardController controller = new VIAdwizardController();
            controller.initAction();

            // Users at the facility level can edit locations as long as they are off-book
            System.assertEquals(true, controller.canEditLocation);

            // Check that the facility was correctly loaded
            System.assertEquals(facility.Id, controller.facilityId);
            System.assertEquals(facility.Name, controller.facilityName);

            // Make sure the URL was properly calculated
            System.assertNotEquals(null, controller.thisURL);

            // Check that the expected number of locations was found
            System.assertEquals(locations.size(), controller.locations.size());

            controller.step1();
            controller.step2();

        }
    }

    /**
     * List all the locations for a facility for a user logged in at the location level.
     */
    static testmethod void listLocationsForLocation() {
    //Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p0 = new PriceFx__c();
        p0.allowed_recordtype_id__c = '01250000000HmZV';
        p0.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p0.Name='callAccount';
        p0.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p0.password__c='Testuser@123';
        p0.username__c='sfdctestuser';
        pfxCustomList.add(p0);
        
        
        
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
        setUp();

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = locations.get(0).Id;
        contact.LastName = 'Test';
        insert contact;

        // Create a customer portal user to run the test
        Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest9',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser9@testorg.com',
                ManagerId = UserInfo.getUserId());
        System.runAs(u) {
            // Create and initialize the controller
            VIAdwizardController controller = new VIAdwizardController();
            controller.initAction();

            // Users at the location level cannot edit locations
            System.assertEquals(false, controller.canEditLocation);

            // Check that the facility was correctly loaded
            System.assertEquals(facility.Id, controller.facilityId);
            System.assertEquals(facility.Name, controller.facilityName);

            // Make sure the URL was properly calculated
            System.assertNotEquals(null, controller.thisURL);

            // Check that the expected number of locations was found
            System.assertEquals(locations.size(), controller.locations.size());

        }
    }

    static testMethod void testVIAdwizardFunctions() {
        String xml = '<?xml version="1.0" encoding="utf-8"?>';
        xml += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        xml += '<soapenv:Body>';
        xml += '<updateAddressesOutputType xmlns="address.webservices.ams.saepio.com">';
        xml += '<confirmations>';
        xml += '<successIndicator>false</successIndicator>';
        xml += '<addressUID>0</addressUID>';
        xml += '<externalAddressID>001Q000000DJ8lYIAT</externalAddressID>';
        xml += '<message>User test@test.test doesn\'t exist in our system</message>';
        xml += '</confirmations>';
        xml += '</updateAddressesOutputType>';
        xml += '</soapenv:Body>';
        xml += '</soapenv:Envelope>';
        VIAdwizardFunctions.readXml(xml);
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        User u = new User(Username='test@test.test');
        String userNotFoundMsg = 'User ' + u.Username + ' doesn\'t exist in our system';
        VIAdwizardFunctions.parseResponseDoc(doc, u, userNotFoundMsg);
        VIAdwizardFunctions.loginToAdwizard('test');
        // add any other calls before this one because the next one will make this test skipped!!!
        //VIAdwizardFunctions.loginToAdwizard('http://www.valvoline.com');
    }

}