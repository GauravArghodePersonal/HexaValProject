public with sharing class ActivityUserGroup_Functions {

    private static final String DELIM = '-'; 
    private static final String SEMICOLON = ';'; 
    private static final String REGULAR_GROUP = 'Regular'; 
    private static final String PM_DEVELOPMENT_GROUP = 'PM Development Group'; 
    private static final String PRICING_COORDINATORS = 'Pricing Coordinators'; 
    
    private static Map<String, Activity_User_Group__c> recordMap = getActivityUserGroups();
    private static Map<String, List<String>> emailIdMap = new Map<String, List<String>>();
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private static Map<String, Activity_User_Group__c> getActivityUserGroups() {
        Map<String, Activity_User_Group__c> amap = new Map<String, Activity_User_Group__c>();
        for (Activity_User_Group__c a : [select Id, Name,
            Activity_Type__c, Group_Name__c, Group_Type__c,
            User_Public_Group__c from Activity_User_Group__c]) {
            amap.put(getRecordKey(a), a);
        }                                            
        return amap;
    }
    
    private static String getRecordKey(Activity_User_Group__c a) {
        return getRecordKey(a.Activity_Type__c, a.Group_Type__c, a.Group_Name__c);
    }
    
    private static String getRecordKey(String atype, String gtype, String gname) {
        return atype + DELIM + gtype + DELIM + gname;
    }
    
    public static void checkForDuplicate(Activity_User_Group__c[] aa) {
        for (Activity_User_Group__c a : aa) {
            String aid = a.id; String mapKey = getRecordKey(a);
            debug(aid+':'+mapKey);
            if (recordMap.containsKey(mapKey)) {
                Activity_User_Group__c b = recordMap.get(mapKey);
                String bid = b.id; debug(bid);
                if (aid == null || !bid.equals(aid)) {
                    a.addError(mapKey + ' already exists');
                }
            } else {
                recordMap.put(mapKey, a);
            }
        }
    }

    public static List<String> getPMDevelopmentGroup(String atype, String gname) {
        return getEmailIds(atype, PM_DEVELOPMENT_GROUP, gname);
    }
        
    public static List<String> getPricingCoordinators(String atype, String gname) {
        return getEmailIds(atype, PRICING_COORDINATORS, gname);
    }
        
    private static List<String> getEmailIds(String atype, String gtype, String gname) {
        if (isNull(gname)) {return null;}
        String mapKey = getRecordKey(atype, gtype, gname);
        if (!recordMap.containsKey(mapKey)) {return null;}
        if (emailIdMap.containsKey(mapKey)) {return emailIdMap.get(mapKey);}
        List<String> elist = getEmailIds(mapKey);
        emailIdMap.put(mapKey, elist);
        return elist;
    }
    
    private static List<String> getEmailIds(String mapKey) {
        List<String> elist = new List<String>();
        String[] names = getUserGroups(mapKey);
        List<User> ulist = [select email from user
                             where id in (
                                   select userorgroupid 
                                     from groupmember 
                                    where group.Type = :REGULAR_GROUP 
                                      and group.Name in :names) 
                           ];
        if (ulist == null || ulist.isEmpty()) {return elist;}
        for(User u : ulist) {elist.add(u.email);}
        return elist;
    }
    
    private static String[] getUserGroups(String mapKey) {
        Activity_User_Group__c a = recordMap.get(mapKey);
        String upg = a.User_Public_Group__c;
        String[] sa = upg.split(SEMICOLON);
        return sa;
    }
    
/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    @isTest public static void testMe() {
        testCheckForDuplicate();
        testGetEmailIds();
    }
    
    private static void testCheckForDuplicate() {
        List<Activity_User_Group__c> alist = new List<Activity_User_Group__c>();
        Activity_User_Group__c a = new Activity_User_Group__c();
        a.Activity_Type__c = 'Task'; a.Group_Type__c = 'testGroupType';
        a.Group_Name__c = 'testGroup1';
        a.User_Public_Group__c = 'testGroup';
        Activity_User_Group__c b = new Activity_User_Group__c();
        b.Activity_Type__c = 'Task'; b.Group_Type__c = 'testGroupType';
        b.Group_Name__c = 'testGroup2';
        b.User_Public_Group__c = 'testGroup';
        Activity_User_Group__c c = new Activity_User_Group__c();
        c.Activity_Type__c = 'Task'; c.Group_Type__c = 'testGroupType';
        c.Group_Name__c = 'testGroup1';
        c.User_Public_Group__c = 'testGroup';
        insert a;
        insert b;
        // test for duplicate on new
        try {insert c;} catch (Exception e) {debug(e.getMessage());}
        // test for duplicate on update
        b.Group_Name__c = 'testGroup1';
        try {update b;} catch (Exception e) {debug(e.getMessage());}
        getActivityUserGroups();
    }
    
    private static void testGetEmailIds() {
        getPMDevelopmentGroup('Task', 'xxxxxx');
        List<Activity_User_Group__c> augs = recordMap.values();
        if (augs != null && !augs.isEmpty()) {
            Activity_User_Group__c a = augs[0];
            getPMDevelopmentGroup(a.Activity_Type__c, a.Group_Name__c);
            getPricingCoordinators(a.Activity_Type__c, a.Group_Name__c);
            //getEmailIds(a);
        }
    }
}