public with sharing class RecordFileDownloaderController {
    @AuraEnabled
    public static List<Id> getfileIds(String recordId){
        Set<Id> contentDocumentIds = new Set<Id>();
        List<Id> contentVersionIds = new List<Id>();
            Set<id> linkedIds = new set<id>();
	for(Task ts : [SELECT AccountId,id FROM Task where AccountId  =: recordId]){
          linkedIds.add(ts.id);
			}
        for(Case cs : [select id, AccountId from case where AccountId =: recordId]){
            linkedIds.add(cs.id);
        }
         for(Opportunity opp : [select id, AccountId from Opportunity where AccountId =: recordId]){
            linkedIds.add(opp.id);
        }
        
        if(linkedIds.size()>0) {
            for(ContentDocumentLink cdl : [SELECT ContentDocumentId,LinkedEntityId,ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId IN:linkedIds ]) {
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
        }
        if(contentDocumentIds.size() > 0) {
            for(ContentVersion cdv : [SELECT Id FROM ContentVersion WHERE isLatest = true AND ContentDocumentId IN :contentDocumentIds]) {
                contentVersionIds.add(cdv.Id);
            }
        }
        return contentVersionIds;
    }
}