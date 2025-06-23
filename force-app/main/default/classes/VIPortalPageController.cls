public class VIPortalPageController {

    public static final String CLASS_NAME   = 'VIPortalPageController';

    public static final String TOP_IMG_1    = 'img/Top_Image_HomePage.png';
    public static final String TOP_IMG_2    = 'img/Top_Image.png';

    public static final String TB_IMG_HPAGE = 'img/TopBar_HomePage.jpg';
    public static final String TB_IMG_ASC   = 'img/TopBar_ASC.jpg';
    public static final String TB_IMG_CDLER = 'img/TopBar_CarDealer.jpg';
    public static final String TB_IMG_ECARE = 'img/TopBar_ExpressCare.jpg';
    public static final String TB_IMG_QLUBE = 'img/TopBar_QuickLube.jpg';

    public static final Map<String, String> TOP_BAR_IMAGES = new Map<String, String>{
        VIUtils.CHANNEL_ASC                   => TB_IMG_ASC,
        VIUtils.CHANNEL_CAR_DEALER            => TB_IMG_CDLER,
        VIUtils.CHANNEL_QUICKLUBE             => TB_IMG_QLUBE,
        VIUtils.CHANNEL_QUICKLUBE_EXPRESSCARE => TB_IMG_ECARE,
        VIUtils.SAP_CUST_GROUP_5_EXPRESSCARE  => TB_IMG_ECARE
    };

    public static final ApexPages.Severity INFO  = ApexPages.Severity.INFO;

    public Boolean renderDefaultBanner {get; set;}
    public Boolean renderTopImage      {get; set;}
    public Boolean renderMenuBtns      {get; set;}
    public Boolean showDebugMsgs       {get; set;}

    public Integer headerHeight        {get; set;}

    public String  topBarImage         {get; set;}
    public String  topImage            {get; set;}

    public Boolean customerPortal      {get; private set;}

    public String  accountId           {get; private set;}
    public String  channel             {get; private set;}
    public String  homePageUrl         {get; private set;}
    public String  locationsUrl        {get; private set;}
    public String  promotionsUrl       {get; private set;}
    public String  username            {get; private set;}

    private Account acc;

    private Id portalAccountId = VIUtils.getPortalAccountId();

    transient List<String> debugMsgs = new List<String>();

    public VIPortalPageController() {
        init(); addDebugMsgs();
    }

    private void debug(String s) {
        if (debugMsgs == null) {debugMsgs = new List<String>();}
        s = CLASS_NAME + ' : ' + (debugMsgs.size() + 1) + ' : ' + s;
        System.debug(LoggingLevel.INFO, s); addDebugMsg(s);
    }

    private void addDebugMsgs() {
        if (debugMsgs == null) {return;}
        for (String s : debugMsgs) {addInfoMsg(s);}
    }

    private void addDebugMsg(String s) {
        if (showDebugMsgs != null && showDebugMsgs) {debugMsgs.add(s);}
    }

    @TestVisible
    private void addInfoMsg(String s) {addMsg(INFO,  s);}

    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }

    private void init() {
        showDebugMsgs = false; debug('init');
        username = UserInfo.getUserName(); homePageUrl = VIUtils.URL_HOME;
        locationsUrl = homePageUrl; promotionsUrl = homePageUrl;
        topBarImage = TB_IMG_HPAGE; topImage = TOP_IMG_1;
        renderDefaultBanner = true;
        renderMenuBtns = (portalAccountId != null);
        customerPortal = VIUtils.isCustomerPortalUser();
    }

    private Boolean equal(String s1, String s2) {
        return (s1 == null && s2 == null) ||
            (s1 != null && s2 != null && s1 == s2);
    }

    public String getAccountId() {return accountId;}

    public void setAccountId(String s) {
        debug('accountId = ' + accountId + ' : s = ' + s);
        if (equal(accountId, s)) {return;} accountId = s;
        homePageUrl = VIUtils.getHomePageUrl(accountId);
        locationsUrl = VIUtils.getLocationsUrl(accountId);
        promotionsUrl = VIUtils.getPromotionsUrl(accountId);
        if (String.isBlank(channel)) {channel = VIUtils.getChannel(accountId);}
        if (String.isBlank(channel)) {return;} else {
            topImage = TOP_IMG_2;
            if (TOP_BAR_IMAGES.containsKey(channel)) {
                topBarImage = TOP_BAR_IMAGES.get(channel);
            }
        }
        renderDefaultBanner = TB_IMG_HPAGE.equals(topBarImage);
    }

    public PageReference gotoHomePage() {return new PageReference(homePageUrl);}

    public PageReference gotoPromotions() {return new PageReference(promotionsUrl);}

    public PageReference gotoLocations() {return new PageReference(locationsUrl);}

    public PageReference gotoLogout() {return new PageReference(VIUtils.URL_LOGOUT);}

}