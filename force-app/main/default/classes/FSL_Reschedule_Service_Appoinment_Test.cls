@isTest 
public class FSL_Reschedule_Service_Appoinment_Test{
    static testMethod void testMethod1(){
         
         Account Acc = TestDataFactory.createAccount(false);
             Acc.SAP_Sales_Org__c ='0271';
             Insert Acc;
         Asset Ast = TestDataFactory.createAsset(True,Acc.Id);         
         Workorder WOR = TestDataFactory.createWorkOrder(True,Ast.Id,Acc.Id);
         
         FSL_Workplan__c WP = New FSL_Workplan__c();
        Test.startTest();

            FSL_Reschedule_Service_Appoinment obj = new FSL_Reschedule_Service_Appoinment ();
            DataBase.executeBatch(obj,200); 
            
        Test.stopTest();
    }
    
   /* static testMethod void testMethod2(){
         
         Account Acc = TestDataFactory.createAccount(false);
             Acc.SAP_Sales_Org__c ='0271';
             Insert Acc;
         Asset Ast = TestDataFactory.createAsset(True,Acc.Id);
         Workorder WOR = TestDataFactory.createWorkOrder(false,Ast.Id,Acc.Id);
         FSL_Workplan__c WP = New FSL_Workplan__c();
         WP.Name='Test WorkPlan';
         Insert WP;
         
         WOR.recordtypeid=Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('TankWorkOrder').getRecordTypeId();
          WOR.FSL_Workplan__c=WP.id;
          WOR.Product_Class__c='1';
        insert WOR;
        update WOR;
        
        System.debug('<<<>>>'+WOR.TankFrequency__c);
        WorkOrderTriggerHandler.CreateWorkOrder(WOR,'tankFrequency');
        
        Test.startTest();

            FSL_Reschedule_Service_Appoinment obj = new FSL_Reschedule_Service_Appoinment ();
            DataBase.executeBatch(obj,200); 
            
        Test.stopTest();
        //WorkOrderTriggerHandler WOT = New WorkOrderTriggerHandler();
        
    }
    
    static testMethod void testMethod3(){
         
         Account Acc = TestDataFactory.createAccount(false);
             Acc.SAP_Sales_Org__c ='0271';
             Insert Acc;
         Asset Ast = TestDataFactory.createAsset(True,Acc.Id);
         Workorder WOR = TestDataFactory.createWorkOrder(false,Ast.Id,Acc.Id);
         WOR.recordtypeid=Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EMEA_Tank_WorkOrder').getRecordTypeId();
         WOR.Product_Class__c='2';   
        insert WOR;
        update WOR;
        Test.startTest();

            FSL_Reschedule_Service_Appoinment obj = new FSL_Reschedule_Service_Appoinment ();
            DataBase.executeBatch(obj,200); 
            
        Test.stopTest();
    }
    
    static testMethod void testMethod4(){
         
         Account Acc = TestDataFactory.createAccount(false);
             Acc.SAP_Sales_Org__c ='0271';
             Insert Acc;
         Asset Ast = TestDataFactory.createAsset(True,Acc.Id);
         Workorder WOR = TestDataFactory.createWorkOrder(false,Ast.Id,Acc.Id);
         //WOR.recordtypeid=Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByDeveloperName().get('EMEA_Work_Order_Tank_Line_Item').getRecordTypeId();
        insert WOR;
        update WOR;
        Test.startTest();

            FSL_Reschedule_Service_Appoinment obj = new FSL_Reschedule_Service_Appoinment ();
            DataBase.executeBatch(obj,200); 
            
        Test.stopTest();
    }*/
}