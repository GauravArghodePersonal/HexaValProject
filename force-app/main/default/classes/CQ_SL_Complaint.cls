/**
 * @description : Custom Handler class on Complaint Trigger
 * ***************************************REVISION HISTORY****************************************** 
 * 1. [SL-3] Complaint Owner User(Custom Field) being pulled in Complaints from Assignment Object on Complaint Creation and Draft Stage and Evaluator values being pulled in Complaints from Assignment Object in In Progress Stage
 * 2. [SL-5] Triage and Verification stage assigned to Complaint Owner (custom field) and Evaluator respectively, raise validation errors respectively
 * 3. [SL-40] Update Complaint's Evaluator when Manufacturing Plant Code is changed
 * 4. [SL-81] Add Responsible departments in Assignment screen
 *    Modified Method Name : assigntheOwnerIdQueueId()
 *                           updateOwnerWhenComplaintIsSubmitted()
 * ***************************************REVISION HISTORY****************************************** 
 */ 
public with sharing class CQ_SL_Complaint {

    private Map<Id, compliancequest__SQX_Complaint__c> oldValues {get; set; }
    private List<compliancequest__SQX_Complaint__c> newValues {get; set; }
   
   /**
    * @description This is a constructor in which Trigger.Old and Trigger.New are passed as a parameter
    * @param newValues 
    * @param oldValues
    */
    public CQ_SL_Complaint(List<compliancequest__SQX_Complaint__c> newValues, Map<Id, compliancequest__SQX_Complaint__c> oldValues) {
        this.oldValues = oldValues == null ? new Map<Id, compliancequest__SQX_Complaint__c>() : oldValues;
        this.newValues = newValues;
    }
    
   /**
    * @description Method to return whether or not to execute Trigger based on setting
    * @return Returns setting information whether or not to execute CQ SS Trigger
    */ 
    public static Boolean isCQSLTriggerDisabled(){
       	CQ_SL_SQX_Trigger_Settings__c cqSlTriggerSettings = CQ_SL_SQX_Trigger_Settings__c.getInstance();
        return cqSlTriggerSettings.CQ_SL_Disable_All_CQ_Custom_Triggers__c;
    }

    /**
     * @description Method to process NC record based on Trigger Events
     */ 
    public void executeTriggerEvents() {

        Boolean isDisableTrigger = isCQSLTriggerDisabled();
        if(!isDisableTrigger) {
            // Perform operation related to Before Update
            if(Trigger.isBefore && Trigger.isUpdate) {
                updateOwnerWhenComplaintIsSubmitted(this.newValues, this.oldValues);
            }
            // Perform operation related to After Update
            if(Trigger.isAfter && Trigger.isUpdate) {
                CQ_SL_Complaint_Handler.sendEmailWhenComplanitOwnerShipIsUpdated(this.newValues, this.oldValues);
                CQ_SL_Complaint_Handler.setEvaluatorWhenComplaintManufacturingPlantCodeIsUpdated(this.newValues, this.oldValues); //[SL-40]
            }
        }
    }
    
    /**
     * @description Apex Method to Update Complaint Record owner based on plant code and Responsible department from the Assignment Record
     * @param newListCom
     * @param oldListCom
     * @Story [SL-3] Complaint Owner User(Custom Field) being pulled in Complaints from Assignment Object on Complaint Creation and Draft Stage and Evaluator values being pulled in Complaints from Assignment Object in In Progress Stage
     * @Story [SL-81]
     */
    public void updateOwnerWhenComplaintIsSubmitted(List<compliancequest__SQX_Complaint__c> newListCom, 
                                                    Map<Id,compliancequest__SQX_Complaint__c> oldListCom)
    {
        list<CQ_SL_SQX_Assignment__c> lstass= [Select Id, CQ_SL_CA_Queue__c,
                                               CQ_SL_CA_Queue_Id__c,
                                               //[SL-81] Retrieved new fields of Assignment{Start}
                                               CQ_SL_Global_Compliance_Queue__c, 
                                               CQ_SL_Global_Compliance_Queue_Id__c,
                                               CQ_SL_Global_Trade_Management_Queue__c,
                                               CQ_SL_Global_Trade_Management_Queue_Id__c,
                                               //[SL-81] Retrieved new fields of Assignment{End}
                                               CQ_SL_Logisics_Queue__c,
                                               CQ_SL_Logisics_Queue_Id__c,
                                               CQ_SL_Manufacturing_Queue_Id__c,
                                               CQ_SL_Manufacturing_Queue__c,
                                               CQ_SL_OTC_Queue__c,
                                               CQ_SL_OTC_Queue_Id__c,
                                               CQ_SL_Planning_Queue__c,
                                               CQ_SL_Planning_Queue_Id__c,
                                               CQ_SL_Plant_Code__c,
                                               CQ_SL_SQX_CA_User__c,
                                               //[SL-81] Retrieved new fields of Asignment{Start}
                                               CQ_SL_SQX_Global_Compliance_User__c,
                                               CQ_SL_SQX_Global_Trade_Management_User__c,
                                               //[SL-81] Retrieved new fields of Asignment{End}
                                               CQ_SL_SQX_OTC_User__c,
                                               CQ_SL_SQX_Logistics_User__c,
                                               CQ_SL_SQX_Manufacturing_User__c,
                                               CQ_SL_SQX_Panning_User__c,
                                               CQ_SL_SQX_STP_Procurement_User__c,
                                               CQ_SL_STP_Procurement_Queue__c,
                                               CQ_SL_STP_Procurement_Queue_Id__c
                                               FROM CQ_SL_SQX_Assignment__c];
        Map<String,CQ_SL_SQX_Assignment__c> mapfieldValue = new Map<String,CQ_SL_SQX_Assignment__c>();
        for(CQ_SL_SQX_Assignment__c assrecord : lstass){
            mapfieldValue.put(assrecord.CQ_SL_Plant_Code__c,assrecord);
        }
        
        if(mapfieldValue!=Null)
        {
            for(compliancequest__SQX_Complaint__c comrecord : newListCom){
                compliancequest__SQX_Complaint__c oldcom = oldListCom.get(comrecord.id);
                CQ_SL_SQX_Assignment__c assRec = mapfieldValue.get(comrecord.CQ_SL_PlantCode__c);
                if(((comrecord.compliancequest__Record_Stage__c == 'Triage' && oldcom.compliancequest__Record_Stage__c != comrecord.compliancequest__Record_Stage__c && assRec != Null)|| 
                    (comrecord.compliancequest__Record_Stage__c == 'In Progress' && assRec != Null && (oldcom.CQ_SL_PlantCode__c != comrecord.CQ_SL_PlantCode__c || oldcom.CQ_SL_Responsible_Department__c != comrecord.CQ_SL_Responsible_Department__c))
                   ))// this if for checking logic
                {
                    assigntheOwnerIdQueueId(comrecord,assRec);
                }
                else if(assRec == Null)
                {
                    comrecord.adderror(Label.CQ_SL_Error_Assignment_Not_Found);
                }
            }
        }
    }

    /**
     * @description
     * @param comrecord
     * @param assRec
     * @Story : [SL-81]
     */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    public static void assigntheOwnerIdQueueId(compliancequest__SQX_Complaint__c comrecord, CQ_SL_SQX_Assignment__c assRec){       
        
        switch on comrecord.CQ_SL_Responsible_Department__c{
            when 'CA'{
                setComplaintOwnerAccordingToDepartment(comrecord, assRec.CQ_SL_SQX_CA_User__c, assRec.CQ_SL_CA_Queue_Id__c);
            }
            //[SL-81] Set Complaint Owner for new picklist value of Responsible Department {Start}
            when 'Global Trade Compliance'{
                setComplaintOwnerAccordingToDepartment(comrecord, assRec.CQ_SL_SQX_Global_Compliance_User__c, assRec.CQ_SL_Global_Compliance_Queue_Id__c);
            }
            when 'Global Trade Management'{
                setComplaintOwnerAccordingToDepartment(comrecord, assRec.CQ_SL_SQX_Global_Trade_Management_User__c, assRec.CQ_SL_Global_Trade_Management_Queue_Id__c);
            }
            //[SL-81] Set Complaint Owner for new picklist value of Responsible Department {End}
            when 'OTC'{
                setComplaintOwnerAccordingToDepartment(comrecord, assRec.CQ_SL_SQX_OTC_User__c, assRec.CQ_SL_OTC_Queue_Id__c);
            }
            when 'PTD - Planning'{
                setComplaintOwnerAccordingToDepartment(comrecord, assRec.CQ_SL_SQX_Panning_User__c, assRec.CQ_SL_Planning_Queue_Id__c);
            }
            when 'PTD - Manufacturing'{
                setComplaintOwnerAccordingToDepartment(comrecord, assRec.CQ_SL_SQX_Manufacturing_User__c, assRec.CQ_SL_Manufacturing_Queue_Id__c);
            }
            when 'PTD - Logistics'{
                setComplaintOwnerAccordingToDepartment(comrecord, assRec.CQ_SL_SQX_Logistics_User__c, assRec.CQ_SL_Logisics_Queue_Id__c);
            }
            when 'STP'{
                setComplaintOwnerAccordingToDepartment(comrecord, assRec.CQ_SL_SQX_STP_Procurement_User__c, assRec.CQ_SL_STP_Procurement_Queue_Id__c);
            }
            when else{
                comrecord.addError('Complaint Responsible Department - ' + comrecord.CQ_SL_Responsible_Department__c + ' is not found in Assignment Records.');
            }
        }
    }
    /**
     * @description
     * @param complaint
     * @param userId
     * @param queueId
     * @return compliancequest__SQX_Complaint__c
     */
    public static compliancequest__SQX_Complaint__c setComplaintOwnerAccordingToDepartment(compliancequest__SQX_Complaint__c complaint, Id userId, Id queueId)
    {
        if(queueId != null){
            complaint.OwnerId = queueId;
        }else{
            complaint.OwnerId = userId;
        }
        return complaint;
    }
}