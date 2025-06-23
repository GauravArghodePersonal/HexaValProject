@isTest
private class AttachmentFolder_Extension_Test {

   static testMethod void myUnitTest() {
        Test.startTest();
      
        Account acc = new Account(Name='TestAccount');
        insert acc;
        
        Case c = new Case(Accountid=acc.Id);
        insert c;
        
        Attachment_Folder__c AF = new Attachment_Folder__c(Account__c = c.accountid);
        insert AF;
        AF = [select id, Level_1_Account_ID__c, Account__c from Attachment_Folder__c where id = :AF.id];
        
        Attachment_Folder__c AF2 = new Attachment_Folder__c(Parent_Folder__c = AF.id);
        insert AF2;
        AF2 = [select id, Level_2_Account_ID__c, Account__c from Attachment_Folder__c where id = :AF2.id];
        
        Attachment_Folder__C AF3 = new Attachment_Folder__c(Parent_Folder__c = AF2.id);
        insert AF3;
        AF3 = [select id, Level_3_Account_ID__c, Account__c from Attachment_Folder__c where id = :AF3.id];
        
        Blob b = Blob.valueOf('Test');
        Attachment a = new Attachment(Name='Test', parentid=c.Id, body=b);
        insert a;
        
        Attachment a1 = a.clone(false);
        a1.parentid = AF.id;
        insert a1;
        
        
        Attachment a2 = a.clone(false);
        a2.parentid = AF2.id;
        insert a2;
        Attachment a3 = a.clone(false);
        a3.parentid = AF3.id;
        insert a3;
        
        Apexpages.currentpage().getparameters().put('AccID', AF.Level_1_Account_ID__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(AF); 
        AttachmentFolder_Extension AFE = new AttachmentFolder_Extension(sc);

}

}