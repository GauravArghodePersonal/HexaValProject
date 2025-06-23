public with sharing class VI_Promotion_Cards_Functions {
	
    public static final String DELIM = '-';
    private static final String COLON = ':';
    private static final String DEF_SORG = '1000';
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }

    public static void doAfterUpsert(List<VI_Promotion_Cards__c> plist) {
        Map<String, VI_Enrollment_Location__c> elmap = getEnrollmentLocations(plist, false);
        if (elmap.isEmpty()) {return;}
        List<VI_Enrollment_Location__c> els = elmap.values();
        try {update els;} catch(Exception e) {}
    }

    public static void doBeforeUpsert(List<VI_Promotion_Cards__c> plist) {
        Map<String, VI_Enrollment_Location__c> elmap = getEnrollmentLocations(plist, true);
        if (elmap.isEmpty()) {return;} VI_Enrollment_Location__c el;
        for (VI_Promotion_Cards__c p : plist) {
        	if (elmap.containsKey(p.Key__c)) {
        		el = elmap.get(p.Key__c); p.Enrollment_Location__c = el.Id;
                if (el.Facility__c != null) {p.Facility__c = el.Facility__c;}
        		if (el.Location__c != null) {p.Location__c = el.Location__c;}
        	}
        }
    }
        
    private static Map<String, VI_Enrollment_Location__c> getEnrollmentLocations(List<VI_Promotion_Cards__c> plist, Boolean isBefore) {
        Set<String> prgrmCodes = new Set<String>(), 
                    accNumbers = new Set<String>(),
                    enrlocKeys = new Set<String>();
        for (VI_Promotion_Cards__c p : plist) {
            prgrmCodes.add(p.Program_Code__c);
            accNumbers.add(p.Installer_Number__c);
        }
        Map<String, String> pmap = getPromotionCodeIdMap(prgrmCodes);
        Map<String, String> amap = getAccountNumberIdMap(accNumbers);
        Map<String, String> cmap = new Map<String, String>();
        String accKey, pid, aid, elkey;
        for (VI_Promotion_Cards__c p : plist) {
            accKey = p.Installer_Number__c + p.SalesOrg_Code__c + '4040';
            pid = null; aid = null;
            if (pmap.containsKey(p.Program_Code__c)) {
                pid = pmap.get(p.Program_Code__c);
            }
            if (amap.containsKey(accKey)) {
                aid = amap.get(accKey);
            } else 
            if (amap.containsKey(p.Installer_Number__c)) {
                aid = amap.get(p.Installer_Number__c);
            }
            if (aid != null) {
            	if (isBefore) {p.Account__c = aid;}
            	if (pid != null) {
	                elkey = pid + COLON + aid;
	                debug('elkey = ' + elkey);
	                //enrlocKeys.add(elkey); cmap.put(elkey, p.Id);
	                enrlocKeys.add(p.Key__c); cmap.put(p.Key__c, p.Id);
            	}
            }
        }
        //updateEnrollmentLocations(enrlocKeys, cmap);
        return getEnrollmentLocations(prgrmCodes, accNumbers, cmap);
    }
    
    private static Map<String, String> getPromotionCodeIdMap(Set<String> prgrmCodes) {
        Map<String, String> amap = new Map<String, String>();
        for (VI_Promotion__c p : [select Id, Program_Code__c
                                    from VI_Promotion__c
                                   where Program_Code__c in :prgrmCodes]) {
        	amap.put(p.Program_Code__c, p.Id);
        }
        debug('getPromotionCodeIdMap : ' + amap);
        return amap;
    }
    
    private static Map<String, String> getAccountNumberIdMap(Set<String> accNumbers) {
        Map<String, String> amap = new Map<String, String>();
        
        Boolean accNumbersValid = true;
        if (accNumbers.size() == 0) {
        	accNumbersValid = false;
        }
        else {
	        for (String accNumber : accNumbers) {
	        	if (accNumber == '' || accNumber == null) {
	        		accNumbersValid = false;
	        		break;
	        	}
	        } 
        }
        
        if (accNumbersValid) {
        	try {
		        for (Account a : [select Id, AccountNumber, Account_Number__c
		                            from Account
		                           where AccountNumber in :accNumbers]) {
		            if (isNull(a.Account_Number__c)) {
		                amap.put(a.AccountNumber, a.Id);
		            } else {
		                amap.put(a.Account_Number__c, a.Id);
		            }
		        }
        	}
        	catch (Exception e) {
        	}
        }
        debug('getAccountNumberIdMap : ' + amap);
        return amap;
    }
    
    private static Boolean isNull(String s) {
    	return (s == null || s.trim().length() == 0);
    }
/*    
    private static void updateEnrollmentLocations(Set<String> enrlocKeys,
                                                  Map<String, String> pcmap) {
    	List<VI_Enrollment_Location__c> els = new List<VI_Enrollment_Location__c>();
    	for (VI_Enrollment_Location__c el : [
            select Id, Key__c, Promotion_Cards__c
              from VI_Enrollment_Location__c
             where Key__c in :enrlocKeys
    	]) {
    		if (el.Key__c != null && pcmap.containsKey(el.Key__c)) {
    			el.Promotion_Cards__c = pcmap.get(el.Key__c);
    			els.add(el);
    		}
    	}
        if (els.isEmpty()) {return;}
        try {update els;} catch(Exception e) {}
    }
*/
    private static Map<String, VI_Enrollment_Location__c> getEnrollmentLocations(
        Set<String> prgrmCodes, Set<String> accNumbers, Map<String, String> pcmap) {
        Map<String, VI_Enrollment_Location__c> els = new Map<String, VI_Enrollment_Location__c>();
        String pckey, pcid, fsorg, lsorg;
        for (VI_Enrollment_Location__c el : [
            select Id, Facility__c, Facility__r.AccountNumber, Facility__r.SAP_Sales_Org__c,
                   Location__c, Location__r.AccountNumber, Location__r.SAP_Sales_Org__c,
                   Program_Code__c, Promotion_Cards__c
              from VI_Enrollment_Location__c
             where (Facility__r.AccountNumber in :accNumbers or
                    Location__r.AccountNumber in :accNumbers)
               and Program_Code__c in :prgrmCodes
        ]) {pcid = null;
        	fsorg = el.Facility__r.SAP_Sales_Org__c; if (isNull(fsorg)) {fsorg = DEF_SORG;}
            lsorg = el.Location__r.SAP_Sales_Org__c; if (isNull(lsorg)) {lsorg = DEF_SORG;}
            pckey = el.Facility__r.AccountNumber + DELIM + fsorg + DELIM + el.Program_Code__c;
            if (pcmap.containsKey(pckey)) {pcid = pcmap.get(pckey); els.put(pckey, el);}
        	pckey = el.Location__r.AccountNumber + DELIM + lsorg + DELIM + el.Program_Code__c;
            if (pcmap.containsKey(pckey)) {pcid = pcmap.get(pckey); els.put(pckey, el);}
            if (pcid != null) {el.Promotion_Cards__c = pcid;}
        }
        return els;
    }
    
}