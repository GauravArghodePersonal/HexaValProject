@IsTest
public class ContentDocTriggerHandlerTest {
    
    @IsTest
    Private static void validateAttachmentTest(){
        List<String> lwrList = new List<String>();
        Account Acc= TestDataFactory.createAccount(True);
        LWR__c lwr = TestDataFactory.createlwr(true, Acc.Id);
        ContentVersion cv = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
            );
        insert cv;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = lwr.id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		insert cdl;
        lwrList.add(lwr.Id);
        ContentDocTriggerHandler.validateAttachment(lwrList);
        }
	
    /**
     * @description TestMethod for processDeletedContentDocuments
     * @author      Lavakusareddy Poluru
     * @date		Created: 22-Jun-2022
     */
    @isTest
    static void processDeletedContentDocumentsTest(){        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Solenis Commercial NA PP' LIMIT 1];
        String uniqueName = LWRUtilities.getUnqiueUserName();
        User testUsr = TestDataFactory.createUser(false,uniqueName + '@testOrg.com',uniqueName.substring(18, 23));
        testUsr.alias = uniqueName.substring(18, 23);
        testUsr.ProfileId = p.Id;
        Insert testUsr;
        
        System.runAs(testUsr){
            try{
                Account acc= TestDataFactory.createAccount(false);
                acc.ParentId = null;
                Insert acc;
                
                LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);
                lwr.Status__c = LWRConstants.STATUS_ACCEPTED_IN_PROGRESS;
                lwr.Health_or_Safety_issues__c = 'none';
                lwr.Reason_for_the_Work__c = 'Goodwill';
                lwr.Type_Of_Work__c = 'Sales Service';
                lwr.Work_Request_Title__c = 'none';
                lwr.Requested_Date__c = system.today();
                lwr.Region__c = 'EMEA';
                lwr.Innova_Selection__c = 'EMEA-PPI-Other';
                lwr.File_Uploaded__c = true;
                Insert lwr;
                
                ContentVersion cv = new ContentVersion(
                    Title = 'Test Document',
                    PathOnClient = 'Dummy.pdf',
                    VersionData = Blob.valueOf('Test Content'),
                    IsMajorVersion = true
                    );
                insert cv;
                
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = lwr.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                insert cdl;
                Test.startTest();                
                if(Recursive_Check.hasAlreadyRan()) {Recursive_Check.reset();}
                delete documents;
                Test.stopTest();
            }catch(Exception ex){
               //System.assert(ex.getMessage().contains('You are not authorized to delete the attachment')); 
            }
        }        
    }
    
    /**
     * @description TestMethod for processRemovedContentDocumentLinks
     * @author      Lavakusareddy Poluru
     * @date		Created: 22-Jun-2022
     */
    @isTest
    static void processRemovedContentDocumentLinksTest(){        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Solenis Commercial NA PP' LIMIT 1];
        String uniqueName = LWRUtilities.getUnqiueUserName();
        User testUsr = TestDataFactory.createUser(false,uniqueName + '@testOrg.com',uniqueName.substring(18, 23));
        testUsr.alias = uniqueName.substring(18, 23);
        testUsr.ProfileId = p.Id;
        Insert testUsr;
        
        System.runAs(testUsr){
            try{
                Account acc= TestDataFactory.createAccount(false);
                acc.ParentId = null;
                Insert acc;
                
                LWR__c lwr = TestDataFactory.createlwr(false, Acc.Id);
                lwr.Status__c = LWRConstants.STATUS_ACCEPTED_IN_PROGRESS;
                lwr.Health_or_Safety_issues__c = 'none';
                lwr.Reason_for_the_Work__c = 'Goodwill';
                lwr.Type_Of_Work__c = 'Sales Service';
                lwr.Work_Request_Title__c = 'none';
                lwr.Requested_Date__c = system.today();
                lwr.Region__c = 'EMEA';
                lwr.Innova_Selection__c = 'EMEA-PPI-Other';
                lwr.File_Uploaded__c = true;
                Insert lwr;
                
                ContentVersion cv = new ContentVersion(
                    Title = 'Test Document',
                    PathOnClient = 'Dummy.pdf',
                    VersionData = Blob.valueOf('Test Content'),
                    IsMajorVersion = true
                    );
                insert cv;
                
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = lwr.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                insert cdl;
                Test.startTest();                
                if(Recursive_Check.hasAlreadyRan()) {Recursive_Check.reset();}
                delete cdl;
                Test.stopTest();
            }catch(Exception ex){
               //System.assert(ex.getMessage().contains('You are not authorized to remove the attachment')); 
            }
        }        
    }
    
    /**
     * @description TestMethod for uncheckFileUploadedOnLWR
     * @author      Lavakusareddy Poluru
     * @date		Created: 22-Jun-2022
     */
    @isTest
    static void uncheckFileUploadedOnLWRTest(){
    	List<String> lwrList = new List<String>();
        Account Acc= TestDataFactory.createAccount(True);
        LWR__c lwr = TestDataFactory.createlwr(true, Acc.Id);
        ContentVersion cv = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'Dummy.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
            );
        insert cv;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = lwr.id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.shareType = 'V';
		insert cdl;
        
        lwrList.add(lwr.Id);
        ContentDocTriggerHandler.validateAttachment(lwrList);
        lwr = [SELECT Id, File_Uploaded__c FROM LWR__c WHERE Id =:lwr.Id];
        System.assert(lwr.File_Uploaded__c);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Solenis Commercial NA PP' LIMIT 1];
        String uniqueName = LWRUtilities.getUnqiueUserName();
        User testUsr = TestDataFactory.createUser(false,uniqueName + '@testOrg.com',uniqueName.substring(18, 23));
        testUsr.alias = uniqueName.substring(18, 23);
        testUsr.ProfileId = p.Id;
        Insert testUsr;
        
        Test.startTest();
        ContentDocumentTriggerHandler.uncheckFileUploadedOnLWR(new Map<Id,ContentDocument>(documents));
        Test.stopTest();  
        
        lwr = [SELECT Id, File_Uploaded__c FROM LWR__c WHERE Id =:lwr.Id];
        System.assert(!lwr.File_Uploaded__c);
    }
}