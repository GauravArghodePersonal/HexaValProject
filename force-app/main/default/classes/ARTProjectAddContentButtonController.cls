public class ARTProjectAddContentButtonController {

    public ContentVersion newContent {get;set;}
    ART_Project__c project;

    Map<String, Id> workspaceMap = new Map<String, Id>();
    Map<String, Id> recordTypeMap = new Map<String, Id>();
    
    public ARTProjectAddContentButtonController(ApexPages.StandardController controller) {
        project = (ART_Project__c)controller.getRecord();
        project = [select Id, Name from ART_Project__c where Id = :project.Id ];
        newContent = new ContentVersion();
        populateWorkspaceMap();
        populateRecordTypeMap();
    }
    
    private void populateWorkspaceMap() {
        List<ContentWorkspace> contentWorkspaces = [SELECT Id, Name FROM ContentWorkspace];
        for (ContentWorkspace contentWorkspace : contentWorkspaces) {
            workspaceMap.put(contentWorkspace.Name,contentWorkspace.Id);
        }
    }
    
    private void populateRecordTypeMap() {
        List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'ContentVersion'];
        for (RecordType recordType : recordTypes) {
            recordTypeMap.put(recordType.Name,recordType.Id);
        }
    }

    public PageReference upload() {
        Id targetWorkspaceId = workspaceMap.get('Ashland Release Tracker Library');
        Id targetRecordTypeId = recordTypeMap.get('ART Related Document');
        
        System.debug('targetWorkspaceId = ' + targetWorkspaceId);
        System.debug('targetRecordTypeId = ' + targetRecordTypeId);
        System.debug('newContent.PathOnClient = ' + newContent.PathOnClient);
        System.debug('project.Name = ' + project.Name);
        System.debug('project.Id = ' + project.Id);

        if (newContent.PathOnClient != null){
            newContent.Title = newContent.PathOnClient;
            newContent.FirstPublishLocationID = targetWorkspaceId;
            newContent.RecordTypeId = targetRecordTypeId;
            newContent.Project__c = project.Id;
            insert newContent;
            return new PageReference('/'+ project.Id);
        }
        else{
            return null;
        }
    }
    
    public PageReference cancel(){
        return new PageReference('/' + project.Id);
    }
    
}