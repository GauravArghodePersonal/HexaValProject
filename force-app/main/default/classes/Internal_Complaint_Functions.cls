public class Internal_Complaint_Functions {

    public static final String DELIM = '-';

    public static final String RTYPE_IC = 'Internal_Complaint__c';

    // 20 Jan 2015 TechM: For Request-0414. Change of Internal Complaints --> Internal Suggestions. 
    public static final String STATUS_UNDER_REVIEW = 'Under Investigation - by Suggestion Owner';
    //public static final String STATUS_UNDER_REVIEW = 'Under Investigation - by Complaint Owner';
    public static final String STATUS_RESEARCHING  = 'Researching';
    public static final String STATUS_FINAL_REVIEW = 'Final Review for Approval - by Originated by';
    public static final String STATUS_RESOLVED     = 'Closed - Resolved';
    public static final String STATUS_AIRS_ENTERED = 'Closed - Entered into AIRS';
    public static final String STATUS_ALL          = 'All';
    
    public static final Set<String> CLOSED_STATS = new Set<String>{STATUS_RESOLVED, STATUS_AIRS_ENTERED};
    public static final Set<String> UPDATE_STATS = new Set<String>{STATUS_UNDER_REVIEW, STATUS_FINAL_REVIEW};
    
    public static final String QRY1 = ''
        + 'select Id, Name, CreatedBy.Name, CreatedDate, Owner.Name,'
        + '       Business_Unit__c, Concern_Issue__c, Days_Open__c,'
        + '       Days_in_Status1__c, Days_in_Status2__c, Days_in_Status3__c,'
        + '       Issue__c, Region__c, Status__c, Topic__c,'
        + '      (select Id, Name, Status__c, Status_Days__c'
        + '         from Internal_Complaint_Logs__r)'
        + '  from Internal_Complaint__c';
        
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Internal_Complaint_Functions : ' + s);
    }
    
    private static Integer getInteger(Decimal d) {
        return (d != null) ? d.intValue() : 0; 
    }
    
    private static String getIntString(Decimal d) {
        Integer n = (d != null) ? d.intValue() : 0;
        return (n == 0) ? '' : String.valueOf(n); 
    }
    
    public class Rec {
        public Boolean selected   {get; set;}

        public Integer recNum     {get; set;}

        public String  concern    {get; set;}
        public String  crtBy      {get; set;}
        public String  crtDate    {get; set;}
        public String  issue      {get; set;}
        public String  owner      {get; set;}
        public String  recId      {get; set;}
        public String  recName    {get; set;}
        public String  recStat    {get; set;}
        public String  statDays1  {get; set;}
        public String  statDays2  {get; set;}
        public String  status     {get; set;}
        public String  topic      {get; set;}
        
        public Rec(Internal_Complaint__c r, Integer n) {
            init1(n); init2(r);
        }
        
        private void init1(Integer n) {recNum = n; selected = false;}
        
        private void init2(Internal_Complaint__c r) {
            recId = r.Id; recName = r.Name; concern = r.Concern_Issue__c; 
            crtBy = r.CreatedBy.Name; crtDate = r.CreatedDate.date().format(); 
            issue = r.Issue__c; owner = r.Owner.Name;
            statDays1 = getIntString(r.Days_in_Status1__c);
            statDays2 = getIntString(r.Days_in_Status2__c);
            status = r.Status__c; topic = r.Topic__c;
        }
        
    }
    
    public static void doAfterInsert(List<Internal_Complaint__c> alist) {
        upsertComplaintLogs(alist);
    }
    
    public static void doAfterUpdate(Map<Id, Internal_Complaint__c> nmap, 
                                     Map<Id, Internal_Complaint__c> omap) {
        List<Internal_Complaint__c> alist = nmap.values(), blist = new 
        List<Internal_Complaint__c>(); Set<String> ostatSet = new Set<String>();
        Map<Id, String> ostatMap = new Map<Id, String>();
        Internal_Complaint__c o; String nstat, ostat;
        for (Internal_Complaint__c a : alist) {
            o = omap.get(a.Id); nstat = a.Status__c; ostat = o.Status__c;
            if (noChange(nstat, ostat)) {continue;}
            blist.add(a); ostatMap.put(a.Id, ostat); ostatSet.add(ostat);
        }
        if (blist.isEmpty()) {return;}
        upsertComplaintLogs(blist, ostatMap, ostatSet);
    }
    
    public static void doBeforeInsert(List<Internal_Complaint__c> alist) {
        Date d = Date.today();
        Map<String, Internal_Complaint_Config__c> cmap = getConfigMap(); 
        for (Internal_Complaint__c a : alist) {
            setFields1(a, cmap);
            if (String.isBlank(a.Status__c)) {a.Status__c = STATUS_UNDER_REVIEW;}
            if (a.Status__c == STATUS_UNDER_REVIEW) {a.Under_Review_In__c = d;}
        }
    }
    
    public static void doBeforeUpdate(Map<Id, Internal_Complaint__c> nmap, 
                                      Map<Id, Internal_Complaint__c> omap) {
        List<Internal_Complaint__c> alist = nmap.values();
        Map<String, Internal_Complaint_Config__c> cmap = getConfigMap(); 
        Date d = Date.today(); Internal_Complaint__c o; String okey, nkey;
        for (Internal_Complaint__c a : alist) {
            o = omap.get(a.Id); setStatusDates(a, o, d);
            okey = getKey(o); nkey = getKey(a);
            if (nkey != okey) {setFields1(a, cmap);}
        }
    }
    
    private static void setStatusDates(Internal_Complaint__c a, Internal_Complaint__c o, Date d) {
        String nstat = a.Status__c, ostat = o.Status__c;
        if (noChange(nstat, ostat)) {return;}
        if (CLOSED_STATS.contains(nstat) && CLOSED_STATS.contains(ostat)) {return;}

        if (nstat != null) {
            if (nstat == STATUS_UNDER_REVIEW) {a.Under_Review_In__c  = d;} else
            if (nstat == STATUS_RESEARCHING)  {a.Researching_In__c   = d;} else
            if (nstat == STATUS_FINAL_REVIEW) {a.Final_Review_In__c  = d;} else
            if (CLOSED_STATS.contains(nstat)) {a.Date_Closed__c      = d;}
        }

        if (ostat != null) {
            if (ostat == STATUS_UNDER_REVIEW) {a.Under_Review_Out__c = d;} else
            if (ostat == STATUS_RESEARCHING)  {a.Researching_Out__c  = d;} else
            if (ostat == STATUS_FINAL_REVIEW) {a.Final_Review_Out__c = d;}
        }
    }
    
    private static Boolean noChange(String s1, String s2) {
        return (s1 == null && s2 == null) ||
               (s1 != null && s2 != null && s1 == s2);
    }
    
    private static void setFields1(Internal_Complaint__c a, Map<String, Internal_Complaint_Config__c> cmap) {
        Internal_Complaint_Config__c c; String k = getKey(a);
        if (cmap.containsKey(k)) {
            c = cmap.get(k);
            if (c.Complaint_Owner__c != null) {a.OwnerId = c.Complaint_Owner__c;}
            if (c.Escalation_Manager__c != null) {a.Escalation_Manager__c = c.Escalation_Manager__c;}
        }
    }
    
    private static Map<String, Internal_Complaint_Config__c> getConfigMap() {
        Map<String, Internal_Complaint_Config__c> amap = new Map<String, Internal_Complaint_Config__c>();
        for (Internal_Complaint_Config__c a : [
            select Id, Name, Complaint_Owner__c, Concern_Issue__c, 
                   Escalation_Manager__c, Topic__c
              from Internal_Complaint_Config__c]) {amap.put(getKey(a), a);}
        return amap;
    }
    
    private static String getKey(Internal_Complaint__c a) {
        return getKey(a.Topic__c, a.Concern_Issue__c);
    }

    private static String getKey(Internal_Complaint_Config__c a) {
        return getKey(a.Topic__c, a.Concern_Issue__c);
    }

    private static String getKey(String topic, String concern) {
        return topic + DELIM + concern;
    }
    
    private static String getComplaintLogKey(Internal_Complaint__c a, String ymd) {
        return a.Id + DELIM + a.Status__c + DELIM + ymd;
    }
    
    private static void upsertComplaintLogs(List<Internal_Complaint__c> alist) {
        Internal_Complaint_Log__c c;
        List<Internal_Complaint_Log__c> clist = new
        List<Internal_Complaint_Log__c>(); Date d = Date.today();
        String ymd = DateTime.now().format('yyyy-MM-dd');
        for (Internal_Complaint__c a : alist) {
            if (String.isBlank(a.Status__c)) {continue;}
            c = new Internal_Complaint_Log__c();
            c.Internal_Complaint__c = a.Id;
            c.Key__c = getComplaintLogKey(a, ymd);
            c.Status__c = a.Status__c;
            c.Status_Start_Date__c = d;
            if (CLOSED_STATS.contains(a.Status__c)) {
                c.Status_End_Date__c = d;
            }
            clist.add(c);
        }
        if (clist.isEmpty()) {return;}
        try {upsert clist Key__c;} catch(Exception e) {
            debug('upsert logs failure : ' + e.getMessage());
        }
    }

    private static void upsertComplaintLogs(List<Internal_Complaint__c> alist, 
                                            Map<Id, String> ostatMap, Set<String> ostatSet) {
        updateComplaintLogs(ostatMap, ostatSet);
        upsertComplaintLogs(alist);
    }
    
    private static void updateComplaintLogs(Map<Id, String> ostatMap, Set<String> ostatSet) {
        Map<Id, Internal_Complaint_Log__c> umap = new Map<Id, Internal_Complaint_Log__c>();
        Set<Id> icids = ostatMap.keySet();
        for (Internal_Complaint_Log__c a : [
            select Id, Name, Internal_Complaint__c, 
                   Key__c, Status__c, Status_End_Date__c
              from Internal_Complaint_Log__c
             where Internal_Complaint__c in :icids
               and Status__c in :ostatSet
             order by Key__c]) {
            umap.put(a.Internal_Complaint__c, a);
        }
        if (umap.isEmpty()) {return;}
        List<Internal_Complaint_Log__c> blist = umap.values(), clist = new
        List<Internal_Complaint_Log__c>(); Date d = Date.today();
        for (Internal_Complaint_Log__c b : blist) {
            if (ostatMap.containsKey(b.Internal_Complaint__c) &&
                ostatMap.get(b.Internal_Complaint__c) == b.Status__c) {
                b.Status_End_Date__c = d; clist.add(b);
            }
        }
        if (clist.isEmpty()) {return;}
        try {update clist;} catch(Exception e) {
            debug('update logs failure : ' + e.getMessage());
        }
    }
    
    public static void updateStatusDays(List<Internal_Complaint__c> alist, Boolean updateAll) {
        Set<Id> aset = new Set<Id>();
        for (Internal_Complaint__c a : alist) {
            if (updateAll || UPDATE_STATS.contains(a.Status__c)) {aset.add(a.Id);}
        }
        if (aset.isEmpty()) {return;}
        String q = QRY1 + ' where Id in :aset';
        List<Internal_Complaint__c> blist = Database.query(q);
        List<Internal_Complaint__c> clist = new List<Internal_Complaint__c>();
        Integer n, n1, n2, m1, m2; String s; Internal_Complaint__c c;
        List<Internal_Complaint_Log__c> rlist;
        for (Internal_Complaint__c b : blist) {
            rlist = b.Internal_Complaint_Logs__r;
            if (rlist == null || rlist.isEmpty()) {continue;}
            n1 = 0; n2 = 0; 
            m1 = getInteger(b.Days_in_Status1__c); 
            m2 = getInteger(b.Days_in_Status2__c);
            for (Internal_Complaint_Log__c r : rlist) {
                s = r.Status__c;
                if (String.isBlank(s)) {continue;}
                n = getInteger(r.Status_Days__c);
                if (s == STATUS_UNDER_REVIEW) {n1 += n;} else
                if (s == STATUS_FINAL_REVIEW) {n2 += n;}
            }
            if (n1 == m1 && n2 == m2) {continue;}
            c = new Internal_Complaint__c(Id = b.Id);
            c.Days_in_Status1__c = n1; c.Days_in_Status2__c = n2;
            clist.add(c);
        }
        if (clist.isEmpty()) {return;}
        try {update clist;} catch(Exception e) {
            debug('updateStatusDays failed : ' + e.getMessage());
        } 
    }
    
    public static List<SelectOption> getStatusOpts() {
        List<SelectOption> alist = new List<SelectOption>();
        alist.add(new SelectOption(STATUS_ALL,          STATUS_ALL         ));
        alist.add(new SelectOption(STATUS_UNDER_REVIEW, STATUS_UNDER_REVIEW));
        alist.add(new SelectOption(STATUS_FINAL_REVIEW, STATUS_FINAL_REVIEW));
        return alist;
    }
    
    public static List<Rec> getRecs(PaginationController pc1, PaginationController.Page p, String rectype) {
        List<Rec> recs = new List<Rec>(); List<SObject> slist = null; Integer n = 0; Rec r;
        if (pc1 != null) {
            pc1.gotoPage(p); n = pc1.recordFrom; slist = pc1.getRecords();
        }
        if (slist == null || slist.isEmpty() || String.isBlank(rectype)) {return recs;}
        for (SObject s : slist) {r = getRec(s, rectype, n++); recs.add(r);}
        return recs;
    }
    
    private static Rec getRec(SObject s, String rectype, Integer n) {
        Rec r;
        if (rectype == RTYPE_IC) {
            r = new Rec((Internal_Complaint__c)s, n);
        }
        return r; 
    }

}