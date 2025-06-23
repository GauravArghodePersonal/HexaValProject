@isTest
public class CapexTriggerHandlerTest {
 @isTest
    public static void testCAPEX()
    {
       GEER_Budget_Numbers__c sg=new GEER_Budget_Numbers__c();
        sg.Budget_number__c='121212';
            sg.Name='2021_Growth_NA_IWT';
          sg.Region__c='NA';
            sg.Project_type__c='Growth';
        insert sg;
        
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
        Acc.ParentId = null;
             Acc.SAP_Sales_Org__c ='1020';
             Insert Acc;
        
        //Create GEER
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
        insert gr;

        //Create GEER Stay in Business
        Geer__c gr1 = new Geer__c();
        gr1.Ship_To__c = acc.id;
         gr1.Fiscal_Year__c='2023';
        gr1.Project_type1__c = 'Growth';
        gr1.Prepared_By__c = '';
        gr1.Budget_Number__c = '';
        gr1.Origination_Type__c = '0';
        gr1.Local_Currency_Total_Amount__c = 12;
        gr1.Exchange_Rate__c = 11;
        gr1.GEER_Description__c = 'Test';
        gr1.State__c = 'VA';
        gr1.Target_Mechanical_Completion_In_Months__c = 5;
        gr1.Cost_Center__c = '';
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
        insert gr1;
		
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
        insert gr2;
        
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
        insert gr3;
        List<Geer__c> grlist=new List<Geer__c>();
        grlist.add(gr1);
        grlist.add(gr2);
         grlist.add(gr3);
        Map<Id,Geer__c> oldMap=new Map<Id,Geer__c>();
            oldMap.put(gr1.Id, gr1);
           Map<Id,Geer__c> NewMap=new Map<Id,Geer__c>();
            NewMap.put(gr1.Id, gr1);
        DCFROR_Project_Management_AdderPercent__c dpm=new DCFROR_Project_Management_AdderPercent__c();
        dpm.AdderPercent__c=10;
        dpm.Name='NA';
        insert dpm;
        
        DCFROR__c df=new DCFROR__c();
        df.GEER__c=gr1.Id;
        insert df;
        List<DCFROR__c> dlist=new List<DCFROR__c>();
        dlist.add(df);
        test.startTest();
        DCFRORTriggerOperations.processBeforeInsert(dlist);
        GEERTriggerOperations.processBeforeUpdate(grlist, oldMap, NewMap);
        Capex__c cp=new Capex__c();
        cp.CAPEX_Amount__c=100;
        cp.DCFROR__c=df.id;
        insert cp;
        test.stopTest();
        
    }
        
   
}