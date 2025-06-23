public with sharing class Attachment_Relationship_Settings {

	public static Attachment_Relationship_Settings__c defaultSettings() {
		Attachment_Relationship_Settings__c settings = Attachment_Relationship_Settings__c.getValues('Default');
		if(settings == null) {settings = Attachment_Relationship_Settings.createDefaultSettings();}
		return settings;
	}
	
	private static Attachment_Relationship_Settings__c createDefaultSettings() {
		Attachment_Relationship_Settings__c settings;
	    settings = new Attachment_Relationship_Settings__c(Name='Default');
		settings.Trigger_Enabled__c = false;
		insert settings;
		
		return settings;
	}
}