@isTest
private class AppLogV2_T {
/****************************************************************************
* Test Class AppLogV2_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - AppLogV2 Apex Class
****************************************************************************/
 
    //Test Data


    //Test Settings


    private static testMethod void myUnitTest() {
        // Create Test Data
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }

    private static void createTestData() {
        // No Test Data Needed
    }

    private static void executeTest01() {
        // Execute Tests
	      AppLogV2 appLog = new AppLogV2('Process','Sub Process','Application Name','Version Info');

	      appLog.write('Log Category','Task','Log Type','Summary','Detailed Log');
	      appLog.write('Log Category','Task','Log Type','Summary','Detailed Log','Related To Key', 'Related To Key Type');
	      appLog.write('Log Category','Task','Log Type','Summary','Detailed Log','Related To Key', 'Related To Key Type','Record Key');
	  
	      appLog.cachedWrite('Log Category','Task','Log Type','Summary','Detailed Log');
	      appLog.cachedWrite('Log Category','Task','Log Type','Summary','Detailed Log','Related To Key', 'Related To Key Type');
	      appLog.cachedWrite('Log Category','Task','Log Type','Summary','Detailed Log','Related To Key', 'Related To Key Type','Record Key');
	  
		  appLog.flushCache();
    }
}