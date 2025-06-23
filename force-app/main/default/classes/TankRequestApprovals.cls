public class TankRequestApprovals {

    private static final Integer PAGE_SIZE = 50;
    private static final Integer MAXNUM = null;
    private static final String ORDERBY_DESC = ' desc';

    private static final String ARROW_UP = '&nbsp;&nbsp;&#9650;';
    private static final String ARROW_DN = '&nbsp;&nbsp;&#9660;';

    private static final String RTYPE_TRC = 'Tank_Requirement__c';
    private static final String RTYPE_TIC = 'Tank_Inspection__c';

    private static final String FLD_CRT_DATE = 'CreatedDate';
    private static final String FLD_REC_NAME = 'Name';
    private static final String FLD_TIC_STAT = 'Status__c';
    private static final String FLD_ACC_NAME = 'Customer_Prospect__r.Name';
    private static final String FLD_ACC_OWNR = 'Customer_Prospect__r.Owner.Name';
    
    private static final Map<String, String> TITLES = 
                     new Map<String, String>{
        RTYPE_TRC => 'Tank Requests to be Approved',
        RTYPE_TIC => 'Tank Assessments to be Approved'
    };
    
    private static final Map<String, String> TREC_TYPE_FLDS = 
                     new Map<String, String>{
        RTYPE_TRC => 'Status__c',
        RTYPE_TIC => 'Record_Request_Type_Formula__c'
    };
    
    private static final Map<String, String> TANK_STAT_FLDS = 
                     new Map<String, String>{
        RTYPE_TRC => 'Tank_Status__c',
        RTYPE_TIC => 'Tank_Ownership_Status_formula__c'
    };
    
    private static final Map<String, String> TANK_TYPE_FLDS = 
                     new Map<String, String>{
        RTYPE_TRC => 'Type__c',
        RTYPE_TIC => 'Tank_Type_Formula__c'
    };
    
    private static final String QRY_TRC = ''
        + 'Select Id, Name, CreatedDate, Customer_Prospect__c,'
        + FLD_ACC_NAME + ', ' + FLD_ACC_OWNR + ','
        + '       Status__c, Tank_Status__c, Type__c'
        + '  from ' + RTYPE_TRC;
    
    private static final String QRY_TIC = ''
        + 'Select Id, Name, CreatedDate, Customer_Prospect__c,'
        + FLD_ACC_NAME + ', ' + FLD_ACC_OWNR + ', Status__c,'
        + '       Record_Request_Type_Formula__c,'
        + '       Tank_Ownership_Status_formula__c,'
        + '       Tank_Type_Formula__c'
        + '  from ' + RTYPE_TIC;
    
    private static final Map<String, String> QRY_MAP = 
                     new Map<String, String>{
        RTYPE_TRC => QRY_TRC,
        RTYPE_TIC => QRY_TIC
    };
    
    public class Rec {
        public Boolean selected   {get; set;}
        public Integer recNum     {get; set;}
        public String  crtDate    {get; set;}
        public String  recId      {get; set;}
        public String  recName    {get; set;}
        public String  accId      {get; set;}
        public String  accName    {get; set;}
        public String  accOwner   {get; set;}
        public String  trecType   {get; set;}
        public String  tankType   {get; set;}
        public String  tankStatus {get; set;}
        public String  ticStatus  {get; set;}

        public Rec(Tank_Requirement__c t, Integer n) {
        	init1(n); recId = t.Id; recName = t.Name; 
        	crtDate = t.CreatedDate.date().format();
        	accId = t.Customer_Prospect__c; 
        	accName = t.Customer_Prospect__r.Name;
        	accOwner = t.Customer_Prospect__r.Owner.Name;
        	trecType = t.Status__c; tankType = t.Type__c;
        	tankStatus = t.Tank_Status__c;
        }

        public Rec(Tank_Inspection__c t, Integer n) {
            init1(n); recId = t.Id; recName = t.Name;
            crtDate = t.CreatedDate.date().format();
            accId = t.Customer_Prospect__c; 
            accName = t.Customer_Prospect__r.Name;
            accOwner = t.Customer_Prospect__r.Owner.Name;
            trecType = t.Record_Request_Type_Formula__c; 
            tankType = t.Tank_Type_Formula__c;
            tankStatus = t.Tank_Ownership_Status_formula__c;
            ticStatus = t.Status__c;
        }
        
        private void init1(Integer n) {recNum = n; selected = false;}
    }
    
    String rectype; List<Rec> trecs;
    
    public Boolean allSelected      {get; set;}
    public Integer pageNumber       {get; set;}
    public Integer pageSize         {get; set;}
    public String  userComments     {get; set;} 

    public Boolean isAssessmnt      {get; private set;}
    public PaginationController pc1 {get; private set;}
    public PageReference pageRef1   {get; private set;}
    public String title             {get; private set;}
    public String orderBy           {get; private set;}
    
    public TankRequestApprovals() {
        pageSize = PAGE_SIZE; rectype = RTYPE_TRC; sortByRecName();
    }
    
    public void debug(String s) {
        System.debug(LoggingLevel.INFO, 'TankRequestApprovals : ' + s);
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public void addErrorMessage(String s) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, s));
    }
    
    public PageReference initActionTRC() {return pageRef1;}
    
    public PageReference initActionTIC() {rectype = RTYPE_TIC; init1(); return pageRef1;}
    
    public void init1() {
        pageRef1 = null; title = TITLES.get(rectype); trecs = new List<Rec>();
        userComments = ''; allSelected = false; Set<String> oids;
        isAssessmnt = (rectype == RTYPE_TIC);
        oids = Custom_Approval_Functions.getPendingApprovalObjectIds(rectype, MAXNUM);
        if (oids == null || oids.isEmpty()) {pageRef1 = Page.PendingApprovals; return;}
        init2(oids);
    }
    
    public void init2(Set<String> oids) {
        String qry = QRY_MAP.get(rectype) + ' where Id in :oids';
        qry += ' order by ' + orderBy;
        Database.Querylocator ql = Database.getQueryLocator(qry);
        pc1 = new PaginationController(ql, pageSize);
        setRecs();
    }
    
    public List<Rec> getRecs() {return trecs;}
    
    public void pc1Size() {setRecs(); pageSize = pc1.getPageSize();}
    public void pc1Frst() {setRecs(PaginationController.Page.FIRST);}
    public void pc1Prev() {setRecs(PaginationController.Page.PREV);}
    public void pc1Next() {setRecs(PaginationController.Page.NEXT);}
    public void pc1Last() {setRecs(PaginationController.Page.LAST);}
    
    private void setRecs() {setRecs(null);}
        
    private void setRecs(PaginationController.Page p) {
        trecs = new List<Rec>(); 
        List<SObject> slist = null; Integer n = 0; Rec r;
        if (pc1 != null) {
            pc1.gotoPage(p); n = pc1.recordFrom; slist = pc1.getRecords();
        }
        if (slist == null || slist.isEmpty()) {return;}
        for (SObject s : slist) {r = getRec(s, n++); trecs.add(r);}
    }
    
    private Rec getRec(SObject s, Integer n) {
    	Rec r;
        if (rectype == RTYPE_TRC) {
            r = new Rec((Tank_Requirement__c)s, n);
        } else
        if (rectype == RTYPE_TIC) {
            r = new Rec((Tank_Inspection__c)s, n);
        }
        return r; 
    }

    private void initSortFlds() {
    	sortDownRecName = sortDownRecName || isNull(sortIconRecName); sortIconRecName = '';
        sortDownCrtDate = sortDownCrtDate || isNull(sortIconCrtDate); sortIconCrtDate = '';
        sortDownRecType = sortDownRecType || isNull(sortIconRecType); sortIconRecType = '';
        sortDownTicStat = sortDownTicStat || isNull(sortIconTicStat); sortIconTicStat = '';
        sortDownTnkStat = sortDownTnkStat || isNull(sortIconTnkStat); sortIconTnkStat = '';
        sortDownTnkType = sortDownTnkType || isNull(sortIconTnkType); sortIconTnkType = '';
        sortDownAccName = sortDownAccName || isNull(sortIconAccName); sortIconAccName = '';
        sortDownAccOwnr = sortDownAccOwnr || isNull(sortIconAccOwnr); sortIconAccOwnr = '';
    }
    
    private void refreshRecs(Boolean b) {
        if (b) {orderBy += ORDERBY_DESC;} init1();
    }
    
    public String sortIconRecName {get; private set;}
    private Boolean sortDownRecName = true;
    public void sortByRecName() {
    	initSortFlds();
        sortDownRecName = !sortDownRecName; orderBy = FLD_REC_NAME;
        sortIconRecName = !sortDownRecName ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownRecName);
    }
    
    public String sortIconCrtDate {get; private set;}
    private Boolean sortDownCrtDate = true;
    public void sortByCrtDate() {
        initSortFlds();
        sortDownCrtDate = !sortDownCrtDate; orderBy = FLD_CRT_DATE;
        sortIconCrtDate = !sortDownCrtDate ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownCrtDate);
    }
    
    public String sortIconRecType {get; private set;}
    private Boolean sortDownRecType = true;
    public void sortByRecType() {
    	initSortFlds();
        sortDownRecType = !sortDownRecType; orderBy = TREC_TYPE_FLDS.get(recType);
        sortIconRecType = !sortDownRecType ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownRecType);
    }
    
    public String sortIconTicStat {get; private set;}
    private Boolean sortDownTicStat = true;
    public void sortByTicStat() {
        initSortFlds();
        sortDownTicStat = !sortDownTicStat; orderBy = FLD_TIC_STAT;
        sortIconTicStat = !sortDownTicStat ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownTicStat);
    }
    
    public String sortIconTnkStat {get; private set;}
    private Boolean sortDownTnkStat = true;
    public void sortByTnkStat() {
        initSortFlds();
        sortDownTnkStat = !sortDownTnkStat; orderBy = TANK_STAT_FLDS.get(recType);
        sortIconTnkStat = !sortDownTnkStat ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownTnkStat);
    }
    
    public String sortIconTnkType {get; private set;}
    private Boolean sortDownTnkType = true;
    public void sortByTnkType() {
        initSortFlds();
        sortDownTnkType = !sortDownTnkType; orderBy = TANK_TYPE_FLDS.get(recType);
        sortIconTnkType = !sortDownTnkType ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownTnkType);
    }
    
    public String sortIconAccName {get; private set;}
    private Boolean sortDownAccName = true;
    public void sortByAccName() {
        initSortFlds();
    	sortDownAccName = !sortDownAccName; orderBy = FLD_ACC_NAME;
        sortIconAccName = !sortDownAccName ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownAccName);
    }
    
    public String sortIconAccOwnr {get; private set;}
    private Boolean sortDownAccOwnr = true;
    public void sortByAccOwnr() {
        initSortFlds();
        sortDownAccOwnr = !sortDownAccOwnr; orderBy = FLD_ACC_OWNR;
        sortIconAccOwnr = !sortDownAccOwnr ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownAccOwnr);
    }
    
    private Set<String> getSelectedObjectIds() {
        Set<String> ss = new Set<String>();
        for (Rec r : trecs) {
            if (r.selected) {ss.add(r.recid);}
        }
        return ss;
    }
    
    public PageReference approveSelectedList() {
        Set<String> sids = getSelectedObjectIds();
        if (sids.isEmpty()) {addErrorMessage('None selected to approve.'); return null;}
        //updateApproverComments();
        Custom_Approval_Functions.approveObjects(sids, userComments);
        init1(); return pageRef1;
    }
    
    public PageReference rejectSelectedList() {
        Set<String> sids = getSelectedObjectIds();
        Boolean b1 = sids.isEmpty(); 
        if (b1) {addErrorMessage('None selected to reject.');}
        Boolean b2 = isNull(userComments);
        if (b2) {addErrorMessage('Reject Comments are required.');}
        if (b1 || b2) {return null;}
        //updateApproverComments();
        Custom_Approval_Functions.rejectObjects(sids, userComments);
        init1(); return pageRef1;
    }
/*    
    private void updateApproverComments() {
        if (isNull(userComments)) {return;}
        String dt = Datetime.now().format();
        String un = UserInfo.getName();
        String cs = dt + ' : ' + un + ' : ' + userComments + '\n';
    }
*/    
}