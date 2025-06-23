@isTest
private class Permission_Set_Rules_Batch_Processing_T {
/****************************************************************************
* Test Class Permission_Set_Rules_Batch_Processing_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - Permission_Set_Rules_Batch_Processing Apex Class
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
        //PermissionSet ps = [Select Id, Label FROM PermissionSet LIMIT 1];
        //String psId = ps.Id;

        //Dynamic_Permission_Sets d = new Dynamic_Permission_Sets();
        //d.add(ps.Id);
        
        //Permission_Set_Rule_Group__c permissionSetRuleGroup = new Permission_Set_Rule_Group__c();
        //permissionSetRuleGroup.Group_Name__c = 'Test';
        //permissionSetRuleGroup.Is_Active__c = true;
        //permissionSetRuleGroup.Short_Description__c = 'Test';
        //permissionSetRuleGroup.Permission_Set_Id__c = ps.Id;
        //insert permissionSetRuleGroup;
    }

    private static void executeTest01() {
        // Execute Tests
        Permission_Set_Rules_Batch_Processing.startSchedule();
        Permission_Set_Rules_Batch_Processing.submitBatchJob();
        Permission_Set_Rules_Batch_Processing.submitBatchJob(1);
        Permission_Set_Rules_Batch_Processing.submitBatchJob(1);
    }
}