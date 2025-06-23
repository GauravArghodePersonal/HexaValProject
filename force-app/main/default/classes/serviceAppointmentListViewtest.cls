@isTest
private class serviceAppointmentListViewtest {
static testMethod void create_SA(){
       
       Account Acc = TestDataFactory.createAccount(false);
             Acc.SAP_Sales_Org__c ='0271';
             Insert Acc;
       Asset Ast = TestDataFactory.createAsset(True,Acc.Id);         
       Workorder WOR = TestDataFactory.createWorkOrder(True,Ast.Id,Acc.Id);
       TestDataFactory.createServiceAppointment(true,WOR.Id);
       serviceAppointmentListView.getSA(WOR.Id);
    }
}