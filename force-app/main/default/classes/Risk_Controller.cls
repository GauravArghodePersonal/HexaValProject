public class Risk_Controller {

    private static final Integer BATCH_SIZE = 200;
    private static final Integer PAGE_SIZE = 20;
    private static final String DELIM = ':';
    private static final String ERROR_STYLE = 'error';
    private static final String ERROR_REQUIRED = 'Please enter a value for all required fields';
    private static final String ERROR_MATERIALS = 'Please add at least one material';
    private static final String ERROR_NOPLANS = 'Account does not have any Sales Plan Materials';
    private static final String ERROR_PERCENT = 'Probability % should be between 0 and 100';
    private static final String ERROR_PROBREQ = 'Probability % is required if Volume at Risk is filled in';
    private static final String ERROR_RISKVOL = 'Volume at Risk should not be more than the Planned Volume';
    private static final String BATCH_JOB_MSG = 'Your request is in progress. You will be notified by email when it completes.';
    private static final String RISK_PAGE1_URL = '/apex/Risk_Page1';
    private static final String UTF_8 = 'UTF-8';
    
    private static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    private static final ApexPages.Severity INFO = ApexPages.Severity.INFO;

    public class RiskHdr {
        public Risk__c rh {get; set;}

        public RiskHdr(Risk__c a) {
            this.rh = a;
        }
    }
    
    public class RiskDtl {
        public Risk_Detail__c rd         {get; set;}
        public Integer recNum            {get; set;}
        public Boolean selected          {get; set;}
        public Decimal amountCY          {get; set;}
        public Decimal amountNY          {get; set;}
        public String  styleClass_pcy    {get; set;}
        public String  styleClass_pny    {get; set;}
        public String  styleClass_vcy    {get; set;}
        public String  styleClass_vny    {get; set;}

        public RiskDtl() {}      
        public RiskDtl(Risk_Detail__c d) {this(d, 1);}
        public RiskDtl(Risk_Detail__c d, Integer n) {
            rd = d; recNum = n; selected = false;
            amountCY = 0; amountNY = 0;
        }
    }
    
    public class PlanMatrl {
        public Product_Sales_Plan__c psp {get; set;}
        public Integer recNum            {get; set;}
        public Boolean selected          {get; set;}
        //public String materialNumber   {get; set;}

        public PlanMatrl() {}      
        public PlanMatrl(Product_Sales_Plan__c a) {this(a, 1);}
        public PlanMatrl(Product_Sales_Plan__c a, Integer n) {
            this.psp = a; recNum = n; selected = false;
            //materialNumber = String_Functions.removeLeadingZeros(a.Material__r.Material_Number__c);
        }
    }
    
    public Boolean allPlanMtrls          {get; set;}
    public Boolean allDetlMtrls          {get; set;}
    public Integer pageSize              {get; set;}
    public String matSrchString          {get; set;}
    public String userLocale             {get; set;} 
    public SAP_LISD lisd                 {get; set;}

    public Boolean accEditable           {get; private set;}
    public Boolean isEditable            {get; private set;}

    public Boolean disableActJobBtn      {get; private set;}
    public Boolean disableCrtJobBtn      {get; private set;}

    public Boolean renderEditBtn         {get; private set;}
    public Boolean renderGoto1           {get; private set;}
    public Boolean renderGoto2           {get; private set;}
    public Boolean renderLisd            {get; private set;}
    public Boolean renderPage2           {get; private set;}
    public Boolean renderRiskHdr         {get; private set;}
    public Boolean renderPlanMtrls       {get; private set;}
    public Boolean renderThrtMtrlsTbl    {get; private set;}
    public Boolean renderPlanMtrlsTbl    {get; private set;}

    public Decimal totBudgetCY           {get; private set;}
    public Decimal totBudgetNY           {get; private set;}
    public Decimal wtdBudgetCY           {get; private set;}
    public Decimal wtdBudgetNY           {get; private set;}

    public RiskHdr riskHeader            {get; private set;}
    public List<RiskDtl> riskDetails     {get; private set;}
    public List<PlanMatrl> planMaterials {get; private set;}
    public List<SelectOption> statusOpts {get; private set;}
    public PaginationController pc1      {get; private set;}

    public Account acc                   {get; private set;}

    public Risk__c rh                    {get; private set;}

    public String styleClass_acc         {get; private set;}
    public String styleClass_bseg        {get; private set;}
    public String styleClass_bunit       {get; private set;}
    public String styleClass_comp        {get; private set;}
    public String styleClass_probcy      {get; private set;}
    public String styleClass_probny      {get; private set;}
    public String styleClass_reasn       {get; private set;}
    public String styleClass_regn        {get; private set;}
    public String styleClass_sbu         {get; private set;}
    public String styleClass_stage       {get; private set;}
    public String styleClass_status      {get; private set;}
    public String styleClass_tname       {get; private set;}
        
    private Risk_Detail__c rd;
    private Set<String> materialIds;
    private List<Risk_Detail__c> tdlist;
    private Boolean isValid;
    private String accountId;
    private String accountNumber;
    private String riskId;
    private String retUrl = null;
    private Map<String, Double> ccrmap;

    public Risk_Controller() {
        init(new Risk__c());
    }
    
    public Risk_Controller(ApexPages.StandardController sc) {
        init(sc.getRecord());
    }
    
    private void debug(String s) {DebugLog_Functions.info('>>>>>>>> ' + s);}
    
    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}
  
    private void init(SObject sobj) {
        debug('sobj : ' + sobj); renderPage2 = false; renderLisd = true; pageSize = PAGE_SIZE;
        init(); initStatusOpts(); matSrchString = ''; userLocale = UserInfo.getLocale();
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        riskId = ApexPages.currentPage().getParameters().get('id');
        retUrl = ApexPages.currentPage().getParameters().get('retURL');
        if (accountId != null) {setRetUrl(accountId);}
        debug('retUrl : ' + retUrl);
        ccrmap = CurrencyConverter.getConversionRateMap();
        rh = new Risk__c(); tdlist = new List<Risk_Detail__c>();
        riskDetails = new List<RiskDtl>(); materialIds = new Set<String>();
        if (sobj != null) {
            if (sobj.getSObjectType() == Risk__c.sObjectType) {
                rh = (Risk__c)sobj; 
            } else 
            if (sobj.getSObjectType() == Risk_Detail__c.sObjectType) {
                rd = (Risk_Detail__c)sobj; setRetUrl(rd.Id); return;
            } 
        }
        if (rh.Id != null) {riskId = rh.Id;}
        if (riskId != null) {
        	setRiskDetails(); setRetUrl(riskId);
            if (rh.Account__c != null) {accountId = rh.Account__c;}
        } else {editRisk();}
        if (rh.Stage__c == null) {rh.Stage__c = Risk_Functions.STAGE_NEW;} 
        if (rh.Record_Status__c == null) {rh.Record_Status__c = Risk_Functions.DRAFT;} 
        debug('rh : ' + rh);
        //initAccount();
    }
    
    private void init() {
        renderRiskHdr = true; isEditable = true; renderGoto2 = false;
        renderEditBtn = false; renderPlanMtrls = false; renderPlanMtrlsTbl = false;
        disableActJobBtn = false; disableCrtJobBtn = false;
    }
    
    private void initStatusOpts() {
        statusOpts = new List<SelectOption>();
        for (String s : Risk_Functions.STATUS_LIST) {
            statusOpts.add(new SelectOption(s, s));
        }
    }
    
    private void initAccount() {
        acc = new Account();
        accEditable = isEditable && (isNull(accountId) || riskDetails.isEmpty()); 
        if (accountId != null) {
            acc = Risk_Functions.getAccount(accountId);
            if (acc != null) {
                rh.Account__c = accountId; setPlanMaterials();
            }
        }
    }
    
    public void initAction1() {
        initAccount();
        if (lisd == null) {
            lisd = new SAP_LISD();
            if (!isNull(accountId)) {lisd.setIndustries(accountId);}
            else {lisd.readOnlyAC = false;}
        }
        if (riskId == null) {onLisdComplete();} else {
        	renderPage2 = true; renderLisd = false; lisd.copyDataFrom(rh); 
        }
    }

    public void onLisdComplete() {
        debug('onLisdComplete : lisd = ' + lisd);
        renderGoto2 = (lisd != null && !lisd.readOnlyInputs && 
                       lisd.seller != null && lisd.seller.Id != null);
        if (!renderPlanMtrlsTbl && lisd != null && lisd.acc != null) {
        	accountId = lisd.acc.Id; initAccount();
        }
        if (lisd != null && lisd.readOnlyInputs) {gotoPage2();}
    }
    
    private void setRetUrl(String objId) {
        if (objId != null) {retUrl = '/' + objId;}
    }
    
    public void gotoPage1() {
    	if (lisd == null) {return;}
		renderPage2 = lisd.readOnlyInputs;
		if (renderPage2) {return;}
	    lisd.setDataLists(rh); renderLisd = true;
        renderGoto2 = (!lisd.readOnlyInputs && 
                       lisd.seller != null && lisd.seller.Id != null);
    }
    
    public void gotoPage2() {
    	renderGoto2 = false; renderLisd = false;
    	renderPage2 = true; isEditable = true; 
        renderGoto1 = (isEditable && lisd != null && !lisd.readOnlyInputs);
        lisd.copyDataTo(rh); accountId = rh.Account__c; initAccount();
    }
    
    public PageReference cancel() {
        PageReference pr = null;
        if (retUrl != null) {pr = new PageReference(retUrl);}
        return pr;
    }
    
    public void editRisk() {
    	init(); renderGoto1 = (isEditable && lisd != null && !lisd.readOnlyInputs); 
    }
    
    public void setPacIndustry() {
    	lisd.setPacIndustry(rh.PAC_Industry_Code__c);
        rh.PAC_Description__c = lisd.getPacIndustryLabel();
    }
    
    private String validateRequired(String s) {
        String t = ''; 
        if (isNull(s)) {
            t = ERROR_STYLE; isValid = false; addErrMsg(ERROR_REQUIRED);
        } 
        return t;
    }
    
    private String validateVolumeAtRisk(Risk_Detail__c d) {
        String t = ''; 
        Double d1 = d.Product_Sales_Plan__r.Sales_Volume__c,
               d2 = d.Volume_at_Risk_CY__c;
        if (d1 != null && d2 != null && d2 > d1) {
            t = ERROR_STYLE; isValid = false; addErrMsg(ERROR_RISKVOL);
        } 
        return t;
    }
    
    private String validateProbability(Decimal d) {
        String t = ''; 
        if (d != null && (d < 0 || d > 100)) {
            t = ERROR_STYLE; isValid = false; addErrMsg(ERROR_PERCENT);
        } 
        return t;
    }
    
    private String validateProbability2(Decimal d1, Decimal d2) {
        String t = ''; 
        if (d1 != null && d1 > 0 && d2 == null) {
            t = ERROR_STYLE; isValid = false; addErrMsg(ERROR_PROBREQ);
        } 
        return t;
    }
    
    private void validate() {
        debug('validate : rh : ' + rh);
        isValid = true;
        styleClass_acc    = validateRequired(rh.Account__c);
        styleClass_comp   = validateRequired(rh.Competitor__c);
        styleClass_reasn  = validateRequired(rh.Reason__c);
        styleClass_sbu    = validateRequired(rh.SBU__c);
        styleClass_stage  = validateRequired(rh.Stage__c);
        styleClass_status = validateRequired(rh.Record_Status__c);
        styleClass_tname  = validateRequired(rh.Name);
        for (RiskDtl d : riskDetails) {
            d.styleClass_pcy = validateRequired(String.valueof(d.rd.Price_CY__c));
            d.styleClass_vcy = validateRequired(String.valueof(d.rd.Volume_at_Risk_CY__c));
            if (d.styleClass_vcy == '') {d.styleClass_vcy = validateVolumeAtRisk(d.rd);}
            if (d.rd.Volume_at_Risk_NY__c > 0) {
                d.styleClass_pny = validateRequired(String.valueof(d.rd.Price_NY__c));
            }
        }
        if (riskDetails == null || riskDetails.isEmpty()) {addErrMsg(ERROR_MATERIALS); isValid = false;}
        styleClass_probcy = validateRequired(String.valueof(rh.Probability_of_Risk_CY__c));
        if (styleClass_probcy == '') {
        styleClass_probcy = validateProbability(rh.Probability_of_Risk_CY__c);}
        styleClass_probny = validateProbability(rh.Probability_of_Risk_NY__c);
        if (styleClass_probny == '') {
        styleClass_probny = validateProbability2(totBudgetNY, rh.Probability_of_Risk_NY__c);}
    }
    
    private void addErrMsg(String s) {addMsg(ERROR, s);}
    
    private void addInfoMsg(String s) {addMsg(INFO, s);}
    
    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }
    
    public void pc1Size() {setPlanMtrls(null); pageSize = pc1.getPageSize();}
    public void pc1Frst() {setPlanMtrls(PaginationController.Page.FIRST);}
    public void pc1Prev() {setPlanMtrls(PaginationController.Page.PREV);}
    public void pc1Next() {setPlanMtrls(PaginationController.Page.NEXT);}
    public void pc1Last() {setPlanMtrls(PaginationController.Page.LAST);}

    public void showPlanMtrls() {
        init(); setPlanMtrls(); renderRiskHdr = false; renderPlanMtrls = true;
    }
        
    public void setPlanMaterials() {
        accountNumber = String_Functions.removeLeadingZeros(acc.AccountNumber);
        pc1 = Risk_Functions.getProductPlansPC(accountId, matSrchString, pageSize); 
        setPlanMtrls();
    }
    
    private void setPlanMtrls() {setPlanMtrls(null);}
        
    private void setPlanMtrls(PaginationController.Page p) {
        renderPlanMtrlsTbl = false;
        debug('riskDetails : ' + riskDetails);
        String msg = ERROR_NOPLANS; 
        planMaterials = new List<PlanMatrl>();List<Product_Sales_Plan__c> alist = null;
        if (pc1 == null) {return;}
        pc1.gotoPage(p);
        try {alist = (List<Product_Sales_Plan__c>) pc1.getRecords();} catch(Exception e) {
            msg = e.getMessage(); debug('setPlanMtrls : ' + msg);
        }
        if (alist == null || alist.isEmpty()) {
        	addErrMsg(msg);	if (lisd != null && lisd.readOnlyAC) {renderLisd = false;} 
        	isEditable = false; renderEditBtn = false; renderGoto2 = false; return;
        }
        Integer n = pc1.recordFrom; PlanMatrl pm;
        for (Product_Sales_Plan__c a : alist) {
            pm = new PlanMatrl(a, n++);
            pm.selected = (materialIds.contains(a.Material__c));
            planMaterials.add(pm);
        }
        renderPlanMtrlsTbl = !planMaterials.isEmpty();
    }
    
    public void addAndReturn() {
        addMaterials(); gotoRiskPage();
    }
    
    public void gotoRiskPage() {init();}
    
    public void onAccountChange() {
        if (accountId == rh.Account__c) {return;}
        lisd = null; initAction1();
    }
    
    public void onStageChange() {
        if (rh.Stage__c == 'Won') {
            rh.Probability_of_Risk_CY__c = 0; rh.Probability_of_Risk_NY__c = 0;
            calculate();
        }
    }
    
    private void setRiskDetails() {
        isEditable = false; renderEditBtn = true;
        riskDetails = new List<RiskDtl>(); materialIds = new Set<String>();
        rh = Risk_Functions.getRisk(riskId); accountId = rh.Account__c;
        if (rh.Risk_Details__r == null) {return;}
        tdlist = rh.Risk_Details__r;
        for (Risk_Detail__c rd : tdlist) {
            RiskDtl tdtl = new RiskDtl(rd);
            riskDetails.add(tdtl); materialIds.add(rd.Material__c);
        } 
        sortRiskDetails(); calculate();
    }
    
    public void deleteMaterials() {
        allDetlMtrls = false;
        Set<String> tset = new Set<String>(); 
        List<RiskDtl> tlist = new List<RiskDtl>(); 
        for (RiskDtl tdtl : riskDetails) {
            if (!tdtl.selected) {tset.add(tdtl.rd.Material__c); tlist.add(tdtl);}
            tdtl.selected = false;
        }
        materialIds = tset; riskDetails = tlist;
        sortRiskDetails(); setPlanMtrls(); calculate();
    }

    public void addMaterials() {
        allPlanMtrls = false;
        for (PlanMatrl pm : planMaterials) {
            if (pm.selected && !materialIds.contains(pm.psp.Material__c)) {
                addRiskDetail(pm);
            }
        }
        sortRiskDetails();
    }

    private void addRiskDetail(PlanMatrl pm) {
        rd = new Risk_Detail__c();
        rd.CurrencyIsoCode       = rh.CurrencyIsoCode;
        rd.Material__c           = pm.psp.Material__c;
        rd.Material__r           = pm.psp.Material__r;
        rd.Product_Sales_Plan__c = pm.psp.Id;
        rd.Product_Sales_Plan__r = pm.psp;
        rd.Volume_UOM_at_Risk__c = pm.psp.Sales_Volume_UOM__c;
        RiskDtl tdtl = new RiskDtl(rd);
        riskDetails.add(tdtl); materialIds.add(pm.psp.Material__c);
    }

    private void sortRiskDetails() {
        accEditable = false; 
        if (riskDetails.isEmpty()) {
            accEditable = true; renderThrtMtrlsTbl = false; return;
        }
        Map<String, RiskDtl> amap = new Map<String, RiskDtl>();
        List<String> slist = new List<String>(); String k;
        List<RiskDtl> tlist = new List<RiskDtl>(); 
        for (RiskDtl tdtl : riskDetails) {
            k = tdtl.rd.Material__r.Name;
            amap.put(k, tdtl); slist.add(k);
        }
        slist.sort(); RiskDtl tdtl; Integer n = 1;
        for (String s : slist) {
            tdtl = amap.get(s); tdtl.recNum = n++; tlist.add(tdtl);
        }
        riskDetails = tlist; renderThrtMtrlsTbl = !riskDetails.isEmpty();
    }
    
    public void calculate() {
        totBudgetCY = 0; totBudgetNY = 0; wtdBudgetCY = 0; wtdBudgetNY = 0;
        Double currConvFac = 1.0;
        for (RiskDtl d : riskDetails) {
            currConvFac = 1.0;
            if (d.rd.CurrencyIsoCode != rh.CurrencyIsoCode) {
                currConvFac = CurrencyConverter.getCurrencyConversionFactor(
                              ccrmap, d.rd.CurrencyIsoCode, rh.CurrencyIsoCode);                
                //d.rd.CurrencyIsoCode  = rh.CurrencyIsoCode;
            }
            //d.amountCY = 0; d.amountNY = 0;
            d.rd.Amount_at_Risk_CY__c = 0; d.rd.Amount_at_Risk_NY__c = 0;
            if (d.rd.Volume_at_Risk_CY__c != null && d.rd.Price_CY__c != null) {
                //d.amountCY = d.rd.Volume_at_Risk_CY__c * d.rd.Price_CY__c;
                d.rd.Amount_at_Risk_CY__c = d.rd.Volume_at_Risk_CY__c * 
                                            d.rd.Price_CY__c * currConvFac;
            }
            if (d.rd.Volume_at_Risk_NY__c != null && d.rd.Price_NY__c != null) {
                //d.amountNY = d.rd.Volume_at_Risk_NY__c * d.rd.Price_NY__c;
                d.rd.Amount_at_Risk_NY__c = d.rd.Volume_at_Risk_NY__c * 
                                            d.rd.Price_NY__c * currConvFac;
            }
            //totBudgetCY += d.amountCY; totBudgetNY += d.amountNY;
            totBudgetCY += d.rd.Amount_at_Risk_CY__c; 
            totBudgetNY += d.rd.Amount_at_Risk_NY__c;
        }
        if (rh.Probability_of_Risk_CY__c != null) {
            wtdBudgetCY = totBudgetCY * rh.Probability_of_Risk_CY__c / 100;
        }
        if (rh.Probability_of_Risk_NY__c != null) {
            wtdBudgetNY = totBudgetNY * rh.Probability_of_Risk_NY__c / 100;
        }
    }
    
    private void setTdlist() {
        tdlist = new List<Risk_Detail__c>();
        for (RiskDtl d : riskDetails) {tdlist.add(d.rd);}
    }
    
    public PageReference saveRisk() {
        validate(); if (!isValid) {return null;}
        PageReference pr = null; calculate(); setTdlist();
        try {
            Risk_Functions.saveRisk(rh, tdlist);
            pr = new PageReference('/' + rh.Id);
        } catch(Exception e) {debug(e.getMessage());}
        return pr;
    }
    
    public PageReference gotoRiskPage1() {
        PageReference pr = null; String s = RISK_PAGE1_URL;
        if (!isNull(retUrl)) {s += '?retURL=' + retUrl;}
        if (rd != null && rd.Id != null) {
            rd = [select Risk__c from Risk_Detail__c where Id = :rd.Id];
            s += '&id=' + rd.Risk__c;
        }
        debug('s : ' + s);
        pr = new PageReference(s); return pr;
    }
    
    private void submitBatchJob(String pstep) {
        Risk_Batchable b = new Risk_Batchable(pstep, null);
        //Risk_Batchable b = new Risk_Batchable(pstep, 1);
        try {Database.executeBatch(b, BATCH_SIZE); addInfoMsg(BATCH_JOB_MSG);}
        catch(Exception e) {addErrMsg(e.getMessage());}
    }
    
    public void createNextYearRisks() {
        submitBatchJob(Risk_Batchable.CREATE_NEW_RISKS_DATA);
        disableCrtJobBtn = true; 
    }

    public void activateNextYearRisks() {
        submitBatchJob(Risk_Batchable.ACTIVATE_NEW_RISKS_DATA);
        disableActJobBtn = true; 
    }
}