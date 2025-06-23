global with sharing class Apex_Job_Schedule_Controller {
 
    public static final String SORT_ASC_IMG = '/img/colTitle_uparrow.gif'; 
    public static final String SORT_DESC_IMG = '/img/colTitle_downarrow.gif'; 

    public static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    public static final ApexPages.Severity INFO = ApexPages.Severity.INFO;
    
    public enum SortOrder {A, D} // Ascending, Descending
     
    public SortOrder nrtso {get; private set;} // next run time sort order
    
    // Map of <Job Name, Schedulable Class>
    private Map<String, Schedulable> scmap; 
    @AuraEnabled
    public static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Apex_Job_Schedule_Controller : ' + s);
    }
    private void addErrMsg(String s) {addMsg(ERROR, s);}
    private void addInfoMsg(String s) {addMsg(INFO, s);}
    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }
    global class JobSchedule implements Comparable {
        @AuraEnabled
        public Apex_Job_Schedule__c ajs {get; private set;}
        
        @AuraEnabled
        public Boolean selected {get; set;}
        
        @AuraEnabled
        public CronTrigger ct {get; set;}

        @AuraEnabled
        public String ct1 {get; set;}
        
        @AuraEnabled
        public Integer recNum {get; private set;}
        
        @AuraEnabled
        public String styleClass {get; private set;}
        
        @AuraEnabled
        public SortOrder nrtso {get; set;}
        
        public JobSchedule(Apex_Job_Schedule__c a, Integer n) { 
            ct1 = (System.now()).format('MM/dd/yyyy hh:mm a');
            ajs = a; nrtso = null; init1(n); selected = false;            
        }
        public void init1(Integer n) {
            recNum = n; styleClass = 'row1';
            if (Math.mod(n, 2) == 0) {styleClass = 'row2';}
        }
        
        global Integer compareTo(Object obj) {
            Integer i = 0; JobSchedule js = (JobSchedule) obj;
            //ct1 = new CronTriggerWrapper();
            //ct1.NextFireTime = ''+js.ct.NextFireTime;
            if (nrtso != null && ct != null && ct.NextFireTime != null && 
                js.ct != null && js.ct.NextFireTime != null) {
                //debug('ct.NextFireTime = ' + recNum + ' : ' + ct.NextFireTime);
                //debug('js.ct.NextFireTime = ' + js.recNum + ' : ' + js.ct.NextFireTime);
                if (nrtso == SortOrder.A) if (ct.NextFireTime > js.ct.NextFireTime) {i = 1;} else {i = -1;}
                if (nrtso == SortOrder.D) if (ct.NextFireTime > js.ct.NextFireTime) {i = -1;} else {i = 1;}
            }
            //debug('i = ' + i + ' : nrtso = ' + nrtso);
            return i;
        }
    }
     
    @AuraEnabled
    public Boolean allSelected1 {get; set;}
    
    @AuraEnabled
    public Boolean allSelected2 {get; set;}
    
    @AuraEnabled
    public Boolean renderlist1  {get; set;}
    
    @AuraEnabled
    public Boolean renderlist2  {get; set;}
    
    @AuraEnabled
    public List<JobSchedule> alist {get; private set;} // Scheduled
    
    @AuraEnabled
    public List<JobSchedule> blist {get; private set;} // Not Scheduled
    
    @AuraEnabled
    public List<JobSchedule> slist {get; private set;} // Selected

    @AuraEnabled
    public String sortImage {get; private set;}
    
    @AuraEnabled
    public boolean renderNRTSortImage {get; private set;}
    
    public Apex_Job_Schedule_Controller(ApexPages.StandardController sc) {}
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public Apex_Job_Schedule_Controller (  ){
    }
    
    public void initAction() {
        allSelected1 = false; allSelected2 = false; 
        nrtso = null; renderNRTSortImage = false;
        scmap = new Map<String, Schedulable>(); Schedulable sc;
        alist = new List<JobSchedule>(); blist = new List<JobSchedule>();
        List<JobSchedule> alistTemp = new List<JobSchedule>(); 
        Integer n1 = 0, n2 = 0; JobSchedule j; Set<String> ctids = new Set<String>();
        for (Apex_Job_Schedule__c a : [
            select Id, Name, Cron_Expression__c, CronTrigger_ID__c, 
                   Day_of_Month__c, Day_of_Week__c, Hours__c, 
                   Job_Name__c, Job_Scheduler__c,
                   Minutes__c, Month__c, Scheduled__c, Seconds__c
              from Apex_Job_Schedule__c where Active__c = true order by Job_Name__c]) {
            sc = getSchedulable(a.Job_Scheduler__c);
            if (sc == null) {continue;}
            scmap.put(a.Job_Name__c, sc);
            if (!isNull(a.CronTrigger_ID__c)) {
                j = new JobSchedule(a, ++n1);
                alist.add(j);
                ctids.add(a.CronTrigger_ID__c);
            } else {
                j = new JobSchedule(a, ++n2);
                j.ajs.Scheduled__c = false;
                blist.add(j);
            }
        }
        Map<String, CronTrigger> ctmap = getCronTriggers(ctids);
        for (JobSchedule a : alist) {
            a.ajs.Scheduled__c = false;
            if (ctmap.containsKey(a.ajs.CronTrigger_ID__c)) {
                a.ct = ctmap.get(a.ajs.CronTrigger_ID__c);                
                a.ct1 = a.ct.NextFireTime.format('MM/dd/yyyy hh:mm a');
                a.ajs.Scheduled__c = true; 
            }
            alistTemp.add(a);
        }       
        alist = alistTemp;
        sortOnNextRunTime();
        renderlist1 = alist.size() > 0;
        renderlist2 = blist.size() > 0;
    }
    
    private Schedulable getSchedulable(String s) {
        if (String.isBlank(s)) {return null;}
        s = 'Apex_Job_Schedule.' + s;
        Apex_Job_Schedule.JobScheduler j; Type t; 
        try {
            t = Type.forName(s);
            j = (Apex_Job_Schedule.JobScheduler)t.newInstance();
            return j.getSchedulable();
        } catch(Exception e) {
            //throw e;
            //addErrMsg('Error getting Schedulable : ' + e.getMessage());
        }
        return null;
    }
    
    private Map<String, CronTrigger> getCronTriggers(Set<String> ctids) {
        Map<String, CronTrigger> amap = new Map<String, CronTrigger>();
        if (ctids == null || ctids.isEmpty()) {return amap;}
        List<CronTrigger> cts = [select Id, CronExpression, EndTime, NextFireTime,
            OwnerId, PreviousFireTime, StartTime, State, TimesTriggered, TimeZoneSidKey
            from CronTrigger where Id in :ctids];
        if (cts == null || cts.isEmpty()) {return amap;}
        for (CronTrigger ct : cts) {amap.put(ct.Id, ct);}
        return amap;
    }
    
    private void setSelected(List<JobSchedule> tlist) {
        slist = new List<JobSchedule>();
        for (JobSchedule t : tlist) {if (t.selected) {slist.add(t);}}
    }
    
    private void scheduleSelected() {
        String jn, ce; Schedulable sc;
        List<Apex_Job_Schedule__c> ulist = new List<Apex_Job_Schedule__c>();
        Apex_Job_Schedule__c u; Id sid;
        for (JobSchedule s : slist) {
            sc = null; u = s.ajs; jn = u.Job_Name__c; ce = u.Cron_Expression__c;
            if (scmap.containsKey(jn)) {sc = scmap.get(jn);}
            if (sc != null) {
                try {
                    sid = System.schedule(jn, ce, sc);
                    u.CronTrigger_ID__c = sid;
                    u.Scheduled__c = true;
                    ulist.add(u);
                } catch(Exception e) {
                    
                }
            }
        }
        if (!ulist.isEmpty()) {update ulist;}
    }
    
    private void deleteSelected() {
        List<Apex_Job_Schedule__c> ulist = new List<Apex_Job_Schedule__c>();
        Apex_Job_Schedule__c u;
        for (JobSchedule s : slist) {
            u = s.ajs;
            if (s.ct != null && s.ct.Id != null) {
                try {
                    System.abortJob(s.ct.Id);
                    u.CronTrigger_ID__c = null;
                    u.Scheduled__c = false;
                    ulist.add(u);
                } catch(Exception e) {
                    
                }
            }
        }
        if (!ulist.isEmpty()) {update ulist;}
    }
    
    public void startSchedulableJobs() {
        setSelected(blist);
        scheduleSelected();
        initAction();
    }
    
    public void deleteScheduleJobs() {
        setSelected(alist);
        deleteSelected();
        initAction();
    }
    
    private void setNextRunTimeSO(SortOrder so) {
        for (JobSchedule a : alist) {a.nrtso = nrtso;}
    }
    
    public void sortOnNextRunTime() {
        if (alist.isEmpty()) {return;}
        //debug('sortOnNextRunTime : nrtso = ' + nrtso);
        renderNRTSortImage = true;
        if (nrtso == SortOrder.A) {
            nrtso = SortOrder.D; sortImage = SORT_DESC_IMG;
        } else {
            nrtso = SortOrder.A; sortImage = SORT_ASC_IMG;
        }
        setNextRunTimeSO(nrtso);
        alist.sort(); Integer n = 0;
        for (JobSchedule a : alist) {++n; a.init1(n);}
    }
    @auraEnabled(cacheable=true)
    public static Apex_Job_Schedule_Controller getApexJobData(){
        Apex_Job_Schedule_Controller apexJobScheduleCtrl = new Apex_Job_Schedule_Controller();
        apexJobScheduleCtrl.initAction();
        return apexJobScheduleCtrl;
    }
    @auraEnabled
    public static Apex_Job_Schedule_Controller startSchedulableJobsHandler(List<Integer> checkedList) { 
        Apex_Job_Schedule_Controller apexJobScheduleCtrl = new Apex_Job_Schedule_Controller();
        apexJobScheduleCtrl.initAction();       
        apexJobScheduleCtrl.blist = Apex_Job_Schedule_Controller.calcSelectedItems(apexJobScheduleCtrl.blist,checkedList);
        apexJobScheduleCtrl.startSchedulableJobs();
        return apexJobScheduleCtrl;
    }
    @auraEnabled
    public static Apex_Job_Schedule_Controller deleteScheduleJobsHandler(List<Integer> checkedList) {
        Apex_Job_Schedule_Controller apexJobScheduleCtrl = new Apex_Job_Schedule_Controller();
        apexJobScheduleCtrl.initAction();
        apexJobScheduleCtrl.alist = Apex_Job_Schedule_Controller.calcSelectedItems(apexJobScheduleCtrl.alist,checkedList);
        apexJobScheduleCtrl.deleteScheduleJobs();
        apexJobScheduleCtrl.initAction();
        return apexJobScheduleCtrl;
    } 

    public static List<JobSchedule> calcSelectedItems(List<JobSchedule> blist, List<Integer> selectedCheckIndex){
        List<Apex_Job_Schedule_Controller.JobSchedule> blistTemp = blist;
        Integer x = 0;
        for(JobSchedule j:blist){            
            for(Integer i: selectedCheckIndex){
                if(j.recNum == i+1){
                    blistTemp[x].selected = true;    
                }
            }
            ++x;
        } 
        return blistTemp;
    }
}