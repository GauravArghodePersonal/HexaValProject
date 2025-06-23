/********************************************REVISION HIStory********************************
* [CCC-44] New controlled document added to test the {CQ_CCC_ControlledDocumentMigrationBatch}.
* [CCC-31] Document Migration Utility: Test for Case Sensitive File Names are handled.
*********************************************REVISION HIStory********************************/
@IsTest
public class CQ_CCC_Test_ControlledDocMigrationBatch {
    private static String responseBody {get; set;} 
    
    @testSetup static void testSetup() {
        //create test libraries
        List<contentWorkSpace> cws = new List<contentWorkspace>();
        cws.add(new contentWorkSpace(Name='CQTESTDRAFTLIBRARY123213'));
        cws.add(new contentWorkSpace(Name='CQTESTRELEASELIBRARY123213'));
        insert cws;
    }
    
    static testmethod void givenControlledDocumentAndContents_whenControlledDocumentMigrationBatchisRun_thenAppropriateDcumentandCOntentsaAreMigrated() {

        // Arrange: Create Two libraries with R/W access
        ContentWorkspace[] ws = [SELECT Id, Name FROM ContentWorkspace WHERE name in('CQTESTDRAFTLIBRARY123213','CQTESTRELEASELIBRARY123213') LIMIT 2];
        String controlledDoc = [SELECT Id,Name FROM RecordType WHERE SobjectType='compliancequest__SQX_Controlled_Document__c' and DeveloperName='Controlled_Document' LIMIT 1].Id;
        String inspectionCriteria = [SELECT Id,Name FROM RecordType WHERE SobjectType='compliancequest__SQX_Controlled_Document__c' and DeveloperName='Inspection_Criteria' LIMIT 1].Id;
        String auditCriteria = [SELECT Id,Name FROM RecordType WHERE SobjectType='compliancequest__SQX_Controlled_Document__c' and DeveloperName='Audit_Criteria' LIMIT 1].Id;
        String templateDocument = [SELECT Id,Name FROM RecordType WHERE SobjectType='compliancequest__SQX_Controlled_Document__c' and DeveloperName='Template_Document' LIMIT 1].Id;
        String courser = [SELECT Id,Name FROM RecordType WHERE SobjectType='compliancequest__SQX_Controlled_Document__c' and DeveloperName='Course' LIMIT 1].Id;
        System.assert(ws.size() >= 2, 'At least 2 libraries with r/w access needed for test to go through');

        //Arrange: Document 1 with Secondary Content as Manual and Primary and Secondary File Name is provided
        //To handle the Case Sensitive file name.
        compliancequest__SQX_Controlled_Document__c doc1 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-1',
            compliancequest__Title__c = 'Document 1',
            compliancequest__Batch_Job_Status__c = 'Import-Draft',
            CQ_CCC_FileName__c = 'PrimaryContentFile1.PDF',
            CQ_CCC_Secondary_FileName__c = 'SecondaryFile1.DoCx',
            CQ_CCC_Draft_Library_Name__c = ws[0].Name,
            CQ_CCC_Release_Library_Name__c = ws[1].Name,
            compliancequest__Secondary_Content__c = 'Manual',
            RecordTypeId = controlledDoc
         );

        //Arrange: Document 2 with Secondary Content as Manual and Secondary File Name is not provided
        compliancequest__SQX_Controlled_Document__c doc2 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-2',
            compliancequest__Title__c = 'Document 2',
            compliancequest__Batch_Job_Status__c = 'Import-Draft',
            CQ_CCC_FileName__c = 'PrimaryContentFile2.xlsx',
            CQ_CCC_Draft_Library_Name__c = ws[0].Name,
            CQ_CCC_Release_Library_Name__c = ws[1].Name,
            compliancequest__Secondary_Content__c = 'Manual',
            RecordTypeId = controlledDoc
        );

        //Arrange: Document 3 with Secondary Content as Auto
        compliancequest__SQX_Controlled_Document__c doc3 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-3',
            compliancequest__Title__c = 'Document 3',
            compliancequest__Batch_Job_Status__c = 'Import-Draft',
            CQ_CCC_FileName__c = 'PrimaryContentFile3.docx',
            CQ_CCC_Draft_Library_Name__c = ws[0].Name,
            CQ_CCC_Release_Library_Name__c = ws[1].Name,
            compliancequest__Secondary_Content__c = 'Auto',
            RecordTypeId = controlledDoc
        );

        //Arrange: Document 4 with Secondary Content as Auto and Secondary File Name also provided
        compliancequest__SQX_Controlled_Document__c doc4 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-4',
            compliancequest__Title__c = 'Document 4',
            compliancequest__Description__c = 'long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description' , 
            compliancequest__Batch_Job_Status__c = 'Import-Draft',
            CQ_CCC_Draft_Library_Name__c = ws[0].Name,
            CQ_CCC_Release_Library_Name__c = ws[1].Name,
            RecordTypeId = inspectionCriteria
        );

        //Arrange: Document 5 with Secondary Content as Auto and File Name is same as document 3
        compliancequest__SQX_Controlled_Document__c doc5 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-5',
            compliancequest__Title__c = 'Document 5',
            compliancequest__Batch_Job_Status__c = 'Import-Draft',
            CQ_CCC_FileName__c = 'PrimaryContentFile3.docx',
            CQ_CCC_Draft_Library_Name__c = ws[0].Name,
            CQ_CCC_Release_Library_Name__c = ws[1].Name,
            compliancequest__Secondary_Content__c = 'Auto',
            RecordTypeId = controlledDoc
        );
        
        //[CCC-44] New controlled document added for test {Start}
        //Arrange: Document 7 with Primary and Secondary file and with secondary content Auto
        //To Cover the lines of code for Batch Job status and Secondary content
        compliancequest__SQX_Controlled_Document__c doc7 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-7',
            compliancequest__Title__c = 'Document 7',
            compliancequest__Description__c = 'long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description' , 
            compliancequest__Batch_Job_Status__c = 'Import-Current',
            CQ_CCC_FileName__c = 'PrimaryContentFile7.pdf',
            CQ_CCC_Secondary_FileName__c = 'SecondaryFile7.docx',
            compliancequest__Secondary_Content__c = 'Auto',
            CQ_CCC_Draft_Library_Name__c = ws[0].Name,
            CQ_CCC_Release_Library_Name__c = ws[1].Name,
            RecordTypeId = inspectionCriteria
        );
        
        //Arrange: Document 8 without filename
        //To Cover "Filename missing, Please specify file name in Render Job Error"
        compliancequest__SQX_Controlled_Document__c doc8 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-8',
            compliancequest__Title__c = 'Document 8',
            compliancequest__Description__c = 'long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description' , 
            compliancequest__Batch_Job_Status__c = 'IMPORT-Obsolete',
            compliancequest__Secondary_Content__c = 'Manual',
            CQ_CCC_Draft_Library_Name__c = ws[0].Name,
            CQ_CCC_Release_Library_Name__c = ws[1].Name,
            RecordTypeId = controlledDoc
        );
        
        //Arrange: Document 9 without Draft and Release Library
        // To Cover "Specified Draft and Release library not found or user does not have access to the library
        compliancequest__SQX_Controlled_Document__c doc9 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-9',
            compliancequest__Title__c = 'Document 9',
            compliancequest__Description__c = 'long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description' , 
            compliancequest__Batch_Job_Status__c = 'Import-Draft',
            CQ_CCC_FileName__c = 'PrimaryContentFile9.pdf',
            CQ_CCC_Secondary_FileName__c = 'SecondaryFile9.docx',
            RecordTypeId = inspectionCriteria
        );
        
        //Arrange: Document 10 with Primary file name without file in the content
        //To Cover "Content Not Found, content should be in private library with title matching file name without extension"
        compliancequest__SQX_Controlled_Document__c doc10 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-10',
            compliancequest__Title__c = 'Document 10',
            compliancequest__Description__c = 'long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description' , 
            compliancequest__Batch_Job_Status__c = 'Import-Draft',
            CQ_CCC_FileName__c = 'PrimaryContentFile10.pdf',
            RecordTypeId = inspectionCriteria
        );
        
        //Arrange: Document 11 with Secondary Content disbled
        //To Cover the when the secondary content is disabled
        compliancequest__SQX_Controlled_Document__c doc11 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-11',
            compliancequest__Title__c = 'Document 11',
            compliancequest__Description__c = 'long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description' , 
            compliancequest__Batch_Job_Status__c = 'Import-Draft',
            CQ_CCC_Draft_Library_Name__c = ws[0].Name,
            CQ_CCC_Release_Library_Name__c = ws[1].Name,
            compliancequest__Secondary_Content__c = 'Disabled',
            RecordTypeId=[SELECT Id,Name FROM RecordType WHERE SobjectType='compliancequest__SQX_Controlled_Document__c' and Name='Controlled Document' LIMIT 1].Id
        );
        
        //Arrange: Document 12 with Batch Job Status Import-Obsolete
        //To cover the Import-Obsolete section of controlled document migration batch class
        compliancequest__SQX_Controlled_Document__c doc12 = new compliancequest__SQX_Controlled_Document__c(
            compliancequest__Document_Number__c = 'DOC-12',
            compliancequest__Title__c = 'Document 12',
            compliancequest__Description__c = 'long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description long description' , 
            compliancequest__Batch_Job_Status__c = 'IMPORT-Obsolete',
            CQ_CCC_FileName__c = 'PrimaryContentFile12',
            CQ_CCC_Secondary_FileName__c = 'SecondaryFile12',
            CQ_CCC_Draft_Library_Name__c = ws[0].Name,
            CQ_CCC_Release_Library_Name__c = ws[1].Name,
            compliancequest__Secondary_Content__c = 'Manual',
            RecordTypeId = controlledDoc
        );
        insert new compliancequest__SQX_Controlled_Document__c[] { doc1, doc2, doc3, doc4 ,doc5,doc7,doc8,doc9,doc10,doc11,doc12};
        //[CCC-44] New controlled document added for test {End}

        // Get documents
        doc1 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc1.Id].get(0);
        doc2 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc2.Id].get(0);
        doc3 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc3.Id].get(0);
        doc4 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc4.Id].get(0);
        //[CCC-44] new controlled added were retrieved {Start}
        doc7 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc7.Id].get(0);
        doc8 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c,compliancequest__Batch_Job_Status__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc8.Id].get(0);
        doc9 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc9.Id].get(0);
        doc10 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc10.Id].get(0);
        doc11 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc11.Id].get(0);
        doc12 = [SELECT Id, CQ_CCC_FileName__c, CQ_CCC_Secondary_FileName__c FROM compliancequest__SQX_Controlled_Document__c WHERE Id =: doc12.Id].get(0);
        //[CCC-44] new controlled added were retrieved {End}
        
        //Arrange : Insert Contents
        ContentVersion primaryV1 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = 'PrimaryContentFile1.pdf');
        ContentVersion secondaryV1 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = 'SecondaryFile1.docx');

        ContentVersion primaryV2 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = doc2.CQ_CCC_FileName__c);
        ContentVersion secondaryV2 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = 'SecondaryFile2.pdf' );

        ContentVersion primaryV3 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = doc3.CQ_CCC_FileName__c);
        ContentVersion secondaryV3 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = 'SecondaryFile3.pdf');
        //[CCC-44] File created for newly created Controlled Document {Start}
        ContentVersion primaryV7 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = doc7.CQ_CCC_FileName__c); 
        ContentVersion secondaryV7 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = doc7.CQ_CCC_Secondary_FileName__c);
        ContentVersion primaryV9 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = doc9.CQ_CCC_FileName__c);
        ContentVersion secondaryV9 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = doc9.CQ_CCC_Secondary_FileName__c);
        ContentVersion primaryV12 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = doc12.CQ_CCC_FileName__c);
        ContentVersion secondaryV12 = new ContentVersion(VersionData = Blob.valueOf('HelloWorld'),Title='Hello World',
                                             PathOnClient = doc12.CQ_CCC_Secondary_FileName__c); 
        insert new ContentVersion[] { primaryV1, secondaryV1, primaryV2, secondaryV2 , primaryV3, secondaryV3, primaryV7, secondaryV7, primaryV9, secondaryV9,primaryV12, secondaryV12};
        //[CCC-44] File created for newly created Controlled Document {End}
		
        // Execute Controlled Document Migration Batch
        Test.startTest();
        Database.executeBatch(new CQ_CCC_ControlledDocumentMigrationBatch());
        Test.stopTest();

        // get the primary content of the doc4 (Inspection Criteria) and doc6 (Audit Criteria) generated by code.
        // [CCC-44] Checking for auto creating file from CQ_ControlledDocumentMigrationBatch class {Start}
        ContentVersion primaryV4 = [SELECT Id from ContentVersion where compliancequest__Controlled_Document__c =: doc4.Id];
        //ContentVersion primaryV6 = [SELECT Id from ContentVersion where compliancequest__Controlled_Document__c =: doc6.Id];
        // [CCC-44] Checking for auto creating file from CQ_ControlledDocumentMigrationBatch class {End}
        
        //[CCC-44] Asserting for Batch Job Error and Synchronization Status {Start}
        //Assert: To check the whether Content Reference not empty or docRefs doesn't contains fileName
        System.assertEquals('Content Not Found, content should be in private library with title matching file name without extension', [SELECT compliancequest__Batch_Job_Error__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc10.Id].compliancequest__Batch_Job_Error__c);
        //Assert: When both Draft and Release library are not provided then the error occurred while running Batch Job
        System.assertEquals('Specified Release library not found or user does not have access to the library', [SELECT compliancequest__Batch_Job_Error__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc9.Id].compliancequest__Batch_Job_Error__c);
        //Assert: When both Draft and Release library are not provided then the error occurred while running Batch Job
        System.assertEquals('Not Supported', [SELECT compliancequest__Synchronization_Status__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc11.Id].compliancequest__Synchronization_Status__c);
        //[CCC-44] Asserting for Batch Job Error and Synchronization Status {End}
        
        // Assert1: Both Primary and Secondary Content is linked for Document 1
        System.assertEquals([SELECT ContentDocumentId FROM ContentVersion WHERE Id = : primaryV1.Id].ContentDocumentId,
                           [SELECT compliancequest__Content_Reference__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc1.Id].compliancequest__Content_Reference__c, 'Expected primary content Id in document 1');
        System.assertEquals([SELECT ContentDocumentId FROM ContentVersion WHERE Id = : secondaryV1.Id].ContentDocumentId,
                           [SELECT compliancequest__Secondary_Content_Reference__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc1.Id].compliancequest__Secondary_Content_Reference__c, 'Expected secondary content Id in document 1');

        // Assert2: Content is not linked when File Name is not provided
        System.assertEquals(null,
                           [SELECT compliancequest__Content_Reference__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc2.Id].compliancequest__Content_Reference__c, 'Primary Content is not linked when Secondary File Name is not provided');
        System.assertEquals('Secondary FileName is missing. Secondary file name has to be provided',
                           [SELECT compliancequest__Batch_Job_Error__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc2.Id].compliancequest__Batch_Job_Error__c, 'Secondary File Name is also expected if Secondary Content is Manual ');

        // Assert3: Primary Content is linked for Document 3 and Document 4
        System.assertEquals([SELECT ContentDocumentId FROM ContentVersion WHERE Id = : primaryV3.Id].ContentDocumentId,
                           [SELECT compliancequest__Content_Reference__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc3.Id].compliancequest__Content_Reference__c, 'Expected primary content Id in document 3  ');
        System.assertEquals([SELECT ContentDocumentId FROM ContentVersion WHERE Id = : primaryV4.Id].ContentDocumentId,
                           [SELECT compliancequest__Content_Reference__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc4.Id].compliancequest__Content_Reference__c, 'Expected primary content Id in document 4  ');
        
        // Assert4: Content is not linked when Duplicate File Name is provided
        System.assertEquals('Duplicate File Name, file name without extension has to be unique to import documents',
                           [SELECT compliancequest__Batch_Job_Error__c FROM compliancequest__SQX_Controlled_Document__c
                           WHERE Id = : doc5.Id].compliancequest__Batch_Job_Error__c, 'Duplicate Primary and Secondary File Name is not supported ');
    }
}