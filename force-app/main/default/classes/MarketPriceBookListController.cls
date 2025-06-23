public class MarketPriceBookListController {

    private static final Integer PAGE_SIZE1 = 10;
    private static final Integer PAGE_SIZE2 = 50;
    private static final Integer PAGE_SIZE3 = 100;
    private static final Integer PAGE_SIZE4 = 200;

    private static final ApexPages.Severity INFO  = ApexPages.Severity.INFO;

    private static final String ACTIVE       = MarketPriceBookMethods.ACTIVE;
    private static final String APPROVED     = MarketPriceBookMethods.APPROVED;
    private static final String DRAFT        = MarketPriceBookMethods.DRAFT;
    private static final String EXPIRED      = MarketPriceBookMethods.EXPIRED;
    private static final String SUBMITTED    = MarketPriceBookMethods.SUBMITTED;
    private static final String ALL          = 'ALL';

    private static final Set<String> PC_STATS1 = MarketPriceBookMethods.PC_STATS1;

    private static final List<Integer> PAGE_SIZES = new List<Integer>{
        PAGE_SIZE1, PAGE_SIZE2, PAGE_SIZE3, PAGE_SIZE4
    };

    private static final String MSG_1 = ''
        + 'Submitted Batch Job and You will be notified by email when it completes.';

    private static final String MPB_QRY1 = ''
        + 'select Id, Name, Description__c, Expired_By__c, Expired_By__r.Name,'
        + '       Record_Status__c, Valid_From_Date__c, Valid_To_Date__c'
        + '  from Market_Price_Book__c';

    private static final String MPB_OBY1 = ' order by Name desc';

    private static final String AMPBE_QRY1 = ''
        + 'select Id, Name,'
        + '       Account__r.Id, Account__r.Name, Account__r.AccountNumber,'
        + '       Market_Price_Book_Entry__r.Id,'
        + '       Market_Price_Book_Entry__r.Name,'
        + '       Market_Price_Book_Entry__r.Market_Price_Book__r.Id,'
        + '       Market_Price_Book_Entry__r.Market_Price_Book__r.Name,'
        + '       Market_Price_Book_Entry__r.Material_Sales_Data2__r.Id,'
        + '       Market_Price_Book_Entry__r.Material_Sales_Data2__r.Material_Desc__c,'
        + '       Market_Price_Book_Entry__r.Material_Sales_Data2__r.Material_Number__c,'
        + '       Market_Price_Book_Entry__r.Material_Sales_Data2__r.Sales_Org_Code__c,'
        + '       Market_Price_Book_Entry__r.Record_Status__c'
        + '  from Account_To_Market_Price_Book_Entry__c'
        + ' where Market_Price_Book_Entry__r.Market_Price_Book__r.Id in :selMpbIds';

    private static final String AMPBE_OBY1 = ' order by'
        + '       Account__r.Name, Account__r.AccountNumber,'
        + '       Market_Price_Book_Entry__r.Material_Sales_Data2__r.Material_Desc__c,'
        + '       Market_Price_Book_Entry__r.Material_Sales_Data2__r.Material_Number__c,'
        + '       Market_Price_Book_Entry__r.Material_Sales_Data2__r.Sales_Org_Code__c,'
        + '       Market_Price_Book_Entry__r.Market_Price_Book__r.Name desc';

    private static final String MPBE_QRY1 = ''
        + 'select Id, Name, '
        + '       Market_Price_Book__r.Id,'
        + '       Market_Price_Book__r.Name,'
        + '       Material_Sales_Data2__r.Id,'
        + '       Material_Sales_Data2__r.Material_Desc__c,'
        + '       Material_Sales_Data2__r.Material_Number__c,'
        + '       Material_Sales_Data2__r.Sales_Org_Code__c,'
        + '       Record_Status__c'
        + '  from Market_Price_Book_Entry__c'
        + ' where Market_Price_Book__c in :selMpbIds';

    private static final String MPBE_OBY1 = ' order by'
        + '       Material_Sales_Data2__r.Material_Desc__c,'
        + '       Material_Sales_Data2__r.Material_Number__c,'
        + '       Material_Sales_Data2__r.Sales_Org_Code__c,'
        + '       Market_Price_Book__r.Name desc';

    private static final String PCN_QRY1 = ''
        + 'select Id, Name,'
        + '       Account__r.Id, Account__r.Name, Account__r.AccountNumber,'
        + '       Market_Price_Book_Entry__r.Id,'
        + '       Market_Price_Book_Entry__r.Name,'
        + '       Market_Price_Book_Entry__r.Market_Price_Book__r.Id,'
        + '       Market_Price_Book_Entry__r.Market_Price_Book__r.Name,'
        + '       Market_Price_Book_Entry__r.Record_Status__c,'
        + '       Market_Pricing_Type__c, Material2__r.Id,'
        + '       Material2__r.Material_Desc__c, Material2__r.Material_Number__c,'
        + '       Material2__r.Sales_Org_Code__c, Record_Status__c'
        + '  from Pricing_Condition__c'
        + ' where Market_Price_Book_Entry__r.Market_Price_Book__r.Id in :selMpbIds'
        + '   and Record_Status__c not in :PC_STATS1';

    private static final String PCN_OBY1 = ' order by'
        + '       Name, Account__r.Name, Account__r.AccountNumber, Record_Status__c,'
        + '       Material2__r.Material_Desc__c, Material2__r.Material_Number__c,'
        + '       Material2__r.Sales_Org_Code__c,'
        + '       Market_Price_Book_Entry__r.Market_Price_Book__r.Name desc';

    private static final String WRK_QRY1 = ''
        + 'select Id, Name, Market_Price_Book__r.Id,'
        + '       Market_Price_Book__r.Name, Market_Price_Book__r.Record_Status__c,'
        + '       Pricing_Condition__r.Account__r.Id,'
        + '       Pricing_Condition__r.Account__r.Name,'
        + '       Pricing_Condition__r.Account__r.AccountNumber,'
        + '       Pricing_Condition__r.Market_Price_Book_Entry__r.Id,'
        + '       Pricing_Condition__r.Market_Price_Book_Entry__r.Name,'
        + '       Pricing_Condition__r.Market_Price_Book_Entry__r.Market_Price_Book__r.Id,'
        + '       Pricing_Condition__r.Market_Price_Book_Entry__r.Market_Price_Book__r.Name,'
        + '       Pricing_Condition__r.Market_Price_Book_Entry__r.Record_Status__c,'
        + '       Pricing_Condition__r.Market_Pricing_Type__c,'
        + '       Pricing_Condition__r.Material2__r.Id,'
        + '       Pricing_Condition__r.Material2__r.Material_Desc__c,'
        + '       Pricing_Condition__r.Material2__r.Material_Number__c,'
        + '       Pricing_Condition__r.Material2__r.Sales_Org_Code__c,'
        + '       Pricing_Condition__r.Name,'
        + '       Pricing_Condition__r.Record_Status__c'
        + '  from Market_Price_Book_Work_When_Approved__c'
        + ' where Market_Price_Book__c in :selMpbIds'
        + '   and MFD__c = false'
        + '   and Pricing_Condition__r.Record_Status__c not in :PC_STATS1';

    private static final String WRK_OBY1 = ' order by'
        + '       Pricing_Condition__r.Account__r.Name,'
        + '       Pricing_Condition__r.Account__r.AccountNumber,'
        + '       Pricing_Condition__r.Record_Status__c,'
        + '       Pricing_Condition__r.Material2__r.Material_Desc__c,'
        + '       Pricing_Condition__r.Material2__r.Material_Number__c,'
        + '       Pricing_Condition__r.Material2__r.Sales_Org_Code__c,'
        + '       Market_Price_Book__r.Name desc';

    public class TableRow {
        public Market_Price_Book__c                    mpb {get; set;}
        public Market_Price_Book_Entry__c             mpbe {get; set;}
        public Account_To_Market_Price_Book_Entry__c ampbe {get; set;}
        public Pricing_Condition__c                    pcn {get; set;}
        public Market_Price_Book_Work_When_Approved__c wrk {get; set;}

        public Boolean   selected {get; set;}
        public Integer     recNum {get; set;}
        public String  styleClass {get; set;}

        public Integer  mpbeCount {get; set;}
        public Integer  mpbwCount {get; set;}
        public Integer ampbeCount {get; set;}
        public Integer   pcnCount {get; set;}

        public String      accNum {get; set;}
        public String      matNum {get; set;}

      //public TableRow(Market_Price_Book__c a)                               {this(a, 1);}
        public TableRow(Market_Price_Book__c a, Integer n)                    {init1(n); init2(a);}

      //public TableRow(Market_Price_Book_Entry__c a)                         {this(a, 1);}
        public TableRow(Market_Price_Book_Entry__c a, Integer n)              {init1(n); init2(a);}

      //public TableRow(Account_To_Market_Price_Book_Entry__c a)              {this(a, 1);}
        public TableRow(Account_To_Market_Price_Book_Entry__c a, Integer n)   {init1(n); init2(a);}

      //public TableRow(Pricing_Condition__c a)                               {this(a, 1);}
        public TableRow(Pricing_Condition__c a, Integer n)                    {init1(n); init2(a);}

      //public TableRow(Market_Price_Book_Work_When_Approved__c a)            {this(a, 1);}
        public TableRow(Market_Price_Book_Work_When_Approved__c a, Integer n) {init1(n); init2(a);}

        private void init1(Integer n) {recNum = n; selected = false; styleClass = '';}

        private void init2(Market_Price_Book__c a) {mpb = a;}

        private void init2(Market_Price_Book_Entry__c a) {
            mpbe = a; mpb = a.Market_Price_Book__r;
            setMat(mpbe.Material_Sales_Data2__r);
        }

        private void init2(Account_To_Market_Price_Book_Entry__c a) {
            ampbe = a; mpbe = a.Market_Price_Book_Entry__r; mpb = mpbe.Market_Price_Book__r;
            setAcc(ampbe.Account__r); setMat(mpbe.Material_Sales_Data2__r);
        }

        private void init2(Pricing_Condition__c a) {
            pcn = a; mpbe = a.Market_Price_Book_Entry__r; mpb = mpbe.Market_Price_Book__r;
            setAcc(pcn.Account__r); setMat(pcn.Material2__r);
        }

        private void init2(Market_Price_Book_Work_When_Approved__c a) {
            wrk = a; mpb = a.Market_Price_Book__r; pcn = a.Pricing_Condition__r;
            mpbe = pcn.Market_Price_Book_Entry__r;
            setAcc(pcn.Account__r); setMat(pcn.Material2__r);
        }

        private void setAcc(Account acc) {
            accNum = String_Functions.removeLeadingZeros(acc.AccountNumber);
        }

        private void setMat(Material_Sales_Data2__c mat) {
            matNum = String_Functions.removeLeadingZeros(mat.Material_Number__c);
        }
    }

    public Boolean   allMpbs {get; set;}
    public Boolean  allMpbes {get; set;}
    public Boolean allAmpbes {get; set;}
    public Boolean   allPcns {get; set;}
    public Boolean   allWrks {get; set;}
    public Boolean debugMode {get; set;}
    public Boolean  batchJob {get; set;}

    public Id          mpbId {get; set;}
    public Integer pageSize1 {get; set;}
    public String    mpbDesc {get; set;}
    public String    mpbNumb {get; set;}
    public String    mpbStat {get; set;}

    public List<TableRow>          mpbList {get; private set;}
    public List<TableRow>         mpbeList {get; private set;}
    public List<TableRow>        ampbeList {get; private set;}
    public List<TableRow>          pcnList {get; private set;}
    public List<TableRow>          wrkList {get; private set;}

    public List<Market_Price_Book__c> mpbs {get; private set;}

    public Market_Price_Book__c        mpb {get; private set;}

    public Boolean              renderMpbs {get; private set;}
    public Boolean             renderMpbes {get; private set;}
    public Boolean            renderAmpbes {get; private set;}
    public Boolean              renderPcns {get; private set;}
    public Boolean              renderWrks {get; private set;}

    public Boolean         renderActvteBtn {get; private set;}
    public Boolean         renderDebugMode {get; private set;}
    public Boolean         renderExpireBtn {get; private set;}
    public Boolean         renderExpiredBy {get; private set;}

    public Integer         pageBlockNumber {get; private set;}

    public PaginationController        pc1 {get; private set;}
    public PaginationController        pc2 {get; private set;}
    public PaginationController        pc3 {get; private set;}
    public PaginationController        pc5 {get; private set;}
    public PaginationController        pc7 {get; private set;}

    public List<SelectOption>  mpbStatOpts {get; private set;}
    public List<SelectOption> pageSizeOpts {get; private set;}

    private List<Market_Price_Book_Entry__c> mpbes;
    private List<Account_To_Market_Price_Book_Entry__c> ampbes;
    private List<Pricing_Condition__c> pcns;
    private List<Market_Price_Book_Work_When_Approved__c> wrks;

    private Map<Id, Integer> ampbeCounts, mpbeCounts, mpbwCounts, pcnCounts;
    private Map<String, String> params;
    private Set<Id> mpbIds, selMpbIds, selMpbeIds, selAmpbeIds, selPcnIds, selWrkIds;

    public MarketPriceBookListController(ApexPages.StandardSetController ssc) {
        if (ssc != null) {mpbs = ssc.getSelected();} init1();
    }

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'MpbListController : ' + s);}

    @TestVisible private void addInfoMsg(String s) {addMsg(INFO, s);}

    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }

    private void init1() {
        debug('init1');
        pageSize1 = PAGE_SIZE2; mpbStat = ACTIVE; batchJob = false;
        pageBlockNumber = 1; mpb = null; mpbId = null;
        debugMode = MarketPriceBookMethods.getDebugMode(); renderDebugMode = debugMode;
        setMpbStatOpts(); setPageSizeOpts(); searchMpbs();
    }

    private void init2() {
        renderActvteBtn = APPROVED.equals(mpbStat);
        renderExpireBtn = ACTIVE.equals(mpbStat) || APPROVED.equals(mpbStat);
        renderExpiredBy = EXPIRED.equals(mpbStat);
    }

    public void initAction() {}

    private void setMpbStatOpts() {
        mpbStatOpts = new List<SelectOption>();
        mpbStatOpts.add(new SelectOption(ACTIVE,    ACTIVE));
        mpbStatOpts.add(new SelectOption(APPROVED,  APPROVED));
        mpbStatOpts.add(new SelectOption(DRAFT,     DRAFT));
        mpbStatOpts.add(new SelectOption(EXPIRED,   EXPIRED));
        mpbStatOpts.add(new SelectOption(SUBMITTED, SUBMITTED));
        mpbStatOpts.add(new SelectOption(ALL,      'All MPBs'));
    }

    private void setPageSizeOpts() {
        pageSizeOpts = new List<SelectOption>(); String s;
        for (Integer n : PAGE_SIZES) {
            s = '' + n; pageSizeOpts.add(new SelectOption(s, s));
        }
    }

    private Boolean isExpired(Pricing_Condition__c pc) {
        return PC_STATS1.contains(pc.Record_Status__c);
    }

    @TestVisible private void selectRows(List<TableRow> trs) {
        if (trs == null || trs.isEmpty()) {return;}
        for (TableRow tr : trs) {tr.selected = true;}
    }

    private Boolean ampbesNotSelected() {
        selAmpbeIds = new Set<Id>();
        for (TableRow tr : ampbeList) {
            if (tr.selected) {selAmpbeIds.add(tr.ampbe.Id);}
        }
        return (selAmpbeIds.isEmpty());
    }

    private Boolean mpbsNotSelected() {
        debug('mpbsNotSelected : debugMode = ' + debugMode);
        selMpbIds = new Set<Id>();
        for (TableRow tr : mpbList) {
            if (tr.selected) {selMpbIds.add(tr.mpb.Id);}
        }
        return (selMpbIds.isEmpty());
    }

    private Boolean pcnsNotSelected() {
        selPcnIds = new Set<Id>();
        for (TableRow tr : pcnList) {
            if (tr.selected) {selPcnIds.add(tr.pcn.Id);}
        }
        return (selPcnIds.isEmpty());
    }

    private Boolean wrksNotSelected() {
        selWrkIds = new Set<Id>();
        for (TableRow tr : wrkList) {
            if (tr.selected) {selWrkIds.add(tr.wrk.Id);}
        }
        return (selWrkIds.isEmpty());
    }

    private void submitBatchJob(String procName, String stepName, Set<Id> idSet) {
        List<Id> alist = new List<Id>();
        if (idSet != null && !idSet.isEmpty()) {alist.addAll(idSet);}
        if (String.isBlank(procName)) {
            MarketPriceBookBatchable.submitBatchJob3(stepName, alist);
        } else {
            MarketPriceBookBatchable.submitBatchJob(procName, stepName, alist);
        }
        addInfoMsg(MSG_1);
    }

    private void submitBatchJob(String stepName, Set<Id> idSet) {
        submitBatchJob(null, stepName, idSet);
    }

    public void submitAllJobs() {
        String s = MarketPriceBookBatchable.ACTIVATE_MPBS;
        submitBatchJob(s, s, selMpbIds);
    }

    public void activateMpbs() {
        if (mpbsNotSelected()) {return;}
        if (batchJob) {
            submitBatchJob(MarketPriceBookBatchable.ACTIVATE_MPBS, selMpbIds);
        } else {
            MarketPriceBookMethods.activateMpbs(selMpbIds, debugMode);
            searchMpbs();
        }
    }

    public void expireMpbs() {
        if (mpbsNotSelected()) {return;}
        if (batchJob) {
            submitBatchJob(MarketPriceBookBatchable.EXPIRE_MPBS, selMpbIds);
        } else {
            MarketPriceBookMethods.expireMpbs(selMpbIds, debugMode);
            searchMpbs();
        }
    }

    public void processWrks() {
        if (wrksNotSelected()) {return;}
        if (batchJob) {
            submitBatchJob(MarketPriceBookBatchable.PROCESS_MPBWS, selWrkIds);
        } else {
            MarketPriceBookMethods.processMpbWrks(selWrkIds, debugMode);
            searchWrks2();
        }
    }

    public void processPcns() {
        if (pcnsNotSelected()) {return;}
        if (batchJob) {
            submitBatchJob(MarketPriceBookBatchable.PROCESS_PCNS, selPcnIds);
        } else {
            MarketPriceBookMethods.processPcns(selPcnIds, debugMode);
            searchPcns2();
        }
    }

    public void processAmpbes() {
        if (ampbesNotSelected()) {return;}
        if (batchJob) {
            submitBatchJob(MarketPriceBookBatchable.PROCESS_AMPBS, selAmpbeIds);
        } else {
            MarketPriceBookMethods.processAccMpbes(selAmpbeIds, debugMode);
            searchAmpbes2();
        }
    }

// ----------------------------------------------------------------------------------------------------

    public void searchMpbs() {
        init2(); String q = MPB_QRY1, s = '';
        if (!String.isBlank(mpbNumb)) {s += ' and Name like \'%' + mpbNumb + '%\'';}
        if (!String.isBlank(mpbDesc)) {s += ' and Description__c like \'%' + mpbDesc + '%\'';}
        if (!ALL.equals(mpbStat))     {s += ' and Record_Status__c = \'' + mpbStat + '\'';}
        if (!String.isBlank(s)) {s = ' where ' + s.substring(5);}
        q += s + MPB_OBY1; debug('searchMpbs : q = ' + q);
        Database.Querylocator ql; pc1 = null;
        try {
            ql  = Database.getQueryLocator(q);
            pc1 = new PaginationController(ql, pageSize1);
        } catch(Exception e) {debug('searchMpbs : ' + e.getMessage());}
        if (pc1 == null) {return;} setMpbs();
    }

    public void pc1Size() {setMpbs(null);}
    public void pc1Frst() {setMpbs(PaginationController.Page.FIRST);}
    public void pc1Prev() {setMpbs(PaginationController.Page.PREV);}
    public void pc1Next() {setMpbs(PaginationController.Page.NEXT);}
    public void pc1Last() {setMpbs(PaginationController.Page.LAST);}

    private void setMpbs() {setMpbs(null);}

    private void setMpbs(PaginationController.Page p) {
        mpbs = null; allMpbs = false; renderMpbs = false; Integer n = 0;
        TableRow tr; mpbList = new List<TableRow>();
        if (pc1 != null) {
            pc1.gotoPage(p); n = pc1.recordFrom;
            mpbs = pc1.getRecords(); pageSize1 = pc1.getPageSize();
        }
        renderMpbs = (mpbs != null && !mpbs.isEmpty());
        if (!renderMpbs)  {return;}
        setMpbIds(); setCounts();
        for (Market_Price_Book__c m : mpbs) {
            tr = new TableRow(m, n++); mpbList.add(tr);
            tr.mpbeCount = mpbeCounts.get(m.Id);
            tr.mpbwCount = mpbwCounts.get(m.Id);
            tr.ampbeCount = ampbeCounts.get(m.Id);
            tr.pcnCount = pcnCounts.get(m.Id);
        }
        mpb = mpbs[0]; mpbId = mpb.Id;
        pageBlockNumber = 1; mpbs = null;
    }

    private void setCounts() {
        setMpbeCounts(); setMpbwCounts();
        setAccMpbeCounts(); setPcnCounts();
    }

    private void setMpbIds() {
        mpbIds = new Set<Id>();
        for (Market_Price_Book__c m : mpbs) {mpbIds.add(m.Id);}
    }

    private void setMpbeCounts() {
        mpbeCounts = new Map<Id, Integer>(); Integer n;
        for (Market_Price_Book_Entry__c a : [
            select Market_Price_Book__c
              from Market_Price_Book_Entry__c
             where Market_Price_Book__c in :mpbIds]) {
            n = mpbeCounts.get(a.Market_Price_Book__c);
            if (n == null) {n = 0;}
            mpbeCounts.put(a.Market_Price_Book__c, ++n);
        }
    }

    private void setMpbwCounts() {
        mpbwCounts = new Map<Id, Integer>(); Integer n;
        for (Market_Price_Book_Work_When_Approved__c a : [
            select Market_Price_Book__c, MFD__c,
                   Pricing_Condition__r.Record_Status__c
              from Market_Price_Book_Work_When_Approved__c
             where Market_Price_Book__c in :mpbIds]) {
            if (a.MFD__c || isExpired(a.Pricing_Condition__r)) {continue;}
            n = mpbwCounts.get(a.Market_Price_Book__c);
            if (n == null) {n = 0;}
            mpbwCounts.put(a.Market_Price_Book__c, ++n);
        }
    }

    private void setAccMpbeCounts() {
        ampbeCounts = new Map<Id, Integer>(); Integer n;
        for (Account_To_Market_Price_Book_Entry__c a : [
            select Market_Price_Book_Entry__r.Market_Price_Book__c
              from Account_To_Market_Price_Book_Entry__c
             where Market_Price_Book_Entry__r.Market_Price_Book__c in :mpbIds]) {
            n = ampbeCounts.get(a.Market_Price_Book_Entry__r.Market_Price_Book__c);
            if (n == null) {n = 0;}
            ampbeCounts.put(a.Market_Price_Book_Entry__r.Market_Price_Book__c, ++n);
        }
    }

    private void setPcnCounts() {
        pcnCounts = new Map<Id, Integer>(); Integer n;
        for (Pricing_Condition__c a : [
            select Market_Price_Book_Entry__r.Market_Price_Book__c, Record_Status__c
              from Pricing_Condition__c
             where Market_Price_Book_Entry__r.Market_Price_Book__c in :mpbIds]) {
            if (isExpired(a)) {continue;}
            n = pcnCounts.get(a.Market_Price_Book_Entry__r.Market_Price_Book__c);
            if (n == null) {n = 0;}
            pcnCounts.put(a.Market_Price_Book_Entry__r.Market_Price_Book__c, ++n);
        }
    }

// ----------------------------------------------------------------------------------------------------

    public void searchMpbes() {
        if (mpbsNotSelected()) {return;} searchMpbes2();
    }

    public void searchMpbes1() {
        selMpbIds = new Set<Id>{mpbId}; searchMpbes2();
    }

    private void searchMpbes2() {
        String q = MPBE_QRY1 + MPBE_OBY1; debug('searchMpbes : q = ' + q);
        Database.Querylocator ql; pc2 = null;
        try {
            ql  = Database.getQueryLocator(q);
            pc2 = new PaginationController(ql, pageSize1);
        } catch(Exception e) {debug('searchMpbes : ' + e.getMessage());}
        if (pc2 == null) {return;} setMpbes();
    }

    public void pc2Size() {setMpbes(null);}
    public void pc2Frst() {setMpbes(PaginationController.Page.FIRST);}
    public void pc2Prev() {setMpbes(PaginationController.Page.PREV);}
    public void pc2Next() {setMpbes(PaginationController.Page.NEXT);}
    public void pc2Last() {setMpbes(PaginationController.Page.LAST);}

    private void setMpbes() {setMpbes(null);}

    private void setMpbes(PaginationController.Page p) {
        mpbes = null; allMpbes = false; renderMpbes = false; Integer n = 0;
        TableRow tr; mpbeList = new List<TableRow>();
        if (pc2 != null) {
            pc2.gotoPage(p); n = pc2.recordFrom;
            mpbes = pc2.getRecords(); pageSize1 = pc2.getPageSize();
        }
        renderMpbes = (mpbes != null && !mpbes.isEmpty());
        if (!renderMpbes)  {return;}
        for (Market_Price_Book_Entry__c m : mpbes) {
            tr = new TableRow(m, n++); mpbeList.add(tr);
        }
        pageBlockNumber = 2; mpbes = null;
    }

// ----------------------------------------------------------------------------------------------------

    public void searchAmpbes() {
        if (mpbsNotSelected()) {return;} searchAmpbes2();
    }

    public void searchAmpbes1() {
        selMpbIds = new Set<Id>{mpbId}; searchAmpbes2();
    }

    private void searchAmpbes2() {
        String q = AMPBE_QRY1 + AMPBE_OBY1; debug('searchAmpbes : q = ' + q);
        Database.Querylocator ql; pc3 = null;
        try {
            ql  = Database.getQueryLocator(q);
            pc3 = new PaginationController(ql, pageSize1);
        } catch(Exception e) {debug('searchAmpbes : ' + e.getMessage());}
        if (pc3 == null) {return;} setAmpbes();
    }

    public void pc3Size() {setAmpbes(null);}
    public void pc3Frst() {setAmpbes(PaginationController.Page.FIRST);}
    public void pc3Prev() {setAmpbes(PaginationController.Page.PREV);}
    public void pc3Next() {setAmpbes(PaginationController.Page.NEXT);}
    public void pc3Last() {setAmpbes(PaginationController.Page.LAST);}

    private void setAmpbes() {setAmpbes(null);}

    private void setAmpbes(PaginationController.Page p) {
        ampbes = null; allAmpbes = false; renderAmpbes = false; Integer n = 0;
        TableRow tr; ampbeList = new List<TableRow>();
        if (pc3 != null) {
            pc3.gotoPage(p); n = pc3.recordFrom;
            ampbes = pc3.getRecords(); pageSize1 = pc3.getPageSize();
        }
        renderAmpbes = (ampbes != null && !ampbes.isEmpty());
        if (!renderAmpbes)  {return;}
        for (Account_To_Market_Price_Book_Entry__c m : ampbes) {
            tr = new TableRow(m, n++); ampbeList.add(tr);
        }
        pageBlockNumber = 3; ampbes = null;
    }

// ----------------------------------------------------------------------------------------------------

    public void searchPcns() {
        if (mpbsNotSelected()) {return;} searchPcns2();
    }

    public void searchPcns1() {
        selMpbIds = new Set<Id>{mpbId}; searchPcns2();
    }

    private void searchPcns2() {
        String q = PCN_QRY1 + PCN_OBY1; debug('searchPcns2 : q = ' + q);
        Database.Querylocator ql; pc5 = null;
        try {
            ql  = Database.getQueryLocator(q);
            pc5 = new PaginationController(ql, pageSize1);
        } catch(Exception e) {debug('searchPcns2 : ' + e.getMessage());}
        if (pc5 == null) {return;} setPcns();
    }

    public void pc5Size() {setPcns(null);}
    public void pc5Frst() {setPcns(PaginationController.Page.FIRST);}
    public void pc5Prev() {setPcns(PaginationController.Page.PREV);}
    public void pc5Next() {setPcns(PaginationController.Page.NEXT);}
    public void pc5Last() {setPcns(PaginationController.Page.LAST);}

    private void setPcns() {setPcns(null);}

    private void setPcns(PaginationController.Page p) {
        pcns = null; allPcns = false; renderPcns = false; Integer n = 0;
        TableRow tr; pcnList = new List<TableRow>();
        if (pc5 != null) {
            pc5.gotoPage(p); n = pc5.recordFrom;
            pcns = pc5.getRecords(); pageSize1 = pc5.getPageSize();
        }
        renderPcns = (pcns != null && !pcns.isEmpty());
        if (!renderPcns)  {return;}
        for (Pricing_Condition__c m : pcns) {
            if (PC_STATS1.contains(m.Record_Status__c)) {continue;}
            tr = new TableRow(m, n++); pcnList.add(tr);
        }
        pageBlockNumber = 5; pcns = null;
    }

// ----------------------------------------------------------------------------------------------------

    public void searchWrks() {
        if (mpbsNotSelected()) {return;} searchWrks2();
    }

    public void searchWrks1() {
        selMpbIds = new Set<Id>{mpbId}; searchWrks2();
    }

    private void searchWrks2() {
        String q = WRK_QRY1 + WRK_OBY1; debug('searchWrks : q = ' + q);
        Database.Querylocator ql; pc7 = null;
        try {
            ql  = Database.getQueryLocator(q);
            pc7 = new PaginationController(ql, pageSize1);
        } catch(Exception e) {debug('searchWrks : ' + e.getMessage());}
        if (pc7 == null) {return;} setWrks();
    }

    public void pc7Size() {setWrks(null);}
    public void pc7Frst() {setWrks(PaginationController.Page.FIRST);}
    public void pc7Prev() {setWrks(PaginationController.Page.PREV);}
    public void pc7Next() {setWrks(PaginationController.Page.NEXT);}
    public void pc7Last() {setWrks(PaginationController.Page.LAST);}

    private void setWrks() {setWrks(null);}

    private void setWrks(PaginationController.Page p) {
        wrks = null; allWrks = false; renderWrks = false; Integer n = 0;
        TableRow tr; wrkList = new List<TableRow>();
        if (pc7 != null) {
            pc7.gotoPage(p); n = pc7.recordFrom;
            wrks = pc7.getRecords(); pageSize1 = pc7.getPageSize();
        }
        renderWrks = (wrks != null && !wrks.isEmpty());
        if (!renderWrks)  {return;}
        for (Market_Price_Book_Work_When_Approved__c m : wrks) {
            tr = new TableRow(m, n++); wrkList.add(tr);
        }
        pageBlockNumber = 7; wrks = null;
    }

// ----------------------------------------------------------------------------------------------------

}