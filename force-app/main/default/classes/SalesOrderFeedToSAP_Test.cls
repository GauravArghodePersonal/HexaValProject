@isTest
public class SalesOrderFeedToSAP_Test {
    @isTest
    public static void saleOrderFeedToSAP(){
        //Create PriceFx
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
        //Create Account
        Account acc = new Account();
        acc.name = 'Test';
        acc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Water Prospect','Account');
        acc.SAP_SALES_ORG__C = '0315';
        acc.Account_Sales_Potential_Amount_Year__c = 200;
        acc.CurrencyIsoCode = 'USD';
        acc.SAP_City__c = 'NY';
        acc.Country_picklist__c = 'Bolivia (BO)';
        acc.Prospect_Sales_Org__c = 'HERCULES RUSSIA(0070)';
        acc.Prospect_Dist_Channel__c = 'AHWT (10)';
        acc.Prospect_Division__c = 'AHWT (11)';
        acc.Prospect_Sales_District__c = 'AWT Direct SLS (10009)';
        acc.Prospect_Sales_Office__c = 'AWT AP Direct Sales (1093)';
        acc.Prospect_Sales_Group__c = 'AWT Direct Sales (WL4)';
        acc.Prospect_Customer_Group__c = 'Biorefining (1E)';
        acc.Prospect_Customer_Group1__c = 'DIRECT SALE (501)';
        acc.Prospect_Customer_Group2__c = 'BRF-BIOFUEL (195)';
        acc.Related_to_Corporate__c = 'No';
        acc.SAP_Customer_Number__c = '12345';
        insert acc;
        
        //Create Reorder
        Reorder__c ord = new Reorder__c();
        ord.Ship_To__c = acc.Id;
        ord.Sold_To__c = acc.Id;
        ord.Customer_PO_Number__c = '12345';
        ord.Requested_Delivery_Date__c = System.Today()+1;
        ord.ReOrder_Type__c = 'Standard Billing';
        insert ord;
        
        //Create Reorder Line Item
        Reorder_Line_Item__c reOrd = new Reorder_Line_Item__c();
        reOrd.Reorder__c = ord.Id;
        reOrd.Quantity__c = 15;
        reOrd.Tank_Number__c = '1';
        insert reOrd;
        
        //SalesOrderFeedToSAP.CalloutToDellBoomi(ord.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SalesOrderMockHttp());
        String res = SalesOrderFeedToSAP.CalloutToDellBoomi(ord.Id);
        Test.setMock(HttpCalloutMock.class, new SalesOrderMockErrorHttp());
        String res1 = SalesOrderFeedToSAP.CalloutToDellBoomi(ord.Id);
        Test.stopTest();
    }
}