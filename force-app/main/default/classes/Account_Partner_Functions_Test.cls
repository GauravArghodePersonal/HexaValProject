@isTest
public class Account_Partner_Functions_Test {

    public static Account shipto, soldto, cherky, ultmtp;
    public static SAP_ECOM_Customer__c secomc;
    static String so = '1234';
    static String dc = '12';
    static String dv = '12';
    
    static void debug(String s) {System.debug(LoggingLevel.INFO, s);}
    
    public static void setup() {
        ultmtp = createAccount('ultmtp', null);
        cherky = createAccount('cherky', ultmtp.Id);
        cherky.ParentId = ultmtp.Id; update cherky;
        soldto = createAccount('soldto', cherky.Id);
        soldto.ParentId = cherky.Id; update soldto;
        shipto = createAccount('shipto', soldto.Id);
        shipto.ParentId = soldto.Id; update shipto;
        secomc = createEcomCust();
    }
    
    static Account createAccount(String accNum, String parentId) {
        Account a = new Account();
        a.Name = accNum; a.AccountNumber = accNum; 
        a.Account_Number__c = accNum + so + dc + dv;
        //if (parentId != null) {a.ParentId = parentId;}
        insert a; debug('a = ' + a); return a;
    }
    
    static SAP_ECOM_Customer__c createEcomCust() {
        SAP_ECOM_Customer__c a = new SAP_ECOM_Customer__c();
        a.Ship_To__c          = shipto.Id; a.Ship_Account__c    = shipto.AccountNumber;
        a.Sold_To__c          = soldto.Id; a.Sold_Account__c    = soldto.AccountNumber;
        a.Hier__c             = cherky.Id; a.Hier_Account__c    = cherky.AccountNumber;
        a.Ship_Sup_Account__c = ultmtp.Id; a.Ship_Sup_Number__c = ultmtp.AccountNumber;
        a.Key__c = ultmtp.AccountNumber + '-' +
                   cherky.AccountNumber + '-' +
                   soldto.AccountNumber + '-' +
                   shipto.AccountNumber;
        insert a; debug('a = ' + a); return a;
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
        Test.startTest();
        Account_Partner_Functions.getAccountHierarchy(shipto.Id, true);
        Account_Partner_Functions.getUltimateParentId(shipto.Id);
        Set<Id> accIds = new Set<Id>{shipto.Id, soldto.Id};
        Account_Partner_Functions.getParentIds(shipto.Id);
        Account_Partner_Functions.getSoldTo(shipto.Id);
        Account_Partner_Functions.getShipToIds(soldto.Id);
        Account_Partner_Functions.isSoldTo(''+soldto.Id);
        Account_Partner_Functions.getSoldTos(accIds);
        Account_Partner_Functions.getPaymentTermCode(shipto.Id);
        Account_Partner_Functions.getAccountType(shipto.Id);
        Account_Partner_Functions.debug('test');
        Test.stopTest();
    }
}