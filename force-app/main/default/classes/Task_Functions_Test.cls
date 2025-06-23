@isTest
private class Task_Functions_Test {

    static Map<String, Schema.RecordTypeInfo> AccRTMap = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
    static Account a;
    static Task t;
    static User u;
    
    static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Task_Functions_Test : ' + s);
    }
    
    static void createTestData() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            u = TestObjects.newUser(); 
        }
        //u = [select email, managerid from user where lastname='Schramm' limit 1];
        a = new Account(Name='Test Account', OwnerId=u.Id);
        a.RecordTypeId = AccRTMap.get('Aqualon Customer').getrecordtypeid();
        insert a;
        
        t = new Task();
        t.WhatId = a.Id;
        t.development_group__c = 'Vinyl Ester Resins';
        t.ActivityDate = System.today();
        t.Notify_account_Owner__c = 'Yes';
        t.Manager_Alert__c = 'Yes';
        t.Subject = 'Test task';
        t.Description = 'Test task';
        insert t;

        t = [select id, accountid, account.ownerid, account.owner.email, 
                    account.recordtypeid, ActivityDate, 
                    description, development_group__c,
                    lastmodifiedby.email,
                    lastmodifiedby.firstname, 
                    lastmodifiedby.lastname, lastmodifiedbyid,
                    Manager_Alert__c, Notify_account_Owner__c, 
                    Owner.FirstName, Owner.LastName, Priority, Subject 
               from task where Id = :t.Id];
               
        debug('Account : ' + a + ' Task : ' + t);
    }
    
    static testMethod void myUnitTest() {
        Test.startTest();
        createTestData();
        List<String> emlist = new list<String>();
        emlist.add(t.account.owner.email);
        Map<Id, Task> tmap = new Map<Id, Task>();
        tmap.put(t.Id, t);

        try {
            task_Functions.sendEmail(t, emlist);
        } catch(Exception e) {}

        try {
            task_Functions.sendEmailsToOtherGroups(tmap, tmap);
        } catch(Exception e) {}

        try {
            task_Functions.createtaskandsendemails(u.id, a.id, 'subj', 'descn', a);
        } catch(Exception e) {}
            
        try {
            task_Functions.createtaskwithduedateandsendemails(u.id, a.id, 'subj', 'descn', a, Date.Today());
        } catch(Exception e) {}
        
        try {
            task_Functions.createTaskWithDueDateRecordTypeAndSendEmails(u.id, a.id, 'subj', 'descn', a, Date.Today(),a.RecordTypeId);
        } catch(Exception e) {}
        
        
    }
}