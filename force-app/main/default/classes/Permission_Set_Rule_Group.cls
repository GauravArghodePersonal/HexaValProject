public with sharing class Permission_Set_Rule_Group {

	public static Permission_Set_Rule_Group__c retrieveActiveWithPermissionSetGroupId(Id permissionSetGroupId) {
		Permission_Set_Rule_Group__c result;
		List<Permission_Set_Rule_Group__c> permissionSetRuleGroups = retrieveActiveWithPermissionSetGroupIds(ListMethods.newWithData(permissionSetGroupId));
		if (permissionSetRuleGroups.size() > 0) {
			result = permissionSetRuleGroups[0];
		}
		return result;
	}
	
	public static List<Permission_Set_Rule_Group__c> retrieveActiveWithPermissionSetGroupIds(List<Id> permissionSetGroupIds) {
		List<Permission_Set_Rule_Group__c> results = new List<Permission_Set_Rule_Group__c>();

		try {
			results = [
			           SELECT Group_Name__c,
                              Permission_Set_Name__c,
                              Permission_Set_Id__c,
                              Short_Description__c,
                              Purpose__c,
                              Is_Active__c,
                              Has_Active_Rules__c,
                              Active_Rule_Count__c,
                              Inactive_Rule_Count__c,
                              Sort_Order__c,
                              (
                                  SELECT Id,
									     Rule_Type__c,
									     Is_Active__c,
									     Profile_Name__c,
									     Profile_Id__c,
									     Role_Name__c,
									     Role_Id__c,
									     User__c,
									     User_License_Filter__c,
									     Comments__c,
									     Sort_Order__c,
 									     Group__c,
									     Group_Permission_Set_Id__c,
									     Group_Permission_Set_Name__c,
									     Group_Name__c,
									     Group_Short_Description__c,
									     Group_Is_Active__c
								    FROM Permission_Set_Rules__r
								   WHERE Is_Active__c = true 
								     AND Record_Valid__c = true
								ORDER BY Rule_Type__c, Sort_Order__c 
                              )
                         FROM Permission_Set_Rule_Group__c
                        WHERE Id in :permissionSetGroupIds
                          AND Is_Active__c = true
                          AND Group_Valid__c = true
		             ORDER BY Sort_Order__c			           
			          ];
		}
		catch (Exception e) {}
		
		return results;
	}

/*
      public static List< Permission_Set_Rule_Group__c > retrieveActiveWithPermissionSetId(Id permissionSetId) {
           return retrieveActiveWithPermissionSetIds(ListMethods.newWithData(permissionSetId));
     }
     
      public static List< Permission_Set_Rule_Group__c > retrieveActiveWithPermissionSetIds(List<Id> permissionSetIds) {
          List< Permission_Set_Rule_Group__c > results = new List<Permission_Set_Rule_Group__c >();

           try {
              results = [
                         SELECT Group_Name__c,
                              Permission_Set_Name__c,
                              Permission_Set_Id__c,
                              Short_Description__c,
                              Purpose__c,
                              Is_Active__c,
                              Has_Active_Rules__c,
                              Active_Rule_Count__c,
                              Inactive_Rule_Count__c,
                              Sort_Order__c,
                              (
                                  SELECT Id,
                                                Rule_Type__c,
                                                Is_Active__c,
                                                Profile_Name__c,
                                                Profile_Id__c,
                                                Role_Name__c,
                                                Role_Id__c,
                                                User__c,
                                                Comments__c,
                                                Sort_Order__c,
                                                Group__c,
                                                Group_Permission_Set_Id__c,
                                                Group_Permission_Set_Name__c,
                                                Group_Name__c,
                                                Group_Short_Description__c,
                                                Group_Is_Active__c
                                          FROM Permission_Set_Rules__r
                                         WHERE Is_Active__c = true
                                      ORDER BY Rule_Type__c, Sort_Order__c
                              )
                         FROM Permission_Set_Rule_Group__c
                        WHERE Permission_Set_Id__c in :permissionSetIds
                          AND Is_Active__c = true
                          AND Has_Active_Rules__c = true
                          AND Group_Valid__c = true
                       ORDER BY Sort_Order__c                       
                        ];
          }
           catch (Exception e) {}
          
           return results;
     }
*/
	public static Permission_Set_Rule_Group__c validate(Permission_Set_Rule_Group__c permissionSetRuleGroup) {return (Permission_Set_Rule_Group__c)ListMethods.newWithData(permissionSetRuleGroup)[0];}
	public static List<Permission_Set_Rule_Group__c> validate(List<Permission_Set_Rule_Group__c> permissionSetRuleGroups) {
		for (Permission_Set_Rule_Group__c permissionSetRuleGroup : permissionSetRuleGroups) {
			List<String> errors = new List<String>();
			
			
			// Validate Permission Set
			Boolean permissionSetValid = false;
			PermissionSet permissionSet;
			
			if (String.isEmpty(permissionSetRuleGroup.Permission_Set_Id__c) && String.isEmpty(permissionSetRuleGroup.Permission_Set_Name__c)) {
				permissionSetValid = false;
				errors.add('Error: No Permission Set Name or Id was specified.');
			}
			else {
				if (String.isNotEmpty(permissionSetRuleGroup.Permission_Set_Id__c)) {
					// Attempt to populate using the Id 
					permissionSet = PermissionSetMethods.retrieveWithId(permissionSetRuleGroup.Permission_Set_Id__c);
					if (permissionSet != null) {
						permissionSetRuleGroup.Permission_Set_Id__c = permissionSet.Id;
						permissionSetRuleGroup.Permission_Set_Name__c = permissionSet.Label;
						permissionSetValid = true;
					}
					else {
						if (String.isNotEmpty(permissionSetRuleGroup.Permission_Set_Name__c)) {
							permissionSet = PermissionSetMethods.retrieveWithLabel(permissionSetRuleGroup.Permission_Set_Name__c);
							if (permissionSet != null) {
								permissionSetRuleGroup.Permission_Set_Id__c = permissionSet.Id;
								permissionSetRuleGroup.Permission_Set_Name__c = permissionSet.Label;
								permissionSetValid = true;
							}
							else {
								errors.add('Error: The Permission Set Id and Permission Set Name are not valid.');
							}
						}
						else {
							errors.add('Error: The Permission Set Id is not valid and no Permission Set Name was provided.');
						}
					}
				}
				else {
					if (String.isNotEmpty(permissionSetRuleGroup.Permission_Set_Name__c)) {
						// Attempt to populate using the Permission Set Name
						permissionSet = PermissionSetMethods.retrieveWithLabel(permissionSetRuleGroup.Permission_Set_Name__c);
						if (permissionSet != null) {
							permissionSetRuleGroup.Permission_Set_Id__c = permissionSet.Id;
							permissionSetRuleGroup.Permission_Set_Name__c = permissionSet.Label;
							permissionSetValid = true;
						}
						else {
							errors.add('Error: The Permission Set Id was not provided and the Permission Set Name is not valid.');
						}
					}
				}
			}
			
			// Validate Permision Set Rule is a valid "Dynamic" Permission Set Rule to Process - In Custom Settings
			Boolean isDynamicPermissionSet = false;
			if (permissionSetValid) {
				Dynamic_Permission_Sets dynamicPermissionSets = new Dynamic_Permission_Sets();
				isDynamicPermissionSet = dynamicPermissionSets.exists(permissionSetRuleGroup.Permission_Set_Id__c);
				if (!isDynamicPermissionSet) {
					errors.add('Error: The Permission Set information entered here is fine, but it is not configured as Dynamic in the Dynamic Permission Sets Custom Setting.');
				}
			}
			
			// Update Record_Valid__c and Validation Errors
			permissionSetRuleGroup.Record_Valid__c = (permissionSetValid && isDynamicPermissionSet);
			permissionSetRuleGroup.Validation_Errors__c = String.join(errors,'\n');
		}
		
		return permissionSetRuleGroups;
	}
	
	
	public static String buildWhereClauseforUserQuery(Permission_Set_Rule_Group__c permissionSetRuleGroup) {
		return buildWhereClauseforUserQuery((List<Permission_Set_Rule_Group__c>)ListMethods.newWithData(permissionSetRuleGroup));
	}

	public static String buildWhereClauseforUserQuery(List<Permission_Set_Rule_Group__c> permissionSetRuleGroups) {
		String result = '';
		List<Permission_Set_Rule__c> permissionSetRules = new List<Permission_Set_Rule__c>();
	
		for (Permission_Set_Rule_Group__c permissionSetRuleGroup : permissionSetRuleGroups) {
			permissionSetRules.addAll(permissionSetRuleGroup.Permission_Set_Rules__r);
		}

		if (!permissionSetRules.isEmpty()) {
			result = Permission_Set_Rule.buildWhereClauseforUserQuery(permissionSetRules);
		}		
		
		return result;
	}
}