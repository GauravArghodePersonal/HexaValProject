public with sharing class EquipmentListFunctions {

    public static final Integer MAX_SEARCH_RESULTS = 1000; 
    public static final Integer MAX_SEARCH_RESULTS_PLUS1 = MAX_SEARCH_RESULTS + 1;
    public static final String DELIM = ' - '; 
    public static final String QRY1 = ''
        + 'select Id, IsActive, Name, Family, Equipment_Name__c, Make__c, Model__c, Product_Number__c ' 
        + '  from Product2 ';
    public static final String LIMIT1 = ' limit :MAX_SEARCH_RESULTS'; 
    public static final String RECORD_TYPE = 'Equipment'; 
    
    public static final String REPORT1 = 'Loan_Equipment_Assets';
    
    // Report Names
    private static final Set<String> REPORT_SET = new Set<String>{
        REPORT1
    };
    private static Map<String, Id> reportMap = null;

    public static Map<String, Id> eqpRtMap = null;
    
    public static String equipmentQry = null;
    
    private static void debug(String msg) {DebugLog_Functions.info(msg);}
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public static Id getEquipmentRecordTypeId() {
        Id rtid = null;
        if (eqpRtMap == null) {
            eqpRtMap = RecordType_Functions.RetrieveRecordTypeNameMap('Product2');
        }
        if (eqpRtMap != null && eqpRtMap.containsKey(RECORD_TYPE)){
            rtid = eqpRtMap.get(RECORD_TYPE);
        }
        return rtid;
    }

    public static String getEquipmentKey(Product2 p) {
    	return RECORD_TYPE + DELIM + p.Make__c + DELIM + p.Model__c;
    }
    
    public static String getEquipmentQry(Product2 p) {
    	if (equipmentQry ==  null) {
	    	equipmentQry = QRY1 + ' where isActive = true';
	        Id rtid = getEquipmentRecordTypeId();
	        if (rtid != null) {
    	        equipmentQry += ' and RecordTypeId = \'' + rtid + '\' ';
	        }
    	}
    	String q = equipmentQry;
        if (!isNull(p.Make__c))  {q += ' and Make__c like \'%' + String.escapeSingleQuotes(p.Make__c) + '%\'';}
        if (!isNull(p.Model__c)) {q += ' and Model__c like \'%' + String.escapeSingleQuotes(p.Model__c) + '%\'';}
        if (!isNull(p.Name))  {q += ' and Name like \'%' + String.escapeSingleQuotes(p.Name) + '%\'';}
        return q; 
    }

    public static PaginationController getEquipmentPC(Integer ps, String sorts, Product2 p) {
        Database.Querylocator ql = null; PaginationController pc = null;
        String q = getEquipmentQry(p); q += sorts;
        ql = Database.getQueryLocator(q);
        if (ql == null) {return null;}
        pc = new PaginationController(ql, ps);
        return pc;
    }
    
    private static void setReportMap() {
    	reportMap = new Map<String, Id>();
    	for (Report r : [select DeveloperName, Id from Report 
    	                  where DeveloperName in :REPORT_SET]) {
            reportMap.put(r.DeveloperName, r.Id);
        }
    }
    
    public static String getReportId(String rptName) {
    	if (reportMap == null) {setReportMap();}
    	String s = '';
    	if (reportMap.containsKey(rptName)) {s = reportMap.get(rptName);}
    	return s;
    }
    
    public static Map<String, Product2> getEquipmentMap(Set<String> ids) {
    	String q = QRY1 + ' where Id in :ids';
    	Map<String, Product2> emap = new Map<String, Product2>();
    	for (Product2 p : Database.query(q)) {emap.put(p.Id, p);}
    	return emap;
    }
    
    public static Map<Id,GEER__c> getGEERMap(Set<String> ids) {
        return new Map<Id,GEER__c>([SELECT Id, CurrencyISOCode FROM GEER__c WHERE Id IN :ids]);
    }
    
    public static Map<String,Set<String>> getEQs(Set<String> ids) {
        Map<String,Set<String>> eqIdMap = new Map<String,Set<String>>();
        for(Asset eq :[SELECT Id, GEER__c FROM Asset WHERE GEER__c IN :ids]) {
            Set<String> eqs = eqIdMap.get(eq.GEER__c);
			eqs = (eqs == null)?new Set<String>():eqs;            
            eqs.add(eq.Id);
            eqIdMap.put(eq.GEER__c,eqs);
        }
        return eqIdMap;
    }
    
}