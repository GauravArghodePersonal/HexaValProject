@isTest
private class VIPfcPageController_T {
/****************************************************************************
 * Test Class VIPfcPageController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - VIPfcPageController Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
    //Test Settings
    
    
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        // Create VI_Portal_Settings__c Entry
    	VI_Portal_Settings__c viPortalSettings = new VI_Portal_Settings__c();
    	viPortalSettings.Adwizard_Login_URL__c = 'http://valvolineadwizard.saepio.com/ams/urlauthlogin.do';
    	viPortalSettings.Adwizard_User_Group__c = 'Users/Installers';
    	viPortalSettings.PFC_CryptoKey__c = 'abcdef1234567890';
    	insert viPortalSettings;
    }
  
    private static void executeTest01() {
        // Execute Tests

        VIPfcPageController c = new VIPfcPageController();
        c.gotoPfc();
    }
}