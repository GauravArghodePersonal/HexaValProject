public class PriceBookProductLineFunctions {

    public static final String NL = '\n';

    public static void setProductLinesDesc(Price_Book__c pb, 
                                           Map<String, List<Price_Book_Product_Line__c>> amap) {
        String pbid = pb.Id;
        if (amap != null && amap.containsKey(pbid)) {
            List<Price_Book_Product_Line__c> alist = amap.get(pbid);
            pb.Product_Lines_Desc__c = getProductLineString(alist, NL);
        }
    }
    
    public static String getProductLineString(List<Price_Book_Product_Line__c> alist,
                                         String lineBreak) {
        String s = '';
        if (alist == null || alist.isEmpty()) {
            return s;
        }
        for (Price_Book_Product_Line__c a : alist) {
            s += (a.Product_Line_Desc__c + ' - ' + a.Product_Line_Code__c + lineBreak);
        }
        return s;
    }
    
    public static String getProductLineString(String pbid,
                                         String lineBreak) {
        List<Price_Book_Product_Line__c> fmlist = getPriceBookProductLines(pbid);
        return getProductLineString(fmlist, lineBreak);
    }
    
    public static String getProductLineString(String pbid) {
        return getProductLineString(pbid, NL);
    }
    
    public static List<Price_Book_Product_Line__c> getPriceBookProductLines(String pbid) {
        return getPriceBookProductLines(new Set<String>{pbid});
    }
    
    public static List<Price_Book_Product_Line__c> getPriceBookProductLines(Set<String> pbids) {
        List<Price_Book_Product_Line__c> alist = [select Product_Line_Code__c, 
                                                   Product_Line_Desc__c,
                                                   Price_Book__c
                                              from Price_Book_Product_Line__c
                                             where Price_Book__c in :pbids 
                                           ];
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        return alist;
    }
    
    public static Map<String, List<Price_Book_Product_Line__c>> getPriceBookProductLineMap(Set<String> pbids) {
        List<Price_Book_Product_Line__c> alist = getPriceBookProductLines(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        List<Price_Book_Product_Line__c> blist;
        String pbid;
        Map<String, List<Price_Book_Product_Line__c>> amap = new Map<String, List<Price_Book_Product_Line__c>>();
        for (Price_Book_Product_Line__c a : alist) {
            pbid = a.Price_Book__c;
            if (amap.containsKey(pbid)) {
                blist = amap.get(pbid);
            } else {
                blist = new List<Price_Book_Product_Line__c>();
                amap.put(pbid, blist);
            }
            blist.add(a);
        }
        return amap;
    }
    
    public static Map<String, Set<String>> getPriceBookProductLineCodeMap(Set<String> pbids) {
        Map<String, List<Price_Book_Product_Line__c>> amap = getPriceBookProductLineMap(pbids);
        if (amap == null || amap.isEmpty()) {
            return null;
        }
        Map<String, Set<String>> bmap = new Map<String, Set<String>>();
        Set<String> keys = amap.keySet();
        for (String k : keys) {
            Set<String> pset = new Set<String>();
            List<Price_Book_Product_Line__c> plist = amap.get(k);
            for (Price_Book_Product_Line__c p : plist) {
                pset.add(p.Product_Line_Code__c);
            }
            bmap.put(k, pset);
        }
        return bmap;
    }
    
    public static Set<String> getPriceBookProductLineCodeSet(Set<String> pbids) {
        List<Price_Book_Product_Line__c> alist = getPriceBookProductLines(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        Set<String> aset = new Set<String>();
        for (Price_Book_Product_Line__c a : alist) {
            aset.add(a.Product_Line_Code__c);
        }
        return aset;
    }
    
    public static Set<Id> getPriceBookIdsForProductLines(Set<String> productLineCodes) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Product_Line__c p : [Select Price_Book__c
                                         from Price_Book_Product_Line__c
                                        where Product_Line_Code__c in :productLineCodes 
                                      ]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
  
    public static Set<Id> getPriceBookIdsForProductLines(Set<Id> pbIds,
                                                      Set<String> productLineCodes) {
        Set<Id> ids = new Set<Id>();
        List<Price_Book_Product_Line__c> alist = getPriceBookProductLines(pbIds, productLineCodes);
        if (alist == null || alist.isEmpty()) {
            return ids;
        }
        for (Price_Book_Product_Line__c p : alist) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
  
    public static List<Price_Book_Product_Line__c> getPriceBookProductLines(Set<Id> pbIds,
                                                                   Set<String> productLineCodes) {
        List<Price_Book_Product_Line__c> alist = new List<Price_Book_Product_Line__c>();
        for (Price_Book_Product_Line__c p : [Select Price_Book__c,
                                              Product_Line_Code__c
                                         from Price_Book_Product_Line__c
                                        where Price_Book__c in :pbIds
                                          and Product_Line_Code__c in :productLineCodes 
                                         ]) {
            alist.add(p);
        }
        return alist;
    }
    
}