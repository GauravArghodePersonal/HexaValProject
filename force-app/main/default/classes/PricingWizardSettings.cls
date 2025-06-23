global with sharing class PricingWizardSettings {

	global class Settings {
		webservice Boolean useNewAccountTree;
		webservice String awtDistChannelMaterialStatusFilter;
	}

	global static Settings retrieveSettings() {
		Id userId = UserInfo.getUserId(); 
		String orgId = UserInfo.getOrganizationId();
		return retrieveSettings(userId,orgId);		
	}

	global static Settings retrieveSettings(Id userId) {
		String orgId = UserInfo.getOrganizationId();
		return retrieveSettings(userId,orgId);		
	}

	global static Settings retrieveSettings(String orgId) {
		Id userId = UserInfo.getUserId(); 
		return retrieveSettings(userId,orgId);		
	}

	global static Settings retrieveSettings(Id userId, String orgId) {
		Settings settings = new Settings();
		
		Pricing_Wizard_Org_Settings__c orgSettings = retrievePricingWizardOrgSettings(orgId);
		//Pricing_Wizard_User_Settings__c userSettings = retrievePricingWizardUserSettings(userId);

		settings.useNewAccountTree = orgSettings.Use_New_Account_Tree__c;
		settings.awtDistChannelMaterialStatusFilter = orgSettings.AWT_Dist_Channel_Material_Status_Filter__c;
		
		if (settings.awtDistChannelMaterialStatusFilter == null) {
			settings.awtDistChannelMaterialStatusFilter = '';
		}
		
		return settings;		
	}

	private static Pricing_Wizard_Org_Settings__c retrievePricingWizardOrgSettings(String name) {
		Pricing_Wizard_Org_Settings__c settings = Pricing_Wizard_Org_Settings__c.getValues(name);
		if(settings == null) {settings = createPricingWizardOrgSettings(name);}
		return settings;
	}

	private static Pricing_Wizard_Org_Settings__c createPricingWizardOrgSettings(String name) {
		Pricing_Wizard_Org_Settings__c settings = Pricing_Wizard_Org_Settings__c.getValues('Default');
		if(settings == null) {
			settings = createDefaultPricingWizardOrgSettings();
		}
		
		Pricing_Wizard_Org_Settings__c newSettings = settings.clone(false,true,false,false);
		newSettings.Name = name;
		insert newSettings;
		settings = newSettings;
		
		return settings;
	}

	private static Pricing_Wizard_Org_Settings__c createDefaultPricingWizardOrgSettings() {
		Pricing_Wizard_Org_Settings__c settings;
	    settings = new Pricing_Wizard_Org_Settings__c(Name='Default');
		settings.Use_New_Account_Tree__c = false;
		settings.AWT_Dist_Channel_Material_Status_Filter__c = '';
		insert settings;
		return settings;
	}


	//private Pricing_Wizard_User_Settings__c retrievePricingWizardUserSettings(Id userId) {
	//	
	//}

	
	//global static Pricing_Wizard_User_Settings__c createDefaultPricingWizardUserSettings() {
	//	Pricing_Wizard_User_Settings__c settings;
	//  settings = new Pricing_Wizard_User_Settings__c(Name='Default');
	//	settings.Use_New_Account_Tree__c = false;
	//	insert settings;
	//	return settings;
	//}
	
}