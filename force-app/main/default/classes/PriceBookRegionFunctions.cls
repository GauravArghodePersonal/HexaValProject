public class PriceBookRegionFunctions {

    public static final String NL = '\n';

    public static void setRegionsDesc(Price_Book__c pb, 
                                       Map<String, List<Price_Book_Region__c>> amap) {
        String pbid = pb.Id;
        if (amap != null && amap.containsKey(pbid)) {
            List<Price_Book_Region__c> alist = amap.get(pbid);
            pb.Regions_Desc__c = getRegionString(alist, NL);
        }
    }
    
    public static String getRegionString(List<Price_Book_Region__c> alist,
                                         String lineBreak) {
        String s = '';
        if (alist == null || alist.isEmpty()) {
            return s;
        }
        for (Price_Book_Region__c a : alist) {
            s += (a.Region_Desc__c + ' - ' + a.Region_Code__c + lineBreak);
        }
        return s;
    }
    
    public static String getRegionString(String pbid, 
                                         String lineBreak) {
        List<Price_Book_Region__c> rglist = getPriceBookRegions(pbid);
        return getRegionString(rglist, lineBreak);
    }
    
    public static String getRegionString(String pbid) {
        return getRegionString(pbid, NL);
    }
    
    public static List<Price_Book_Region__c> getPriceBookRegions(String pbid) {
        return getPriceBookRegions(new Set<String>{pbid});
    }
    
    public static List<Price_Book_Region__c> getPriceBookRegions(Set<String> pbids) {
        List<Price_Book_Region__c> alist = [select Region_Code__c, 
                                                   Region_Desc__c,
                                                   Price_Book__c,
                                                   SAP_Region__c
                                              from Price_Book_Region__c
                                             where Price_Book__c in :pbids 
                                           ];
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        return alist;
    }
    
    public static Map<String, List<Price_Book_Region__c>> getPriceBookRegionMap(Set<String> pbids) {
        List<Price_Book_Region__c> alist = getPriceBookRegions(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        List<Price_Book_Region__c> blist;
        String pbid;
        Map<String, List<Price_Book_Region__c>> amap = new Map<String, List<Price_Book_Region__c>>();
        for (Price_Book_Region__c a : alist) {
            pbid = a.Price_Book__c;
            if (amap.containsKey(pbid)) {
                blist = amap.get(pbid);
            } else {
                blist = new List<Price_Book_Region__c>();
                amap.put(pbid, blist);
            }
            blist.add(a);
        }
        return amap;
    }
    
    public static Map<String, Set<String>> getPriceBookRegionCodeMap(Set<String> pbids) {
        Map<String, List<Price_Book_Region__c>> amap = getPriceBookRegionMap(pbids);
        if (amap == null || amap.isEmpty()) {
            return null;
        }
        Map<String, Set<String>> bmap = new Map<String, Set<String>>();
        Set<String> keys = amap.keySet();
        for (String k : keys) {
            Set<String> pset = new Set<String>();
            List<Price_Book_Region__c> plist = amap.get(k);
            for (Price_Book_Region__c p : plist) {
                pset.add(p.Region_Code__c);
            }
            bmap.put(k, pset);
        }
        return bmap;
    }
    
    public static Map<String, Set<String>> getPriceBookRegionIdMap(Set<String> pbids) {
        Map<String, List<Price_Book_Region__c>> amap = getPriceBookRegionMap(pbids);
        if (amap == null || amap.isEmpty()) {
            return null;
        }
        Map<String, Set<String>> bmap = new Map<String, Set<String>>();
        Set<String> keys = amap.keySet();
        for (String k : keys) {
            Set<String> pset = new Set<String>();
            List<Price_Book_Region__c> plist = amap.get(k);
            for (Price_Book_Region__c p : plist) {
                pset.add(p.SAP_Region__c);
            }
            bmap.put(k, pset);
        }
        return bmap;
    }
    
    public static Set<String> getPriceBookRegionIdSet(Set<String> pbids) {
        List<Price_Book_Region__c> alist = getPriceBookRegions(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        Set<String> aset = new Set<String>();
        for (Price_Book_Region__c a : alist) {
            aset.add(a.SAP_Region__c);
        }
        return aset;
    }
    
    public static Set<Id> getPriceBookIdsForRegions(Set<String> regionCodes) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Region__c p : [Select Price_Book__c
                                         from Price_Book_Region__c
                                        where Region_Code__c in :regionCodes 
                                      ]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
  
    public static Set<Id> getPriceBookIdsForRegions(List<Id> regIds) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Region__c p : [Select Price_Book__c
                                         from Price_Book_Region__c
                                        where SAP_Region__c in :regIds 
                                      ]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
  
    public static Set<Id> getPriceBookIdsForRegions(List<Id> regIds,
                                                    Set<String> recStats) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Region__c p : [
            Select Price_Book__c
              from Price_Book_Region__c
             where SAP_Region__c in :regIds
               and Price_Book__r.Record_Status__c in :recStats]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
  
    public static Set<Id> getPriceBookIdsForRegions(Set<Id> pbIds,
                                                     List<Id> regIds) {
        Set<Id> ids = new Set<Id>();
        List<Price_Book_Region__c> alist = getPriceBookRegions(pbIds, regIds);
        if (alist == null || alist.isEmpty()) {
            return ids;
        }
        for (Price_Book_Region__c p : alist) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
  
    public static List<Price_Book_Region__c> getPriceBookRegions(Set<Id> pbIds,
                                                                  List<Id> regIds) {
        List<Price_Book_Region__c> alist = new List<Price_Book_Region__c>();
        for (Price_Book_Region__c p : [Select Price_Book__c,
                                              SAP_Region__c
                                         from Price_Book_Region__c
                                        where Price_Book__c in :pbIds
                                          and SAP_Region__c in :regIds 
                                         ]) {
            alist.add(p);
        }
        return alist;
    }
    
    public static Set<Id> getPriceBookIdsForRegions(Set<Id> pbIds,
                                                     Set<String> regionCodes) {
        Set<Id> ids = new Set<Id>();
        List<Price_Book_Region__c> alist = getPriceBookRegions(pbIds, regionCodes);
        if (alist == null || alist.isEmpty()) {
            return ids;
        }
        for (Price_Book_Region__c p : alist) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
  
    public static List<Price_Book_Region__c> getPriceBookRegions(Set<Id> pbIds,
                                                                  Set<String> regionCodes) {
        List<Price_Book_Region__c> alist = new List<Price_Book_Region__c>();
        for (Price_Book_Region__c p : [Select Price_Book__c,
                                              SAP_Region__c
                                         from Price_Book_Region__c
                                        where Price_Book__c in :pbIds
                                          and Region_Code__c in :regionCodes 
                                         ]) {
            alist.add(p);
        }
        return alist;
    }
    
}