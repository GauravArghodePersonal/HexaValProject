@isTest
private class ART_Release_T {
/****************************************************************************
 * Test Class ART_Release_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ART_Release Apex Class
 ****************************************************************************/
 
    //Test Data
    public static ART_Release__c release;
    
    public static List<ART_Release__c> releases = new List<ART_Release__c>();
    public static List<Id> releaseIds = new List<Id>();
    
    public static ART_Release rel;
    public static ART_Release.ART_Releases rels;
    
    public static List<SelectOption> selectOptions;
    
    
    //Test Settings
    
    
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    	User user = TestObjects.newUser();
    	
    	Public_Calendar__c settings;
	    settings = new Public_Calendar__c(Name=ART_Release.CALENDAR_NAME);
	    settings.Public_Calendar_Id__c = user.Id;
	    insert settings;
    	
        release = TestObjects.newART_Release();
        release.Name = 'Test Release';
        update release;
        
        releases.add(release);

        releaseIds.add(release.Id);
    }
  
    private static void executeTest01() {
        // Execute Tests
        ART_Release.updateEventsforReleases(release);
        ART_Release.updateEventsforReleases(release.Id);
        ART_Release.updateEventsforReleases(releases);
        ART_Release.updateEventsforReleases(releaseIds);
        
		release.Show_on_Release_Calendar__c = TRUE;
		release.Code_Freeze_Required__c = TRUE;
        release.SFDC_Release_Date__c = System.today();
        update release;

        release.SFDC_Release_Date__c = null;
        update release;

        release.SFDC_Release_Date__c = System.today();
        update release;

		release.Show_on_Release_Calendar__c = TRUE;
		release.Code_Freeze_Required__c = FALSE;
		update release;
		
		release.Show_on_Release_Calendar__c = TRUE;
		release.Code_Freeze_Required__c = TRUE;
		update release;
		
		release.Code_Freeze_Days_Before_Release__c = null;
		update release;
		
		release.Show_on_Release_Calendar__c = FALSE;
		update release;
		
		
		rel = new ART_Release(release);
		
		rels = ART_Release.query(false);
		rels = ART_Release.query(true);
		
		selectOptions = ART_Release.createSelectOptions(releases);
		selectOptions = ART_Release.createSelectOptions(rels.releases);
		selectOptions = ART_Release.openReleases;
		
		delete release;
		rels = ART_Release.query(false);
		
    }
}