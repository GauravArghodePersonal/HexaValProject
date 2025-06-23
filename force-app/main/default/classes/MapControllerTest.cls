@isTest
private class MapControllerTest{
    static Id ESRRecordType = RecordType_Functions.LookupRecordTypeId('AHWT DZ', 'Case');
    static testMethod void createData(){
        //Create an object of data
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
        // Inserting Account
        Account rec=new Account(); 
        rec.Name = 'Test Account 1';
        rec.SAP_Zip_Code__c = '43081';
        rec.SAP_Account_Name_2__c = rec.Name;
        rec.AccountNumber = '123';
        rec.BillingCity = 'City';
        rec.BillingCountry = 'US';
        rec.BillingPostalCode = '99999';
        rec.BillingState = 'Virginia';
        rec.SAP_State__c = 'Virginia';
        rec.SAP_Customer_Group_1_Desc__c = 'CustGrp1';
        rec.SAP_Customer_Group_Desc__c = 'CustGrp';
        rec.SAP_DistChannel__c = '10';
        rec.SAP_Dist_Channel_Desc__c = 'AHWT';
        rec.SAP_DivisionCode__c = '11';
        rec.SAP_Division_Desc__c = 'AHWT';
        rec.SAP_Sales_Org__c = '1020';
        rec.SAP_Sales_Org_Desc__c = 'Solenis';
        rec.Hours_of_Access__c='9 to 17';
        rec.PPE_Requirements__c='Ear Plugs';
        rec.Site_Access__c='BackGround Check';
        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
        insert rec;
        
        //Inseting case
        Case cas = new Case();
        cas.AccountId = rec.Id;
        cas.RecordTypeId = ESRRecordType;
        cas.Subject = 'test case';
        cas.Status='In Scheduling';
        insert cas;
        ApexPages.StandardController c = new ApexPages.StandardController(cas);
        PageReference pageRef = Page.NavigationMap;
        Test.setCurrentPage(pageRef);
        MapController con = new MapController(c);
    }   
}