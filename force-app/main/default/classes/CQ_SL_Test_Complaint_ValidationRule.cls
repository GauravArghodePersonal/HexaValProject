/**********************************Revision History*****************************
 * @description This method related to Complaint Validation Rule check 
 * [SL-18] Request Sample Task Config
 * -----------------------------------------------------------------------------
 * [SL-48] Complaint Submit Screen Validation message
 * Validation Rule : CQ_SL_Evidences_Required
 * -----------------------------------------------------------------------------
 * [SL-65] Responsible Party and Lot configs
 * Validation Rule : CQ_SL_Required_Lot_and_Shipped_Quantity
 * Test Method Name : givenComplaint_WhenComplaintSubkmittedWithoutLotOrShippedQuantity_ThenThrowValidationMessage()
 *******************************************************************************/
@isTest
public class CQ_SL_Test_Complaint_ValidationRule {

    /**
     * @description Method to call Assignment, Complaint Factory class to create necessary record
     */
    @testSetup
    static void setupData(){
        Map<String,SObject> usersMap = new CQ_CCC_Test_Data_Factory(User.SObjectType).constructData('users-adminandstandard');
        User stdUser = (User)usersMap.get('Standard User 1');
        
        System.runAs(stdUser){
            //new CQ_CCC_Test_Data_Factory(Account.SObjectType).constructData('createAccount');
            new CQ_CCC_Test_Data_Factory(CQ_SL_SQX_Assignment__c.SObjectType).constructData('createAssign-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('createCom-OF-CA-Commit');
            new CQ_CCC_Test_Data_Factory(compliancequest__SQX_Complaint__c.SObjectType).constructData('BulkInsert');            
        }
    }
    
    /**
     * @description This method will test the .CQ_SL_Evidences_Required Complaint's Validation Rule.
     * GIVEN: Complaint record
     * WHEN: Complaint is Submitted
     * THEN: Throw Validation Message
     * 
     * Validation Rule : CQ_SL_Evidences_Required
     * @Story: [SL-48] Complaint Submit Screen Validation message
     */
    @isTest
    public static void givenComplaintRecord_WhenComplaintIsSubmitted_ThenThrowEvidencesRequiredValidationMessage(){
        User stdUser = [SELECT Id FROM User WHERE FirstName =: 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            
            //Arrange: Create Complaint record
            compliancequest__SQX_Complaint__c comRecord = [SELECT Id, compliancequest__Record_Stage__c,
                                                           CQ_SL_Have_you_atchd_all_the_req__c
                                                           FROM compliancequest__SQX_Complaint__c 
                                                           WHERE CQ_SL_Responsible_Department__c = 'CA'];
            
            //Act: Complaint is submitted
            comRecord.compliancequest__Record_Stage__c = 'Triage';
            comRecord.compliancequest__Activity_Code__c = 'submit';
            comRecord.CQ_SL_Have_you_atchd_all_the_req__c = 'No';
            comRecord.compliancequest__Occurrence_Date__c = Date.today();
            comRecord.compliancequest__Reported_Date__c = Date.today();
            
            Database.SaveResult result = Database.update(comRecord, false);
            
            //Assert: It will throw validation message
            System.assertEquals(false, result.isSuccess(), 'Failed to throw validation message - Please attach the required evidences in Notes and files section and submit the complaint!');

            //Act: Set Have you attached all the required evidences to 'Yes' & Submit Complaint
            comRecord.compliancequest__Record_Stage__c = 'Triage';
            comRecord.compliancequest__Activity_Code__c = 'submit';
            comRecord.CQ_SL_Have_you_atchd_all_the_req__c = 'Yes';
            comRecord.compliancequest__Occurrence_Date__c = Date.today();
            comRecord.compliancequest__Reported_Date__c = Date.today();
            result = Database.update(comRecord, false);               
            System.assertEquals(true, result.isSuccess(), 'Failed to update the Comapliaint stage to Triage.');            
        }
    }
    
    /**
     * @description This method will test the CQ_SL_Required_Lot_and_Shipped_Quantity Complaint's Validation Rule.
     * GIVEN: Complaint record
     * WHEN : Complaint is Submitted and either lot or Shipped Quantity is blank
     * THEN : Throw Validation Message
     * 
     * Validation Rule : CQ_SL_Required_Lot_and_Shipped_Quantity
     * @Story: [SL-65] Responsible Party and Lot configs
     */
    @isTest
    public static void givenComplaint_WhenComplaintSubkmittedWithoutLotOrShippedQuantity_ThenThrowValidationMessage(){
        User stdUser = [SELECT Id FROM User WHERE FirstName = 'Standard User 1' LIMIT 1];
        
        System.runAs(stdUser){
            
            //Arrange: Create Complaint record
            compliancequest__SQX_Complaint__c comRecord = [SELECT Id, compliancequest__Record_Stage__c,
                                                           CQ_SL_Have_you_atchd_all_the_req__c
                                                           FROM compliancequest__SQX_Complaint__c 
                                                           WHERE CQ_SL_Responsible_Department__c = 'CA'];
            
            //Act: Complaint is submitted
            comRecord.compliancequest__Record_Stage__c = 'Triage';
            comRecord.compliancequest__Activity_Code__c = 'submit';
            comRecord.compliancequest__Occurrence_Date__c = System.today();
            comRecord.CQ_SL_Complaint_Type__c  = 'Customer Complaint w/ Supplier Involvement';
            Database.SaveResult result = Database.update(comRecord, false);
            
            //Assert: It will throw validation message
            System.assertEquals(false, result.isSuccess(), 'Failed to throw validation message where user missed to enter lot/shipped quantity before submit.');
            
            //Act: Set Lot/ Shipped Quantity
            comRecord.CQ_SL_Lot__c = '123456';
            comRecord.CQ_SL_Shipped_Quantity__c = 20;
            result = Database.update(comRecord, false);
            
            //Assert: It will allowed to submit the Complaint
            System.assertEquals(true, result.isSuccess(), 'Failed to submit the Complaint when it have lot/shipped quantity.');
        }
    }
}