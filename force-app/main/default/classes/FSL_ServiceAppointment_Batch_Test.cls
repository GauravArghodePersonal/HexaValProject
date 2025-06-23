@isTest
public class FSL_ServiceAppointment_Batch_Test{
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
         SA.Status = null;
         SA.Work_Time__c=30;
         SA.Travel_Time__c=30;
         SA.Pre_Post_Visit_Time__c=30;
         update SA;
         Workorder w1 = WOR.clone(false,false,false,false);
         Workorder w2 = WOR.clone(false,false,false,false);
         Workorder w3 = WOR.clone(false,false,false,false); 
        Test.startTest();
           FSL_ServiceAppointment_Batch obj = new FSL_ServiceAppointment_Batch();
            DataBase.executeBatch(obj,200);
           
            FSL_ReSchedule_S_Appoinment_Scheduler ups = New FSL_ReSchedule_S_Appoinment_Scheduler();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test Territory Check', sch, ups);
            List<Workorder> lstWo = new List<Workorder>();
            
            w1.recordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('TankWorkOrder').getRecordTypeId();
            w1.Product_Class__c = '1';
            w3.recordtypeId  = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EMEA_Tank_WorkOrder').getRecordTypeId();
            w3.Product_Class__c = '1';
            w2.recordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('ESR_W_O_Generox').getRecordTypeId();
            w2.Frequency__c = '1';
            lstWo.add(w1);
            lstWo.add(w2);
            lstWo.add(w3);
            insert lstWo;
            lstWo.clear();
            w1.Status = 'Completed';
            w2.Status = 'Completed';
            w3.Status = 'Completed';
            lstWo.add(w1);
            lstWo.add(w2);
            lstWo.add(w3);
            update lstWo;
            FSL.GlobalAPIS.addStatusTransition('None', 'Completed');
            //SA.Status = 'Completed';
            update SA;
            List<Integer> values = new List<Integer>();
            FSL_time_calculation.calculate(30,30,30);
             ApexPages.StandardController sc = new ApexPages.StandardController(Ast);
                FSLMapController fslController = new FSLMapController(sc);//Instantiate the Class
        Test.stopTest();
    }
}