@isTest
private class SalesOrderDeliveriesFunctions_Test {

    static Sample_Request__c sr1;
    static Sample_Material__c sm1;
    static Open_Orders__c oo1;
    static Sales_Order_Deliveries__c od1;
    
    static String ordrType = 'ABCD';

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>>>>> ' + s);
    }
    
    static void createTestData() {
        sr1 = Sample_Request_Functions_Test.getSampleRequest();
        sm1 = Sample_Request_Functions_Test.getSampleMaterial();
        debug('createTestData :1: sr1 = '+sr1);
        oo1 = new Open_Orders__c();
        oo1.Key__c = 'RecordKey1';
        oo1.SFDC_Sample_Request_Number__c = sr1.Name;       
        oo1.Material__c = sm1.SAP_Material_MSD2__c;
        oo1.ShipTo__c = sr1.Account__c;
        oo1.Line_Item_Number__c = '0001';
        oo1.Carrier_Tracking_Number__c = '0001';
        oo1.Sales_Order_Number__c = '0001';
        oo1.Sales_Doc_Type__c = ordrType;
        insert oo1;
        debug('createTestData :2: sr1 = '+sr1);
    }
    
    static testMethod void test01() {
        createTestData();
        Test.startTest();
        oo1.Goods_Issue_Date__c = '2012-12-12';
        oo1.Carrier_Tracking_Number__c = '0002';
        oo1.Sales_Order_Number__c = '0002';
        oo1.SFDC_Sample_Request_Number__c='SAMP_REQ_NAME12';
        update oo1;
    }
    
    static testMethod void test02() {
        createTestData();       
        
        od1 = new Sales_Order_Deliveries__c();
        od1.ShipTo__c = sr1.Account__c;
        od1.Material__c = sm1.SAP_Material_MSD2__c;
        od1.Open_Orders__c = oo1.Id;
        od1.Record_Key__c = 'RecordKey1';
        od1.Quantity_Shipped_in_BU__c = 10;
        od1.Quantity_Shipped_in_LB__c = 20;
        od1.UOM_Quantity_Shipped_in_BU__c = 'KG';
        //od1.Sample_Request_Number__c=123;
        insert od1;
        debug('createTestData :3: sr1 = '+sr1);
        Test.startTest();
        od1.Actual_Goods_Issue_Date_Text__c = '2012-12-12';
        od1.Actual_Goods_Issue_Date__c  = System.Today();
        od1.Carrier_PRO_Number__c = '0002';
        od1.Sales_Order_Number__c = '0002';
        od1.Shipment_Complete_Flag__c = 'X';
        update od1;
        Set<String> ordrTypes = new Set<String>{ordrType};
        Set<String> matIds = new Set<String>{od1.Material__c};
        Date d1 = Date.newInstance(2012,12,12), d2 = Date.newInstance(2012,12,12);
        //Map<String, Decimal> qmap = SalesOrderDeliveriesFunctions.getShippedQtys(od1.ShipTo__c, d1, d2, ordrTypes, matIds, 'LB');
        Map<String, Decimal> qmap1 = SalesOrderDeliveriesFunctions.getShippedQtys(od1.ShipTo__c, d1, d2, ordrTypes, matIds, 'LB', '12345','12345');
        Decimal d = SalesOrderDeliveriesFunctions.getShippedQty(qmap1 , od1.Material__c, ordrType);
        PaginationController pc = SalesOrderDeliveriesFunctions.getDeliveriesPC(od1.ShipTo__c, d1, d2, ordrType, od1.Material__c, 10);
        PaginationController pc1 = SalesOrderDeliveriesFunctions.getDeliveriesPC(od1.ShipTo__c, d1, d2, ordrType, matIds , 10, '12345','12345');
        List<Sales_Order_Deliveries__c> SOD = New List<Sales_Order_Deliveries__c>();
       // od1= TestDataFactory.create_Sales_Order_Deliveries(false);
        //od1.Record_Key__c='test22111';
        SOD.add(od1);
        SalesOrderDeliveriesFunctions.processBeforeUpsert(SOD);
        SalesOrderDeliveriesFunctions.processAfterUpsert(SOD);
    }
    static testMethod void test03() {
        createTestData();
         oo1.SFDC_Sample_Request_Number__c='SAMP_REQ_NAME12';
        update oo1;
        
        od1 = new Sales_Order_Deliveries__c();
        od1.ShipTo__c = sr1.Account__c;
        od1.Material__c = sm1.SAP_Material_MSD2__c;
        od1.Open_Orders__c = oo1.Id;
        od1.Record_Key__c = 'RecordKey1';
        od1.Quantity_Shipped_in_BU__c = 10;
        od1.Quantity_Shipped_in_LB__c = 20;
        od1.UOM_Quantity_Shipped_in_BU__c = 'KG';
        od1.Actual_Goods_Issue_Date__c  = System.Today();
        insert od1;
        debug('createTestData :3: sr1 = '+sr1);
        Test.startTest();
        od1.Actual_Goods_Issue_Date_Text__c = '2012-12-12';
        od1.Carrier_PRO_Number__c = '0002';
        od1.Sales_Order_Number__c = '0002';
        od1.Shipment_Complete_Flag__c = 'X';
        update od1;
        Set<String> ordrTypes = new Set<String>{ordrType};
        Set<String> matIds = new Set<String>{od1.Material__c};
        Date d1 = Date.newInstance(2012,12,12), d2 = Date.newInstance(2012,12,12);
        //Map<String, Decimal> qmap = SalesOrderDeliveriesFunctions.getShippedQtys(od1.ShipTo__c, d1, d2, ordrTypes, matIds, 'LB');
        Map<String, Decimal> qmap1 = SalesOrderDeliveriesFunctions.getShippedQtys(od1.ShipTo__c, d1, d2, ordrTypes, matIds, 'LB', '12345','12345');
        Decimal d = SalesOrderDeliveriesFunctions.getShippedQty(qmap1, od1.Material__c, ordrType);
        PaginationController pc = SalesOrderDeliveriesFunctions.getDeliveriesPC(od1.ShipTo__c, d1, d2, ordrType, od1.Material__c, 10);
        PaginationController pc1 = SalesOrderDeliveriesFunctions.getDeliveriesPC(od1.ShipTo__c, d1, d2, ordrType, matIds , 10, '12345','12345');
        List<Sales_Order_Deliveries__c> SOD = New List<Sales_Order_Deliveries__c>();
        od1= new Sales_Order_Deliveries__c(Sample_Material__c=sm1.id,Open_Orders__c=oo1.id,ShipTo__c=od1.ShipTo__c,
                                                   Record_Key__c='OrdrDlvryA', Actual_Goods_Issue_Date_Text__c='2013-11-01',
                                                   Quantity_Shipped_in_BU__c=1000, UOM_Quantity_Shipped_in_BU__c='KG');
        
        insert od1;
        SOD.add(od1);
        SalesOrderDeliveriesFunctions.processBeforeUpsert(SOD);
        SalesOrderDeliveriesFunctions.processAfterUpsert(SOD);
    }
    
    static testMethod void test04() {
        createTestData();
        od1 = new Sales_Order_Deliveries__c();
        /*od1= new Sales_Order_Deliveries__c(Sample_Material__c=sm1.id,Open_Orders__c=oo1.id,ShipTo__c=od1.ShipTo__c,
                                                   Record_Key__c='OrdrDlvryA', Actual_Goods_Issue_Date_Text__c='2013-11-01',
                                                   Quantity_Shipped_in_BU__c=1000, UOM_Quantity_Shipped_in_BU__c='KG');
        
        insert od1;*/
        
        od1.ShipTo__c = sr1.Account__c;
        od1.Material__c = sm1.SAP_Material_MSD2__c;
        od1.Open_Orders__c = oo1.Id;
        od1.Record_Key__c = 'RecordKey1';
        od1.Quantity_Shipped_in_BU__c = 10;
        od1.Quantity_Shipped_in_LB__c = 20;
        od1.Actual_Goods_Issue_Date__c=system.today()+1;
        od1.UOM_Quantity_Shipped_in_BU__c = 'KG';
        insert od1;
        debug('createTestData :3: sr1 = '+sr1);
        Test.startTest();
        od1.Actual_Goods_Issue_Date_Text__c = '2012-12-12';
        od1.Carrier_PRO_Number__c = '0002';
        od1.Sales_Order_Number__c = '0002';
        od1.Shipment_Complete_Flag__c = 'X';
        update od1;
        Set<String> ordrTypes = new Set<String>{ordrType};
        Set<String> matIds = new Set<String>{od1.Material__c};
        Date d1 = Date.newInstance(2021,5,5), d2 = Date.newInstance(2021,5,30);
        //Map<String, Decimal> qmap = SalesOrderDeliveriesFunctions.getShippedQtys(od1.ShipTo__c, d1, d2, ordrTypes, matIds, 'KG');
        Map<String, Decimal> qmap1 = SalesOrderDeliveriesFunctions.getShippedQtys(od1.ShipTo__c, d1, d2, ordrTypes, matIds, 'KG', '12345','12345');
        Decimal d = SalesOrderDeliveriesFunctions.getShippedQty(qmap1, od1.Material__c, ordrType);
        PaginationController pc = SalesOrderDeliveriesFunctions.getDeliveriesPC(od1.ShipTo__c, d1, d2, ordrType, od1.Material__c, 10);
        PaginationController pc1 = SalesOrderDeliveriesFunctions.getDeliveriesPC(od1.ShipTo__c, d1, d2, ordrType, matIds , 10, '12345','12345');
        List<Sales_Order_Deliveries__c> SOD = New List<Sales_Order_Deliveries__c>();
        
        SOD.add(od1);
        SalesOrderDeliveriesFunctions.processBeforeUpsert(SOD);
        SalesOrderDeliveriesFunctions.processAfterUpsert(SOD);
    }
    
    static testMethod void test05() {
        createTestData();
        od1 = new Sales_Order_Deliveries__c();
        /*od1= new Sales_Order_Deliveries__c(Sample_Material__c=sm1.id,Open_Orders__c=oo1.id,ShipTo__c=od1.ShipTo__c,
                                                   Record_Key__c='OrdrDlvryA', Actual_Goods_Issue_Date_Text__c='2013-11-01',
                                                   Quantity_Shipped_in_BU__c=1000, UOM_Quantity_Shipped_in_BU__c='KG');
        
        insert od1;*/
        
        od1.ShipTo__c = sr1.Account__c;
        od1.Material__c = sm1.SAP_Material_MSD2__c;
        od1.Open_Orders__c = oo1.Id;
        od1.Record_Key__c = 'RecordKey1';
        od1.Quantity_Shipped_in_BU__c = 10;
        od1.Quantity_Shipped_in_LB__c = 20;
        od1.UOM_Quantity_Shipped_in_BU__c = 'LB';
        insert od1;
        debug('createTestData :3: sr1 = '+sr1);
        Test.startTest();
        od1.Actual_Goods_Issue_Date_Text__c = '2012-12-12';
        od1.Actual_Goods_Issue_Date__c  = System.Today();
        od1.Carrier_PRO_Number__c = '0002';
        od1.Sales_Order_Number__c = '0002';
        od1.Shipment_Complete_Flag__c = 'X';
        update od1;
        Set<String> ordrTypes = new Set<String>{ordrType};
        Set<String> matIds = new Set<String>{od1.Material__c};
        Date d1 = Date.newInstance(2012,12,12), d2 = Date.newInstance(2012,12,12);
        //Map<String, Decimal> qmap = SalesOrderDeliveriesFunctions.getShippedQtys(od1.ShipTo__c, d1, d2, ordrTypes, matIds, 'LB');
        Map<String, Decimal> qmap1 = SalesOrderDeliveriesFunctions.getShippedQtys(od1.ShipTo__c, d1, d2, ordrTypes, matIds, 'LB', '12345','12345');
        Decimal d = SalesOrderDeliveriesFunctions.getShippedQty(qmap1 , od1.Material__c, ordrType);
        PaginationController pc = SalesOrderDeliveriesFunctions.getDeliveriesPC(od1.ShipTo__c, d1, d2, ordrType, od1.Material__c, 10);
        PaginationController pc1 = SalesOrderDeliveriesFunctions.getDeliveriesPC(od1.ShipTo__c, d1, d2, ordrType, matIds , 10, '12345','12345');
        List<Sales_Order_Deliveries__c> SOD = New List<Sales_Order_Deliveries__c>();
        
        SOD.add(od1);
        SalesOrderDeliveriesFunctions.processBeforeUpsert(SOD);
        SalesOrderDeliveriesFunctions.processAfterUpsert(SOD);
    }
    
}