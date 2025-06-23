@isTest
public class IRF_PDF_Testclass_SAP {

    static testMethod void  testMethod1()
    {
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
        
        
        Account acct5=new Account();
        acct5.Name = 'Test 5';
        acct5.ParentId = '0015000000tvxEv';
        acct5.Type = 'Prospect';
        acct5.AccountNumber = 'P704122';
        acct5.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        acct5.country_picklist__c = 'Afghanistan (AF)';
        acct5.Prospect_Division__c = 'AAFI (50)';
        acct5.Prospect_Sales_District__c = 'ADDITIVES (11100)';
        acct5.Prospect_Sales_Office__c = '3RD PARTY DISTRI (114R)';
        acct5.Prospect_Sales_Group__c = 'AM ARG/URU';
        acct5.Prospect_Dist_Channel__c = 'AAFI (50)';
        acct5.Prospect_Customer_Group1__c = 'AFFILIATE (412)';
        acct5.Prospect_Customer_Group2__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Group__c = 'ADDITIVES (11)';
        acct5.Prospect_Customer_Group__c = 'ADD-ADHESIVES (161)';
        acct5.Prospect_Customer_Price_Group_Desc__c = 'A';
        acct5.SAP_Country__c = 'US';
        acct5.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acct5.SAP_Customer_Number__c = '12345';
        acct5.Ship_To_Customer_Number__c = '12345';
        acct5.SAP_Sales_Office__c='IW31';
        acct5.SAP_SalesGroup__c='18I';        
        acct5.SAP_SalesDistrict__c='IWNA1';
        acct5.RecordTypeId = '01250000000HmZ3AAK';
        insert acct5;     
        Invoicing_Report_Form__c irf=new Invoicing_Report_Form__c();
        irf.ShipTo__c=acct5.Id;
        insert irf;
        
        
        IRF_Monthly_Data__c irfMonthlyData=new IRF_Monthly_Data__c();
        irfMonthlyData.Shipped_From__c='123';
        irfMonthlyData.Sales_OrderNum__c='123';
        irfMonthlyData.Bill_LandNumber__c='123';
        irfMonthlyData.IRF__c=irf.Id;
            irfMonthlyData.Status__c='Approved';
        insert irfMonthlyData;
        
        IRF_Monthly_Unit__c irfMonthlyUnit=new IRF_Monthly_Unit__c();
        irfMonthlyUnit.Amount__c=123;
        irfMonthlyUnit.IRF_Monthly_Data__c=irfMonthlyData.id;
        irfMonthlyUnit.Amount__c=123;
        insert irfMonthlyUnit;
        Test.StartTest(); 
        
        ApexPages.currentPage().getParameters().put('id', String.valueOf(irfMonthlyData.Id));
        GetSAPController  testAccPlan = new GetSAPController();
        testAccPlan.save();
         testAccPlan.cancel();
        
        
        Test.StopTest();
        
        
    }
    
    
}