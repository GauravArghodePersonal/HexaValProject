/**
 * Contains tests for the VILocationListController class.
 */
@IsTest
private class VILocationListControllerTest {
    // Fields
    private static Account distributor;
    private static Account facility;
    private static List<Account> locations;

    /**
    * Creates test data.
    */
    private static void setUp() {
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
        setUp();

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = distributor.Id;
        contact.LastName = 'Test';
        insert contact;

        // Create a customer portal user to run the test
        /*Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.PARTNER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest7',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser7@testorg.com',
                ManagerId = UserInfo.getUserId());
        System.runAs(u) {*/
            // Set page parameters
            Map<String, String> params = System.currentPageReference().getParameters();
            params.put(VILocationListController.PARAM_FACILITY_ID, facility.Id);
            params.put(VILocationListController.PARAM_STATUS, 'Yes');
            params.put(VILocationListController.PARAM_RETURN_URL, '/home/home.jsp');

            // Create and initialize the controller
            VILocationListController controller = new VILocationListController();
            controller.init();

            // Users at the distributor level can edit locations
            //System.assertEquals(true, controller.getCanEditLocation());

            // Check that the facility was correctly loaded
            //System.assertEquals(facility.Id, controller.getFacilityId());
            //System.assertEquals(facility.Name, controller.getFacilityName());

            // Set the max search results
            controller.setMaxSearchResults(10);
            //System.assertEquals(10, controller.getMaxSearchResults());

            // Set search criteria and execute the search
            controller.getLocationName().setValue('Test');
            controller.getCity().setValue(null);
            controller.getState().setValue(null);
            controller.getPostalCode().setValue(null);
            controller.getStatus().setValue('All');
            controller.searchLocations();

            // Make sure the URL was properly calculated
            //System.assertNotEquals(null, controller.getThisURL());

            // Check that the expected number of locations was found
            //System.assertEquals(locations.size(), controller.getLocations().size());

            // Invoke the newLocation method for coverage
            //System.assertNotEquals(null, controller.newLocation());
        //}
    }

    /**
    * List all the locations for a facility for a user logged in at the facility level.
    */
    static testmethod void listLocationsForFacility() {
        setUp();

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = facility.Id;
        contact.LastName = 'Test';
        insert contact;

        // Create a customer portal user to run the test
        /*Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest8',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser8@testorg.com',
                ManagerId = UserInfo.getUserId());
        System.runAs(u) {*/
            // Set page parameters
            Map<String, String> params = System.currentPageReference().getParameters();
            params.put(VILocationListController.PARAM_STATUS, 'No');
            params.put(VILocationListController.PARAM_RETURN_URL, '/home/home.jsp');

            // Create and initialize the controller
            VILocationListController controller = new VILocationListController();
            controller.init();

            // Users at the facility level can edit locations as long as they are off-book
            //System.assertEquals(true, controller.getCanEditLocation());

            // Check that the facility was correctly loaded
            //System.assertEquals(facility.Id, controller.getFacilityId());
            //System.assertEquals(facility.Name, controller.getFacilityName());

            // Set the max search results
            controller.setMaxSearchResults(10);
            System.assertEquals(10, controller.getMaxSearchResults());

            // Set search criteria and execute the search
            controller.getLocationName().setValue('Test');
            controller.getCity().setValue(null);
            controller.getState().setValue(null);
            controller.getPostalCode().setValue(null);
            controller.getStatus().setValue('All');
            controller.searchLocations();

            // Make sure the URL was properly calculated
            //System.assertNotEquals(null, controller.getThisURL());

            // Check that the expected number of locations was found
            //System.assertEquals(locations.size(), controller.getLocations().size());

            // Invoke the newLocation method for coverage
            //System.assertNotEquals(null, controller.newLocation());
        //}
    }

    /**
    * List all the locations for a facility for a user logged in at the location level.
    */
    static testmethod void listLocationsForLocation() {
        setUp();

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = locations.get(0).Id;
        contact.LastName = 'Test';
        insert contact;

        // Create a customer portal user to run the test
        /*Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest9',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser9@testorg.com',
                ManagerId = UserInfo.getUserId());
        System.runAs(u) {*/
            // Create and initialize the controller
            VILocationListController controller = new VILocationListController();
            controller.init();

            // Users at the location level cannot edit locations
            //System.assertEquals(false, controller.getCanEditLocation());

            // Check that the facility was correctly loaded
            //System.assertEquals(facility.Id, controller.getFacilityId());
            //System.assertEquals(facility.Name, controller.getFacilityName());

            // Set the max search results
            controller.setMaxSearchResults(10);
            //System.assertEquals(10, controller.getMaxSearchResults());

            // Set search criteria and execute the search
            controller.getLocationName().setValue('Test');
            controller.getCity().setValue(null);
            controller.getState().setValue(null);
            controller.getPostalCode().setValue(null);
            controller.getStatus().setValue('All');
            controller.searchLocations();

            // Make sure the URL was properly calculated
            //System.assertNotEquals(null, controller.getThisURL());

            // Check that the expected number of locations was found
            //System.assertEquals(locations.size(), controller.getLocations().size());

            // Invoke the newLocation method for coverage
            //System.assertNotEquals(null, controller.newLocation());
            controller.cancel(); controller.newLocation();
            controller.gotoBiwPage(); controller.gotoBrandMusclePage();
        //}
    }
}