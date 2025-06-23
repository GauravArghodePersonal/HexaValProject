/**
* @description : Custom Handler class on Complaint Trigger
* ***************************************REVISION HISTORY****************************************** 
* [SL-5]: Triage and Verification stage assigned to Complaint Owner (custom field) and Evaluator respectively, raise validation errors respectively
* [SL-40] Update Complaint's Evaluator when Manufacturing Plant Code is changed
* ***************************************REVISION HISTORY****************************************** 
*/
@SuppressWarnings('PMD')  
public with sharing class CQ_SL_Complaint_Handler {
    /**
     * @description Apex Method to Send Email to Complaint Record owner when user or Queue
     * @param newRecords
     * @param oldMap
     * @Story [SL-5] : Triage and Verification stage assigned to Complaint Owner (custom field) and Evaluator respectively, raise validation errors respectively
     */
    public static void sendEmailWhenComplanitOwnerShipIsUpdated(List<compliancequest__SQX_Complaint__c> newRecords,Map<Id,compliancequest__SQX_Complaint__c> oldMap) {
        Set<String> userIds = new Set<String>();
        Set<String> queueIds = new Set<String>();
        Set<String> emailIds = new Set<String>();
        
         for (compliancequest__SQX_Complaint__c complaint : newRecords) {
            if(oldMap.get(complaint.Id).compliancequest__Record_Stage__c!=complaint.compliancequest__Record_Stage__c && complaint.compliancequest__Record_Stage__c=='Triage'){
                if(String.valueOf(complaint.ownerId).StartsWith('00G')){
                    queueIds.add(complaint.ownerId);
                }
                if(String.valueOf(complaint.ownerId).StartsWith('005')){
                    userIds.add(complaint.ownerId);
                }
            }
        }
        if(!userIds.isEmpty() && getEmailAddressedOfTheOwner(userIds).size()>0){
            emailIds.addAll(getEmailAddressedOfTheOwner(userIds));
        }
        if(!queueIds.isEmpty() && getEmailAddressedOfQueueMember(queueIds).size()>0){
            emailIds.addAll(getEmailAddressedOfQueueMember(queueIds));
        }
        if(emailIds.size()>0){
            sendEmailToUsersAndQueues(emailIds, newRecords);
        }
    }
    /**
     * @description address of quue member
     * @param emailIds
     * @param newRecords
     */
    public static void sendEmailToUsersAndQueues(Set<String> emailIds,List<compliancequest__SQX_Complaint__c> newRecords) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        compliancequest__SQX_Custom_Settings_Public__c customSetting = compliancequest__SQX_Custom_Settings_Public__c.getInstance();
        String orgBaseUrl = customSetting.compliancequest__Org_Base_URL__c;
        for (compliancequest__SQX_Complaint__c complaint : newRecords) {
                
                // the body of the email
                String body = '<style type="text/css">'+
                    'table{border: 1px solid black; width: 100%;}'+
                    'td, th{border: 1px solid black;'+                
                    'height: 40px;'+
                    'padding: 5px;}'+
                    'span.thick {font-weight: bold;}'+
                    'span.underln {text-decoration: underline;}'+
                    'div.emailContent {font-size: 13px; font-family: Arial;}'+
                    '</style>';
                
                body += '<div class="emailContent">';
                body += '<p> <span class="thick">The complaint has been assigned complaint number </span>'+complaint.Name+'. Please initiate and complete the record<span class="thick">.</p>'+
                    '<p> <span class="thick">Title :</span>'+complaint.compliancequest__Complaint_Title__c+'</p>' +
                    '<p> <span class="thick">Link to launch to complaint record : </span>' + '<a href="' + orgBaseUrl + complaint.Id + '">' + '<span class="underln">' + orgBaseUrl + '<span>' + complaint.Id + '</span></span></a></p>' +
                    '<br/><br/>';
                Messaging.SingleEmailMessage semail= new Messaging.SingleEmailMessage();
                semail.setSubject('The Complaint '+complaint.Name+' has been Assigned');
                semail.setToAddresses (new List<String>(emailIds));
                semail.setHtmlBody(body);
                messages.add(semail);
            }
            if(messages.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
        }
    /**
     * @description address of quue member
     * @param queueIds
     * @return emailAddress;
     */
    public static Set<String> getEmailAddressedOfQueueMember(Set<String> queueIds) {
        Set<String> emailAddress = new Set<String>();
        if (Schema.sObjectType.User.isAccessible() && Schema.sObjectType.GroupMember.isAccessible()) {
        List<User> usersInQueue = [Select id,email from User where Id in (Select UserOrGroupId from GroupMember WHERE Group.Type='Queue' and GroupId IN :queueIds)];
        for(User singleUser: usersInQueue){
            emailAddress.Add(singleUser.Email);
        }
    }
        // Add debug log to capture values
        return emailAddress;
    }
    /**
     * @description address of the owner
     * @param uIds
     * @return emailAddress
     */
    public static Set<String> getEmailAddressedOfTheOwner(Set<String> uIds) {
        Set<String> emailAddress = new Set<String>();
        if (Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.Email.isAccessible()) {
        List<User> users = [Select id,email from User where Id in :uIds];
        for(User singleUser: users){
            emailAddress.Add(singleUser.Email);
        }
    }
        return emailAddress;
    }

    /**
     * @description This method will update the Evaluator when Manufacturing Plant Code is changed in Complaint record.
     * @param newRecords
     * @param oldMap
     * @Story [SL-40] Update Complaint's Evaluator when Manufacturing Plant Code is changed
     */
    public static void setEvaluatorWhenComplaintManufacturingPlantCodeIsUpdated(List<compliancequest__SQX_Complaint__c> newRecords, 
                                                                                Map<Id, compliancequest__SQX_Complaint__c> oldMap) {

        Map<Id, String> complaintIdWithPlantCodeMap = new Map<Id, String>();
        
        for (compliancequest__SQX_Complaint__c complaint : newRecords) {
            if(oldMap.get(complaint.Id).CQ_SL_PlantCode__c != complaint.CQ_SL_PlantCode__c 
               && (complaint.compliancequest__Record_Stage__c == 'Triage' || complaint.compliancequest__Record_Stage__c == 'Draft'))
            {
                complaintIdWithPlantCodeMap.put(complaint.Id, complaint.CQ_SL_PlantCode__c);
            }
        }
        
        if(complaintIdWithPlantCodeMap.values().size() > 0){
            //Get matched Assignment Evaluator Records
            List<CQ_SL_SQX_Assignment_Evaluator__c> assignmentEvaluators = [SELECT CQ_SL_SQX_Assignment__r.CQ_SL_Plant_Code__c,
                                                                            CQ_SL_SQX_User__c,
                                                                            Name
                                                                            FROM CQ_SL_SQX_Assignment_Evaluator__c 
                                                                            WHERE CQ_SL_SQX_Assignment__r.CQ_SL_Plant_Code__c IN: complaintIdWithPlantCodeMap.values()
                                                                            ORDER BY Name];
            
            Map<String, Id> plantCodeWithEvaluatorIdMap = new Map<String, Id>(); 
            if(assignmentEvaluators.size() > 0){
                String tempPlantCode = ''; 
                for(CQ_SL_SQX_Assignment_Evaluator__c assignmentEva : assignmentEvaluators){
                    if((String.isBlank(tempPlantCode)) || 
                       (!String.isBlank(tempPlantCode) && tempPlantCode != assignmentEva.CQ_SL_SQX_Assignment__r.CQ_SL_Plant_Code__c))
                    {
                        plantCodeWithEvaluatorIdMap.put(assignmentEva.CQ_SL_SQX_Assignment__r.CQ_SL_Plant_Code__c, assignmentEva.CQ_SL_SQX_User__c);
                    }
                    tempPlantCode = assignmentEva.CQ_SL_SQX_Assignment__r.CQ_SL_Plant_Code__c;
                }
            }
            
            Map<Id, Id> complaintIdWithCompEvaluatorIdMap = new Map<Id, Id>();
            
            for(compliancequest__SQX_Complaint__c complaintRec : newRecords){
                if(complaintIdWithPlantCodeMap.keySet().contains(complaintRec.Id) 
                   && !plantCodeWithEvaluatorIdMap.keySet().contains(complaintIdWithPlantCodeMap.get(complaintRec.Id)))
                {
                    complaintRec.addError('Matched Plant Code, Assignment record not found.');
                }
                else if(complaintIdWithPlantCodeMap.keySet().contains(complaintRec.Id) 
                       && plantCodeWithEvaluatorIdMap.get(complaintIdWithPlantCodeMap.get(complaintRec.Id)) == null)
                {
                    complaintRec.addError('Assignment Evaluator record not found.');
                }
                else if(complaintIdWithPlantCodeMap.keySet().contains(complaintRec.Id) 
                        && plantCodeWithEvaluatorIdMap.get(complaintIdWithPlantCodeMap.get(complaintRec.Id)) != null)
                {
                    complaintIdWithCompEvaluatorIdMap.put(complaintRec.Id, plantCodeWithEvaluatorIdMap.get(complaintIdWithPlantCodeMap.get(complaintRec.Id)));
                }
            }
            
            if(complaintIdWithCompEvaluatorIdMap.values().size() > 0){
                
                //Get Complaint Evaluator Records
                List<CQ_SL_SQX_Evaluator__c> compEvaluators = [SELECT Id, CQ_SL_SQX_Complaint__c,
                                                               CQ_SL_SQX_User__c
                                                               FROM CQ_SL_SQX_Evaluator__c 
                                                               WHERE CQ_SL_SQX_Complaint__c IN: complaintIdWithCompEvaluatorIdMap.keySet()];
                
                List<CQ_SL_SQX_Evaluator__c> updatedComplaintEvaluators = new List<CQ_SL_SQX_Evaluator__c>();
                
                if(compEvaluators.size() > 0){
                    for(CQ_SL_SQX_Evaluator__c complaintEvaluatorRec : compEvaluators){
                        if(complaintIdWithCompEvaluatorIdMap.get(complaintEvaluatorRec.CQ_SL_SQX_Complaint__c) != null){
                            complaintEvaluatorRec.CQ_SL_SQX_User__c = complaintIdWithCompEvaluatorIdMap.get(complaintEvaluatorRec.CQ_SL_SQX_Complaint__c);
                            updatedComplaintEvaluators.add(complaintEvaluatorRec);
                        }
                    }
                    
                    if(updatedComplaintEvaluators.size() > 0){
                        Database.SaveResult[] result = Database.update(updatedComplaintEvaluators, false);
                    }
                }
                //When there is no Complaint Evaluator [SL-52] {Start}
                else{
                    for(Id complaintId : complaintIdWithCompEvaluatorIdMap.keySet()){
                        CQ_SL_SQX_Evaluator__c newEvaluator = new CQ_SL_SQX_Evaluator__c();
                        newEvaluator.CQ_SL_SQX_Complaint__c = complaintId;
                        newEvaluator.CQ_SL_SQX_User__c = complaintIdWithCompEvaluatorIdMap.get(complaintId);
                        updatedComplaintEvaluators.add(newEvaluator);
                    }
                    
                    if(updatedComplaintEvaluators.size() > 0){
                        Database.SaveResult[] result1 = Database.insert(updatedComplaintEvaluators, false);
                    }
                }
                //[SL-52] {End}
            }            
        }
    }
}