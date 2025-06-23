@isTest(seeAllData=true)
private class Test_checkSiteAccess{
    static testMethod void create_case(){
        //List<Account> acc = [select id,Name,SiteAccessRequirementOther__c,SAP_Sales_Org_Region_value__c,PPE_Requirements__c,Site_Access__c,Hours_of_Access__c from Account where SAP_Sales_Org_Region_value__c = 'EMEA' Limit 1];
            
         //Creation of Account
         try{
             /*Account a = new Account();
             a.RecordtypeId = '01250000000HmZ3';
             a.Name ='Test - EMEA' ;
             a.Account_Sales_Potential_Amount_Year__c = 12659;
             a.PPE_Requirements__c = 'Chemical suit if breaking lines';
             a.Site_Access__c = 'Certificate Of Insurance';
             a.Hours_of_Access__c = '12.75';
             a.SiteAccessRequirementOther__c = 'Test';*/
             
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
             
             insert ACC;
              String sBreak = '</br></br>'; // this is separate because you can use it anywhere else
              String first = '<a href="'; 
              String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();  // You can easily use in any instance, no need hard code
              String last = '" target="_blank" style="color:#c00;">Click here for viewing the Account</a>'; //target opens in new window
             Case c = new Case();
                //c = [select Id,Solenis_Contact__c,Account.SiteAccessRequirmentsOther__c from case where RecordTypeId = '012500000009wKh' and AccountId = '0015000000twCTn' limit 1];
                c.Solenis_Contact__c = 'Vinub';
                c.RecordTypeId = '012500000009wKh';
                c.Accountid = ACC.id;
                c.Solenis_Contact_Phone__c = '996232b3825';
                c.EngineerRegion__c = 'EMEA';
                c.Equipment_Type__c = 'Analyzer EMEA';
                c.Product_ESR__c = 'Test123f4';
                c.Asset_Tag__c = 'tesfts';
                c.Description_of_work_to_be_done__c = 'tfest';
                c.Eqpt_to_be_unistalled_by_Equipment_Team__c = 'Yes';
                c.Where_will_the_equipment_go__c = 'Shipped out';
                c.Subject = 'Thkest';
                c.Requested_Date__c = date.today();
                c.Description_of_work_to_be_done__c = 'Techkst';
                //accMap.get(c.accountid).SiteAccessRequirmentsOther__c = '';
                insert c;
                System.debug('Here is the Case detail'+c);   
        }
        catch(exception ex){
            Boolean expectedExceptionThrown = ex.getMessage().contains('Script-thrown exception') ? true : false; 
        }
    }
    static testMethod void create_case2(){
        //List<Account> acc = [select id,Name,SiteAccessRequirementOther__c,SAP_Sales_Org_Region_value__c,PPE_Requirements__c,Site_Access__c,Hours_of_Access__c from Account where SAP_Sales_Org_Region_value__c = 'EMEA' Limit 1];
            
         //Creation of Account
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
              String sBreak = '</br></br>'; // this is separate because you can use it anywhere else
              String first = '<a href="'; 
              String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();  // You can easily use in any instance, no need hard code
              String last = '" target="_blank" style="color:#c00;">Click here for viewing the Account</a>'; //target opens in new window
             Case c = new Case();
                //c = [select Id,Solenis_Contact__c,Account.SiteAccessRequirmentsOther__c from case where RecordTypeId = '012500000009wKh' and AccountId = '0015000000twCTn' limit 1];
                c.Solenis_Contact__c = 'Vinub';
                c.RecordTypeId = '012500000009wKh';
                
                //c.RecordTypeId='01250000000HmOe';
                c.Accountid = a.id;
                c.Solenis_Contact_Phone__c = '996232b3825';
                c.EngineerRegion__c = 'EMEA';
                c.Equipment_Type__c = 'Analyzer EMEA';
                c.Product_ESR__c = 'Test123f4';
                c.Asset_Tag__c = 'tesfts';
                c.Description_of_work_to_be_done__c = 'tfest';
                c.Eqpt_to_be_unistalled_by_Equipment_Team__c = 'Yes';
                c.Where_will_the_equipment_go__c = 'Shipped out';
                c.Subject = 'Thkest';
                c.Requested_Date__c = date.today();
                c.Description_of_work_to_be_done__c = 'Techkst';
                //accMap.get(c.accountid).SiteAccessRequirmentsOther__c = '';
                insert c;
                System.debug('Here is the Case detail'+c);   
        }
        catch(exception ex){
            Boolean expectedExceptionThrown = ex.getMessage().contains('Script-thrown exception') ? true : false; 
        }
    }
    
}