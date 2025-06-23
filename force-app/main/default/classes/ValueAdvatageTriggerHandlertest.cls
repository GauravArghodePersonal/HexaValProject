@isTest
	/* Modified By Sandeep Kobaku */
    private class ValueAdvatageTriggerHandlertest{

       @isTest Private static void VDPTriggerHandlertestStatus(){
     
       List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        List<ValueAdvantage__c> valueAdvantageFinalList = new List<ValueAdvantage__c>();
            Map<Id,ValueAdvantage__c> valueAdvantageFinalMap = new  Map<Id,ValueAdvantage__c>();    
		List<ValueAdvantage__c> valueAdvantageList = new List<ValueAdvantage__c>();        
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
       // acct5.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
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
      //  acct5.SAP_Country__c = 'US';
      	 acct5.Not_VDP_Eligible__c = true;
        acct5.Reason_for_not_VDP_Eligible__c = 'Distributor';
        acct5.SAP_Sales_Org_Region_value1__c = 'AP';
        acct5.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acct5.SAP_Customer_Number__c = '12345';
        acct5.Ship_To_Customer_Number__c = '12345';
        acct5.SAP_Sales_Office__c='IW31';
        acct5.SAP_SalesGroup__c='18I';   
     
      //  acct5.SAP_SalesDistrict__c='IWNA1';
       // acct5.SAP_Sales_Org_Region_value1__c ='NA'; 
        acct5.RecordTypeId = '01250000000HmZ3AAK';
    
        insert acct5;
         system.debug('Sandeep'+ acct5.Id);   
        //List<VDP_Approver_List__c> vdplist = new List<VDP_Approver_List__c>();
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
        temp.Group_Manager__c='ED CONNORS';
        temp.Region__c = 'EMEA';
        temp.Group_Manager_User_Id__c='00550000005GumKAAS';
        temp.DOGId__c='IWNA1IW3118I';
        temp.Active_Group_Manager__c=True;
        temp.Username__c='Test User';
        temp.SAP_Sales_Group__c='18I';
       // temp.Office_Manager_User_Id__c='NA';
        //vdplist.add(temp);
        insert temp;
        
        
            
        ValueAdvantage_Approver_List__c temp1= new ValueAdvantage_Approver_List__c();
        temp1.Name='EMEA/APAC';
        temp1.Active_District_Manager__c=False;
        temp1.Active_Office_Manager__c=False;
        temp1.District_Manager__c='';
        temp1.District_Manager_User_Id__c='';
        temp1.Office_Manager__c='';
        temp1.Office_Manager_User_Id__c='';
        temp1.SAP_Sales_District__c='EMEA/APAC';
        temp1.Group_Manager__c='ED CONNORS';
        temp1.DOGId__c='GLOIWGLOWGLW';
        temp1.Active_District_Manager__c=True;
        temp1.Group_Manager_User_Id__c='00550000005GumKAAS';
        temp1.SAP_Sales_Office__c='qqq';
        temp1.User_Id__c='00550000003XArG';
        temp1.Username__c='Alain Enou';
        temp1.SAP_Sales_Group__c='18I';
        insert temp1;
        
        
        ValueAdvantage__c vdp = New ValueAdvantage__c();
        vdp.Name='Test';
        vdp.Customer__c=acct5.Id;
        vdp.CurrencyIsoCode='USD';
        vdp.Approver__c='00550000003XlDL';
        vdp.Project_Status__c='Delivering Value';
        vdp.Approval_Status__c='Completed';
        vdp.Actual_Date_Completed__c=System.today();
        vdp.Savings_Type__c='Cost Savings';
        vdp.Customer_Value_Type__c='Raw Material';
        vdp.Problem_Statement__c='test test';
        vdp.Solenis_Recommendation__c='test';
        vdp.Value_Proposition__c='test';
        vdp.Customer_Value_Type_Cost_Savings__c = 'Environmental (CO2 t/Yr)' ;  
        vdp.Total_Environmental_Savings__c = 23 ; 
        vdp.Customer_Team__c = 'Test';
        vdp.Learnings__c='test';
        vdp.Savings_Month_1__c = 1000;
        vdp.Business_Type__c = 'IWT (Water)';
        vdp.Value_Focus_Area__c = 'Autoclave';
           
        insert vdp;  
        vdp.Approval_Status__c='Completed';  
        vdp.Project_Status__c = 'Completed';
        update vdp;
        
        acct5.SAP_Sales_Office__c='';
        acct5.SAP_SalesGroup__c=''; 
        acct5.SAP_SalesDistrict__c='IWNA1';
        Update acct5;
        vdp.Approval_Status__c='Approved';
         Update vdp;
        
           ValueAdvantage__c vd = New ValueAdvantage__c();
        vd.Name='Test';
        vd.Customer__c=acct5.Id;
        vd.CurrencyIsoCode='USD';
        vd.Approver__c='00550000003XlDL';
        vd.Project_Status__c='Rejected';
        vd.Approval_Status__c='Completed';
        vd.Actual_Date_Completed__c=System.today();
        vd.Savings_Type__c='Cost Savings';
        vd.Customer_Value_Type__c='Raw Material';
        vd.Problem_Statement__c='test test';
        vd.Solenis_Recommendation__c='test';
        vd.Value_Proposition__c='test';
        vd.Customer_Value_Type_Cost_Savings__c = 'Environmental (CO2 t/Yr)' ;  
        vd.Total_Environmental_Savings__c = 23 ; 
        vd.Customer_Team__c = 'Test';
        vd.Learnings__c='test';
        vd.Savings_Month_1__c = 1000;
        vd.Business_Type__c = 'IWT (Water)';
        vd.Value_Focus_Area__c = 'Autoclave';
           
        insert vd;
           
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        
        ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = vdp.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            insert cdl;
            
            vdp.Savings_Month_1__c=35000.00;
             //update vdp;
           valueAdvantageFinalList.add(vdp);
           valueAdvantageFinalList.add(vd);
           Test.startTest();
           ValueAdvantageTriggerHandler.afterUpdateTrigger(valueAdvantageFinalList,valueAdvantageFinalMap);
           ValueAdvantageTriggerHandler.UpdateApprover(valueAdvantageFinalList);
           ValueAdvantageTriggerHandler.updateStatus(valueAdvantageFinalList,valueAdvantageFinalMap);
          ValueAdvantage__c Valueadvantage =  VA_Update_ctrl.getValueAdvantageById(vdp.id);
           System.assertEquals(True, Valueadvantage != null, 'VA Changes');
           ValueAdvantage__c ValueadvantageNegative =  VA_Update_ctrl.getValueAdvantageById('');
           System.assertEquals(True, ValueadvantageNegative == null, 'VA Changes');
           Test.StopTest();
           
        }
        
        @isTest Private static void VDPTriggerHandlertest(){
             List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        List<ValueAdvantage__c> valueAdvantageFinalList = new List<ValueAdvantage__c>();
            Map<Id,ValueAdvantage__c> valueAdvantageFinalMap = new  Map<Id,ValueAdvantage__c>();    
		List<ValueAdvantage__c> valueAdvantageList = new List<ValueAdvantage__c>();        
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
       // acct5.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
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
            acct5.Not_VDP_Eligible__c = true;
        acct5.Reason_for_not_VDP_Eligible__c = 'Distributor';
      //  acct5.SAP_Country__c = 'US';
        acct5.SAP_Sales_Org_Region_value1__c = 'AP';
        acct5.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
        acct5.SAP_Customer_Number__c = '12345';
        acct5.Ship_To_Customer_Number__c = '12345';
        acct5.SAP_Sales_Office__c='IW31';
        acct5.SAP_SalesGroup__c='18I';   
     
      //  acct5.SAP_SalesDistrict__c='IWNA1';
       // acct5.SAP_Sales_Org_Region_value1__c ='NA'; 
        acct5.RecordTypeId = '01250000000HmZ3AAK';
    
        insert acct5;
         system.debug('Sandeep'+ acct5.Id);   
        //List<VDP_Approver_List__c> vdplist = new List<VDP_Approver_List__c>();
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
        temp.Group_Manager__c='ED CONNORS';
        temp.Region__c = 'EMEA';
        temp.Group_Manager_User_Id__c='00550000005GumKAAS';
        temp.DOGId__c='IWNA1IW3118I';
        temp.Active_Group_Manager__c=True;
        temp.Username__c='Test User';
        temp.SAP_Sales_Group__c='18I';
       // temp.Office_Manager_User_Id__c='NA';
        //vdplist.add(temp);
        insert temp;
        
        
            
        ValueAdvantage_Approver_List__c temp1= new ValueAdvantage_Approver_List__c();
        temp1.Name='EMEA/APAC';
        temp1.Active_District_Manager__c=False;
        temp1.Active_Office_Manager__c=False;
        temp1.District_Manager__c='';
        temp1.District_Manager_User_Id__c='';
        temp1.Office_Manager__c='';
        temp1.Office_Manager_User_Id__c='';
        temp1.SAP_Sales_District__c='EMEA/APAC';
        temp1.Group_Manager__c='ED CONNORS';
        temp1.DOGId__c='GLOIWGLOWGLW';
        temp1.Active_District_Manager__c=True;
        temp1.Group_Manager_User_Id__c='00550000005GumKAAS';
        temp1.SAP_Sales_Office__c='qqq';
        temp1.User_Id__c='00550000003XArG';
        temp1.Username__c='Alain Enou';
        temp1.SAP_Sales_Group__c='18I';
        insert temp1;
        
        
        ValueAdvantage__c vdp = New ValueAdvantage__c();
        vdp.Name='Test';
        vdp.Customer__c=acct5.Id;
        vdp.CurrencyIsoCode='USD';
        vdp.Approver__c='00550000003XlDL';
        vdp.Project_Status__c='Delivering Value';
        vdp.Approval_Status__c='Completed';
        vdp.Actual_Date_Completed__c=System.today();
        vdp.Savings_Type__c='Cost Savings';
        vdp.Customer_Value_Type__c='Raw Material';
        vdp.Problem_Statement__c='test test';
        vdp.Solenis_Recommendation__c='test';
        vdp.Value_Proposition__c='test';
        vdp.Customer_Value_Type_Cost_Savings__c = 'Environmental (CO2 t/Yr)' ;  
        vdp.Total_Environmental_Savings__c = 23 ; 
        vdp.Customer_Team__c = 'Test';
        vdp.Learnings__c='test';
        vdp.Savings_Month_1__c = 1000;
        vdp.Business_Type__c = 'IWT (Water)';
        vdp.Value_Focus_Area__c = 'Autoclave';
           
  
        
        acct5.SAP_Sales_Office__c='';
        acct5.SAP_SalesGroup__c=''; 
        acct5.SAP_SalesDistrict__c='IWNA1';
        Update acct5;
        
           ValueAdvantage__c vd = New ValueAdvantage__c();
        vd.Name='Test';
        vd.Customer__c=acct5.Id;
        vd.CurrencyIsoCode='USD';
        vd.Approver__c='00550000003XlDL';
        vd.Project_Status__c='Rejected';
        vd.Approval_Status__c='Completed';
        vd.Actual_Date_Completed__c=System.today();
        vd.Savings_Type__c='Cost Savings';
        vd.Customer_Value_Type__c='Raw Material';
        vd.Problem_Statement__c='test test';
        vd.Solenis_Recommendation__c='test';
        vd.Value_Proposition__c='test';
        vd.Customer_Value_Type_Cost_Savings__c = 'Environmental (CO2 t/Yr)' ;  
        vd.Total_Environmental_Savings__c = 23 ; 
        vd.Customer_Team__c = 'Test';
        vd.Learnings__c='test';
        vd.Savings_Month_1__c = 1000;
        vd.Business_Type__c = 'IWT (Water)';
        vd.Value_Focus_Area__c = 'Autoclave';
           
      
           
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        
       
            
           valueAdvantageFinalList.add(vdp);
           valueAdvantageFinalList.add(vd);
           Test.startTest();
           ValueAdvantageTriggerHandler.afterUpdateTrigger(valueAdvantageFinalList,valueAdvantageFinalMap);
            ValueAdvantageTriggerHandler.updateStatus(valueAdvantageFinalList,valueAdvantageFinalMap);

         insert valueAdvantageFinalList;
             ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = valueAdvantageFinalList[0].id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            insert cdl;
             ValueAdvantageTriggerHandler.updateStatus(valueAdvantageFinalList,valueAdvantageFinalMap);
           Test.StopTest();
        }
        
       

    }