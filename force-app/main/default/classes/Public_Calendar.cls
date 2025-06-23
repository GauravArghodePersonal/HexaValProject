public with sharing class Public_Calendar {
	
	public static Id getId(String name) {
		Id result;
		
		Public_Calendar__c settings = Public_Calendar__c.getValues(name);
		
		if (settings != null) {
			result = settings.Public_Calendar_Id__c;
		}
		
		return result;
	}

}