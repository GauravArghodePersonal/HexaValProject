@isTest
private class Permission_Set_Rule_T {
/****************************************************************************
* Test Class Permission_Set_Rule_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - Permission_Set_Rule Apex Class
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
        Profile profile = [Select Id, Name FROM Profile LIMIT 1];
        UserRole userRole = [Select Id, Name, DeveloperName FROM UserRole LIMIT 1];
        User user = TestObjects.newUser();
        
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
        
        Permission_Set_Rule__c p = new Permission_Set_Rule__c();
        p.Rule_Type__c = Permission_Set_Rule.RULETYPE_ADD;
        p.Profile_Name__c = '*';
        p.Role_Name__c = '*';
        p.Group__c = permissionSetRuleGroup.Id;
        p.Is_Active__c = true;
        insert p;
        
        Permission_Set_Rule__c p2 = new Permission_Set_Rule__c();
        p2.Rule_Type__c = Permission_Set_Rule.RULETYPE_ADD;
        p2.Profile_Id__c = profile.Id;
        p2.Group__c = permissionSetRuleGroup.Id;
        p2.Is_Active__c = true;
        insert p2;
        
        Permission_Set_Rule__c p3 = new Permission_Set_Rule__c();
        p3.Rule_Type__c = Permission_Set_Rule.RULETYPE_SUBTRACT;
        p3.Role_Id__c = userRole.Id;
        p3.Group__c = permissionSetRuleGroup.Id;
        p3.Is_Active__c = true;
        insert p3;
        
        Permission_Set_Rule__c p4 = new Permission_Set_Rule__c();
        p4.Rule_Type__c = Permission_Set_Rule.RULETYPE_ADD;
        p4.User__c = user.Id;
        p4.Group__c = permissionSetRuleGroup.Id;
        p4.Is_Active__c = true;
        insert p4;

        Permission_Set_Rule__c p5 = new Permission_Set_Rule__c();
        p5.Rule_Type__c = Permission_Set_Rule.RULETYPE_ADD;
        p5.Profile_Name__c = profile.Name;
        p5.Group__c = permissionSetRuleGroup.Id;
        p5.Is_Active__c = true;
        insert p5;
        
        Permission_Set_Rule__c p6 = new Permission_Set_Rule__c();
        p6.Rule_Type__c = Permission_Set_Rule.RULETYPE_SUBTRACT;
        p6.Role_Name__c = userRole.Name;
        p6.Group__c = permissionSetRuleGroup.Id;
        p6.Is_Active__c = true;
        insert p6;
        

        
        List<Permission_Set_Rule__c> permissionSetRules = new List<Permission_Set_Rule__c>();
        permissionSetRules.add(p);
        permissionSetRules.add(p2);
        permissionSetRules.add(p3);
        permissionSetRules.add(p4);
        
		Permission_Set_Rule.validate(p);
		Permission_Set_Rule.validate(permissionSetRules);
		Permission_Set_Rule.buildWhereClauseforUserQuery(p);
		Permission_Set_Rule.buildWhereClauseforUserQuery(permissionSetRules);
        
    }
}