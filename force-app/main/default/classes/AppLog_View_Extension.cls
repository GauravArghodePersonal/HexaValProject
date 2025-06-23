public with sharing class AppLog_View_Extension {

	private Id applogId;
    private List<Attachment> snapshots = new List<Attachment>();
    
	public AppLog__c applog {get;set;}
	public Boolean showSnapshot {get;set;}
	public Boolean showRelatedAppLogs {get;set;}
	public List<AppLog__c> relatedAppLogs {get;set;}

    /**************
     * Constructor
     **************/
    public AppLog_View_Extension(ApexPages.StandardController stdController) {
        AppLog__c applogIn = (AppLog__c)stdController.getRecord();
        applogId = applogIn.Id;
		showSnapshot = false;
		showRelatedAppLogs = false;
        applog = retrieveAppLog(applogId);
        snapshots = retrieveSnapshotsforAppLog(applogId);
        
        if (appLog.Related_To_Key__c != null) {
        	relatedAppLogs = retrieveRelatedAppLogs(appLog.Related_To_Key__c,appLog.Related_To_Key_Type__c);
        }
        else {
        	relatedAppLogs = new List<AppLog__c>();
        }
        
        if (snapshots.size() > 0) {showSnapshot = true;}
        if (relatedAppLogs.size() > 0) {showRelatedAppLogs = true;}
    }

    /**************************
     * Generic Private Methods
     **************************/
    private AppLog__c retrieveAppLog(Id applogId) {
        return [SELECT Id,
                       Name,
                       Application_Name__c,
                       Log__c,
                       Log_Category__c,
                       Log_Date_Time__c,
                       Log_Type__c,
                       Process__c,
                       Record_Key__c,
                       Related_To_Key__c,
                       Related_To_Key_Type__c,
                       Session_Id__c,
                       Sub_Process__c,
                       Summary__c,
                       Task__c,
                       User__c,
                       Version_Info__c
                  FROM AppLog__c
                 WHERE Id = :applogId];
    }	

    private List<Attachment> retrieveSnapshotsforAppLog(Id applogId) {
        return [SELECT Id,
                       Body, 
                       ContentType, 
                       Name 
                  FROM Attachment
                 WHERE ParentId = :applogId
                   AND Name = 'snapshot.png'];
    }	

    private List<AppLog__c> retrieveRelatedAppLogs(String relatedToKey, String relatedToKeyType) {
        return [SELECT Id,
                       Name,
                       Application_Name__c,
                       Log__c,
                       Log_Category__c,
                       Log_Date_Time__c,
                       Log_Type__c,
                       Process__c,
                       Record_Key__c,
                       Related_To_Key__c,
                       Related_To_Key_Type__c,
                       Session_Id__c,
                       Sub_Process__c,
                       Summary__c,
                       Task__c,
                       User__c,
                       Version_Info__c
                  FROM AppLog__c
                 WHERE Related_To_Key__c = :relatedToKey
                   AND Related_To_Key_Type__c = :relatedToKeyType
                 ORDER BY Log_Date_Time__c ASC
             ];
    }	


    public Attachment snapshotAttachment {
	    get {
            if (snapshotAttachment == null) {
            	if (snapshots.size() > 0) {
            		snapshotAttachment = snapshots[0];
            	}
            }
            return snapshotAttachment;
		}
        private set;
    }

    public String snapshot {
     	get {
     		String result = null;
     		if (snapshots.size() > 0) {
     			result = EncodingUtil.Base64Encode(snapshotAttachment.body);
     		}
            return result;
        }
        private set;
    }
}