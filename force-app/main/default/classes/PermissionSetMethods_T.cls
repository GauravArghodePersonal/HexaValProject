@isTest
private class PermissionSetMethods_T {
/****************************************************************************
* Test Class PermissionSetMethods_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - PermissionSetMethods Apex Class
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

        PermissionSet ps = [Select Id, Name, Label FROM PermissionSet LIMIT 1];
        String psId = ps.Id;
		List<Id> ids = new List<Id>();
		ids.add(psId);

		PermissionSetMethods.retrieveWithId(ps.Id);
		PermissionSetMethods.retrieveWithIds(ids);
		PermissionSetMethods.retrieveWithName(ps.name);
		PermissionSetMethods.retrieveWithLabel(ps.label);

        
    }
}