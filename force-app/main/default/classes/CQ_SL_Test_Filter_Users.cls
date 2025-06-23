/**
 * *********************** Revision History ***************************
 * @description
 * [SL-20]:Create Related List Evaluator in Assignment Object and Evaluator config in Complaints object
 * *********************** Revision History ***************************
 */
@isTest
public class CQ_SL_Test_Filter_Users {
    
    /**
     * @description Method to call Assignment, Complaint Factory class to create necessary record
     */
    @testSetup
    static void setupData(){
        Map<String,SObject> usersMap = new CQ_CCC_Test_Data_Factory(User.SObjectType).constructData('users-adminandstandard');
        User stdUser = (User)usersMap.get('Standard User 1');
        //User adminUser = (User)usersMap.get('Admin User 1');
        
        System.runAs(stdUser){
            new CQ_CCC_Test_Data_Factory(CQ_SL_SQX_Assignment__c.SObjectType).constructData('createAssign-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-OF-CA-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('BulkInsert');
            new CQ_CCC_Test_Data_Factory(CQ_SL_SQX_Assignment_Evaluator__c.SObjectType).constructData('createEvaluator');
        }
    }
    
    @isTest
    public static void givenComplaintRecord_WhenPlantCodeisSelectedintheComplaintRecord_ThenEvaluatorUsershouldbefiltered(){
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];  
       
        System.runAs(stdUser){
            
            //Arrange: Get Assignment Record
            CQ_SL_SQX_Assignment__c assignment = [SELECT Id,CQ_SL_Plant_Code__c FROM CQ_SL_SQX_Assignment__c LIMIT 1];
            
            CQ_SL_SQX_Assignment_Evaluator__c assEvaluator = [SELECT Id,CQ_SL_SQX_User__c,
                                                              CQ_SL_SQX_Assignment__c
                                                              FROM CQ_SL_SQX_Assignment_Evaluator__c LIMIT 1];
            
            //Arrange: Create Assignement Record with Plant Code = 40
            CQ_SL_SQX_Assignment__c assignment1 = new CQ_SL_SQX_Assignment__c();
            assignment1.CQ_SL_Plant_Code__c = '40';
            assignment1.CQ_SL_Choose_CA_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Logisics_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Manufact_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_OTC_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_Planning_User_By_Default__c = false;
            assignment1.CQ_SL_Choose_STP_Pro_User_By_Default__c = false;
            assignment1.CQ_SL_SQX_CA_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Logistics_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Manufacturing_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_OTC_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_Panning_User__c = stdUser.Id;
            assignment1.CQ_SL_SQX_STP_Procurement_User__c = stdUser.Id;
            assignment1.CQ_SL_Region__c ='Region 1';
            insert assignment1;
            
            //Arrange: Related Assignment Evaluator
            CQ_SL_SQX_Assignment_Evaluator__c assignEva = new CQ_SL_SQX_Assignment_Evaluator__c(
                CQ_SL_SQX_User__c = stdUser.Id,
                CQ_SL_SQX_Assignment__c = assignment1.Id
            );
            insert assignEva;
            
            //Arrange:
            compliancequest__SQX_Complaint__c comRecord = [SELECT Id,CQ_SL_Responsible_Department__c,
                                                           CQ_SL_PlantCode__c,CQ_SL_Category__c,
                                                           compliancequest__Record_Stage__c 
                                                           FROM compliancequest__SQX_Complaint__c LIMIT 1];
            comRecord.CQ_SL_PlantCode__c = '40';
            update comRecord;
            
            //Arrange: Get Assignment Record
            CQ_SL_SQX_Evaluator__c evaluator = new CQ_SL_SQX_Evaluator__c();
            evaluator.CQ_SL_Plant_Code__c = comRecord.CQ_SL_PlantCode__c;
            
            Map<String,Object> listSearch = evaluator.getPopulatedFieldsAsMap();
            List<SObject> listOfUser = CQUI_SL_Filter_Users.getRecords(listSearch, '');
        
            //Assert: Return Product must be 1
            System.assertEquals(1, listOfUser.size(),'Test Got Failed');
        }
    }
}