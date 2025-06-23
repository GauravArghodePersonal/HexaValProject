@isTest
private class Dynamic_Permission_Sets_T {
/****************************************************************************
* Test Class Dynamic_Permission_Sets_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - Dynamic_Permission_Sets Apex Class
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
        PermissionSet validPermissionSet = [Select Id, Label FROM PermissionSet LIMIT 1];
        String validPermissionSetId = validPermissionSet.Id;
        
        Dynamic_Permission_Sets d = new Dynamic_Permission_Sets();
        d.exists('test');
        d.exists(validPermissionSet.Id);
        d.exists(validPermissionSetId);
        d.exists(validPermissionSet.Label);
        
        d.add(validPermissionSet.Id);
        d.remove(validPermissionSet.Id);

        d.add(validPermissionSet.Label);
        d.remove(validPermissionSet.Label);

        d.add(validPermissionSet);
        d.remove(validPermissionSet);

		// force Error, already configured
        d.add(validPermissionSet);
        d.add(validPermissionSet);

		// force error, permission set isn't saved
		PermissionSet newPermissionSet = new PermissionSet();
        d.add(newPermissionSet);
		
		// force error, permission set is null
		PermissionSet nullPermissionSet;
		d.add(nullPermissionSet);

		// force error, permission Set doesn't exist
        d.remove(validPermissionSet);
        d.remove(validPermissionSet);

		// force error with Label
        d.add(validPermissionSet.Label);
        d.remove(validPermissionSet.Label);
        d.remove(validPermissionSet.Label);

        d.add(validPermissionSet.Label);
        
        d.validateAll();
    }
}