public without sharing class VISiteHomeController {

    private static final String RESULT_SUCCESS = 'success';
    private static final String RESULT_FAILURE = 'failure';

    private static final ApexPages.Severity INFO = ApexPages.Severity.INFO;

    public Boolean showDebugMsgs {get; set;}

    public String  username      {get; set;}
    public String  portalId      {get; set;}
    public String  loginResult   {get; set;}

    transient List<String> debugMsgs = new List<String>();

    public VISiteHomeController() {
        showDebugMsgs = VIUtils.SHOW_DEBUG_MSGS;
        debug('Constructor'); //addDebugMsgs();
    }

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

    private void addInfoMsg(String s) {addMsg(INFO,  s);}

    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }

    public void login() {
        loginResult = RESULT_FAILURE;

        VI_Portal_Settings__c settings = VI_Portal_Settings__c.getInstance();
        if (settings == null) {return;}
        String portalType = VILoginHelper.getPortalType(username);
        if (VIUtils.PORTAL_TYPE_CUSTOMER.equalsIgnoreCase(portalType)) {
            portalId = settings.Customer_Portal_ID__c;
            loginResult = RESULT_SUCCESS;
        } else
        if (VIUtils.PORTAL_TYPE_PARTNER.equalsIgnoreCase(portalType)) {
            portalId = settings.Partner_Portal_ID__c;
            loginResult = RESULT_SUCCESS;
        }
    }
}