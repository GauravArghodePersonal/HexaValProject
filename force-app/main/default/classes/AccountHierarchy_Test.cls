@IsTest
public class AccountHierarchy_Test {
    public static Account shipTo, soldTo, corporateAccount, ultimateAccount;
    public static SAP_ECOM_Customer__c sapECOMCustomer;
    static String so = '1234';
    static String dc = '12';
    static String dv = '12';

    static void debug(String debugLine) {
        System.debug(LoggingLevel.INFO, debugLine);
    }

    static Account createAccount(String accountNumber, String parentId) {
        Account a = new Account();
        a.Name = accountNumber;
        a.AccountNumber = accountNumber;
        a.Account_Number__c = accountNumber + so + dc + dv;
        insert a;
        return a;
    }

    static SAP_ECOM_Customer__c createEcomCustomer() {
        SAP_ECOM_Customer__c a = new SAP_ECOM_Customer__c();
        a.Ship_To__c = shipTo.Id;
        a.Ship_Account__c = shipTo.AccountNumber;
        a.Sold_To__c = soldTo.Id;
        a.Sold_Account__c = soldTo.AccountNumber;
        a.Hier__c = corporateAccount.Id;
        a.Hier_Account__c = corporateAccount.AccountNumber;
        a.Ship_Sup_Account__c = ultimateAccount.Id;
        a.Ship_Sup_Number__c = ultimateAccount.AccountNumber;
        a.Key__c = ultimateAccount.AccountNumber + '-' +
            corporateAccount.AccountNumber + '-' +
            soldTo.AccountNumber + '-' +
            shipTo.AccountNumber;

        insert a;
        return a;
    }

    public static void testSetup(){
        ultimateAccount = createAccount('ultimate', null);

        corporateAccount = createAccount('corporate', ultimateAccount.Id);
        corporateAccount.ParentId = ultimateAccount.Id;
        update corporateAccount;

        soldTo = createAccount('soldTo', corporateAccount.Id);
        soldTo.ParentId = corporateAccount.Id;
        update soldTo;

        shipTo = createAccount('shipTo', soldTo.Id);
        shipTo.ParentId = soldTo.Id;
        update shipTo;

        sapECOMCustomer = createEcomCustomer();        
    }

    @IsTest
    public static void testHierarchy_withInactiveAccounts() {
        //Creating PriceFx TestData;
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        List<String> priceNameList = new List<String>();
        priceNameList.add('callAccount');
        priceNameList.add('callMaterialSalesData2');
        priceNameList.add('callCustomerProductInfo2');
        priceNameList.add('callMaterialPlant2');

        for (Integer i = 0; i < 4; i++) {
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name = priceNameList[i];
            p.EndpointURL__c = 'https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c = 'Testuser@123';
            p.username__c = 'sfdctestuser';
            pfxCustomList.add(p);
        }

        insert pfxCustomList;

        testSetup();
        Test.startTest();
        AccountHierarchy aHierarchy = new AccountHierarchy(shipTo.Id, true);
        Test.stopTest();
    }

    @IsTest
    public static void testHierarchy_withoutInactiveAccounts() {
        //Creating PriceFx TestData;
        List<PriceFx__c> pfxCustomList = new List<PriceFx__c>();
        List<String> priceNameList = new List<String>();
        priceNameList.add('callAccount');
        priceNameList.add('callMaterialSalesData2');
        priceNameList.add('callCustomerProductInfo2');
        priceNameList.add('callMaterialPlant2');

        for (Integer i = 0; i < 4; i++) {
            PriceFx__c p = new PriceFx__c();
            p.allowed_recordtype_id__c = '01250000000HmZV';
            p.allowed_sales_org__c = '1020,1700,1031,0070,0310,0322,0330,0340,0410,0445,0460,0490,3580,XXX6,0430,0481,0390';
            p.Name = priceNameList[i];
            p.EndpointURL__c = 'https://b2bisqa.solenis.com:1200/rest/Pricefx.C..';
            p.password__c = 'Testuser@123';
            p.username__c = 'sfdctestuser';
            pfxCustomList.add(p);
        }

        insert pfxCustomList;

        testSetup();
        Test.startTest();
        AccountHierarchy aHierarchy = new AccountHierarchy(shipTo.Id, false);
        Test.stopTest();
    }

    @IsTest
    public static void testHierarchy_classes() {
        Test.startTest();
        AccountHierarchy.UltimateAccount uAccount = new AccountHierarchy.UltimateAccount();
        AccountHierarchy.CorporateAccount cAccount = new AccountHierarchy.CorporateAccount();
        AccountHierarchy.SoldToAccount soldToAccount = new AccountHierarchy.SoldToAccount();
        AccountHierarchy.ShipToAccount shipToAccount = new AccountHierarchy.ShipToAccount();
        Test.stopTest();
    }

}