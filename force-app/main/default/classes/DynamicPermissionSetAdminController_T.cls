@isTest
private class DynamicPermissionSetAdminController_T {
/****************************************************************************
 * Test Class DynamicPermissionSetAdminController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - DynamicPermissionSetAdminController Apex Class
 ****************************************************************************/
 
    //Test Data
    private static PermissionSet ps;
    
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
        Profile profile = [Select Id, Name FROM Profile LIMIT 1];
        
        ps = [Select Id, Label FROM PermissionSet LIMIT 1];
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
        p.Profile_Name__c = profile.Id;
        p.Group__c = permissionSetRuleGroup.Id;
        p.Is_Active__c = true;
        insert p;
        
    }
  
    private static void executeTest01() {
        // Execute Tests
		DynamicPermissionSetAdminController c = new DynamicPermissionSetAdminController();
		
		c.permissionSetId = ps.Id;
		
		c.runButDoNotApplyChangesHandler();
		c.runAndApplyChangesHandler();
		
    }


}