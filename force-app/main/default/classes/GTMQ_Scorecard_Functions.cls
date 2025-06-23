public class GTMQ_Scorecard_Functions {
	
	public static final String COLON = ':';
    public static final String EXPORT_PROCESSOR = 'Export_Processor__c';
    public static final String READ_ONLY = 'Read';
    
    public static void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'GTMQ_Scorecard_Functions : ' + s);
    }
	
    public static void processAfterUpsert(List<GTM_Quality_Scorecard__c> alist) {
        createSharingData(alist);
    }

	public static void processBeforeUpdate(Map<Id, GTM_Quality_Scorecard__c> omap,
	                                       Map<Id, GTM_Quality_Scorecard__c> nmap) {
        deleteSharingData(omap, nmap);
	}
	
	private static void createSharingData(List<GTM_Quality_Scorecard__c> plist) {
        Set<String> pset = new Set<String>(), uset = new Set<String>(); 
        Map<String, GTM_Quality_Scorecard__c> pmap = new Map<String, GTM_Quality_Scorecard__c>();
        for (GTM_Quality_Scorecard__c p1 : plist) {
        	pset.add(p1.Id); pmap.put(p1.Id, p1);
        	if (p1.User__c != null) {uset.add(p1.User__c);}
        }
        Map<String, GTM_Quality_Scorecard__Share> smap = getSharingDataMap(pset, uset);
        GTM_Quality_Scorecard__c p; GTM_Quality_Scorecard__Share s; String k;
        List<GTM_Quality_Scorecard__Share> alist = new List<GTM_Quality_Scorecard__Share>();
        for (GTM_Quality_Scorecard__c p2 : plist) {
        	if (p2.User__c != null) {
        		k = p2.Id + COLON + p2.User__c + COLON + EXPORT_PROCESSOR;
        		if (!smap.containsKey(k)) {
        			s = new GTM_Quality_Scorecard__Share();
        			s.AccessLevel = READ_ONLY; s.ParentId = p2.Id; 
        			s.RowCause = EXPORT_PROCESSOR; s.UserOrGroupId = p2.User__c;
        			alist.add(s);
        		}
        	}
        }
        debug('alist : ' + alist);
        if (!alist.isEmpty()) {insert alist;}
	}
	
	private static Map<String, GTM_Quality_Scorecard__Share> getSharingDataMap(Set<String> pset, Set<String> uset) {
        Map<String, GTM_Quality_Scorecard__Share> smap = new Map<String, GTM_Quality_Scorecard__Share>();
        String k;
        for (GTM_Quality_Scorecard__Share s1: [select AccessLevel, Id, 
            ParentId, RowCause, UserOrGroupId from GTM_Quality_Scorecard__Share
            where ParentId in :pset and UserOrGroupId in :uset and RowCause = :EXPORT_PROCESSOR]) {
            k = s1.ParentId + COLON + s1.UserOrGroupId + COLON + EXPORT_PROCESSOR;
            smap.put(k, s1);
        }
        return smap;
	}

    private static void deleteSharingData(Map<Id, GTM_Quality_Scorecard__c> omap, 
                                          Map<Id, GTM_Quality_Scorecard__c> nmap) {
        Set<String> pset = new Set<String>(), uset = new Set<String>(); 
        GTM_Quality_Scorecard__c o; Map<String, GTM_Quality_Scorecard__Share> smap;
        for (GTM_Quality_Scorecard__c n : nmap.values()) {
        	o = omap.get(n.Id); if (o.User__c == null) {continue;}
        	if (o.User__c != null && (n.User__c == null || n.User__c != o.User__c)) {
        		pset.add(o.Id); uset.add(o.User__c);
        	}
        }
    	if (!pset.isEmpty()) {
            smap = getSharingDataMap(pset, uset);
            debug('smap.values() : ' + smap.values());
            if (!smap.isEmpty()) {delete smap.values();}
    	}
    }

}