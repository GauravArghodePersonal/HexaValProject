public with sharing class MassFilesDownloadLWRFiles {


    @AuraEnabled
    public static List<Id> getfileIds(){
        Set<Id> contentDocumentIds = new Set<Id>();
        List<Id> contentVersionIds = new List<Id>();
            Set<id> linkedIds = new set<id>();
		String startEndDate = Label.LWR_Attachments_StartEnd_Date;
        List<String> startEndDateLst = startEndDate.contains(';') ? startEndDate.split(';') : new List<String>{startEndDate};
        Datetime startDate = Test.isRunningTest() ? Date.today() : date.valueOf(startEndDateLst[0]);
        Datetime endDate = Test.isRunningTest() ? Date.today().addDays(1) : date.valueOf(startEndDateLst[1]);
        for(LWR__C lwr : [select id,createdDate from LWR__C WHERE CreatedDate >=:startDate AND CreatedDate <:endDate limit 100]){
            	System.debug(lwr);
            	linkedIds.add(lwr.id);
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