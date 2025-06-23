public with sharing class Dynamic_Permission_Sets {

	/*
	Dynamic_Permission_Sets dynamicPermissionSets = new Dynamic_Permission_Sets();
	dynamicPermissionSets.add('Market Price Books - Full User');
	*/

	public Map<String,Dynamic_Permission_Sets__c> allMap;
	public Map<Id,Dynamic_Permission_Sets__c> permissionSetIdMap;
	public Map<String,Dynamic_Permission_Sets__c> permissionSetNameMap;

	public Dynamic_Permission_Sets() {
		refresh();
	}

	public void refresh() {
		allMap = Dynamic_Permission_Sets.retrieveAll();
		permissionSetIdMap = Dynamic_Permission_Sets.convertAllMapToPermissionSetIdMap(allMap);
		permissionSetNameMap = Dynamic_Permission_Sets.convertAllMapToPermissionSetNameMap(allMap);
	}

	public Boolean exists(String permissionSetName) {
		if (IdMethods.isId(permissionSetName)) {
			return permissionSetIdMap.containsKey(permissionSetName);
		}
		else {
			return permissionSetNameMap.containsKey(permissionSetName);
		}
	}
	public Boolean exists(Id permissionSetId) {return permissionSetIdMap.containsKey(permissionSetId);}

	public Boolean add(Id permissionSetId) {
		PermissionSet permissionSet = PermissionSetMethods.retrieveWithId(permissionSetId);
		return add(permissionSet);
	}

	public Boolean add(String permissionSetLabel) {
		PermissionSet permissionSet = PermissionSetMethods.retrieveWithLabel(permissionSetLabel);
		return add(permissionSet);
	}
	
	public Boolean add(PermissionSet permissionSet) {
		List<String> errors = new List<String>();
		
		if (permissionSet != null) {
			//if (permissionSet.Id != '' && permissionSet.Id != null) {
			if (permissionSet.Id != null) {
				if (!exists(permissionSet.Id)) {
					Dynamic_Permission_Sets__c newItem = new Dynamic_Permission_Sets__c();
					newItem.Name = permissionSet.Id;
					newItem.Permission_Set_Id__c = permissionSet.Id;
					newItem.Permission_Set_Name__c = permissionSet.Label;
					try {
						insert newItem;
						validateAll();
					}
					catch (Exception e) {
						errors.add('Error inserting ' + newItem + ' - Exception is: ' + e);
					}
				}
				else {
					errors.add('Error inserting ' + permissionSet + ' - Permission Set is Already Configured as Dynamic.');
				}
			}
			else {
				errors.add('Error inserting ' + permissionSet + ' - Permission Set isn\'t in Salesforce yet, it has no Id.');
			}
		}
		else {
			errors.add('Error - Permission Set is null.');
		}
		
		if (!errors.isEmpty()) {System.debug('Errors occurred: ' + String.join(errors,'\n'));}
		
		refresh();
		
		return errors.isEmpty();
	}

	public Boolean remove(PermissionSet permissionSet) {return remove(permissionSet.Id);}
	public Boolean remove(String permissionSetName) {
		List<String> errors = new List<String>();
		
		Dynamic_Permission_Sets__c itemToDelete = permissionSetNameMap.get(permissionSetName);
		if (itemToDelete != null) {
			try {
				delete itemToDelete;
			}
			catch (Exception e) {
				errors.add('Error deleting ' + permissionSetName + ' - Exception is: ' + e);
			}
		}
		else {
			errors.add('Error: Unable to Locate entry for ' + permissionSetName);
		}
		
		if (!errors.isEmpty()) {System.debug('Errors occurred: ' + String.join(errors,'\n'));}
		
		refresh();
		
		return errors.isEmpty();
	}
	
	public Boolean remove(Id permissionSetId) {
		List<String> errors = new List<String>();
		
		Dynamic_Permission_Sets__c itemToDelete = permissionSetIdMap.get(permissionSetId);
		if (itemToDelete != null) {
			try {
				delete itemToDelete;
			}
			catch (Exception e) {
				errors.add('Error deleting ' + permissionSetId + ' - Exception is: ' + e);
			}
		}
		else {
			errors.add('Error: Unable to Locate entry for ' + permissionSetId);
		}
		
		if (!errors.isEmpty()) {System.debug('Errors occurred: ' + String.join(errors,'\n'));}
		
		refresh();
		
		return errors.isEmpty();
	}

	public Boolean validateAll() {
		List<String> errors = new List<String>();
		
		Dynamic_Permission_Sets dynamicPermissionSets = new Dynamic_Permission_Sets();
		List<Dynamic_Permission_Sets__c> itemsToUpdate = new List<Dynamic_Permission_Sets__c>(); 
		
		for (Dynamic_Permission_Sets__c item : dynamicPermissionSets.allMap.values()) {
			// Validate Permission Set
			Boolean permissionSetValid = false;
			Boolean itemChanged = false;
			PermissionSet permissionSet;
			
			if (String.isEmpty(item.Permission_Set_Id__c) && String.isEmpty(item.Permission_Set_Name__c)) {
				permissionSetValid = false;
				errors.add('Error: No Permission Set Name or Id was specified.');
			}
			else {
				if (String.isNotEmpty(item.Permission_Set_Id__c)) {
					// Attempt to populate using the Id 
					permissionSet = PermissionSetMethods.retrieveWithId(item.Permission_Set_Id__c);
					if (permissionSet != null) {
						if (item.Permission_Set_Name__c != permissionSet.Label) {
							item.Permission_Set_Name__c = permissionSet.Label;
							itemChanged = true;
						}
						permissionSetValid = true;
					}
					else {
						if (String.isNotEmpty(item.Permission_Set_Name__c)) {
							permissionSet = PermissionSetMethods.retrieveWithLabel(item.Permission_Set_Name__c);
							if (permissionSet != null) {
								if (item.Permission_Set_Id__c != permissionSet.Id) {
									item.Permission_Set_Id__c = permissionSet.Id;
									itemChanged = true;
								}
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
					if (String.isNotEmpty(item.Permission_Set_Name__c)) {
						// Attempt to populate using the Permission Set Name
						permissionSet = PermissionSetMethods.retrieveWithLabel(item.Permission_Set_Name__c);
						if (permissionSet != null) {
							if (item.Permission_Set_Id__c != permissionSet.Id) {
								item.Permission_Set_Id__c = permissionSet.Id;
								itemChanged = true;
							}
							permissionSetValid = true;
						}
						else {
							errors.add('Error: The Permission Set Id was not provided and the Permission Set Name is not valid.');
						}
					}
				}
			}
			
			String newErrors = String.join(errors,'\n');
			if (item.Validation_Errors__c != newErrors) {item.Validation_Errors__c = newErrors;itemChanged = true;}

			Boolean recordValid = errors.isEmpty();			
			if (item.Record_Valid__c != recordValid) {item.Record_Valid__c = recordValid;itemChanged = true;}
			
			if (itemChanged) {itemsToUpdate.add(item);}
		}
		
		
		if (!itemsToUpdate.isEmpty()) {update itemsToUpdate;}
		
		return errors.isEmpty();
	}

	public static Map<String,Dynamic_Permission_Sets__c> retrieveAll() {
		Map<String,Dynamic_Permission_Sets__c> results;
		results = Dynamic_Permission_Sets__c.getAll();
		return results;
	}
	
	public static Map<Id,Dynamic_Permission_Sets__c> convertAllMapToPermissionSetIdMap(Map<String,Dynamic_Permission_Sets__c> allMap) {
		Map<Id,Dynamic_Permission_Sets__c> results = new Map<Id,Dynamic_Permission_Sets__c>();
		for (Dynamic_Permission_Sets__c dynamicPermissionSet : allMap.values()) {
			results.put(dynamicPermissionSet.Permission_Set_Id__c,dynamicPermissionSet);			
		}
		return results;
	}
	
	public static Map<String,Dynamic_Permission_Sets__c> convertAllMapToPermissionSetNameMap(Map<String,Dynamic_Permission_Sets__c> allMap) {
		Map<String,Dynamic_Permission_Sets__c> results = new Map<String,Dynamic_Permission_Sets__c>();
		for (Dynamic_Permission_Sets__c dynamicPermissionSet : allMap.values()) {
			results.put(dynamicPermissionSet.Permission_Set_Name__c,dynamicPermissionSet);			
		}
		return results;
	}
	
}