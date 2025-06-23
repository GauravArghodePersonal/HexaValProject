/** @description Test class of Trigger Assignement Object.
******************************** Revision History ****************************
* Story: [SL-6] New Object Assignment Created "CQ_SL_SQX_Assignment__c".Please create the new fields as mentioned in the attached excel file.
* Test Method Name : givenUserWithAssignment_WhenAssignmentIsCreated_ThenQueueIsSet()
* -----------------------------------------------------------------------------
* [SL-81] Add Responsible departments in Assignment screen
* Apex Class : CQ_SL_Assignment
* Method Name : updateAllQueueIdsWhenAssignmentIsCreated()
* Test Method Name : givenUserWithAssignment_WhenAssignmentIsCreated_ThenQueueIsSet()
* -----------------------------------------------------------------------------
* [SL-83] Complaint not getting assigned to Triage queue
* Apex Class : CQ_SL_Assignment
* Method Name : updateQueueIdsWhenAssignmentUpdated()
* Test Method Name : givenAssignment_WhenAssignmentRecordUpdated_ThenQueueIdIsUpdatedAccordingly()
********************************* Revision History *****************************/
@IsTest
public class CQ_SL_Test_Assignment_Trigger {
    /*
     * @description setup method to construct data
     */
    @testSetup
    static void setupData(){
        new CQ_SL_Test_User_Factory().constructData('co-standard-actionAssignee');
    }
    
    /*
     * @description this test method testing the assignment of a user to a queue by creating a sample assignment record, associating it with a queue, and then verifying that the assignment's
     * GIVEN: User With Assignment.
     * WHEN: Assignment is created.
     * THEN: Queue is set.
     * @Story: [SL-6] [SL-81]
     */
    @IsTest
    public static void givenUserWithAssignment_WhenAssignmentIsCreated_ThenQueueIsSet(){
        
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser) {
            
            //Arrange: Retrieve a Queue
            Group queue1 = [SELECT Id FROM Group WHERE Name = 'Third Party Vendors'];
            // Act: Create an Assignment record using the factory CS class
            CQ_SL_SQX_Assignment__c assignment = CQ_SL_Test_Assignment_CS.createAssignment(true);
            
            assignment.CQ_SL_Choose_CA_User_By_Default__c = true;
            assignment.CQ_SL_CA_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = true;
            assignment.CQ_SL_Planning_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = true;
            assignment.CQ_SL_STP_Procurement_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = true;
            assignment.CQ_SL_OTC_Queue__c ='Third Party Vendors';
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = true;
            assignment.CQ_SL_Manufacturing_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = true;
            assignment.CQ_SL_Logisics_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Global_Compliance_User_Default__c = true;
            assignment.CQ_SL_Global_Compliance_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Global_Trade_Mgt_User_Default__c = true;
            assignment.CQ_SL_Global_Trade_Management_Queue__c = 'Third Party Vendors';
            insert assignment;
            
            // Assert: Verify that the Queue is set correctly
            assignment = [SELECT Id, CQ_SL_CA_Queue_Id__c, 
                          CQ_SL_Global_Compliance_Queue_Id__c,
                          CQ_SL_Global_Trade_Management_Queue_Id__c,
                          CQ_SL_Logisics_Queue_Id__c,
                          CQ_SL_Manufacturing_Queue_Id__c,
                          CQ_SL_OTC_Queue_Id__c,
                          CQ_SL_Planning_Queue_Id__c,
                          CQ_SL_STP_Procurement_Queue_Id__c
                          FROM CQ_SL_SQX_Assignment__c 
                          WHERE Id =: assignment.Id];
            System.assertEquals(queue1.Id, assignment.CQ_SL_CA_Queue_Id__c, 'Failed to set the Commercial Area Queue Id when Assignment record is created.');
            System.assertEquals(queue1.Id, assignment.CQ_SL_Global_Compliance_Queue_Id__c,'Failed to set the Global Compliance Queue Id when Assignment record is created.');
            System.assertEquals(queue1.Id, assignment.CQ_SL_Global_Trade_Management_Queue_Id__c,'Failed to set the Global Trade Management Queue Id when Assignment record is created.');
            System.assertEquals(queue1.Id, assignment.CQ_SL_Logisics_Queue_Id__c,'Failed to set Logistics Queue Id when Assignment record is created.');
            System.assertEquals(queue1.Id, assignment.CQ_SL_Manufacturing_Queue_Id__c,'Failed to set Manufacturing Queue Id when Assignment record is created.');
            System.assertEquals(queue1.Id, assignment.CQ_SL_OTC_Queue_Id__c,'Failed to set Customer Services Queue Id when Assignment record is created.');
            System.assertEquals(queue1.Id, assignment.CQ_SL_Planning_Queue_Id__c,'Failed to set Planning Queue Id when Assignment record is created.');
            System.assertEquals(queue1.Id, assignment.CQ_SL_STP_Procurement_Queue_Id__c,'Failed to set Procurement Queue Id when Assignment record is created.');           
        }
    }
    
    /**
     * @description This test method verify the Queue Id is set when Assignment record is updated.
     * GIVEN : Assignment Record
     * WHEN  : Assignment Record is updated with Queues
     * THEN  : Set Queue Ids of Assignment record
     * @Story [SL-83]
     */
    @isTest
    public static void givenAssignment_WhenAssignmentRecordUpdated_ThenQueueIdIsUpdatedAccordingly(){
        
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser) {
            
            //Arrange: Retrieve a Queue
            Group queue1 = [SELECT Id FROM Group WHERE Name = 'Third Party Vendors'];
            
            //Arrange: Create an Assignment record using the factory CS class
            CQ_SL_SQX_Assignment__c assignment = CQ_SL_Test_Assignment_CS.createAssignment(true);
            
            //Add user to Commercial Area
            assignment.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment.CQ_SL_SQX_CA_User__c = stdUser.Id;
            
            //Add user to Global Compliance
            assignment.CQ_SL_Global_Compliance_User_Default__c = false;
            assignment.CQ_SL_SQX_Global_Compliance_User__c = stdUser.Id;
            
            //Add user to Global Trade Management
            assignment.CQ_SL_Global_Trade_Mgt_User_Default__c = false;
            assignment.CQ_SL_SQX_Global_Trade_Management_User__c = stdUser.Id;
            
            //Add user to Planning
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            
            //Add user to Procurement
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Add user to Customer Services
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            
            //Add user to Manufacturing            
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            
            //Add user to Logistics
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            
            //Create a Assignment record
            insert assignment;
            
            //Act: Update Assignment record
            assignment.CQ_SL_Choose_CA_User_By_Default__c = true;
            assignment.CQ_SL_CA_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Global_Compliance_User_Default__c = true;
            assignment.CQ_SL_Global_Compliance_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Global_Trade_Mgt_User_Default__c = true;
            assignment.CQ_SL_Global_Trade_Management_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = true;
            assignment.CQ_SL_Logisics_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = true;
            assignment.CQ_SL_Manufacturing_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = true;
            assignment.CQ_SL_OTC_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = true;
            assignment.CQ_SL_Planning_Queue__c = 'Third Party Vendors';
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = true;
            assignment.CQ_SL_STP_Procurement_Queue__c = 'Third Party Vendors';
            update assignment;
            
            //Assert: Set Queue Ids of Respective Departments
            CQ_SL_SQX_Assignment__c assignmentRecord = [SELECT Id, CQ_SL_CA_Queue_Id__c,
                                                        CQ_SL_Global_Compliance_Queue_Id__c,
                                                        CQ_SL_Global_Trade_Management_Queue_Id__c,
                                                        CQ_SL_Logisics_Queue_Id__c,
                                                        CQ_SL_Manufacturing_Queue_Id__c,
                                                        CQ_SL_OTC_Queue_Id__c,
                                                        CQ_SL_Planning_Queue_Id__c,
                                                        CQ_SL_STP_Procurement_Queue_Id__c
                                                        FROM CQ_SL_SQX_Assignment__c 
                                                        WHERE Id =: assignment.Id];
            System.assertEquals(queue1.Id, assignmentRecord.CQ_SL_CA_Queue_Id__c, 'Failed to set the CA Queue Id when Assignment record is updated.');
            System.assertEquals(queue1.Id, assignmentRecord.CQ_SL_Global_Compliance_Queue_Id__c, 'Failed to set Global Compliance Queue Id when Assignment record is updated.');
            System.assertEquals(queue1.Id, assignmentRecord.CQ_SL_Global_Trade_Management_Queue_Id__c, 'Failed to set Global Trade Management Queue Id when Assignment record is updated.');
            System.assertEquals(queue1.Id, assignmentRecord.CQ_SL_Logisics_Queue_Id__c, 'Failed to set Logistics Queue Id when Assignment record is updated.');
            System.assertEquals(queue1.Id, assignmentRecord.CQ_SL_Manufacturing_Queue_Id__c, 'Failed to set Manufacturing Queue Id when Assignment record is updated.');
            System.assertEquals(queue1.Id, assignmentRecord.CQ_SL_OTC_Queue_Id__c, 'Failed to set Customer Service Queue Id when Assignment record is updated.');
            System.assertEquals(queue1.Id, assignmentRecord.CQ_SL_Planning_Queue_Id__c, 'Failed to set Planning Queue Id when Assignment record is updated.');
            System.assertEquals(queue1.Id, assignmentRecord.CQ_SL_STP_Procurement_Queue_Id__c, 'Failed to set Procurement Queue Id when Assignment record is updated.');
        }
    }
}