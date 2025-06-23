/**
 * Contains test methods for the VIPortalHeaderController class.
 */
@IsTest
private class VIPortalHeaderControllerTest {
    /**
    * Ensure that the the correct channel information is returned for a user logging in at
    * a facility-level.
    */
    static testmethod void runAsFacilityUser() {
        // Create a distributor account
        Account distributor = new Account();
        distributor.Name = 'Test Distributor';
        distributor.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
        insert distributor;

        // Create a facility account
        Account facility = new Account();
        facility.ParentId = distributor.Id;
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        facility.VI_Channel__c = VIUtils.CHANNEL_ASC;
        insert facility;

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
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest12',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser12@testorg.com');
        System.runAs(u) {
            // Create and initialize the controller
            VIPortalHeaderController controller = new VIPortalHeaderController();
            controller.init();

            // Ensure the correct channel is returned
            System.assertEquals(VIUtils.CHANNEL_ASC, controller.getChannel());
        }
    }

    /**
    * Ensure that the the correct channel information is returned for a user logging in at
    * a location-level.
    */
    static testmethod void runAsLocationUser() {
        // Create a distributor account
        Account distributor = new Account();
        distributor.Name = 'Test Distributor';
        distributor.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
        insert distributor;

        // Create a facility account
        Account facility = new Account();
        facility.ParentId = distributor.Id;
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        facility.VI_Channel__c = VIUtils.CHANNEL_CAR_DEALER;
        insert facility;

        // Create a location account
        Account location = new Account();
        location.ParentId = facility.Id;
        location.Name = 'Test Location';
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
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest13',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser13@testorg.com');
        System.runAs(u) {
            // Create and initialize the controller
            VIPortalHeaderController controller = new VIPortalHeaderController();
            controller.init();

            // Ensure the correct channel is returned
            System.assertEquals(VIUtils.CHANNEL_CAR_DEALER, controller.getChannel());
        }
    }
}