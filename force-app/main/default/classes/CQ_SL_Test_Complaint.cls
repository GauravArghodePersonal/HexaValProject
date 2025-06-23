/*****************************************REVISION HISTORY******************************************
 * 1. [SL-3]: Complaint Owner User(Custom Field) being pulled in Complaints from Assignment Object on Complaint Creation and Draft Stage and Evaluator values being pulled in Complaints from Assignment Object in In Progress Stage
 * 2. [SL-5]: Triage and Verification stage assigned to Complaint Owner (custom field) and Evaluator respectively, raise validation errors respectively
 * 3. [SL-40]: Update Complaint's Evaluator when Manufacturing Plant Code is changed
 * @description Common setup class for Complaint
****************************************REVISION HISTORY*******************************************/
@isTest
public class CQ_SL_Test_Complaint {
    
    /**
     * @description Method to call Assignment, Complaint Factory class to create necessary record
     */
    @testSetup
    static void setupData(){
        Map<String,SObject> usersMap = new CQ_CCC_Test_Data_Factory(User.SObjectType).constructData('users-adminandstandard');
        User stdUser = (User)usersMap.get('Standard User 1');
        User adminUser = (User)usersMap.get('Admin User 1');
        
        System.runAs(stdUser){
            new CQ_CCC_Test_Data_Factory(CQ_SL_SQX_Assignment__c.SObjectType).constructData('createAssign-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-OF-CA-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-OF-STP-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createComWithoutPlantCode-Commit');//[SL-52]
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('BulkInsert');
        }
    }
    
    /**
     * @description Test method to updateComplaintOwnerfieldwhenrecordisupdated
     * 
     * GIVEN: Complaint record in Triage stage
     * WHEN: Complaint is Updated
     * THEN: Complaint Owner is Updated or Not
     * 
     * Apex Class:CQ_SL_Complaint(updateComplaintOwnerfieldwhenrecordisupdated)     
     * @Story: [SL-3] Complaint Owner User(Custom Field) being pulled in Complaints from Assignment Object on Complaint Creation and Draft Stage and Evaluator values being pulled in Complaints from Assignment Object in In Progress Stage
     */ 
    @isTest
    public static void givenComplaintRecordInTraigeStage_WhenComplaintIsUpdated_ThenComplaintOwnerisUpdatedOrNot(){
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];   
        
        System.runAs(stdUser){
            
            //Arrange: Get Assignment Record
            CQ_SL_SQX_Assignment__c ass = [select id,CQ_SL_SQX_CA_User__c,CQ_SL_SQX_Manufacturing_User__c,CQ_SL_Plant_Code__c,CQ_SL_SQX_Panning_User__c
                                           from CQ_SL_SQX_Assignment__c LIMIT 1];
            
            //Arrange: Create Complaint record
            compliancequest__SQX_Complaint__c comRecord = [select id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c
                                                           from compliancequest__SQX_Complaint__c where CQ_SL_Responsible_Department__c = 'CA'];
            
            //Arrange: Update Complaint Record
            comRecord.compliancequest__Record_Stage__c = 'Triage';
            Update comRecord;
            
            //Assert: Complaint Owner is Updated or Not
            System.assertEquals(comRecord.OwnerId,ass.CQ_SL_SQX_CA_User__c,'Record updated successfully');
        }
    }
    
    /**
     * @description Test method to updateComplaintOwnerfieldwhenrecordisupdated
     * 
     * GIVEN: Complaint record 
     * WHEN: Complaint record is Updated 
     * THEN: Throw Validation 
     * 
     * Apex Class:CQ_SL_Complaint(updateComplaintOwnerfieldwhenrecordisupdated)     
     * @Story: [SL-3] Complaint Owner User(Custom Field) being pulled in Complaints from Assignment Object on Complaint Creation and Draft Stage and Evaluator values being pulled in Complaints from Assignment Object in In Progress Stage
     */ 
    @isTest
    public static void givenComplaintRecord_WhenComplaintIsUpdated_ThenThrowValidation(){
        User adminUser = [SELECT Id FROM User WHERE FirstName =: 'Admin User 1' LIMIT 1];   
        
        System.runAs(adminUser){
            
            //Arrange: Get Assignment Record
            CQ_SL_SQX_Assignment__c ass = [select id,CQ_SL_CA_Queue_Id__c,CQ_SL_Manufacturing_Queue_Id__c,CQ_SL_Plant_Code__c,CQ_SL_Planning_Queue_Id__c
                                           from CQ_SL_SQX_Assignment__c LIMIT 1];
            
            //Arrange: Create Complaint record
            compliancequest__SQX_Complaint__c comRecord = [select id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c
                                                           from compliancequest__SQX_Complaint__c where CQ_SL_Responsible_Department__c = 'CA'];
            
            //Act: Update Complaint Record
            comRecord.compliancequest__Record_Stage__c = 'Triage';
            comRecord.CQ_SL_PlantCode__c = '10';
            Database.SaveResult result1 = Database.update(comRecord, false);
            
            //Assert: Validation Error Should be thrown
            System.assertEquals(false,result1.isSuccess(),'Assignment Record is not found');
        }
    }
    
    /**
     * @description Test method to updateComplaintOwnerfieldwhenrecordisupdated
     * 
     * GIVEN: Complaint record in Triage stage
     * WHEN: Complaint is Updated with Dep STP
     * THEN: Complaint Owner is Updated or Not
     * 
     * Apex Class:CQ_SL_Complaint(updateComplaintOwnerfieldwhenrecordisupdated)     
     * @Story: [SL-3] Complaint Owner User(Custom Field) being pulled in Complaints from Assignment Object on Complaint Creation and Draft Stage and Evaluator values being pulled in Complaints from Assignment Object in In Progress Stage
     */ 
    @isTest
    public static void givenComplaintRecordInTraigeStage_WhenComplaintIsUpdatedDepSTP_ThenComplaintOwnerisUpdatedOrNot(){
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];   
        
        System.runAs(stdUser){
            
            //Arrange: Get Assignment Record
            CQ_SL_SQX_Assignment__c ass = [select id,CQ_SL_SQX_OTC_User__c,CQ_SL_SQX_STP_Procurement_User__c,CQ_SL_Plant_Code__c,CQ_SL_SQX_Logistics_User__c
                                           from CQ_SL_SQX_Assignment__c LIMIT 1];
            
            //Arrange: Create Complaint record
            compliancequest__SQX_Complaint__c comRecord = [select id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c
                                                           from compliancequest__SQX_Complaint__c where CQ_SL_Responsible_Department__c = 'STP'];
            
            //Arrange: Update Complaint Record
            comRecord.compliancequest__Record_Stage__c = 'Triage';
            Update comRecord;
            
            //Assert: Owner field is Updated
            System.assertEquals(comRecord.OwnerId,ass.CQ_SL_SQX_STP_Procurement_User__c,'Assignment Record is not found');
        }
    }
    /**
     * @description Test method to sendEmailWhenComplanitOwnerShipIsUpdated
     * 
     * GIVEN: Complaint record 
     * WHEN: Complaint record is Moved To Triage Stage and Updated with Queue or User as owner 
     * THEN: Complaint Owner to be notified with an email
     * 
     * Apex Class:CQ_SL_Complaint(sendEmailWhenComplanitOwnerShipIsUpdated)     
     * @Story: [SL-5] Complaint Owner User(Custom Field) being pulled in Complaints from Assignment Object on Complaint Creation and Draft Stage and Evaluator values being pulled in Complaints from Assignment Object in In Progress Stage
     */ 
    @isTest
    static void givenComplaintRecord_WhenOwnerIsUpdatedWithQueueOrUser_ThenSendEmailAlerts() {
        //ARRANGE: Get the User record and update email
        User stdUser = [SELECT Id, Email FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        stdUser.Email = 'project@compliancequest.com';
        update stdUser;
        
        // Create the "Third Party Vendor" queue
        Group queue = new Group(Name = 'Third Party Vendors', Type = 'Queue');
        insert queue;

        // Add a user to the queue
        GroupMember groupMember1 = new GroupMember();
        groupMember1.GroupId = queue.Id;
        groupMember1.UserOrGroupId = stdUser.Id;
        insert groupMember1;

        System.runAs(stdUser) {
            // Arrange: Create a Complaint record
            compliancequest__SQX_Complaint__c comRecord = [select id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c
                                                           from compliancequest__SQX_Complaint__c where CQ_SL_Responsible_Department__c = 'CA'];
            //Arrange: Update Complaint Record
            comRecord.compliancequest__Record_Stage__c = 'Triage';
            comRecord.OwnerId = queue.Id;
            Update comRecord;
        
            // Assert: Ensure that the email was sent to the queue
            Integer emailInvocations = Limits.getEmailInvocations();
            System.assert(emailInvocations >= 1, 'Failed to send email to the queue');
        }
    }
    /**
     * @description Test method to updateComplaintOwnerfieldwhenrecordisupdated
     * 
     * GIVEN: Complaint record
     * WHEN: Complaint is Updated to Verification
     * THEN: Complaint Owner is Updated or Not
     * 
     * Flow:CQ_SL_Complaint_After_Update_RT_Flow 
     * @Story: [SL-5] Triage and Verification stage assigned to Complaint Owner (custom field) and Evaluator respectively, raise validation errors respectively
     */ 
    @isTest	
    public static void givenComplaintRecordInVerificationStage_WhenComplaintIsUpdated_ThenComplaintOwnerisUpdatedOrNot(){
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];
        User stdUser1 = [SELECT Id FROM User WHERE FirstName =: 'Standard User 2' LIMIT 1];
        
        System.runAs(stdUser){
            
            //Arrange: Get Assignment Record
            /*CQ_SL_SQX_Assignment__c ass = [select id,CQ_SL_CA_Queue_Id__c,CQ_SL_Manufacturing_Queue_Id__c,CQ_SL_Plant_Code__c,CQ_SL_Planning_Queue_Id__c
                                           from CQ_SL_SQX_Assignment__c LIMIT 1];
            //Arrange: Get Assignment Evaluator Record
            CQ_SL_SQX_Assignment_Evaluator__c assEv = [select id,CQ_SL_SQX_User__c
                                           from CQ_SL_SQX_Assignment_Evaluator__c WHERE CQ_SL_SQX_Assignment__c =:ass.Id LIMIT 1];*/
            
            //Arrange: Create Complaint record
            compliancequest__SQX_Complaint__c comRecord = [select id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c
                                                           from compliancequest__SQX_Complaint__c where CQ_SL_Responsible_Department__c = 'STP'];
             //Arrange: Create Evaluator record
         	CQ_SL_SQX_Evaluator__c comEvaluator = new CQ_SL_SQX_Evaluator__c();
        	comEvaluator.CQ_SL_SQX_Complaint__c =comRecord.Id;
         	comEvaluator.CQ_SL_SQX_User__c=stdUser.Id;
         	insert comEvaluator;
                
            //Arrange: Update Complaint Record
            comRecord.compliancequest__Record_Stage__c = 'Closure Review';
            comRecord.compliancequest__Require_Closure_Review__c = True;
            comRecord.compliancequest__Closure_Review_By__c = stdUser1.Id;
            Update comRecord;
            
          	compliancequest__SQX_Complaint__c comRecord1 = [select id,CQ_SL_Responsible_Department__c,OwnerId,CQ_SL_PlantCode__c,compliancequest__Closure_Review_By__c
                                                           from compliancequest__SQX_Complaint__c where CQ_SL_Responsible_Department__c = 'STP'];
            
            //Assert: Owner field is Updated
            System.assertEquals(comRecord1.OwnerId,comRecord1.compliancequest__Closure_Review_By__c,'Owner Record is not found');
        }
    }

    /**
     * @description : This methods test the Evaluator UserId is Changed when Manufacture Plant Code Is Updated.
     * GIVEN : Complaint
     * WHEN : User Updated Manufacturing Plant Code
     * THEN : Update Complaint Evaluator
     * 
     * @Story: [SL-40] : Update Complaint's Evaluator when Manufacturing Plant Code is changed
     */
    @isTest
    public static void givenComplaint_WhenUserUpdateManufacturingPlantCode_ThenUpdateComplaintEvaluator(){
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        User stdUser2 = [SELECT Id FROM User WHERE FirstName =: 'Standard User 2' LIMIT 1];
        
        System.runAs(stdUser){
            String plantCode;
            
            //Arrange: Get Assignment Record
            CQ_SL_SQX_Assignment__c ass = [SELECT Id,
                                           CQ_SL_Plant_Code__c
                                           FROM CQ_SL_SQX_Assignment__c
                                           LIMIT 1];
            
            //Arrange: Create Assignment Evaluator
            CQ_SL_SQX_Assignment_Evaluator__c assignEvaluator = new CQ_SL_SQX_Assignment_Evaluator__c();
            assignEvaluator.CQ_SL_SQX_Assignment__c = ass.Id;
            assignEvaluator.CQ_SL_SQX_User__c = stdUser.Id;
            insert assignEvaluator;
            
            //Arrange: Get the Complaint Record.
            compliancequest__SQX_Complaint__c complaint = [SELECT Id,
                                                           CQ_SL_PlantCode__c
                                                           FROM compliancequest__SQX_Complaint__c
                                                           WHERE CQ_SL_Responsible_Department__c = 'CA'
                                                           LIMIT 1];
            //Arrange: Create Complaint Evaluator
            CQ_SL_SQX_Evaluator__c comEvaluator = new CQ_SL_SQX_Evaluator__c(
                CQ_SL_SQX_User__c = stdUser.Id,
                CQ_SL_SQX_Complaint__c = complaint.Id
            );
            insert comEvaluator;
            
            //Arrange: Get the plant Code which is not equal to previous Plant Code of the Complaint.
            String[] plantCodeList = CQ_SL_Test_Complaint_Factory.getPlantCodeList();
            for(integer i = 0; i <= 1; i++){
                if(plantCodeList[i] != null && plantCodeList[i] != complaint.CQ_SL_PlantCode__c) {
                    plantCode = plantCodeList[i];
                    break;
                }
            }
            
            //Create Assignment Record 
            CQ_SL_SQX_Assignment__c assignment = new CQ_SL_SQX_Assignment__c();
            assignment.CQ_SL_Plant_Code__c = plantCode;
            assignment.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            insert assignment;
            
            //Arrnage: Create the Assignment Evaluator
            CQ_SL_SQX_Assignment_Evaluator__c assignmentEvaluator = new CQ_SL_SQX_Assignment_Evaluator__c();
            assignmentEvaluator.CQ_SL_SQX_Assignment__c = assignment.Id;
            assignmentEvaluator.CQ_SL_SQX_User__c = stdUser2.Id;
            insert assignmentEvaluator;
            
            //Act: Update the plant code of the Complaint
            complaint.CQ_SL_PlantCode__c = plantCode;
            update complaint;
            
            //Arrange: Get the User and Id from the Evaluator.
            CQ_SL_SQX_Evaluator__c updatedEvaluator = [SELECT Id,
                                                       CQ_SL_SQX_User__c
                                                       FROM CQ_SL_SQX_Evaluator__c
                                                       WHERE CQ_SL_SQX_Complaint__c =: complaint.Id
                                                       LIMIT 1];
             
            //Assert: Check the updated Evaluator User Id is Equal to the Standard User 2 Id.
            system.assertEquals(stdUser2.Id, updatedEvaluator.CQ_SL_SQX_User__c, 'New updated Evaluator user should be user2 but not equal to the User 2');
        }
    }
    
    /**
     * @description : This methods test whether the Evaluator record is created when Manufacture Plant Code Is Updated.
     * GIVEN : Complaint Without Manufacturing Plant COde
     * WHEN : User Updated Manufacturing Plant Code
     * THEN : Create a Complaint Evaluator record
     * 
     * @Story: [SL-52] : Impact of Manufacturing Plant Code made as optional in Complaint create page.
     */
    @isTest
    public static void givenComplaintWithoutPlantCode_WhenUserUpdateManufPlantCode_ThenCreateComplaintEvaluatorRecord(){
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            String plantCode;
            
            //Arrange: Get Assignment Record
            CQ_SL_SQX_Assignment__c ass = [SELECT Id,
                                           CQ_SL_Plant_Code__c
                                           FROM CQ_SL_SQX_Assignment__c
                                           LIMIT 1];
            
            //Arrange: Create Assignment Evaluator
            CQ_SL_SQX_Assignment_Evaluator__c assignEvaluator = new CQ_SL_SQX_Assignment_Evaluator__c();
            assignEvaluator.CQ_SL_SQX_Assignment__c = ass.Id;
            assignEvaluator.CQ_SL_SQX_User__c = stdUser.Id;
            insert assignEvaluator;
            
            //Arrange: Get the Complaint Record.
            compliancequest__SQX_Complaint__c complaint = [SELECT Id,
                                                           CQ_SL_PlantCode__c
                                                           FROM compliancequest__SQX_Complaint__c
                                                           WHERE CQ_SL_PlantCode__c = ''
                                                           LIMIT 1];
            
            //Arrange: Get the plant Code which is not equal to previous Plant Code of the Complaint.
            String[] plantCodeList = CQ_SL_Test_Complaint_Factory.getPlantCodeList();
            for(integer i = 0; i <= 1; i++){
                if(plantCodeList[i] != null && plantCodeList[i] != complaint.CQ_SL_PlantCode__c) {
                    plantCode = plantCodeList[i];
                    break;
                }
            }
            
            //Act: Update the plant code of the Complaint
            complaint.CQ_SL_PlantCode__c = plantCode;
            update complaint;
            
            //Arrange: Get the User and Id from the Evaluator.
            CQ_SL_SQX_Evaluator__c createdEvaluator = [SELECT Id,
                                                       CQ_SL_SQX_User__c
                                                       FROM CQ_SL_SQX_Evaluator__c
                                                       WHERE CQ_SL_SQX_Complaint__c =: complaint.Id
                                                       LIMIT 1];
             
            //Assert: Check the updated Evaluator User Id is Equal to the Standard User 2 Id.
            system.assertEquals(stdUser.Id, createdEvaluator.CQ_SL_SQX_User__c, 'New Complaint Evaluator user should be stdUser but not same, when Complaint is created without Plant Code.');
        }
    }
}