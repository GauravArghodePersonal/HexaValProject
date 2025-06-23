public class PriceBookCustGroupFunctions {

    public static final String NL = '\n';

    public static void setCustomerGroupsDesc(Price_Book__c pb, 
                                              Map<String, List<Price_Book_Customer_Group__c>> amap) {
        String pbid = pb.Id;
        if (amap != null && amap.containsKey(pbid)) {
            List<Price_Book_Customer_Group__c> alist = amap.get(pbid);
            pb.Customer_Groups_Desc__c = getCustomerGroupString(alist, NL);
        }
    }
    
    public static String getCustomerGroupString(List<Price_Book_Customer_Group__c> alist,
                                                String lineBreak) {
        String s = '';
        if (alist == null || alist.isEmpty()) {
            return s;
        }
        for (Price_Book_Customer_Group__c a : alist) {
            s += (a.Customer_Group_Desc__c + ' - ' + a.Customer_Group_Code__c + lineBreak);
        }
        return s;
    }
    
    public static String getCustomerGroupString(String pbid) {
        return getCustomerGroupString(pbid, NL);
    }
    
    public static String getCustomerGroupString(String pbid,
                                                String lineBreak) {
        List<Price_Book_Customer_Group__c> cglist = getPriceBookCustomerGroups(pbid);
        return getCustomerGroupString(cglist, lineBreak);
    }
    
    public static List<Price_Book_Customer_Group__c> getPriceBookCustomerGroups(String pbid) {
        return getPriceBookCustomerGroups(new Set<String>{pbid});
    }
    
    public static List<Price_Book_Customer_Group__c> getPriceBookCustomerGroups(Set<String> pbids) {
        List<Price_Book_Customer_Group__c> alist = [select Customer_Group_Code__c, 
                                                           Customer_Group_Desc__c,
                                                           Price_Book__c,
                                                           SAP_Customer_Group__c
                                                      from Price_Book_Customer_Group__c
                                                     where Price_Book__c in :pbids 
                                                   ];
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        return alist;
    }
    
    public static Map<String, List<Price_Book_Customer_Group__c>> getPriceBookCustomerGroupMap(Set<String> pbids) {
        List<Price_Book_Customer_Group__c> alist = getPriceBookCustomerGroups(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        List<Price_Book_Customer_Group__c> blist;
        String pbid;
        Map<String, List<Price_Book_Customer_Group__c>> amap = new Map<String, List<Price_Book_Customer_Group__c>>();
        for (Price_Book_Customer_Group__c a : alist) {
            pbid = a.Price_Book__c;
            if (amap.containsKey(pbid)) {
                blist = amap.get(pbid);
            } else {
                blist = new List<Price_Book_Customer_Group__c>();
                amap.put(pbid, blist);
            }
            blist.add(a);
        }
        return amap;
    }
    
    public static Map<String, Set<String>> getPriceBookCustomerGroupIdMap(Set<String> pbids) {
        Map<String, List<Price_Book_Customer_Group__c>> amap = getPriceBookCustomerGroupMap(pbids);
        if (amap == null || amap.isEmpty()) {
            return null;
        }
        Map<String, Set<String>> bmap = new Map<String, Set<String>>();
        Set<String> keys = amap.keySet();
        for (String k : keys) {
            Set<String> pset = new Set<String>();
            List<Price_Book_Customer_Group__c> plist = amap.get(k);
            for (Price_Book_Customer_Group__c p : plist) {
                pset.add(p.SAP_Customer_Group__c);
            }
            bmap.put(k, pset);
        }
        return bmap;
    }
    
    public static Map<String, Set<String>> getPriceBookCustomerGroupCodeMap(Set<String> pbids) {
        Map<String, List<Price_Book_Customer_Group__c>> amap = getPriceBookCustomerGroupMap(pbids);
        if (amap == null || amap.isEmpty()) {
            return null;
        }
        Map<String, Set<String>> bmap = new Map<String, Set<String>>();
        Set<String> keys = amap.keySet();
        for (String k : keys) {
            Set<String> pset = new Set<String>();
            List<Price_Book_Customer_Group__c> plist = amap.get(k);
            for (Price_Book_Customer_Group__c p : plist) {
                pset.add(p.Customer_Group_Code__c);
            }
            bmap.put(k, pset);
        }
        return bmap;
    }
    
    public static Set<String> getPriceBookCustomerGroupIdSet(Set<String> pbids) {
        List<Price_Book_Customer_Group__c> alist = getPriceBookCustomerGroups(pbids);
        if (alist == null || alist.isEmpty()) {
            return null;
        }
        Set<String> aset = new Set<String>();
        for (Price_Book_Customer_Group__c a : alist) {
            aset.add(a.SAP_Customer_Group__c);
        }
        return aset;
    }
    
    private static Set<Id> getPriceBookIdsForCustGroups(Set<String> custGroupCodes) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Customer_Group__c p : [Select Price_Book__c
                                                 from Price_Book_Customer_Group__c
                                                where Customer_Group_Code__c in :custGroupCodes 
                                              ]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }

    public static Set<Id> getPriceBookIdsForCustGroups(List<Id> custGroupIds) {
        Set<Id> ids = new Set<Id>();
        for (Price_Book_Customer_Group__c p : [Select Price_Book__c
                                                 from Price_Book_Customer_Group__c
                                                where SAP_Customer_Group__c in :custGroupIds 
                                              ]) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }

    public static Set<Id> getPriceBookIdsForCustGroups(Set<Id> pbIds, 
                                                        List<Id> custGroupIds) {
        Set<Id> ids = new Set<Id>();
        List<Price_Book_Customer_Group__c> alist = getPriceBookCustGroups(pbIds, custGroupIds);
        if (alist == null || alist.isEmpty()) {
            return ids;
        }
        for (Price_Book_Customer_Group__c p : alist) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }

    public static List<Price_Book_Customer_Group__c> getPriceBookCustGroups(Set<Id> pbIds,
                                                                             List<Id> custGroupIds) {
        List<Price_Book_Customer_Group__c> alist = new List<Price_Book_Customer_Group__c>();
        for (Price_Book_Customer_Group__c p : [Select Price_Book__c,
                                                      SAP_Customer_Group__c
                                                 from Price_Book_Customer_Group__c
                                                where Price_Book__c in :pbIds
                                                  and SAP_Customer_Group__c in :custGroupIds 
                                              ]) {
            alist.add(p);
        }
        return alist;
    }
    
    public static Set<Id> getPriceBookIdsForCustGroups(Set<Id> pbIds, 
                                                        Set<String> custGroupCodes) {
        Set<Id> ids = new Set<Id>();
        List<Price_Book_Customer_Group__c> alist = getPriceBookCustGroups(pbIds, custGroupCodes);
        if (alist == null || alist.isEmpty()) {
            return ids;
        }
        for (Price_Book_Customer_Group__c p : alist) {
            ids.add(p.Price_Book__c);
        }
        return ids;
    }

    public static List<Price_Book_Customer_Group__c> getPriceBookCustGroups(Set<Id> pbIds,
                                                                             Set<String> custGroupCodes) {
        List<Price_Book_Customer_Group__c> alist = new List<Price_Book_Customer_Group__c>();
        for (Price_Book_Customer_Group__c p : [Select Price_Book__c,
                                                      SAP_Customer_Group__c
                                                 from Price_Book_Customer_Group__c
                                                where Price_Book__c in :pbIds
                                                  and Customer_Group_Code__c in :custGroupCodes 
                                              ]) {
            alist.add(p);
        }
        return alist;
    }
    
}