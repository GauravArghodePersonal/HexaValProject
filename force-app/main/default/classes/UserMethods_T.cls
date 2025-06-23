@isTest
private class UserMethods_T {
/****************************************************************************
* Test Class UserMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - UserMethods Apex Class
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
        User user1 = TestObjects.NewUser();
        User user2 = TestObjects.NewUser();
        List<Id> userIds = new List<Id>();
        List<User> users = new List<User>();
        userIds.add(user1.Id);
        userIds.add(user2.Id);
        users.add(user1);
        users.add(user2);
        
        QueryBuilder.SubQuery subQuery = UserMethods.SUBQUERY_PERMISSIONSETASSIGNMENTS_ALL;
        List<QueryBuilder.SubQuery> subQueries = new List<QueryBuilder.SubQuery>();
        subQueries.add(subQuery);
        
        UserMethods.retrieveUsers(UserMethods.FIELDS, 'Id = \'' + user1.Id + '\'');
        UserMethods.retrieveUsers(UserMethods.FIELDS, 'Id = \'' + user1.Id + '\'', subQueries);
        UserMethods.retrieveUsers(UserMethods.FIELDS, 'Id = \'' + user1.Id + '\'', subQuery);
        
        UserMethods.retrievePermissionSetInfoForUserId(user1.Id);
        UserMethods.retrievePermissionSetInfoForUserIds(userIds);
        UserMethods.retrievePermissionSetMapForUsers(users);
    }
}