public class ContentDocTriggerHandler {    
    
    static User loggedInUser = LWRDataAccessor.getLoggedInUserDetails();
    
    public static void validateAttachment(List<String> entitiList){
        list<LWR__c> lwrList =new list<LWR__c>();
        system.debug('====forLWR===');
        for(LWR__c lwr:[select id,Status__c, Technical_Center__c, Sections__c, Request_Type__c,Request__c,File_Uploaded__c, (SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.ContentSize 
       				FROM ContentDocumentLinks) from LWR__c where id =:entitiList]){
        			system.debug('======='+lwr);
                    system.debug('====lwr==='+lwr.ContentDocumentLinks.size());
         	if(lwr.ContentDocumentLinks.size()>0){
               	lwr.File_Uploaded__c = true;
                lwrList.add(lwr);
            }
        }
        if(lwrList.size() > 0){
           update lwrList; 
        }
        
    }
    
    /**
     * @description Display Error Message to remove attachment record
     * @author      Lavakusareddy
     * @date        Created: 17-Jun-2022
     * @param		removedCLsMap Attachments which are in process of removal
     * @return      void
     */
    public static void displayErrorOnLWRAttachmentRemove(Map<Id,ContentDocumentLink> removedCLsMap){
        List<LWR_Setting__mdt> lwrSettings = LWRDataAccessor.getLWRSetting(LWRConstants.PROFILES_CAN_DELETE_FILES_UNDER_APPROVAL_LWR);
        List<String> excludedProfiles = LWRUtilities.getProfileNames(lwrSettings);
        
        if(!excludedProfiles.contains(loggedInUser.Profile.Name)){
            Map<Id,Id> lwrIdCLinksMap = new Map<Id,Id>();
            for(ContentDocumentLink cdl : [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE Id IN : removedCLsMap.keySet()]){
            	lwrIdCLinksMap.put(cdl.LinkedEntityId, cdl.Id);          
            }
            
            for(LWR__c lwr : [SELECT Id FROM LWR__c WHERE Id IN :lwrIdCLinksMap.keySet() AND 
                                  (Status__c != :LWRConstants.STATUS_NOT_SUBMITTED AND Status__c != :LWRConstants.STATUS_REJECTED)])
            {
                if(lwrIdCLinksMap.containsKey(lwr.Id) && removedCLsMap.containsKey(lwrIdCLinksMap.get(lwr.Id))){
                     removedCLsMap.get(lwrIdCLinksMap.get(lwr.Id)).addError('You are not authorized to remove the attachment');
                }          
            }
        }
        
    }
}