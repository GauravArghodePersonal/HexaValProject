@isTest(seeAllData = false)
private class FSL_serviceAppointmentHandlerTest {
    static testMethod void insertServiceAppointment() {
        Test.startTest();
        try{
        List <PriceFx__c> pfxCustomList = new List <PriceFx__c>();
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        insert pfxCustomList;
        
        //Account Creation
        Account rec=new Account(); 
        rec.Name = 'Test Account 2';
        rec.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('DrewCustomer').getRecordTypeId();
        rec.SAP_Zip_Code__c = '43081';
        rec.Account_Sales_Potential_Amount_Year__c = 52;
        rec.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        rec.Prospect_Dist_Channel__c = 'AHWT (10)';
        rec.Prospect_Division__c = 'AWT (11)';
        rec.Prospect_Sales_District__c = 'RSD IWT NA (IWNA1)';
        rec.Prospect_Sales_Office__c = 'DM  IWT NA CENTRAL (IW35)';
        rec.Prospect_Sales_Group__c = 'IWT NA ARKLATEX (27I)';
        rec.Prospect_Customer_Group__c = 'POWER (1J)';
        rec.Prospect_Customer_Group1__c = 'THIRD PARTY PRODUCER (510)';
        rec.Prospect_Customer_Group2__c = 'PWR-Coal (191)';
        rec.Related_to_Corporate__c = 'No';
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
        //rec.Hours_of_Access__c='9 to 17';
        //rec.PPE_Requirements__c='Ear Plugs';
        //rec.Site_Access__c='BackGround Check';
        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
        rec.ShippingStreet = 'test street';
        //rec.Owner__r.Email  ='vinu.sankaralingam@techmahindra.com';
        //system.debug('rec.Owner.Email'+rec.Owner.Email);
        Account rec2 = rec.clone(false, false, false, false);
        rec2.Hours_of_Access__c='9 to 17';
        rec2.PPE_Requirements__c='Ear Plugs';
        rec2.Site_Access__c='BackGround Check';
        List<Account>acLst = new List<Account>();
        acLst.add(rec);
        acLst.add(rec2);
        insert acLst;
        acLst.clear();
        rec.Hours_of_Access__c='9 to 17';
        rec.PPE_Requirements__c='Ear Plugs';
        rec.Site_Access__c='BackGround Check';
        acLst.add(rec);
        update acLst;
        
        // Asset Creation
        Asset a = new Asset();
        a.AccountId = rec.id;
        a.Name = 'Test Asset';
        Insert a;
        
        
        Workorder w = new Workorder();
        w.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('ESR_New_Install').getRecordTypeId();
        w.AccountId = rec.id;
        w.AssetId = a.id;
        w.Subject = 'test';
        w.Description_of_work_to_be_done_del__c = 'Test Data';
        w.Product_ESR__c = 'Yes';
        w.Is_an_Initial_Scope_Visit_Required__c = 'Yes';
        w.EngineerRegion__c = 'NA';
        w.Equipment_Type1__c = 'Audit';
        //w.Requested_Installation_Date__c = System.now();
        w.FSL_Requested_Installation_Date__c = System.now();
        w.Is_Date_Flexible__c = 'Yes';
        w.Is_Equipment_on_Site__c = 'Yes';
        Insert w;
        
        
        
        // Service Appointment creation
        List<ServiceAppointment>saLst = new List<ServiceAppointment>();
        ServiceAppointment s = new ServiceAppointment();
        s.ParentRecordId = w.id;
        ServiceAppointment s2 = new ServiceAppointment();
        s2.ParentRecordId = w.id;
        saLst.add(s);
        saLst.add(s2);
        insert saLst;
        saLst.clear();
        s.status='Scheduled';
        s2.status='Scheduled';
        saLst.add(s);
        saLst.add(s2);
        update saLst;
        saLst.clear();
        s.status='Dispatched';
        s2.status='Dispatched';
        saLst.add(s);
        saLst.add(s2);
        update saLst;
        saLst.clear();
        s.status='In Progress';
        s2.status='In Progress';
        saLst.add(s);
        saLst.add(s2);
        update saLst;
        saLst.clear();
        s.Travel_Time__c =20 ;
        s.Work_Time__c = 50;
        s.Target_Return_Date__c = system.today().adddays(5);
        s.status = 'Cannot Complete';
        s.Create_another_Service_Appointment__c='Yes';
        s2.Travel_Time__c =20 ;
        s2.Work_Time__c = 50;
        s2.status = 'Completed';        
        saLst.add(s);
        saLst.add(s2);
        update saLst;
        saLst.clear();
        }
        catch (DMLException e) {
    	System.debug(e.getMessage());
		}
         Test.stopTest();
    }
    
     static testMethod void insertServiceAppointment2() {
        Test.startTest();
         try{
        List <PriceFx__c> pfxCustomList = new List <PriceFx__c>();
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        insert pfxCustomList;
        
        //Account Creation
        Account rec=new Account(); 
        rec.Name = 'Test Account 2';
        rec.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('DrewCustomer').getRecordTypeId();
        rec.SAP_Zip_Code__c = '43081';
        rec.Account_Sales_Potential_Amount_Year__c = 52;
        rec.Prospect_Sales_Org__c = 'Solenis LLC(1020)';
        rec.Prospect_Dist_Channel__c = 'AHWT (10)';
        rec.Prospect_Division__c = 'AWT (11)';
        rec.Prospect_Sales_District__c = 'RSD IWT NA (IWNA1)';
        rec.Prospect_Sales_Office__c = 'DM  IWT NA CENTRAL (IW35)';
        rec.Prospect_Sales_Group__c = 'IWT NA ARKLATEX (27I)';
        rec.Prospect_Customer_Group__c = 'POWER (1J)';
        rec.Prospect_Customer_Group1__c = 'THIRD PARTY PRODUCER (510)';
        rec.Prospect_Customer_Group2__c = 'PWR-Coal (191)';
        rec.Related_to_Corporate__c = 'No';
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
        //rec.Hours_of_Access__c='9 to 17';
        //rec.PPE_Requirements__c='Ear Plugs';
        //rec.Site_Access__c='BackGround Check';
        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
        rec.ShippingStreet = 'test street';
        //rec.Owner__r.Email  ='vinu.sankaralingam@techmahindra.com';
        //system.debug('rec.Owner.Email'+rec.Owner.Email);
        Account rec2 = rec.clone(false, false, false, false);
        rec2.Hours_of_Access__c='9 to 17';
        rec2.PPE_Requirements__c='Ear Plugs';
        rec2.Site_Access__c='BackGround Check';
        List<Account>acLst = new List<Account>();
        acLst.add(rec);
        acLst.add(rec2);
        insert acLst;
        acLst.clear();
        rec.Hours_of_Access__c='9 to 17';
        rec.PPE_Requirements__c='Ear Plugs';
        rec.Site_Access__c='BackGround Check';
        acLst.add(rec);
        update acLst;
        
        // Asset Creation
        Asset a = new Asset();
        a.AccountId = rec.id;
        a.Name = 'Test Asset';
        Insert a;
        
        
        Workorder w = new Workorder();
        w.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('ESR_New_Install').getRecordTypeId();
        w.AccountId = rec.id;
        w.AssetId = a.id;
        w.Subject = 'test';
        w.Description_of_work_to_be_done_del__c = 'Test Data';
        w.Product_ESR__c = 'Yes';
        w.Is_an_Initial_Scope_Visit_Required__c = 'Yes';
        w.EngineerRegion__c = 'NA';
        w.Equipment_Type1__c = 'Audit';
        //w.Requested_Installation_Date__c = System.now();
        w.FSL_Requested_Installation_Date__c = System.now();
        w.Is_Date_Flexible__c = 'Yes';
        w.Is_Equipment_on_Site__c = 'Yes';
        Insert w;
        
        
        
        // Service Appointment creation
        List<ServiceAppointment>saLst = new List<ServiceAppointment>();
        ServiceAppointment s = new ServiceAppointment();
        s.ParentRecordId = w.id;
        ServiceAppointment s2 = new ServiceAppointment();
        s2.ParentRecordId = w.id;
        saLst.add(s);
        saLst.add(s2);
        insert saLst;
        saLst.clear();
        s.status='Scheduled';
        s2.status='Scheduled';
        saLst.add(s);
        saLst.add(s2);
        update saLst;
        saLst.clear();
        s.status='Dispatched';
        s2.status='Dispatched';
        saLst.add(s);
        saLst.add(s2);
        update saLst;
        saLst.clear();
        s.status='In Progress';
        s2.status='In Progress';
        saLst.add(s);
        saLst.add(s2);
        update saLst;
        saLst.clear();
        s.Travel_Time__c =20 ;
        s.Work_Time__c = 50;
        s.Target_Return_Date__c = system.today().adddays(5);
        s.Create_another_Service_Appointment__c='Yes';      
        s2.Travel_Time__c =20 ;
        s2.Work_Time__c = 50;
        s2.Create_another_Service_Appointment__c='Yes';
        s2.status = 'Completed';        
        saLst.add(s);
        saLst.add(s2);
        update saLst;
        saLst.clear();
         }catch (DMLException e) {
    	System.debug(e.getMessage());
		}
         Test.stopTest();
    }
}