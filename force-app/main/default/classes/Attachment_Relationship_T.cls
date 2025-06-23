@isTest
private class Attachment_Relationship_T {
/****************************************************************************
 * Test Class Attachment_Relationship_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Attachment_Relationship_Functions Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Account a;
    public static Account a2;
    public static Opportunity o;
    public static Contact contact;
    public static Task t;
    public static Event e;
    public static Case c;
    public static Sample_Request__c s;

	public static Attachment aa;
	public static Attachment aa2;
	public static Attachment ao;
	public static Attachment acontact;
	public static Attachment atsk;
	public static Attachment aevt;
	public static Attachment ac;
	public static Attachment asamp;
    
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
        a = TestObjects.newAccount(new Map<String,String>{'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Ultimate Parent', 'Account')});
        a2 = TestObjects.newAccount(new Map<String,String>{'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Ultimate Parent', 'Account'),'ParentId'=>a.Id});
        o = TestObjects.newOpportunity(new Map<String,String>{'AccountId'=>a.Id});
        contact = TestObjects.newContact(new Map<String,String>{'AccountId'=>a.Id});
        t = TestObjects.newTask(new Map<String,String>{'WhatId'=>a.Id});
        e = TestObjects.newEvent(new Map<String,String>{'WhatId'=>a.Id});
        c = TestObjects.newCase(new Map<String,String>{'AccountId'=>a.Id});
        s = TestObjects.newSample_Request(new Map<String,String>{'Account__c'=>a.Id});

        Blob b = Blob.valueOf('Test');

		aa = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>a.Id},false);
		aa2 = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>a2.Id},false);
		ao = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>o.Id},false);
		acontact = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>contact.Id},false);
		atsk = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>t.Id},false);
		aevt = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>e.Id},false);
		ac = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>c.Id},false);
		asamp = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>s.Id},false);

		aa.body = b;
		insert aa;

		aa2.body = b;
		insert aa2;

		ao.body = b;
		insert ao;

		atsk.body = b;
		insert atsk;

		aevt.body = b;
		insert aevt;

		ac.body = b;
		insert ac;

		asamp.body = b;
		insert asamp;
		
		
    }
  
    private static void executeTest01() {
        // Execute Tests
		Attachment_Relationship.updateAttachmentRelationship(aa.Id);
		Attachment_Relationship.deleteAttachmentRelationship(aa.Id);
		
    }
}