@isTest
private class UserRoleMethods_T {
/****************************************************************************
* Test Class UserRoleMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - UserRoleMethods Apex Class
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
		UserRole userRole = [SELECT Id, DeveloperName, Name FROM UserRole LIMIT 1];        
        
		UserRoleMethods.retrieveWithId(userRole.Id);
		UserRoleMethods.retrieveWithDeveloperName(userRole.DeveloperName);
		UserRoleMethods.retrieveWithName(userRole.Name);
    }
}