@isTest
public class FSL_ServiceAppointmentBatchClass_Test {
static testMethod void testMethod1(){
    
        FSL__Scheduling_Policy__c FSP = New FSL__Scheduling_Policy__c();
        FSP.Name='Solenis v1';        
        Insert FSP;
        
        operatingHours OH = New operatingHours();
            OH.Name='Base Calendar';
          Insert OH;
            
         FSL_SA_Scheduling_Policy__c FSSP = New FSL_SA_Scheduling_Policy__c();
             FSSP.Name='Solenis v1';
             FSSP.Policy_Id__c=FSP.id;
         Insert FSSP;   
         Account Acc = TestDataFactory.createAccount(false);
             Acc.SAP_Sales_Org__c ='0271';
             Insert Acc;
         Asset Ast = TestDataFactory.createAsset(True,Acc.Id);
         Workorder WOR = TestDataFactory.createWorkOrder(True,Ast.Id,Acc.Id);
         ServiceAppointment SA =TestDataFactory.createServiceAppointment(True,WOR.id);
         SA.Status = 'None';
         SA.Work_Time__c=30;
         SA.Travel_Time__c=30;
         SA.Pre_Post_Visit_Time__c=30;
         update SA;
        
        Test.startTest();
            FSL_ServiceAppointment_Batch obj = new FSL_ServiceAppointment_Batch();
            DataBase.executeBatch(obj,200);
        Test.stopTest();
    }
}