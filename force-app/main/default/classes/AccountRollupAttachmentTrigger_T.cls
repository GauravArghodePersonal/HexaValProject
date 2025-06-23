@isTest
private class AccountRollupAttachmentTrigger_T {
/****************************************************************************
 * Test Class AccountRollupAttachmentTrigger_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupAttachmentTrigger Apex Class
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
        Attachment_Relationship_Settings__c settings = Attachment_Relationship_Settings.defaultSettings();
        settings.Trigger_Enabled__c = true;
        update settings;
    }
  
    private static void executeTest01() {
        // Execute Tests
        Account a = TestObjects.newAccount(new Map<String,String>{'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Ultimate Parent', 'Account')});

        Blob b = Blob.valueOf('Test');

		Attachment aa = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>a.Id},false);

		aa.body = b;
		insert aa;
		
		aa.Name = 'Test 2';
		update aa;
		
		delete aa;
    }
}