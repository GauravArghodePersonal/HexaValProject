@isTest
public class OpportunityCaseCreationControllerTest {

    @TestSetup
    static void createTestData() {
        User user= TestDataFactory.createUser(false, 'solenis@test.com', 'empId');
        user.SAP_Cust_Num__c = '0000208802222';
        insert user;
        
        User user1= TestDataFactory.createUser(false, 'solenis12@test.com', 'empId1');
        user1.SAP_Cust_Num__c = '0000208802456';
        user1.profileId = [Select Id from Profile WHERE Profile.Name LIKE 'System Administrator'].Id;
        insert user1;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Solenis_ASR_Access'];
        insert new PermissionSetAssignment(AssigneeId = user1.id, PermissionSetId = ps.Id);
            
        
        
        /*Opportunity Opp = TestDataFactory.createOpportunity(true,accountLst[0].Id);
        Opportunity_Material__c oppMat = TestDataFactory.createOpportunityMaterial(true,opp.id);Opp.StageName='Won';
        Opp.SBU_Multi__c='Defoamers';               
        Opp.ByPassValidation_Rule__c=True;
        Test.startTest();
        update Opp;*/
        
    }
    
    @isTest
    static void testCaseAccess(){
        User userObj = [Select Id from User WHERE Username LIKE 'solenis@test.com'];
        Test.startTest();
        System.runAs(userObj){
            String resp1 = OpportunityCaseCreationController.isUserHasPermission('');
            System.assert(resp1.equalsIgnoreCase('Only Application support team has access to create application support case. You do not have the permission to create an application support case'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testCaseAccess2(){
        User userObj = [Select Id from User WHERE Username LIKE 'solenis12@test.com'];
        
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Drew Customer').getRecordTypeId();
        
        Account regularAccount = TestDataFactory.createAccount(false);
        regularAccount.Name = 'Account123';
        regularAccount.ownerId = userObj.id;
        regularAccount.RecordTypeId = accountRecordTypeId;
        regularAccount.AccountNumber = '19876';
        regularAccount.SAP_Sales_Org__c = '1020';
        regularAccount.Enable_As_Buyer_Account__c = true;
        regularAccount.SAP_Attribute1_Desc__c ='abc';
        regularAccount.SAP_DivisionCode__c = '10';
        regularAccount.SAP_DistChannel__c = '10';
        regularAccount.SAP_Customer_Number__c = '35462379';
        regularAccount.ParentId = null;

        List<Account> accountLst = new List<Account>{regularAccount};
        insert accountLst;
        
        Trigger__c Tr = New Trigger__c();
        Tr.Name='SentEmailToAcc';    
        Tr.Run__c=True;
        Tr.Trigger_Name__c='opportunityTriggerhandler';
        Insert Tr;
        
        List<Opportunity> opportunityLst = new List<Opportunity>{TestDataFactory.createOpportunity(false, accountLst[0].Id)};
        insert opportunityLst;
        
        Test.startTest();
        System.runAs(userObj){
            String resp2 = OpportunityCaseCreationController.isUserHasPermission(opportunityLst[0].Id);
            System.assert(resp2.equalsIgnoreCase('Success'));
        }
        Test.stopTest();
        
    }
}