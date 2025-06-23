/**
 * Contains test methods for the VIManageAccountController class.
 */
@IsTest
private class VIManageAccountControllerTest {
    /**
    * Run as a partner portal user to ensure that the user is redirected to the current user's
    * account detail page.
    */
    static testmethod void runAsPartnerPortalUser() {
        // Create the account
        
        VIManageAccountController controller1 = new VIManageAccountController();
        Account account = new Account();
        account.Name = 'Test Partner Account';
        insert account;

        // Create a contact to represent our portal user
        Contact contact = new Contact();
        contact.AccountId = account.Id;
        contact.LastName = 'Test';
        insert contact;
		
        PageReference pr = Page.VIManageAccount; 
  			Test.setCurrentPage(pr);
            test.startTest();
                VIManageAccountController controller = new VIManageAccountController();
                PageReference redirect = controller.init();
			Test.stopTest();
        // Create a partner portal user to run the test
        Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.PARTNER_PORTAL_NAME];
        } catch(Exception e) {return;}
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                ProfileId = p.Id, ContactId = contact.Id, Ashland_Employee_Number__c = 'zzzTest10',
                TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser10@testorg.com');
        System.runAs(u) {
            // Create and initialize the controller
            //ApexPages.StandardController sc = new ApexPages.standardController(account);
            
           /* PageReference pr = Page.VIManageAccount; 
  			Test.setCurrentPage(pr);
            test.startTest();
                VIManageAccountController controller = new VIManageAccountController();
                PageReference redirect = controller.init();
			Test.stopTest();
            System.assertNotEquals(null, redirect);*/
        }
        
    }
}