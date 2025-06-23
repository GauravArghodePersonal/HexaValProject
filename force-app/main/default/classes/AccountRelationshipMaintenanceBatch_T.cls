@isTest
private class AccountRelationshipMaintenanceBatch_T {
/****************************************************************************
* Test Class AccountRelationshipMaintenanceBatch_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - AccountRelationshipMaintenanceBatch Apex Class
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
        Account a1 = TestObjects.NewAccount();
        Account a2 = TestObjects.NewAccount();
        Account_Relationship__c ar = new Account_Relationship__c();
        ar.Child_Account__c = a1.Id;
        ar.Parent_Account__c = a2.Id;
        ar.Child_Relationships_Need_Rebuilt__c = true;
        ar.Recalc_Needed__c = true;
        insert ar;
    }

    private static void executeTest01() {
        // Execute Tests
        AccountRelationshipMaintenanceBatch.ApplyNewRecalcNeededToAll(true); // Reset all Recalc_Needed__c to True
        AccountRelationshipMaintenanceBatch.ApplyNewRecalcNeededToAll(false); // Reset all Recalc_Needed__c to False
        AccountRelationshipMaintenanceBatch.EnableRecalcToUltimateParentRecords(); // Set anything UP Related to true
    }
}