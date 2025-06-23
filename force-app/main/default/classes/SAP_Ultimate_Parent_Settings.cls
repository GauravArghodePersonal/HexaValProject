public with sharing class SAP_Ultimate_Parent_Settings {

	public static SAP_Ultimate_Parent_Settings__c defaultSettings() {
		SAP_Ultimate_Parent_Settings__c settings = SAP_Ultimate_Parent_Settings__c.getValues('Default');
		if(settings == null) {settings = SAP_Ultimate_Parent_Settings.createDefaultSettings();}
		return settings;
	}
	
	private static SAP_Ultimate_Parent_Settings__c createDefaultSettings() {
		SAP_Ultimate_Parent_Settings__c settings;
	    settings = new SAP_Ultimate_Parent_Settings__c(Name='Default');
		settings.Account_Owner_Id__c = null;
		settings.Account_Owner_Id_When_Deleted__c = null;
		settings.Account_Owner_Name__c = '';
		settings.Account_Owner_Name_When_Deleted__c = '';
		settings.SAP_Ultimate_Parent_Trigger_Enabled__c = false;
		insert settings;
		
		return settings;
	}

}