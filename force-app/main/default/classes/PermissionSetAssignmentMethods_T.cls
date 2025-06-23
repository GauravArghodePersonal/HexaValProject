@isTest
private class PermissionSetAssignmentMethods_T {
/****************************************************************************
* Test Class PermissionSetAssignmentMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - PermissionSetAssignmentMethods Apex Class
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
        User user1 = TestObjects.newUser();
        User user2 = TestObjects.newUser();
        List<Id> userIds = new List<Id>();
        userIds.add(user1.Id);
        userIds.add(user2.Id);
        
		PermissionSetAssignmentMethods.retrieveWithUserId(user1.Id);
		PermissionSetAssignmentMethods.retrieveWithUserIds(userIds);
    }
}