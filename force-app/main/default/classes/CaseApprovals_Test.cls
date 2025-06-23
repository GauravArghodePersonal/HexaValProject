@isTest
private class CaseApprovals_Test {

    static Account acc;
    static Case cas;
    static Id dzTypeId = RecordType_Functions.LookupRecordTypeId('AHWT DZ', 'Case');

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, s);
    }

    static void setup() {
        acc = new Account(Name='TestAcc');
        acc.SAP_Sales_Org__c = '1020';
        acc.SAP_DistChannel__c = '50';
        acc.SAP_DivisionCode__c = '50';
        insert acc; debug('Account : ' + acc);

        cas = new Case();
        cas.AccountId = acc.Id;
        cas.DZ_Number__c = '123456';
        cas.RecordTypeId = dzTypeId;
        cas.Subject = 'test case';
        cas.Submit_on_Save__c = false;
        insert cas;
        cas = [select Id, CreatedDate, Account.Name, Account.AccountNumber,
                      DevEx_Transfer_Status__c, DZ_Number__c, Subject,
                      Submit_on_Save__c
                 from Case where Id = :cas.Id];
    }

    static testMethod void test01() {
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
        Boolean b = CaseCustomSettings__c.getInstance().Lab_Work_Approver__c;
        debug('Lab_Work_Approver = ' + b);
        CaseApprovals.Rec r = new CaseApprovals.Rec(cas, 1);
        CaseApprovals c = new CaseApprovals();
        c.debug(''); c.getRecs(); c.init1(); c.init2(); c.initActionTSR();
        c.pc1Frst(); c.pc1Next(); c.pc1Prev(); c.pc1Last();
        try {c.pc1Size();} catch(Exception e){}
        c.onCreateDevexProj(); c.onCreateDevexProjAll(); c.addErrorMessage('');
        c.approveSelectedList(); c.rejectSelectedList();
        c.sortByAccName(); c.sortByCaseNumber(); c.sortByDevexPM(); c.sortByLabTech();
        c.sortByPriority(); c.sortByReason(); c.sortBySubject(); c.sortByTechRisk();
    }
}