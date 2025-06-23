@isTest
private class PricingSurcharge_Test {

    static String PARAM_ACCOUNT_ID   = PricingSurcharge_Controller.PARAM_ACCOUNT_ID;
    static String PARAM_SRCHRGBRK_ID = PricingSurcharge_Controller.PARAM_SRCHRGBRK_ID;

    static Account acc1;
    static SAP_Plant__c sp1;
    static SAP_UOM_Description__c uom1;
    static Pricing_Surcharge__c ps1;
    static Pricing_Surcharge_Break__c psb1;
    static List<Pricing_Surcharge_Break__c> psbList;
    static Map<String, String> params;

    static PageReference pageRef1A = Page.PricingSurcharge_Page_1A;
    static PricingSurcharge_Controller psc = new PricingSurcharge_Controller();

    static String accName = 'TestAccount';
    static String plantCode = '1234';
    static String plantName = 'TestPlant';
    static String uomCode = 'KG';
    static String uomDesc = 'KG';

    static void setup() {
        acc1 = new Account(Name=accName, SAP_ShippingPlant__c=plantCode);
        insert acc1;
        acc1 = [select Id, Name, AccountNumber from Account
                 where Id = :acc1.Id];

        sp1 = new SAP_Plant__c();
        sp1.Plant_Code__c = plantCode;
        sp1.Plant_Name__c = plantName;
        insert sp1;

        uom1 = new SAP_UOM_Description__c();
        uom1.UOM_Code__c = uomCode;
        uom1.UOM_Description__c = uomDesc;
        insert uom1;

        ps1 = new Pricing_Surcharge__c();
        ps1.Account__c = acc1.Id;
        ps1.SAP_Plant__c = sp1.Id;
        ps1.Record_Key__c = psc.getSurchargeKey(acc1.AccountNumber, plantCode);
        insert ps1;

        psb1 = new Pricing_Surcharge_Break__c();
        psb1.Pricing_Surcharge__c = ps1.Id;
        psb1.Scale_Qty__c = 0;
        psb1.Record_Key__c = psc.getSrchrgBrkKey(ps1, psb1.Scale_Qty__c);
        insert psb1;

        psbList = new List<Pricing_Surcharge_Break__c>(); psbList.add(psb1);
    }

    static void addPsb1(Double d) {
        psb1 = new Pricing_Surcharge_Break__c();
        psb1.Scale_Qty__c = d;
        psbList = new List<Pricing_Surcharge_Break__c>(); psbList.add(psb1);
    }

    static testmethod void test01() {
        Test.startTest(); setup();
        params = pageRef1A.getParameters();
        params.put(PARAM_ACCOUNT_ID, acc1.Id);
        Test.setCurrentPage(pageRef1A);
        psc = new PricingSurcharge_Controller(); psc.initAction();
        psc.plantCode = plantCode; psc.uomCode = uomCode;
        psc.cancel1(); psc.find1(); psc.add1(); psc.add1();
        psc.rowNum1 = psc.scales.size(); psc.del1(); psc.save1();
        psc.delete1(psbList); addPsb1(10); psc.insert1(psbList);
        psc.setSurcharge(); psc.initSurcharge(); psc.setSurchargeFields();
        Test.stopTest();
    }
}