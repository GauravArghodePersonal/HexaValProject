public class IRF_Controller {



    private static final Integer    PAGE_SIZE1 = 200;
    private static final Integer    PAGE_SIZE2 = 80;
    private static final Integer    PAGE_SIZE3 = 80;

    private static final Integer    MAT_LIMIT1 = 2; // limit of New monthly materials

    private static final String          DELIM = '-';
    private static final String    IRF_PAGE_1A = '/apex/IRF_Page_1A';
    private static final String    IRF_PAGE_2A = '/apex/IRF_Page_2A';
    private static final String    IRF_PAGE_2A_fix = '/apex/IRF_Page_2A_view_fix';
    private static final String    IRF_PAGE_3A = '/apex/IRF_Page_3A';
    private static final String    IRF_PAGE_4A = '/apex/IRF_Page_4A';

    private static final String          DRAFT = IRF_Functions.IRF_STAT_DRAFT;
    private static final String       APPROVED = IRF_Functions.IMD_STAT_APPROVED;
    private static final String       REJECTED = IRF_Functions.IMD_STAT_REJECTED;

    private static final String        CT_ZCCC = IRF_Functions.CT_ZCCC_VAL;
    private static final String        CT_ZPCC = IRF_Functions.CT_ZPCC_VAL;
    private static final String        CT_ZPNC = IRF_Functions.CT_ZPNC_VAL;
    private static final String        CT_ZTCC = IRF_Functions.CT_ZTCC_VAL;
    private static final String		   CT_ZTNC = IRF_Functions.CT_ZTNC_VAL; // added vishnu 2

    private static final String    OPT_VAL_NO  = IRF_Functions.OPT_VAL_NO;
    private static final String    OPT_VAL_YES = IRF_Functions.OPT_VAL_YES;

    private static final String       LBL_TOTL = IRF_Functions.LBL_TOTL;
    private static final String        SC_HILI = IRF_Functions.SC_HILI;
    private static final String        SC_HIL2 = IRF_Functions.SC_HIL2;
    private static final String        SC_REQD = IRF_Functions.SC_REQD;
    private static final String        SC_TOTL = IRF_Functions.SC_TOTL;

    private static final String       SDT_ZCCF = IRF_Functions.SDT_ZCCF;
    private static final String       SDT_ZCCR = IRF_Functions.SDT_ZCCR;

    private static final Set<String>  SORGS_LB = IRF_Functions.SORGS_LB;

    private static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    private static final ApexPages.Severity INFO  = ApexPages.Severity.INFO;
    private static final ApexPages.Severity WARN  = ApexPages.Severity.WARNING;

    public static final String PARAM_OBJID = 'Id';
    public static final String PARAM_ACCID = 'accId';
    public static final String PARAM_IRFID = 'irfId';
    public static final String PARAM_IRFNM = 'irfNm';
    public static final String PARAM_MATID = 'matId';
    public static final String PARAM_UNTID = 'untId';
    public static final String PARAM_IMDID = 'imdId';
    public static final String PARAM_IMDNM = 'imdNm';
    public static final String PARAM_IMMID = 'immId';
    public static final String PARAM_IMUID = 'imuId';
    public static final String PARAM_VTYPE = 'vtype';

    public Map<String, String>        params {get; private set;}

    public IRF_Class                   m_hdr {get; private set;} // master header

    public IRF_Monthly_Data            d_hdr {get; private set;} // monthly header

    public List<IRF_Material>           mats {get; private set;}
    public List<IRF_Material>         m_mats {get; private set;}
    public List<IRF_Unit>             m_unts {get; private set;}

    public List<IRF_Monthly_Material> d_mats {get; private set;}
    public List<IRF_Monthly_Unit>     d_unts {get; private set;}

    public List<IRF_Material>         dlvrys {get; private set;}

    public List<SelectOption>   contractOpts {get; private set;}
    public List<SelectOption>   currencyOpts {get; private set;}
    public List<SelectOption>    imdStatOpts {get; private set;}
    public List<SelectOption>    irfStatOpts {get; private set;}
    public List<SelectOption>        uomOpts {get; private set;}
    public List<SelectOption>         ynOpts {get; private set;}

    public Account                       acc {get; private set;}
    public Account                    soldTo {get; private set;}

    public PaginationController          pc1 {get; private set;}
    public PaginationController          pc2 {get; private set;}
    public PaginationController          pc3 {get; private set;}
    public PaginationController          pc4 {get; private set;}
    public PaginationController          pc5 {get; private set;}
    public PaginationController          pc6 {get; private set;}
    public PaginationController          pc7 {get; private set;}

    public Boolean             activeAccount {get; private set;}
    public Boolean                isDraftIrf {get; private set;}
    public Boolean               isEditable1 {get; private set;}
    public Boolean               isEditable2 {get; private set;}
    public Boolean               isEditable3 {get; private set;}
    public Boolean               isEditable4 {get; private set;}

    public Boolean               renderImdOP {get; private set;}
    public Boolean               renderIrfOP {get; private set;}
    public Boolean               renderMatOP {get; private set;}
    public Boolean               renderSodOP {get; private set;}

    public Boolean          renderBatchesCol {get; private set;}
    public Boolean          renderRvnueAlloc {get; private set;}

    public Boolean            renderSrchMats {get; private set;}
    public Boolean             renderImdList {get; private set;}
    public Boolean             renderMatList {get; private set;}
    public Boolean             renderUntList {get; private set;}
    public Boolean             renderSodList {get; private set;}

    public Boolean           renderDelIrfBtn {get; private set;}
    public Boolean           renderDelImdBtn {get; private set;}

    public Boolean             renderEditBtn {get; private set;}
    public Boolean             renderSaveBtn {get; private set;}
    public Boolean             renderSubmBtn {get; private set;}
    public Boolean          renderAddImdsBtn {get; private set;}

    public Boolean         renderAddMats1Btn {get; private set;}
    public Boolean         renderAddMats2Btn {get; private set;}

    public Boolean         renderAddUnts1Btn {get; private set;}
    public Boolean         renderAddUnts2Btn {get; private set;}
    public Boolean         renderImdAprvlBtn {get; private set;}
    public Boolean         renderSetDraftBtn {get; private set;}

    public Boolean              contractZCCC {get; private set;}
    public Boolean              contractZPNC {get; private set;}
    public Boolean              contractZPCC {get; private set;}//added vishnu
    public Boolean				contractZTNC {get; private set;}// added vishnu 2

    public Boolean               contractGrp {get; private set;}
    public Boolean               hideMatsMFD {get; private set;}
    public Boolean               hideUntsMFD {get; private set;}
    public Boolean               hideMatsMFDedit {get; private set;}
    public Boolean               sortMatsVar = false;
    public Boolean               sortUntsVar = false;
    public Boolean               hideMFD {get; private set;}
    public Boolean               hideMFDIMD {get; private set;}
    public Boolean               hideMFDUnit {get; private set;}
    public Boolean               hideMFDUnitIMD {get; private set;}

    public Boolean                  validImd {get; private set;}

    public String                      accId {get; private set;}
    public String                      imdId {get; private set;}
    public String                      imdNm {get; private set;}
    public String                      immId {get; private set;}
    public String                      imuId {get; private set;}
    public String                      irfId {get; private set;}
    public String                      irfNm {get; private set;}
    public String                      matId {get; private set;}
    public String                      untId {get; private set;}
    public String                      vtype {get; private set;}
    public String                contractLbl {get; private set;}
    public String                 userLocale {get; private set;}
    public String                  matMfdLbl {get; private set;}
    public String                  untMfdLbl {get; private set;}
    public String                  volumeLbl {get; private set;}
    public String                  weightLbl {get; private set;}
    public String				   priceLbl  {get; private set;} //added by vishnu
    public String                   dlvryLbl {get; private set;}
    public String                  deleteMsg {get; private set;}

    public        IRF_Monthly_Material t_mat {get; private set;}
    public            IRF_Monthly_Unit t_unt {get; private set;}

    public Boolean                   allImds {get; set;}
    public Boolean                   allMats {get; set;}
    public Boolean                   allUnts {get; set;}
    public Integer                 pageSize1 {get; set;}
    public Integer                 pageSize2 {get; set;}
    public Integer                 pageSize3 {get; set;}
    public Integer                 pageSize6 {get; set;}
    public Integer                 pageSize7 {get; set;}
    public String              matSrchString {get; set;}
    public String               userComments {get; set;}

    private Boolean              isImd, isAprvdImd, isDraftImd, isEMEA, isNewImd, isNewIrf,
                                 standardPage, validPeriod;
    private Set<String>          selectedMatIds, mfdMatIds, mfdUntIds, newImdMatIds, mfdImdMatIds;
    private SObject              sobj;
    private String               retUrl, sobjId, shipToNum, soldToNum;

    private IRF_Settings__c      irfSettings = IRF_Settings__c.getInstance();

    private Map<String, Double>  unt_amts = new Map<String, Double>();

    public List<IRF_Monthly_Data> imdList {get; private set;}

    public IRF_Controller() {init(null); hideMatsMFDedit=false;}

    public IRF_Controller(ApexPages.StandardController sc) {init(sc.getRecord()); hideMatsMFDedit=false;}

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'IRF_Controller : ' + s);}

    private void addErrMsg(String s)  {addMsg(ERROR, '<b>' + s + '</b>');}

    private void addReqMsg(String s)  {addMsg(ERROR, 'Required a value for : <b>' + s + '</b>');}

    private void addInfoMsg(String s) {addMsg(INFO,  '<b>' + s + '</b>');}

    private void addWarnMsg(String s) {addMsg(WARN,  '<b>' + s + '</b>');}

    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }
    
    

    private void setRetUrl(String url, String n1, String v1) {
        debug('setRetUrl : url = ' + url + ' : ' + url.indexOf('?'));
        if (String.isBlank(v1)) {return;} retUrl = url;
        if (!String.isBlank(n1)) {
            retUrl += (retUrl.indexOf('?') < 0) ? '?' : '&';
            retUrl += (n1 + '=');
        }
        retUrl +=  v1; debug('setRetUrl : retUrl = ' + retUrl);
    }

    private PageReference getPageRef(String url, String p1) {
        sobjId = sobj != null ? sobj.Id : null;
        if (standardPage && sobjId != null) {return getStdPageRef();}
        return getPageRef(url, p1, sobjId);
    }

    private PageReference getPageRef(String url, String p1, String v1) {
        setRetUrl(url, p1, v1); if (retUrl == null) {retUrl = '/';}
        return new PageReference(retUrl);
    }

    public PageReference gotoRetUrl() {
        debug('gotoRetUrl : retUrl = ' + retUrl); if (retUrl == null) {retUrl = '/';}
        PageReference pr = new PageReference(retUrl); pr.setRedirect(true); return pr;
    }

    private PageReference gotoUrl(String url, String p1, String v1) {
        setRetUrl(url, p1, v1); return gotoRetUrl();
    }

    private PageReference getStdPageRef() {
        PageReference pr = new PageReference('/' + sobjId + '?nooverride=1');
        return pr.setRedirect(true);
    }

    public PageReference gotoImdPage() {
        PageReference pr = getPageRef(IRF_PAGE_2A, PARAM_IRFID, m_hdr.sobj.Id);
        pr.setRedirect(true); return pr;
    }

    private void init(SObject so) {
        sobj = so; debug('init(so) : so = ' + so); debug('irfSettings : ' + irfSettings);
        params       = System.currentPageReference().getParameters();
        contractOpts = IRF_Functions.getContractOpts();
        currencyOpts = CurrencyFunctions.getCurrencyCodes();
        imdStatOpts  = IRF_Functions.getImdStatOpts();
        irfStatOpts  = IRF_Functions.getIrfStatOpts();
        uomOpts      = IRF_Functions.getUomOpts();
        ynOpts       = IRF_Functions.getYnOpts();
        userLocale   = UserInfo.getLocale();
        volumeLbl    = 'Liter'; weightLbl = 'KG'; priceLbl = '€'; //added €
        deleteMsg    = 'Are you sure?';
        contractGrp  = IRF_Functions.isContractTeam() ||
                      (irfSettings != null && irfSettings.Contract_Group__c);
        standardPage = irfSettings != null && irfSettings.Show_Standard_Page__c;
        pageSize1 = PAGE_SIZE1; pageSize2 = PAGE_SIZE2; pageSize3 = PAGE_SIZE3;
        pageSize6 = PAGE_SIZE1; pageSize7 = PAGE_SIZE1;
        allMats = false; allUnts = false; isAprvdImd = false;
        isDraftImd = false; isDraftIrf = false; isEMEA = false;
        isImd = false; isNewImd = false; isNewIrf = false;
        isEditable1 = false; isEditable2 = false;
        isEditable3 = false; isEditable4 = false;
        validImd = false; validPeriod = false;
        renderImdOP = true;  renderIrfOP = true;
        renderMatOP = false; renderSodOP = false;
        renderAddMats1Btn = false; renderAddMats2Btn = false;
        renderAddUnts1Btn = false; renderAddUnts2Btn = false;
        renderAddImdsBtn = false; renderEditBtn = false;
        renderSaveBtn = false; renderSubmBtn = false;
        renderDelIrfBtn = false; renderDelImdBtn = false;
        vtype = null; renderBatchesCol = false; renderRvnueAlloc = false;
        renderImdAprvlBtn = false; renderSetDraftBtn = false;

        selectedMatIds = new Set<String>();
        newImdMatIds = new Set<String>(); mfdImdMatIds = new Set<String>();
        mfdMatIds = new Set<String>(); mfdUntIds = new Set<String>();
        m_hdr = new IRF_Class(); m_mats = new List<IRF_Material>();
        m_unts = new List<IRF_Unit>();

        d_hdr = new IRF_Monthly_Data();
        d_mats = new List<IRF_Monthly_Material>();
        d_unts = new List<IRF_Monthly_Unit>();
        dlvrys = new List<IRF_Material>();
        t_mat = new IRF_Monthly_Material(); t_unt = new IRF_Monthly_Unit();
    }

    private void initParams() {
        params = System.currentPageReference().getParameters();
        retUrl = '/'; debug('params = ' + params);
        sobjId = params.get(PARAM_OBJID); setRetUrl(     retUrl,          '', sobjId);
        accId  = params.get(PARAM_ACCID); setRetUrl(     retUrl,          '', accId);
        irfId  = params.get(PARAM_IRFID); setRetUrl(IRF_PAGE_1A, PARAM_IRFID, irfId);
        matId  = params.get(PARAM_MATID); setRetUrl(IRF_PAGE_1A, PARAM_MATID, matId);
        untId  = params.get(PARAM_UNTID); setRetUrl(IRF_PAGE_1A, PARAM_UNTID, untId);
        imdId  = params.get(PARAM_IMDID); setRetUrl(IRF_PAGE_2A, PARAM_IMDID, imdId);
        immId  = params.get(PARAM_IMMID); setRetUrl(IRF_PAGE_2A, PARAM_IMMID, immId);
        imuId  = params.get(PARAM_IMUID); setRetUrl(IRF_PAGE_2A, PARAM_IMUID, imuId);
        vtype  = params.get(PARAM_VTYPE);
        imdNm  = params.get(PARAM_IMDNM); irfNm  = params.get(PARAM_IRFNM);
    }

    public void initAction1() {
        initParams(); initIrf();
        if (!Test.isRunningTest() && isNewIrf && !contractGrp) {
            addInfoMsg('Not Authorized to Create Invoicing Report Form'); return;
        }
        hideMatsMFD = false; hideUntsMFD = false; setMfdBtnLbls();
        initMats(); initUnts(); initAccount();
        if (String.isBlank(accId)) {return;} initImdList();
        isEditable1 = (acc != null) && isNewIrf;
        isEditable2 = isEditable1; isEditable3 = isEditable1;
        renderAddMats1Btn = true; renderAddUnts1Btn = true; renderEditBtn = !isNewIrf;
        renderDelIrfBtn = irfSettings.Allowed_to_Delete_IRF__c && !isNewIrf;
        if (renderImdList) {
            deleteMsg  = 'All monthly data will be deleted\\n';
            deleteMsg += '       if the Header is deleted.\\n\\n';
            deleteMsg += '             Are you sure?';
        }
        setEditable4(); setRenderMatList(); setRenderUntList(); onContractChange();
    }

    public void initAction2() {
        initParams();
        hideMatsMFD = true; hideUntsMFD = true; isImd = true; setMfdBtnLbls();
        initImd(); initImms(); initImus(); initAccount();
        if (String.isBlank(accId)) {return;}
        isEditable1 = (acc != null) && isNewImd;
        isEditable2 = isEditable1; isEditable3 = isEditable1;
        isAprvdImd = APPROVED.equals(d_hdr.sobj.Status__c);
        renderEditBtn = !isNewImd && (contractGrp || isDraftImd ||
                        REJECTED.equals(d_hdr.sobj.Status__c));
        initSaveBtns();
        renderDelImdBtn = irfSettings.Allowed_to_Delete_IMD__c && !isNewImd;
        renderAddMats1Btn = renderEditBtn;
        setRenderImdAprvlBtn(); setRenderSetDraftBtn(); setEditable4();
        setRenderImmList(); setRenderImuList(); onContractChange();
        if (!isNewImd) {validateImd();}
    }

    public void initAction3() {initAction2();}

    public void initAction4() {initParams();}

    public PageReference initAction5() {
        userComments = ''; allImds = false;
        pc7 = IRF_Functions.getSubmittedImdPC(pageSize7);
        if (pc7 == null) {return Page.PendingApprovals;}
        setImdList(); return null;
    }

    public PageReference initActionIrf() {return getPageRef(IRF_PAGE_1A, PARAM_IRFID);}
    public PageReference initActionMat() {return getPageRef(IRF_PAGE_1A, PARAM_MATID);}
    public PageReference initActionUnt() {return getPageRef(IRF_PAGE_1A, PARAM_UNTID);}

    public PageReference initActionImd() {return getPageRef(IRF_PAGE_2A, PARAM_IMDID);}
    public PageReference initActionImm() {return getPageRef(IRF_PAGE_2A, PARAM_IMMID);}
    public PageReference initActionImmFix() {return getPageRef(IRF_PAGE_2A_fix, PARAM_IMMID);}
    public PageReference initActionImu() {return getPageRef(IRF_PAGE_2A, PARAM_IMUID);}

    public ConfirmDialogParam cdp {get; private set;}

    public Boolean renderConfirmDialogComp {get; private set;}

    public void onConfirmComplete() {
        renderConfirmDialogComp = cdp.renderComp;
    }

    private void initConfirmDialog() {
        cdp = new ConfirmDialogParam();
        cdp.cancelUrl = '/' + accId;
        cdp.warnMsg1 = 'Account is marked for deletion. Continue creating IRF?';
        renderConfirmDialogComp = isNewIrf && cdp.renderComp;
    }

    private void initAccount() {
        if (String.isBlank(accId)) {addErrMsg('Account Info missing'); return;}
        acc = IRF_Functions.getAccount(accId); activeAccount = true;
        if (acc != null && acc.Inactive_Account__c != null && acc.Inactive_Account__c) {
            activeAccount = false; initConfirmDialog();
        }
        if (isNewIrf) {m_hdr.sobj.Units_UOM__c = 'KG';}
        if (SORGS_LB.contains(acc.SAP_Sales_Org__c)) {
            volumeLbl = 'Gallon'; weightLbl = 'LB'; priceLbl = '$';
            if (isNewIrf) {m_hdr.sobj.Units_UOM__c = 'LB';}
        }
        isEMEA = SAP_Queries_Functions.isEUSalesOrg(acc);
        soldTo = Account_Partner_Functions.getSoldTo(accId);
        shipToNum =    acc != null ?    acc.AccountNumber : '';
        soldToNum = soldTo != null ? soldTo.AccountNumber : '';
        m_hdr.setAccounts(acc, soldTo);
    }

    private void initIrf() {
        m_hdr = new IRF_Class();
        if (!String.isBlank(irfId)) {m_hdr = IRF_Functions.getIrfClass1(irfId);} else
        if (!String.isBlank(matId)) {m_hdr = IRF_Functions.getIrfClass2(matId);} else
        if (!String.isBlank(untId)) {m_hdr = IRF_Functions.getIrfClass3(untId);}
        if (m_hdr.sobj != null) {
            if (m_hdr.sobj.Id        != null) {irfId = m_hdr.sobj.Id;}
            if (m_hdr.sobj.ShipTo__c != null) {accId = m_hdr.sobj.ShipTo__c;}
            renderBatchesCol = OPT_VAL_YES.equals(m_hdr.sobj.Batches_Required__c);
            renderAddImdsBtn = IRF_Functions.isIrfReleased(m_hdr.sobj.Status__c);
            System.debug('renderAddImdsBtn>>>>'+renderAddImdsBtn+'>>>>>m_hdr.sobj'+m_hdr.sobj);
        }
        isNewIrf = String.isBlank(irfId);
        if (isNewIrf) {
            m_hdr.sobj.Batches_Required__c = OPT_VAL_NO;
            m_hdr.sobj.Contract_Type__c = CT_ZPCC;
        }
    }

    private void initMats() {
        System.debug('initMats()>>>>');
        //hideUntsMFD = false;
        pc2 = IRF_Functions.getIrfMatPC(irfId, pageSize2, hideUntsMFD, sortMatsVar); if (pc2 == null) {return;}
        setIrfMats(); selectedMatIds = IRF_Functions.getIrfMatIds(irfId);
    }

    private void initUnts() {
    System.debug('initUnts()>>>>');
        pc3 = IRF_Functions.getIrfUntPC(irfId, pageSize3, hideUntsMFD, sortUntsVar);
        if (pc3 == null) {return;} setIrfUnts();
    }

    private void initImdList() {
    System.debug('initImdList()>>>>');
        pc7 = IRF_Functions.getImdPC(irfId, pageSize7); setImdList();
    }

    public void initAddMats() {
    
        renderAddMats1Btn = false; renderAddMats2Btn = true; renderEditBtn = false;
        isEditable2 = true; isEditable4 = true;
        m_mats = new List<IRF_Material>(); searchMaterials();
    }

    public void initAddUnts() {
        renderAddUnts1Btn = false; renderAddUnts2Btn = true; renderEditBtn = false;
        isEditable3 = true;
        m_unts = new List<IRF_Unit>(); addUnits();
    }

    private void initImd() {
    System.debug('initImd()>>>>');
        d_hdr = new IRF_Monthly_Data();
        if (!String.isBlank(irfId)) {d_hdr = IRF_Functions.getIrfMD1(irfId);System.debug('here>>>getIrfMD1');} else
        if (!String.isBlank(imdId)) {d_hdr = IRF_Functions.getIrfMD2(imdId);System.debug('here>>>getIrfMD2');} else
        if (!String.isBlank(immId)) {d_hdr = IRF_Functions.getIrfMD3(immId);System.debug('here>>>getIrfMD3');} else
        if (!String.isBlank(imuId)) {d_hdr = IRF_Functions.getIrfMD4(imuId);System.debug('here>>>getIrfMD4');}
        if (d_hdr.sobj == null) {return;}
        imdId = d_hdr.sobj.Id; irfId = d_hdr.sobj.IRF__c;
        isNewImd = String.isBlank(imdId); isNewIrf = String.isBlank(irfId);
        isDraftImd = !isNewImd && DRAFT.equals(d_hdr.sobj.Status__c);
        if (isNewIrf) {addErrMsg('IRF Info missing'); return;}
        validateImdPeriod(); if (isNewImd && !validPeriod) {return;}
        IRF_Functions.setImdFields1(d_hdr.sobj);
        initIrf(); d_hdr.sobj.IRF__r = m_hdr.sobj; d_hdr.unitsUom = m_hdr.sobj.Units_UOM__c;
        if (isNewImd) {
            d_hdr.sobj.Purchase_Order_Number__c = m_hdr.sobj.Purchase_Order_Number__c;
        }
    }

    private void initImms() {
    System.debug('where - initImms()>>>>');
        renderAddMats1Btn = false; renderAddMats2Btn = false; isEditable4 = false;
        d_mats = new List<IRF_Monthly_Material>(); renderMatList = false;
        hideMFD = true;
        hideMFDIMD = false;
        
        //sortMatsVar = false;
        System.debug('sortMatsVar>>>'+sortMatsVar);
        if (!validPeriod) {return;}
        if (isNewImd || isDraftImd) {
        System.debug('isNewImd or isDraftImd>>>>');
        System.debug('isNewImd >>>>'+isNewImd);
        System.debug('isDraftImd>>>>'+isDraftImd);
            hideMatsMFD = false;
            pc4 = IRF_Functions.getIrfMatPC(irfId, pageSize2, hideMatsMFD, sortMatsVar);
        } else {
            System.debug('sortMatsVar>>>>'+sortMatsVar);
            pc4 = IRF_Functions.getImdMatPC(imdId, pageSize2, hideMatsMFD, sortMatsVar);
        }
        if (pc4 == null) {return;}
        if(isNewImd){
            hideMFD = false;
            hideMFDIMD = true;    
        }
        newImdMatIds = new Set<String>(); mfdImdMatIds = new Set<String>();
        selectedMatIds = IRF_Functions.getIrfMatIds(irfId); setImdMats();
    }

    private void initImus() {
    System.debug('initImus()>>>>');
        d_unts = new List<IRF_Monthly_Unit>(); renderUntList = false;
        hideMFDUnit = true;
        hideMFDUnitIMD = false;
        if (!validPeriod) {return;}
        if (isNewImd || isDraftImd) {
        hideUntsMFD = false;
            pc5 = IRF_Functions.getIrfUntPC(irfId, pageSize3, true, sortUntsVar); // changed hideUntsMFD directly to true vishnu check
        } else {
            pc5 = IRF_Functions.getImdUntPC(imdId, pageSize3, hideUntsMFD, sortUntsVar);
        }
        if (pc5 == null) {return;} setImdUnts();
        if(isNewImd){
            hideMFDUnit = false;
            hideMFDUnitIMD = true;    
        }
    }

    public void initAddImdMats() {
    System.debug('initAddImdMats()>>>>');
        renderAddMats1Btn = false; renderAddMats2Btn = true; renderEditBtn = false;
        isEditable2 = true; isEditable4 = true; validImd = false; initSaveBtns();
        d_mats = new List<IRF_Monthly_Material>();
        if (!isNewImd) {
        System.debug('initAddImdMats>>>');
        d_mats = IRF_Functions.getNewImdMats(d_hdr.sobj);}
        if (d_mats.size() < MAT_LIMIT1) {searchMaterials();} else {
            addInfoMsg('Max number of New Materials allowed is ' + MAT_LIMIT1);
        }
    }

    private void initSaveBtns() {
    System.debug('initSaveBtns()>>>>');
        renderSaveBtn = !renderEditBtn;
        if (isAprvdImd && !contractGrp) {renderSaveBtn = false;}
        renderSubmBtn = renderSaveBtn && !isAprvdImd;
    }

    public PageReference deleteIrf() {
        PageReference pr = new PageReference('/' + accId);
        try {delete m_hdr.sobj; return pr;} catch(Exception e) {
            debug('deleteIrf : ' + e.getMessage());
        }
        return null;
    }

    public PageReference deleteImd() {
        PageReference pr = new PageReference('/' + irfId);
        try {delete d_hdr.sobj; return pr;} catch(Exception e) {
            debug('deleteImd : ' + e.getMessage());
        }
        return null;
    }

    public PageReference setDraftImd() {
        PageReference pr = new PageReference('/' + imdId);
        IRF_Monthly_Data__c d = d_hdr.sobj;
        if (d.Status__c == DRAFT) {return null;}
        Set<String> aset = new Set<String>{imdId};
        String s = 'Per Request to set to Draft';
        Custom_Approval_Functions.recallObjects(aset, s);
        d.Status__c = DRAFT;
        try {update d; return pr;} catch(Exception e) {
            debug('setDraftImd : ' + e.getMessage());
        }
        return null;
    }

    public void setEditable() {
        system.debug('<<<Edit>>>'+ acc);
        isEditable1 = (acc != null); setEditable4();
        isEditable2 = isEditable1; isEditable3 = isEditable1;
        renderAddMats1Btn = false; renderAddMats2Btn = false;
        renderAddUnts1Btn = false; renderAddUnts2Btn = false;
        renderEditBtn = false; renderImdAprvlBtn = false; validImd = false;
        initSaveBtns();
        system.debug('<<<isEditable1 >>>'+ isEditable1 );
        system.debug('<<<isEditable2 >>>'+ isEditable2 );
    }

    private void setEditable4() {
        isDraftIrf = DRAFT.equals(m_hdr.sobj.Status__c);
        isEditable4 = isEditable1 && (isDraftIrf || isDraftImd);
    }

    private void setRenderImdAprvlBtn() {
        renderImdAprvlBtn = false; Boolean b1, b2, b3;
        b1 = !isNewImd; if (!b1) {return;}
        b2 = (irfSettings != null && irfSettings.IMD_Approval_History__c);  if (!b2) {return;}
        b3 = IRF_Functions.imdApprovalHistoryExists(imdId);
        renderImdAprvlBtn = (b1 && b2 && b3);
    }

    private void setRenderSetDraftBtn() {
        renderSetDraftBtn = false; Boolean b1, b2, b3;
        b1 = !isNewImd; if (!b1) {return;}
        b2 = (irfSettings != null && irfSettings.Allowed_to_Set_to_Draft__c);  if (!b2) {return;}
        b3 = !isDraftImd; if (!b3) {return;}
        renderSetDraftBtn = (b1 && b2 && b3);
    }

    private void setRenderImdList() {
        renderImdList = imdList != null && !imdList.isEmpty();
    }

    private void setRenderImmList() {
        renderMatList = d_mats != null && !d_mats.isEmpty();
    }

    private void setRenderImuList() {
        renderUntList = d_unts != null && !d_unts.isEmpty();
    }

    private void setRenderMatList() {
        renderMatList = m_mats != null && !m_mats.isEmpty();
    }

    private void setRenderUntList() {
        renderUntList = m_unts != null && !m_unts.isEmpty();
    }

    private void setRenderSodList() {
        renderSodList = dlvrys != null && !dlvrys.isEmpty();
    }

    private void setMfdBtnLbls() {
        matMfdLbl = hideMatsMFD ? 'Show Materials MFD' : 'Hide Materials MFD';
        untMfdLbl = hideUntsMFD ? 'Show Units MFD'     : 'Hide Units MFD';
       // matMfdLbl = hideMatsMFDedit? 'Hide Materials' : 'MFD Show Materials MFD';

        
    }
    private void setMfdBtnLblsedit() {       
       matMfdLbl = hideMatsMFDedit? 'Hide Materials MFD' : 'Show Materials MFD';        
    }

    private void setPrevPeriodData() {IRF_Functions.setPrevPeriodData(d_hdr);}

    public void onBatchReqChange() {}

    public void onContractChange() {
        contractZPNC = CT_ZPNC.equals(m_hdr.sobj.Contract_Type__c);
        contractZCCC = CT_ZCCC.equals(m_hdr.sobj.Contract_Type__c);
        contractZPCC = CT_ZPCC.equals(m_hdr.sobj.Contract_Type__c);//added vishnu
        contractZTNC = CT_ZTNC.equals(m_hdr.sobj.Contract_Type__c);// added vishnu 2
        contractLbl = IRF_Functions.getSOptLbl(contractOpts, m_hdr.sobj.Contract_Type__c);
        renderRvnueAlloc = (CT_ZPCC.equals(m_hdr.sobj.Contract_Type__c) ||
                            CT_ZTCC.equals(m_hdr.sobj.Contract_Type__c)) && isEMEA;
    }

    public void onCurrencyChange() {}

    public void onImdStatChange() {}

    public void onIrfStatChange() {setEditable4();}

    public void onSiteOper1Change() {}

    public void onSiteOper2Change() {}

    public void onDateChange() {validateImdPeriod(true);}

    public void onUomChange() {}

    public void showHideMatsMFD() {hideMatsMFD = !hideMatsMFD; setMfdBtnLbls(); initImms();}
    public void showHideMatsMFDedit() {hideMatsMFDedit = !hideMatsMFDedit; setMfdBtnLblsedit();}
     
    public void sortMats() {sortMatsVar = !sortMatsVar; initImms();}
    
    public void sortUnts() {sortUntsVar = !sortUntsVar; initImus();}

    public void showHideUntsMFD() {hideUntsMFD = !hideUntsMFD; setMfdBtnLbls(); initImus();}

    public void showIRF() {
        renderIrfOP = true; renderMatOP = false;
        if (m_mats == null || m_mats.isEmpty()) {
            setIrfMats(); setEditable4();
            renderAddMats1Btn = isEditable1; renderAddMats2Btn = false;
        }
        setRenderMatList();
    }
// --------------------------------------------------------------------------------------------------------------
    public void searchMaterials() {
        allMats = false;
        pc1 = IRF_Functions.getMsd2PC(acc, matSrchString, pageSize1);
        if (pc1 == null) {return;}
        renderIrfOP = false; renderImdOP = false; renderMatOP = true; setMats();
    }

    public void selectMaterials() {
        allMats = false; setRenderMatList();
        List<Material_Sales_Data2__c> msd2s = new List<Material_Sales_Data2__c>();
        for (IRF_Material m : mats) {
            if (m.selected) {
                selectedMatIds.add(m.matId); msd2s.add(m.msd2);
                m.selected = false;
            }
            setStyleClass(m);
        }
        if (msd2s.isEmpty()) {return;}
        List<IRF_Material> mlist = IRF_Functions.getIrfMaterials(acc, soldToNum, msd2s);
        Integer n = m_mats.size() + 1; Date d = Date.today();
        for (IRF_Material m : mlist) {
            //m.sobj.Effective_Date__c = d;
            m.recNum = n++; m_mats.add(m);
        }
    }

    public void selectMaterialsAndReturn() {
        selectMaterials();  showIRF();
    }

    public void selectMats() {
        allMats = false; Integer n = d_mats.size(); setRenderImmList();
        if (n >= MAT_LIMIT1) {return;}
        List<Material_Sales_Data2__c> msd2s = new List<Material_Sales_Data2__c>();
        for (IRF_Material m : mats) {
            if (!m.selected) {continue;}
            n++; if (n > MAT_LIMIT1) {break;}
            newImdMatIds.add(m.matId); msd2s.add(m.msd2);
            setStyleClass(m);
        }
        if (msd2s.isEmpty()) {return;}
        List<IRF_Material> mlist = IRF_Functions.getIrfMaterials(acc, soldToNum, msd2s);
        n = d_mats.size() + 1; SObject so; IRF_Monthly_Material imm;
        for (IRF_Material m : mlist) {
            so = m.sobj; imm = new IRF_Monthly_Material(d_hdr.sobj, so, n++); d_mats.add(imm);
        }
    }

    public void selectMatsAndReturn() {
        selectMats();
        IRF_Functions.setPrevPeriodData(d_hdr, d_mats);
        IRF_Functions.setOrdrDelvryData(d_hdr, d_mats);
        showIMD();
    }

    private void setStyleClass(IRF_Material m) {
        m.styleClass = '';
        if (selectedMatIds.contains(m.matId) || newImdMatIds.contains(m.matId)) {
            m.styleClass = 'boldblue'; m.disabled = isImd;
            if (m.disabled) {m.styleClass = 'boldgrey';}
        }
    }

    public void pc1Size() {setMats(null);}
    public void pc1Frst() {setMats(PaginationController.Page.FIRST);}
    public void pc1Prev() {setMats(PaginationController.Page.PREV);}
    public void pc1Next() {setMats(PaginationController.Page.NEXT);}
    public void pc1Last() {setMats(PaginationController.Page.LAST);}

    private void setMats() {setMats(null);}

    private void setMats(PaginationController.Page p) {
        renderSrchMats = false; mats = new List<IRF_Material>();
        List<Material_Sales_Data2__c> mlist = null; Integer n = 0;
        if (pc1 != null) {
            pc1.gotoPage(p); n = pc1.recordFrom;
            mlist = pc1.getRecords(); pageSize1 = pc1.getPageSize();
        }
        if (mlist == null || mlist.isEmpty()) {return;}
        IRF_Material mat;
        for (Material_Sales_Data2__c m : mlist) {
            mat = new IRF_Material(m, n++); setStyleClass(mat);
            mats.add(mat);
        }
        renderSrchMats = !mats.isEmpty();
    }
// --------------------------------------------------------------------------------------------------------------
    public void pc2Size() {setIrfMats(null);}
    public void pc2Frst() {setIrfMats(PaginationController.Page.FIRST);}
    public void pc2Prev() {setIrfMats(PaginationController.Page.PREV);}
    public void pc2Next() {setIrfMats(PaginationController.Page.NEXT);}
    public void pc2Last() {setIrfMats(PaginationController.Page.LAST);}

    private void setIrfMats() {setIrfMats(null);}

    private void setIrfMats(PaginationController.Page p) {
        m_mats = new List<IRF_Material>(); renderMatList = false;
        List<IRF_Material__c> mlist = null; Integer n = 0;
        if (pc2 != null) {
            pc2.gotoPage(p); n = pc2.recordFrom;
            mlist = pc2.getRecords(); pageSize2 = pc2.getPageSize();
        }
        if (mlist == null || mlist.isEmpty()) {return;}
        for (IRF_Material__c m : mlist) {
            m_mats.add(new IRF_Material(m, n++));
        }
        setRenderMatList();
    }

    public void deleteMaterials() {
        List<IRF_Material> temp = new List<IRF_Material>();
        selectedMatIds = new Set<String>();
        for (IRF_Material m : m_mats) {
            if (m.selected) {
                if (m.sobj != null && m.sobj.Id != null) {mfdMatIds.add(m.sobj.Id);}
            } else {temp.add(m); selectedMatIds.add(m.matId);}
        }
        m_mats = temp; allMats = false; setRenderMatList();
    }
    
    public void undeleteMaterials() {
        IRF_Material__c m;
        for (IRF_Material mm : m_mats) {
            if (mm.selected) {
                mm.selected = false; m = mm.sobj;
                if (m != null && m.MFD__c != null && m.MFD__c) {
                    m.MFD__c = false;
                    //m.Undeletion_Date__c = system.now();
                    //m.Marked_for_deletion_Date__c = NULL;
                }
            } 
        }
        allMats = false;
    }
// --------------------------------------------------------------------------------------------------------------
    public void pc3Size() {setIrfUnts(null);}
    public void pc3Frst() {setIrfUnts(PaginationController.Page.FIRST);}
    public void pc3Prev() {setIrfUnts(PaginationController.Page.PREV);}
    public void pc3Next() {setIrfUnts(PaginationController.Page.NEXT);}
    public void pc3Last() {setIrfUnts(PaginationController.Page.LAST);}

    private void setIrfUnts() {setIrfUnts(null);}
    
    private void setIrfUnts(PaginationController.Page p) {
        m_unts = new List<IRF_Unit>(); renderUntList = false;
        List<IRF_Unit__c> ulist = null; Integer n = 0;
        if (pc3 != null) {
            pc3.gotoPage(p); n = pc3.recordFrom;
            ulist = pc3.getRecords(); pageSize3 = pc3.getPageSize();
        }
        if (ulist == null || ulist.isEmpty()) {return;}
        Integer count = 0;//added
        for (IRF_Unit__c u : ulist) {
            if(u.MFD__c == false)//added vishnu
            	{	count ++;
                    m_unts.add(new IRF_Unit(u, n++, count));
                }
            else{
            	m_unts.add(new IRF_Unit(u, n++, null));
            }
        }
        setRenderUntList();
    }

    public void addUnits() {
        allUnts = false; Integer n = m_unts.size() + 1;
        IRF_Unit__c u; IRF_Unit t; Date d = Date.today();
        for (Integer i = 0; i < 1; i++) {
            u = new IRF_Unit__c(); //u.Effective_Date__c = d; 
            t = new IRF_Unit(new IRF_Unit__c(), n++, null);
            m_unts.add(t);
        }
        setRenderUntList();
    }

    public void deleteUnits() {
        List<IRF_Unit> temp = new List<IRF_Unit>();
        for (IRF_Unit u : m_unts) {
            if (u.selected) {
                if (u.sobj != null && u.sobj.Id != null) {mfdUntIds.add(u.sobj.Id);}
            } else {temp.add(u);}
        }
        m_unts = temp; allUnts = false; setRenderUntList();
    }

    public void undeleteUnits() {
        IRF_Unit__c u;
        for (IRF_Unit uu : m_unts) {
            if (uu.selected) {
                uu.selected = false; u = uu.sobj; 
                if (u != null && u.MFD__c != null && u.MFD__c) {
                    u.MFD__c = false;
                    //u.Undeletion_Date__c = system.now();
                    //u.Marked_for_deletion_Date__c = NULL;
                }
            }
        }
        allUnts = false;
    }
// --------------------------------------------------------------------------------------------------------------
    private Boolean validateMhdr() {
        Invoicing_Report_Form__c f = m_hdr.sobj;
        Boolean b1 = true, b2 = true; String s = 'IRF : '; m_hdr.scPoNum = '';

         b1 = !String.isBlank(f.Contract_Number__c);
         if(b1){
            b1 = f.Contract_Number__c.length()!=10?false:true;
        }
        if(!b1) {b2 = false; m_hdr.scSapcn = SC_HILI; addReqMsg(s + 'SAP Contract Number should be 10 digit (eg 0040012345)');}
        
        if(!String.isBlank(f.Previous_Contract_Number__c) ){
            if(f.Previous_Contract_Number__c.length()!=10){
                 b2 = false;
                 m_hdr.scSapcn = SC_HILI;
                 addReqMsg(s + 'Previous Contract Number should be 10 digit (eg 0040012345)');
             }
        }

        b1 = !String.isBlank(f.Currency_for_Invoicing__c);
        if(!b1) {b2 = false; addReqMsg(s + 'Currency for');}

        b1 = !String.isBlank(f.Contract_Type__c);
        if(!b1) {b2 = false; addReqMsg(s + 'SAP Contract Type');}

        b1 = !String.isBlank(f.Units_UOM__c);
        if(!b1) {b2 = false; addReqMsg(s + 'Units (UoM)');}

        b1 = !String.isBlank(f.Batches_Required__c);
        if(!b1) {b2 = false; addReqMsg(s + 'Batches Required');}

        b1 = !f.PO_for_Billing_Period__c ||
             (f.PO_for_Billing_Period__c && !String.isBlank(f.Purchase_Order_Number__c));
        if(!b1) {b2 = false; m_hdr.scPoNum = SC_HILI; addReqMsg(s + 'Purchase Order Number');}

        if (!contractZPNC) {
            b1 = !m_mats.isEmpty();
            if(!b1) {b2 = false; addErrMsg(s + 'At least one Material Required');}
        }

        if (!contractZCCC) {
            b1 = !m_unts.isEmpty();
            if(!b1) {b2 = false; addErrMsg(s + 'At least one Unit Required');}
        }

        //if(!b2) {addErrMsg(s + '.');}
        return b2;
    }

    private Boolean validate(IRF_Material a, Integer n) {
        a.scBegnv = ''; a.scDiscp = ''; a.scEdate = ''; a.scEstqt = ''; a.scPrice = ''; a.scRvnap = '';
        IRF_Material__c m = a.sobj; String s = 'Material ' + n + ' : ';
        Boolean b1 = true, b2 = true; if (m.MFD__c) {return b2;}
        b1 = (m.Beginning_Inventory__c != null);
        if(!b1) {b2 = false; a.scBegnv = SC_HILI; addReqMsg(s + 'Beginning Inventory');}

        if (contractZCCC) {
            b1 = (m.Effective_Date__c != null);
            if(!b1) {b2 = false; a.scEdate = SC_HILI; addReqMsg(s + 'Effective Date');}

            b1 = (m.Price__c != null);
            if(!b1) {b2 = false; a.scPrice = SC_HILI; addReqMsg(s + 'Price');} else {
                b1 = (m.Price__c >= 0);
                if(!b1) {b2 = false; a.scPrice = SC_HILI; addErrMsg(s + 'Price cannot be negative');}
            }

            /*
            b1 = (m.Discount_Percent__c == null ||
                (m.Discount_Percent__c >= 0 && m.Discount_Percent__c <= 100.0));
            if(!b1) {b2 = false; a.scDiscp = SC_HILI;
            addErrMsg(s + 'Discount Percent valid range is 0 to 100');}
            */
        }

        if (renderRvnueAlloc) {
            b1 = (m.Revenue_Allocation__c == null ||
                 (m.Revenue_Allocation__c >= 0 && m.Revenue_Allocation__c <= 100.0));
            if(!b1) {b2 = false; a.scRvnap = SC_HILI;
            addErrMsg(s + 'Revenue Allocation Percent valid range is 0 to 100');}
        }

        b1 = (m.Estimated_Quantity__c != null);
        if(!b1) {b2 = false; a.scEstqt = SC_HILI; addReqMsg(s + 'Estimated Quantity');}

        //if(!b2) {addErrMsg(s + '.');}
        return b2;
    }

    private Boolean validate(IRF_Unit a, Integer n) {
        IRF_Unit__c u = a.sobj; Boolean b1 = true, b2 = true; String s = 'Unit ' + n + ' : ';
        a.scEdate = ''; a.scPrice = ''; a.scUdesc = ''; a.scExpectedproduction = ''; //Added by Vishnu
        if (u.MFD__c) {return b2;}
        b1 = !String.isBlank(u.Description__c);
        if(!b1) {b2 = false; a.scUdesc = SC_HILI; addReqMsg(s + 'Unit Description');}

        b1 = (u.Effective_Date__c != null);
        if(!b1) {b2 = false; a.scEdate = SC_HILI; addReqMsg(s + 'Effective Date');}

        b1 = (u.Price__c          != null);
        if(!b1) {b2 = false; a.scPrice = SC_HILI; addReqMsg(s + 'Price per Unit');}
          
        if (contractZPCC) {
        b1 = (u.Expected_production__c != null);
        if(!b1) {b2 = false; a.scExpectedproduction = SC_HILI; addReqMsg(s + 'Expected production per Unit');}  //Added by Vishnu 
         }
        //if(!b2) {addErrMsg(s + '.');}
        return b2;
    }

    private Boolean validateIrf() {
        Invoicing_Report_Form__c f = m_hdr.sobj;
        f.currencyIsoCode = f.Currency_for_Invoicing__c;
        Boolean b1 = true, b2 = true; Integer n;
        b1 = validateMhdr(); if (!b1) {b2 = false;}
       // if (!contractZPNC) {
            n = 1;
            for (IRF_Material m : m_mats) {
                b1 = validate(m, n++); if (!b1) {b2 = false;}
                m.sobj.currencyIsoCode = f.currencyIsoCode;
            }
       // }
        if (!contractZCCC) {
            n = 1;
            for (IRF_Unit u : m_unts) {
                b1 = validate(u, n++); if (!b1) {b2 = false;}
                u.sobj.currencyIsoCode = f.currencyIsoCode;
            }
        }
        return b2;
    }



    public PageReference saveIrf() {
        if (!validateIrf()) {return null;} String s = '';
        s = IRF_Functions.saveIrf(m_hdr, m_mats, m_unts, mfdMatIds, mfdUntIds);
        if (String.isBlank(s)) {return gotoUrl(IRF_PAGE_1A, PARAM_IRFID, m_hdr.sobj.Id);}
        else {addErrMsg('Save Failed : ' + s);} return null;
    }

// --------------------------------------------------------------------------------------------------------------
    public void showIMD() {
        renderImdOP = true; renderMatOP = false; renderSodOP = false;
        setRenderImmList();
    }

    public void showAdjstdInvs() {showSOD(SDT_ZCCR); dlvryLbl = 'Adjusted Inventory';}

    public void showRecevdInvs() {showSOD(SDT_ZCCF); dlvryLbl = 'Received Inventory';}

    private void showSOD(String ordrType) {
        pc6 = IRF_Functions.getDeliveriesPC(d_hdr, d_mats, ordrType, pageSize6);
        if (pc6 == null) {return;} setDlvrys();
    }
// --------------------------------------------------------------------------------------------------------------
    public void pc4Size() {setImdMats(null);}
    public void pc4Frst() {setImdMats(PaginationController.Page.FIRST);}
    public void pc4Prev() {setImdMats(PaginationController.Page.PREV);}
    public void pc4Next() {setImdMats(PaginationController.Page.NEXT);}
    public void pc4Last() {setImdMats(PaginationController.Page.LAST);}

    private void setImdMats() {setImdMats(null);}

    private void setImdMats(PaginationController.Page p) {
        System.debug('IMM ini>>');
        d_mats = new List<IRF_Monthly_Material>(); renderMatList = false;
        t_mat = new IRF_Monthly_Material(); t_mat.styleClass = SC_TOTL;
        t_mat.matNum = LBL_TOTL;
        List<SObject> sobjs = null; Integer n = 0;
        if (!validPeriod) {return;}
        if (pc4 != null) {
            pc4.gotoPage(p); n = pc4.recordFrom;
            sobjs = pc4.getRecords(); pageSize2 = pc4.getPageSize();
        }
        if (sobjs == null || sobjs.isEmpty()) {return;}
        System.debug('sobjs - 987>>>'+sobjs);
        Map<String, IRF_Monthly_Material__c> mmap = getImmMap(sobjs);
        System.debug('getImmMap>>>'+mmap);
        IRF_Monthly_Material m;
        for (SObject so : sobjs) {
      if (isDraftImd && mmap.containsKey(so.Id)) 
            {so = mmap.get(so.Id);
               }
         if( !Boolean.valueOf(so.get('MFD__c'))){
            m = new IRF_Monthly_Material(d_hdr.sobj, so, n++);
            d_mats.add(m);    
            }
      }
       if (isDraftImd) {
        system.debug('isDraftImd>>');
        d_mats.addAll(IRF_Functions.getNewImdMats(d_hdr.sobj));
     }
        setRenderImmList(); if (!renderMatList) {return;}
        if (isNewImd || isDraftImd) {
            IRF_Functions.setPrevPeriodData(d_hdr, d_mats);
            IRF_Functions.setOrdrDelvryData(d_hdr, d_mats);
            //IRF_Functions.markForDeletion(d_mats);
            System.debug('isNewImd or isDraftImd');
        }
        IRF_Functions.setImmTotl(d_hdr, d_mats, t_mat); d_mats.add(t_mat);
    }

    private Map<String, IRF_Monthly_Material__c> getImmMap(List<SObject> sobjs) {
        Map<String, IRF_Monthly_Material__c> amap = new Map<String, IRF_Monthly_Material__c>();
        if (!isDraftImd) { system.debug('returning empty map');
        return amap;} Set<String> matIds = new Set<String>();
        for (SObject so : sobjs) {matIds.add(so.Id);}
        System.debug('sobjs in getImmMap>>'+sobjs);
        System.debug('Not Draft IMD>>'+imdId+'<<<Matid'+matIds);
        return IRF_Functions.getImms(imdId, matIds);
    }

    public void deleteImdMats() {
        List<IRF_Monthly_Material> temp = new List<IRF_Monthly_Material>();
        newImdMatIds = new Set<String>();
        for (IRF_Monthly_Material m : d_mats) {
            if (m.selected) {
                if (m.sobj != null && m.sobj.Id != null) {mfdImdMatIds.add(m.sobj.Id);}
            } else {temp.add(m); newImdMatIds.add(m.matId);}
        }
        d_mats = temp; allMats = false; setRenderImmList();
    }
// --------------------------------------------------------------------------------------------------------------
    public void pc5Size() {setImdUnts(null);}
    public void pc5Frst() {setImdUnts(PaginationController.Page.FIRST);}
    public void pc5Prev() {setImdUnts(PaginationController.Page.PREV);}
    public void pc5Next() {setImdUnts(PaginationController.Page.NEXT);}
    public void pc5Last() {setImdUnts(PaginationController.Page.LAST);}

    private void setImdUnts() {setImdUnts(null);}

    private void setImdUnts(PaginationController.Page p) {
        d_unts = new List<IRF_Monthly_Unit>(); renderUntList = false;
        t_unt = new IRF_Monthly_Unit(); t_unt.styleClass = SC_TOTL;
        t_unt.untDesc = LBL_TOTL;
        List<SObject> sobjs = null; Integer n = 0;
        if (!validPeriod) {return;}
        if (pc5 != null) {
            pc5.gotoPage(p); n = pc5.recordFrom;
            sobjs = pc5.getRecords(); pageSize3 = pc5.getPageSize();
        }
        if (sobjs == null || sobjs.isEmpty()) {return;}
        Map<String, IRF_Monthly_Unit__c> umap = getImuMap(sobjs);
        for (SObject so : sobjs) {
            if (isDraftImd && umap.containsKey(so.Id)) {so = umap.get(so.Id);}
            d_unts.add(new IRF_Monthly_Unit(so, n++));
        }
        setRenderImuList();
        //system.debug('the -->#'+ d_unts);
        IRF_Functions.setImuTotl(d_hdr, d_unts, t_unt); d_unts.add(t_unt);
    }

    private Map<String, IRF_Monthly_Unit__c> getImuMap(List<SObject> sobjs) {
        Map<String, IRF_Monthly_Unit__c> umap = new Map<String, IRF_Monthly_Unit__c>();
        if (!isDraftImd) {return umap;} Set<String> untIds = new Set<String>();
        for (SObject so : sobjs) {untIds.add(so.Id);}
        //system.debug('passIMD:'+imdId);
        return IRF_Functions.getImus(imdId, untIds);
    }
// --------------------------------------------------------------------------------------------------------------
    public void pc6Size() {setDlvrys(null);}
    public void pc6Frst() {setDlvrys(PaginationController.Page.FIRST);}
    public void pc6Prev() {setDlvrys(PaginationController.Page.PREV);}
    public void pc6Next() {setDlvrys(PaginationController.Page.NEXT);}
    public void pc6Last() {setDlvrys(PaginationController.Page.LAST);}

    private void setDlvrys() {setDlvrys(null);}

    private void setDlvrys(PaginationController.Page p) {
        dlvrys = new List<IRF_Material>(); renderSodList = false;
        List<Sales_Order_Deliveries__c> sobjs = null; Integer n = 0;
        if (!validPeriod) {return;}
        if (pc6 != null) {
            pc6.gotoPage(p); n = pc6.recordFrom;
            sobjs = pc6.getRecords(); pageSize6 = pc6.getPageSize();
        }
        if (sobjs == null || sobjs.isEmpty()) {return;}
        for (Sales_Order_Deliveries__c so : sobjs) {
            dlvrys.add(new IRF_Material(so, n++));
        }
        setRenderSodList();
        if (renderSodList) {renderImdOP = false; renderSodOP = true;}
    }
// --------------------------------------------------------------------------------------------------------------
    public void pc7Size() {setImdList(null);}
    public void pc7Frst() {setImdList(PaginationController.Page.FIRST);}
    public void pc7Prev() {setImdList(PaginationController.Page.PREV);}
    public void pc7Next() {setImdList(PaginationController.Page.NEXT);}
    public void pc7Last() {setImdList(PaginationController.Page.LAST);}

    private void setImdList() {setImdList(null);}

    private void setImdList(PaginationController.Page p) {
        imdList = new List<IRF_Monthly_Data>(); renderImdList = false;
        List<IRF_Monthly_Data__c> sobjs = null; Integer n = 0;
        if (pc7 != null) {
            pc7.gotoPage(p); n = pc7.recordFrom;
            sobjs = pc7.getRecords(); pageSize7 = pc7.getPageSize();
        }
        if (sobjs == null || sobjs.isEmpty()) {return;}
        for (IRF_Monthly_Data__c so : sobjs) {
            imdList.add(new IRF_Monthly_Data(so, n++));
        }
        setRenderImdList();
    }
// --------------------------------------------------------------------------------------------------------------
    public void validateImd() {
        Boolean b1 = true, b2 = true; Integer n;

        b1 = validateImdHdr();   if (!b1) {b2 = false;}
       // if (!contractZPNC) {
            b1 = validateImdMats();  if (!b1) {b2 = false;}
       // }
        if (!contractZCCC) {
            b1 = validateImdUnts();  if (!b1) {b2 = false;}
        }
        b1 = validateImdTotls(); if (!b1) {b2 = false;}

        validImd = b2;
    }

    private Boolean validateImdHdr() {
        Invoicing_Report_Form__c f = m_hdr.sobj; IRF_Monthly_Data__c d = d_hdr.sobj;
        d.currencyIsoCode = f.currencyIsoCode;

        Boolean b1 = true, b2 = true; String s = 'MD : ';
        d_hdr.scDate1 = ''; d_hdr.scOpcmt = ''; d_hdr.scPOnum = ''; d_hdr.scUpchg = '';

        validateImdPeriod(); if (!validPeriod) {b2 = false; d_hdr.scDate1 = SC_HILI;}

        b1 = !String.isBlank(d.Purchase_Order_Number__c);
        if(!b1) {b2 = false; d_hdr.scPOnum = SC_HILI; addReqMsg(s + 'Purchase Order Number');}

        b1 = OPT_VAL_YES.equals(d.Operating_at_Normal__c) ||
             OPT_VAL_NO.equals(d.Operating_at_Normal__c) && !String.isBlank(d.Operating_Comments__c);
        if(!b1) {b2 = false; d_hdr.scOpcmt = SC_HILI; addReqMsg(s + 'Site Operation Comments');}

        b1 = OPT_VAL_YES.equals(d.Foresee_at_Normal__c) ||
             OPT_VAL_NO.equals(d.Foresee_at_Normal__c) && !String.isBlank(d.Upcoming_Changes__c);
        if(!b1) {b2 = false; d_hdr.scUpchg = SC_HILI; addReqMsg(s + 'Known Upcoming Changes');}

        //if(!b2) {addErrMsg(s + '.');}
        return b2;
    }

    private void validateImdPeriod() {validateImdPeriod(false);}

    private void validateImdPeriod(Boolean initDlvryData) {
        validPeriod = false; String s = 'MD : ';
        if (d_hdr.sobj == null) {return;}
        Date sdate = d_hdr.sobj.Start_Date__c, edate = d_hdr.sobj.End_Date__c;
        if (sdate == null) {addReqMsg(s + 'Start Date');}
        if (edate == null) {addReqMsg(s + 'End Date');}
        if (String.isBlank(irfId) || sdate == null || edate == null) {return;}
        validPeriod = (sdate <= edate);
        if (!validPeriod) {addErrMsg('Start Date cannot be later than End Date'); return;}
        if (isNewImd) {
            validPeriod = IRF_Functions.isNewPeriod(irfId, sdate, edate);
            if (!validPeriod) {addErrMsg('Monthly Data already exists for this period'); return;}
        }
        if (sdate != d_hdr.startDate || edate != d_hdr.endDate) {
            IRF_Functions.setOrdrDelvryData(d_hdr, d_mats, initDlvryData);
        }
        if (sdate != d_hdr.startDate) {IRF_Functions.setPrevPeriodData(d_hdr);}
        IRF_Functions.setImdFields1(d_hdr.sobj);
    }

    private Boolean validateImdMats() {
        Boolean b1 = true, b2 = true; Integer n = 1;

        for (IRF_Monthly_Material a : d_mats) {
            if (a.recNum == null) {continue;}
            b1 = validate(a, n++); if (!b1) {b2 = false;}
        }
        IRF_Functions.setImmTotl(d_hdr, d_mats, t_mat);
        return b2;
    }

    private Boolean validateImdUnts() {
        Boolean b1 = true, b2 = true; Integer n = 1;
        for (IRF_Monthly_Unit a : d_unts) {
            if (a.recNum == null) {continue;}
            b1 = validate(a, n++); if (!b1) {b2 = false;}
        }
       // system.debug('the -->##1271'+ d_unts);
        IRF_Functions.setImuTotl(d_hdr, d_unts, t_unt);
        return b2;
    }

    private Boolean validate(IRF_Monthly_Material a, Integer n) {
        Invoicing_Report_Form__c f = m_hdr.sobj; IRF_Monthly_Material__c m = a.sobj;
        m.currencyIsoCode = f.currencyIsoCode;
        Boolean b1 = true, b2 = true; if (m.IRF_Material__r.MFD__c) {return b2;}
        IRF_Functions.setImmFields1(m);
        Decimal d1, d2; String s = 'Material ' + n + ' : ';
        a.scAdjst = ''; a.scComnt = ''; a.scCnsnv = ''; a.scEndnv = ''; a.scNdays = ''; a.scVrnce = '';

        if (a.newMat) {
            b1 = !String.isBlank(m.Comments__c);
            if (!b1) {b2 = false; a.scComnt = SC_HILI;
                addReqMsg(s + 'Comments about added material');}
        }

        b1 = (m.Ending_Inventory__c != null);
        if(!b1) {b2 = false; a.scEndnv = SC_HILI; addReqMsg(s + 'Ending Inventory');
        } 
        else {
            b1 = (m.Ending_Inventory__c > 0 ||
                m.Ending_Inventory__c <= 0 && !String.isBlank(m.Comments__c));
            if(!b1) {
            //b2 = false; a.scComnt = SC_HILI; a.scEndnv = SC_HILI;
            //addReqMsg(s + 'Comments about Ending Inventory');
            }
        }

        //if (IRF_Functions.isChanged(m.Adjustment_Inventory__c, a.qtyAdjstd)) {
        //    a.scAdjst = SC_HILI; a.scComnt = SC_HILI;}

        b1 = (m.Consumed_Inventory__c == null || m.Consumed_Inventory__c >= 0);
        if(!b1) {b2 = false; addErrMsg(s + 'Consumed Inventory cannot be negative');} else {
            if (m.Consumed_Inventory__c > 0) {a.scCnsnv = SC_HIL2;}
        }

        b1 = (m.Adjustment_Inventory__c == null || m.Adjustment_Inventory__c == 0);
        if (!b1) {
            b1 = !String.isBlank(m.Comments__c);
            if (!b1) {b2 = false; a.scAdjst = SC_HILI; a.scComnt = SC_HILI;
                addReqMsg(s + 'Comments about Adjustments');}
        }

        b1 = (m.Other_Charges__c == null || m.Other_Charges__c == 0);
        if (!b1) {
            b1 = !String.isBlank(m.Comments__c);
            if (!b1) {b2 = false; a.scComnt = SC_HILI; addReqMsg(s + 'Comments about Other Charges');}
        }

        if (m.Projected_Monthly_Average__c != null &&
            m.Inventory_Variance__c != null) {
            d2 = 0.10 * m.Projected_Monthly_Average__c; d1 = -d2;
            if (m.Inventory_Variance__c < d1 ||
                m.Inventory_Variance__c > d2) {a.scVrnce = SC_HILI;}
            if (m.Inventory_Variance__c > 0)  {a.scVrnce += ' ' + SC_REQD;}
        }

        if (m.Days_Inventory__c != null &&
            m.Days_Inventory__c > 60) {a.scNdays = SC_HILI;}

        //if(!b2) {addErrMsg(s + '.');}
        return b2;
    }

    private Boolean validate(IRF_Monthly_Unit a, Integer n) {
        Invoicing_Report_Form__c f = m_hdr.sobj; IRF_Monthly_Unit__c u = a.sobj;
        u.currencyIsoCode = f.currencyIsoCode; String s = 'Unit ' + n + ' : ';
        Boolean b1 = true, b2 = true; if (u.IRF_Unit__r.MFD__c) {return b2;}
        IRF_Functions.setImuFields1(u); a.scProdn = '';
        b1 = (u.Production__c != null);
        if(!b1) {b2 = false; a.scProdn = SC_HILI; addReqMsg(s + 'Current Month Production');}

        //if(!b2) {addErrMsg(s + '.');}
        return b2;
    }

    private Boolean validateImdTotls() {
        d_hdr.scGncmt = ''; Boolean b1 = true, b2 = true; Decimal d1, d2;
        if (d_hdr.pmd == null || d_hdr.pmd.Id == null) {return b2;}

        //if (!contractZPNC) {
            d1 = t_mat.sobj.Billing_Value__c; d2 = d_hdr.prevMatAmt;
            b1 = validateImdAmts('', d1, d2); if(!b1) {b2 = false;}
        //}

        if (!contractZCCC) {
            d1 = t_unt.sobj.Amount__c; d2 = d_hdr.prevUntAmt;
            b1 = validateImdAmts('', d1, d2); if(!b1) {b2 = false;}
        }

        return b2;
    }

    private Boolean validateImdAmts(String s1, Decimal d1, Decimal d2) {
        Boolean b1 = true; Decimal d3, d4, d5; String gc = d_hdr.sobj.General_Comments__c;
        if (d1 == null) {d1 = 0;} if (d2 == null) {d2 = 0;}
        d1 = d1.setScale(2, RoundingMode.HALF_UP); d2 = d2.setScale(2, RoundingMode.HALF_UP);
        String c = m_hdr.sobj.Currency_for_Invoicing__c;
        String s2 = s1 + ' Total Invoicing Value (' + c + ' ' + d1 +
                    ') is +/- 10% of Previous Period Value (' + c + ' ' + d2 + ')';
        d3 = 0.10 * d2; d4 = d2 - d3; d5 = d2 + d3;
        if (d1 < d4 || d1 > d5) {addInfoMsg(s2);
            if (String.isBlank(gc)) {b1 = false; d_hdr.scGncmt = SC_HILI; addReqMsg('General Comments');}
        }
        return b1;
    }

    public PageReference saveImd() {
        validateImd(); if (!validImd) {return null;} String s = '';
        System.debug('after submit d_unts--->>'+d_unts);
        s = IRF_Functions.saveImd(d_hdr, d_mats, d_unts, mfdImdMatIds);
        System.debug('after submit s--->>'+s);
        System.debug('PARAM_IMDID>>'+PARAM_IMDID+'<<<d_hdr.sobj'+d_hdr.sobj);
        if (String.isBlank(s)) {return gotoUrl(IRF_PAGE_2A, PARAM_IMDID, d_hdr.sobj.Id);}
        else {addErrMsg('Save Failed : ' + s);} return null;
    }

    public PageReference saveAndSubmitImd() {
        PageReference pr = saveImd(); imdId = d_hdr.sobj.Id;
        if (pr == null || imdId == null) {return null;}
        try {
            Custom_Approval_Functions.submitForApproval(imdId);
            setSubmittedInfo();
        } catch(Exception e) {debug('saveAndSubmitImd : ' + e.getMessage());}
        return pr;
    }

    private void setSubmittedInfo() {
        IRF_Monthly_Data__c d = d_hdr.sobj; d.Status__c = IRF_Functions.IMD_STAT_SUBMITED;
        d.Submitted_By__c = UserInfo.getUserId(); d.Submitted_DateTime__c = Datetime.now();
        try {update d;} catch(Exception e) {debug('setSubmittedInfo : ' + e.getMessage());}
    }

    public PageReference viewImdAsPdf() {
      showRecevdInvs();
        String s = IRF_PAGE_3A;
        s += '?' + PARAM_IMDID + '=' + d_hdr.sobj.Id;
        s += '&' + PARAM_VTYPE + '=pdf';
        return new PageReference(s);
    }
    public PageReference viewInvoicePdf() {
      //  showRecevdInvs();
        PageReference pageRef = new PageReference('/apex/IRF_MD_PDF?id='+ imdId );
       pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference viewImdApprovalHistory() {
        String s = IRF_PAGE_4A;
        s += '?' + PARAM_OBJID + '=' + d_hdr.sobj.Id;
        s += '&' + PARAM_IRFNM + '=' + m_hdr.sobj.Name;
        s += '&' + PARAM_IMDNM + '=' + d_hdr.sobj.Name;
        return new PageReference(s);
    }
    
    private Set<String> getSelectedImdIds() {
        Set<String> sids = new Set<String>();
        for (IRF_Monthly_Data d : imdList) {
            if (d.selected) {sids.add(d.sobj.Id);}
        }
        return sids;
    }
    
    public PageReference approveImds() {
        Set<String> sids = getSelectedImdIds();
        if (sids.isEmpty()) {addErrMsg('None selected to Approve'); return null;}
        Custom_Approval_Functions.approveObjects(sids, userComments);
        return initAction5();
    }
    
    public PageReference rejectImds() {
        Set<String> sids = getSelectedImdIds(); Boolean b1, b2;
        b1 = sids.isEmpty(); 
        if (b1) {addErrMsg('None selected to Reject');}
        b2 = String.isBlank(userComments);
        if (b2) {addErrMsg('Reject Comments are Required');}
        if (b1 || b2) {return null;}
        Custom_Approval_Functions.rejectObjects(sids, userComments);
        return initAction5();
    }
    
    //Added For IRF Changes on 20_8_2019
    public PageReference IRF_SAP_Details()
    {
        PageReference pageRef = new PageReference('/apex/IRF_MD_GETSAP?id='+ imdId );
        pageRef.setRedirect(true);
        return pageRef;
        
    }
        
}