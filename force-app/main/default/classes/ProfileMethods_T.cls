@isTest
private class ProfileMethods_T {
/****************************************************************************
* Test Class ProfileMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - ProfileMethods Apex Class
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
        
        Profile p = [SELECT Id,Name FROM Profile LIMIT 1];
        
        ProfileMethods.retrieveWithId(p.Id);
        ProfileMethods.retrieveWithName(p.Name);

		Id badId = '001000000000000';
        ProfileMethods.retrieveWithId(badId);
        ProfileMethods.retrieveWithName('1234');

    }
}