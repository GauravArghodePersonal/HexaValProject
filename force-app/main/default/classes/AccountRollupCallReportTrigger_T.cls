@isTest
private class AccountRollupCallReportTrigger_T {
/****************************************************************************
 * Test Class AccountRollupCallReportTrigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupCallReportTrigger Trigger
 ****************************************************************************/
 
    //Test Data
	private static Call_Report__c callReport;
   
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
		callReport = (Call_Report__c)testData.get('callReport');
		
        Account_Rollup_Settings__c settings = Account_Rollup_Settings.defaultSettings();
        settings.Triggers_Enabled__c = true;
        update settings;
    }
  
    private static void executeTest01() {
        // Execute Tests
        update callReport;
        delete callReport;
    }
}