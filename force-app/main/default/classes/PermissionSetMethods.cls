public with sharing class PermissionSetMethods {

	public static PermissionSet retrieveWithId(Id id) {
		PermissionSet result = null;

		try {
			result = [
			           SELECT Id, Name, Description, Label, CreatedDate, CreatedById, CreatedBy.Name, LastModifiedDate, LastModifiedById, ProfileId, UserLicenseId, UserLicense.Name
			             FROM PermissionSet
			            WHERE Id = :id
			          ];
		}
		catch (Exception e) {}
		
		return result;
	}
	
	public static List<PermissionSet> retrieveWithIds(List<Id> ids) {
		List<PermissionSet> results;

		try {
			results = [
			           SELECT Id, Name, Description, Label, CreatedDate, CreatedById, CreatedBy.Name, LastModifiedDate, LastModifiedById, ProfileId, UserLicenseId, UserLicense.Name
			             FROM PermissionSet
			            WHERE Id in :ids
			          ];
		}
		catch (Exception e) {results = new List<PermissionSet>();}
		
		return results;
	}
	
	public static PermissionSet retrieveWithName(String name) {
		PermissionSet result = null;

		try {
			result = [
			           SELECT Id, Name, Description, Label, CreatedDate, CreatedById, CreatedBy.Name, LastModifiedDate, LastModifiedById, ProfileId, UserLicenseId, UserLicense.Name
			             FROM PermissionSet
			            WHERE Name = :name
			          ];
		}
		catch (Exception e) {}
		
		return result;
	}
	
	public static PermissionSet retrieveWithLabel(String label) {
		PermissionSet result = null;

		try {
			result = [
			           SELECT Id, Name, Description, Label, CreatedDate, CreatedById, CreatedBy.Name, LastModifiedDate, LastModifiedById, ProfileId, UserLicenseId, UserLicense.Name
			             FROM PermissionSet
			            WHERE Label = :label
			          ];
		}
		catch (Exception e) {}
		
		return result;
	}
	
}