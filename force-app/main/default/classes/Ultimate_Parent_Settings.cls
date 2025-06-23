public with sharing class Ultimate_Parent_Settings {

	public static Ultimate_Parent_Settings__c defaultSettings() {
		Ultimate_Parent_Settings__c settings = Ultimate_Parent_Settings__c.getValues('Default');
		if(settings == null) {settings = Ultimate_Parent_Settings.createDefaultSettings();}
		return settings;
	}
	
	private static Ultimate_Parent_Settings__c createDefaultSettings() {
		Ultimate_Parent_Settings__c settings;
	    settings = new Ultimate_Parent_Settings__c(Name='Default');
		settings.Strategic_Plan_Trigger_Enabled__c = false;
		insert settings;
		
		return settings;
	}
}