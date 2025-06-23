@isTest
public class SolenisCChReadControllerTest {
    
    @isTest
    Private static void CChReadControllerTest(){
        User user= TestDataFactory.createUser(True, 'solenis@test.com', 'empId');
        Account Acc= TestDataFactory.createAccount(false);
        Acc.Type = 'Customer';
        Acc.SAP_Sales_Org__c = '0070';
        Insert Acc;
        SAP_Contact__c sapCont= TestDataFactory.createSAPContact(True, Acc.Id);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(false, Acc.Id);
        ccr.ChangeReqSAPContact__c=True;
        ccr.Account__c = Acc.Id;
        ccr.SAP_Contact__c=sapCont.Id;
        ccr.Account_Owner__c=user.Id;
        ccr.BillingStreet__c='Test';
        ccr.City__c = 'Test';
        ccr.Postal_Code__c='3000';
        Insert ccr;
        
        Test.startTest();
        SolenisCChReadController.getAccContact(ccr.Id);
        SolenisCChReadController.getAcc(ccr.Id);
        SolenisCChReadController.getCCR(ccr.Id);
        SolenisCChReadController.getDuplicate(ccr.Id);
        SolenisCChReadController.getDuplicateCon(ccr.Id);
        Test.stopTest();
        
        Customer_Creation_Request__c result = [Select id,Account__c, Region__c, Request_Type__c from Customer_Creation_Request__c where id =: ccr.Id];
        System.assertEquals(Acc.Id, result.Account__c);
    }

}