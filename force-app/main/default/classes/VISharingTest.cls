@isTest
private class VISharingTest {

    static Account acc, acc1, acc2;
    static User usr;

    static Map<String, String> pageParams;
    static PageReference pageRef;
    static VISharingController c;

    static void debug(String s) {System.debug(LoggingLevel.INFO, 'VISharingTest : ' + s);}

    static void showPageErrMsgs() {
        if (!ApexPages.hasMessages(ApexPages.Severity.ERROR)) {return;}
        for (ApexPages.Message m : ApexPages.getMessages()) {debug(m.getSummary());}
    }

    static void setPageParam(String k, String v) {
        pageParams.clear(); pageParams.put(k, v);
        debug('pageParams : ' + pageParams);
    }

    static void setController() {
        c = new VISharingController(); c.setAdmin(true);
    }

    static void setup() {
        Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = :VIUtils.CUSTOMER_PORTAL_NAME];
        } catch(Exception e) {return;}

        Contact contact = TestObjects.newContact();

        Account a = TestObjects.newAccount();

        contact.AccountId = a.Id;
        update contact;

        String profileId = [SELECT Id FROM Profile WHERE Profile.Name = :VIUtils.CUSTOMER_PORTAL_NAME].Id;
        String contactId = contact.Id;
        User u = TestObjects.newUser(new Map<String,String>{'ProfileId'=>profileId,
                                                            'ContactId'=>contactId
                                                           });

        usr = [select Id, ContactId, Contact.AccountId from User
                where ProfileId = :p.Id
                and isActive = true
                and Contact.Account.Inactive_Account__c = false
                and Contact.Account.Active_Account__c != 'No'
                limit 1];

        acc = [select Id, Name, AccountNumber from Account
                where Id = :usr.Contact.AccountId];

        acc1 = new Account(Name='Child1', ParentId=acc.Id);
        acc2 = new Account(Name='Child2', ParentId=acc.Id);
        List<Account> accs = new List<Account>{acc1, acc2}; insert accs;
        pageRef = Page.VIPortalRoleSharing; pageParams = pageRef.getParameters();
        setPageParam('id', acc.Id);
    }

    static testMethod void test01() {
        setup(); if (acc == null) {return;}
        Test.setCurrentPage(pageRef); Test.startTest();
        setController(); c.getChildAccsCount(); c.getSortFlds();
        c.getChildAccounts(); c.setAccounts(); c.getSharingsAdded();
        c.setRoleIdToAdd(); String roleId = c.userRoleId; c.getSharingsToAdd();
        c.pcFrst(); c.pcNext(); c.pcPrev(); c.pcLast(); c.pcSize();
        c.selectAllAccs(); c.addAccountShares();
        acc2.ParentId = null; update acc2; setController(); c.userRoleId = roleId;
        c.getSharingsToDel(); c.selectAllAccs(); c.deleteAccountShares();
    }
}