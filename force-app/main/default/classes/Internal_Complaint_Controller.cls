public class Internal_Complaint_Controller {

    private static final Integer PAGE_SIZE = 50;
    private static final String ORD_DESC = ' desc nulls last';
    private static final String ARROW_UP = '&nbsp;&nbsp;&#9650;';
    private static final String ARROW_DN = '&nbsp;&nbsp;&#9660;';

    private static final String FLD_CONCERN  = 'Concern_Issue__c';
    private static final String FLD_CRT_BY   = 'CreatedBy.Name';
    private static final String FLD_CRT_DATE = 'CreatedDate';
    private static final String FLD_ISSUE    = 'Issue__c';
    private static final String FLD_OWNER    = 'Owner.Name';
    private static final String FLD_REC_NAME = 'Name';
    private static final String FLD_STATUS   = 'Status__c';
    private static final String FLD_ST_DAYS1 = 'Days_in_Status1__c';
    private static final String FLD_ST_DAYS2 = 'Days_in_Status2__c';
    private static final String FLD_TOPIC    = 'Topic__c';

    private static final String STATUS_ALL   = Internal_Complaint_Functions.STATUS_ALL;

    public Boolean allSelected      {get; set;}
    public Integer pageNumber       {get; set;}
    public Integer pageSize         {get; set;}
    public String  status           {get; set;}

    public List<SelectOption> statOpts {get; private set;}
    public PaginationController pc1    {get; private set;}
    public PageReference pageRef1      {get; private set;}
    public String orderBy              {get; private set;}

    String rectype; 
    List<Internal_Complaint_Functions.Rec> recs;

    public Internal_Complaint_Controller() {
        rectype = Internal_Complaint_Functions.RTYPE_IC;
        pageSize = PAGE_SIZE; status = Internal_Complaint_Functions.STATUS_ALL;
        statOpts = Internal_Complaint_Functions.getStatusOpts(); 
        sortIconRecName = ARROW_DN; sortByRecName();
    }
    
    public void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Internal_Complaint_Controller : ' + s);
    }
    
    public void addErrorMessage(String s) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, s));
    }

    public void initAction1() { }
        
    public void init1() {
        pageRef1 = null; 
        String qry = Internal_Complaint_Functions.QRY1;
        if (status != STATUS_ALL) {qry += ' where Status__c = :status';}
        qry += ' order by ' + orderBy;
        Database.Querylocator ql = Database.getQueryLocator(qry);
        pc1 = new PaginationController(ql, pageSize);
        setRecs();
    }
    
    public List<Internal_Complaint_Functions.Rec> getRecs() {return recs;}
    
    public void pc1Size() {setRecs(); pageSize = pc1.getPageSize();}
    public void pc1Frst() {setRecs(PaginationController.Page.FIRST);}
    public void pc1Prev() {setRecs(PaginationController.Page.PREV);}
    public void pc1Next() {setRecs(PaginationController.Page.NEXT);}
    public void pc1Last() {setRecs(PaginationController.Page.LAST);}
    
    private void setRecs() {setRecs(null);}
        
    private void setRecs(PaginationController.Page p) {
        recs = Internal_Complaint_Functions.getRecs(pc1, p, rectype);
    }
    
    private void initSortFlds() {
        sortDownConcern = sortDownConcern || String.isBlank(sortIconConcern); sortIconConcern = '';
        sortDownCrtBy   = sortDownCrtBy   || String.isBlank(sortIconCrtBy);   sortIconCrtBy   = '';
        sortDownCrtDate = sortDownCrtDate || String.isBlank(sortIconCrtDate); sortIconCrtDate = '';
        sortDownOwner   = sortDownOwner   || String.isBlank(sortIconOwner);   sortIconOwner   = '';
        sortDownRecName = sortDownRecName || String.isBlank(sortIconRecName); sortIconRecName = '';
        sortDownStatus  = sortDownStatus  || String.isBlank(sortIconStatus);  sortIconStatus  = '';
        sortDownStDays1 = sortDownStDays1 || String.isBlank(sortIconStDays1); sortIconStDays1 = '';
        sortDownStDays2 = sortDownStDays2 || String.isBlank(sortIconStDays2); sortIconStDays2 = '';
        sortDownTopic   = sortDownTopic   || String.isBlank(sortIconTopic);   sortIconTopic  = '';
    }
    
    private void refreshRecs(Boolean b) {
        if (b) {orderBy += ORD_DESC;} init1();
    }
    
    public String sortIconConcern {get; private set;}
    private Boolean sortDownConcern = true;
    public void sortByConcern() {
        initSortFlds();
        sortDownConcern = !sortDownConcern; orderBy = FLD_CONCERN;
        sortIconConcern = !sortDownConcern ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownConcern);
    }
    
    public String sortIconCrtBy {get; private set;}
    private Boolean sortDownCrtBy = true;
    public void sortByCrtBy() {
        initSortFlds();
        sortDownCrtBy = !sortDownCrtBy; orderBy = FLD_CRT_BY;
        sortIconCrtBy = !sortDownCrtBy ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownCrtBy);
    }
    
    public String sortIconCrtDate {get; private set;}
    private Boolean sortDownCrtDate = true;
    public void sortByCrtDate() {
        initSortFlds();
        sortDownCrtDate = !sortDownCrtDate; orderBy = FLD_CRT_DATE;
        sortIconCrtDate = !sortDownCrtDate ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownCrtDate);
    }
    
    public String sortIconIssue {get; private set;}
    private Boolean sortDownIssue = true;
    public void sortByIssue() {
        initSortFlds();
        sortDownIssue = !sortDownIssue; orderBy = FLD_ISSUE;
        sortIconIssue = !sortDownIssue ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownIssue);
    }
    
    public String sortIconOwner {get; private set;}
    private Boolean sortDownOwner = true;
    public void sortByOwner() {
        initSortFlds();
        sortDownOwner = !sortDownOwner; orderBy = FLD_OWNER;
        sortIconOwner = !sortDownOwner ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownOwner);
    }
    
    public String sortIconRecName {get; private set;}
    private Boolean sortDownRecName = false;
    public void sortByRecName() {
        initSortFlds();
        sortDownRecName = !sortDownRecName; orderBy = FLD_REC_NAME;
        sortIconRecName = !sortDownRecName ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownRecName);
    }
    
    public String sortIconStatus {get; private set;}
    private Boolean sortDownStatus = true;
    public void sortByStatus() {
        initSortFlds();
        sortDownStatus = !sortDownStatus; orderBy = FLD_STATUS;
        sortIconStatus = !sortDownStatus ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownStatus);
    }
    
    public String sortIconStDays1 {get; private set;}
    private Boolean sortDownStDays1 = true;
    public void sortByStDays1() {
        initSortFlds();
        sortDownStDays1 = !sortDownStDays1; orderBy = FLD_ST_DAYS1;
        sortIconStDays1 = !sortDownStDays1 ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownStDays1);
    }
    
    public String sortIconStDays2 {get; private set;}
    private Boolean sortDownStDays2 = true;
    public void sortByStDays2() {
        initSortFlds();
        sortDownStDays2 = !sortDownStDays2; orderBy = FLD_ST_DAYS2;
        sortIconStDays2 = !sortDownStDays2 ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownStDays2);
    }
    
    public String sortIconTopic {get; private set;}
    private Boolean sortDownTopic = true;
    public void sortByTopic() {
        initSortFlds();
        sortDownTopic = !sortDownTopic; orderBy = FLD_TOPIC;
        sortIconTopic = !sortDownTopic ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownTopic);
    }
    
}