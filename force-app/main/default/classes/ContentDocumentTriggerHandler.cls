/**
 * @description ContentDocument Object Trigger Handler
 * @author      Lavakusareddy
 * @date        Created: 17-Jun-2022
 */
public without sharing class ContentDocumentTriggerHandler {
    
    public static Boolean stopBeforeDeleteExecution = false;	
    static User loggedInUser = LWRDataAccessor.getLoggedInUserDetails();
    
    /**
     * @description Update File Uploaded Flag on LWRs
     * @author      Lavakusareddy
     * @date        Created: 17-Jun-2022
     * @param		deletedCDsMap Deleted Files
     * @return      void
     */
    public static void uncheckFileUploadedOnLWR(Map<Id,ContentDocument> deletedCDsMap){
       updateFileUploadedFlagOnLWRs(deletedCDsMap.keySet());
    }
	
    /**
     * @description Process the deleted attachments 
     * @author      Lavakusareddy
     * @date        Created: 17-Jun-2022
     * @param		deletedCDsMap Attachments which are in process of deletion
     * @return      void
     */
    public static void processDeletedContentDocuments(Map<Id,ContentDocument> deletedCDsMap){
       displayErrorOnLWRAttachmentDeletion(deletedCDsMap);
    }
    
    /**
     * @description Display Error Message to delete attachment record
     * @author      Lavakusareddy
     * @date        Created: 17-Jun-2022
     * @param		deletedCDsMap Attachments which are in process of deletion
     * @return      void
     */
    public static void displayErrorOnLWRAttachmentDeletion(Map<Id,ContentDocument> deletedCDsMap){
        List<LWR_Setting__mdt> lwrSettings = LWRDataAccessor.getLWRSetting(LWRConstants.PROFILES_CAN_DELETE_FILES_UNDER_APPROVAL_LWR);
        List<String> excludedProfiles = LWRUtilities.getProfileNames(lwrSettings);
        
        if(!excludedProfiles.contains(loggedInUser.Profile.Name)){
            Map<Id,Set<Id>> lwrIdCDocsMap = new Map<Id,Set<Id>>();
            for(ContentDocumentLink cdl : [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN : deletedCDsMap.keySet()]){
                Set<Id> cdocIds = lwrIdCDocsMap.get(cdl.LinkedEntityId);
                cdocIds = (cdocIds == null)?new Set<Id>():cdocIds;
                cdocIds.add(cdl.ContentDocumentId);
                lwrIdCDocsMap.put(cdl.LinkedEntityId, cdocIds);            
            }
            
            for(LWR__c lwr : [SELECT Id FROM LWR__c WHERE Id IN :lwrIdCDocsMap.keySet() AND 
                                  (Status__c != :LWRConstants.STATUS_NOT_SUBMITTED AND Status__c != :LWRConstants.STATUS_REJECTED)])
            {
                for(Id cDocId : lwrIdCDocsMap.get(lwr.Id)){
                    if(deletedCDsMap.containsKey(cDocId)){
                        deletedCDsMap.get(cDocId).addError('You are not authorized to delete the attachment');
                        stopBeforeDeleteExecution = true;
                    }
                }            
            }
        }
        
    }
    
    /**
     * @description Update File Uploaded Flag on LWRs
     * @author      Lavakusareddy
     * @date        Created: 17-Jun-2022
     * @param		cDocIds Deleted Content Document Record Ids
     * @return      void
     */
    public static void updateFileUploadedFlagOnLWRs(Set<Id> cDocIds){
        Set<Id> lwrIds = new Set<Id>();
        for(ContentDocumentLink cdl : [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN : cDocIds]){
            lwrIds.add(cdl.LinkedEntityId);            
        }
        
        List<LWR__c> lwrs = new List<LWR__c>();
        for(LWR__c lwr : [SELECT Id, File_Uploaded__c, (SELECT Id FROM ContentDocumentLinks) FROM LWR__c WHERE Id IN :lwrIds])
        {
            if(lwr.File_Uploaded__c && !lwr.ContentDocumentLinks.isEmpty() && lwr.ContentDocumentLinks.size() == 1){
                lwrs.add(new LWR__c(Id = lwr.Id, File_Uploaded__c = false));
            }           
        }
        
        if(!lwrs.isEmpty()){
            update lwrs;
        }        
    }
}