@isTest
private class AccountRollupOpportunitiyTrigger_T {
/****************************************************************************
 * Test Class AccountRollupOpportunitiyTrigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollup_OpportunitiyTrigger Trigger
 ****************************************************************************/
 
    //Test Data
	private static Opportunity opportunity;
   
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
		opportunity = (Opportunity)testData.get('opportunity');

        Account_Rollup_Settings__c settings = Account_Rollup_Settings.defaultSettings();
        settings.Triggers_Enabled__c = true;
        update settings;
    }
  
    private static void executeTest01() {
        // Execute Tests
        update opportunity;
        delete opportunity;
    }
}