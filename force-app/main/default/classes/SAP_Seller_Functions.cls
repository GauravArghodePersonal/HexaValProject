public class SAP_Seller_Functions {

    public static Integer MAX_RECS = 50000;
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }
    
    private static Boolean isNull(String s) {
    	return (s == null || s.trim().length() == 0);
    }
    
    public static void processAfterUpsert(List<SAP_Seller__c> ssa) {
    	Set<Id> userIds = new Set<Id>();
    	for (SAP_Seller__c ss : ssa) {userIds.add(ss.User__c);}
    	updateUserSapSellerNumbers(userIds);
    } 
    
    public static void updateUserSapSellerNumbers(Set<Id> userIds) {
        Map<String, String> umap = getSapSellerNumbers(userIds); String userId;
        for (List<User> usrs : [select Id, SAP_Cust_Num__c from User
                                 where IsActive = true and Id in :userIds]) {
            for (User u : usrs) {
                userId = u.Id; u.SAP_Cust_Num__c = '';
                if (umap.containsKey(userId)) {
                    u.SAP_Cust_Num__c = umap.get(userId);
                }
            }
            update usrs;
        }
    }
    
    public static Set<String> getSellerNumbers() {
        return getSellerNumbers(UserInfo.getUserId());
    }
    
    public static Set<String> getSellerNumbers(Id userId) {
    	Set<String> aset = new Set<String>();
        for (SAP_Seller__c ss : [select Name from SAP_Seller__c 
            where User__c = :userId]) {aset.add(ss.Name);}
        return aset;
    }
    
    private static Map<String, String> getSapSellerNumbers(Set<Id> userIds) {
        Map<String, Set<String>> amap = new Map<String, Set<String>>();
        Set<String> nums; String userId;
        for (SAP_Seller__c ss : [select Name, User__c from SAP_Seller__c
                                  where User__c in :userIds]) {
            userId = ss.User__c;
            if (!amap.containsKey(userId)) {
                nums = new Set<String>(); amap.put(userId, nums);
            } else {nums = amap.get(userId);}
            nums.add(ss.Name);
        }
        Map<String, String> bmap = new Map<String, String>();
        Set<String> kset = amap.keySet();
        for (String k : kset) {
            nums = amap.get(k); bmap.put(k, getString(nums));
        }
        return bmap;
    }
    
    private static String getString(Set<String> ss) {
        List<String> alist = new List<String>();
        alist.addAll(ss); String s = '', t;
        for (Integer i = 0; i < alist.size();i++) {
            t = alist.get(i);
            if (t != null && t.trim().length() > 0) {
                if (i > 0) {s += ',';}
                s += t;
            }
        }
        if (s.length() > 255) {s = s.substring(0, 255);}
        return s;
    }
    
    public static void deleteInactiveSellerRecords() {
    	for (List<SAP_Seller__c> ss : [select Id from SAP_Seller__c 
             where User__r.isActive = false and User__r.Permanently_Inactivated__c = true limit :MAX_RECS]) {
    		debug('Inactive Seller Records : '+ ss.size());
    		delete ss;
    	}
    }

    @future(callout = false)
    public static void deleteInactiveSellerRecords(Set<Id> userIds) {
    	if (userIds.isEmpty()) {return;}
        for (List<SAP_Seller__c> ss : [select Id from SAP_Seller__c 
            where User__c in :userIds and user__r.Permanently_Inactivated__c = true]) {
            debug('Inactive Seller Records : '+ ss.size());
            try {delete ss;} catch(Exception e){}
        }
    }
    
    public static User getUser(String sellerNum) {
    	if (isNull(sellerNum)) {return null;}
    	Set<String> aset = new Set<String>{sellerNum};
    	Map<String, User> umap = getSellerMap(aset);
    	if (umap != null && umap.containsKey(sellerNum)) {return umap.get(sellerNum);}
    	return null;
    }

    public static Map<String, User> getSellerMap(Set<String> sellerNums) {
    	Map<String, User> umap = new Map<String, User>();
    	if (sellerNums == null || sellerNums.isEmpty()) {return umap;}
    	setSellerMap(sellerNums, umap);
    	return umap;
    }

    public static void setSellerMap(Set<String> sellerNums, Map<String, User> umap) {
    	User u; String s;
        for (SAP_Seller__c ss : [select Id, Name, 
            User__r.Id, User__r.Name from SAP_Seller__c 
            where Name in :sellerNums and User__r.isActive = true
            order by User__r.Name]) {s = ss.Name; u = ss.User__r;
            if (!umap.containsKey(s)) {umap.put(s, u);}
        }
    }
    
}