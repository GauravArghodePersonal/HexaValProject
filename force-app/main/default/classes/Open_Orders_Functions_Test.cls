@isTest
private class Open_Orders_Functions_Test {

    static Account acc;
    static List<Open_Orders__c> openOrders;
    static List<Material_Sales_Data2__c> mats;
    static String salesOrg = '1021';
    static String distChan = '50';
    static List<String> matNums = new List<String>{'mat1', 'mat2'};

    static void setup() {
        acc = new Account(Name='testAcc');
        insert acc;

        mats = Material_Sales_Data_Functions_Test.getTestMsd2s(salesOrg, distChan, matNums);

        openOrders = new List<Open_Orders__c>(); Open_Orders__c o;
        for (Material_Sales_Data2__c m : mats) {
            o = new Open_Orders__c();
            o.ShipTo__c = acc.Id; o.Material__c = m.Id;
            o.Sales_Order_Number__c = m.Material_Number__c;
            o.Line_Item_Number__c = m.Material_Number__c;
            o.Key__c = m.Material_Number__c;
            o.Seller__c = UserInfo.getUserId();
            o.Expected_Ship_Date__c = '2012-12-12';
            o.Delivery_Date__c = '2012-12-12';

            openOrders.add(o);
        }
        insert openOrders;
    }

    static testMethod void test01() {
        setup();
        Open_Orders_Functions.emailOnCreditHoldRelease(openOrders);
    }

//*
    static testMethod void test02() {
        Test.startTest();
        Reorder__c r = new Reorder__c();
        r.Customer_PO_Number__c = 'Test';
        r.Expected_Ship_Date__c = Date.today();
        r.Requested_Delivery_Date__c = Date.today();
        insert r;
        r = [select Expected_Ship_Date__c, Expected_Ship_Date2__c,
                    Requested_Delivery_Date__c, Requested_Delivery_Date2__c
            from Reorder__c where Id = :r.Id
            ];
        System.debug(r.Expected_Ship_Date__c + ' --> ' + r.Expected_Ship_Date2__c);
        System.debug(r.Requested_Delivery_Date__c + ' --> ' + r.Requested_Delivery_Date2__c);
    }
//*/
}