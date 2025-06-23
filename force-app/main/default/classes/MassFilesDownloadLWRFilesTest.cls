@isTest
private class MassFilesDownloadLWRFilesTest {
    
    @TestSetup
    static void makeData() {
        List<Account> accounts = new List<Account>();        
        Account accountA = TestDataFactory.createAccount(false);
        accountA.ParentId = null;
        accounts.add(accountA);
        
        Account accountB = TestDataFactory.createAccount(false);
        accountB.ParentId = null;
        accounts.add(accountB);
        
        Insert accounts;
        
		List<LWR__c> lwrs = new List<LWR__c>();
		LWR__c lwrA = TestDataFactory.createlwr(false, accountA.Id);     
        lwrs.add(lwrA);
        
        LWR__c lwrB = TestDataFactory.createlwr(false, accountB.Id);
        lwrs.add(lwrB);
        
        Insert lwrs;
        
        List<ContentVersion> cvs = new List<ContentVersion>();
        ContentVersion cvA = new ContentVersion(
                                                Title = 'Penguins',
                                                PathOnClient = 'Penguins.jpg',
                                                VersionData = Blob.valueOf('Test Content'),
                                                IsMajorVersion = true
                                                );
        cvs.add(cvA);
        
        ContentVersion cvB = new ContentVersion(
                                                Title = 'Test Document',
                                                PathOnClient = 'Dummy.pdf',
                                                VersionData = Blob.valueOf('Test Content'),
                                                IsMajorVersion = true
                                                );
        cvs.add(cvB);
        
        Insert cvs;
        
        List<ContentDocumentLink> cdLinks = new List<ContentDocumentLink>();
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdlA = New ContentDocumentLink();
        cdlA.LinkedEntityId = lwrA.id;
		cdlA.ContentDocumentId = documents[0].Id;
		cdlA.shareType = 'V';
		cdLinks.add(cdlA);
        
        ContentDocumentLink cdlB = New ContentDocumentLink();
        cdlB.LinkedEntityId = lwrB.id;
        cdlB.ContentDocumentId = documents[1].Id;
        cdlB.shareType = 'V';
		cdLinks.add(cdlB);
        
        Insert cdLinks;
    }
    
    @isTest
    static void getfileIdsTest() {
		Test.startTest();
        List<Id> fileIds = MassFilesDownloadLWRFiles.getfileIds();
        Test.stopTest();
        System.debug(fileIds.size());
        System.assertEquals(2, fileIds.size());
    }

}