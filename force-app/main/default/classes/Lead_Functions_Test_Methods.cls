@isTest
private class Lead_Functions_Test_Methods {

    static Account taccount;
    static Contact tcontact;
    static Lead tlead;
    
    static void debug(String s) {System.debug(LoggingLevel.INFO, s);}
    
    static void setup() {
        taccount = new Account(Name='testAcc');
        insert taccount;
        
        tcontact = new Contact(LastName='lname');
        tcontact.AccountId = taccount.Id;
        insert tcontact;
        
        tlead = new Lead();
        tlead.FirstName = 'fname';
        tlead.LastName = 'lname';
        tlead.Company = 'company';
        tlead.DoNotCall = true;
        insert tlead;
        debug('tlead : ' + tlead);
    }

//*    
    static testMethod void myUnitTest() {
        Test.startTest();
        Map<String, Schema.RecordTypeInfo> RTMap = Lead.sObjectType.getDescribe().getRecordTypeInfosByName();
        Lead newLead = new Lead();
        newLead.FirstName = 'Jon';
        newLead.LastName = 'Keener';
        newLead.Street = 'Street'; newLead.City = 'City'; 
        newLead.State = 'OH'; newLead.PostalCode = '99999';     
        AshlandWebSiteLeadInsertResults result1 = Lead_Functions.createAshlandWebSiteLead(newLead);

        newLead.Company = 'ABC Company';
        AshlandWebSiteLeadInsertResults result2 = Lead_Functions.createAshlandWebSiteLead(newLead);
        
        System.assertEquals(result1.result,false);  
        System.assertEquals(result2.result,true);
        
        List<RecordType> RTList = [select id, name, BusinessProcessId from RecordType where name in :RTMap.keyset() and isactive = true];
        List<Lead> LeadList = new List<Lead>();
        
        for(RecordType r:RTList)
        {
        Lead NewLead2 = NewLead.clone(false);
        newLead2.recordtypeid = RTMap.get(r.name).getrecordtypeid();   
        system.debug('RecordType: ' + r.name + ' - ' + RTMap.get(r.name).getrecordtypeid());
        LeadList.add(NewLead2);
        }
        
        Lead_Trigger_Functions.processBeforeInsert(LeadList);

        List<LeadStatus> convertedstatuses= [select id, MasterLabel from LeadStatus where IsConverted = true limit 2];
        insert LeadList;
        
        Map<String, Schema.RecordTypeInfo> RTMapCon = Consumption__c.sObjectType.getDescribe().getRecordTypeInfosByName();

       Lead_Trigger_Functions.LeadOnConvert(leadlist);
       
        for(Lead l:leadlist){
          for(LeadStatus LS:convertedstatuses){
            Try{       
             Database.LeadConvert lc = new database.LeadConvert();
             lc.setLeadId(l.id);
             lc.setConvertedStatus(LS.MasterLabel);
             Database.LeadConvertResult lcr = Database.convertLead(lc);
             Lead_Trigger_Functions.createConsumptionFromLead(l, RTMap, RTMapCon);
            }  
            catch(Exception e) { system.debug('Error: ' + e);}
          }
       }
       
       //Test.stopTest();
   }
   
    static testMethod void test02() {
    
//Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        
        
        
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = '01250000000HmZV';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        pfxCustomList.add(p1);
        
        PriceFx__c p2 = new PriceFx__c();
        p2.allowed_recordtype_id__c = '01250000000HmZV';
        p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p2.Name='callCustomerProductInfo2';
        p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p2.password__c='Testuser@123';
        p2.username__c='sfdctestuser';
        pfxCustomList.add(p2);
        
        PriceFx__c p3 = new PriceFx__c();
        p3.allowed_recordtype_id__c = '01250000000HmZV';
        p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p3.Name='callMaterialPlant2';
        p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p3.password__c='Testuser@123';
        p3.username__c='sfdctestuser';
        pfxCustomList.add(p3);
        
        insert pfxCustomList;

        setup();
        String page1 = '/apex/leadconversionprocess';
        PageReference pr1 = new PageReference(page1);
        Test.setCurrentPageReference(pr1);
        Map<String, String> pmap = ApexPages.currentPage().getParameters();
        pmap.put('id', tlead.id);
        leadconversionprocessclass c = new leadconversionprocessclass();
        c.lsource = true; c.createtask = true;
        c.app = taccount.Id; c.convalue = tcontact.Id;
        c.getcontact(); c.ConvertToAccount(); c.BackToLead();
    }
//*/
   
    static testMethod void test03() {
    
//Creating PriceFx test data
        
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        
        
        PriceFx__c p = new PriceFx__c();
        p.allowed_recordtype_id__c = '01250000000HmZV';
        p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p.Name='callAccount';
        p.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p.password__c='Testuser@123';
        p.username__c='sfdctestuser';
        pfxCustomList.add(p);
        
        
        
        PriceFx__c p1 = new PriceFx__c();
        p1.allowed_recordtype_id__c = '01250000000HmZV';
        p1.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p1.Name='callMaterialSalesData2';
        p1.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p1.password__c='Testuser@123';
        p1.username__c='sfdctestuser';
        pfxCustomList.add(p1);
        
        PriceFx__c p2 = new PriceFx__c();
        p2.allowed_recordtype_id__c = '01250000000HmZV';
        p2.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p2.Name='callCustomerProductInfo2';
        p2.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p2.password__c='Testuser@123';
        p2.username__c='sfdctestuser';
        pfxCustomList.add(p2);
        
        PriceFx__c p3 = new PriceFx__c();
        p3.allowed_recordtype_id__c = '01250000000HmZV';
        p3.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
        p3.Name='callMaterialPlant2';
        p3.EndpointURL__c='https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
        p3.password__c='Testuser@123';
        p3.username__c='sfdctestuser';
        pfxCustomList.add(p3);
        
        insert pfxCustomList;

        setup();
        String page1 = '/apex/leadprocessextn';
        PageReference pr1 = new PageReference(page1);
        Test.setCurrentPageReference(pr1);
        Map<String, String> pmap = ApexPages.currentPage().getParameters();
        pmap.put('id', taccount.id);
        SalesDogUpdationClass c = new SalesDogUpdationClass();
        c.RedirecttoAccount(); c.dosave();
    }
}