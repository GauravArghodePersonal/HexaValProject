public with sharing class ARTRequestManagementControllerMethods {

	/********************************* 
	 * URL Parameter Processing Class
	 *********************************/

	public class URLParameters {
		public Boolean useStartingDevUserId {get;set;}
		public String startingDevUserId {get;set;}
		public String showOnlyMe {get;set;}
		public String initialHiddenColumnsOverride {get;set;}
		
		public URLParameters(Map<String,String> parameters) {
			String devUserId = parameters.get('devUserId');
			String showOnlyMe = parameters.get('showOnlyMe');
			String hiddenColumns = parameters.get('hiddenColumnsOverride');

			useStartingDevUserId = false;
			
			if (showOnlyMe == 'true') {
				useStartingDevUserId = true;
				startingDevUserId = UserInfo.getUserId();
			}
			else {
				if (devUserId != null && devUserId != '') {
					if (IdMethods.isId(devUserId)) {
						useStartingDevUserId = true;
						startingDevUserId = devUserId;
					}
					else {
						if (devUserId == 'unassigned') {
							useStartingDevUserId = true;
							startingDevUserId = null;
						}
					}
				}
			}
			
			if (hiddenColumns!=null) {initialHiddenColumnsOverride = hiddenColumns;}
		}
	}
	
	/************************ 
	 * Public Static Methods
	 ************************/
	 
	public static List<Id> determineInitialProjectIds(String initialProjectIdsParam) {
		List<Id> results;
		
		if (initialProjectIdsParam != '') {
			results = initialProjectIdsParam.split(',');
		} 
		else {
			results = new List<Id>(ART_Project.query(false).projectIds);
		}
		
		return results;
	}

	public static List<Id> determineInitialReleaseIds(String initialReleaseIdsParam) {
		List<Id> results;
		
		if (initialReleaseIdsParam != '') {
			results = initialReleaseIdsParam.split(',');
		} 
		else {
			results = new List<Id>(ART_Release.query(false).releaseIds);
		}
		
		return results;
	}
}