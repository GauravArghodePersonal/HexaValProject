public class PriceBookSalesOrgFunctions {

    public static final String NL = '\n';

    public static void setSalesOrgsDesc(Price_Book__c pb, 
                                         Map<String, List<Price_Book_Sales_Org__c>> amap) {
        String pbid = pb.Id;
        if (amap != null && amap.containsKey(pbid)) {
            List<Price_Book_Sales_Org__c> alist = amap.get(pbid);
            pb.Sales_Orgs_Desc__c = getSalesOrgString(alist, NL);
        }
    }
    
    public static String getSalesOrgString(List<Price_Book_Sales_Org__c> alist, 
                                           String lineBreak) {
        String s = '';
        if (alist == null || alist.isEmpty()) {
            return s;
        }
        for (Price_Book_Sales_Org__c a : alist) {
            s += (a.Sales_Org_Desc__c + ' - ' + a.Sales_Org_Code__c + lineBreak);
        }
        return s;
    }
    
    public static String getSalesOrgString(String pbid,
                                           String lineBreak) {
        List<Price_Book_Sales_Org__c> solist = getPriceBookSalesOrgs(pbid);
        return getSalesOrgString(solist, lineBreak);
    }
    
    public static String getSalesOrgString(String pbid) {
        return getSalesOrgString(pbid, NL);
    }
    
    public static List<Price_Book_Sales_Org__c> getPriceBookSalesOrgs(String pbid) {
        return getPriceBookSalesOrgs(new Set<String>{pbid});
    }
    
    public static List<Price_Book_Sales_Org__c> getPriceBookSalesOrgs(Set<String> pbids) {
        List<Price_Book_Sales_Org__c> alist = [select Sales_Org_Code__c, 
                                                      Sales_Org_Desc__c,
                                                      Price_Book__c,
                                                      SAP_Sales_Org__c
                                                 from Price_Book_Sales_Org__c
                                                where Price_Book__c in :pbids 
                                              ];
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        return alist;
    }
    
    public static Map<String, List<Price_Book_Sales_Org__c>> getPriceBookSalesOrgMap(Set<String> pbids) {
        List<Price_Book_Sales_Org__c> alist = getPriceBookSalesOrgs(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        List<Price_Book_Sales_Org__c> blist;
        String pbid;
        Map<String, List<Price_Book_Sales_Org__c>> amap = new Map<String, List<Price_Book_Sales_Org__c>>();
        for (Price_Book_Sales_Org__c a : alist) {
            pbid = a.Price_Book__c;
            if (amap.containsKey(pbid)) {
                blist = amap.get(pbid);
            } else {
                blist = new List<Price_Book_Sales_Org__c>();
                amap.put(pbid, blist);
            }
            blist.add(a);
        }
        return amap;
    }
    
    public static Map<String, Set<String>> getPriceBookSalesOrgCodeMap(Set<String> pbids) {
        Map<String, List<Price_Book_Sales_Org__c>> amap = getPriceBookSalesOrgMap(pbids);
        if (amap == null || amap.isEmpty()) {
            return null;
        }
        Map<String, Set<String>> bmap = new Map<String, Set<String>>();
        Set<String> keys = amap.keySet();
        for (String k : keys) {
            Set<String> pset = new Set<String>();
            List<Price_Book_Sales_Org__c> plist = amap.get(k);
            for (Price_Book_Sales_Org__c p : plist) {
                pset.add(p.Sales_Org_Code__c);
            }
            bmap.put(k, pset);
        }
        return bmap;
    }
    
    public static Map<String, Set<String>> getPriceBookSalesOrgIdMap(Set<String> pbids) {
        Map<String, List<Price_Book_Sales_Org__c>> amap = getPriceBookSalesOrgMap(pbids);
        if (amap == null || amap.isEmpty()) {
            return null;
        }
        Map<String, Set<String>> bmap = new Map<String, Set<String>>();
        Set<String> keys = amap.keySet();
        for (String k : keys) {
            Set<String> pset = new Set<String>();
            List<Price_Book_Sales_Org__c> plist = amap.get(k);
            for (Price_Book_Sales_Org__c p : plist) {
                pset.add(p.SAP_Sales_Org__c);
            }
            bmap.put(k, pset);
        }
        return bmap;
    }
    
    public static Set<String> getPriceBookSalesOrgIdSet(Set<String> pbids) {
        List<Price_Book_Sales_Org__c> alist = getPriceBookSalesOrgs(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        Set<String> aset = new Set<String>();
        for (Price_Book_Sales_Org__c a : alist) {
            aset.add(a.SAP_Sales_Org__c);
        }
        return aset;
    }
    
    public static Set<Id> getPriceBookIdsForSalesOrgs(Set<String> salesOrgCodes) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Sales_Org__c p : [Select Price_Book__c
                                            from Price_Book_Sales_Org__c
                                           where Sales_Org_Code__c in :salesOrgCodes 
                                         ]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
    
    public static Set<Id> getPriceBookIdsForSalesOrgs(List<Id> salesOrgIds) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Sales_Org__c p : [Select Price_Book__c
                                            from Price_Book_Sales_Org__c
                                           where SAP_Sales_Org__c in :salesOrgIds 
                                         ]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
    
    public static Set<Id> getPriceBookIdsForSalesOrgs(Set<Id> pbIds,
                                                       Set<String> salesOrgCodes) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Sales_Org__c p : [Select Price_Book__c
                                            from Price_Book_Sales_Org__c
                                           where Price_Book__c in :pbIds
                                             and Sales_Org_Code__c in :salesOrgCodes 
                                         ]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
    
    public static Set<Id> getPriceBookIdsForSalesOrgs(Set<Id> pbIds,
                                                      List<Id> salesOrgIds) {
        Set<Id> ids = new Set<Id>();
        List<Price_Book_Sales_Org__c> alist = getPriceBookSalesOrgs(pbIds, salesOrgIds);
        if (alist == null || alist.isEmpty()) {
            return ids;
        }
        for (Price_Book_Sales_Org__c p : alist) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }
    
    public static List<Price_Book_Sales_Org__c> getPriceBookSalesOrgs(Set<Id> pbIds,
                                                                       List<Id> salesOrgIds) {
        List<Price_Book_Sales_Org__c> alist = new List<Price_Book_Sales_Org__c>();
        for (Price_Book_Sales_Org__c p : [Select Price_Book__c,
                                                 SAP_Sales_Org__c
                                            from Price_Book_Sales_Org__c
                                           where Price_Book__c in :pbIds
                                             and SAP_Sales_Org__c in :salesOrgIds
                                         ]) {
            alist.add(p);
        }
        return alist;
    }

}