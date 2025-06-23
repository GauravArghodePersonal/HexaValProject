@isTest

    private class PricingApproversTriggerHandlertest{

       @isTest Private static void PricingTriggerHandlertestStatus(){
     
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
            
        Account acct5 = new Account();
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
            
        //List<VDP_Approver_List__c> vdplist = new List<VDP_Approver_List__c>();
        Pricing_Approvers__c temp= new Pricing_Approvers__c();
        temp.Name='IW41';
        temp.Active_Office_Manager__c=True;
        temp.Office_Manager__c='Thomas R Bonham';
        temp.Office_Manager_Email__c='ss00561461@techmahindra.com';
        temp.Office_Manager_Id__c='00550000003XBCzAAO';
        temp.SAP_Sales_Office__c='IW41';
        insert temp;
       
        
        Pricing__c pricing= New Pricing__c ();
        pricing.Account__c=acct5.Id;
        pricing.Pricing_Type__c='Equipment Pricing';
        pricing.Flag_Check__c=False;
        insert pricing;  
           ContentVersion cv = new ContentVersion(
                    Title = 'Test DocumentNew34',
                    PathOnClient = 'Dummynew34.pdf',
                    VersionData = Blob.valueOf('Test ContentNew34'),
                    IsMajorVersion = true
                    );
                insert cv;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = pricing.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                insert cdl;
        pricing.Status__c='Submitted';            
        update pricing;
        
        
      
        }
        
       

    }