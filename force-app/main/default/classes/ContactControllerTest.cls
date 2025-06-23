/*****************************************************************
* Class Name     : TestContactController                         *
* Author         : Gokul Bajai R                                 *
* Created Date   : 10-Sep-2020                                   *
* Modified Date  : 10-Sep-2020                                   *
* Description    : Test Class for ContactController class        *
*****************************************************************/

@isTest
public class ContactControllerTest { 
    static Task t;
    static Id ESRRecordType = RecordType_Functions.LookupRecordTypeId('ESR-Preventative Maintenance', 'Case');
    static testMethod void testSurvey(){ 
        
        Test.startTest();
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        
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
        insert acc;       
        t = new Task();
        t.WhatId = acc.Id;
        t.development_group__c = 'Vinyl Ester Resins';
        t.ActivityDate = System.today();
        t.Notify_account_Owner__c = 'Yes';
        t.Manager_Alert__c = 'Yes';
        t.Subject = 'Test task';
        t.Description = 'Test task';
        insert t;
        ContentVersion cv = new ContentVersion(
                    Title = 'Test DocumentNew34',
                    PathOnClient = 'Dummynew34.pdf',
                    VersionData = Blob.valueOf('Test ContentNew34'),
                    IsMajorVersion = true
                    );
                insert cv;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = t.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                insert cdl;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.id;
        con.Phone = '12345';
        con.Email = 'test@abc.com';
        con.W_Decision_Maker_Type__c = 'Other';
        con.V_Area_of_Responsibility__c = 'CEO';
        con.WV_Contact_Status__c = 'Active';
        insert con;
        
        List<contact> updateCon = New list<contact>();
        updateCon.add(con);
        
        List<String> conIdList = new List<String>();
        conIdList.add(con.id);
        RecordFileDownloaderController.getfileIds(acc.id);
        ContactController.isSurveyUser();
        ContactController.findContactByAccountId(acc.Id);
        ContactController.updateContactRecord(conIdList);
        ContactController.getSurveys();
        ContactController.updateContactRecordV1(updateCon);
   
        Test.stopTest();
    }
}