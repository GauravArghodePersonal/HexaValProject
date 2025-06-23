@isTest
private class AppLogWebServices_T {
/****************************************************************************
* Test Class AppLogWebServices_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - AppLogWebServices_T Apex Class
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
	      AppLogWebServices.write('Process Name','Sub Process','Application Name','Version Info','Log Category','Task','Log Type','Summary','Detailed Log','Related To Key','Related To Key Type','Record Key');
    }
}