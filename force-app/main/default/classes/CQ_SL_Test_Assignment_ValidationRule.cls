/** @description Test class of Validation Rule Of Assignement Object.
******************************** Revision History ****************************
* Story: [SL-6] New Object Assignment Created "CQ_SL_SQX_Assignment__c".Please create the new fields as mentioned in the attached excel file.
* 
********************************* Revision History *****************************/

@isTest
public class CQ_SL_Test_Assignment_ValidationRule {
    
    /*
     * @description setup method to construct data
     */
    @testSetup
    static void setupData(){
        new CQ_SL_Test_User_Factory().constructData('co-standard-actionAssignee');
    }
    
    /**
     * @description method to check Assignment record for CA user and Queue
     * GIVEN: Assignment Record 
     * WHEN: Assignment is created without Queue And user of CA
     * THEN: Validation error is occur.
     * @Story: [SL-6]
     */
    @isTest
    public static void givenAssignmentWithoutCAQueueOrUser_WhenSaveRecord_ThenThrowValidationMessage() {
        
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser) {
            
            //Arrange: Retrieve a Queue
            Group queue1 = [SELECT Id FROM Group WHERE name = 'CLXL Logistics'];
            
            //Arrange: Create an invalid Assignment record using the factory
            CQ_SL_SQX_Assignment__c assignment = CQ_SL_Test_Assignment_CS.createAssignment(true);
            CQ_SL_SQX_Assignment__c assignment1 = CQ_SL_Test_Assignment_CS.createAssignment(true);
            
            //Act: Save the Assignment Record
            Database.SaveResult result = Database.insert(assignment, false);
            
            //Assert: Validation rule error is expected
            System.assertEquals(false, result.isSuccess(), 'Failed to throw CA Queue or User required validation message');
            
            //Arrange: Add CA User
            assignment.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with CA User
            result = Database.insert(assignment, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when CA User is available');
            
            //Arrange: Add CA Queue
            Schema.DescribeFieldResult fieldResult = CQ_SL_SQX_Assignment__c.CQ_SL_Plant_Code__c.getDescribe();
            assignment1.CQ_SL_Plant_Code__c = fieldResult.getPicklistValues()[1].getValue();
            assignment1.CQ_SL_Choose_CA_User_By_Default__c = true;
            assignment1.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment1.CQ_SL_CA_Queue__c = 'CLXL Logistics';
            assignment1.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with CA Queue
            result = Database.insert(assignment1, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when CA Queue is available');
        }
    }
    
     /**
      * @description method to check Assignment record for OTC user and Queue
     * GIVEN: Assignment Record 
     * WHEN: Assignment is created without Queue And user of OTC
     * THEN: Validation error is occur.
     * @Story: [SL-6]
     */
    @IsTest
    public static void givenAssignmentWithoutOTCQueueOrUser_WhenSaveRecord_ThenThrowValidationMessage() {
        
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser) {
            
            //Arrange: Retrieve a Queue
            Group queue1 = [SELECT Id FROM Group WHERE name = 'CLXL Logistics'];
            
            //Arrange: Create an invalid Assignment record using the factory
            CQ_SL_SQX_Assignment__c assignment = CQ_SL_Test_Assignment_CS.createAssignment(true);
            CQ_SL_SQX_Assignment__c assignment1 = CQ_SL_Test_Assignment_CS.createAssignment(true);
            
            //Act: Save the Assignment Record
            Database.SaveResult result = Database.insert(assignment, false);
            
            //Assert: Validation rule error is expected
            System.assertEquals(false, result.isSuccess(), 'Failed to throw OTC Queue or User required validation message');
            
            //Arrange: Add OTC User
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with OTC User
            result = Database.insert(assignment, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when OTC User is available');
            
            //Arrange: Add OTC Queue
            Schema.DescribeFieldResult fieldResult = CQ_SL_SQX_Assignment__c.CQ_SL_Plant_Code__c.getDescribe();
            assignment1.CQ_SL_Plant_Code__c = fieldResult.getPicklistValues()[1].getValue();
            assignment1.CQ_SL_Choose_OTC_User_By_Default__c = true;
            assignment1.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment1.CQ_SL_OTC_Queue__c ='CLXL Logistics';
            assignment1.CQ_SL_SQX_CA_User__c = stdUser.Id; 
            assignment1.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with OTC Queue
            result = Database.insert(assignment1, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when OTC Queue is available');
        }
    }
    
    /**
     * @description method to check Assignment record for Planning user and Queue
     * GIVEN: Assignment Record 
     * WHEN: Assignment is created without Queue And user of CA
     * THEN: Validation error is occur.
     * @Story: [SL-6]
     */
    @IsTest
    public static void givenAssignmentWithoutPlanningQueueOrUser_WhenSaveRecord_ThenThrowValidationMessage() {
        
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser) {
            
            //Arrange: Retrieve a Queue
            Group queue1 = [SELECT Id FROM Group WHERE name = 'CLXL Logistics'];
            
            //Arrange: Create an invalid Assignment record using the factory
            CQ_SL_SQX_Assignment__c assignment = CQ_SL_Test_Assignment_CS.createAssignment(true);
            CQ_SL_SQX_Assignment__c assignment1 = CQ_SL_Test_Assignment_CS.createAssignment(true);
            
            //Act: Save the Assignment Record
            Database.SaveResult result = Database.insert(assignment, false);
            
            //Assert: Validation rule error is expected
            System.assertEquals(false, result.isSuccess(), 'Failed to throw CA Queue or User required validation message');
            
            //Arrange: Add CA User
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with Planning User
            result = Database.insert(assignment, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when Planning User is available');
            
            //Arrange: Add Planning Queue
            Schema.DescribeFieldResult fieldResult = CQ_SL_SQX_Assignment__c.CQ_SL_Plant_Code__c.getDescribe();
            assignment1.CQ_SL_Plant_Code__c = fieldResult.getPicklistValues()[1].getValue();
            assignment1.CQ_SL_Choose_Planning_User_By_Default__c = true;
            assignment1.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment1.CQ_SL_Planning_Queue__c = 'CLXL Logistics';
            assignment1.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with Planning Queue
            result = Database.insert(assignment1, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when Planning Queue is available');
        }
    }
    
    /**
     * @description method to check Assignment record for STP-Procurumrnt user and Queue
     * GIVEN: Assignment Record 
     * WHEN: Assignment is created without Queue And user of STP-Procurument
     * THEN: Validation error is occur.
     * @Story: [SL-6]
     */
    @IsTest
    public static void givenAssignmentWithoutSTPProcurmentQueueOrUser_WhenSaveRecord_ThenThrowValidationMessage() {
        
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser) {
            
            //Arrange: Retrieve a Queue
            Group queue1 = [SELECT Id FROM Group WHERE name = 'CLXL Logistics'];
            
            //Arrange: Create an invalid Assignment record using the factory
            CQ_SL_SQX_Assignment__c assignment = CQ_SL_Test_Assignment_CS.createAssignment(true);
            CQ_SL_SQX_Assignment__c assignment1 = CQ_SL_Test_Assignment_CS.createAssignment(true);
            
            //Act: Save the Assignment Record
            Database.SaveResult result = Database.insert(assignment, false);
            
            //Assert: Validation rule error is expected
            System.assertEquals(false, result.isSuccess(), 'Failed to throw CA Queue or User required validation message');
            
            //Arrange: Add CA User
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with STP-Procurument User
            result = Database.insert(assignment, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when CA User is available');
            
            //Arrange: Add STP-Procurumrnt Queue
            Schema.DescribeFieldResult fieldResult = CQ_SL_SQX_Assignment__c.CQ_SL_Plant_Code__c.getDescribe();
            assignment1.CQ_SL_Plant_Code__c = fieldResult.getPicklistValues()[1].getValue();
            assignment1.CQ_SL_Choose_STP_Pro_User_By_Default__c = true;
            assignment1.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment1.CQ_SL_STP_Procurement_Queue__c = 'CLXL Logistics';
            assignment1.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_CA_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with STP-Procurumrnt Queue
            result = Database.insert(assignment1, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when STP-Procurument Queue is available');
        }
    }
    
    /**
     * @description method to check Assignment record for Logistics user and Queue 
     * GIVEN: Assignment Record 
     * WHEN: Assignment is created without Queue And user of Logistics
     * THEN: Validation error is occur.
     * @Story: [SL-6]
     */
    @IsTest
    public static void givenAssignmentWithoutLogisticsQueueOrUser_WhenSaveRecord_ThenThrowValidationMessage() {
        
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser) {
            
            //Arrange: Retrieve a Queue
            Group queue1 = [SELECT Id FROM Group WHERE name = 'CLXL Logistics'];
            
            //Arrange: Create an invalid Assignment record using the factory
            CQ_SL_SQX_Assignment__c assignment = CQ_SL_Test_Assignment_CS.createAssignment(true);
            CQ_SL_SQX_Assignment__c assignment1 = CQ_SL_Test_Assignment_CS.createAssignment(true);
            
            //Act: Save the Assignment Record
            Database.SaveResult result = Database.insert(assignment, false);
            
            //Assert: Validation rule error is expected
            System.assertEquals(false, result.isSuccess(), 'Failed to throw CA Queue or User required validation message');
            
            //Arrange: Add CA User
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with Logistics User
            result = Database.insert(assignment, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when Logistics User is available');
            
            //Arrange: Add Logistics Queue
            Schema.DescribeFieldResult fieldResult = CQ_SL_SQX_Assignment__c.CQ_SL_Plant_Code__c.getDescribe();
            assignment1.CQ_SL_Plant_Code__c = fieldResult.getPicklistValues()[1].getValue();
            assignment1.CQ_SL_Choose_Logisics_User_By_Default__c = true;
            assignment1.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment1.CQ_SL_Logisics_Queue__c	 = 'CLXL Logistics';
            assignment1.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with Logistics Queue
            result = Database.insert(assignment1, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when Logistics Queue is available');
        }
    }
    
    /**
     * @description method to check Assignment record for Manufacturing user and Queue
     * GIVEN: Assignment Record 
     * WHEN: Assignment is created without Queue And user of Manufacturing
     * THEN: Validation error is occur.
     * @Story: [SL-6]
     */
    @isTest
    public static void givenAssignmentWithoutManufacturingQueueOrUser_WhenSaveRecord_ThenThrowValidationMessage() {
        
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser) {
            
            //Arrange: Retrieve a Queue
            Group queue1 = [SELECT Id FROM Group WHERE name = 'CLXL Logistics'];
            
            //Arrange: Create an invalid Assignment record using the factory
            CQ_SL_SQX_Assignment__c assignment = CQ_SL_Test_Assignment_CS.createAssignment(true);
            CQ_SL_SQX_Assignment__c assignment1 = CQ_SL_Test_Assignment_CS.createAssignment(true);
            
            //Act: Save the Assignment Record
            Database.SaveResult result = Database.insert(assignment, false);
            
            //Assert: Validation rule error is expected
            System.assertEquals(false, result.isSuccess(), 'Failed to throw Manufacturing Queue or User required validation message');
            
            //Arrange: Add Manufacturing User
            assignment.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with Manufacturing User
            result = Database.insert(assignment, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when CA User is available');
            
            //Arrange: Add CA Queue
            Schema.DescribeFieldResult fieldResult = CQ_SL_SQX_Assignment__c.CQ_SL_Plant_Code__c.getDescribe();
            assignment1.CQ_SL_Plant_Code__c = fieldResult.getPicklistValues()[1].getValue();
            assignment1.CQ_SL_Choose_Manufact_User_By_Default__c = true;
            assignment1.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment1.CQ_SL_Manufacturing_Queue__c = 'CLXL Logistics';
            assignment1.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Save the Assignment Record with Manufacturing Queue
            result = Database.insert(assignment1, false);
            
            //Assert: Validation rule should be skipped and allowed to create a record
            System.assertEquals(true, result.isSuccess(), 'Failed to save the Assignment when Manufacturing Queue is available');
        }
    }
    
}