/*
 * @description - Common setup class for Investigation
 * *************************************** REVISION HISTORY******************************************
 * 1. [SL-28]: Read only Formula fields from investigation to complaint
 * 2. [SL-22]: Adhoc configs - Field mgt
 * 3. [SL-36]: Additional Configs
 * *************************************** REVISION HISTORY*******************************************/
@isTest
public class CQ_SL_Test_Investigation {
     /**
      * @description - Method to call Assignment, Complaint Factory class to create necessary record
      */
    @testSetup
    static void setupData(){
        Map<String,SObject> usersMap = new CQ_CCC_Test_Data_Factory(User.SObjectType).constructData('users-adminandstandard');
        User stdUser = (User)usersMap.get('Standard User 1');

        System.runAs(stdUser){
            new CQ_CCC_Test_Data_Factory(CQ_SL_SQX_Assignment__c.SObjectType).constructData('createAssign-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-OF-CA-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('BulkInsert');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Investigation__c.SObjectType).constructData('createComplain-withInvestigationAndActionPlan');  
        }
    }
    
    /**
     * @description - This validation rule checks Action Plan should be complete before completion of Investigation.
     * GIVEN - Investigation.
     * WHEN - Action Plan is not completed.
     * THEN - Throw Validation Error.
     * @story[SL-22] - Adhoc configs - Field mgt
     */
    @isTest
    public static void givenInvestigation_WhenActionPlanIsNotCompleted_ThenThrowValidationError() {
        User stdUser = [SELECT Id FROM User WHERE FirstName = :'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            
            //Arrange: Create Investigation With Action Plan in Incomplete Stage
            compliancequest__SQX_Investigation__c investigation = CQ_SL_Test_Investigation_Factory.createComplainWithInvestigationAndActionPlan(false);
            
            investigation.compliancequest__Activity_Code__c = 'performinvestigation_complete';
            investigation.compliancequest__Investigation_Summary__c = 'Investigation Summary';
            investigation.compliancequest__Conclusion__c = 'Confirmed';
            
            Database.SaveResult result = Database.update(investigation, false);
            
            //Assert: Check the Validation Rule.
            System.assertEquals(false, result.isSuccess(), 'Perform Investigation should not be completed but completed');
            
            //Arrange: Get the List of Action Plan and Change Status to Complete
            List<compliancequest__SQX_Action_Plan__c> actionPlanList = [SELECT Id,compliancequest__Completed__c 
                                                                        FROM compliancequest__SQX_Action_Plan__c 
                                                                        WHERE compliancequest__SQX_Investigation__c = :investigation.Id];
            
            //Act: Complete the Action Plan
            List<compliancequest__SQX_Action_Plan__c> updateActionPlanList = new List<compliancequest__SQX_Action_Plan__c>();
            for(compliancequest__SQX_Action_Plan__c actionPlan : actionPlanList) {
                actionPlan.compliancequest__Completed__c = true;
                actionPlan.compliancequest__Completion_Date__c = Date.Today();
                updateActionPlanList.add(actionPlan);
            }
            
            if(updateActionPlanList.size() > 0) {
                update updateActionPlanList;
            }
            
            //Submit the Investigaion to complete  
            Database.SaveResult resultUpdate = Database.update(investigation, false);
            
            //Assert: Check the Validation Rule.
            System.assertEquals(true, resultUpdate.isSuccess(), 'Perform Investigation should be completed but not completed');
        }
    }
    
     /**
     * @description - This validation rule checks Action Plan should be complete before completion of Investigation.
     * GIVEN - Investigation.
     * WHEN - Investigation summary and Description
     * THEN - Populate in Complaints
     * Flow - CQ_SL_Investigation_After_Update_RT_Flow
     * @story[SL-28] - Read only Formula fields from investigation to complaint
     */
    @isTest
    public static void givenInvestigation_WhenInvSummaryAndDescriptionAdded_ThenPopulateInComplaints() {
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];   
        
        System.runAs(stdUser){
            //Arrange: Complaint Record
            compliancequest__SQX_Complaint__c complainRecord1 =[SELECT Id,CQ_SL_Root_Cause_Description__c,CQ_SL_Investigation_Summary__c FROM compliancequest__SQX_Complaint__c LIMIT 1];

            //Arrange: Investigation Record
             compliancequest__SQX_Investigation__c investigation = [SELECT Id,compliancequest__Investigation_Summary__c,compliancequest__SQX_Complaint__c FROM compliancequest__SQX_Investigation__c LIMIT 1];
             
            //Arrange: Get the Action Plan
            compliancequest__SQX_Action_Plan__c actionPlan = [SELECT Id,compliancequest__Plan_Type__c,compliancequest__Description__c FROM compliancequest__SQX_Action_Plan__c LIMIT 1];

            //Assert: Checking Summary and Description
            System.assertEquals('Corrective', actionPlan.compliancequest__Plan_Type__c, 'Plan type was not set');
            System.assertEquals(complainRecord1.CQ_SL_Root_Cause_Description__c, actionPlan.compliancequest__Description__c, 'Description was not set');
            System.assertEquals(complainRecord1.CQ_SL_Investigation_Summary__c, investigation.compliancequest__Investigation_Summary__c, 'summary was not set');
        }
    }

   /**
     * @description - Update the OwnerId of Investigation
     * GIVEN - Investigation.
     * WHEN - Investigation Completed
     * THEN - Change The Owner Id of Investigation
     * Flow - CQ_SL_Investigation_After_Update_RT_Flow
     * @story[SL-36] - Additional Configs
     */
    @isTest
    public static void givenInvestigation_WhenInvestigationCompleted_ThenChangeTheOwnerIdOfInvestigation() {
        
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            
            //Arrange: Create Investigation With Action Plan in Incomplete Stage
            compliancequest__SQX_Complaint__c comRecord = [SELECT Id, OwnerId,
                                                           CQ_SL_Responsible_Department__c
                                                           FROM compliancequest__SQX_Complaint__c 
                                                           WHERE CQ_SL_Responsible_Department__c = 'CA'];
            
            compliancequest__SQX_Investigation__c investigation = CQ_SL_Test_Investigation_Factory.createComplainWithInvestigationAndActionPlan(false);
            
            //Arrange: Get the List of Action Plan and Change Status to Complete
            List<compliancequest__SQX_Action_Plan__c> actionPlanList = [SELECT Id,compliancequest__Completed__c,
                                                                        compliancequest__Completion_Date__c
                                                                        FROM compliancequest__SQX_Action_Plan__c 
                                                                        WHERE compliancequest__SQX_Investigation__c = :investigation.Id];
            
            //Act: Complete the Action Plan
            List<compliancequest__SQX_Action_Plan__c> updateActionPlanList = new List<compliancequest__SQX_Action_Plan__c>();
            for(compliancequest__SQX_Action_Plan__c actionPlan : actionPlanList) {
                actionPlan.compliancequest__Completed__c = true;
                actionPlan.compliancequest__Completion_Date__c = Date.Today();
                updateActionPlanList.add(actionPlan);
            }
            
            if(updateActionPlanList.size() > 0) {
                update updateActionPlanList;
            }
            
            //Act: Update the Investigation to complete
            investigation.compliancequest__Activity_Code__c = 'performinvestigation_complete';
            investigation.compliancequest__Investigation_Summary__c = 'Investigation Summary';
            Database.SaveResult result = Database.update(investigation, false);
            
            //Arrange: Get the Ipdated Investigation Record.
            compliancequest__SQX_Investigation__c completedInvestigation = [SELECT Id, OwnerId
                                                                            FROM compliancequest__SQX_Investigation__c
                                                                            WHERE Id = :investigation.Id LIMIT 1];

            //Assert: Check the OwnerId of Investigation is equal to the OwnerId of the Complaint.
            System.assertEquals(comRecord.OwnerId, completedInvestigation.OwnerId, 'Owner of the investigation should be updated to owner of complaint but not failed');
         }
    }
}