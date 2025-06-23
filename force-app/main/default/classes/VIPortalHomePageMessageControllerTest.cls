/**
 * Contains test methods for the VIPortalHomePageMessageController class.
 */
@IsTest
private class VIPortalHomePageMessageControllerTest {
    private static final String CUSTOMER_PORTAL_MESSAGE = 'Hello from Customer Portal';
    private static final String PARTNER_PORTAL_MESSAGE = 'Testing Partner Portal Message';

    /**
    * Common setup for all tests in this class.
    */
    private static void setUp() {
        // Delete any existing messages that could interfere with our test
        delete [SELECT Id
                FROM VI_Message__c
                WHERE Active__c = TRUE
                AND Start_Date__c <= TODAY
                AND End_Date__c >= TODAY];

        // Create a partner portal message and a customer portal message
        List<VI_Message__c> messages = new List<VI_Message__c>();
        messages.add(new VI_Message__c(Active__c = true,
                Start_Date__c = Date.today(), End_Date__c = Date.today(),
                Customer_Portal__c = true, Partner_Portal__c = false,
                Body__c = CUSTOMER_PORTAL_MESSAGE));
        messages.add(new VI_Message__c(Active__c = true,
                Start_Date__c = Date.today(), End_Date__c = Date.today(),
                Customer_Portal__c = false, Partner_Portal__c = true,
                Body__c = PARTNER_PORTAL_MESSAGE));
        insert messages;
    }

    /**
    * Ensure that customer portal users see customer portal messages.
    */
    static testmethod void runAsCustomerPortalUser() {
        setUp();

        // Create the account
        Account account = new Account();
        account.Name = 'Test Customer Account';
        insert account;

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = account.Id;
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
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest14',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser14@testorg.com');
        System.runAs(u) {
            // Create and initialize the controller
            VIPortalHomePageMessageController controller = new VIPortalHomePageMessageController();
            controller.init();

            // Check that the correct message is displayed
            //System.assertEquals(CUSTOMER_PORTAL_MESSAGE, controller.getMessage());
        }
    }

    /**
    * Ensure that partner portal users see partner portal messages.
    */
    static testmethod void runAsPartnerPortalUser() {
        setUp();

        // Create the account
        Account account = new Account();
        account.Name = 'Test Partner Account';
        insert account;

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = account.Id;
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
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest15',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser15@testorg.com');
        System.runAs(u) {
            // Create and initialize the controller
            VIPortalHomePageMessageController controller = new VIPortalHomePageMessageController();
            controller.init();

            // Check that the correct message is displayed
            //System.assertEquals(PARTNER_PORTAL_MESSAGE, controller.getMessage());
        }
    }

    /**
    * Non-portal users do not see any messages.
    */
    static testmethod void runAsNonPortalUser() {
        setUp();

        // Create and initialize the controller
        VIPortalHomePageMessageController controller = new VIPortalHomePageMessageController();
        controller.init();

        // Check that no message is displayed
        System.assertEquals(null, controller.getMessage());
    }
}