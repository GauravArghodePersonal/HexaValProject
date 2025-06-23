@isTest(seeAllData = true)
public class WorkOrderTriggerHandler_Test {
    static testMethod void dataCreation() { 
        Test.StartTest();
        //Account a = new Account();
        //a = TestDataFactory.createAccount(true);
        Asset Ast= New Asset();
        Ast = [Select id,AccountId from Asset limit 1];
        //Ast = TestDataFactory.createAsset(true,a.Id);
        WorkOrder Wor= New WorkOrder();
        WorkOrder Wor2= New WorkOrder();
        //Wor = TestDataFactory.createWorkOrder(true,Ast.Id,Ast.AccountId);
            Wor = [select id from workorder where recordtype.developerName = 'TankWorkOrder' AND Product_Class__c !=NULL AND status != 'Completed' AND OwnerId != '00G50000001suBj' limit 1];
            Wor2 = [select id, Frequency__c from workorder where recordtype.developerName = 'EMEA_Tank_WorkOrder' AND status != 'Completed' AND OwnerId != '00G50000001suBj' limit 1];
        Test.StopTest();
        Wor.Status = 'completed';
        Wor2.Frequency__c = '1';
        Wor2.Status = 'completed';
        //Wor.Product_Class__c = '1';
        //Wor.Frequency__c = '1';
        List<WorkOrder> wol = new List<WorkOrder>();
        wol.add(Wor);
        wol.add(Wor2);
        update wol;
    }
    
    }