public with sharing class OrgSettings {

	/**********************************
     * String setting1 = OrgSettings.retrieveSetting('Mergeboard_Enabled__c');
     * Boolean setting2 = Boolean.valueOf(OrgSettings.retrieveSetting('Mergeboard_Enabled__c'));
     **********************************/

	public static String retrieveSetting(String settingName) {
		String result;
		
		OrgSettings__c settings = OrgSettings__c.getInstance();
		
		try {
			result = String.valueOf(settings.get(settingName));
		}
		catch (Exception e) {
			result = null;
		}
		
		return result;
	} 
	
	public static Boolean settingExists(String settingName) {
		Boolean result;

		OrgSettings__c settings = OrgSettings__c.getInstance();
		
		try {
			settings.get(settingName);
			result = true;
		}
		catch (Exception e) {
			result = false;
		}
		
		return result;
	}
}