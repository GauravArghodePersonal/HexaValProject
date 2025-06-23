public with sharing class Permission_Set_Rule {

	public static final String RULETYPE_ADD = 'Add';
	public static final String RULETYPE_SUBTRACT = 'Subtract';

	public static Permission_Set_Rule__c validate(Permission_Set_Rule__c permissionSetRule) {return (Permission_Set_Rule__c)ListMethods.newWithData(permissionSetRule)[0];}
	public static List<Permission_Set_Rule__c> validate(List<Permission_Set_Rule__c> permissionSetRules) {
		for (Permission_Set_Rule__c permissionSetRule : permissionSetRules) {
			List<String> errors = new List<String>();
			
			
			// Validate Profile
			Boolean profileInUse = true;
			Boolean profileValid = false;
			Boolean allProfiles = false;
			Profile profile;
			
			if (String.isEmpty(permissionSetRule.Profile_Id__c) && String.isEmpty(permissionSetRule.Profile_Name__c)) {
				profileValid = true;
				profileInUse = false;
			}
			else {
				if (permissionSetRule.Profile_Name__c == '*') {
					permissionSetRule.Profile_Id__c = '';
					profileValid = true;
					allProfiles = true;
				}
				else {
					if (String.isNotEmpty(permissionSetRule.Profile_Id__c)) {
						// Attempt to populate using the Id
						profile = ProfileMethods.retrieveWithId(permissionSetRule.Profile_Id__c);
						if (profile != null) {
							permissionSetRule.Profile_Name__c = profile.Name;
							profileValid = true;
						}
						else {
							if (String.isNotEmpty(permissionSetRule.Profile_Name__c)) {
								profile = ProfileMethods.retrieveWithName(permissionSetRule.Profile_Name__c);
								if (profile != null) {
									permissionSetRule.Profile_Id__c = profile.Id;
									profileValid = true;
								}
								else {
									errors.add('Error: The Profile Id and Profile Name are not valid.');
								}
							}
							else {
								errors.add('Error: The Profile Id is not valid and no Profile Name was provided.');
							}
						}
					}
					else {
						if (String.isNotEmpty(permissionSetRule.Profile_Name__c)) {
							// Attempt to populate using the Profile Name
							profile = ProfileMethods.retrieveWithName(permissionSetRule.Profile_Name__c);
							if (profile != null) {
								permissionSetRule.Profile_Id__c = profile.Id;
								profileValid = true;
							}
							else {
								errors.add('Error: The Profile Id was not provided and the Profile Name is not valid.');
							}
						}
					}
				}
			}
			
			// Validate Role
			Boolean roleInUse = true;
			Boolean roleValid = false;
			Boolean allRoles = false;
			UserRole userRole;
			List<UserRole> userRoles;
			if (String.isEmpty(permissionSetRule.Role_Id__c) && String.isEmpty(permissionSetRule.Role_Name__c)) {
				roleValid = true;
				roleInUse = false;
			}
			else { 
				if (permissionSetRule.Role_Name__c == '*') {
					permissionSetRule.Role_Id__c = '';
					roleValid = true;
					allRoles = true;
				}
				else {
					if (String.isNotEmpty(permissionSetRule.Role_Id__c)) {
						// Attempt to populate using the Id
						userRole = UserRoleMethods.retrieveWithId(permissionSetRule.Role_Id__c);
						if (userRole != null) {
							permissionSetRule.Role_Name__c = userRole.Name;
							roleValid = true;
						}
						else {
							if (String.isNotEmpty(permissionSetRule.Role_Name__c)) {
								userRoles = UserRoleMethods.retrieveWithName(permissionSetRule.Role_Name__c);
								if (userRoles.size() == 1) {
									userRole = userRoles[0];
									permissionSetRule.Role_Id__c = userRole.Id;
									roleValid = true;
								}
								else {
									errors.add('Error: The Role Id and Role Name are not valid. ' + userRoles.size() + ' matching role(s) were found based on the Role Name.');
								}
							}
							else {
								errors.add('Error: The Role Id is Not valid and No Role Name was provided.');
							}
						}
					}
					else {
						if (String.isNotEmpty(permissionSetRule.Role_Name__c)) {
							// Attempt to populate using the Role Name
							userRoles = UserRoleMethods.retrieveWithName(permissionSetRule.Role_Name__c);
							if (userRoles.size() == 1) {
								userRole = userRoles[0];
								permissionSetRule.Role_Id__c = userRole.Id;
								roleValid = true;
							}
							else {
								errors.add('Error: The Role Id was not provided and the Role Name is not valid. ' + userRoles.size() + ' matching role(s) were found based on the Role Name.');
							}
						}
					}
				}
			}
			
			Boolean userInUse = true;
			Boolean userValid = true;
			if (permissionSetRule.User__c == null) {
				userInUse = false;
			}
			
			Boolean inUse = true;
			// Make sure the record is actually in Use
			if (!profileInUse && !roleInUse && !userInUse) {
				inUse = false;
				errors.add('Warning: This record has no filter rules populated and will not affect rule processing.');
			}
			
			// Update Record_Valid__c and Validation Errors
			permissionSetRule.Record_Valid__c = (profileValid && roleValid && userValid);
			permissionSetRule.Validation_Errors__c = String.join(errors,'\n');
		}
		
		return permissionSetRules;
	}

	public static String buildWhereClauseforUserQuery(Permission_Set_Rule__c permissionSetRule) {
		return buildWhereClauseforUserQuery((List<Permission_Set_Rule__c>)ListMethods.newWithData(permissionSetRule));
	}
	
	public static String buildWhereClauseforUserQuery(List<Permission_Set_Rule__c> permissionSetRules) {
		String result = '';
		String perRowSplitOperator = ' OR '; 
		String sectionSplitOperator = ' AND '; 
		
		List<String> whereRowAdds = new List<String>();
		List<String> whereRowSubtracts = new List<String>();
		for (Permission_Set_Rule__c permissionSetRule : permissionSetRules) {
			String comparisionOperator;
			String picklistComparisionOperator;
			String withInRowSplitOperator; 
			if (permissionSetRule.Rule_Type__c == RULETYPE_ADD) {
				comparisionOperator = '=';
				picklistComparisionOperator = ' IN ';
				withInRowSplitOperator = ' AND ';
			}
			if (permissionSetRule.Rule_Type__c == RULETYPE_SUBTRACT) {
				comparisionOperator = '!=';
				picklistComparisionOperator = ' NOT IN ';
				withInRowSplitOperator = ' AND ';
			}
			
			List<String> whereRowItems = new List<String>();
			if (String.isNotEmpty(permissionSetRule.Profile_Id__c)) {
				if (permissionSetRule.Profile_Id__c != '*') {
					whereRowItems.add('ProfileId' + comparisionOperator + '\'' + permissionSetRule.Profile_Id__c + '\'');
				}
			} 
			if (String.isNotEmpty(permissionSetRule.Role_Id__c)) {
				if (permissionSetRule.Role_Id__c != '*') {
					whereRowItems.add('UserRoleId' + comparisionOperator + '\'' + permissionSetRule.Role_Id__c + '\'');
				}
			} 
			if (String.isNotEmpty(permissionSetRule.User__c)) {
				whereRowItems.add('Id' + comparisionOperator + '\'' + permissionSetRule.User__c + '\'');
			} 

			if (String.isNotEmpty(permissionSetRule.User_License_Filter__c)) {
				List<String> userLicenseFilters = permissionSetRule.User_License_Filter__c.split(';');
				List<String> userLicenseFiltersWithQuotes = new List<String>();
				for (String userLicenseFilter : userLicenseFilters) {
					userLicenseFiltersWithQuotes.add('\'' + userLicenseFilter + '\'');
				}
				String userLicenseFilterString = String.join(userLicenseFiltersWithQuotes,',');
				
				whereRowItems.add('Profile.UserLicense.Name' + picklistComparisionOperator + '(' + userLicenseFilterString + ')');
			} 

			if (whereRowItems.size() > 0) {
				if (permissionSetRule.Rule_Type__c == RULETYPE_ADD) {
					whereRowAdds.add('(' + String.join(whereRowItems,withInRowSplitOperator) + ')'); 
				}
				if (permissionSetRule.Rule_Type__c == RULETYPE_SUBTRACT) {
					whereRowSubtracts.add('(' + String.join(whereRowItems,withInRowSplitOperator) + ')'); 
				}
			}
		}

		List<String> whereSections = new List<String>();
		if (whereRowAdds.size() > 0) {whereSections.add('(' + String.join(whereRowAdds,perRowSplitOperator) + ')');}
		if (whereRowSubtracts.size() > 0) {whereSections.add('(' + String.join(whereRowSubtracts,perRowSplitOperator) + ')');}

		if (whereSections.size() > 0) {
			result = String.join(whereSections,sectionSplitOperator);
		}
		
		return result;
	}
}