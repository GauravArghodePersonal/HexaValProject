@isTest
private class GEERPendingApprovalEmailNotifsTest {
    
    @TestSetup
    static void makeData(){
        Profile pr = [SELECT Id FROM Profile WHERE Name = 'Solenis Commercial EMEA PP' LIMIT 1];
        User user= TestDataFactory.createUser(false, 'solenistest' + Integer.valueof((Math.random() * 10)) + '@test.com', 'empId');
        user.ProfileId = pr.Id;
        Insert user;
        Id geerPermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'GEERPermissionSet' LIMIT 1].Id;
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = geerPermissionSetId, AssigneeId = user.Id);
        insert psa; 

        System.runAs(user) {
            Account acc = TestDataFactory.createAccount(false);
            acc.ParentId = null;
            acc.SAP_SalesDistrict__c='PSNA1';
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
        }
    }

    @isTest
    static void sendPendingApprovalEmailNotificationsTest() {
        User usr = [SELECT Id FROM User WHERE UserName LIKE 'solenistest%' LIMIT 1];
        GEER__c geer = [SELECT Id FROM GEER__c LIMIT 1];
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(geer.id);
        req1.setSubmitterId(usr.Id); 
        req1.setProcessDefinitionNameOrId('EMEA_GEER_PaperV7');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
		
        Test.startTest();
        GEERPendingApprovalEmailNotifications.sendPendingApprovalEmailNotifications();
        Test.stopTest();
    }
}