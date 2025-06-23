public class SAP_LISD_Controller {

    Boolean enableAcc, showLisds; SAP_LISD sapLisd; Id accountId;
    transient public List<SAP_LISD> sapLisds {get; private set;}
    
    public String industry   {get {return sapLisd.industryValue;}   set {sapLisd.industryValue = value;}}
    public String endUseCust {get {return sapLisd.endUseCustValue;} set {sapLisd.endUseCustValue = value;}}
    public String salesDst   {get {return sapLisd.salesDstValue;}   set {sapLisd.salesDstValue = value;}}
    public String salesOfc   {get {return sapLisd.salesOfcValue;}   set {sapLisd.salesOfcValue = value;}}
    public String salesGrp   {get {return sapLisd.salesGrpValue;}   set {sapLisd.salesGrpValue = value;}}
    public String custGroup  {get {return sapLisd.custGroupValue;}  set {sapLisd.custGroupValue = value;}}
    public String sellerNum  {get {return sapLisd.sellerValue;}     set {sapLisd.sellerValue = value;}}
    
    public String sdhelp     {get {return sapLisd.helpText_sd;}  private set;}
    public String sohelp     {get {return sapLisd.helpText_so;}  private set;}
    public String sghelp     {get {return sapLisd.helpText_sg;}  private set;}
    public String cghelp     {get {return sapLisd.helpText_cg;}  private set;}

    public List<SelectOption> industries  {get {return sapLisd.industries;}  private set;}
    public List<SelectOption> endUseCusts {get {return sapLisd.endUseCusts;} private set;}
    public List<SelectOption> salesDsts   {get {return sapLisd.salesDsts;}   private set;}
    public List<SelectOption> salesOfcs   {get {return sapLisd.salesOfcs;}   private set;}
    public List<SelectOption> salesGrps   {get {return sapLisd.salesGrps;}   private set;}
    public List<SelectOption> custGroups  {get {return sapLisd.custGroups;}  private set;}
    public List<SelectOption> sellerOpts  {get {return sapLisd.sellerOpts;}  private set;}
    
    public Boolean readOnlyAC             {get {return sapLisd.readOnlyAC;} private set;}
    public Boolean readOnlyL1             {get {return sapLisd.readOnlyL1;} private set;}
    public Boolean readOnlyEC             {get {return sapLisd.readOnlyEC;} private set;}
    public Boolean readOnlySD             {get {return sapLisd.readOnlySD;} private set;}
    public Boolean readOnlySO             {get {return sapLisd.readOnlySO;} private set;}
    public Boolean readOnlySG             {get {return sapLisd.readOnlySG;} private set;}
    public Boolean readOnlyCG             {get {return sapLisd.readOnlyCG;} private set;}
    public Boolean readOnlySL             {get {return sapLisd.readOnlySL;} private set;}

    public String  accsarea               {get {return sapLisd.salesArea;} private set;}
    public Account acc                    {get {return sapLisd.acc;} private set;}
    public User seller                    {get {return sapLisd.seller;} private set;}

    public Contact con                    {get; private set;}
    public String  message1               {get; private set;}

    public Boolean renderLisds            {get; private set;}
    public Boolean renderMsg1             {get; private set;}

    public SAP_LISD_Controller() {
    	this(null);
    }
    
    public SAP_LISD_Controller(ApexPages.StandardController sc) {
    	debug('SAP_LISD_Controller.Constructor : begins');
        con = new Contact();
        PageReference pr = ApexPages.currentPage();
        if (pr != null) {
        	debug('pr.getParameters() : ' + pr.getParameters());
        	con.AccountId = pr.getParameters().get('accountId');
        }
        init1();
    }
    
    private void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);}
    
    private Boolean isNull(String s) {return String.isBlank(s);}
    
    private void init1() {
        accountId = con.AccountId; sapLisds = null;
        renderLisds = false; renderMsg1 = false;
    }
    public SAP_LISD getSapLisd() {return sapLisd;}
    public void setSapLisd(SAP_LISD sl) {
        debug('setSapLisd :      sl = ' + sl); 
        debug('setSapLisd : sapLisd = ' + sapLisd);
        if (sapLisd != null) {return;}
    	if (sl == null) {
    		sapLisd = new SAP_LISD(); setIndustries();
    	} else {sapLisd = sl;}
    }
    
    public Boolean getEnableAcc() {return enableAcc;}
    public void setEnableAcc(Boolean b) {
    	if (enableAcc != null) {return;}
    	if (b == null) {enableAcc = true;} else {enableAcc = b;}
    }

    public Boolean getShowLisds() {return showLisds;}
    public void setShowLisds(Boolean b) {
        if (showLisds != null) {return;}
        if (b == null) {showLisds = false;} else {showLisds = b;}
        setSapLisds();
    }

    public void setIndustries() {
        init1(); if (sapLisd == null) {return;}
        sapLisd.setIndustries(accountId, !enableAcc); setSapLisds();
    }
    
    public void setEndUseCusts() {
    	sapLisd.setEndUseCusts(); setSapLisds();
    }
    
    public void setSalesDsts() {
    	sapLisd.setSalesDsts(); setSapLisds();
    }
    
    public void setSalesOfcs() {
        sapLisd.setSalesOfcs(); setSapLisds();
    }
    
    public void setSalesGrps() {
        sapLisd.setSalesGrps(); setSapLisds();
    }

    public void setCustGroups() {
        sapLisd.setCustGroups(); setSapLisds();
    }

    public void setSellerOpts() {
        sapLisd.setSellerOpts(); setSapLisds();
    }

    public void setSapLisds() {
        init1(); if (accountId == null || sapLisd == null || isNull(sellerNum)) {return;}
        sapLisd.setSeller();
        if (showLisds == null || !showLisds) {return;}
       	sapLisds = SAP_LISD_Functions.getAccountLisds(accountId);
        renderLisds = (sapLisds != null && !sapLisds.isEmpty());
        if (!renderLisds) {
            message1 = 'No LISDs found for the selected Account'; renderMsg1 = true;
        }
    }
    
}