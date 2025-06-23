@isTest
public class GEERTriggerOperations_Test {
    
    @isTest
    public static void test1()
    {
        GEER_Budget_Numbers__c sg=new GEER_Budget_Numbers__c();
        sg.Budget_number__c='121212';
        sg.Name='2021_Growth_NA_IWT';
        sg.Region__c='NA';
        sg.Project_type__c='Growth';
        insert sg;
        
        String profileId = [SELECT Id FROM Profile WHERE Profile.Name = 'W-Standard User - non G3'].Id;      
        User u = TestObjects.newUser(new Map<String,String>{'ProfileId'=>profileId});  
        
        ValueAdvantage_Approver_List__c vapSet = new ValueAdvantage_Approver_List__c();
        vapSet.Name = 'NA/LA';
        vapSet.Active_Office_Manager__c = True;
        vapSet.SAP_Sales_District__c = 'IWEU2';
        vapSet.SAP_Sales_Office__c = 'IW02';
        vapSet.SAP_Sales_Group__c = 'I22';
        vapSet.Office_Manager_User_Id__c = u.Id;
        vapSet.DOGId__c = 'IWEU2IW02I22';
        vapSet.CR_Approve_Level__c = 'DM';
        insert vapSet;
        
        
        ValueAdvantage_Approver_List__c vapSet2 = new ValueAdvantage_Approver_List__c();
        vapSet2.Name = 'EMEA/APAC';
        vapSet2.Active_Office_Manager__c = True;
        vapSet2.SAP_Sales_District__c = 'IWEU2';
        vapSet2.SAP_Sales_Office__c = 'IW02';
        vapSet2.SAP_Sales_Group__c = 'I22';
        vapSet2.Office_Manager_User_Id__c = u.Id;
        vapSet2.DOGId__c = 'IWEU2IW02I22';
        vapSet2.CR_Approve_Level__c = 'DM';
        insert vapSet2;
        
        AFE_Call__c setting = new AFE_Call__c();
        setting.Name = 'EMEA';
        setting.Project_Manager_Emp_Num__c = '1234';
        insert setting;
        
        AFE_Call__c setting1 = new AFE_Call__c();
        setting1.Name = 'NA';
        setting1.Project_Manager_Emp_Num__c = '1234';
        insert setting1;
        
        AFE_Call__c setting2 = new AFE_Call__c();
        setting2.Name = 'callFiori';
        setting2.EndpointURL__c = '1234';
        setting2.Username__c = '1234';
        setting2.Password__c = '1234';
		insert setting2;
        
        //Create Account
        Account Acc = TestDataFactory.createAccount(false);
        acc.ParentId = null;
        acc.SAP_Sales_Org__c = '0650';
        acc.SAP_Sales_Org_Region_value1__c = 'NA';
        Insert Acc;
        
        List<Geer__c> geerList = new List<Geer__c>();
        
        //Create GEER
        Geer__c gr = new Geer__c();
        gr.Ship_To__c = acc.id;
        gr.Fiscal_Year__c='2023';
        gr.Ship_To__c = acc.id;
        gr.Project_type1__c = 'Growth';
        gr.Prepared_By__c = '';
        gr.Budget_Number__c = '';
        gr.Origination_Type__c = '0';
        gr.Local_Currency_Total_Amount__c = 12;
        gr.Exchange_Rate__c = 11;
        gr.GEER_Description__c = 'Test';
        gr.State__c = 'VA';
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
        gr.Request_Type__c = 'Field Test Equipment';
        geerList.add(gr);

        //Create GEER Stay in Business
        Geer__c gr1 = new Geer__c();
        gr1.Ship_To__c = acc.id;
        gr1.Fiscal_Year__c='2023';
        gr1.Project_type1__c = 'Growth';
        gr1.Prepared_By__c = '';
        gr1.Cost_Center__c = 'IWT Equipment - CC (350001) - 0869';
        gr1.Budget_Number__c = '';
        gr1.Origination_Type__c = '0';
        gr1.Local_Currency_Total_Amount__c = 12;
        gr1.Exchange_Rate__c = 11;
        gr1.GEER_Description__c = 'Test';
        gr1.State__c = 'VA';
        gr1.Target_Mechanical_Completion_In_Months__c = 5;
       
        gr1.Approval_Routing_Priority__c = 'Normal';
        gr1.Project_Manager_Emp_Num__c = '';
        gr1.Asset_Type__c ='Machinery and Equipment(6)';
        gr1.Usage_Code__c = 'Sales Support(9)';
        gr1.SFDC_Link_GEER__c = '';
        gr1.Market_Vertical__c = 'Pulp(11)';
        gr1.Equipment_Category__c = 'Polymer - Dry(54)';
        gr1.Sales_Rep_Name__c = '';
        gr1.SBU__c = 'Polymer - RDC(8)';
        gr1.Est_Revenue_Generated__c = 2;
        gr1.Est_Gross_Profit_Generated__c = 2;
        gr1.Payback_in_Months__c = 4;
        gr1.Justification__c = 'Trial for new business';        
        geerList.add(gr1);
        
        DCFROR_Project_Management_AdderPercent__c dpm=new DCFROR_Project_Management_AdderPercent__c();
        dpm.AdderPercent__c=10;
        dpm.Name='NA';
        insert dpm;
		
        //Create GEER Compliance
        Geer__c gr2 = new Geer__c();
        gr2.Ship_To__c = acc.id;
        gr2.Fiscal_Year__c='2023';
        gr2.Project_type1__c = 'Growth';
        gr2.Prepared_By__c = '';
        gr2.Budget_Number__c = '';
        gr2.Origination_Type__c = '0';
        gr2.Local_Currency_Total_Amount__c = 12;
        gr2.Exchange_Rate__c = 11;
        gr2.GEER_Description__c = 'Test';
        gr2.State__c = 'VA';
        gr2.Target_Mechanical_Completion_In_Months__c = 5;
        gr2.Cost_Center__c = '';
        gr2.Approval_Routing_Priority__c = 'Normal';
        gr2.Project_Manager_Emp_Num__c = '';
        gr2.Asset_Type__c ='Machinery and Equipment(6)';
        gr2.Usage_Code__c = 'Sales Support(9)';
        gr2.SFDC_Link_GEER__c = '';
        gr2.Market_Vertical__c = 'Pulp(11)';
        gr2.Equipment_Category__c = 'Polymer - Dry(54)';
        gr2.Sales_Rep_Name__c = '';
        gr2.SBU__c = 'Polymer - RDC(8)';
        gr2.Est_Revenue_Generated__c = 2;
        gr2.Est_Gross_Profit_Generated__c = 2;
        gr2.Payback_in_Months__c = 4;
        gr2.Justification__c = 'Trial for new business';
        geerList.add(gr2);
        
        //Create GEER E-Pool
        Geer__c gr3 = new Geer__c();
        gr3.Ship_To__c = acc.id;
        gr3.Fiscal_Year__c='2023';
        gr3.Project_type1__c = 'Growth';
        gr3.Prepared_By__c = '';
        gr3.Budget_Number__c = '';
        gr3.Origination_Type__c = '0';
        gr3.Local_Currency_Total_Amount__c = 12;
        gr3.Exchange_Rate__c = 11;
        gr3.GEER_Description__c = 'Test';
        gr3.State__c = 'VA';
        gr3.Target_Mechanical_Completion_In_Months__c = 5;
        gr3.Cost_Center__c = '';
        gr3.Approval_Routing_Priority__c = 'Normal';
        gr3.Project_Manager_Emp_Num__c = '';
        gr3.Asset_Type__c ='Machinery and Equipment(6)';
        gr3.Usage_Code__c = 'Sales Support(9)';
        gr3.SFDC_Link_GEER__c = '';
        gr3.Market_Vertical__c = 'Pulp(11)';
        gr3.Equipment_Category__c = 'Polymer - Dry(54)';
        gr3.Sales_Rep_Name__c = '';
        gr3.SBU__c = 'Polymer - RDC(8)';
        gr3.Est_Revenue_Generated__c = 2;
        gr3.Est_Gross_Profit_Generated__c = 2;
        gr3.Payback_in_Months__c = 4;
        gr3.Justification__c = 'Trial for new business';
        geerList.add(gr3);
        
        Test.setMock(HttpCalloutMock.class, new GEERTrackingHttpCalloutMockImpl());
        Test.startTest();
        Insert geerList;
        
        DCFROR__c df=new DCFROR__c();
        df.GEER__c=gr1.Id;
        insert df;
        
        gr.Status__c = 'Equipment Creation';
        gr.Project_type1__c = 'Stay in Business';
        gr.Site_contacts__c = 'Test'; 
        gr.Cost_Center__c = 'IWT Equipment - CC (350001) - 0869';
        gr.Equipment_Engineers_Comments__c = 'Test Comments';
        
        gr1.Status__c = 'SAP Process';
        gr1.Project_type1__c = 'Stay in Business';
        gr1.Site_contacts__c = 'Test';
        gr1.SAP_Status__c = 'Purchase Requisition';
        gr3.SBU__c = 'Size - AKD(11)';
        
        gr2.Status__c = 'SAP Process';
        gr2.Project_type1__c = 'Stay in Business';
        gr2.Site_contacts__c = 'Test';
        gr2.SAP_Status__c = 'Purchase Order';
        gr3.SBU__c = 'Size - Rosin(13)';
        
        gr3.Status__c = 'SAP Process';
        gr3.Project_type1__c = 'Stay in Business';
        gr3.Site_contacts__c = 'Test';
        gr3.SAP_Status__c = 'Goods Receipt in SAP';
        gr3.SBU__c = 'Size - ASA(12)';
        Update geerList;
        
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setComments('Submitting request for approval.');
        request.setObjectId(gr3.id);        
        request.setSubmitterId(userinfo.getUserId());         
        request.setProcessDefinitionNameOrId('NAEngineerStep');
        request.setSkipEntryCriteria(true);  
        Approval.ProcessResult result = Approval.process(request);
        
        System.assert(result.isSuccess());
        
        ProcessInstanceWorkitem[] workItems = [ SELECT Id
                                                FROM ProcessInstanceWorkitem
                                                WHERE ProcessInstance.TargetObjectId =: gr3.Id
                                                AND ProcessInstance.Status = 'Pending'];
        Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest(); 
        pwr.setAction('Approve');
        request.setComments('Approved!');
        pwr.setWorkItemId( workItems[0].id );       
        result = Approval.process( pwr );
        
        gr3.Status__c = 'AFE Approval';
        Update gr3;
        
        GEERTriggerOperations.makeHttpsCall('Testing',gr1.Id);
        GEERTriggerOperations.makeHttpsCall('Testing',gr2.Id);
        GEERTriggerOperations.makeHttpsCall('Testing',gr3.Id);
        Test.stopTest();
        
    }

}