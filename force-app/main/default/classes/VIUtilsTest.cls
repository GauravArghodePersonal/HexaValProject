/**
 * Contains test methods for the VIUtils class.
 */
@IsTest
private class VIUtilsTest {
    /**
    * Test portal methods.
    */
    static testmethod void portalTests() {
        // Create a distributor
        Account distributor = new Account();
        distributor.Name = 'Test Distributor';
        distributor.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
        insert distributor;

        // Create a facility
        Account facility = new Account();
        facility.ParentId = distributor.Id;
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        insert facility;

        // Create a location
        Account location = new Account();
        location.ParentId = facility.Id;
        location.Name = 'Test Customer Account';
        location.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_LOCATION;
        insert location;

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = location.Id;
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
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest16',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser16@testorg.com');
        System.runAs(u) {
            System.assertEquals(location.Id, VIUtils.getPortalAccountId());
            System.assertEquals(VIUtils.ACCOUNT_TYPE_LOCATION, VIUtils.getPortalAccountType());
            System.assertEquals(VIUtils.PORTAL_TYPE_CUSTOMER, VIUtils.getPortalType());
            System.assertEquals(true, VIUtils.isPortalUser());
            System.assertEquals(true, VIUtils.isCustomerPortalUser());
            System.assertEquals(false, VIUtils.isPartnerPortalUser());
            VIUtils.getUser(u.Username);
        }
    }

    /**
    * Test channel methods.
    */
    static testmethod void channelTests() {
        System.assertEquals(VIUtils.CHANNEL_ASC, VIUtils.getChannel(VIUtils.CHANNEL_ASC, null));
        System.assertEquals(VIUtils.CHANNEL_CAR_DEALER, VIUtils.getChannel(VIUtils.CHANNEL_CAR_DEALER, null));
        System.assertEquals(VIUtils.CHANNEL_QUICKLUBE, VIUtils.getChannel(VIUtils.CHANNEL_QUICKLUBE, null));
        System.assertEquals(VIUtils.CHANNEL_QUICKLUBE_EXPRESSCARE, VIUtils.getChannel(VIUtils.CHANNEL_QUICKLUBE, VIUtils.SAP_CUST_GROUP_5_EXPRESSCARE));
    }

    /**
    * Test date methods.
    */
    static testmethod void dateTests() {
        Date a = Date.newInstance(2010, 1, 1);
        Datetime b = Datetime.newInstance(2010, 1, 1);
        System.assertEquals(b, VIUtils.dateToDatetime(a));

        System.assertEquals('1/1/2010', VIUtils.formatDate(a, 'M/d/yyyy'));
        System.assertNotEquals(null, VIUtils.formatDate(a, null));
    }

    /**
    * Test fiscal year methods.
    */
    static testmethod void fiscalYearTests() {
        System.assertEquals(2009, VIUtils.getFiscalYear(Date.newInstance(2010, 1, 1), 2));
        System.assertEquals(2010, VIUtils.getFiscalYear(Date.newInstance(2010, 1, 1), 1));
        System.assertEquals(2011, VIUtils.getFiscalYear(Date.newInstance(2010, 10, 1), 10));
    }

    /**
    * Test account methods.
    */
    static testmethod void accountTests() {
        // Create a distributor
        Account distributor = new Account();
        distributor.Name = 'Test Distributor';
        distributor.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
        insert distributor;

        // Create a facility
        Account facility = new Account();
        facility.ParentId = distributor.Id;
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        insert facility;

        // Create a location
        Account location = new Account();
        location.ParentId = facility.Id;
        location.Name = 'Test Location';
        location.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_LOCATION;
        insert location;

        // Start the test
        Test.startTest();

        // Get the facility
        Account f = VIUtils.getFacility(facility.Id);
        System.assertNotEquals(null, f);
        System.assertEquals(facility.Id, f.Id);

        // Get the location
        Account l = VIUtils.getLocation(location.Id);
        System.assertNotEquals(null, l);
        System.assertEquals(location.Id, l.Id);
        VIUtils.getLocations(facility);

        // Stop the test
        Test.stopTest();
    }
}