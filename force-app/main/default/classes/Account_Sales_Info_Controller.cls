public class Account_Sales_Info_Controller {

    public final static String DIST_CHAN_AAFI = '50';
    public final static String DIST_CHAN_AHWT = '10';
    public final static String DIST_CHAN_VALV = '40';
    public final static String DIST_CHAN_ASKC = 'Y0';

    public final static String GM_GP_AMOUNT    = Rolling_Product_Sales_Info.GM_GP_AMOUNT;
    public final static String GM_GP_PERCENT   = Rolling_Product_Sales_Info.GM_GP_PERCENT;
    public final static String PLAN_AMOUNT     = Rolling_Product_Sales_Info.PLAN_AMOUNT;
    public final static String PLAN_VOLUME_KG  = Rolling_Product_Sales_Info.PLAN_VOLUME_KG;
    public final static String PLAN_VOLUME_LB  = Rolling_Product_Sales_Info.PLAN_VOLUME_LB;
    public final static String SALES_AMOUNT    = Rolling_Product_Sales_Info.SALES_AMOUNT;
    public final static String SALES_VOLUME_GL = Rolling_Product_Sales_Info.SALES_VOLUME_GL;
    public final static String SALES_VOLUME_KG = Rolling_Product_Sales_Info.SALES_VOLUME_KG;
    public final static String SALES_VOLUME_LB = Rolling_Product_Sales_Info.SALES_VOLUME_LB;
    public final static String SALES_VOLUME_PT = Rolling_Product_Sales_Info.SALES_VOLUME_PT;
    public final static String SALES_VOLUME_UN = Rolling_Product_Sales_Info.SALES_VOLUME_UN;

    public final static Date FYTD_StartDate    = Rolling_Product_Sales_Info.FYTD_StartDate;
    public final static Date FYTD_EndDate      = Rolling_Product_Sales_Info.FYTD_EndDate;

    public final static Date PFYTD_StartDate   = Rolling_Product_Sales_Info.PFYTD_StartDate;
    public final static Date PFYTD_EndDate     = Rolling_Product_Sales_Info.PFYTD_EndDate;

    public final static Date FYF_StartDate     = Rolling_Product_Sales_Info.FYF_StartDate;
    public final static Date FYF_EndDate       = Rolling_Product_Sales_Info.FYF_EndDate;

    public final static Date PFYF_StartDate    = Rolling_Product_Sales_Info.PFYF_StartDate;
    public final static Date PFYF_EndDate      = Rolling_Product_Sales_Info.PFYF_EndDate;

    public final static Map<Integer,String> MNTH_LBL_MAP =
                                                 Rolling_Product_Sales_Info.MNTH_LBL_MAP;
    public final static String[] MONTH_LABELS  = Rolling_Product_Sales_Info.MONTH_LABELS;

    public Boolean show_Data           {get; set;}

    public String materialName         {get; set;}
    public String rpsView              {get; set;}

    public String accId, accType;
    public Account acc                    {get; private set;}
    public PaginationController pc1       {get; private set;}
    public List<SelectOption> rpsViewOpts {get; private set;}
    public String gmgpLabel               {get; set;}

    List<Rolling_Product_Sales_Info.RPSI_Line> rpsiLines;
    Account_Sales_Info accountSalesInfo;
    String amountLabel, gmgpAmountLabel;
    Boolean hideGmGps;

    public Boolean isAAFI {
        get {return (String.isBlank(acc.SAP_DistChannel__c) ||
              DIST_CHAN_AAFI.equals(acc.SAP_DistChannel__c));}
    }

    public Boolean isAHWT {
        get {return (DIST_CHAN_AHWT.equals(acc.SAP_DistChannel__c));}
    }

    public Boolean isVALV {
        get {return (DIST_CHAN_VALV.equals(acc.SAP_DistChannel__c));}
    }

    public Boolean isASKC {
        get {return (DIST_CHAN_ASKC.equals(acc.SAP_DistChannel__c));}
    }

    public Boolean isAHWT_AP {
        get {return (SAP_Queries_Functions.isAHWT_AP(acc));}
    }

    public Boolean showGMGPs {
        get {
            return (!hideGmGps && !isAAFI && !isASKC && !isAHWT_AP);
        }
    }

    public Boolean showProductGMs {
        get {return (!hideGmGps && !isAAFI && !isASKC && !isAHWT_AP && !isVALV);}
    }

    public Boolean showLBs      {get {return (true);}}
    public Boolean showKGs      {get {return (!isVALV);}}
    public Boolean showUNs      {get {return (isVALV);}}
    public Boolean showGLs      {get {return (isVALV);}}
    public Boolean showPTs      {get {return (isVALV);}}

    public Boolean showFYF      {get {return (isAAFI);}}
    public Boolean showPFYF     {get {return (isAAFI);}}

    public Boolean showPAMTs    {get {return (isAAFI);}}
    public Boolean showPVKGs    {get {return (isAAFI);}}
    public Boolean showPVLBs    {get {return (isAAFI);}}

    public Integer accountSummaryColumns {
        get {Integer n = 3; if (isAAFI) {n += 9;}
            if (showKGs) n++; if (showUNs) n++; if (showGLs) n++; if (showPTs) n++;
            if (showGMGPs) n += 2; return n;}
    }

    public String labelMonth01 {get; private set;}
    public String labelMonth02 {get; private set;}
    public String labelMonth03 {get; private set;}
    public String labelMonth04 {get; private set;}
    public String labelMonth05 {get; private set;}
    public String labelMonth06 {get; private set;}
    public String labelMonth07 {get; private set;}
    public String labelMonth08 {get; private set;}
    public String labelMonth09 {get; private set;}
    public String labelMonth10 {get; private set;}
    public String labelMonth11 {get; private set;}
    public String labelMonth12 {get; private set;}
    public String labelMonth13 {get; private set;}
    public String labelFYTD    {get; private set;}
    public String labelPFYTD   {get; private set;}
    public String labelYTDVar  {get; private set;}
    public String labelFYF     {get; private set;}
    public String labelPFYF    {get; private set;}

    public String lastUpdTime  {get; private set;}

    List<Rolling_Product_Sales_Info__c> rpslist;
    Integer pageSize = Rolling_Product_Sales_Info.PAGE_SIZE;

    public Account_Sales_Info_Controller() {}

    public Account_Sales_Info_Controller(ApexPages.StandardController sc) {
        Map<String, String> pmap = ApexPages.currentPage().getParameters();
        SObject sobj = sc.getRecord(); acc = null;
        if (sobj != null) {acc = (Account)sobj; accId = acc.Id;}
        else {accId = pmap.get('id');}
        init1();
    }

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'ASI_Controller : ' + s);
    }

    private void init1() {
        show_Data = false; materialName = '';
        rpsiLines = new List<Rolling_Product_Sales_Info.RPSI_Line>();
        rpsViewOpts = new List<SelectOption>();
        labelMonth01 = MONTH_LABELS[01].replace('-','<br/>');
        labelMonth02 = MONTH_LABELS[02].replace('-','<br/>');
        labelMonth03 = MONTH_LABELS[03].replace('-','<br/>');
        labelMonth04 = MONTH_LABELS[04].replace('-','<br/>');
        labelMonth05 = MONTH_LABELS[05].replace('-','<br/>');
        labelMonth06 = MONTH_LABELS[06].replace('-','<br/>');
        labelMonth07 = MONTH_LABELS[07].replace('-','<br/>');
        labelMonth08 = MONTH_LABELS[08].replace('-','<br/>');
        labelMonth09 = MONTH_LABELS[09].replace('-','<br/>');
        labelMonth10 = MONTH_LABELS[10].replace('-','<br/>');
        labelMonth11 = MONTH_LABELS[11].replace('-','<br/>');
        labelMonth12 = MONTH_LABELS[12].replace('-','<br/>');
        labelMonth13 = MONTH_LABELS[13].replace('-','<br/>');
        labelFYTD    = getLabel(FYTD_StartDate, FYTD_EndDate);
        labelPFYTD   = getLabel(PFYTD_StartDate, PFYTD_EndDate);
        labelYTDVar  = 'YTD<br/>Variance';
        labelFYF     = getLabel(FYF_StartDate, FYF_EndDate);
        labelPFYF    = getLabel(PFYF_StartDate, PFYF_EndDate);
        if (String.isBlank(accId)) {return;}
        init2();
    }

    private void init2() {
        try {acc = [select Id, Name, SAP_DistChannel__c, SAP_Sales_Org__c
                      from Account where Id = :accId];
        } catch(Exception e) {return;}
        debug('acc : ' + acc); setLastUpdTime();
        CustomSettings__c csc = CustomSettings__c.getInstance();
        hideGmGps = (csc.BW_Data_Hide_GMGP__c != null && csc.BW_Data_Hide_GMGP__c == true);
        getAccountSalesInfo();
        setRpsViewOpts(); setRpsList(); //setRpsView();
        show_data =  accountSalesInfo != null ||
                    (rpslist != null && !rpslist.isEmpty());
    }

    public String getAccId() {return accId;}
    public void setAccId(String s) {
        if (accId != null) {return;} accId = s; init1();
    }

    private void setLastUpdTime() {
        lastUpdTime = '';
        LIST<AggregateResult> ars = [select max(lastmodifieddate) lmd
            from Rolling_Product_Sales_Info__c where Account__c = :accId];
        if (ars == null || ars.isEmpty()) {return;}
        Datetime dt = (Datetime)ars[0].get('lmd');
        if (dt != null) {lastUpdTime = dt.format();}
    }

    private String getLabel(Date d1, Date d2) {
        return MNTH_LBL_MAP.get(d1.month()) + ' ' + d1.year() + '<br/>' +
               MNTH_LBL_MAP.get(d2.month()) + ' ' + d2.year();
    }

    private void setRpsViewOpts() {
        rpsView = SALES_VOLUME_LB; if (isVALV) {rpsView = SALES_VOLUME_UN;}

            rpsViewOpts = new List<SelectOption>();
            rpsViewOpts.add(new SelectOption(SALES_VOLUME_LB, 'Sales Volume in LBs'));

        if (!isVALV) {
            rpsViewOpts.add(new SelectOption(SALES_VOLUME_KG, 'Sales Volume in KGs'));
        }

        if (isVALV) {
            rpsViewOpts.add(new SelectOption(SALES_VOLUME_PT, 'Sales Volume in Points'));
            rpsViewOpts.add(new SelectOption(SALES_VOLUME_GL, 'Sales Volume in Gallons'));
            rpsViewOpts.add(new SelectOption(SALES_VOLUME_UN, 'Sales Volume in Units'));
        }
            rpsViewOpts.add(new SelectOption(SALES_AMOUNT,    'Sales ' + amountLabel));

        if (isAAFI) {
            rpsViewOpts.add(new SelectOption(PLAN_VOLUME_LB,  'Plan Volume in LBs'));
            rpsViewOpts.add(new SelectOption(PLAN_VOLUME_KG,  'Plan Volume in KGs'));
            rpsViewOpts.add(new SelectOption(PLAN_AMOUNT,     'Plan ' + amountLabel));
        }

        if (showProductGMs) {
            rpsViewOpts.add(new SelectOption(GM_GP_AMOUNT,    gmgpAmountLabel));
            rpsViewOpts.add(new SelectOption(GM_GP_PERCENT,   gmgpLabel + ' %'));
        }
    }

    public String getRpsViewLabel() {
        SelectOption so = Rolling_Product_Sales_Info.getSelectOption(rpsViewOpts, rpsView);
        return so.getLabel();
    }

    public void searchByMaterialName() {setRpsList();}

    public Account_Sales_Info getAccountSalesInfo() {
        if (acc == null) {return null;}
        debug('accId : ' + accId);
        amountLabel = 'Amount'; gmgpLabel = 'Gross Margin';
        if (isAHWT || isVALV) {gmgpLabel = 'Gross Profit';}
        gmgpAmountLabel = gmgpLabel;
        if (accountSalesInfo != null) {return accountSalesInfo;}
        accountSalesInfo = new Account_Sales_Info(accId);
        accType = accountSalesInfo.accountType;
        String cc = accountSalesInfo.currencyCode;
        if (!String.isBlank(cc)) {
            amountLabel += ' in ' + cc;
            gmgpAmountLabel += ' in ' + cc;
        }
        return accountSalesInfo;
    }

    public void pc1Size() {setRpsList(null); pageSize = pc1.getPageSize();}
    public void pc1Frst() {setRpsList(PaginationController.Page.FIRST);}
    public void pc1Prev() {setRpsList(PaginationController.Page.PREV);}
    public void pc1Next() {setRpsList(PaginationController.Page.NEXT);}
    public void pc1Last() {setRpsList(PaginationController.Page.LAST);}
    public void pc1Goto() {setRpsList(null);}

    private void setRpsList() {
        pc1 = Rolling_Product_Sales_Info.getPaginationController(accId, accType, materialName);
        setRpsList(null);
    }

    private void setRpsList(PaginationController.Page p) {
        rpslist = new List<Rolling_Product_Sales_Info__c>();
        if (pc1 == null) {return;} pc1.gotoPage(p);
        rpslist = (List<Rolling_Product_Sales_Info__c>)pc1.getRecords();
        if (rpslist != null && !rpslist.isEmpty()) {setRpsView();}
    }

    public void setRpsView() {
        rpsiLines = new List<Rolling_Product_Sales_Info.RPSI_Line>();
        Rolling_Product_Sales_Info.RPSI_Line l; Integer n = pc1.recordFrom;
        for (Rolling_Product_Sales_Info__c r : rpslist) {
            l = new Rolling_Product_Sales_Info.RPSI_Line(r, rpsView, n++); rpsiLines.add(l);
            debug('rpsi line : ' + l);
        }
    }

    public List<Rolling_Product_Sales_Info.RPSI_Line> getRpsiLines() {return rpsiLines;}
}