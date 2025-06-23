/*
 * @description - Common setup class for Assignment
 * *************************************** REVISION HISTORY******************************************
 * 1. [SL-23]: Plant Code Config
 * *************************************** REVISION HISTORY*******************************************/
@isTest
public class CQ_SL_Test_Assignment {
     /**
      * @description - Method to call Assignment, Complaint Factory class to create necessary record
      */
    @testSetup
    static void setupData(){
        Map<String,SObject> usersMap = new CQ_CCC_Test_Data_Factory(User.SObjectType).constructData('users-adminandstandard');
        User stdUser = (User)usersMap.get('Standard User 1');
        
        System.runAs(stdUser){
            new CQ_CCC_Test_Data_Factory(CQ_SL_SQX_Assignment__c.SObjectType).constructData('createAssign-Commit');
        }
    }
    
    /**
     * @description - Check the Plant Code is Unique while creating Assignment.
     * GIVEN - Plant Code.
     * WHEN - Plant Code is Already Used.
     * THEN - Throw Error.
     * @story[SL-23] - Plant Code Config
     * ApexClass : CQ_SL_Assignment
     * Method Name : checkPlantCodeShouldBeUnique()
     */
    @isTest
    public static void givenPlantCode_WhenPlantIsAlreadyUsed_ThenThrowError() {
        
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            
            String[] picklistOptions = CQ_SL_Test_Assignment_Factory.getPlantCodeList();
            
            //Arrange: Create a Assignment with Plant Code 40 .
            CQ_SL_SQX_Assignment__c assignment = new CQ_SL_SQX_Assignment__c();
            if(picklistOptions[0] != null) {
                assignment.CQ_SL_Plant_Code__c = picklistOptions[0];
            }
            
            //Act: Throw the Error that Plant Code 40 is Already in Use.
            Database.SaveResult result = Database.insert(assignment, false);
            
            //Assert: Check the Plant Code that is alreay in used.
            System.assertEquals(false, result.isSuccess(), 'Throw an Error Plant Code is Already in Use but not get errors');
            
            //Arrange: Create a Assignment with Plant Code .
            CQ_SL_SQX_Assignment__c assignmentRecord = new CQ_SL_SQX_Assignment__c();
            if(picklistOptions[1] != null) {
                assignmentRecord.CQ_SL_Plant_Code__c = picklistOptions[1];
            }
            assignmentRecord.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignmentRecord.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignmentRecord.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignmentRecord.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignmentRecord.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignmentRecord.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            
            //Act: Create the Assignment record with plant code
            Database.SaveResult createAssignment = Database.insert(assignmentRecord, false);
                        
            //Assert: Check the Assignemt is created with plant code.
            System.assertEquals(true, createAssignment.isSuccess(), 'Plant code is created with plant code ' + picklistOptions[1] + ' but not created');
        }
    }
}