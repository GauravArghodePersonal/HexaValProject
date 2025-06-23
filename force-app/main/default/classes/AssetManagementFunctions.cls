public class AssetManagementFunctions {

    public static final Integer MAX_SEARCH_RESULTS = 1000; 
    public static final Integer MAX_SEARCH_RESULTS_PLUS1 = MAX_SEARCH_RESULTS + 1;
    public static final String ASSET_QRY1 = ''
        + 'select Id, Name, Account.Id, Account.Name, Account.AccountNumber, ' 
        + '       Price, Product2.Id, Product2.Name, PurchaseDate, Status, ' 
        + '       AFE_Number__c, Asset_Number__c, Assigned_Account__r.Id, ' 
        + '       Assigned_Account__r.Name, Assigned_Account__r.AccountNumber, ' 
        + '       AutoNation_Points__c, Equipment_Name__c, Invoice_Number__c, '
        + '       Market_Value__c, New_Used__c, PO_Number__c,'
        + '       Revenue_from_Sale__c, SerialNumber, Transaction_Date__c' 
        + '  from Asset ';
    public static final String ASSET_QRY2 = ''
        + 'select Id, Status, New_Used__c, '
        + '      (select Id, Status__c '
        + '         from Asset_Event_Log__r)' 
        + '  from Asset ';
    public static final String LIMIT1 = ' limit :MAX_SEARCH_RESULTS'; 
    
    private static final String ACCOUNT_TYPE_FACILITY = VIUtils.ACCOUNT_TYPE_FACILITY;
    private static final String ACCOUNT_TYPE_LOCATION = VIUtils.ACCOUNT_TYPE_LOCATION;
    private static final Set<String> VI_ACCOUNT_TYPES = new Set<String>{
        ACCOUNT_TYPE_FACILITY, ACCOUNT_TYPE_LOCATION
    };

    // Asset Status Values
    public static final String AS_ASSIGNED = 'Assigned';
    public static final String AS_NEW      = 'New';
    public static final String AS_RETIRED  = 'Retired';
    public static final String AS_RETURNED = 'Returned';
    public static final String AS_SOLD     = 'Sold';
    public static final String AS_TRANSFER = 'Transferred';
    public static final String AS_USED     = 'Used';

    public static Map<String, Id> eqpRtMap = null, accRtMap = null;
    
    private static void debug(String msg) {DebugLog_Functions.info(msg);}
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public static void processAfterInsert(Map<Id, Asset> nmap) {
        Map<String,String> geerOwnerIdMaps = new Map<String,String>();
        Map<String,String> geerAssetMap = new Map<String,String>();
		
        for(Asset assetObj: nmap.values()){
            geerOwnerIdMaps.put(assetObj.GEER__c, assetObj.CreatedById);
            geerAssetMap.put(assetObj.GEER__c, assetObj.Name);
        }
        
        Datetime todaysTime = datetime.now();
        List<GEER__c> geerLst = [Select Id,GEER_Tracking__c from GEER__c WHERE Id IN:geerOwnerIdMaps.keySet()];
        Map<Id,User> userMap = new Map<Id,User>([Select Id,Name from User WHERE Id=:geerOwnerIdMaps.values()]);
        for(GEER__c geerObj: geerLst){
            if(userMap.containsKey(geerOwnerIdMaps.get(geerObj.id))){
                geerObj.GEER_Tracking__c += 'Equipment('+geerAssetMap.get(geerObj.id)+') was created by '+userMap.get(geerOwnerIdMaps.get(geerObj.id)).Name+' '+todaysTime.format('MMMM d,  yyyy')+'<br/>';
            }
        }
        update geerLst;
    	createAssetEventLogs(nmap.values());
    }
    
    public static void processAfterUpdate(Map<Id, Asset> nmap, Map<Id, Asset> omap) {
        createAssetEventLogs(nmap, omap);
    }
    
    public static void processBeforeUpsert(List<Asset> alist) {
        setAssetFields(alist);
    }
    
    public static void processAfterUpsert(Map<Id, Asset_Event_Log__c> nmap) {
        updateAssets(nmap.values());
    }
    
    public static void processBeforeUpdate(List<Asset_Event_Log__c> elist) {
        updateAssetEventLogs(elist);
    }
    
    public static Boolean isAssetCreatable() {
    	return Schema_Services.isObjectCreatable('Asset');
    }
    
    public static void createAssetEventLogs(Map<Id, Asset> nmap, Map<Id, Asset> omap) {
        List<Asset> alist = new List<Asset>();
        for (Asset a : nmap.values()) {
        	if (isChanged(a, omap.get(a.Id))) {alist.add(a);}
        }
        if (alist.isEmpty()) {return;}
        createAssetEventLogs(alist);
    }
    
    private static Boolean isChanged(Asset n, Asset o) {
    	Boolean b = false;
    	b = (n.Assigned_Account__c != o.Assigned_Account__c) ||
    	    (n.AccountId           != o.AccountId)           ||
    	    (n.Transaction_Date__c != o.Transaction_Date__c) ||
    	    (n.Status              != o.Status);
    	return b;
    }
    
    private static void createAssetEventLogs(List<Asset> alist) {
    	if (alist == null || alist.isEmpty()) {return;}
    	List<Asset_Event_Log__c> elist = new List<Asset_Event_Log__c>();
    	Asset_Event_Log__c e;
    	for (Asset a : alist) {
    		e = new Asset_Event_Log__c();
    		e.Account__c          = a.Assigned_Account__c;
            e.Asset__c            = a.Id;
    		e.Plant__c            = a.AccountId;
    		e.Transaction_Date__c = a.Transaction_Date__c;
    		e.Start_Date__c       = a.Transaction_Date__c;
    		e.Status__c           = a.Status;
    		elist.add(e);
    	}
    	try {
    		insert elist; updateAssetEventLogs(elist);
    	} catch(Exception ex) {}
    }
    
    private static Boolean isNotEqual(Date d1, Date d2) {
    	return (d1 == null && d2 != null) || 
    	       (d1 != null && d2 != null && d1 != d2);
    }
    
    private static void updateAssetEventLogs(List<Asset_Event_Log__c> elist) {
        Map<String, Asset_Event_Log__c> emap = new Map<String, Asset_Event_Log__c>();
        for (Asset_Event_Log__c e : elist) {emap.put(e.Id, e);}
        Asset_Event_Log__c ael, prevLog; String prevAssetId = '';
        for (Asset_Event_Log__c e : [
            select Id, Account__c, Asset__c, End_Date__c, Plant__c, 
                   Transaction_Date__c, Start_Date__c, Status__c
              from Asset_Event_Log__c where Id in :emap.keySet()
             order by Asset__c, CreatedDate desc, Name desc]) {
          	ael = emap.get(e.Id); ael.Start_Date__c = ael.Transaction_Date__c;
          	if (prevAssetId.equals(e.Asset__c)) {
          		if (isNotEqual(e.End_Date__c, prevLog.Start_Date__c)) {
              		ael.End_Date__c = prevLog.Start_Date__c;
          		}
        	} else {prevAssetId = e.Asset__c;}
            prevLog = e;
        }
    }
    
    private static Id getEquipmentRecordTypeId() {
    	Id rtid = null;
    	if (eqpRtMap == null) {
            eqpRtMap = RecordType_Functions.RetrieveRecordTypeNameMap('Product2');
    	}
    	if (eqpRtMap != null && eqpRtMap.containsKey('Equipment')){
    	    rtid = eqpRtMap.get('Equipment');
    	}
    	return rtid;
    }

    private static Id getPlantRecordTypeId() {
        Id rtid = null;
        if (accRtMap == null) {
            accRtMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        }
        if (accRtMap != null && accRtMap.containsKey('Plant')){
            rtid = accRtMap.get('Plant');
        }
        return rtid;
    }

    public static List<Product2> getEquipments(String equipmntName) {
    	return getEquipments(equipmntName, new List<String>());
    }
    
    public static List<Product2> getEquipments(String equipmntName, List<String> msgs) {
    	Id rtid = getEquipmentRecordTypeId();
    	if (rtid == null) {return null;} 
        String t = null;
        if (!isNull(equipmntName)) {t = '%' + String.escapeSingleQuotes(equipmntName) + '%';}
        String q1 = 'select Id, Name, Make__c, Model__c from Product2 ';
        String q2 = 'where RecordTypeId = :rtid ';
        if (t != null) {q2 += 'and Equipment_Name__c like :t ';}
        String q3 = 'order by Make__c, Model__c, Name limit :MAX_SEARCH_RESULTS';
        String q4 = 'select count() from Product2 ';
        String q5 = 'limit :MAX_SEARCH_RESULTS_PLUS1';
        Integer n = Database.countQuery(q4 + q2 + q5);
        if (n >= MAX_SEARCH_RESULTS_PLUS1) {
        	msgs.add('Too many records found, showing only the first ' + MAX_SEARCH_RESULTS + ' records');
        } else if (n == 0) {
            msgs.add('No records found'); return null;
        }
        List<Product2> equipments = new List<Product2>();
        try {
            equipments = Database.query(q1 + q2 + q3);
            return equipments;
        } catch(exception e) {msgs.add(e.getMessage());}
    	return null;
    }

    public static List<Account> getAccounts(Account plant1, String accName, String accNum, List<String> msgs) {
        String sorg = plant1.SAP_Sales_Org__c;
        String dchn = plant1.SAP_DistChannel__c;
        String dvsn = plant1.SAP_DivisionCode__c;
        String sgrp = plant1.SAP_SalesGroup__c;
        Set<Id> recTypeIds = null;
        return getAccounts(sorg, dchn, dvsn, sgrp, accName, accNum, recTypeIds, msgs);
    }
        
    public static List<Account> getPlants(Account plant1, String accName, String accNum, List<String> msgs) {
        String sorg = plant1.SAP_Sales_Org__c;
        String dchn = plant1.SAP_DistChannel__c;
        String dvsn = plant1.SAP_DivisionCode__c;
        String sgrp = null;
        Id plantRecTypeId = getPlantRecordTypeId();
        Set<Id> recTypeIds = new Set<Id>{plantRecTypeId};
        return getAccounts(sorg, dchn, dvsn, sgrp, accName, accNum, recTypeIds, msgs);
    }
        
    private static List<Account> getAccounts(String sorg, String dchn, String dvsn, String sgrp,
                                             String accName, String accNum, Set<Id> recTypeIds, 
                                             List<String> msgs) {
        String q1 = 'select Id, Name, AccountNumber, SAP_DistChannel__c, '
                  + '       SAP_DivisionCode__c, SAP_SalesGroup__c, SAP_Sales_Group_Desc__c, '
                  + '       SAP_Sales_Org__c '
                  + '  from Account ';
        String q2 = 'where VI_Account_Type__c in :VI_ACCOUNT_TYPES ';
        if (!isNull(accName)) {
        	accName = '%' + String.escapeSingleQuotes(accName) + '%';
        	q2 += ' and Name like :accName ';
        }
        if (!isNull(accNum)) {
            accNum = '%' + String.escapeSingleQuotes(accNum) + '%';
            q2 += ' and AccountNumber like :accNum ';
        }
        if (recTypeIds != null && !recTypeIds.isEmpty()) {
        	q2 += ' and RecordTypeId in :recTypeIds ';
        }
        if (!isNull(sorg)) {q2 += ' and SAP_Sales_Org__c = :sorg ';}
        if (!isNull(dchn)) {q2 += ' and SAP_DistChannel__c = :dchn ';}
        if (!isNull(dvsn)) {q2 += ' and SAP_DivisionCode__c = :dvsn ';}
        if (!isNull(sgrp)) {q2 += ' and SAP_SalesGroup__c = :sgrp ';}
        String q3 = 'order by Name limit :MAX_SEARCH_RESULTS';
        String q4 = 'select count() from Account ';
        String q5 = 'limit :MAX_SEARCH_RESULTS_PLUS1';
        Integer n = Database.countQuery(q4 + q2 + q5);
        if (n >= MAX_SEARCH_RESULTS_PLUS1) {
            msgs.add('Too many records found, showing only the first ' + MAX_SEARCH_RESULTS + ' records');
        } else if (n == 0) {
            msgs.add('No records found'); return null;
        }
        List<Account> accounts = new List<Account>();
        try {
            accounts = Database.query(q1 + q2 + q3);
            return accounts;
        } catch(exception e) {msgs.add(e.getMessage());}
        return null;
    }
    
    public static Asset getAsset(String assetId) {
    	Set<String> assetIds = new Set<String>{assetId};
    	List<Asset> assets = getAssets(assetIds, '');
    	if (assets != null && !assets.isEmpty()) {return assets[0];}
        return null;
    }
    
    public static List<Asset> getAssets(Set<String> assetIds, String sorts) {
    	String q = ASSET_QRY1 + 'where Id in :assetIds ' + sorts + LIMIT1;
    	List<Asset> assets = Database.query(q);
    	return assets;
    }
    
    // Returns a Map<EquipmentName, Map<Status, AssetCount>>
    public static Map<String, Map<String, Integer>> getAssetCountMap() {
    	Map<String, Map<String, Integer>> emap = new Map<String, Map<String, Integer>>();
    	Map<String, Integer> smap;
    	return emap;
    }
    
    private static void updateAssets(List<Asset_Event_Log__c> aels) {
    	Set<Id> aset = new Set<Id>();
    	for (Asset_Event_Log__c ael : aels) {aset.add(ael.Asset__c);}
    	String q = ASSET_QRY2 + ' where Id in :aset';
    	List<Asset> alist = Database.query(q);
    	if (alist == null || alist.isEmpty()) {return;}
    	setUsedStatus(alist);
    	try {update alist;} catch(Exception e){}
    }
    
    private static void setUsedStatus(List<Asset> alist) {
    	Boolean used = false; Integer assigned = 0, returned = 0, trnsferd = 0;
    	for (Asset a : alist) {
    		if (a.New_Used__c != null && a.New_Used__c.equals(AS_USED) || 
    		    a.Asset_Event_Log__r == null || a.Asset_Event_Log__r.isEmpty()) {continue;}
    		used = false; assigned = 0; returned = 0; trnsferd = 0;
    		for (Asset_Event_Log__c ael : a.Asset_Event_Log__r) {
    			if (ael.Status__c == null) {continue;}
    			if (ael.Status__c.equals(AS_ASSIGNED)) {assigned++;} else 
                if (ael.Status__c.equals(AS_RETURNED)) {returned++;} else 
                if (ael.Status__c.equals(AS_TRANSFER)) {trnsferd++;} 
    		}
    		used = (assigned > 1 || returned > 1) || (assigned > 0 && returned > 0);
    		if (used) {a.New_Used__c = AS_USED;} else {a.New_Used__c = AS_NEW;}
    	}
    }
    
    private static void setAssetFields(List<Asset> alist) {
    	Set<String> eids = new Set<String>();
        Set<String> geerIds = new Set<String>();
    	for (Asset a : alist) {
            eids.add(a.Product2Id);
            geerIds.add(a.GEER__c);
        }
    	Map<String, Product2> emap = EquipmentListFunctions.getEquipmentMap(eids);
        Map<Id, GEER__c> gmap = EquipmentListFunctions.getGEERMap(geerIds);
    	for (Asset a : alist) {
    		if (a.Start_Date__c == null && a.Transaction_Date__c != null) {
    			a.Start_Date__c = a.Transaction_Date__c;
    		}
    		if (emap.containsKey(a.Product2Id)) {
    			Product2 p = emap.get(a.Product2Id);
    			a.Name = p.Equipment_Name__c;
    		}
            
            if(gmap.containsKey(a.GEER__c)) {
                a.CurrencyISOCode = gmap.get(a.GEER__c).CurrencyISOCode;
            }
    	}
    }
}