@isTest
public class Sales_Plan_Test {

    static Account                 acc;
    static Material_Sales_Data2__c mat;
    static Account_Sales_Plan__c   asp;
    static Product_Sales_Plan__c   psp;

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }
    
    static void createTestData() {
        acc = new Account(Name='Test Account1');
        acc.AccountNumber = '0000123456';
        acc.Account_Number__c = '000012345612341011';
        insert acc;
        debug('acc : ' + acc);

        mat = Material_Sales_Data_Functions_Test.getTestMsd2();
        debug('mat : ' + mat);

        asp = new Account_Sales_Plan__c();
        asp.Account_Number__c = acc.AccountNumber;
        asp.SoldTo_Number__c = acc.AccountNumber;
        asp.SalesOrg_Code__c = '1234';
        asp.DistChan_Code__c = '10';
        asp.Division_Code__c = '11';
        asp.CustomerType__c = 'ShipTo';
        asp.FiscalPeriod__c = '9999001';
        asp.RecordType__c = 'CM';
        asp.Sales_Amount_Company__c = 1000;
        asp.Sales_Amount_Local__c = 1000;
        asp.Sales_Volume__c = 2000;
        asp.Sales_Volume_UOM__c = 'LB';
        asp.Key__c = 'TestKey1';
        insert asp;

        psp = new Product_Sales_Plan__c();
        psp.Account_Number__c = acc.AccountNumber;
        psp.Material_Number__c = mat.Material_Number__c;
        psp.SalesOrg_Code__c = '1234';
        psp.DistChan_Code__c = '10';
        psp.Division_Code__c = '11';
        psp.Record_Status__c = Sales_Plan_Functions.ACTIVE;
        psp.Sales_Volume_CY__c = 10000;
        psp.Sales_Volume_UOM_CY__c = 'LB';
        psp.Sales_Volume_NY__c = 20000;
        psp.Sales_Volume_UOM_NY__c = 'LB';
        psp.Key__c = 'TestKey1';
        insert psp;
        psp = [select Account__c, Material__c 
                 from Product_Sales_Plan__c 
                where Id = :psp.Id];
    }
    
    public static Product_Sales_Plan__c getProductSalesPlan() {
    	createTestData(); return psp;
    }
    
    static testMethod void test01() {
        createTestData();
        Test.startTest();
        PaginationController pc = Sales_Plan_Functions.getProductPlansPC(acc.Id);
        List<Product_Sales_Plan__c> alist = pc.getRecords();
        alist = Sales_Plan_Functions.createNextYearProdPlans(alist);
        Sales_Plan_Functions.activateNextYearProdPlans(alist);
    }
    
}