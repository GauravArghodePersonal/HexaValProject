@isTest
private class ExportToExcelDemoControllerTest {
    
    @isTest
    Private static void demoControllerTest01(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'NA';
        ccr.Request_Type__c = 'SOLD TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest02(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'EMEA';
        ccr.Request_Type__c = 'SOLD TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest03(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'NA';
        ccr.Request_Type__c = 'SHIP TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest04(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'EMEA';
        ccr.Request_Type__c = 'SHIP TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest05(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'NA';
        ccr.Request_Type__c = 'Bill TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest06(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'EMEA';
        ccr.Request_Type__c = 'Bill TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest07(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'NA';
        ccr.Request_Type__c = 'PAYER TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest08(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'EMEA';
        ccr.Request_Type__c = 'PAYER TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest09(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'NA';
        ccr.Request_Type__c = 'DIV NODE OR HIERARCHY CODE';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest10(){
        Account Acc= TestDataFactory.createAccountCus(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'EMEA';
        ccr.Request_Type__c = 'DIV NODE OR HIERARCHY CODE';
        Insert ccr;
        ccr.Purchasing_Contact_Name__c='123';
        update ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest11(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'NA';
        ccr.Request_Type__c = 'SELLER CSR DZ CSR ZADD';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    
    @isTest
    Private static void demoControllerTest12(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'EMEA';
        ccr.Request_Type__c = 'SELLER CSR DZ CSR ZADD';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest13(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'LA';
        ccr.Request_Type__c = 'SOLD TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest14(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'AP';
        ccr.Request_Type__c = 'SOLD TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest15(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'LA';
        ccr.Request_Type__c = 'PAYER TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest16(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'AP';
        ccr.Request_Type__c = 'PAYER TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest17(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'LA';
        ccr.Request_Type__c = 'Bill TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest18(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'AP';
        ccr.Request_Type__c = 'Bill TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest19(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'LA';
        ccr.Request_Type__c = 'SHIP TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest20(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'AP';
        ccr.Request_Type__c = 'SHIP TO';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest21(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'LA';
        ccr.Request_Type__c = 'DIV NODE OR HIERARCHY CODE';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }
    @isTest
    Private static void demoControllerTest22(){
        Account Acc= TestDataFactory.createAccount(True);
        Customer_Creation_Request__c ccr= TestDataFactory.createCCR(False, Acc.Id);
        ccr.Shipping_BOL_Contact__c = 'Test';
        ccr.Purchasing_Contact_Name__c = 'Test';
        ccr.Billing_Credit_Contact_Name__c = 'Test';
        ccr.QM_QA_COA_Contact_Name__c = 'Test';
        ccr.Contacts_MSDS_Contact_Name__c = 'Test';
        ccr.Region__c = 'AP';
        ccr.Request_Type__c = 'DIV NODE OR HIERARCHY CODE';
        Insert ccr;
        
        test.starttest();
        ExportToExcelDemoController exportExcel = new ExportToExcelDemoController();
        ExportToExcelDemoController.getContacts(ccr.Id);
        test.StopTest();
    }

}