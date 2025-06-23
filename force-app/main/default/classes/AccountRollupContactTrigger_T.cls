@isTest
private class AccountRollupContactTrigger_T {
/****************************************************************************
 * Test Class AccountRollupContactTrigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupContactTrigger Trigger
 ****************************************************************************/
 
    //Test Data
	private static Contact contact;
   
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    	Map<String,SObject> testData = TestScenarios.createAccountwithContactOppandTask();
		contact = (Contact)testData.get('contact');
		
        Account_Rollup_Settings__c settings = Account_Rollup_Settings.defaultSettings();
        settings.Triggers_Enabled__c = true;
        update settings;
    }
  
    private static void executeTest01() {
        // Execute Tests
        update contact;
        delete contact;
    }
}