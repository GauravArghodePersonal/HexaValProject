@isTest
private class VILearnshareController_T {
/****************************************************************************
 * Test Class VILearnshareController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - VILearnshareController Apex Class
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
    	viPortalSettings.Learnshare_CryptoKey__c = 'abcdef1234567890';
    	viPortalSettings.Learnshare_URL__c = 'http://lms3.learnshare.com/lsapientry.aspx?cid=50&Z=';
    	insert viPortalSettings;
    }
  
    private static void executeTest01() {
        // Execute Tests

    	VILearnshareController c = new VILearnshareController();
    	c.gotoLearnshare();
    }
}