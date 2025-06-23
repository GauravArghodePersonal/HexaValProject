public class CaseApprovals {

    private static final Integer PAGE_SIZE = 50;
    private static final Integer MAXNUM = null;
    private static final String ORDERBY_DESC = ' desc';

    private static final String ARROW_UP = '&nbsp;&nbsp;&#9650;';
    private static final String ARROW_DN = '&nbsp;&nbsp;&#9660;';

    private static final String OBJECT_NAME         = 'Case';
    private static final String CASE_TYPE_TSR       = 'CASE_TYPE_TSR';

    private static final String ACCOUNT_ID          = 'AccountId';
    private static final String ACCOUNT_NAME        = 'Account.Name';
    private static final String ACCOUNT_NUMBER      = 'Account.AccountNumber';
    private static final String CASE_NUMBER         = 'CaseNumber';
    private static final String CASE_REASON         = 'Reason';
    private static final String CASE_SUBJECT        = 'Subject';
    private static final String CREATED_DATE        = 'CreatedDate';
    private static final String DEVEX_PROJ_MANAGER  = 'DevEx_Project_Manager__c';
    private static final String DEVEX_TRANSFER_STAT = 'DevEx_Transfer_Status__c';
    private static final String LAB_TECH_ASSIGNED   = 'Lab_Tech_Assigned__c';
    private static final String TECH_APRVL_PRIORITY = 'Technical_Approval_Priority__c';
    private static final String TECH_RISK_ASSESSMNT = 'Technical_Risk_Assessment__c';
    
    private static final Set<Id> TSR_REC_TYPE_IDS = Case_Functions.getTSRRecordTypeIds();
    
    private static final Map<String, String> TITLES = 
                     new Map<String, String>{
        CASE_TYPE_TSR => 'TSRs to be Approved'
    };
    
    private static final String QRY_TSR = 'Select Id'
        + ', ' + ACCOUNT_ID
        + ', ' + ACCOUNT_NAME
        + ', ' + ACCOUNT_NUMBER
        + ', ' + CASE_NUMBER
        + ', ' + CASE_REASON
        + ', ' + CASE_SUBJECT
        + ', ' + CREATED_DATE
        + ', ' + DEVEX_PROJ_MANAGER
        + ', ' + DEVEX_TRANSFER_STAT
        + ', ' + LAB_TECH_ASSIGNED
        + ', ' + TECH_APRVL_PRIORITY
        + ', ' + TECH_RISK_ASSESSMNT
        + '  from Case where Id in :caseIds '
        + '   and RecordTypeId in :TSR_REC_TYPE_IDS ';
    
    private static final Map<String, String> QRY_MAP = 
                     new Map<String, String>{
        CASE_TYPE_TSR => QRY_TSR
    };
    
    public class Rec {
        public Case    cse         {get; set;}

        public String  accountName {get; set;}
        public String  createDate  {get; set;}

        public Integer recordNum   {get; set;}

        public Boolean selected    {get; set;}

        public Boolean createDevexProj  {get; set;}
        public Boolean renderDevexChkbx {get; private set;}

        public Rec(Case c, Integer n) {init1(n); cse = c; 
            accountName = c.Account.Name + ' - ' +
                          String_Functions.removeLeadingZeros(c.Account.AccountNumber);
            createDate  = c.CreatedDate.date().format();
            renderDevexChkbx = String.isBlank(c.DevEx_Transfer_Status__c);
        }
        
        private void init1(Integer n) {
        	recordNum = n; selected = false; createDevexProj = false;}
    }
    
    String caseType; List<Rec> trecs; Set<String> caseIds;
    
    public Boolean createDevexProjAll {get; set;}
    public Boolean allSelected        {get; set;}
    public Integer pageNumber         {get; set;}
    public Integer pageSize           {get; set;}
    public String  userComments       {get; set;} 

    public PaginationController pc1 {get; private set;}
    public PageReference pageRef1   {get; private set;}
    public String title             {get; private set;}
    public String orderBy           {get; private set;}
    public Boolean labWorkApprover  {get; private set;}
    
    public CaseApprovals() {
        pageSize = PAGE_SIZE; caseType = CASE_TYPE_TSR;
        //labWorkApprover = CaseCustomSettings__c.getInstance().Lab_Work_Approver__c; 
        labWorkApprover = true; 
        sortByCaseNumber(); init1();
    }
    
    public void debug(String s) {
        System.debug(LoggingLevel.INFO, 'CaseApprovals : ' + s);
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public void addErrorMessage(String s) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, s));
    }
    
    public PageReference initActionTSR() {return pageRef1;}
    
    public void init1() {
    	debug('labWorkApprover = ' + labWorkApprover);
        pageRef1 = null; title = TITLES.get(caseType); trecs = new List<Rec>();
        userComments = ''; createDevexProjAll = false; allSelected = false;
        caseIds = Custom_Approval_Functions.getPendingApprovalObjectIds(OBJECT_NAME, MAXNUM);
        if (caseIds == null || caseIds.isEmpty()) {pageRef1 = Page.PendingApprovals; return;}
        init2();
    }
    
    public void init2() {
        if (caseIds == null || caseIds.isEmpty()) {return;}
        String qry = QRY_MAP.get(caseType);
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
    
    private Rec getRec(SObject s, Integer n) {return new Rec((Case)s, n);}
    
    public void onCreateDevexProjAll() {
        for (Rec r : trecs) {
            r.createDevexProj = createDevexProjAll;
        }
    }

    public void onCreateDevexProj() {
    	createDevexProjAll = true; Boolean b1;
        for (Rec r : trecs) {
        	b1 = String.isBlank(r.cse.DevEx_Transfer_Status__c) && !r.createDevexProj;
        	if (b1) {createDevexProjAll = false; break;}
        }
    }

    private Set<String> getSelectedObjectIds() {
        Set<String> ss = new Set<String>();
        for (Rec r : trecs) {
            if (r.selected) {ss.add(r.cse.Id);}
        }
        return ss;
    }
    
    private void updateSelectedList(Boolean approved) {
        List<Case> clist = new List<Case>(); Case c;
        Boolean b1;
        for (Rec r : trecs) {
            if (!r.selected || !r.createDevexProj) {continue;} c = r.cse;
            b1 = approved && String.isBlank(c.DevEx_Transfer_Status__c) && r.createDevexProj;
        	if (b1) {
                c.DevEx_Transfer_Status__c = 'Create DevEx Project';
        	}
            clist.add(c);
        }
        if (clist.isEmpty()) {return;}
        update clist;
    }
    
    public PageReference approveSelectedList() {
        Set<String> sids = getSelectedObjectIds();
        if (sids.isEmpty()) {addErrorMessage('None selected to approve.'); return null;}
        updateSelectedList(true);
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
        updateSelectedList(false);
        Custom_Approval_Functions.rejectObjects(sids, userComments);
        init1(); return pageRef1;
    }

    private void initSortFlds() {
        sortDownCaseNumber = 
        sortDownCaseNumber || isNull(sortIconCaseNumber); sortIconCaseNumber = '';
        
        sortDownAccName = 
        sortDownAccName || isNull(sortIconAccName); sortIconAccName = '';

        sortDownSubject = 
        sortDownSubject || isNull(sortIconSubject); sortIconSubject = '';

        sortDownReason = 
        sortDownReason || isNull(sortIconReason); sortIconReason = '';

        sortDownLabTech = 
        sortDownLabTech || isNull(sortIconLabTech); sortIconLabTech = '';

        sortDownTechRisk = 
        sortDownTechRisk || isNull(sortIconTechRisk); sortIconTechRisk = '';

        sortDownPriority = 
        sortDownPriority || isNull(sortIconPriority); sortIconPriority = '';

        sortDownDevexPM = 
        sortDownDevexPM || isNull(sortIconDevexPM); sortIconDevexPM = '';

    }
    
    private void refreshRecs(Boolean b) {
        if (b) {orderBy += ORDERBY_DESC;} init2();
    }
    
    public String sortIconCaseNumber {get; private set;}
    private Boolean sortDownCaseNumber = true;
    public void sortByCaseNumber() {
        initSortFlds();
        sortDownCaseNumber = !sortDownCaseNumber; orderBy = CASE_NUMBER;
        sortIconCaseNumber = !sortDownCaseNumber ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownCaseNumber);
    }
    
    public String sortIconAccName {get; private set;}
    private Boolean sortDownAccName = true;
    public void sortByAccName() {
        initSortFlds();
        sortDownAccName = !sortDownAccName; orderBy = ACCOUNT_NAME;
        sortIconAccName = !sortDownAccName ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownAccName);
    }
    
    public String sortIconSubject {get; private set;}
    private Boolean sortDownSubject = true;
    public void sortBySubject() {
        initSortFlds();
        sortDownSubject = !sortDownSubject; orderBy = CASE_SUBJECT;
        sortIconSubject = !sortDownSubject ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownSubject);
    }
    
    public String sortIconReason {get; private set;}
    private Boolean sortDownReason = true;
    public void sortByReason() {
        initSortFlds();
        sortDownReason = !sortDownReason; orderBy = CASE_REASON;
        sortIconReason = !sortDownReason ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownReason);
    }
    
    public String sortIconLabTech {get; private set;}
    private Boolean sortDownLabTech = true;
    public void sortByLabTech() {
        initSortFlds();
        sortDownLabTech = !sortDownLabTech; orderBy = LAB_TECH_ASSIGNED;
        sortIconLabTech = !sortDownLabTech ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownLabTech);
    }
    
    public String sortIconTechRisk {get; private set;}
    private Boolean sortDownTechRisk = true;
    public void sortByTechRisk() {
        initSortFlds();
        sortDownTechRisk = !sortDownTechRisk; orderBy = TECH_RISK_ASSESSMNT;
        sortIconTechRisk = !sortDownTechRisk ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownTechRisk);
    }
    
    public String sortIconPriority {get; private set;}
    private Boolean sortDownPriority = true;
    public void sortByPriority() {
        initSortFlds();
        sortDownPriority = !sortDownPriority; orderBy = TECH_APRVL_PRIORITY;
        sortIconPriority = !sortDownPriority ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownPriority);
    }
    
    public String sortIconDevexPM {get; private set;}
    private Boolean sortDownDevexPM = true;
    public void sortByDevexPM() {
        initSortFlds();
        sortDownDevexPM = !sortDownDevexPM; orderBy = DEVEX_PROJ_MANAGER;
        sortIconDevexPM = !sortDownDevexPM ? ARROW_UP : ARROW_DN;
        refreshRecs(sortDownDevexPM);
    }
    
}