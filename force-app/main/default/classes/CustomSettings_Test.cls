@isTest(SeeAllData=false)
private class CustomSettings_Test {
	
	static Account acc;
	static Contact con;
	static Profile prf;
	static User usr;
	static UserRole urole;
	static CustomSettings__c csc;

    static String profileName;

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'CustomSettings_Test : ' + s);
    }
    
    private static void setup() {
    	acc = new Account(Name='Test Account');
    	insert acc;
    	
    	con = new Contact(AccountId=acc.Id, LastName='Test');
    	insert con;

        List<Profile> plist = [SELECT Id FROM Profile WHERE Name = :profileName];
        if (plist.isEmpty()) {return;}
        prf = plist[0]; debug('Profile : ' + prf);
        
        csc = new CustomSettings__c(SetupOwnerId = prf.Id);
        csc.BW_Data_Hide_GMGP__c = true;
        insert csc; debug('Profile : ' + prf);

        usr = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                       EmailEncodingKey = 'UTF-8', LastName = 'Testing',
                       LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                       ProfileId = prf.Id, ContactId = con.Id, 
                       Ashland_Employee_Number__c = 'zzzTest16',
                       TimeZoneSidKey = 'America/Los_Angeles', 
                       Username = 'standarduser16@testorg.com');
        debug('User : ' + usr);

    }
    
    static void getUserData() {
        List<UserRole> userRoles = [SELECT PortalAccountId, PortalType
                                      FROM UserRole WHERE Id = :UserInfo.getUserRoleId()];        
        if (userRoles.isEmpty()) {return;}
        urole = userRoles[0]; debug('UserRole : ' + urole);
        
        csc = CustomSettings__c.getInstance(); debug('CustomSettings : ' + csc);
    }
//*    
    static testMethod void test01() {
        debug('BW_Data_Start_Date : '            + CustomSettings_Functions.getBW_Data_Start_Date());
        debug('BW_Data_BatchSize : '             + CustomSettings_Functions.getBW_Data_BatchSize());
        debug('BW_Data_LastModified_DateTime : ' + CustomSettings_Functions.getBW_Data_LastModified_DateTime());
        debug('BW_Data_Updating : '              + CustomSettings_Functions.getBW_Data_Updating());
        debug('ignoreApexTrigger : '             + CustomSettings_Functions.ignoreApexTrigger());
    }
//*/    
    static testMethod void test02() {
    	profileName = 'AWT - Distributor Partner Portal'; setup();
    	if (usr == null) {return;}
    	System.runAs(usr) {getUserData();}
    }
}