public class HX_FileDownloadController {
    
    @AuraEnabled(cacheable=true)
    public static list<FileWrapper> getRelatedFiles(String recordId, String objName) {
        list<FileWrapper> fwList = new list<FileWrapper>();
        System.debug(objName);
        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List<ID> fileIDs = new List<ID>();
        for(ContentDocumentLink docLink : files){
            fileIDs.add(docLink.ContentDocumentId);
        } 
        List<ID> relatedIds = new List<ID>();
        List<ID> puIds = new List<ID>();
        List<ID> ctdIds = new List<ID>();
        List<ID> hxlIds = new List<ID>();
        if(objName == 'Account'){
            for(Production_Unit__c prod:[Select ID from Production_Unit__c where Account__c=: recordId]){
                relatedIds.add(prod.ID);
                puIds.add(prod.Id);
            }
            for(Cooling_Tower_Design__c ctd:[Select ID from Cooling_Tower_Design__c where ProductionUnit__c IN : puIds]){
                relatedIds.add(ctd.ID);
                ctdIds.add(ctd.Id);
            }
            for(HXLibraryCW__c  hxl:[Select ID from HXLibraryCW__c  where Cooling_Tower_ID__c  IN : ctdIds]){
                relatedIds.add(hxl.ID);
                hxlIds.add(hxl.Id);
            }
        }else if(objName == 'HXLibraryCW__c'){
            for(FlowStudyCW__c  fs:[Select ID from FlowStudyCW__c where Heat_Exchanger_Id__c =: recordId]){
                relatedIds.add(fs.ID);
            }
            for(One_Time_Data__c  otd:[Select ID from One_Time_Data__c  where HXLibraryCW__c =: recordId]){
                relatedIds.add(otd.ID);
            }
            for(HXEvent__c  hxe:[Select ID from HXEvent__c   where HXLibrary__c =: recordId]){
                relatedIds.add(hxe.ID);
            }
        }      
        if(relatedIds.size()>0){
        List<ContentDocumentLink> relatedFiles = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN : relatedIds];
        for (ContentDocumentLink docLink : relatedFiles) {
            fileIDs.add(docLink.ContentDocumentId);
        }
    }
        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                                     FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
        
        for(ContentVersion docLink : docs){
            FileWrapper fw = new FileWrapper();
            fw.Id = docLink.ContentDocumentId;
            fw.fileURL = '/sfc/servlet.shepherd/document/download/'+docLink.ContentDocumentId;
            fw.fileName = docLink.Title+'.'+docLink.FileExtension;
            if(docLink.FileExtension=='pdf'){
                fw.iconName = 'doctype:pdf';
            }else if(docLink.FileExtension=='png' || docLink.FileExtension=='jpeg' 
                     || docLink.FileExtension=='jpg' ){
                         fw.iconName = 'doctype:image';
                     }
            else if(docLink.FileExtension=='xlsx'){
                fw.iconName = 'doctype:excel';
            }else if(docLink.FileExtension=='csv'){
                fw.iconName = 'doctype:csv';
            }else{
                fw.iconName = 'doctype:attachment';
            }
            fwList.add(fw);
        }
        return fwList;
    }
    
    public class FileWrapper{
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String fileURL;
        @AuraEnabled
        public String fileName;
        @AuraEnabled
        public String fileType;
        @AuraEnabled
        public String iconName;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject, String filter) {
        String myQuery = null;
        if(filter != null && filter != ''){
            myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND '+filter;
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Name from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC';
            }
            else {
                myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\'';
            }
        }
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }


    @AuraEnabled
    public static String createFile(String fileName, String base64Data) {
        try {
            Blob fileBlob = EncodingUtil.base64Decode(base64Data);
            ContentVersion content = new ContentVersion(
                Title = fileName,
                VersionData = fileBlob,
                PathOnClient = fileName // Set the PathOnClient field to the file name
            );
            insert content;
            return 'File created successfully with Id: ' + content.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating file: ' + e.getMessage());
        }
    }
    
    
}