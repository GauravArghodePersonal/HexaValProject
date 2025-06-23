@isTest
private class SystemMethods_T {
/****************************************************************************
* Test Class SystemMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - SystemMethods Apex Class
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
    }

    private static void executeTest01() {
        // Execute Tests
        SystemMethods.schedule('TEST', '', null);
        SystemMethods.scheduleBatch(null,'TEST',1);
    }
}