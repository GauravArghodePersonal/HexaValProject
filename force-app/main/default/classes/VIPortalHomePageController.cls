public class VIPortalHomePageController {

    public static final String BASEURL = URL.getSalesforceBaseUrl().toExternalForm();

    public static final String PARAM_ID = VIUtils.PARAM_ID;

    public static final ApexPages.Severity INFO  = ApexPages.Severity.INFO;

    public Account facility      {get; private set;}
    public String  accountId     {get; private set;}

    public Boolean renderMoney   {get; private set;}
    public Boolean renderPOS     {get; private set;}
    public Boolean renderVPerk   {get; private set;}
    public Boolean showDebugMsgs {get; private set;}

    transient List<String> debugMsgs = new List<String>();

    public VIPortalHomePageController() {init1();}

    private void debug(String s) {
        if (debugMsgs == null) {debugMsgs = new List<String>();}
        s = 'VIPortalHomePageController : ' + (debugMsgs.size() + 1) + ' : ' + s;
        System.debug(LoggingLevel.INFO, s); addDebugMsg(s);
    }

    private void addDebugMsg(String s) {
        if (showDebugMsgs != null && showDebugMsgs) {debugMsgs.add(s);}
    }

    private void addDebugMsgs() {
        if (debugMsgs == null) {return;}
        for (String s : debugMsgs) {addInfoMsg(s);}
    }

    @TestVisible
    private void addInfoMsg(String s) {addMsg(INFO,  s);}

    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }

    public PageReference initAction() {
        String homePageUrl = VIUtils.getHomePageUrl(); addDebugMsgs();
        if (homePageUrl == null ||
            homePageUrl.startsWith(VIUtils.URL_VIHOME)) {return null;}
        return new PageReference(homePageUrl);
    }

    private void init1() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        showDebugMsgs = VIUtils.showDebugMsgs(params);
        accountId = VIUtils.getPortalAccountId();
        if (accountId == null) {accountId = params.get(PARAM_ID);}
        debug('init1 : accountId = ' + accountId);
        facility = VIUtils.getFacility(params);
        renderMoney = (facility != null);
        renderVPerk = VIUtils.isVperksUser();
        renderPOS = VIUtils.isDistributor(accountId);
    }
}