/** 
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest
private class Test_BatchCloseCase {
    static Id ESRRecordType = RecordType_Functions.LookupRecordTypeId('ESR-Preventative Maintenance', 'Case');
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        //setUpData();
        User LoggedUser=[Select Id,email from User where Id=:Userinfo.getUserId()];
        string emailAddress = LoggedUser.email;
        Id userId = LoggedUser.Id;
        setUpData2(userId,emailAddress);
        WorkOrder testWO=[select Id,(Select Id from WorkOrderLineItems) from WorkOrder Limit 1];
        //system.assertEquals(testWO.WorkOrderLineItems.size(),1);
        testWO.Status='Completed';
        testWO.FSO__Completed_Date__c=System.now();
        Update testWO;
        Case c=[Select Id, Status from Case Limit 1];
        c.Status = 'In Scheduling';
        update c; 
        System.debug('testWO'+testWO);
        system.runAs(LoggedUser)
        {
            Test.startTest();
            System.debug('Start Batch Test');
            Database.BatchableContext BC;
            Schedulablecontext sc;
            
            ScheduleCloseCase srcalc=new ScheduleCloseCase();
            srcalc.testMode=true;
            srcalc.execute(sc);
            //Case c=[Select Id, Status from Case Limit 1];
            //system.assertEquals(c.Status,'Completed');
            System.debug('vinu>>>case'+c);
            //system.assertEquals(testWO.Status,'Completed');
            string batchQuery1='Select Id,CaseId from WorkOrder where Status=\'Completed\' and case.status= \'In Scheduling\' and Completed_Date_Formula__c <= TODAY';
            BulkCloseCase b = new BulkCloseCase(batchQuery1);
            database.executebatch(b);
            Test.stopTest();
        }   
    }
    private static void setUpData()
    {    
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
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
        
        Case cas = new Case();
        cas.AccountId = rec.Id;
        cas.RecordTypeId = ESRRecordType;
        cas.Subject = 'test case';
        cas.Status='In Scheduling';
        insert cas;
        
        FSO__WorkPlan__c wPlan=new FSO__WorkPlan__c(Name='test');
        insert wPlan;
        
        FSO__WorkPlanItem__c woitem=new FSO__WorkPlanItem__c(Name='Test-Step-1',FSO__WorkPlan__c=wPlan.Id,
                                                             FSO__Description__c='Test',FSO__Order__c=1);
        insert woitem;
        
        
        WorkOrder wo=new WorkOrder(CaseId=cas.Id,
                                   Description='Test',StartDate=System.today(),Subject='Test',
                                   Frequency__c='12',
                                   Has_Annual_Add_on_Tasks__c=true,
                                   Annual_Addon_Work_Plan__c=wPlan.Id
                                  );
        insert wo;    
        
    }
    
    private static void setUpData2(Id userId, string emailAddress)
    {    
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        insert p;
        Account rec=new Account(); 
        rec.Name = 'Test Account 2';
        rec.recordtypeId = '01250000000HmZV';
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
        rec.Hours_of_Access__c='9 to 17';
        rec.PPE_Requirements__c='Ear Plugs';
        rec.Site_Access__c='BackGround Check';
        rec.Account_Number__c = rec.Name + rec.SAP_Sales_Org__c + rec.SAP_DistChannel__c + rec.SAP_DivisionCode__c;
        rec.OwnerId = userId;
        rec.ShippingStreet = 'test street';
        //rec.Owner__r.Email  ='vinu.sankaralingam@techmahindra.com';
        //system.debug('rec.Owner.Email'+rec.Owner.Email);
        insert rec;
        system.debug('OwnerId '+rec.OwnerId);
        System.debug('Inserted'+rec);
        System.debug('Inserted'+rec.Owner__r.Email);
        
        Case cas = new Case();
        cas.AccountId = rec.Id;
        cas.RecordTypeId = ESRRecordType;
        cas.Subject = 'test case';
        cas.Status='In Scheduling';
        cas.EngineerRegion__c = 'EMEA';
        insert cas;
        
        FSO__WorkPlan__c wPlan=new FSO__WorkPlan__c(Name='test');
        insert wPlan;
        
        FSO__WorkPlanItem__c woitem=new FSO__WorkPlanItem__c(Name='Test-Step-1',FSO__WorkPlan__c=wPlan.Id,
                                                             FSO__Description__c='Test',FSO__Order__c=1);
        insert woitem;
        
        
        WorkOrder wo=new WorkOrder(CaseId=cas.Id,
                                   Description='Test',StartDate=System.today(),Subject='Test',
                                   Frequency__c='12',
                                   Has_Annual_Add_on_Tasks__c=true,
                                   Annual_Addon_Work_Plan__c=wPlan.Id,AccountId= rec.Id
                                  );
        insert wo;    
        string batchQuery='Select Id,CaseId from WorkOrder where Status=\'Completed\' and case.status= \'In Scheduling\' and Completed_Date_Formula__c <= TODAY';
       // Test.startTest();
        BatchCloseCase bcc=new BatchCloseCase(batchQuery);
        DataBase.executeBatch(bcc);
        //Test.stopTest();
    }
}