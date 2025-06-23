public with sharing class PermissionSetAssignmentMethods {

	public static final String SOBJECT_NAME = 'PermissionSetAssignment';

	public static final Set<String> FIELDS_MINIMUM = new Set<String>
	  {
		'Id', 
        'AssigneeId', 
        'PermissionSetId',
        'PermissionSet.Name',
        'PermissionSet.ProfileId',
        'PermissionSet.UserLicenseId' 	  	
	  };
	public static final Set<String> FIELDS = new Set<String>(PermissionSetAssignmentMethods.FIELDS_MINIMUM);

	public static List<PermissionSetAssignment> retrieveWithUserId(Id userId) {return retrieveWithUserIds(ListMethods.newWithData(userId));}
	public static List<PermissionSetAssignment> retrieveWithUserIds(List<Id> userIds) {
		List<PermissionSetAssignment> results;

		try {
			results = [
			           SELECT Id, AssigneeId, Assignee.Name, PermissionSetId, PermissionSet.Name 
			             FROM PermissionSetAssignment
			            WHERE AssigneeId in :userIds
			          ];	
		}
		catch (Exception e) {results = new List<PermissionSetAssignment>();}
		
		return results;
	}
	

}