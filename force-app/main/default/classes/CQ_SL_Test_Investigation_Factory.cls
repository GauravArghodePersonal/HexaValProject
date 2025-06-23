/**
 * @description - Common setup class for Investigation
 * *************************************** REVISION HISTORY******************************************
 * 1. [SL-28]: Read only Formula fields from investigation to complaint
 * 2. [SL-22]: Adhoc configs - Field mgt
 * *************************************** REVISION HISTORY*******************************************/
@isTest
public class CQ_SL_Test_Investigation_Factory implements CQ_SL_Test_SObject_Factory {
    
    //Commit values
    public static final Boolean NO_COMMIT_DB = TRUE,
                                COMMIT_DB = FALSE;
    
    /**
     * @description Method to Construct Data
     * @return new
     * @param dataCode
     */
    public Map<String, SObject> constructData(String dataCode){
        
        switch on dataCode{
            when 'createComplain-withInvestigationAndActionPlan' { createComplainWithInvestigationAndActionPlan(COMMIT_DB);}
        }
        return new  Map<String,SObject>();
    }
    
    /**
     * @description - Create a complain with investigation
     * @param noCommitToDb
     * @return compliancequest__SQX_Investigation__c
     */
    public static compliancequest__SQX_Investigation__c createComplainWithInvestigationAndActionPlan(Boolean  noCommitToDb) {
        
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];   
        compliancequest__SQX_Investigation__c investigation = new compliancequest__SQX_Investigation__c();
        
        System.runAs(stdUser){
            //Arrange: Create Complaint record
            compliancequest__SQX_Complaint__c complainRecord = [SELECT id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c FROM compliancequest__SQX_Complaint__c WHERE CQ_SL_Responsible_Department__c = 'CA'];
            //Arrange Create Investigation with Developer Name as Complaint_Investigation
            investigation.compliancequest__SQX_Complaint__c = complainRecord.Id;
            investigation.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Complaint_Investigation'].Id;
            investigation.compliancequest__Investigation_Summary__c ='Testing IVs';
            
            if(!noCommitToDb) {
                insert investigation;
            }
            //Create Action Plan for Corrective Action
            compliancequest__SQX_Action_Plan__c actionPlan = new compliancequest__SQX_Action_Plan__c();
            actionPlan.compliancequest__Completed__c = false;
            actionPlan.compliancequest__Due_Date__c = Date.Today() + 5;
            actionPlan.compliancequest__Plan_Type__c = 'Corrective';
            actionPlan.compliancequest__Description__c ='test';
            actionPlan.compliancequest__SQX_User__c = stdUser.Id;
            actionPlan.compliancequest__SQX_Investigation__c = investigation.Id;
            insert actionPlan;
        }
        return investigation;        
    }
}