@isTest
private class Permission_Set_Rule_Group_T {
/****************************************************************************
* Test Class Permission_Set_Rule_Group_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - Permission_Set_Rule_Group Apex Class
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
        
        PermissionSet ps = [Select Id, Label FROM PermissionSet LIMIT 1];
        String psId = ps.Id;

        Dynamic_Permission_Sets d = new Dynamic_Permission_Sets();
        d.add(ps.Id);
        
        Permission_Set_Rule_Group__c permissionSetRuleGroup = new Permission_Set_Rule_Group__c();
        permissionSetRuleGroup.Group_Name__c = 'Test';
        permissionSetRuleGroup.Is_Active__c = true;
        permissionSetRuleGroup.Short_Description__c = 'Test';
        permissionSetRuleGroup.Permission_Set_Id__c = ps.Id;
        insert permissionSetRuleGroup;
        
        Permission_Set_Rule_Group__c permissionSetRuleGroup2 = new Permission_Set_Rule_Group__c();
        permissionSetRuleGroup2.Group_Name__c = 'Test';
        permissionSetRuleGroup2.Is_Active__c = true;
        permissionSetRuleGroup2.Short_Description__c = 'Test';
        permissionSetRuleGroup2.Permission_Set_Id__c = null;
        insert permissionSetRuleGroup2;
        
        Permission_Set_Rule_Group__c permissionSetRuleGroup3 = new Permission_Set_Rule_Group__c();
        permissionSetRuleGroup3.Group_Name__c = 'Test';
        permissionSetRuleGroup3.Is_Active__c = true;
        permissionSetRuleGroup3.Short_Description__c = 'Test';
        permissionSetRuleGroup3.Permission_Set_Id__c = '001000000000000';
        insert permissionSetRuleGroup3;
        
        Permission_Set_Rule_Group__c permissionSetRuleGroup4 = new Permission_Set_Rule_Group__c();
        permissionSetRuleGroup4.Group_Name__c = 'Test';
        permissionSetRuleGroup4.Is_Active__c = true;
        permissionSetRuleGroup4.Short_Description__c = 'Test';
        permissionSetRuleGroup4.Permission_Set_Name__c = 'Test';
        insert permissionSetRuleGroup4;
        
        Id permissionSetGroupId = permissionSetRuleGroup.Id;
        Id permissionSetGroupId2 = permissionSetRuleGroup2.Id;
        Id permissionSetGroupId3 = permissionSetRuleGroup3.Id;
        Id permissionSetGroupId4 = permissionSetRuleGroup4.Id;
        
        List<Id> permissionSetGroupIds = new List<Id>();
        permissionSetGroupIds.add(permissionSetGroupId);
        permissionSetGroupIds.add(permissionSetGroupId2);
        permissionSetGroupIds.add(permissionSetGroupId3);
        permissionSetGroupIds.add(permissionSetGroupId4);
        
        List<Permission_Set_Rule_Group__c> permissionSetRuleGroups = new List<Permission_Set_Rule_Group__c>();
        permissionSetRuleGroups.add(permissionSetRuleGroup);
        permissionSetRuleGroups.add(permissionSetRuleGroup2);
        permissionSetRuleGroups.add(permissionSetRuleGroup3);
        permissionSetRuleGroups.add(permissionSetRuleGroup4);
        
		Permission_Set_Rule_Group.retrieveActiveWithPermissionSetGroupId(permissionSetGroupId);
		Permission_Set_Rule_Group.retrieveActiveWithPermissionSetGroupIds(permissionSetGroupIds);
		Permission_Set_Rule_Group.validate(permissionSetRuleGroup);
		Permission_Set_Rule_Group.validate(permissionSetRuleGroups);	
		Permission_Set_Rule_Group.buildWhereClauseforUserQuery(permissionSetRuleGroup);
		Permission_Set_Rule_Group.buildWhereClauseforUserQuery(permissionSetRuleGroups);
    }
}