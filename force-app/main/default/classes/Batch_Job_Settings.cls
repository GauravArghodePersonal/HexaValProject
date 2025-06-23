public with sharing class Batch_Job_Settings {
 
	private static final String DEFAULT_PREFIX = 'Default';
	private static final String SCHEDULED_SUFFIX = '-S';
	private static final String UNSCHEDULED_SUFFIX = '-U';

	public static Batch_Job_Settings__c retrieveBatchJobSettings(String className, Boolean isScheduled) {
		Batch_Job_Settings__c results;
		String customSettingKey;
		String defaultCustomSettingKey;

		ApexClass apexClass; 
		try {
			apexClass = [SELECT Id, Name FROM ApexClass WHERE Name = :className];
		}
		catch (Exception e) {System.debug('*** ERROR *** Batch_Job_Settings-retrieveBatchJobSettings - Apex Class does not exist! ' + className);}

		if (apexClass != null) {
			if (isScheduled) {
				customSettingKey = apexClass.Id + SCHEDULED_SUFFIX;
				defaultCustomSettingKey = DEFAULT_PREFIX + SCHEDULED_SUFFIX;
			}
			else {
				customSettingKey = apexClass.Id + UNSCHEDULED_SUFFIX;
				defaultCustomSettingKey = DEFAULT_PREFIX + UNSCHEDULED_SUFFIX;
			}
	
			results = queryBatchJobSettings(apexClass,isScheduled,customSettingKey,defaultCustomSettingKey);
		}

		return results;
	}
	
	private static Batch_Job_Settings__c queryBatchJobSettings(ApexClass apexClass, Boolean isScheduled, String settingName, String defaultSettingName) {
		//Retrieve Batch Job Settings
		Batch_Job_Settings__c settings = Batch_Job_Settings__c.getValues(settingName);
		
		if(settings == null) {
			//Retrieve Default Settings if Batch Job Settings are not found
			Batch_Job_Settings__c defaultSettings = Batch_Job_Settings__c.getValues(defaultSettingName);
			
			if (defaultSettings == null) {
				//If no default settings are found, create and save default settings
				defaultSettings = new Batch_Job_Settings__c();
				defaultSettings.Name = defaultSettingName;
				defaultSettings.Batch_Class_Name__c = defaultSettingName;
				defaultSettings.Scheduled_Job__c = isScheduled; 
				insert defaultSettings;
			}

			//Save Default Settings to Batch Job Settings
			settings = defaultSettings.clone(false,true,false,false);
			settings.Name = settingName;
			settings.Batch_Class_Name__c = apexClass.Name;
			settings.Scheduled_Job__c = isScheduled; 
			insert settings;	
		}
		
		return settings;
	}
}