public class PriceBookFamilyFunctions {

    public static final String NL = '\n';

    public static void setProductFamiliesDesc(Price_Book__c pb, 
                                               Map<String, List<Price_Book_Family__c>> amap) {
        String pbid = pb.Id;
        if (amap != null && amap.containsKey(pbid)) {
            List<Price_Book_Family__c> alist = amap.get(pbid);
            pb.Product_Families_Desc__c = getFamilyString(alist, NL);
        }
    }
    
    public static String getFamilyString(List<Price_Book_Family__c> alist,
                                         String lineBreak) {
        String s = '';
        if (alist == null || alist.isEmpty()) {
            return s;
        }
        for (Price_Book_Family__c a : alist) {
            s += (a.Family_Desc__c + ' - ' + a.Family_Code__c + lineBreak);
        }
        return s;
    }
    
    public static String getFamilyString(String pbid,
                                         String lineBreak) {
        List<Price_Book_Family__c> fmlist = getPriceBookFamilies(pbid);
        return getFamilyString(fmlist, lineBreak);
    }
    
    public static String getFamilyString(String pbid) {
        return getFamilyString(pbid, NL);
    }
    
    public static List<Price_Book_Family__c> getPriceBookFamilies(String pbid) {
        return getPriceBookFamilies(new Set<String>{pbid});
    }
    
    public static List<Price_Book_Family__c> getPriceBookFamilies(Set<String> pbids) {
        List<Price_Book_Family__c> alist = [select Family_Code__c, 
                                                   Family_Desc__c,
                                                   Price_Book__c
                                              from Price_Book_Family__c
                                             where Price_Book__c in :pbids 
                                           ];
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        return alist;
    }
    
    public static Map<String, List<Price_Book_Family__c>> getPriceBookFamilyMap(Set<String> pbids) {
        List<Price_Book_Family__c> alist = getPriceBookFamilies(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        List<Price_Book_Family__c> blist;
        String pbid;
        Map<String, List<Price_Book_Family__c>> amap = new Map<String, List<Price_Book_Family__c>>();
        for (Price_Book_Family__c a : alist) {
            pbid = a.Price_Book__c;
            if (amap.containsKey(pbid)) {
                blist = amap.get(pbid);
            } else {
                blist = new List<Price_Book_Family__c>();
                amap.put(pbid, blist);
            }
            blist.add(a);
        }
        return amap;
    }
    
    public static Map<String, Set<String>> getPriceBookFamilyCodeMap(Set<String> pbids) {
        Map<String, List<Price_Book_Family__c>> amap = getPriceBookFamilyMap(pbids);
        if (amap == null || amap.isEmpty()) {
            return null;
        }
        Map<String, Set<String>> bmap = new Map<String, Set<String>>();
        Set<String> keys = amap.keySet();
        for (String k : keys) {
            Set<String> pset = new Set<String>();
            List<Price_Book_Family__c> plist = amap.get(k);
            for (Price_Book_Family__c p : plist) {
                pset.add(p.Family_Code__c);
            }
            bmap.put(k, pset);
        }
        return bmap;
    }
    
    public static Set<String> getPriceBookFamilyCodeSet(Set<String> pbids) {
        List<Price_Book_Family__c> alist = getPriceBookFamilies(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        Set<String> aset = new Set<String>();
        for (Price_Book_Family__c a : alist) {
            aset.add(a.Family_Code__c);
        }
        return aset;
    }
    
    public static Set<Id> getPriceBookIdsForFamilies(Set<String> familyCodes) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Family__c p : [Select Price_Book__c
                                         from Price_Book_Family__c
                                        where Family_Code__c in :familyCodes 
                                      ]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
  
    public static Set<Id> getPriceBookIdsForFamilies(Set<Id> pbIds,
                                                      Set<String> familyCodes) {
        Set<Id> ids = new Set<Id>();
        List<Price_Book_Family__c> alist = getPriceBookFamilies(pbIds, familyCodes);
        if (alist == null || alist.isEmpty()) {
            return ids;
        }
        for (Price_Book_Family__c p : alist) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
  
    public static List<Price_Book_Family__c> getPriceBookFamilies(Set<Id> pbIds,
                                                                   Set<String> familyCodes) {
        List<Price_Book_Family__c> alist = new List<Price_Book_Family__c>();
        for (Price_Book_Family__c p : [Select Price_Book__c,
                                              Family_Code__c
                                         from Price_Book_Family__c
                                        where Price_Book__c in :pbIds
                                          and Family_Code__c in :familyCodes 
                                         ]) {
            alist.add(p);
        }
        return alist;
    }
    
}