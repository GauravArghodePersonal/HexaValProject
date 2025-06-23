public class LWRTriggerHandler {
    
    public static User loggedInUser = LWRDataAccessor.getLoggedInUserDetails();
    
    public static void LWRTriggerIscloned (List<LWR__c>LWRList){
        for (LWR__c lwr : LWRList) {
            if (lwr.isClone()) {
                lwr.Status__c = 'Not Submitted';
                lwr.Date_Sample_Received__c = null;
                lwr.Date_Accepted__c = null;
                lwr.Date_Completed__c = null;
                lwr.Accepted__c = false;
                lwr.File_Uploaded__c = false;
                lwr.Is_Rejected__c = false;
                lwr.Reason_for_Rejection__c = null;
                lwr.Comments__c = null;
                lwr.Date_Created__c = Date.today();
                lwr.Received_By__c = ' ';
                lwr.Accepted_By__c = ' ';
                lwr.Target_Date__c = null;
                lwr.LIMS_Number__c = null;
                lwr.Analytical_File_Uploaded__c = false;
                lwr.Applications_File_Uploaded__c = false;
                lwr.Colorants_File_Uploaded__c = false;
                lwr.Paper_Making_File_Uploaded__c = false;
                lwr.Paper_Testing_File_Uploaded__c = false;
                lwr.Pulp_File_Uploaded__c = false;
            }
        }
    
    }
    
    public static void ReasonForRejectionConcadinate(List<LWR__c>LWRList,Map<Id,LWR__c>OldLwrMap){
        for(LWR__c lwr:LWRList){
            DateTime todaysDate = System.today();
            lwr.Read_Only__c = false;
            system.debug('========= loop');
            if(lwr.Status__c == 'Rejected' && OldLwrMap.get(lwr.Id).Reason_for_Rejection__c!=Null && OldLwrMap.get(lwr.Id).Reason_for_Rejection__c!=''){
                system.debug('========='+OldLwrMap.get(lwr.id).Reason_for_Rejection__c);
                lwr.Reason_for_Rejection__c = todaysDate.format('yyyy-MM-dd')+' - '+UserInfo.getName()+' - '+OldLwrMap.get(lwr.id).Reason_for_Rejection__c+ ',' + 
                                                '\n'+todaysDate.format('yyyy-MM-dd')+ ' - ' +UserInfo.getName()+ ' - '+lwr.Reason_for_Rejection__c;
            }
            else{
                lwr.Reason_for_Rejection__c =  todaysDate.format('yyyy-MM-dd')+ ' - ' +UserInfo.getName()+ ' - '+lwr.Reason_for_Rejection__c;
            }
            system.debug('reason '+lwr.Reason_for_Rejection__c);
            
        }
    }
    
    /*
    public static void checkAttachmentsCountBeforeSubmission(List<LWR__c> LWRList,Map<Id,LWR__c> OldLwrMap){
        Map<String,Integer> totalFiles = getFilesCount(OldLwrMap.keySet());
        
        for(LWR__c lwr:LWRList){
            LWR__c oldLWR = OldLwrMap.get(lwr.id);
            Integer filesCount = totalFiles.containsKey(lwr.id)?totalFiles.get(lwr.id):0;
            if(oldLWR.Status__c != lwr.Status__c && LWRConstants.APPROVAL_SUBMISSION_STATUS_GROUP.contains(lwr.Status__c) && filesCount == 0) {
               lwr.addError('Please add attachment before submission');
            }
        }
    }*/
    
    public static void updateLWRAsReadOnly(List<LWR__c> LWRList,Map<Id,LWR__c> OldLwrMap){
        List<LWR_Setting__mdt> lwrSettings = LWRDataAccessor.getLWRSetting(LWRConstants.PROFILES_CAN_EDIT_UNDER_APPROVAL_LWR);
        List<String> excludedProfiles = LWRUtilities.getProfileNames(lwrSettings);
        
        for(LWR__c lwr:LWRList){
            LWR__c oldLWR = OldLwrMap.get(lwr.id);
            if(!excludedProfiles.contains(loggedInUser.Profile.Name) && isLockedToEdit(oldLWR, lwr)) {
                lwr.addError('You are not authorized to edit LWR after submission');
            }
        }
    }
    
    /*
    private static Map<String,Integer> getFilesCount(Set<Id> lwrIds){
        Map<String,Integer> totalFilesCountPerLWR = new Map<String,Integer>();
        for(AggregateResult ar : [SELECT LinkedEntityId, Count(Id)FileCount FROM ContentDocumentLink WHERE LinkedEntityId IN :lwrIds GROUP BY LinkedEntityId]){
            totalFilesCountPerLWR.put(String.valueOf(ar.get('LinkedEntityId')), Integer.valueOf(ar.get('FileCount')));
        }
        
        return totalFilesCountPerLWR;
    }*/
    
    private static Boolean isLockedToEdit(LWR__c oldLWR, LWR__c newLWR){
        return ( LWRConstants.READ_ONLY_STATUS_GROUP.contains(newLWR.Status__c) 
                && (newLWR.Status__c == oldLWR.Status__c)
                && (
                    (newLWR.ApprovalDate__c != null && newLWR.Status__c != LWRConstants.STATUS_WAITING_FOR_APPROVAL)        
                    || (newLWR.ApprovalDate__c == null)
                   )
               );            
    }
    
    public static void setLabInitials(List<LWR__c> LWRList,Map<Id,LWR__c> OldLwrMap){
        List<LWR__c> labInitialsForLWRs = new List<LWR__c>();
        for(LWR__c lwr : LWRList){
            /*if(String.isBlank(lwr.Lab_Initials__c)){
                labInitialsForLWRs.add(lwr);
            }*/
            if(String.isNotBlank(lwr.Technical_Center__c)){
                labInitialsForLWRs.add(lwr);
            }
        }
        
        if(!labInitialsForLWRs.isEmpty()){
            updateLabInitials(labInitialsForLWRs);
        }
    }
    
    private static void updateLabInitials(List<LWR__c> lwrs){
        List<Lab__c> labs = LWRDataAccessor.getLabs();
        Map<String,List<SObject>> labsByName = LWRUtilities.groupSObjectsByFieldName('Lab_Name__c', labs);
        
        for(LWR__c lwr : lwrs){
            if(lwr.Technical_Center__c.equalsIgnoreCase(LWRConstants.TECHNICAL_CENTER_WILMINGTION))
            {
                if(lwr.Request__c.equalsIgnoreCase(LWRConstants.REQUEST_NAME_WRAP) || lwr.Request__c.equalsIgnoreCase(LWRConstants.REQUEST_NAME_COUPON)){
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_NA_CUSTOMER_ANALYTICAL);
                    continue;
                }
                else if(lwr.Sections__c.containsIgnoreCase(LWRConstants.SECTION_NAME_ANALYTICAL))
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_NA_CUSTOMER_ANALYTICAL);
                    continue;
                } 
                else if(lwr.Sections__c.equalsIgnoreCase(LWRConstants.SECTION_NAME_PAPER_MAKING))
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_NA_PAPER_MAKING);
                    continue;
                } 
                else if(lwr.Sections__c.equalsIgnoreCase(LWRConstants.SECTION_NAME_PAPER_TESTING))
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_NA_PAPER_TESTING);
                    continue;
                } 
                else if(lwr.Sections__c.equalsIgnoreCase(LWRConstants.SECTION_NAME_APPLICATIONS) 
                          &&  lwr.Request_Type__c.equalsIgnoreCase(LWRConstants.REQUEST_TYPE_PPD)) 
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_NA_PAPER_APPLICATIONS);
                    continue;
                }
                else if(lwr.Sections__c.equalsIgnoreCase(LWRConstants.SECTION_NAME_COLORANTS)) 
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_NA_COLORANTS_APPLICATIONS);
                    continue;
                }
                else if(lwr.Sections__c.equalsIgnoreCase(LWRConstants.SECTION_NAME_APPLICATIONS) 
                          &&  lwr.Request_Type__c.equalsIgnoreCase(LWRConstants.REQUEST_TYPE_WTR)) 
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_NA_WATER_APPLICATIONS);
                    continue;
                }
                else if(!lwr.Sections__c.contains(LWRConstants.SECTION_NAME_ANALYTICAL) 
                          &&  lwr.Request_Type__c.equalsIgnoreCase(LWRConstants.REQUEST_TYPE_PPD)) 
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_NA_PAPER_MAKING);
                    continue;
                }
            } 
            else if(lwr.Technical_Center__c.equalsIgnoreCase(LWRConstants.TECHNICAL_CENTER_PAULINIA))
            {
                lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_PAULINIA);
                continue;
            }
            else if(lwr.Technical_Center__c.equalsIgnoreCase(LWRConstants.TECHNICAL_CENTER_SHANGHAI))
            {
                lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_SHANGHAI);
                continue;
            }
            else if(lwr.Technical_Center__c.equalsIgnoreCase(LWRConstants.TECHNICAL_CENTER_INDONESIA))
            {
                lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_ITC);
                continue;
            }
            else if(lwr.Technical_Center__c.equalsIgnoreCase(LWRConstants.TECHNICAL_CENTER_INDIA))
            {
                lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_TECHNICAL_APPLICATION_LAB);
                continue;
            }
            else if(lwr.Technical_Center__c.equalsIgnoreCase(LWRConstants.TECHNICAL_CENTER_KREFELD))
            {
                if(lwr.Request__c.equalsIgnoreCase(LWRConstants.REQUEST_NAME_WRAP) || lwr.Request__c.equalsIgnoreCase(LWRConstants.REQUEST_NAME_COUPON)){
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_CAS_BD_M9);
                    continue;
                }
                else if(lwr.Sections__c.containsIgnoreCase(LWRConstants.SECTION_NAME_ANALYTICAL))
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_CAS_BD_M9);
                    continue;
                }
                else if(lwr.Sections__c.equalsIgnoreCase(LWRConstants.SECTION_NAME_APPLICATIONS) 
                          &&  lwr.Request_Type__c.equalsIgnoreCase(LWRConstants.REQUEST_TYPE_WTR)) 
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_SOLENIS_TECHNOLOGIES_GERMANY);
                    continue;
                } 
                else if(!lwr.Sections__c.contains(LWRConstants.SECTION_NAME_ANALYTICAL)
                          &&  lwr.Request_Type__c.equalsIgnoreCase(LWRConstants.REQUEST_TYPE_PPD))
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_SOLENIS_TECHNOLOGIES_GERMANY);
                    continue;
                } 
            }
            else if(lwr.Technical_Center__c.equalsIgnoreCase(LWRConstants.TECHNICAL_CENTER_BARENDRECHT))
            {
               if(lwr.Request__c.equalsIgnoreCase(LWRConstants.REQUEST_NAME_WRAP) || lwr.Request__c.equalsIgnoreCase(LWRConstants.REQUEST_NAME_COUPON)){
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_WAS);
                    continue;
                }
                else if(lwr.Sections__c.equalsIgnoreCase(LWRConstants.SECTION_NAME_APPLICATIONS) 
                          &&  lwr.Request_Type__c.equalsIgnoreCase(LWRConstants.REQUEST_TYPE_WTR)) 
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_SOLENIS_TECHNOLOGIES_GERMANY);
                    continue;
                }
                else if(lwr.Sections__c.equalsIgnoreCase(LWRConstants.SECTION_NAME_ANALYTICAL) 
                          &&  lwr.Request_Type__c.equalsIgnoreCase(LWRConstants.REQUEST_TYPE_WTR)) 
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_WAS);
                    continue;
                }
                else if(String.isNotBlank(lwr.Sections__c) 
                          &&  lwr.Request_Type__c.equalsIgnoreCase(LWRConstants.REQUEST_TYPE_PPD)) 
                {
                    lwr.Lab_Initials__c = getLabInitialsId(labsByName, LWRConstants.LAB_NAME_SOLENIS_TECHNOLOGIES_GERMANY);
                    continue;
                }  
            }
        }
    }
    
    private static string getLabInitialsId(Map<String, List<SObject>> labListByLabNames, String labName){
        String labInitialsId;
        if(String.isNotBlank(labName) && 
           labListByLabNames.containsKey(labName) && 
           !labListByLabNames.get(labName).isEmpty())
        {
           labInitialsId = String.valueOf(labListByLabNames.get(labName)[0].get('Id')); 
        }
        
        return labInitialsId;
    }
}