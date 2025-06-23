@isTest
public class GOLIGeerControllerTest {
@isTest
    public static void method1(){
		//Create Account
          Account Acc = TestDataFactory.createAccount(false);
             Acc.SAP_Sales_Org__c ='1020';
             Insert Acc;
      
        //Create GEER Growth
        Geer__c gr = new Geer__c();
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
       
        
        GoLI__c gol=new GoLI__c();
gol.Quantity__c=1; 
        gol.GEER__c=gr.Id;
        insert gol;
         List<GOLI__c> grList=new List<GOLI__c>();
        grList.add(gol);
        Asset ast =  TestDataFactory.createAsset(true,acc.id);
      
        
        Equipment_Order_Line_Item__c eoli = new Equipment_Order_Line_Item__c();
        eoli.Description__c = 'Test';
        eoli.Quantity__c = '5';
        eoli.Vendor__c = 'A&F (103897)';
        eoli.Date_Required__c = system.today()+1;
        eoli.Equipment__c = ast.id;
        insert eoli;
		
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new AFEcreationMockHttp());
        List<Equipment_Order_Line_Item__c> e = EOLIGeerController.getEOLI(gr.Id);
       
        GOLIGeerController.getGOLI(gol.Id,12);
        GOLIGeerController.SendGOLI(grList,ast.id);
        Test.stopTest();
    }
}