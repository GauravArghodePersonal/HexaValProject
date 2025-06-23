public with sharing class SalesOrderDeliveriesFunctions {

    private static final Integer MAX_RECS = 10000;
    private static final Integer PAGE_SIZE = 200;
    @TestVisible private static final String COLON = ':';
    @TestVisible private static final String DELIM = ' - ';
    private static final Time ZERO_TIME = Time.newInstance(0,0,0,0);
    @TestVisible private static final String SAMP_REQ_NAME1 = 'SAMP-';
    private static final String MAX_LIMIT = ' limit ' + MAX_RECS;
        
    private static final String SOD_QRY1 = ''
        + 'select Id, Name, Actual_Goods_Issue_Date__c, Delivery_Number__c, Material__c,'
        + '       Material__r.Material_Desc__c, Material__r.Material_Number__c,'
        + '       Quantity_Shipped_in_BU__c, Quantity_Shipped_in_LB__c, Reference_Document__c,'
        + '       Sales_Doc_Type__c, Sales_Order_Item__c, Sales_Order_Number__c,'
        + '       ShipTo__c, UOM_Quantity_Shipped_in_BU__c'
        + '  from Sales_Order_Deliveries__c';

    private static final String SOD_OBY1 = ' order by'
        + ' Material__r.Material_Desc__c,'
        + ' Material__r.Material_Number__c,'
        + ' Actual_Goods_Issue_Date__c';

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'SalesOrderDeliveriesFunctions : ' + s);
    }
    
    public static void processBeforeUpsert(List<Sales_Order_Deliveries__c> alist) {
        updateFields(alist);
        system.debug('<<<alist>>>'+alist);
    }
    
    public static void processAfterUpsert(List<Sales_Order_Deliveries__c> alist) {
        updateSampleRequests(alist);
    }
    
    private static void updateFields(List<Sales_Order_Deliveries__c> alist) {
        for (Sales_Order_Deliveries__c a : alist) {
            updateDateFields(a);
        }
        setSampleMaterials(alist);
    }
    
    private static void updateDateFields(Sales_Order_Deliveries__c o) {
        o.Actual_Goods_Issue_Date__c = getDate(o.Actual_Goods_Issue_Date_Text__c);
        o.Agreed_Ship_Date__c = getDate(o.Agreed_Ship_Date_Text__c);
        o.Delivery_Date__c = getDate(o.Delivery_Date_Text__c);
        o.Goods_Issue_Date__c = getDate(o.Goods_Issue_Date_Text__c);
        o.Material_Avail_Date__c = getDate(o.Material_Avail_Date_Text__c);
        o.Requested_Delivery_Date__c = getDate(o.Requested_Delivery_Date_Text__c);
        o.Sales_Order_Date__c = getDate(o.Sales_Order_Date_Text__c);
    }
    
    private static Date getDate(String s) {
        if (!isNull(s) && s.length() > 9) {
            try {
                Integer y = Integer.valueOf(s.substring(0, 4));
                Integer m = Integer.valueOf(s.substring(5, 7));
                Integer d = Integer.valueOf(s.substring(8, 10));
                if (y > 1970 && y < 2170 && m > 0 && m < 13) { 
                    return Date.newInstance(y, m, d);
                }
            } catch(Exception e) {}
        }
        return null;
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private static Boolean sampleRequestRelated(Sales_Order_Deliveries__c o) {
        Boolean b = true;
        String s = o.Sample_Request_Number__c;
        System.debug('<<<<S>>>'+s);
        System.debug('<<<<o>>>'+o.Actual_Goods_Issue_Date__c );
        b = !isNull(s) && s.startsWith(SAMP_REQ_NAME1) && 
                          o.Actual_Goods_Issue_Date__c != null;
        return b;
    }

    private static Map<String, Sales_Order_Deliveries__c> getSampleDeliveriesMap(List<Sales_Order_Deliveries__c> alist) {
        Map<String, Sales_Order_Deliveries__c> amap = new Map<String, Sales_Order_Deliveries__c>();
        List<Sales_Order_Deliveries__c> blist = new List<Sales_Order_Deliveries__c>();
        for (Sales_Order_Deliveries__c o : alist) {
            if (sampleRequestRelated(o)) {blist.add(o);} 
        }
        if (blist.isEmpty() && !Test.isRunningTest()) {return amap;}
        //String cn = 'SalesOrderDeliveriesFunctions', mn = 'updateSampleRequests';
        String k;
        for (Sales_Order_Deliveries__c o : blist) {
            k = o.Sample_Request_Number__c + COLON + o.Material__c;
            debug(k);
            //DebugLog_Functions.logMessage(cn, mn, k); 
            amap.put(k, o);
        }
        return amap;
    }

    private static void setSampleMaterials(List<Sales_Order_Deliveries__c> alist) {
        Map<String, Sales_Order_Deliveries__c> amap = getSampleDeliveriesMap(alist);
        if (amap.isEmpty()) {return;}
        List<Sample_Request__c> srs = Sample_Request_Functions.getSampleRequests(amap);
        if (srs == null || srs.isEmpty()) {return;}
        Sales_Order_Deliveries__c od; String k;
        for (Sample_Request__c sr : srs) {
            if (sr.Sample_Materials__r == null || 
                sr.Sample_Materials__r.isEmpty()) {continue;}
            for (Sample_Material__c sm : sr.Sample_Materials__r) {
                k = sr.Name + COLON + sm.SAP_Material_MSD2__c;
                debug('updateDeliveriesData2 : '+k);
                if (amap.containsKey(k)) {
                    od = amap.get(k);
                    debug(''+od);
                    od.Sample_Material__c = sm.Id;
                }
            }
        }
    }
  
    private static void updateSampleRequests(List<Sales_Order_Deliveries__c> alist) {
        Map<String, Sales_Order_Deliveries__c> amap = getSampleDeliveriesMap(alist);
        if (amap.isEmpty()) {return;}
        Sample_Request_Functions.updateDeliveriesData(amap);
    }
    
    private static String getMapKey1(String matId, String ordrType) {return matId + COLON + ordrType;}

    /*public static Map<String, Decimal> getShippedQtys(String shipToId, Date startDate, Date endDate,
                                                      Set<String> ordrTypes, Set<String> matIds,
                                                      String uom) {
                                             
        Map<String, Decimal> amap = new Map<String, Decimal>(); String k; Decimal q = 0, v = 0;
        if (String.isBlank(shipToId) || startDate == null || endDate == null || 
            ordrTypes == null || ordrTypes.isEmpty() || matIds == null || matIds.isEmpty()) {return amap;}
        String qry = SOD_QRY1 + ' where ShipTo__c = :shipToId and Sales_Doc_Type__c in :ordrTypes';        
        qry += ' and Material__c in :matIds';
        qry += ' and Actual_Goods_Issue_Date__c >= :startDate';
        qry += ' and Actual_Goods_Issue_Date__c <= :endDate ' + MAX_LIMIT;
        
        system.debug('<<<uom>>'+ uom);
        for (Sales_Order_Deliveries__c a : Database.query(qry)) {
            if (uom == 'KG' ) {q = a.Quantity_Shipped_in_BU__c;} else 
            if (uom == 'LB' ) {q = a.Quantity_Shipped_in_LB__c;} else {continue;}
            if (q == null) {q = 0;}
            k = getMapKey1(a.Material__c, a.Sales_Doc_Type__c);           
            if (!amap.containsKey(k)) {amap.put(k, 0);}
            debug('k : ' + k); debug('q : ' + q);
            v = amap.get(k); v += q; amap.put(k, v);
        }
        debug('getShippedQtys : amap = ' + amap);
        return amap;
    }*/
    
    public static Map<String, Decimal> getShippedQtys(String shipToId, Date startDate, Date endDate,
                                                      Set<String> ordrTypes, Set<String> matIds,
                                                      String uom, string contractNum, String PrecontractNum) {
        //ordrTypes.add('ZCCP');                                                
        Map<String, Decimal> amap = new Map<String, Decimal>(); String k; Decimal q = 0, v = 0;
        if (String.isBlank(shipToId) || startDate == null || endDate == null || 
            ordrTypes == null || ordrTypes.isEmpty() || matIds == null || matIds.isEmpty()) {return amap;}
        String qry = SOD_QRY1 + ' where ShipTo__c = :shipToId and (Reference_Document__c =: contractNum OR Reference_Document__c =: PrecontractNum) and Sales_Doc_Type__c in :ordrTypes';
        qry += ' and Material__c in :matIds';
        qry += ' and Actual_Goods_Issue_Date__c >= :startDate';
        qry += ' and Actual_Goods_Issue_Date__c <= :endDate ' + MAX_LIMIT;
        debug('Issue 40 - query>>> ' + qry);
        System.debug('<<ordrTypes>>'+ordrTypes);
        for (Sales_Order_Deliveries__c a : Database.query(qry)) {   
            System.debug('<<<a.Sales_Doc_Type__c>>>'+a.Sales_Doc_Type__c);        
                if (uom == 'KG') {q = a.Sales_Doc_Type__c =='ZCCP'?-a.Quantity_Shipped_in_BU__c:a.Quantity_Shipped_in_BU__c;} else 
                if (uom == 'LB') {q = a.Sales_Doc_Type__c =='ZCCP'?-a.Quantity_Shipped_in_LB__c:a.Quantity_Shipped_in_LB__c;} else {continue;}
                if (q == null) {q = 0;}
            
            k = getMapKey1(a.Material__c, a.Sales_Doc_Type__c);
             debug('<<<k>>' + k);
            if (!amap.containsKey(k)) {amap.put(k, 0);}
            debug('k : ' + k); debug('q : ' + q);
            v = amap.get(k); v += q; amap.put(k, v);
        }
        debug('Issue 40>>> getShippedQtys : amap = ' + amap);
        return amap;
    }
    
    public static Decimal getShippedQty(Map<String, Decimal> qtyMap, String matId, String ordrType) {
        String k = getMapKey1(matId, ordrType); Decimal v = 0;
        system.debug('<<kkkk>>>'+k);
        system.debug('<<qtyMap>>>'+qtyMap);
        if (qtyMap.containsKey(k)) {
            v = qtyMap.get(k);
            }
            k = getMapKey1(matId, 'ZCCP');
           if (qtyMap.containsKey(k)) {
                v += qtyMap.get(k);
            }
        System.debug('<<<<<v>>>>>'+v);
        return v;
    }    

    public static PaginationController getDeliveriesPC(String shipToId, Date startDate, Date endDate,
                                                       String ordrType, String matId, Integer pageSize) {
        Set<String> matIds = new Set<String>{matId};
        return getDeliveriesPC(shipToId, startDate, endDate, ordrType, matIds, pageSize);
    }

    public static PaginationController getDeliveriesPC(String shipToId, Date startDate, Date endDate,
                                                       String ordrType, Set<String> matIds, Integer pageSize) {
        String qry = SOD_QRY1 + ' where ShipTo__c = :shipToId and Sales_Doc_Type__c = :ordrType';
        qry += ' and Material__c in :matIds';
        qry += ' and Actual_Goods_Issue_Date__c >= :startDate';
        qry += ' and Actual_Goods_Issue_Date__c <= :endDate ';
        qry += SOD_OBY1 + MAX_LIMIT;
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            System.debug('<<<q1>>>>'+ql);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getDeliveriesPC : ' + e.getMessage());}
        return pc;
    }
    
    public static PaginationController getDeliveriesPC(String shipToId, Date startDate, Date endDate,
                                                       String ordrType, Set<String> matIds, Integer pageSize,string contractNum, string PrecontractNum){
        String qry = SOD_QRY1 + ' where ShipTo__c = :shipToId and (Reference_Document__c =: contractNum OR Reference_Document__c =: PrecontractNum) and Sales_Doc_Type__c = :ordrType';
        qry += ' and Material__c in :matIds';
        qry += ' and Actual_Goods_Issue_Date__c >= :startDate';
        qry += ' and Actual_Goods_Issue_Date__c <= :endDate ';
        qry += SOD_OBY1 + MAX_LIMIT;
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            System.debug('<<<q1>>>>'+ql);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getDeliveriesPC : ' + e.getMessage());}
        return pc;
    }
}