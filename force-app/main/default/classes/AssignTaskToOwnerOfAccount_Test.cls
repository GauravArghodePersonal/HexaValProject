@isTest
private class AssignTaskToOwnerOfAccount_Test {

static testMethod void myUnitTest() {
        Test.startTest();
      
        Case c = new case();
        Account acc = new Account(Name='TestAccount');
        insert acc;
        Contact con = new Contact(LastName='LastName');
        con.AccountId = acc.Id;
        insert con;
        c.Accountid = acc.Id;
        c.contactid = con.id;
        insert c;
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        AssignTaskToOwnerOfAccount AT = new AssignTaskToOwnerOfAccount(sc);
        AT.AssignTask();

}



}