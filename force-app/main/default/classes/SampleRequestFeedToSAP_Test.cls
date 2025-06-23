@isTest
public class SampleRequestFeedToSAP_Test {
	@isTest
    public static void SampleRequestFeedToSAP(){
        
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
        acc.SAP_SALES_ORG__C = '1020';
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
        acc.Type = 'Customer';
        acc.SAP_Sales_Org_Region_value1__c = 'NA';
        insert acc;
        
        //Create Sample Request
        Sample_Request__c sampReq = new Sample_Request__c();
        sampReq.Account__c = acc.Id;
        sampReq.Commercial_Order__c = true;
        insert sampReq;
        
        //Create Sample Material
        Sample_Material__c sampMat = new Sample_Material__c();
        sampMat.Name = 'ABCD';
        sampMat.Sample_Quantity__c = 15;
        sampMat.Sample_Request__c = sampReq.Id;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        insert sampMat;  
        }
        
        String lc = 'E';
        Material_General_Data__c mgd = new Material_General_Data__c();
        Material_Description__c md = new Material_Description__c();
        md.Material_Description__c = 'TestMat';
        md.Language_Code__c = lc;
        md.Material_Number__c = '000000000123456789';
        insert md;
        //mgd.Material_Description__c = 'Test';
        mgd.Material_Number__c = md.Material_Number__c;
        mgd.Gross_Weight__c = 1.075;
        mgd.Net_Weight__c = 1.000;
        mgd.Base_UOM__c = 'ABC';
        Material_Base_Code__c bc = new Material_Base_Code__c();
        bc.Material_Base_Code__c = '12345678';
        insert bc; 
        mgd.Base_Code__c = bc.Material_Base_Code__c;
        Material_Container_Code__c cc = new Material_Container_Code__c();
        cc.Material_Container_Code__c = '12345';
        insert cc;
        mgd.Container_Code__c = cc.Material_Container_Code__c;
        Material_Group__c mg = new Material_Group__c();
        mg.Language_Code__c = lc;
        mg.Material_Group_Code__c = '1234';
        insert mg;
        mgd.Material_Group_Code__c = mg.Material_Group_Code__c;
        Material_Type__c mt = new Material_Type__c();
        mt.Language_Code__c = lc;
        mt.Material_Type_Code__c = 'ABCD';
        insert mt;
        mgd.Material_Type_Code__c = mt.Material_Type_Code__c;
        insert mgd;
        
        
        //Create PriceFx
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = '01250000000HmZV';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        insert p1;
        
        Material_Sales_Data2__c matSales = new Material_Sales_Data2__c();
        matSales.Material_Number__c = '12345';
        matSales.Dist_Channel_Code__c = '12';
        matSales.Record_Key__c = '11';
        matSales.Sales_Org_Code__c = '1020';
        insert matSales;
		
        Set<Id> sampId = new Set<Id>();
        sampId.add(sampReq.Id);
        
        Test.startTest();
        SampleRequestFeedToSAP_LWCbutton.IsSysAdminProfile();
        Test.setMock(HttpCalloutMock.class, new SalesOrderMockHttp());
        SampleRequestFeedToSAP.CalloutToDellBoomi(sampId);
        String res = SampleRequestFeedToSAP_LWCbutton.CalloutToDellBoomi(sampReq.Id);
        Test.setMock(HttpCalloutMock.class, new SalesOrderMockErrorHttp());
        String res1 = SampleRequestFeedToSAP_LWCbutton.CalloutToDellBoomi(sampReq.Id);
        Test.stopTest();
    }
}