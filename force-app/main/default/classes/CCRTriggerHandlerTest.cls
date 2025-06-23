@isTest
private class CCRTriggerHandlerTest {
    
    @isTest
    Private static void customerRequest(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(True, Acc.Id);
        Customer_Creation_Request__c result = [Select id,Account__c, Region__c, Request_Type__c from Customer_Creation_Request__c where id =: ccr.Id];
        System.assertEquals(Acc.Id, result.Account__c);
    }
    
    @isTest
    Private static void customerRequest01(){
        Account Acc= TestDataFactory.createAccount(false);
        Acc.Type = 'Customer';
        Insert Acc;
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(True, Acc.Id);
        
        Customer_Creation_Request__c result = [Select id,Account__c, Region__c, Request_Type__c from Customer_Creation_Request__c where id =: ccr.Id];
        System.assertEquals(Acc.Id, result.Account__c);
    }
    
    @isTest
    Private static void customerRequest02(){
        List<Customer_Creation_Request__c> cReq = new List<Customer_Creation_Request__c>();
        User user= TestDataFactory.createUser(True, 'solenis@test.com', 'empId');
        Account Acc= TestDataFactory.createAccount(false);
        Acc.Type = 'Customer';
        Acc.SAP_Partner_Functions__c = 'Sold To,Bill To,Payer,Ship To';
        Insert Acc;
        ValueAdvantage_Approver_List__c vapSet = new ValueAdvantage_Approver_List__c();
        vapSet.Name = 'PP06-P27';
        vapSet.Active_Group_Manager__c = True;
        vapSet.SAP_Sales_District__c = 'IWLA1';
        vapSet.SAP_Sales_Office__c = 'IW82';
        vapSet.SAP_Sales_Group__c = '83I';
        vapSet.Group_Manager_User_Id__c = user.Id;
        vapSet.DOGId__c = 'IWLA1IW8283I';
        vapSet.CR_Approve_Level__c = 'AM';
        insert vapSet;
        
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(false, Acc.Id);
        ccr.Region__c = 'NA';
        ccr.Change_Request__c=True;
        ccr.Company_Legal_Name__c = 'Test';
        ccr.Account__c = Acc.Id;
        ccr.Name_2__c = 'Test';
        ccr.Name_3__c = 'Test3';
        ccr.CCR_Sales_District__c = 'RSD  IWT LA BRAZIL	 (IWLA1)';
        ccr.CCR_Sales_Office__c = 'DM IWT LA BR II (IW82)';
        ccr.Sales_Group__c = 'AM IWT LA BR II 2 (83I)';
        ccr.Incoterms__c = 'CFR - Cost and Freight';
        ccr.HQAccount__c=Acc.Id;
        ccr.Account_Owner__c=user.Id;
        ccr.BillingStreet__c='Test';
        ccr.City__c = 'Test';
        ccr.Postal_Code__c='3000';
        ccr.ChangeReqCredit__c=True;
        ccr.ChangeReqPricing__c=True;
        ccr.changeReqCusGroup__c=True;
        Insert ccr;
        cReq.add(ccr);
        CustomerCreationRequestTriggerHandler.updateChangeRequestApprover(cReq);
        Customer_Creation_Request__c result = [Select id,Account__c, Region__c, Request_Type__c from Customer_Creation_Request__c where id =: ccr.Id];
        System.assertEquals(Acc.Id, result.Account__c);  
    } 
    
    @isTest
    Private static void customerRequest03(){
        User user= TestDataFactory.createUser(True, 'solenis@test.com', 'empId');
        Account Acc= TestDataFactory.createAccount(false);
        Acc.Type = 'Customer';
        Insert Acc;               
        SAP_Contact__c sapCont = TestDataFactory.createSAPContact(True, Acc.Id);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(false, Acc.Id);
        ccr.Region__c = 'NA';
        ccr.ChangeReqSAPContact__c = True;
        ccr.SAP_Contact__c = sapCont.Id;
        ccr.First_Name__c = 'solenis01';
        ccr.Last_Name__c = 'solenis02';
        ccr.SAP_Email__c = 'solenis@test.com';
        ccr.SAP_Title__c = 'TestContact';
        ccr.SAP_Fax__c = '12345';
        ccr.SAP_Phone__c = '1234567843';
        //ccr.Account__c = Acc.Id;
        ccr.SAP_Customer_Number__c = '12345';
        ccr.SAP_ContactNumber__c = '12345';
        ccr.SAP_Contact_Person_FunctionCode__c = '12345';
        Insert ccr;
        
        Customer_Creation_Request__c result = [Select id,Account__c, Region__c, Request_Type__c from Customer_Creation_Request__c where id =: ccr.Id];
        System.assertEquals(Acc.Id, result.Account__c);
    }
    
    @isTest
    Private static void customerRequest04(){
        List<Customer_Creation_Request__c> cReq = new List<Customer_Creation_Request__c>();
        User user= TestDataFactory.createUser(True, 'solenis@test.com', 'empId');
        Account Acc= TestDataFactory.createAccount(false);
        Acc.Type = 'Customer';
        Acc.SAP_Partner_Functions__c = 'Sold To,Bill To,Payer,Ship To';
        Insert Acc;
        ValueAdvantage_Approver_List__c vapSet = new ValueAdvantage_Approver_List__c();
        vapSet.Name = 'IW02-I22';
        vapSet.Active_Office_Manager__c = True;
        vapSet.SAP_Sales_District__c = 'IWEU2';
        vapSet.SAP_Sales_Office__c = 'IW02';
        vapSet.SAP_Sales_Group__c = 'I22';
        vapSet.Office_Manager_User_Id__c = user.Id;
        vapSet.DOGId__c = 'IWEU2IW02I22';
        vapSet.CR_Approve_Level__c = 'DM';
        insert vapSet;
        
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(false, Acc.Id);
        ccr.Region__c = 'NA';
        ccr.Change_Request__c=True;
        ccr.Company_Legal_Name__c = 'Test';
        ccr.Account__c = Acc.Id;
        ccr.Name_2__c = 'Test';
        ccr.Name_3__c = 'Test3';
        ccr.CCR_Sales_District__c = 'RSD IWT EMEA NORTH (IWEU2)';
        ccr.CCR_Sales_Office__c = 'IWT EMEA DACH EUROPE (IW02)';
        ccr.Sales_Group__c = 'IWT AUSTRIA & CH (I22)';
        ccr.Incoterms__c = 'CFR - Cost and Freight';
        ccr.HQAccount__c=Acc.Id;
        ccr.Account_Owner__c=user.Id;
        ccr.BillingStreet__c='Test';
        ccr.City__c = 'Test';
        ccr.Postal_Code__c='3000';
        ccr.ChangeReqCredit__c=True;
        ccr.ChangeReqPricing__c=True;
        ccr.changeReqCusGroup__c=True;
        Insert ccr;
        cReq.add(ccr);
        CustomerCreationRequestTriggerHandler.updateChangeRequestApprover(cReq);
        Customer_Creation_Request__c result = [Select id,Account__c, Region__c, Request_Type__c from Customer_Creation_Request__c where id =: ccr.Id];
        System.assertEquals(Acc.Id, result.Account__c);  
    }
 
 }