/**
* Class to import Controlled documents in CQ. Steps to import include
* a) Importing the document profile/metadata using tools like Data Import Wizard
*    Note: A row called rendition error should contain the filename of the documnet
*          that will be uploaded
*
* b) Uploading the files using FileSync or anyother mechanism to Salesforce
*
* c) Execute Database.executeBatch(new CQ_ControlledDocumentMigrationBatch(), 5);
*
* **************************************************************************************
* Later Modifications:
* CCC-2 - Creating the common configuration component
* CCC-3 - Support for 'Disabled' Documents
* CCC-4 - Current DocMigrationComponent does not update the Content Title and Description for Auto
* CCC-9 - Set the content document's record type to match the one with the controlled document's while importing
* CCC-10 - Truncate the 1000+ character controlled document description texts to 1000 characters to 
* use in the controlled content's description
* CCC-44 - In importing file If record type equals to Audit Criteria and record type equals to Inspection Criteria and 
*          also the file name is blank then create content for them.
* CCC-31 - Document Migration Utility: Case Sensitive File Names are not handled.
*/

global class CQ_CCC_ControlledDocumentMigrationBatch implements Database.Batchable<compliancequest__SQX_Controlled_Document__c> {
    
    //The max allowed size for the description field.
    public static final Integer MAX_SIZE=ContentVersion.Description.getDescribe().getLength();
    public static final String AUDIT_CRITERIA = 'Audit Criteria';
    public static final String INSPECTION_CRITERIA = 'Inspection Criteria';
    
    //[CCC-44] Added compliancequest__Synchronization_Status__c, compliancequest__Approval_Status__c,compliancequest__Document_Number__c,
    //compliancequest__Revision__c fields to select from the controlled document
    global Iterable<compliancequest__SQX_Controlled_Document__c> start(Database.BatchableContext bc) {
        return [SELECT compliancequest__Document_And_Rev__c, RecordTypeId, RecordType.Name, RecordType.DeveloperName, compliancequest__Draft_Vault__c,
                compliancequest__Title__c, compliancequest__Description__c,
                CQ_CCC_FileName__c, CQ_CCC_Draft_Library_Name__c,
                CQ_CCC_Release_Library_Name__c, CQ_CCC_Secondary_FileName__c,
                compliancequest__Content_Reference__c,compliancequest__Batch_Job_Status__c,
                compliancequest__Batch_Job_Error__c, compliancequest__Release_Vault__c,
                compliancequest__Secondary_Content__c, compliancequest__Secondary_Content_Reference__c,
                compliancequest__Synchronization_Status__c, compliancequest__Approval_Status__c,
                compliancequest__Document_Number__c,compliancequest__Revision__c
                FROM compliancequest__SQX_Controlled_Document__c
                WHERE compliancequest__Batch_Job_Status__c IN
                ('IMPORT-Draft','IMPORT-Current','IMPORT-Obsolete')
                AND compliancequest__Content_Reference__c = null
                ORDER BY compliancequest__Batch_Job_Status__c DESC, compliancequest__Revision__c];
    }
    global void execute(Database.BatchableContext BC, List<SObject> docSObject) {
        
        //Find all documents that do not have primary content
        List<compliancequest__SQX_Controlled_Document__c> lstCDocs = (List<compliancequest__SQX_Controlled_Document__c>)docSObject;
        Set<Id> docsToLock = new Set<Id>();
        
        //find all library names and id
        list<ContentWorkSpace> lstLibs = [select id,name from ContentWorkSpace];
        map<string,string> libResolved = new Map<string,string>();
        for (ContentWorkspace lib : lstLibs){
            libResolved.put(lib.name,lib.id);
        }
        
        //render job error is file name, which goes as title when file is synched so files matching the documents to be processed
        //if file exists then skip that doc and flag error in batch error
        set<string> lstFileNames  = new set<string>();
        set<string> secondarylstFileNames  = new set<string>();
        set<string>docDeveloperNames= new set<string>();
        string fileName;
        string secondaryFileName;
        List<compliancequest__SQX_Controlled_Document__c> lstErrCDocs  = new List<compliancequest__SQX_Controlled_Document__c> ();
        compliancequest__SQX_Controlled_Document__c cDocToCheck;
        integer j=0;
        boolean hasError = false;
        
        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        
        while (j < lstCDocs.size()){
            cDocToCheck = lstCDocs.get(j);
            docDeveloperNames.add(cDocToCheck.RecordType.DeveloperName);
            hasError  = false;
            //[CCC-31] Converted the file csv file name in lower case and also checked the file name is blank or not{Start}
            fileName = String.isBlank(cDocToCheck.CQ_CCC_FileName__c)?'':(cDocToCheck.CQ_CCC_FileName__c).toLowerCase();
            secondaryFileName = String.isBlank(cDocToCheck.CQ_CCC_Secondary_FileName__c)?'':(cDocToCheck.CQ_CCC_Secondary_FileName__c).toLowerCase();
            //[CCC-31] Converted the file csv file name in lower case and also checked the file name is blank or not{End}
            
            //[CCC-44] Moved to here for visibility {Start}
            String recordType = cDocToCheck.RecordType.Name;
            //[CCC-44] Moved to here for visibility {End}
            
            if (string.isNotEmpty(fileName) || string.isNotEmpty(secondaryFileName)) {
                if (lstFileNames.Contains(fileName) ){
                    cDocToCheck.compliancequest__Batch_Job_Error__c = 'Duplicate File Name, file name without extension has to be unique to import documents';
                    hasError = true;
                }
                if (cDocToCheck.compliancequest__Secondary_Content__c == 'Manual' && secondarylstFileNames.Contains(secondaryFileName) ){
                    cDocToCheck.compliancequest__Batch_Job_Error__c = 'Duplicate Secondary File Name, secondary file name without extension has to be unique to import documents';
                    hasError = true;
                }
                if(cDocToCheck.compliancequest__Secondary_Content__c == 'Manual' && string.isEmpty(secondaryFileName)){
                    cDocToCheck.compliancequest__Batch_Job_Error__c = 'Secondary FileName is missing. Secondary file name has to be provided';
                    hasError = true;
                }
            }
            //[CCC-44] In importing file If record type equals to Audit Criteria and record type equals to Inspection Criteria.
            //Also the file name is blank then create content for them.
            else if(AUDIT_CRITERIA == recordType || INSPECTION_CRITERIA  == recordType){
                if(string.isEmpty(fileName)){
                    //[CCC-31] Checked the Revision is blank or not and if not blank then converted it to lower case{Start}
                    String revision = String.isBlank(cDocToCheck.compliancequest__Revision__c)?'0':cDocToCheck.compliancequest__Revision__c;
                    cDocToCheck.CQ_CCC_FileName__c = cDocToCheck.compliancequest__Document_Number__c +'_'+ revision;
                    fileName = (cDocToCheck.compliancequest__Document_Number__c +'_'+ revision).toLowerCase();
                    secondaryFileName = (cDocToCheck.compliancequest__Document_Number__c +'_'+ revision).toLowerCase();
                    cDocToCheck.CQ_CCC_FileName__c = fileName;
                    cDocToCheck.CQ_CCC_Secondary_FileName__c = secondaryFileName;
                    //[CCC-31] Checked the Revision is blank or not and if not blank then converted it to lower case{End}
                    // Create and upload primary and secondary content version for Inspection Criteria and Audit criteria
                    ContentVersion primaryCV = new ContentVersion(
                        Title = fileName,
                        PathOnClient = fileName,
                        VersionData = Blob.valueOf(recordType + ' Primary Content')
                    );
                    ContentVersion secondaryCV = new ContentVersion(
                        Title = secondaryFileName,
                        PathOnClient = secondaryFileName,
                        VersionData = Blob.valueOf(recordType + ' Secondary Content')
                    );
                    contentVersionList.add(primaryCV);
                    contentVersionList.add(secondaryCV);
                }
            }
            else{
                cDocToCheck.compliancequest__Batch_Job_Error__c = 'Filename missing, Please specify file name in Render Job Error';
                hasError = true;
            }
            if (!hasError){
                lstFileNames.add(fileName);
                secondarylstFileNames.add(secondaryFileName);
                cDocToCheck.compliancequest__Batch_Job_Error__c ='';
                j++;
            }else{
                lstCDocs.remove(j);
                lstErrCDocs.add(cDocToCheck);
            }
        }
        
        // Insert the content version
        if(!contentVersionList.isEmpty()){
            insert contentVersionList;
        }
        
        //[CCC-31] Retrieved the PathOnClient from ContentVersion and converted each of the filename and Secondary File name to lower case{Start}
        //find private unmapped files (contentversion) for selected documents
        List<ContentVersion> allPCVs = [SELECT Id, PathOnClient, ContentDocumentId, Title,compliancequest__Controlled_Document__c, FileExtension FROM ContentVersion where ContentDocument.PublishStatus ='R' and compliancequest__Controlled_Document__c = null and isLatest=true];
        string lowerPathOnClientFilename;
        List<ContentVersion> lstPCV = new List<ContentVersion>();
        for(ContentVersion cv : allPCVs){
            lowerPathOnClientFilename = (cv.PathOnClient).toLowerCase();
            if(lstFileNames.contains(lowerPathOnClientFilename)){
                lstPCV.add(cv);
            }
        }
        List<ContentVersion> allSCVs = [SELECT Id, PathOnClient,  ContentDocumentId, Title,compliancequest__Controlled_Document__c, FileExtension FROM ContentVersion where ContentDocument.PublishStatus ='R' and compliancequest__Controlled_Document__c = null and isLatest=true];
        string lowerPathOnClientSecondaryFileName;
        List<ContentVersion> lstSCV = new List<ContentVersion>();
        for(ContentVersion cv : allSCVs){
            lowerPathOnClientSecondaryFileName = (cv.PathOnClient).toLowerCase();
            if(secondarylstFileNames.contains(lowerPathOnClientSecondaryFileName)){
                lstSCV.add(cv);
            }
        }
        //[CCC-31] Retrieved the PathOnClient from ContentVersion and converted each of the filename and Secondary File name to lower case{End}

        map<string,ContentVersion> docRefs = new map<string,ContentVersion>();
        map<string,ContentVersion> docSecRefs = new map<string,ContentVersion>();
        list<string>  pcvs = new list<string>();
        String lowerPathOnClient;
        for (ContentVersion pcv: lstPCV){
            //[CCC-31] Checked the PathOnClient is blank or not and if not blank then converted it to lower case{Start}
            lowerPathOnClient = String.isBlank(pcv.PathOnClient)?'':(pcv.PathOnClient).toLowerCase();
            //[CCC-31] Checked the PathOnClient is blank or not and if not blank then converted it to lower case{End}
            if (!docRefs.containsKey(lowerPathOnClient)){
                //if same title twice, use the first one
                docRefs.put(lowerPathOnClient,pcv); //match file and metadata by title of the file (this can change per requirement)
                
            }
        }
        for (ContentVersion scv: lstSCV){
            //[CCC-31] Checked the PathOnClient is blank or not and if not blank then converted it to lower case{Start}
            lowerPathOnClient = String.isBlank(scv.PathOnClient)?'':(scv.PathOnClient).toLowerCase();
            //[CCC-31] Checked the PathOnClient is blank or not and if not blank then converted it to lower case{End}
            if (!docSecRefs.containsKey(lowerPathOnClient)){
                //if same title twice, use the first one
                docSecRefs.put(lowerPathOnClient,scv); //match file and metadata by title of the file (this can change per requirement)
            }
        }
        
        List<ContentWorkSpaceDoc> lstCWDs = new List<ContentWorkSpaceDoc>();
        //attach primary file to controlled doc
        ContentVersion pcv;
        ContentVersion scv;
        j = 0;
        
        Map<String, compliancequest__SQX_Controlled_Document__c> contentDocMap = new Map<String, compliancequest__SQX_Controlled_Document__c>();
        while (j < lstCDocs.size()){
            cDocToCheck = lstCDocs.get(j);
            hasError = false;
            //[CCC-31] Checked the filename and Secondary file name is blank or not, if not then convert them to lowercase{Start}
            fileName = String.isBlank(cDocToCheck.CQ_CCC_FileName__c)?'':(cDocToCheck.CQ_CCC_FileName__c).toLowerCase();
            secondaryFileName = String.isBlank(cDocToCheck.CQ_CCC_Secondary_FileName__c)?'':(cDocToCheck.CQ_CCC_Secondary_FileName__c).toLowerCase();
            //[CCC-31] Checked the filename and Secondary file name is blank or not, if not then convert them to lowercase{End}
            
            //[CCC-31] Checked the fileName if docRefs insted of actual field value
            if (string.isEmpty(cDocToCheck.compliancequest__Content_Reference__c) && docRefs.containsKey(fileName))
            {
                if(libResolved.containsKey(cDocToCheck.CQ_CCC_Draft_Library_Name__c)){
                    cDocToCheck.compliancequest__Draft_Vault__c = libResolved.get(cDocToCheck.CQ_CCC_Draft_Library_Name__c);
                }else{
                    cDocToCheck.compliancequest__Batch_Job_Error__c = 'Specified Draft library not found or user does not have access to the library';
                    hasError = true;
                }
                if(libResolved.containsKey(cDocToCheck.CQ_CCC_Release_Library_Name__c)){
                    cDocToCheck.compliancequest__Release_Vault__c = libResolved.get(cDocToCheck.CQ_CCC_Release_Library_Name__c);
                }else{
                    cDocToCheck.compliancequest__Batch_Job_Error__c = 'Specified Release library not found or user does not have access to the library';
                    hasError = true;
                }
            }else{
                cDocToCheck.compliancequest__Batch_Job_Error__c = 'Content Not Found, content should be in private library with title matching file name without extension';
                hasError = true;
            }
            if (!hasError){
                //[CCC-31] Referenced the converted file name value instead of Actual field value
                pcv = docRefs.get(fileName);
                cDocToCheck.compliancequest__Content_Reference__c = pcv.ContentDocumentId;
                pcv.Description = CQ_CCC_Utils.truncate(cDocToCheck.compliancequest__Description__c,MAX_SIZE);
                pcv.Title = cDocToCheck.compliancequest__Title__c;
                contentDocMap.put(pcv.Id, cDocToCheck);
                
                //Link Secondary Content if Secondary Content Mode is set to manual
                if(cDocToCheck.compliancequest__Secondary_Content__c == 'Manual'){
                    //[CCC-31] Referenced the converted Secondary file name value instead of Actual field value
                    scv = docSecRefs.get(secondaryFileName);
                    cDocToCheck.compliancequest__Secondary_Content_Reference__c = scv.ContentDocumentId;
                    scv.Description = CQ_CCC_Utils.truncate(cDocToCheck.compliancequest__Description__c,MAX_SIZE);
                    scv.Title = cDocToCheck.compliancequest__Title__c;
                    cDocToCheck.compliancequest__Synchronization_Status__c = 'In Sync';
                    contentDocMap.put(scv.Id, cDocToCheck);
                }
                j++;
            }else{
                lstCDocs.remove(j);
                lstErrCDocs.add(cDocToCheck);
            }
        }
        
        for(ContentVersion cv : lstPCV)
        {
            if(contentDocMap.containsKey(cv.Id)){
                cv.compliancequest__Controlled_Document__c = contentDocMap.get(cv.id).Id;
            }
        }
        for(ContentVersion cv : lstSCV)
        {
            if(contentDocMap.containsKey(cv.Id)){
                cv.compliancequest__Controlled_Document__c = contentDocMap.get(cv.id).Id;
            }
        }
        update lstPCV;
        update lstSCV;
        
        //Build Secondary Content, only for Current/Draft Documents, No secondary format for obsolete
        list<ContentVersion> lstSCV2 = new list<ContentVersion>();
        for (compliancequest__SQX_Controlled_Document__c cDoc : lstCDocs){
            if (((cDoc.compliancequest__Batch_Job_Status__c == 'IMPORT-Current')||(cDoc.compliancequest__Batch_Job_Status__c == 'IMPORT-Draft'))&&(cDoc.compliancequest__Secondary_Content__c !='Disabled' && cDoc.compliancequest__Secondary_Content__c !='Manual' ) && string.isNotEmpty(cDoc.compliancequest__Content_Reference__c)  ){
                scv = new ContentVersion();
                scv.VersionData = Blob.valueOf('Migrated Document, secondary format not yet rendered');
                scv.PathOnClient = 'MigratedDoc.txt';
                //START [CCC-4] Current DocMigrationComponent does not update the Content Title and Description for Auto
                scv.Description = CQ_CCC_Utils.truncate(cDoc.compliancequest__Description__c, MAX_SIZE);
                scv.Title = cDoc.compliancequest__Title__c;
                //END [CCC-4] Current DocMigrationComponent does not update the Content Title and Description for Auto
                scv.compliancequest__Controlled_Document__c = cDoc.Id;
                lstSCV2.add(scv);
                cDoc.compliancequest__Synchronization_Status__c = 'Out Of Sync';
            }
        }
        
        insert lstSCV2;
        lstSCV.addAll(lstSCV2);
        
        //update reference to Secondary Content
        list<string> addedSCVIds = new list<string>();
        for (contentVersion cv : lstSCV){
            addedSCVIds.add(cv.id);
        }
        
        //refetch secondary content version to find contentDocumentId
        lstSCV = [select id,ContentDocumentId, compliancequest__Controlled_Document__c from ContentVersion where id in :addedSCVIds];
        
        Map<string,string> secRefs = new Map<string,string>();
        for (ContentVersion cv : lstSCV){
            secRefs.put(cv.compliancequest__Controlled_Document__c,cv.ContentDocumentId);
        }
        
        for (compliancequest__SQX_Controlled_Document__c cDoc : lstCDocs){
            if ((cDoc.compliancequest__Batch_Job_Status__c == 'IMPORT-Draft') || (cDoc.compliancequest__Batch_Job_Status__c == 'IMPORT-Current') ){
                lstCWDs.add(new ContentWorkSpaceDoc(ContentDocumentId = cDoc.compliancequest__Content_Reference__c, ContentWorkspaceId = cDoc.compliancequest__Draft_Vault__c));// move to public draft
            }
            if (cDoc.compliancequest__Batch_Job_Status__c == 'IMPORT-Current')
            {
                cDoc.compliancequest__Approval_Status__c = 'Approved';
                cDoc.compliancequest__Document_Status__c = 'Current';
                
                if(cDoc.compliancequest__Secondary_Content__c !='Disabled'){
                    cDoc.compliancequest__Secondary_Content_Reference__c = secRefs.get(cDoc.id);
                    lstCWDs.add(new ContentWorkSpaceDoc(ContentDocumentId = cDoc.compliancequest__Secondary_Content_Reference__c, ContentWorkspaceId = cDoc.compliancequest__Release_Vault__c));// move to release
                }
                cDoc.compliancequest__Is_Locked__c = true;
                docsToLock.add(cDoc.Id);
            }
            if (cDoc.compliancequest__Batch_Job_Status__c == 'IMPORT-Obsolete')
            {
                cDoc.compliancequest__Document_Status__c = 'Obsolete';
                cDoc.compliancequest__Is_Locked__c = true;
                docsToLock.add(cDoc.Id);
            }
            cDoc.compliancequest__Batch_Job_Status__c = 'Processed-'+cDoc.compliancequest__Batch_Job_Status__c;
            cDoc.CQ_CCC_FileName__c  = '';
            cDoc.CQ_CCC_Secondary_FileName__c = '';
        }
        
        insert lstCWDs; //publishes primary and secondary
        update lstCDocs;
        update lstErrCDocs;
        Approval.lock(new List<Id>(docsToLock));
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}