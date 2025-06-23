public class PricingConditionListController {

    private static final Integer PAGE_SIZE = 100;
    private static final String COMMA    = ',';
    private static PageReference ACCOUNTS_TAB = new PageReference('/001/o');
    private static PageReference EDIT_PAGE2 = Page.PricingConditionListPage2;
    private static PageReference ADD_PAGE1 = Page.PricingConditionAddPage1;
    private static PageReference NEW_CONTRACT_PAGE = Page.Pricing_ContractPricingWizard;
    private static final String URL1 = '/apex/PricingConditionListPage1?ac=';
    private static final String URL2 = '&rs=';
    private static final String COPY_URL1 = '/apex/PricingConditionCopyPage1';

    private static final String ACTIVE    = 'Active';
    private static final String APPROVED  = 'Approved,Not Yet Active';
    private static final String CANCELLED = 'Cancelled';
    private static final String DRAFT     = 'Draft';
    private static final String EXPIRED   = 'Expired';
    private static final String REJECTED  = 'Rejected';
    private static final String SUBMITTED = 'In Approval Process';
    private static final String ALL       = 'All';
    private static final String OTCREJECTED = 'Rejected by OTC';

    private static final String SHIPTO = Account_Partner_Functions.ACC_TYPE_SHIPTO;
    private static final String SOLDTO = Account_Partner_Functions.ACC_TYPE_SOLDTO;

    private static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    private static final ApexPages.Severity INFO  = ApexPages.Severity.INFO;

    private static final String ACTV = 'actv';
    private static final String APRV = 'aprv';
    private static final String CNCL = 'cncl';
    private static final String DRFT = 'drft';
    private static final String EXPR = 'expr';
    private static final String RJCT = 'rjct';
    private static final String SBMT = 'sbmt';
    private static final String OTCRJT = 'otcrjt';

    // Record Status Value Name Map
    private static final Map<String, String> RSVN_MAP = new Map<String, String>{
        ACTV => ACTIVE,
        APRV => APPROVED,
        CNCL => CANCELLED,
        DRFT => DRAFT,
        EXPR => EXPIRED,
        RJCT => REJECTED,
        SBMT => SUBMITTED,
        ALL  => ALL,
        OTCRJT => OTCREJECTED
    };

    private static final Map<String, Set<String>> RECS_MAP = new Map<String, Set<String>>{
        ACTIVE    => new Set<String>{ACTIVE},
        APPROVED  => new Set<String>{APPROVED},
        CANCELLED => new Set<String>{CANCELLED},
        DRAFT     => new Set<String>{DRAFT},
        EXPIRED   => new Set<String>{EXPIRED},
        REJECTED  => new Set<String>{REJECTED},
        SUBMITTED => new Set<String>{SUBMITTED},
        ALL       => new Set<String>{ACTIVE, APPROVED, CANCELLED, DRAFT, EXPIRED, REJECTED, SUBMITTED, OTCREJECTED},
        OTCREJECTED => new Set<String>{OTCREJECTED}
    };

    // value, label
    private static final List<SelectOption> recordStatusList = new List<SelectOption>{
            new SelectOption(SBMT, SUBMITTED),
            new SelectOption(RJCT,  REJECTED),
            new SelectOption(OTCRJT, OTCREJECTED),
            new SelectOption(CNCL, CANCELLED),
            new SelectOption(DRFT,     DRAFT),
            new SelectOption(EXPR,   EXPIRED),
            new SelectOption(APRV,  APPROVED),
            new SelectOption(ACTV,    ACTIVE),
            new SelectOption(ALL, 'All Conditions')
    };

    private static final Set<String> ACC_REC_TYPES_AAFI = new Set<String>{'Aqualon Customer', 'Aqualon Prospect'};
    private static final Set<String> ACC_REC_TYPES_AHWT = new Set<String>{'Drew Customer', 'Water Prospect'};
    private static final Set<String> ACC_REC_TYPES_PM = new Set<String>{'Performance Materials Customer'};

    private static final Map<Id,String> ACCOUNT_RECTYPES = getAccountRecordTypeMap();

    private Boolean isActivateAllowed = false, isCopyAllowed = false, isMultiIndustyAcc = false,
                    isAAFI = false, isAHWT = false, isAHWT_EMEA = false;

    public String accountId {get; set;}
    private String accDetailsUrl;
    private String pcListPageUrl;

    public final Account acc {get; set;}

    public String accountNumber {get; set;}

    public String accountRecordType {get; set;}

    public Boolean renderPcs {get; set;}

    public String rsparam {get; set;}
    public String recordStatus {get; set;}
    private Set<String> recordStatusSet;

    public List<Pricing_Condition> plist;
    public List<Pricing_Condition> slist {get; private set;}

    public List<Pricing_Condition__c> pcs {get; set;}
    public Pricing_Condition__c pc {get; set;}

    public Boolean allSelected {get; set;}
    public Boolean disableSubmit {get; set;}
    public Boolean inactiveAccount {get; set;}
    public Boolean renderExtendAtSoldTo {get; set;}
    public Boolean renderActivateButton {get; set;}
    public Boolean renderCopyButton {get; set;}
    public Boolean renderMarketPrice {get; set;}
    public Boolean renderNewInvoicePrice {get; set;}
    public Boolean extendJobSubmitted {get; set;}
    public String extendToLbl {get; set;}
    public String selectedIds {get; set;}
    public String userComments {get; set;}
    public String userLocale {get; set;}

    public PageReference returnPage {get; set;}

    public Integer lastPageNumber {get; set;}
    public Integer pageNumber;
    public Integer recordFrom {get; set;}
    public Integer recordTo {get; set;}
    public Integer resultSize {get; set;}

    private Boolean mktpbwired = false;
    private ApexPages.StandardSetController ssc;

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'PricingConditionListController : ' + s);
    }

    private void addErrMsg(String s)  {addMsg(ERROR, s);}

    private void addInfoMsg(String s) {addMsg(INFO,  s);}

    private void addMsg(ApexPages.Severity mtype, String s) {
        debug('addMsg : ' + s);
        ApexPages.Message msg = new ApexPages.Message(mtype, '<b>' + s + '</b>');
        ApexPages.addMessage(msg);
    }

    public PricingConditionListController(ApexPages.StandardSetController c) {
        debug('PricingConditionListController : constructor begins');
        userLocale = UserInfo.getLocale();
        accountId = ApexPages.currentPage().getParameters().get('ac');
        rsparam = ApexPages.currentPage().getParameters().get('rs');
        if (rsparam == null || !RSVN_MAP.containsKey(rsparam)) {rsparam = ALL;}
        renderMarketPrice = Schema_Services.isFieldAccessible('Pricing_Condition__c', 'Market_Price__c');
        Pricing_Security__c ps = Pricing_Security__c.getInstance();
        if (ps != null) {
            isActivateAllowed = ps.Allowed_to_activate_PricingConditions__c;
            isCopyAllowed = ps.Allowed_to_Copy_PricingConditions__c;
        }
        if (accountId != null) {
          acc = [select Id, Name, AccountNumber, Inactive_Account__c, Multi_Level_Industry__c, RecordTypeId,
                        SAP_Customer_Group_1_Desc__c, SAP_DistChannel__c, SAP_Sales_Org__c, sales_area__c
                   from Account where Id = :accountId];
          isMultiIndustyAcc = SAP_LISD_Functions.isMultiLevelIndustryAccount(acc);
          setStandardSetController(); //init();
        }
    }

    private static Map<Id,String> getAccountRecordTypeMap() {
      Map<Id,String> amap = new Map<Id,String>();
      for (RecordType r : [select Id, Name
                               from RecordType
                              where isActive = true
                                and sObjectType = 'Account'
                            ]) {
            amap.put(r.Id, r.Name);
        }
        return amap;
    }

    public PageReference initAction() {
      if (accountId == null) {return ACCOUNTS_TAB;}
      return null;
    }

    private void init() {
        debug('init');
        if (acc == null) {addErrMsg('Account not known'); return;}
        accountNumber = String_Functions.removeLeadingZeros(acc.AccountNumber);
        accountRecordType = ACCOUNT_RECTYPES.get(acc.RecordTypeId);
        inactiveAccount = (acc.Inactive_Account__c != null && acc.Inactive_Account__c);
        isAAFI = SAP_Queries_Functions.isAAFI(acc);
        isAHWT = SAP_Queries_Functions.isAHWT(acc);
        isAHWT_EMEA = SAP_Queries_Functions.isAHWT_EMEA(acc);
        String dc = acc.SAP_DistChannel__c;
        Integer n = PricingConditionFunctions.getMaxDaysToExtend(dc);
        extendToLbl = 'Extend To Date (Max. ' + n + ' days)';
        recordStatus = RSVN_MAP.get(rsparam);
        recordStatusSet = RECS_MAP.get(recordStatus);
        accDetailsUrl = '/' + accountId;
        pcListPageUrl = URL1 + accountId + URL2 + rsparam;
        userComments = '';
        allSelected = false; renderPcs = false; renderNewInvoicePrice = true;
        renderExtendAtSoldTo = false; extendJobSubmitted = false;
        pc = new Pricing_Condition__c();
        pc.Valid_To_Date__c = Date.today().addDays(30);
        //debug('accountRecordType = ' + accountRecordType);
        pageNumber = 0; recordFrom = 0; recordTo = 0; lastPageNumber = 0;
        if (isAAFI) {renderNewInvoicePrice = false; renderMarketPrice = false;}
    }

    private void setStandardSetController() {
        debug('setStandardSetController');
        init();
        Database.Querylocator ql = getQueryLocator();
        ssc = new ApexPages.StandardSetController(ql);
        resultSize = ssc.getResultSize();
        setPageSize(PAGE_SIZE);
        renderPcs = (resultSize > 0);
        renderActivateButton = isApproved && isActivateAllowed;
        renderCopyButton = isCopyAllowed && (recordStatus == ALL) && renderPcs;
        if (renderPcs) {setPCList();}
    }

    private Database.Querylocator getQueryLocator() {
        debug('getQueryLocator');
        Database.Querylocator ql;
        Date currentDate = Date.today();
        String qry = PricingConditionFunctions.SELECT_QRY_1 +
           + '    where Account__c = :accountId'
           + '      and Record_Status__c in :recordStatusSet'
           + ' order by Material2__r.Material_Desc__c,'
           + '          Valid_From_Date__c';
        ql = Database.getQueryLocator(qry);
        return ql;
    }

    private void setRecordNumbers() {
        allSelected = false;
        Integer n = getPageSize();
        recordFrom = (pageNumber - 1) * n + 1;
        if (recordFrom < 1) {
            recordFrom = 1;
        }
        recordTo = recordFrom + n - 1;
        if (recordTo > resultSize) {
            recordTo = resultSize;
        }
        //debug(pageNumber + ':' + recordFrom + '-' + recordTo);
    }

    public void first() {
        ssc.first();
        resetPageNumbers(); setPCList();
    }

    private void resetPageNumbers() {
        pageNumber = 1;
        recordFrom = 1;
        Decimal d = 1.0 * resultSize / getPageSize();
        lastPageNumber = d.round(System.RoundingMode.UP).intValue();
        setRecordNumbers();
    }

    public void last() {
        ssc.last();
        pageNumber = lastPageNumber;
        setRecordNumbers(); setPCList();
    }

    public void next() {
        ssc.next();
        pageNumber = ssc.getPageNumber();
        setRecordNumbers(); setPCList();
    }

    public void previous() {
        ssc.previous();
        pageNumber = ssc.getPageNumber();
        setRecordNumbers(); setPCList();
    }

    public Integer getPageSize() {
      if (ssc == null) {return 0;}
        return ssc.getPageSize();
    }

    public void setPageSize(Integer n) {
        ssc.setPageSize(n);
        if (resultSize > 0) {
            resetPageNumbers();
        }
    }

    public Integer getPageNumber() {
        return pageNumber;
    }

    public void setPageNumber(Integer n) {
        pageNumber = n;
        ssc.setPageNumber(pageNumber);
        setRecordNumbers();
    }

    public List<SelectOption> getRecordStatusList() {
        return recordStatusList;
    }

    public void changeRecordStatus() {
        debug('changeRecordStatus');
        recordStatus = RSVN_MAP.get(rsparam);
        recordStatusSet = RECS_MAP.get(recordStatus);
        setStandardSetController();
    }

    private void setPCList() {
        debug('setPCList');
        getPricingConditions(); setPricingConditionList(pcs);
    }

    public List<Pricing_Condition__c> getPricingConditions() {
        debug('getPricingConditions');
        if (ssc != null) {
            pcs = (List<Pricing_Condition__c>) ssc.getRecords();
            renderPcs = (pcs.size() > 0);
        }
        return pcs;
    }

    public List<Pricing_Condition> getPricingConditionList() {
        return plist;
    }

    private void setPricingConditionList(List<Pricing_Condition__c> pcs) {
        debug('setPricingConditionList');
        mktpbwired = true; if (pcs == null || pcs.isEmpty()) {return;}
        plist = new List<Pricing_Condition>(); Integer n = recordFrom;
        Set<String> mpwset = PricingConditionListFunctions.MKT_PB_WIRED;
        for (Pricing_Condition__c pc : pcs) {
            Pricing_Condition p = new Pricing_Condition(pc, n++);
            setSellerName(p, pc);
            p.invoicePrice = pc.Invoice_Price__c; plist.add(p);
            if (!mpwset.contains(p.marketPricingType)) {mktpbwired = false;}
        }
        debug('setPricingConditionList : mktpbwired = ' + mktpbwired);
        PricingConditionFunctions.setAttachments(plist);
    }

    private void setSellerName(Pricing_Condition p, Pricing_Condition__c pc) {
        if (pc.Account__r == null || pc.Account__r.Owner == null) {return;}
        if (!isMultiIndustyAcc) {p.sellerName = pc.Account__r.Owner.Name;}
    }

    private Set<Id> getSelectedObjectIds() {
        Set<Id> ss = new Set<Id>(); selectedIds = ''; Integer i = 0;
        for (Pricing_Condition pc : plist) {
            if (pc.selected) {
                ss.add(pc.pricingCondition.id); i++;
                if (i > 1) {selectedIds += COMMA;}
                selectedIds += pc.pricingCondition.id;
            }
        }
        return ss;
    }

    private Set<String> getSelectedIds() {
        Set<String> aset = new Set<String>();
        for (Pricing_Condition pc : plist) {
            if (pc.selected) {aset.add(pc.pricingCondition.id);}
        }
        return aset;
    }

    public PageReference editSelectedList() {
        if (inactiveAccount) {return inactiveAccountMsg();}
        Set<Id> oids = getSelectedObjectIds();
        //debug(''+selectedIds);
        return EDIT_PAGE2;
    }

    private PageReference inactiveAccountMsg() {
        addInfoMsg('The Account is marked for deletion.  No Pricing can be entered.');
        return null;
    }

    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public Boolean isSelectable {
      get {
        return renderPcs != null && renderPcs && (isActive || isEditable);
      }
    }

    public Boolean isActive {
        get {
            return  renderPcs != null && renderPcs &&
                   (recordStatus == ACTIVE ||
                    recordStatus == APPROVED);
        }
    }

    public Boolean isApproved {
        get {
            return (renderPcs != null && renderPcs && recordStatus == APPROVED);
        }
    }

    public Boolean isDeletable {
        get {
            return (renderPcs != null && renderPcs && recordStatus == DRAFT);
        }
    }

    public Boolean isEditable {
        get {
            return  renderPcs != null && renderPcs &&
                   (recordStatus == ACTIVE ||
                    recordStatus == ALL ||
                    recordStatus == APPROVED ||
                    recordStatus == DRAFT ||
                    recordStatus == EXPIRED ||
                    recordStatus == REJECTED ||
                    recordStatus == OTCREJECTED);
        }
    }

    public Boolean isExtendable {
        get {
            return  renderPcs != null && renderPcs && !mktpbwired &&
                   (recordStatus == ACTIVE ||
                    recordStatus == APPROVED ||
                    recordStatus == EXPIRED);
        }
    }

    public Boolean isSubmittable {
        get {
            return  renderPcs != null && renderPcs &&
                   (recordStatus == DRAFT ||
                    recordStatus == REJECTED ||
                    recordStatus == OTCREJECTED);
        }
    }

    public Boolean isDefaultLayout {
        get {
            return !(isAafiLayout || isAhwtLayout || isApmLayout);
            //return false; // for testing only
        }
    }

    public Boolean isAafiLayout {
        get {
            return ACC_REC_TYPES_AAFI.contains(accountRecordType);
            //return true; // for testing only
        }
    }

    public Boolean isAhwtLayout {
        get {
            return ACC_REC_TYPES_AHWT.contains(accountRecordType);
            //return false; // for testing only
        }
    }

    public Boolean isApmLayout {
        get {
            return ACC_REC_TYPES_PM.contains(accountRecordType);
            //return true; // for testing only
        }
    }

    private Boolean validateUserComments() {
        if (userComments == null || userComments.trim().length() == 0) {
            addErrMsg('Comments are required'); return false;
        }
        return true;
    }

    private Boolean validateExtendToDate() {
        if (pc.Valid_To_Date__c == null) {
            addErrMsg('ExtendToDate is required'); return false;
        }
        Date tdate = Date.today();
        Integer d = tdate.daysBetween(pc.Valid_To_Date__c);
        if (d < 0) {
            addErrMsg('Invalid ExtendToDate'); return false;
        }
        return true;
    }

    public PageReference gotoExtendPage2() {
        if (inactiveAccount) {return inactiveAccountMsg();}
        Boolean b1 = validateExtendToDate();
        Boolean b2 = validateUserComments();
        disableSubmit = !(b1 && b2);
        return Page.PricingConditionExtendPage2;
    }

    public PageReference gotoExpirePage2() {
        debug('gotoExpirePage2');
        Boolean b2 = validateUserComments();
        disableSubmit = !(b2);
        return Page.PricingConditionExpirePage2;
    }

    public PageReference gotoDeletePage2() {
        return Page.PricingConditionDeletePage2;
    }

    public PageReference getPageRef(String url) {
        return new PageReference(url);
    }

    public PageReference gotoAccountDetails() {
        init();
        return getPageRef(accDetailsUrl);
    }

    public PageReference gotoListPage1() {
        setStandardSetController();
        return getPageRef(pcListPageUrl);
    }

    public PageReference gotoAddNewPage() {
        if (inactiveAccount) {return inactiveAccountMsg();}
        return ADD_PAGE1;
    }

    public PageReference gotoNewContractPage() {
        return NEW_CONTRACT_PAGE;
    }

    public List<Pricing_Condition> getSelectedPricingConditions() {
        debug('getSelectedPricingConditions');
        slist = PricingConditionFunctions.getSelectedPricingConditions(plist);
        debug('getSelectedPricingConditions : slist = ' + slist);
        return slist;
    }

    public void setExtendablePCs() {
        if (extendJobSubmitted != null && extendJobSubmitted) {return;}
        slist = PricingConditionFunctions.getSelectedPricingConditions(plist);
        debug('setExtendablePCs : slist = ' + slist);
        disableSubmit = false;
        if (slist == null || slist.isEmpty()) {
            disableSubmit = true; return;
        }
        Integer extendableCount = PricingConditionListFunctions.setExtendableFlag(
                                                  acc, pc.Valid_To_Date__c, slist);
        if (extendableCount > 0) {
            if (isAAFI || isAHWT_EMEA) {setRenderExtendAtSoldTo();}
        } else {extendJobSubmitted = true;}
    }

    private void setRenderExtendAtSoldTo() {
        renderExtendAtSoldTo = false; Pricing_Condition__c pcc; String s;
        Boolean b = false; pc.Active__c = false;
        for (Pricing_Condition p : slist) {
            pcc = p.pricingCondition;
            s = pcc.Account_Level_Condition_Applies_To__c;
            if (s != null && s.equals(SHIPTO)) {
                b = true; break;
            }
        }
        if (b) {
            Id soldToId = Account_Partner_Functions.getSoldToId(accountId);
            if (soldToId != null && soldToId == accountId) {renderExtendAtSoldTo = true;}
        }
    }

    private void extendAndSubmitForApproval() {
        try {
            PricingConditionListFunctions.extendAndSubmitForApproval(pc.Active__c, pc.Valid_To_Date__c,
                                                                     userComments, slist);
        } catch(Exception e) {addErrMsg(e.getMessage());}
    }

    public void submitForApproval() {
        Set<String> oids = getSelectedIds(); if (oids.isEmpty()) {return;}
        userComments = 'Submitting Pricing Condition for Approval.';
        try {
            Custom_Approval_Functions.submitForApproval(oids, userComments);
            setStandardSetController();
            addInfoMsg('Selected PCNs were submitted for Approval');
        } catch(Exception e) {addErrMsg(e.getMessage());}
    }

    public PageReference submitExtendBatchJob() {
        String jobId;
        try {
            jobId = PricingConditionListFunctions.submitExtendBatchJob(accountId, pc.Active__c,
                                                                       pc.Valid_To_Date__c, userComments, slist);
            if (jobId == null) {return null;}
            addInfoMsg('Your request is in progress. You will be notified by email when it completes.');
        } catch(Exception e) {
            addErrMsg(e.getMessage());
        }
        return null;
    }

    public void activatePricingConditions() {
        PricingConditionActivationFunctions.activatePricingConditions(pcs);
        rsparam = ACTV; changeRecordStatus();
    }

    public PageReference extendPricingConditions() {
        extendJobSubmitted = true;
        debug('slist : ' + slist);
        slist = PricingConditionListFunctions.getExtendablePricingConditions(slist);
        if (slist == null || slist.isEmpty()) {return null;}
        return submitExtendBatchJob();
    }

    public PageReference expirePricingConditions() {
        try {
            PricingConditionListFunctions.expirePricingConditions(userComments, slist);
        } catch(Exception e) {
            addErrMsg(e.getMessage());
        }
        return gotoListPage1();
    }

    public PageReference deletePricingConditions() {
        try {
            PricingConditionListFunctions.deletePricingConditions(slist);
        } catch(Exception e) {
            addErrMsg(e.getMessage());
        }
        return gotoListPage1();
    }

    public PageReference copyPricingConditions() {
        if (isNull(accountId)) {return null;}
        String s = COPY_URL1 + '?fid=' + accountId;
        return new PageReference(s);
    }

}