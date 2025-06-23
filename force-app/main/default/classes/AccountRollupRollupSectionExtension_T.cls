@isTest
private class AccountRollupRollupSectionExtension_T {
/****************************************************************************
 * Test Class AccountRollupRollupSectionExtension_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollup_RollupSectionExtension Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
    //Test Settings
    
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        // No Test Data Needed
    }
  
    private static void executeTest01() {
        // Execute Tests
        Account_Relationship_Settings__c arSettings = Account_Relationship_Settings.retrieveDefaultSettings();
		arSettings.Relationships_Need_Processed__c = true;
		update arSettings;
        
        Attachment_Relationship_Settings__c attSettings = Attachment_Relationship_Settings.defaultSettings();
		attSettings.Trigger_Enabled__c = true;
		update attSettings;
        
        Account_Rollup_Settings__c rollupSettings = Account_Rollup_Settings.defaultSettings();
		rollupSettings.Triggers_Enabled__c = true;
		update rollupSettings;
        
		Account a = TestObjects.NewAccount();
		Account a2 = TestObjects.NewAccount();
		a2.ParentId = a.Id;
		update a2;
		
        ApexPages.currentpage().getparameters().put('id', a.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(a); 
        AccountRollupRollupSectionExtension e = new AccountRollupRollupSectionExtension(sc);
        
        e.getRollupRec();
        e.getShowAdminPanel();
		e.recalcAccountNow();
		e.getNoChildInfoExists();
		e.submitBatchJob_RecalcRollups();
		e.submitBatchJob_RecalcRollups_RefreshAll();
    }
}