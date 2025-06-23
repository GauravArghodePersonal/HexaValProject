public class Sales_Area_Team {
	
	private static final String DELIM = '-';
	
    private static void debug(String s) {System.debug(LoggingLevel.INFO, 'Sales_Area_Team : ' + s);}
    
	public static void doBeforeInsert(List<Sales_Area_Team__c> alist) {
		setFields1(alist);
	}

    public static void doBeforeUpdate(Map<Id, Sales_Area_Team__c> oldMap, 
                                      Map<Id, Sales_Area_Team__c> newMap) {
        List<Sales_Area_Team__c> nlist = newMap.values();
        setFields1(nlist);
    }
    
    private static void setFields1(List<Sales_Area_Team__c> alist) {
        for (Sales_Area_Team__c a : alist) {
            a.Key__c = getKey(a);
        }
    }
    
    private static String getKey(Sales_Area_Team__c a) {
    	String s = '';
    	if (a.Sales_Office__c     != null) {s +=         a.Sales_Office__c;}
    	if (a.District_Manager__c != null) {s += DELIM + a.District_Manager__c;}
    	debug('Key : ' + s); return s;
    }
    
    public static Map<String, Sales_Area_Team__c> getDistrictManagers(Set<String> aset) {
    	Map<String, Sales_Area_Team__c> amap = new Map<String, Sales_Area_Team__c>();
    	for (Sales_Area_Team__c a : [select Id, Sales_Office__c, District_Manager__r.Email
        	  from Sales_Area_Team__c where Sales_Office__c in :aset]) {
            amap.put(a.Sales_Office__c, a);
        }
    	return amap;
    }

}