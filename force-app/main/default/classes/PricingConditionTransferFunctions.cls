public class PricingConditionTransferFunctions {

    private static final String COMMA = ',';
    private static final String CRNL  = '\r\n';
    private static final String DELIM = '-';
    private static final Integer MAX_RECS = 10000;
    
    private static final String ACTIVE = PricingConditionFunctions.ACTIVE;
    private static final String APPROVED = PricingConditionFunctions.APPROVED;
    private static final String DRAFT = 'Draft';
    
    private static final String CHERKY = Account_Partner_Functions.ACC_TYPE_CHERKY;
    private static final String SHIPTO = Account_Partner_Functions.ACC_TYPE_SHIPTO;
    private static final String SOLDTO = Account_Partner_Functions.ACC_TYPE_SOLDTO;
    
    private static final Map<String, String> ACC_TYPE_LEVEL_MAP = new Map<String, String>{
    	CHERKY => 'Corporate Account',
    	SHIPTO => SHIPTO,
    	SOLDTO => SOLDTO
    };

    private static final Set<String> PC_STATS1 = new Set<String>{
        PricingConditionFunctions.ACTIVE,
        PricingConditionFunctions.APPROVED,
        PricingConditionFunctions.DRAFT,
        PricingConditionFunctions.SUBMITTED
    }; 
    
    public static final String QRY_PCTR = ''
        + 'select Id,'
        + '       Account_From__r.CurrencyIsoCode,'  
        + '       Account_From__r.Id,'  
        + '       Account_From__r.SAP_DistChannel__c,'
        + '       Account_From__r.SAP_Sales_Org__c,'
        + '       Account_To__r.CurrencyIsoCode,'  
        + '       Account_To__r.Id,'
        + '       Account_To__r.SAP_DistChannel__c,'
        + '       Account_To__r.SAP_Sales_Org__c,'
        + '       Material_From__r.Id,'  
        + '       Material_To__r.Id,'  
        + '       Pricing_Condition__c'  
        + '  from Pricing_Condition_Transfer_Request__c';

    public static final String QRY_PCTM = ''
        + 'select CurrencyIsoCode, Id,' 
        + '       Material2__c,'
        + '       PCT_Request__r.Account_From__c,'
        + '       PCT_Request__r.Account_To__c,'
        + '       Pricing_Condition__r.Comments__c,'
        + '       Pricing_Condition__r.Id,'
        + '       Pricing_Condition__r.Material2__c'
        + '  from Pricing_Condition_Transfer_Material__c';
        
    private static final String QRY2 = ' where CreatedById = :createdById';
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'PricingConditionTransferFunctions : ' + s);
    }

    public static Database.Querylocator getPctrQryLctr() {
        return getPctrQryLctr(UserInfo.getUserId());
    }
    
    public static Database.Querylocator getPctrQryLctr(Id createdById) {
        return Database.getQueryLocator(QRY_PCTR + QRY2);
    }
    
    public static Database.Querylocator getPctmQryLctr() {
        return getPctmQryLctr(UserInfo.getUserId());
    }

    public static Database.Querylocator getPctmQryLctr(Id createdById) {
        return Database.getQueryLocator(QRY_PCTM + QRY2);
    }

    public static void createPCTRequests(String s1) {
    	List<String> smsgs = new List<String>();
        List<String> emsgs = new List<String>();
    	createPCTRequests(s1, smsgs, emsgs);
    }
    
    public static void createPCTRequests(String s1, List<String> smsgs, List<String> emsgs) {
    	List<String> s1a = s1.split(CRNL); String[] s2a;
        debug('s1 = ' + s1 + ' : s1a.size = ' + s1a.size());
    	if (s1a == null || s1a.isEmpty()) {return;}
    	Set<String> ks = new Set<String>(); s1 = null;
    	List<String[]> s3a = new List<String[]>();
    	for (String s2 : s1a) {
    		s2a = s2.split(COMMA);
    		if (s2a == null || s2a.size() < 2 || 
    		    s2a[0] == null || s2a[1] == null || 
    		    s2a[0].equals(s2a[1])) {continue;}
            //debug('s2a[0]='+s2a[0]+' : s2a[1]='+s2a[1]);
    		ks.add(s2a[0]); ks.add(s2a[1]);
    		s3a.add(s2a);
    	}
    	s1a = null;
    	if (ks.size() < 2) {return;}
    	Map<String, Id> amap = getAccountNumIdMap(ks);
    	//if (amap.isEmpty()) {return;}
    	List<Pricing_Condition_Transfer_Request__c> pctrs = new 
    	List<Pricing_Condition_Transfer_Request__c>();
    	Pricing_Condition_Transfer_Request__c pctr; Integer n1 = 0, n2 = 0, n3 = 0; String msg;
    	for (String[] s4a : s3a) {
    		msg = 'Record ' + (++n1) + ' : ';
    		if (amap.containsKey(s4a[0]) && amap.containsKey(s4a[1])) {
    			pctr = new Pricing_Condition_Transfer_Request__c();
    			pctr.Account_From__c = amap.get(s4a[0]);
                pctr.Account_To__c = amap.get(s4a[1]);
                pctrs.add(pctr); n2++;
                //msg += ' Accounts found : ' + s4a[0] + ' : ' + s4a[1];
                //if (smsgs.size() < 1000) {smsgs.add(msg);}
    		} else {
    			msg += ' Accounts not found : '; n3++;
    			if (!amap.containsKey(s4a[0])) {msg += s4a[0] + ' : ';}
                if (!amap.containsKey(s4a[1])) {msg += s4a[1];}
                if (emsgs.size() < 1000) {emsgs.add(msg);}
    		}
    	}
    	if (n1 > 0) {smsgs.add('        Total Records Read : ' + n1);}
        if (n2 > 0) {smsgs.add('Records Selected to Upload : ' + n2);}
        if (n3 > 0) {smsgs.add('      Records Not Selected : ' + n3);}
    	if (!pctrs.isEmpty()) {insert pctrs;}
    }
    
    public static Integer getPCTReqCount() {
        return [select count() from Pricing_Condition_Transfer_Request__c];
    }
    
    public static Integer getPCTMatCount() {
        return [select count() from Pricing_Condition_Transfer_Material__c];
    }
    
    public static Pricing_Condition_Transfer_Request__c getPCTR() {
        List<Pricing_Condition_Transfer_Request__c> rs = Database.query(QRY_PCTR); 
        if (rs == null || rs.isEmpty()) {return null;}
        return rs[0];
    }
    
    public static Boolean isDiffSalesArea(Pricing_Condition_Transfer_Request__c pctr) {
        Boolean b1, b2;
        Account a1 = pctr.Account_From__r, a2 = pctr.Account_To__r;
        debug('a1 = ' + a1 + ' : a2 = ' + a2);
        b1 = isDiff(a1.SAP_DistChannel__c, a2.SAP_DistChannel__c);
        b2 = isDiff(a1.SAP_Sales_Org__c, a2.SAP_Sales_Org__c);
        return (b1 || b2);
    }
    
    private static Boolean isDiff(String s1, String s2) {
    	return (s1 != null && s2 != null && s1 != s2);
    }
    
    private static Map<String, Id> getAccountNumIdMap(Set<String> accNums) {
    	String q1 = 'select Id, AccountNumber, Account_Number__c from Account where ';
    	String q2 = ' in :accNums limit :MAX_RECS';
    	List<Account> alist = new List<Account>(), blist;
    	blist = Database.query(q1 + 'Account_Number__c' + q2);
    	if (blist != null && !blist.isEmpty()) {alist.addAll(blist);}
        blist = Database.query(q1 + 'AccountNumber' + q2);
        if (blist != null && !blist.isEmpty()) {alist.addAll(blist);}
    	Map<String, Id> amap = new Map<String, Id>();
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Account a : alist) {
        	if (String.isBlank(a.Account_Number__c)) {amap.put(a.AccountNumber, a.Id);}
        	else {amap.put(a.Account_Number__c, a.Id);}
        }
        return amap;
    }
    
    public static void deletePCTRequests() {
    	List<Pricing_Condition_Transfer_Request__c> rs = Database.query(QRY_PCTR); 
    	if (rs != null && !rs.isEmpty()) {delete rs;}
    }

    public static void deletePCTMaterials() {
        List<Pricing_Condition_Transfer_Material__c> rs = Database.query(QRY_PCTM); 
        if (rs != null && !rs.isEmpty()) {delete rs;}
    }

    public static void createMaterials(List<Pricing_Condition_Transfer_Request__c> pctrs) {
        if (pctrs == null || pctrs.isEmpty()) {return;}
        for (Pricing_Condition_Transfer_Request__c pctr : pctrs) {
            createMaterials(pctr);
        }
    }
    
    private static void createMaterials(Pricing_Condition_Transfer_Request__c pctr) {
        Account a1 = pctr.Account_From__r;
        Account a2 = pctr.Account_To__r;
        String oldMatKey, newMatKey;
        Set<String> newMatKeys = new Set<String>();
        List<Pricing_Condition__c> pcs = new List<Pricing_Condition__c>();
        for (Pricing_Condition__c pc : [
            select Id, Account__c,
                   Material2__r.Material_Number__c, 
                   Material2__r.Record_Key__c
              from Pricing_Condition__c 
             where Account__c = :a1.id]) {
            oldMatKey = pc.Material2__r.Record_Key__c;
            newMatKey = pc.Material2__r.Material_Number__c + 
                        a2.SAP_Sales_Org__c + a2.SAP_DistChannel__c;
            //debug('oldMatKey = '+oldMatKey+' : newMatKey = '+newMatKey);
            if (!newMatKey.equals(oldMatKey)) {
                pcs.add(pc);
                newMatKeys.add(newMatKey);
            }
        }
        if (newMatKeys.isEmpty()) {return;}
        Map<String, String> newMatKeyIdMap = new Map<String, String>();
        for (Material_Sales_Data2__c m : [
            select Id, Record_Key__c
              from Material_Sales_Data2__c
             where Record_Key__c in :newMatKeys]) {
            newMatKeyIdMap.put(m.Record_Key__c, m.Id);
        }
        List<Pricing_Condition_Transfer_Material__c> pctms = new 
        List<Pricing_Condition_Transfer_Material__c>();
        Pricing_Condition_Transfer_Material__c pctm;
        for (Pricing_Condition__c pc : pcs) {
            newMatKey = pc.Material2__r.Material_Number__c + 
                        a2.SAP_Sales_Org__c + a2.SAP_DistChannel__c;
            if (newMatKeyIdMap.containsKey(newMatKey)) {
                pctm = getPCTM(pctr, pc);
                pctm.Material2__c = newMatKeyIdMap.get(newMatKey);
                pctms.add(pctm);
            }
        }
        if (pctms.isEmpty()) {return;}
        try {upsert pctms Pricing_Condition_Transfer_Material__c.Fields.Key__c;}
        catch(Exception e) {debug(e.getMessage());}
    }
    
    private static void createMaterials2(Pricing_Condition_Transfer_Request__c pctr) {
        List<Pricing_Condition_Transfer_Material__c> pctms = new 
        List<Pricing_Condition_Transfer_Material__c>();
        Pricing_Condition_Transfer_Material__c pctm;
        for (Pricing_Condition__c pc : [
            select Id, Account__c,
                   Material2__r.Material_Number__c, 
                   Material2__r.Record_Key__c
              from Pricing_Condition__c 
             where Account__c = :pctr.Account_From__c]) {
            pctm = getPCTM(pctr, pc);
            pctms.add(pctm);
        }
        try {upsert pctms Pricing_Condition_Transfer_Material__c.Fields.Key__c;}
        catch(Exception e) {debug(e.getMessage());}
    }
    
    public static void updateMaterials(List<Pricing_Condition_Transfer_Material__c> pctms) {
        if (pctms == null || pctms.isEmpty()) {return;}
        List<Pricing_Condition__c> pcs = new List<Pricing_Condition__c>();
        Pricing_Condition__c pc; String c;
        for (Pricing_Condition_Transfer_Material__c pctm : pctms) {
            pc = pctm.Pricing_Condition__r;
            c = pc.Comments__c;
            if (c == null) {c = '';}
            pc.Comments__c = c + '\nAccount Merged\n';
            pc.Material2__c = pctm.Material2__c;
            pcs.add(pc);
        }
        if (pcs.isEmpty()) {return;}
        try {update pcs;}
        catch(Exception e) {debug(e.getMessage());}
    }
    
    public static void mergeAccounts(List<Pricing_Condition_Transfer_Request__c> pctrs) {
        if (pctrs == null || pctrs.isEmpty()) {return;}
        Map<String, List<Account>> amap = new Map<String, List<Account>>();
        Set<String> aset = new Set<String>(), pset = new Set<String>();
        for (Pricing_Condition_Transfer_Request__c pctr : pctrs) {
            Account a1 = pctr.Account_From__r;
            Account a2 = pctr.Account_To__r;
            amap.put(a1.Id + DELIM + a2.Id, new List<Account>{a1, a2});
            aset.add(a1.Id);
        }
        Set<String> sset = PricingConditionIDocFunctions.PC_REC_STATS;
        for (Pricing_Condition__c pc : [select Id, Record_Status__c from Pricing_Condition__c 
                                         where Account__c in :aset]) {
            if (sset.contains(pc.Record_Status__c)) {pset.add(pc.Id);}
        } 
        for (List<Account> accs : amap.values()) {
            try {merge accs[1] accs[0];}
            catch(Exception e) {debug(e.getMessage());}
        }
        if (!pset.isEmpty()) {createIDocs(pset);}
    }
    
    public static void createPCTMs(List<Pricing_Condition_Transfer_Request__c> pctrs) {
        if (pctrs == null || pctrs.isEmpty()) {return;}
        for (Pricing_Condition_Transfer_Request__c pctr : pctrs) {
	        Boolean diffSalesArea = isDiffSalesArea(pctr);
	        if (diffSalesArea == null) {continue;}
	        if (diffSalesArea) {createMaterials(pctr);} else {createMaterials2(pctr);}
        }
    }
    
    private static Pricing_Condition_Transfer_Material__c getPCTM(Pricing_Condition_Transfer_Request__c pctr, 
                                                                  Pricing_Condition__c pc) {
    	Pricing_Condition_Transfer_Material__c pctm;
        pctm = new Pricing_Condition_Transfer_Material__c();
        Account a1 = pctr.Account_From__r;
        Account a2 = pctr.Account_To__r;
        pctm.CurrencyIsoCode = a2.CurrencyIsoCode;
        pctm.Material2__c = pc.Material2__c;
        pctm.PCT_Request__c = pctr.Id;
        pctm.Pricing_Condition__c = pc.Id;
        pctm.Key__c = a1.Id + DELIM + a2.Id + DELIM + pc.Id;
        return pctm;
    }
    
    public static void createPCTMs2(List<Pricing_Condition_Transfer_Request__c> pctrs) {
        if (pctrs == null || pctrs.isEmpty()) {return;}
        for (Pricing_Condition_Transfer_Request__c pctr : pctrs) {createPCTMs2(pctr);}
    }
    
    private static void createPCTMs2(Pricing_Condition_Transfer_Request__c pctr) {
        List<Pricing_Condition_Transfer_Material__c> pctms = new 
        List<Pricing_Condition_Transfer_Material__c>();
        Pricing_Condition_Transfer_Material__c pctm;
        for (Pricing_Condition__c pc : [
            select Id, Account__c,
                   Material2__r.Material_Number__c, 
                   Material2__r.Record_Key__c
              from Pricing_Condition__c 
             where Account__c = :pctr.Account_From__c
               and Material2__c = :pctr.Material_From__c]) {
            pctm = getPCTM(pctr, pc);
            pctm.Material2__c = pctr.Material_To__c;
            pctms.add(pctm);
        }
        try {upsert pctms Pricing_Condition_Transfer_Material__c.Fields.Key__c;}
        catch(Exception e) {debug(e.getMessage());}
    }
    
    private static void setAccLevelMap(Id accountId, Map<Id, String> accTypeMap, Map<Id, String> accLevlMap) {
    	if (accLevlMap.containsKey(accountId)) {return;}
    	String accType, accLevl;
        if (!accTypeMap.containsKey(accountId)) {
            accType = Account_Partner_Functions.getAccountType(accountId);
            accTypeMap.put(accountId, accType);
        }
        accType = accTypeMap.get(accountId);
        if (String.isBlank(accType)) {return;}
        if (ACC_TYPE_LEVEL_MAP.containsKey(accType)) {
        	accLevl = ACC_TYPE_LEVEL_MAP.get(accType);
        	accLevlMap.put(accountId, accLevl);
        } 
    }
    
    private static Map<Id, Pricing_Condition__c> getPCMap(List<Pricing_Condition_Transfer_Material__c> pctms) {
        set<Id> pcids = new set<Id>(); 
        Map<Id, Pricing_Condition__c> pcmap = new Map<Id, Pricing_Condition__c>();
        for (Pricing_Condition_Transfer_Material__c pctm : pctms) {pcids.add(pctm.Pricing_Condition__c);}
        List<Pricing_Condition__c> plist = PricingConditionFunctions.getPricingConditions(pcids);
        for (Pricing_Condition__c pc : plist) {pcmap.put(pc.Id, pc);}
        return pcmap;
    }
    
    private static Pricing_Condition__c getClonedPricingCondition(Id pcid, Map<Id, Pricing_Condition__c> pcmap) {
    	Pricing_Condition__c pc = pcmap.get(pcid);
        List<Pricing_Condition__c> plist = new List<Pricing_Condition__c>{pc};
        return PricingConditionFunctions.getClonedPricingConditions(plist)[0];
    }
    
    public static void createPricingConditions(List<Pricing_Condition_Transfer_Material__c> pctms) {
    	Map<Id, String> accTypeMap = new Map<Id, String>();
        Map<Id, String> accLevlMap = new Map<Id, String>(); String accLevl;
        Map<Id, Pricing_Condition__c> pcmap = getPCMap(pctms);
        List<Pricing_Condition__c> clist = new List<Pricing_Condition__c>();
        Pricing_Condition__c pc;
        for (Pricing_Condition_Transfer_Material__c pctm : pctms) {
        	pc = getClonedPricingCondition(pctm.Pricing_Condition__c, pcmap);
        	if (!PC_STATS1.contains(pc.Record_Status__c)) {continue;}
        	pc.Account__c = pctm.PCT_Request__r.Account_To__c;
            if (!accLevlMap.containsKey(pc.Account__c)) {
            	setAccLevelMap(pc.Account__c, accTypeMap, accLevlMap);
            }
        	if (accLevlMap.containsKey(pc.Account__c)) {
        		accLevl = accLevlMap.get(pc.Account__c);
        		if (!String.isBlank(accLevl)) {pc.Account_Level_Condition_Applies_To__c = accLevl;}
        	}
        	pc.Material2__c = pctm.Material2__c;
            pc.CurrencyIsoCode = pctm.CurrencyIsoCode;
            pc.Entered_in_SAP__c = false;
            pc.Date_Entered_in_SAP__c = null;
        	if (pc.Active__c) {pc.Active__c = false; 
        		pc.Current_State__c = APPROVED; pc.Record_Status__c = APPROVED;
        	}
        	clist.add(pc);
        }
        PricingConditionFunctions.insertPricingConditions(clist);
        //for (Pricing_Condition__c pc : clist) {debug(pc.Id + ':' + pc.Name);}
    }
    
    public static void createIDocs(List<Pricing_Condition_Transfer_Request__c> pctrs) {
        if (pctrs == null || pctrs.isEmpty()) {return;}
        Set<String> pcids1 = new Set<String>(), pcids2 = new Set<String>();
        for (Pricing_Condition_Transfer_Request__c pctr : pctrs) {
        	if (!String.isBlank(pctr.Pricing_Condition__c)) {
        		      pcids1.add(pctr.Pricing_Condition__c);}
        }
        if (pcids1.isEmpty()) {return;}
        Set<String> sset = PricingConditionIDocFunctions.PC_REC_STATS;
        List<Pricing_Condition__c> pcs = new List<Pricing_Condition__c>();
        for (Pricing_Condition__c pc : [select Id, Record_Status__c from Pricing_Condition__c 
                                         where Id in :pcids1]) {
        	if (sset.contains(pc.Record_Status__c)) {pcids2.add(pc.Id); pcs.add(pc);}
        } 
        if (pcids2.isEmpty()) {return;}
        try {update pcs; createIDocs(pcids2);} catch(Exception e) {}
    }
    
    private static void createIDocs(Set<String> pcids) {
        if (pcids == null || pcids.isEmpty()) {return;}
        PricingConditionIDocFunctions.deleteIDocs(pcids);
        PricingConditionIDocFunctions.createIDocs(pcids);
    }
    
}