public with sharing class Account_Rollup_Settings {

	public static Account_Rollup_Settings__c defaultSettings() {
		Account_Rollup_Settings__c settings = Account_Rollup_Settings__c.getValues('Default');
		if(settings == null) {settings = Account_Rollup_Settings.createDefaultSettings();}
		return settings;
	}
	
	private static Account_Rollup_Settings__c createDefaultSettings() {
		Account_Rollup_Settings__c settings;
	    settings = new Account_Rollup_Settings__c(Name='Default');
		settings.Triggers_Enabled__c = false;
		insert settings;
		
		return settings;
	}
}