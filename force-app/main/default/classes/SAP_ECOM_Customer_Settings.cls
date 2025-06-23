public with sharing class SAP_ECOM_Customer_Settings {

	public static SAP_ECOM_Customer_Settings__c retrieveDefaultSettings() {
		SAP_ECOM_Customer_Settings__c settings = SAP_ECOM_Customer_Settings__c.getValues('Default');
		if(settings == null) {settings = SAP_ECOM_Customer_Settings.createDefaultSettings();}
		return settings;
	}
	
	public static SAP_ECOM_Customer_Settings__c createDefaultSettings() {
		SAP_ECOM_Customer_Settings__c settings;
	    settings = new SAP_ECOM_Customer_Settings__c(Name='Default');
		settings.Account_Last_Run_Date_Time__c = DateTime.now();
		settings.Account_New_Batch_Job_Started__c = DateTime.now();
		settings.Account_Batch_Job_Running__c = false;
		settings.Triggers_Enabled__c = false;
		insert settings;
		
		return settings;
	}

	public static DateTime retrieveAccountLastRunDateTime() { 
		SAP_ECOM_Customer_Settings__c settings = SAP_ECOM_Customer_Settings.retrieveDefaultSettings();
		return settings.Account_Last_Run_Date_Time__c;
	}
	
	public static void updateAccountLastRunDateTime(DateTime newLastRunDateTime) {
		SAP_ECOM_Customer_Settings__c settings = SAP_ECOM_Customer_Settings.retrieveDefaultSettings();
		settings.Account_Last_Run_Date_Time__c = newLastRunDateTime;
		update settings;
	} 

	public static DateTime retrieveAccountNewBatchJobStarted() { 
		SAP_ECOM_Customer_Settings__c settings = SAP_ECOM_Customer_Settings.retrieveDefaultSettings();
		return settings.Account_New_Batch_Job_Started__c;
	}

	public static void updateAccountNewBatchJobStarted(DateTime newBatchJobStarted) {
		SAP_ECOM_Customer_Settings__c settings = SAP_ECOM_Customer_Settings.retrieveDefaultSettings();
		settings.Account_New_Batch_Job_Started__c = newBatchJobStarted;
		update settings;
	} 
	
	public static Boolean retrieveAccountBatchJobRunning() { 
		SAP_ECOM_Customer_Settings__c settings = SAP_ECOM_Customer_Settings.retrieveDefaultSettings();
		return settings.Account_Batch_Job_Running__c;
	}

	public static void updateAccountBatchJobRunning(Boolean isRunning) {
		SAP_ECOM_Customer_Settings__c settings = SAP_ECOM_Customer_Settings.retrieveDefaultSettings();
		settings.Account_Batch_Job_Running__c = isRunning;
		update settings;
	} 
	

}