public class Schema_Functions {
    
    private static final Integer MAX_DESCRIBES = 10;
    private static final String RT_MAP_KEY_NAME = 'Name';
    private static final String RT_MAP_KEY_ID = 'Id';
    private static final String RT_MAP_KEY_DRT_NAME = 'RT_MAP_KEY_DRT_NAME'; // Default Record Type Name
    private static final String RT_MAP_KEY_DRT_ID = 'RT_MAP_KEY_DRT_ID'; // Default Record Type Id
    
    private static final Map<String, Map<String, Id>> RT_NAME_MAP = new Map<String, Map<String, Id>>();
    private static final Map<String, Map<Id, String>> RT_ID_MAP = new Map<String, Map<Id, String>>();
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'Schema_Functions : ' + s);
    }
    
    public static Map<String, String> getSelectOptionValueLabelMap(Schema.DescribeFieldResult dfr) {
        Map<String, String> somap = new Map<String, String>();
        List<SelectOption> solist = getSelectOptionList(dfr);
        if (solist != null && !solist.isEmpty()) {
            for (SelectOption so : solist) {
                // Value, Label
                somap.put(so.getValue(), so.getLabel());
            }
        }
        return somap;
    }

    public static List<SelectOption> getSelectOptionList(Schema.DescribeFieldResult dfr) {
    	List<SelectOption> solist = new List<SelectOption>();
    	try {
    		List<Schema.PicklistEntry> pelist = dfr.getPicklistValues();
    		solist = getSelectOptions(pelist); 
    	} catch(exception e) {
    		System.debug(e.getMessage());
    	}
    	return solist;
    }
    
    private static List<SelectOption> getSelectOptions(List<Schema.PicklistEntry> pelist) {
        List<SelectOption> solist = new List<SelectOption>();
        List<String> pvlist = getPicklistValues(pelist);
        if (pvlist != null && !pvlist.isEmpty()) {
            Integer i = 0;
            for (String s : pvlist) {
                // Value, Label
                solist.add(new SelectOption(String.valueOf(++i), s));
            }
        }
        return solist;
    }
    
    public static Set<String> getPicklistValueSet(Schema.DescribeFieldResult dfr) {
        Set<String> aset = new Set<String>();
        try {
            List<Schema.PicklistEntry> pelist = dfr.getPicklistValues();
	        if (pelist != null && !pelist.isEmpty()) {
	            for (Schema.PicklistEntry pe : pelist) {
	                if (pe.isActive()) {aset.add(pe.getValue());}
	            }
	        }
        } catch(exception e) {
            System.debug(e.getMessage());
        }
        return aset;
    }
    
    public static List<String> getPicklistValues(Schema.DescribeFieldResult dfr) {
        List<String> slist = new List<String>();
        try {
            List<Schema.PicklistEntry> pelist = dfr.getPicklistValues();
            slist = getPicklistValues(pelist);
        } catch(exception e) {System.debug(e.getMessage());}
        return slist;
    }
	
    private static List<String> getPicklistValues(List<Schema.PicklistEntry> pelist) {
        List<String> slist = new List<String>();
        if (pelist != null && !pelist.isEmpty()) {
            for (Schema.PicklistEntry pe : pelist) {
                if (pe.isActive()) {slist.add(pe.getValue());}
            }
            slist.sort();
        }
        return slist;
    }

    public static List<SelectOption> getSelectOptionList(Schema.DescribeFieldResult dfr,
                                                         List<String> labels) {
        List<SelectOption> solist = new List<SelectOption>();
        if (labels != null && !labels.isEmpty()) {
	        Map<String, String> lvmap = getSelectOptionLabelValueMap(dfr);
	        if (lvmap != null && !lvmap.isEmpty()) {
	        	for (String s : labels) {
	        		if (lvmap.containsKey(s)) {
		                // Value, Label
		                solist.add(new SelectOption(lvmap.get(s), s));
	        		}
	        	}
	        }
        }
        return solist;
    }
    
    private static Map<String, String> getSelectOptionLabelValueMap(Schema.DescribeFieldResult dfr) {
        Map<String, String> somap = new Map<String, String>();
        List<SelectOption> solist = getSelectOptionList(dfr);
        if (solist != null && !solist.isEmpty()) {
            for (SelectOption so : solist) {
                // Label, Value
                somap.put(so.getLabel(), so.getValue());
            }
        }
        return somap;
    }

    public static List<SelectOption> getPicklistOptions(Schema.DescribeFieldResult dfr) {
        return getPicklistOptions(dfr, false);
    }
    
    public static List<SelectOption> getSortedPicklistOptions(Schema.DescribeFieldResult dfr) {
    	return getPicklistOptions(dfr, true);
    }
    
    public static List<SelectOption> getPicklistOptions(Schema.DescribeFieldResult dfr,
                                                        Boolean sortedOptions) {
        List<SelectOption> solist = new List<SelectOption>();
        List<Schema.PicklistEntry> pelist;
        try {pelist = dfr.getPicklistValues();}
        catch(exception e) {debug(e.getMessage()); return solist;}
        if (pelist == null || pelist.isEmpty()) {return solist;}
        List<String> slist = new List<String>();
        for (Schema.PicklistEntry pe : pelist) {
            if (pe.isActive()) {slist.add(pe.getValue());}
        }
        if (slist.isEmpty()) {return solist;}
        if (sortedOptions) {slist.sort();}
        for (String s : slist) {solist.add(new SelectOption(s, s));}
        return solist;
    }
    
    public static Map<String, Map<String, Id>> getRecordTypeNameMap(List<String> objectNames) {
        try {
        	Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        	Integer i = 1; 
            for (String s : objectNames) {
            	if (i > MAX_DESCRIBES) {break;}
                s = s.toLowerCase();
            	if (gd.containsKey(s)) { 
                    System.debug(i + ':' + s); 
                    getRecordTypeNameMap(gd, s); i++;
            	}
            }
        } catch(Exception e) {System.debug(e.getMessage());}
        return RT_NAME_MAP;
    }
    
    public static Map<String, Map<Id, String>> getRecordTypeIdMap(List<String> objectNames) {
        try {
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Integer i = 1; 
            for (String s : objectNames) {
                if (i > MAX_DESCRIBES) {break;}
                s = s.toLowerCase();
                if (gd.containsKey(s)) {
                	System.debug(i + ':' + s); 
                    getRecordTypeIdMap(gd, s); i++;
                }
            }
        } catch(Exception e) {System.debug(e.getMessage());}
        return RT_ID_MAP;
    }
    
    public static Map<String, Id> getRecordTypeNameMap(String objectName) {
    	return getRecordTypeNameMap(null, objectName);
    }
    
    private static Map<String, Id> getRecordTypeNameMap(Map<String, Schema.SObjectType> gd, 
                                                        String objectName) {
        objectName = objectName.toLowerCase();
        Map<String, Id> rtmap = new Map<String, Id>();
        if (RT_NAME_MAP.containsKey(objectName)) {
            rtmap = RT_NAME_MAP.get(objectName);
        } else {
        	if (gd == null) {gd = Schema.getGlobalDescribe();}
            Map<String, String> smap = getRecordTypeMap(gd, objectName, RT_MAP_KEY_NAME);
            for (String s : smap.keySet()) {
            	if (s.startsWith('RT_MAP_KEY_DRT')) {continue;}
                rtmap.put(s, smap.get(s));
            }
            RT_NAME_MAP.put(objectName, rtmap);
        }
        return rtmap;
    }
    
    public static String getDefaultRecordTypeId(String objectName) {
        List<String> alist = getDefaultRecordTypeIdNameList(objectName);
        if (alist.size() > 0) {return alist[0];}
        return null;
    }
    
    public static List<String> getDefaultRecordTypeIdNameList(String objectName) {
    	Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, String> smap = getRecordTypeMap(gd, objectName, RT_MAP_KEY_NAME);
        List<String> alist = new List<String>();
        if (smap.containsKey(RT_MAP_KEY_DRT_NAME)) {
            alist.add(smap.get(RT_MAP_KEY_DRT_ID));
        	alist.add(smap.get(RT_MAP_KEY_DRT_NAME));
        }
        return alist;
    }
    
    public static Map<Id, String> getRecordTypeIdMap(String objectName) {
        return getRecordTypeIdMap(null, objectName);
    }
    
    private static Map<Id, String> getRecordTypeIdMap(Map<String, Schema.SObjectType> gd, 
                                                      String objectName) {
        objectName = objectName.toLowerCase();
        Map<Id, String> rtmap = new Map<Id, String>();
        if (RT_ID_MAP.containsKey(objectName)) {
            rtmap = RT_ID_MAP.get(objectName);
        } else {
            if (gd == null) {gd = Schema.getGlobalDescribe();}
            Map<String, String> smap = getRecordTypeMap(gd, objectName, RT_MAP_KEY_ID);
            for (String s : smap.keySet()) {
                if (s.startsWith('RT_MAP_KEY_DRT')) {continue;}
                rtmap.put(s, smap.get(s));
            }
            RT_ID_MAP.put(objectName, rtmap);
        }
        return rtmap;
    }
    
    private static Map<String, String> getRecordTypeMap(Map<String, Schema.SObjectType> gd, 
                                                        String objectName, String keyType) {
        Map<String, String> rtmap = new Map<String, String>(); String s;
        try {
            objectName = objectName.toLowerCase();
            if (gd.containsKey(objectName)) {
                Schema.SObjectType ot = gd.get(objectName);
                Schema.DescribeSObjectResult dor = ot.getDescribe();
                List<Schema.Recordtypeinfo> rtlist = dor.getRecordTypeInfos();
                if (rtlist != null && !rtlist.isEmpty()) {
                    for (Schema.Recordtypeinfo rt : rtlist) {
                    	s = rt.getName(); if (s != null) {s = s.trim();}
                        if (s != null && s != '' && s != 'Master') {
                            System.debug(objectName + ':' + rt.getName() + ':' + rt.getRecordTypeId());
                            if (RT_MAP_KEY_NAME.equals(keyType)) {
                                rtmap.put(rt.getName(), rt.getRecordTypeId());
                            } else if (RT_MAP_KEY_ID.equals(keyType)) {
                                rtmap.put(rt.getRecordTypeId(), rt.getName());
                            }
                            if (rt.isDefaultRecordTypeMapping()) {
                                rtmap.put(RT_MAP_KEY_DRT_ID, rt.getRecordTypeId());
                                rtmap.put(RT_MAP_KEY_DRT_NAME, rt.getName());
                            }
                        }
                    }
                }
            }
        } catch(Exception e) {System.debug(e.getMessage());}
        return rtmap;
    }

}