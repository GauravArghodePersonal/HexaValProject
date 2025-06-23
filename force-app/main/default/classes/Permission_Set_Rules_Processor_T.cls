@isTest
private class Permission_Set_Rules_Processor_T {
/****************************************************************************
* Test Class Permission_Set_Rules_Processor_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - Permission_Set_Rules_Processor Apex Class
****************************************************************************/
 
    //Test Data
	private static UserRole userRole;
	private static PermissionSet ps;
	private static Profile profile;
	private static User user;
	private static User user2;
	
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
    	User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    	System.runAs ( thisUser ) {
	        userRole = new UserRole();
	        userRole.DeveloperName = 'test';
	        userRole.Name = 'test';
	        insert userRole;
	        
	        ps = new PermissionSet();
	        ps.Name = 'test';
	        ps.Label = 'test';
	        insert ps;

	        profile = [Select Id, Name FROM Profile WHERE UserType = 'Standard' LIMIT 1];
	        user = TestObjects.newUser(new Map<String,String>{'ProfileId'=>profile.Id});
	        user2 = TestObjects.newUser(new Map<String,String>{'ProfileId'=>profile.Id,'UserRoleId'=>userRole.Id});
    	}
    }

    private static void executeTest01() {
        // Execute Tests
        //Profile profile = new Profile();
        //profile.Name = 'test';
       // insert profile;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        String psId = ps.Id;

        Dynamic_Permission_Sets d = new Dynamic_Permission_Sets();
        d.add(ps.Id);
        
        Permission_Set_Rule_Group__c permissionSetRuleGroup = new Permission_Set_Rule_Group__c();
        permissionSetRuleGroup.Group_Name__c = 'Test';
        permissionSetRuleGroup.Is_Active__c = true;
        permissionSetRuleGroup.Short_Description__c = 'Test';
        permissionSetRuleGroup.Permission_Set_Id__c = ps.Id;
        insert permissionSetRuleGroup;
        
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
        
        List<Id> permissionSetGroupIds = new List<Id>();
        permissionSetGroupIds.add(permissionSetRuleGroup.Id);
     
        System.runAs ( thisUser ) {
	   		Permission_Set_Rules_Processor.ProcessingResults processingResults = Permission_Set_Rules_Processor.processRulesForPermissionSetRuleGroupId(permissionSetRuleGroup.Id);
        }
   		
   		Permission_Set_Rules_Processor.SecurityChange sc1 = new Permission_Set_Rules_Processor.SecurityChange(
   			permissionSetRuleGroup.Id,
		    permissionSetRuleGroup.Name,
		    ps.Id,
		    ps.Name,
		    user.Id,
		    user.Name,
		    'profileName',
		    'roleName',
		    'action'
   		);

   		Permission_Set_Rules_Processor.SecurityChange sc2 = new Permission_Set_Rules_Processor.SecurityChange(
   			permissionSetRuleGroup.Id,
		    permissionSetRuleGroup.Name,
		    ps.Id,
		    ps.Name,
		    user.Id,
		    user.Name,
		    'profileName',
		    'roleName',
		    'action',
		    true
   		);
   		
   		Permission_Set_Rules_Processor.ProcessingResults pr1 = new Permission_Set_Rules_Processor.ProcessingResults(
   			permissionSetRuleGroup.Id,
		    permissionSetRuleGroup.Name,
		    ps.Id,
		    ps.Name
   		);  
   		pr1.addComment('test');
   		pr1.newSecurityChange_PermissionSetAdded(user);
   		pr1.newSecurityChange_PermissionSetAdded(user.Id,'','','');
   		pr1.newSecurityChange_PermissionSetRemoved(user);
   		pr1.newSecurityChange_PermissionSetRemoved(user.Id,'','','');
   		pr1.newSecurityChange_PermissionSetAdded(user,true);
   		pr1.newSecurityChange_PermissionSetAdded(user.Id,'','','',true);
   		pr1.newSecurityChange_PermissionSetRemoved(user,true);
   		pr1.newSecurityChange_PermissionSetRemoved(user.Id,'','','',true);
   		 
   		PermissionSetAssignment psa1 = new PermissionSetAssignment(); 
   		PermissionSetAssignment psa2 = new PermissionSetAssignment();
   		
   		Set<PermissionSetAssignment> psas = new Set<PermissionSetAssignment>();
   		psas.add(psa1); 
   		psas.add(psa2); 
   		 
   		Permission_Set_Rules_Processor.Instruction i1 = new Permission_Set_Rules_Processor.Instruction(psas,psas,true);
   		Permission_Set_Rules_Processor.Instruction i2 = new Permission_Set_Rules_Processor.Instruction(psas,psas,true);
   		Set<Id> userIdsSet = new Set<Id>();
   		
    	System.runAs ( thisUser ) {
   			userIdsSet.add(user.Id);
    	}
    	
   		i1.ignoredUserIds = userIdsSet;
   		i1.outputToString();
   		i1.outputToStringSummary();
   		i1.append(i2);
   		i1.remove(i2);
   		
   		System.runAs ( thisUser ) {
	   		Permission_Set_Rules_Processor.ProcessingResults pr2 = Permission_Set_Rules_Processor.processRulesForPermissionSetRuleGroupIds(permissionSetGroupIds);
   		}
   		
   		Permission_Set_Rules_Processor.retrieveUserIdsThatHavePermissionSet(ps.Id);
		//Permission_Set_Rules_Processor.adjustSecurity(Permission_Set_Rule.RULETYPE_ADD, Map<Id,User> userMap, List<Id> permissionSetIds, Boolean applyChanges) {
   		
    }
}