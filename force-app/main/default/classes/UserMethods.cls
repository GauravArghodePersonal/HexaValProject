public with sharing class UserMethods {

	public static final String SOBJECT_NAME = 'User';
	public static final String RELATIONSHIP_PERMISSIONSETASSIGNMENTS = 'PermissionSetAssignments';
	public static final QueryBuilder.SubQuery SUBQUERY_PERMISSIONSETASSIGNMENTS_ALL = new QueryBuilder.SubQuery(RELATIONSHIP_PERMISSIONSETASSIGNMENTS,PermissionSetAssignmentMethods.FIELDS);

	public static final Set<String> FIELDS_MINIMUM = new Set<String>
	  {
		'Id', 
		'Name', 
		'ProfileId',
		'Profile.Name',
		'Profile.UserLicenseId',
		'UserRoleId',
		'UserRole.Name',
		'IsActive'
	  };
	public static final Set<String> FIELDS = new Set<String>(UserMethods.FIELDS_MINIMUM);
	

	public static List<User> retrieveUsers(Set<String> fieldList,String whereClause) {
		QueryBuilder.SubQuery subQuery;
		return retrieveUsers(fieldList,whereClause,subQuery);
	}
	
	public static List<User> retrieveUsers(Set<String> fieldList,String whereClause,QueryBuilder.SubQuery subQuery) {
		List<QueryBuilder.SubQuery> subqueries = new List<QueryBuilder.SubQuery>();
		if (subQuery != null) {
			subqueries.add(subQuery);
		}
		//List<QueryBuilder.SubQuery> subqueries = (List<QueryBuilder.SubQuery>)ListMethods.newWithData(subQuery);
		return retrieveUsers(fieldList,whereClause,subqueries);
	}
	public static List<User> retrieveUsers(Set<String> fieldList,String whereClause,List<QueryBuilder.SubQuery> subQueries) {
		List<User> results;
		
		String query = QueryBuilder.generateSOQL(UserMethods.SOBJECT_NAME,fieldList,whereClause,subQueries);
		
		try {
			results = Database.query(query);
		} 
		catch (Exception e) {results = new List<User>();}
		
		return results;
	}

	/***********************************
	 * Permission Set Specific Routines
     ***********************************/

	public static List<User> retrievePermissionSetInfoForUserId(Id userId) {return retrievePermissionSetInfoForUserIds(ListMethods.newWithData(userId));}
	public static List<User> retrievePermissionSetInfoForUserIds(List<Id> userIds) {
		List<User> results;
		
		try {
			results = [
			           SELECT Id, Name, ProfileId, Profile.Name, Profile.UserLicenseId, UserRoleId, UserRole.Name,IsActive,
			                  (SELECT Id, 
                                      AssigneeId, 
                                      PermissionSetId,
                                      PermissionSet.Name,
                                      PermissionSet.ProfileId,
                                      PermissionSet.UserLicenseId 
                                 FROM PermissionSetAssignments)
			             FROM User
			            WHERE Id in :userIds
			          ];	
		}
		catch (Exception e) {results = new List<User>();}
		
		return results;
	}
	
	public static Map<Id,Map<Id,PermissionSetAssignment>> retrievePermissionSetMapForUsers(List<User> users) {
		Map<Id,Map<Id,PermissionSetAssignment>> results = new Map<Id,Map<Id,PermissionSetAssignment>>();
		
		// Create a Map of existing User/PermissionSet Combinations 
		// The Map will be keyed by User Id, then a Map within each user with PermissionSet Id tied to an Assignment record
		Map<Id,Map<Id,PermissionSetAssignment>> existingSecurity = new Map<Id,Map<Id,PermissionSetAssignment>>();
		for (User user : users) {
			Map<Id,PermissionSetAssignment> values = new Map<Id,PermissionSetAssignment>();
			for (PermissionSetAssignment permissionSetAssignment : user.permissionSetAssignments) {
				values.put(permissionSetAssignment.PermissionSetId,permissionSetAssignment);
			}
			results.put(user.Id,values);
		}
		
		return results;
	}
	
	public static Boolean validPermissionSetforUser(User user,PermissionSet permissionSet) {
		Boolean result = true;
		if (permissionSet.UserLicenseId != null) {
			if (user.Profile.UserLicenseId != permissionSet.UserLicenseId) {
				result = false;	
			}
		}
		return result;
	}
}