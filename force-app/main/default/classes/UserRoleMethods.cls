public with sharing class UserRoleMethods {

	public static UserRole retrieveWithId(Id id) {
		UserRole result = null;
		try {
			result = [
			          SELECT Id, Name, ParentRoleId, DeveloperName, RollupDescription,
			                 (SELECT Id, Name, ProfileId, Profile.Name, UserRoleId, UserRole.Name, isActive FROM Users)
			            FROM UserRole 
			           WHERE Id = :id
			         ];
		}
		catch (Exception e) {}
		return result;
	}
	
	public static UserRole retrieveWithDeveloperName(String developerName) {
		UserRole result = null;
		try {
			result = [
			          SELECT Id, Name, ParentRoleId, DeveloperName, RollupDescription,
			                 (SELECT Id, Name, ProfileId, Profile.Name, UserRoleId, UserRole.Name, isActive FROM Users)
			            FROM UserRole 
			           WHERE DeveloperName = :developerName
			         ];
		}
		catch (Exception e) {}
		return result;
	}
	
	public static List<UserRole> retrieveWithName(String name) {
		List<UserRole> results = null;
		try {
			results = [
			          SELECT Id, Name, ParentRoleId, DeveloperName, RollupDescription,
			                 (SELECT Id, Name, ProfileId, Profile.Name, UserRoleId, UserRole.Name, isActive FROM Users)
			            FROM UserRole 
			           WHERE Name = :name
			         ];
		}
		catch (Exception e) {}
		return results;
	}
}