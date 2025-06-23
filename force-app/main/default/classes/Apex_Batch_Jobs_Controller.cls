public class Apex_Batch_Jobs_Controller {
    
    private final static Map<String, Apex_Batch_Jobs__c> ABJ_MAP = 
                                     Apex_Batch_Jobs__c.getAll();
    
    private final static Set<String> EXCL_JOBTYPES = 
                     new Set<String>{'future', 'BatchApexWorker'};
    
    private final static Set<String> COMPLETE_STATS = 
                     new Set<String>{'Aborted', 'Completed', 'Failed'};
    
    private final static Set<String> RUNNING_STATS = 
                     new Set<String>{'Preparing', 'Processing'};
    
    private final static ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    private final static ApexPages.Severity INFO = ApexPages.Severity.INFO;

    private final static String QRY1 = ''
        + 'Select Id, Status, JobType, MethodName, ApexClassID, '
        + '       ApexClass.Name, CreatedBy.Name,'
        + '       JobItemsProcessed, TotalJobItems,' 
        + '       NumberOfErrors, CreatedDate, CompletedDate' 
        + '  from AsyncApexJob' 
        + ' where jobtype not in :EXCL_JOBTYPES '; 
    
    private final static String QRY_CRTBY = ' and CreatedById = :userId ';
    
    private final static String QRY_STAT1 = ' and Status in :RUNNING_STATS ';
    
    private final static String OBY1 = ' order by createddate desc limit 1000';
            
    private final static String VIEW_USR_RUN = 'VIEW_USR_RUN';
    private final static String VIEW_USR_ALL = 'VIEW_USR_ALL';
    private final static String VIEW_ALL_RUN = 'VIEW_ALL_RUN';
    private final static String VIEW_ALL_ALL = 'VIEW_ALL_ALL';
    
    private final static List<String[]> OUTVIEW_VALUE_LABELS = new List<String[]> {
        new String[]{VIEW_USR_RUN, 'My Jobs - Running'},
        new String[]{VIEW_USR_ALL, 'My Jobs - All'},
        new String[]{VIEW_ALL_RUN, 'All Jobs - Running'},
        new String[]{VIEW_ALL_ALL, 'All Jobs'}
    };

    public String jobName {get; set;}
    public String outView {get; set;}

    public List<SelectOption> jobNames  {get; private set;}
    public List<SelectOption> outViews  {get; private set;}
    
    private String userId = UserInfo.getUserId();
    private String query1;
    
    public Apex_Batch_Jobs_Controller() {init1();}
    
    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Apex_Batch_Jobs_Controller : ' + s);
    }
    
    private void addErrMsg(String s) {addMsg(ERROR, s);}
    
    private void addInfoMsg(String s) {addMsg(INFO, s);}
    
    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }
    
    private void init1() {
        setJobNames(); setOutViews();
        outView = VIEW_USR_RUN; changeView();
    }
    
    private void setJobNames() {
        jobNames = new List<SelectOption>();
        if (ABJ_MAP == null || ABJ_MAP.isEmpty()) {return;}
        List<Apex_Batch_Jobs__c> alist = ABJ_MAP.values();
        List<String> slist = new List<String>();
        for (Apex_Batch_Jobs__c j : alist) {slist.add(j.Name);}
        slist.sort(); Apex_Batch_Jobs__c j;
        for (String s : slist) {j = ABJ_MAP.get(s);
            jobNames.add(new SelectOption(j.Apex_Job_Class_Name__c, j.Apex_Job_Name__c));
        }
        jobName = jobNames[0].getValue(); 
    }
    
    private void setOutViews() {
        outViews = new List<SelectOption>();
        for (String[] sa : OUTVIEW_VALUE_LABELS) {
            outViews.add(new SelectOption(sa[0], sa[1]));
        }
    }
    
    public void submitJob() {
        if (String.isBlank(jobName)) {return;}
        Apex_Batch_Jobs.BatchJob j; Type t; 
        try {
            t = Type.forName(jobName);
            j = (Apex_Batch_Jobs.BatchJob)t.newInstance();
            j.submit();
            addInfoMsg('Submitted the selected Batch Job');
        } catch(Exception e) {
            addErrMsg('Error in Submitting Job : ' + e.getMessage());
        }
    }

    public void changeView() {
        query1 = QRY1;
        if (outView == VIEW_USR_RUN) {query1 += QRY_CRTBY + QRY_STAT1;} else
        if (outView == VIEW_USR_ALL) {query1 += QRY_CRTBY;} else
        if (outView == VIEW_ALL_RUN) {query1 += QRY_STAT1;}
        query1 += OBY1;
    }
    
    public void refreshView() {}
    
    public List<BatchJob> getBatchJobs() {
        List<BatchJob> batchJobs = new List<BatchJob>();
        for(AsyncApexJob aaj : Database.query(query1)) {
            batchJobs.add(getBatchJob(aaj));
        }
        return batchJobs;
    }

    public BatchJob getBatchJob(AsyncApexJob aaj) {
        BatchJob bj          = new BatchJob();
        bj.ClassId           = aaj.ApexClassID;
        bj.ClassName         = aaj.ApexClass.Name;
        bj.CompletedDate     = aaj.CompletedDate;
        bj.CreatedBy         = aaj.CreatedBy.Name;
        bj.CreatedDate       = aaj.CreatedDate;
        bj.Job_Type          = aaj.jobtype;
        bj.MethodName        = aaj.MethodName;
        bj.name              = aaj.id;
        bj.NumberOfErrors    = aaj.NumberOfErrors;
        bj.Records_Processed = aaj.JobItemsProcessed;
        bj.Status            = aaj.Status;
        bj.Total_Records     = aaj.TotalJobItems;
        
        if(aaj.jobItemsProcessed > 0 && aaj.TotalJobItems > 0) {
            Decimal d = aaj.jobItemsProcessed; 
            d = d.Divide(aaj.totalJobItems, 2)*100;
            bj.Percent = d.intValue();
        } else {
            if (aaj.Status == 'Completed') {bj.Percent= 100;} 
            else {bj.Percent = 1;}
        }
        
        return bj;
    }
    
    // Internal class BatchJob starts
    public class BatchJob {

        public DateTime      CreatedDate {get;set;}
        public DateTime    CompletedDate {get;set;}
        public Integer           Percent {get;set;}
        public Integer     Total_Records {get;set;}
        public Integer    NumberOfErrors {get;set;}
        public Integer Records_Processed {get;set;}
        public String               Name {get;set;}
        public String             Status {get;set;}
        public String            ClassId {get;set;}
        public String           Job_Type {get;set;}
        public String          ClassName {get;set;}
        public String          CreatedBy {get;set;}
        public String         MethodName {get;set;}
            
        public BatchJob(){}

        public Boolean getItemCompleted() {
            return COMPLETE_STATS.contains(Status);
        }
            
        public String getFormatted_CreatedDate() {
            return CreatedDate.format();
        }

        public String getFormatted_CompletedDate() {
            try {return CompletedDate.format();}
            catch (Exception e) {return '';}
        }

        public String getEstimatedCompletionDateTime() {
            DateTime currentDateTime = datetime.now();

            Long datediff = System.now().getTime() - CreatedDate.getTime();

            Decimal percentageComplete = 1, minutesLeft = 0; 

            Decimal D = Decimal.valueOf(Records_Processed);
            if (Total_Records != 0) {D = D.Divide(Decimal.valueOf(Total_Records), 6);}
                
            try {if (Total_Records != 0) {percentageComplete = D;}
            } catch(Exception e) {}

            String result = '';
                
            if (percentageComplete != 0) {
                minutesLeft = ((datediff / percentageComplete) - datediff) / (1000 * 60);
                    
                DateTime completionDateTime = System.Now();
                    
                Integer mm = minutesLeft.intValue();
                completionDateTime = completionDateTime.addMinutes(mm);
                    
                result = mm + ' minutes left';
                    
                if (mm > 60) {
                    Integer hh = mm / 60; mm -= hh * 60;
                    result = hh + ' hours ' + mm + ' minutes left';
                }
                    
                result += '<br/>' + completionDateTime.format();
            }
                
            return result;
        }

    }
    // Internal class BatchJob ends
        
}