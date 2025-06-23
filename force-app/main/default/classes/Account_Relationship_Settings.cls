public with sharing class Account_Relationship_Settings {

    public static Boolean relationshipsNeedProcessed() {
    	Account_Relationship_Settings__c settings = retrieveDefaultSettings();
    	return settings.Relationships_Need_Processed__c;
    }
   
    public static void relationshipsNeedProcessed(Boolean value) {
    	Account_Relationship_Settings__c settings = retrieveDefaultSettings();
    	if (settings.Relationships_Need_Processed__c != value) {
    		try {
	    		settings.Relationships_Need_Processed__c = value;
	    		update settings;
    		}
    		catch (Exception e) {}
    	}
    }
   
   	public static Account_Relationship_Settings__c retrieveDefaultSettings() {
		Account_Relationship_Settings__c settings = Account_Relationship_Settings__c.getValues('Default');
		if(settings == null) {settings = createDefaultSettings();}
		return settings;
	}
   
   	private static Account_Relationship_Settings__c createDefaultSettings() {
		Account_Relationship_Settings__c settings;
	    settings = new Account_Relationship_Settings__c(Name='Default');
		settings.Relationships_Need_Processed__c = false;
		insert settings;
		
		return settings;
	}
}