global with sharing class Flex_Framework_Settings {

  global class Settings {
    webservice Boolean showUnhandledErrorPopup;
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
    
    Flex_Framework_Org_Settings__c orgSettings = retrieveFlexFrameworkOrgSettings(orgId);
    //Flex_Framework_User_Settings__c userSettings = retrieveFlexFrameworkUserSettings(userId);

    settings.showUnhandledErrorPopup = orgSettings.Show_Unhandled_Error_Popup__c;
    
    return settings;    
  }

  private static Flex_Framework_Org_Settings__c retrieveFlexFrameworkOrgSettings(String name) {
    Flex_Framework_Org_Settings__c settings = Flex_Framework_Org_Settings__c.getValues(name);
    if(settings == null) {settings = createFlexFrameworkOrgSettings(name);}
    return settings;
  }

  private static Flex_Framework_Org_Settings__c createFlexFrameworkOrgSettings(String name) {
    Flex_Framework_Org_Settings__c settings = Flex_Framework_Org_Settings__c.getValues('Default');
    if(settings == null) {
      settings = createDefaultFlexFrameworkOrgSettings();
    }
    
    Flex_Framework_Org_Settings__c newSettings = settings.clone(false,true,false,false);
    newSettings.Name = name;
    insert newSettings;
    settings = newSettings;
    
    return settings;
  }

  private static Flex_Framework_Org_Settings__c createDefaultFlexFrameworkOrgSettings() {
    Flex_Framework_Org_Settings__c settings;
      settings = new Flex_Framework_Org_Settings__c(Name='Default');
    settings.Show_Unhandled_Error_Popup__c = false;
    insert settings;
    return settings;
  }


  //private Flex_Framework_User_Settings__c retrieveFlexFrameworkUserSettings(Id userId) {
  //  
  //}

  
  //global static Flex_Framework_User_Settings__c createDefaultFlexFrameworkUserSettings() {
  //  Flex_Framework_User_Settings__c settings;
  //  settings = new Flex_Framework_User_Settings__c(Name='Default');
  //  settings.Show_Unhandled_Error_Popup__c = false;
  //  insert settings;
  //  return settings;
  //}
  
}