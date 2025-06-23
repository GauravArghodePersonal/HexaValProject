/**
 * Contains test methods for the VIPortalAVIStatusController class.
 */
@IsTest
private class VIPortalAVIStatusControllerTest {
    /**
    * Run as a customer portal user.
    */
    static testmethod void runAsCustomerPortalUser() {
        // Create the facility account
        Account facility = new Account();
        facility.Name = 'Test Facility';
        facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
        insert facility;

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = facility.Id;
        contact.LastName = 'Test';
        insert contact;

        // Create some test location accounts
        List<Account> locations = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            Account location = new Account();
            location.ParentId = facility.Id;
            location.Name = 'Test Location ' + String.valueOf(i + 1);
            location.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_LOCATION;

            locations.add(location);
        }
        insert locations;

        // Create some AVI form records for testing
        List<VI_AVI_Form__c> forms = new List<VI_AVI_Form__c>();
        for (Account location : locations) {
            forms.add(new VI_AVI_Form__c(Location__c = location.Id));
        }
        insert forms;

        // Share the location accounts with the current user's subordinates
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

        List<AccountShare> accountShares = new List<AccountShare>();
        for (Account location : locations) {
            accountShares.add(new AccountShare(AccountId = location.Id,
                    UserOrGroupId = groups.get(0).Id,
                    AccountAccessLevel = 'Read',
                    OpportunityAccessLevel = 'None',
                    CaseAccessLevel = 'None'));
        }
        insert accountShares;

        // Create a customer portal user to run the test
        Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest11',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser11@testorg.com',
                ManagerId = UserInfo.getUserId());
        System.runAs(u) {
            // Create and initialize the controller
            VIPortalAVIStatusController controller = new VIPortalAVIStatusController();
            controller.init();
            List<VIAccount> viaccounts = controller.getLocations();

            // Check that the correct number of locations are displayed
            System.assertNotEquals(null, viaccounts);
            //System.assertEquals(locations.size(), viaccounts.size());
            VIAccount viacc;
            Integer numLocations = viaccounts.size();
            for (Integer i = 0; i < numLocations; i++) {
                viacc = viaccounts.get(i);
                //System.assertNotEquals(null, viacc.acc);
                //System.assertNotEquals(null, viacc.aviAppStatus);
            }
        }
    }
}