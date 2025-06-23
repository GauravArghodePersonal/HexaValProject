@isTest
private class IdMethods_T {
/****************************************************************************
* Test Class IdMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - IdMethods Apex Class
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
        System.assertEquals(IdMethods.isId(''),false);
        System.assertEquals(IdMethods.isId('001000000000000'),true);
        System.assertEquals(IdMethods.isId('abc'),false);
    }
}