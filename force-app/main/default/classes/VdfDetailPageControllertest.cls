@isTest

    private class VdfDetailPageControllertest{

        @isTest Private static void VdfDetailPageControllertest(){
        
        Trigger__c Tr = New Trigger__c();
               Tr.Name='SentEmailToAcc';    
               Tr.Run__c=True;
               Tr.Trigger_Name__c='opportunityTriggerhandler';
           Insert Tr;     
           
           Competitive_Email_Setup__c CMS = New Competitive_Email_Setup__c();
               CMS.Name='SentEmailToAcc';
               CMS.Bcc__c='Test@test.com';
               CMS.CC_Email__c='Test@test.com';
               CMS.DisplayName__c='Test Display Name';
               CMS.Reply_To__c='Test@test.com';
               CMS.Subject__c='Test Subject';
            insert CMS;
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();          
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        insert pfxCustomList;
        
        ValueAdvantage_Approver_List__c temp= new ValueAdvantage_Approver_List__c();
        temp.Name='NA/LA';
        temp.Active_District_Manager__c=True;
        temp.Active_Office_Manager__c=True;
        temp.District_Manager__c='Test Manager';
        temp.District_Manager_User_Id__c='00550000006SxCGAA0';
        temp.Office_Manager__c='Test Office Manager';
        temp.Office_Manager_User_Id__c='00550000003XBCzAAO';
        temp.SAP_Sales_District__c='IWNA1';
        temp.SAP_Sales_Office__c='IW31';
        temp.User_Id__c='00550000003XlDL';
        temp.Username__c='Test User';
        temp.DOGId__c='IWNA1IW3118I';
        temp.SAP_Sales_Group__c='18I';
        //vdplist.add(temp);
        insert temp;
        
            Account ACC = new Account();
            ACC.Name = 'Test 5';
            ACC.ParentId = '0015000000tvxEv';
            ACC.Type = 'Prospect';
            ACC.AccountNumber = 'P704122';
            ACC.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
            ACC.country_picklist__c = 'Afghanistan (AF)';
            ACC.Prospect_Division__c = 'AAFI (50)';
            ACC.Prospect_Sales_District__c = 'ADDITIVES (11100)';
            ACC.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
            ACC.Prospect_Sales_Group__c = 'AM ARG/URU';
            ACC.Prospect_Dist_Channel__c = 'AAFI (50)';
            ACC.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
            ACC.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
            ACC.Prospect_Customer_Group__c = 'ADDITIVES (11)';
            ACC.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
            ACC.Prospect_Customer_Price_Group_Desc__c = 'A';
            ACC.SAP_Country__c = 'US';
            ACC.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
            ACC.SAP_Customer_Number__c = '12345';
            ACC.Ship_To_Customer_Number__c = '12345';
            ACC.SAP_Sales_Office__c='IW31';
            ACC.SAP_SalesGroup__c='18I';        
            ACC.SAP_SalesDistrict__c='IWNA1';
            ACC.RecordTypeId = '01250000000HmZ3AAK';
            ACC.SAP_Sales_Org__c = '1031';
        insert ACC;
        
        
        Opportunity Opp = New Opportunity();
            opp=TestDataFactory.createOpportunity(false,ACC.id);
            Opp.Name = 'Test Opportunity';
            Opp.Accountid=ACC.id;
            Opp.Customer_Prospect__c = ACC.id;
            Opp.SBU_Multi__c='Boiler';
            //Opp.SAP_Sales_Org_Region__c='EMEA';
            Opp.CurrencyIsoCode='USD';
            Opp.Annualized_Gross_Profit_GP__c=500;
            Opp.Amount=600;
            Opp.CloseDate=System.today();
            Opp.StageName='Defining/Prospecting';
            Opp.Capex_Equipment_investment_involved__c='Yes';
            Opp.Capex_Estimate__c=100;
            Opp.CapitalEquipmentDescription__c='GLOBAL-CUSTOMISED (Manual entry)';
            Opp.SAP_Sales_Org_Region__c='NA';
        insert Opp;
       
        
        ValueAdvantage__c vdp = New ValueAdvantage__c();
            vdp.Name='Test';
            vdp.Customer__c=ACC.Id;
            vdp.CurrencyIsoCode='USD';
            vdp.Approver__c='00550000003XlDL';
            vdp.Project_Status__c='Delivering Value';
            vdp.Approval_Status__c='Completed';
            vdp.Actual_Date_Completed__c=System.today();
            //vdp.Savings_Type__c='Cost Savings';
            //vdp.Customer_Value_Type__c='Raw Material';
            vdp.Problem_Statement__c='Test test';
            vdp.Check__c=true;
            vdp.Solenis_Recommendation__c='Test';
            vdp.Value_Proposition__c='Test';
            vdp.Opportunity__c=Opp.id;
            vdp.Learnings__c='test';
        insert vdp;              
            ApexPages.CurrentPage().getParameters().put('id', vdp.id);
            VdfDetailPageController  va= New VdfDetailPageController();
            vdpCustomerFacingPDfController vcfc = New vdpCustomerFacingPDfController();
            VdpMultiPdf vmp = New VdpMultiPdf();
            VdpMultiXls vmx = New VdpMultiXls();
            
        
        }
        
    }