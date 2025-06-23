@isTest
private class AccountRollupAttachmentController_T {
/****************************************************************************
 * Test Class AccountRollupAttachmentController_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AccountRollupAttachmentController Apex Class
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

        Account a = TestObjects.newAccount(new Map<String,String>{'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Ultimate Parent', 'Account')});
        Account a2 = TestObjects.newAccount(new Map<String,String>{'RecordTypeId'=>RecordType_Functions.LookupRecordTypeId('Ultimate Parent', 'Account'),'ParentId'=>a.Id});
        Opportunity o = TestObjects.newOpportunity(new Map<String,String>{'AccountId'=>a.Id});
        Task t = TestObjects.newTask(new Map<String,String>{'WhatId'=>a.Id});
        Event e = TestObjects.newEvent(new Map<String,String>{'WhatId'=>a.Id});
        Case c = TestObjects.newCase(new Map<String,String>{'AccountId'=>a.Id});
        Sample_Request__c s = TestObjects.newSample_Request(new Map<String,String>{'Account__c'=>a.Id});

        Blob b = Blob.valueOf('Test');

        a2.ParentId = a.Id;
        update a2;

        Attachment aa = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>a.Id},false);
        Attachment aa2 = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>a2.Id},false);
        Attachment ao = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>o.Id},false);
        Attachment atsk = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>t.Id},false);
        Attachment aevt = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>e.Id},false);
        Attachment ac = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>c.Id},false);
        Attachment asamp = TestObjects.newAttachment(new Map<String,String>{'Name'=>'Test','ParentId'=>s.Id},false);

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

        ApexPages.currentpage().getparameters().put('id', a.Id);
        AccountRollupAttachmentController c1 = new AccountRollupAttachmentController();

        Attachment test = c1.attachment;

        Account_Rollup__c aRollup = new Account_Rollup__c();
        aRollup.Account__c = a.Id;
        aRollup.Attachment_Count__c = 1;
        insert aRollup;

        Account_Relationship__c ar = new Account_Relationship__c();
        ar.Parent_Account__c = a.Id;
        ar.Child_Account__c = a2.Id;
        insert ar;

        Account_Relationship__c ar2 = new Account_Relationship__c();
        ar2.Parent_Account__c = a2.Id;
        ar2.Child_Account__c = a2.Id;
        insert ar2;

        c1.processSelectionChange();
        c1.updateDynamicFilter1();
        c1.getItemSelected();
        //c1.getJsonString();

        c1.objectType = 'Opportunity';
        c1.selectedId = o.Id;
        c1.processSelectionChange();
        //c1.getJsonString();

        c1.objectType = 'Task';
        c1.selectedId = t.Id;
        c1.processSelectionChange();
        //c1.getJsonString();

        c1.objectType = 'Event';
        c1.selectedId = e.Id;
        c1.processSelectionChange();
        //c1.getJsonString();

        c1.objectType = 'Case';
        c1.selectedId = c.Id;
        c1.processSelectionChange();
        //c1.getJsonString();

        c1.objectType = 'Sample_Request__c';
        c1.selectedId = s.Id;
        c1.processSelectionChange();
        //c1.getJsonString();

        c1.saveAttachment();

        c1.attachment.body = b;
        c1.saveAttachment();

        c1.refreshAttachmentsTab();

        //c1.getJsonString();
    }
}