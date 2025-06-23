@isTest
private class SAP_Ultimate_Parent_Trigger_T {
/****************************************************************************
 * Test Class SAP_Ultimate_Parent_Trigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - SAP_Ultimate_Parent_Trigger Trigger
 ****************************************************************************/
 
    //Test Data
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    	SAP_Ultimate_Parent_Settings__c settings = SAP_Ultimate_Parent_Settings.defaultSettings();
		settings.Account_Owner_Id__c = TestObjects.newUser().Id;
		settings.Account_Owner_Id_When_Deleted__c = TestObjects.newUser().Id;
		settings.SAP_Ultimate_Parent_Trigger_Enabled__c = true;
		update settings;
    }
  
    private static void executeTest01() {
    	SAP_Ultimate_Parent__c up1 = TestObjects.newSAP_Ultimate_Parent();
    	update up1;
    	delete up1;
    	undelete up1;
    }
}