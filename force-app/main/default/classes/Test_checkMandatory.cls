@isTest
private class Test_checkMandatory{
    static testMethod void create_wo(){
         try{
             
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
        
        Account ACC = new Account();
            ACC.Name = 'Test 5';
            ACC.ParentId = '0015000000tvxEv';
            ACC.RecordTypeId ='01250000000V8vO';
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
            ACC.SAP_SalesDistrict__c='IWNA1';
            ACC.RecordTypeId = '01250000000HmZ3AAK';
            ACC.SAP_Sales_Org__c = '0410';
    
        insert ACC;
             
             Asset ass = new Asset();
             ass.Name='General Equipment';
             ass.Accountid=ACC.id;
             ass.Sales_Org_Region__c='NA';
             
        insert ass;
             
              String sBreak = '</br></br>'; // this is separate because you can use it anywhere else
              String first = '<a href="'; 
              String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();  // You can easily use in any instance, no need hard code
              String last = '" target="_blank" style="color:#c00;">Click here for viewing the Account</a>'; //target opens in new window
             WorkOrder wo = new WorkOrder();
                wo.Assetid =ass.id;
                wo.RecordTypeId='0122J000000kxw2';
                wo.Accountid = ACC.id;
                wo.Subject='Felt Wash Trial';
                wo.Description_of_work_to_be_done_del__c='Install trial skid with feed lines to injection points';
                wo.Product_ESR__c='Presstige FC8585';
                wo.Business_Unit__c='IWT';
                wo.SBU_Type__c='Defoamer-IWT';
                wo.FSL_Equipment_Type__c='General Equipment';
                wo.FSL_Requested_Date__c=date.today();
               
                insert wo;
                System.debug('Here is the WO detail'+wo);   
        }
        catch(exception ex){
            Boolean expectedExceptionThrown = ex.getMessage().contains('Script-thrown exception') ? true : false; 
        }
    }
    static testMethod void create_wo2(){
       
         try{
             Account a = new Account();
             a.RecordtypeId = '01250000000HmZ3';
             a.Name ='Test - EMEA' ;
             a.Account_Sales_Potential_Amount_Year__c = 12659;
             a.PPE_Requirements__c = 'test';
             a.Site_Access__c = 'test';
             a.Hours_of_Access__c = '5';
             a.SiteAccessRequirementOther__c = 'test';
             insert a;
             
             Asset asset = new Asset();
             asset.Name='General Equipment';
             asset.Accountid=a.id;
             asset.Sales_Org_Region__c='NA';
             
             insert asset;
        
              String sBreak = '</br></br>'; // this is separate because you can use it anywhere else
              String first = '<a href="'; 
              String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();  // You can easily use in any instance, no need hard code
              String last = '" target="_blank" style="color:#c00;">Click here for viewing the Account</a>'; //target opens in new window
             WorkOrder workorder = new WorkOrder();
                workorder.Assetid =asset.id;
                workorder.RecordTypeId='0122J000000kxw2';
                workorder.Accountid = a.id;
                workorder.Subject='Felt Wash Trial';
                workorder.Description_of_work_to_be_done_del__c='Install trial skid with feed lines to injection points';
                workorder.Product_ESR__c='Presstige FC8585';
                workorder.Business_Unit__c='IWT';
                workorder.SBU_Type__c='Defoamer-IWT';
                workorder.FSL_Equipment_Type__c='General Equipment';
                workorder.FSL_Requested_Date__c=date.today();
                insert workorder;
                System.debug('Here is the Case detail'+workorder);   
        }
        catch(exception ex){
            Boolean expectedExceptionThrown = ex.getMessage().contains('Script-thrown exception') ? true : false; 
        }
    }
    
}