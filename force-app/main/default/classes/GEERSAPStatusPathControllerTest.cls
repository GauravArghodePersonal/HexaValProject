@isTest
private class GEERSAPStatusPathControllerTest { 
    
    @TestSetup
    static void makeData(){
        Profile pr = [SELECT Id FROM Profile WHERE Name = 'Solenis Commercial EMEA PP' LIMIT 1];
        User user= TestDataFactory.createUser(false, 'solenistest' + Integer.valueof((Math.random() * 10)) + '@test.com', 'empId');
        user.ProfileId = pr.Id;
        Insert user;

        Id geerPermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'EMEA_EquipmentAsset_Admin' LIMIT 1].Id;
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = geerPermissionSetId, AssigneeId = user.Id);
        insert psa; 

        System.runAs(user) {
            Account acc = TestDataFactory.createAccount(false);
            acc.ParentId = null;
            Insert acc;

            Geer__c gr = new Geer__c();
            gr.Fiscal_Year__c='2023';
            gr.Ship_To__c = acc.id;
            gr.Project_type1__c = 'Growth';
            gr.Prepared_By__c = '';
            gr.Budget_Number__c = '';
            gr.Origination_Type__c = '0';
            gr.Local_Currency_Total_Amount__c = 12;
            gr.Exchange_Rate__c = 11;
            gr.GEER_Description__c = 'Test';
            gr.State__c = 'Morethanten';
            gr.Target_Mechanical_Completion_In_Months__c = 5;
            gr.Cost_Center__c = '';
            gr.Approval_Routing_Priority__c = 'Normal';
            gr.Project_Manager_Emp_Num__c = '';
            gr.Asset_Type__c ='Machinery and Equipment(6)';
            gr.Usage_Code__c = 'Sales Support(9)';
            gr.SFDC_Link_GEER__c = '';
            gr.Market_Vertical__c = 'Pulp(11)';
            gr.Equipment_Category__c = 'Polymer - Dry(54)';
            gr.Sales_Rep_Name__c = '';
            gr.SBU__c = 'Polymer - RDC(8)';
            gr.Est_Revenue_Generated__c = 2;
            gr.Est_Gross_Profit_Generated__c = 2;
            gr.Payback_in_Months__c = 4;
            gr.Justification__c = 'Trial for new business';
            insert gr;  

            Asset ast =  TestDataFactory.createAsset(false,acc.id);
            ast.GEER__c = gr.Id;
            Insert ast;
            
            Equipment_Order_Line_Item__c eoli = new Equipment_Order_Line_Item__c();
            eoli.Description__c = 'Test';
            eoli.Quantity__c = '5';
            eoli.Vendor__c = 'A&F (103897)';
            eoli.Date_Required__c = system.today()+1;
            eoli.Equipment__c = ast.id;
            eoli.Not_in_EU_Schengen_Country__c = true;
            insert eoli;
        }
    }

    @isTest
    static void getGEERWrapperTest() {
        String geerId = [SELECT Id FROM GEER__c LIMIT 1].Id;

        Test.startTest();
        GEERSAPStatusPathController.GEERWrapper result = GEERSAPStatusPathController.getGEERWrapper(geerId);
        Test.stopTest();

        System.assert(result != null);
        System.assertEquals(5, result.steps.size());
    }

    @isTest
    static void updateSAPStatusTest() {
        String geerId = [SELECT Id FROM GEER__c LIMIT 1].Id;

        Test.startTest();
        GEERSAPStatusPathController.updateSAPStatus(GEERSAPStatusPathController.STEP_PRUCHASE_REQUISITION, geerId);
        Test.stopTest();

        System.assertEquals(GEERSAPStatusPathController.STEP_PRUCHASE_REQUISITION, 
                            [SELECT Id, SAP_Status__c FROM GEER__c WHERE Id =:geerId].SAP_Status__c);
    }
}