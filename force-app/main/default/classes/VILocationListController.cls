public with sharing class VILocationListController {
    public static final String PARAM_FACILITY_ID = VIUtils.PARAM_FACILITY_ID;
    public static final String PARAM_LOCATION_NAME = 'location';
    public static final String PARAM_CITY = 'city';
    public static final String PARAM_STATE = 'state';
    public static final String PARAM_POSTAL_CODE = 'zip';
    public static final String PARAM_STATUS = 'status';
    public static final String PARAM_RETURN_URL = 'retURL';

    public static final String PARAM_VALUE_YES = 'y';
    public static final String PARAM_SHOW_MSG1 = 'msg1';
    public static final String MSG1 = 'Location is added and it will be active after it is approved by the Sales Rep.';

    public static final Integer DEFAULT_MAX_SEARCH_RESULTS = 50;

    private static final String DATE_TIME_FMT1 = 'yyyy-MM-dd HH:mm:ss';
    private static final String          UTF_8 = VIUtils.UTF_8;
    private static final String BIW_CRYPTO_KEY = VIUtils.BIW_CRYPTO_KEY;
    private static final String BIW_INIT_VECTR = VIUtils.BIW_INIT_VECTOR;
    private static final String BIW_SECRET_KEY = VIUtils.BIW_SECRET_KEY;

    private static final ApexPages.Severity INFO = ApexPages.Severity.INFO;

    // Fields
    private Integer maxSearchResults = DEFAULT_MAX_SEARCH_RESULTS;
    private final VIInputField locationName = new VIInputField();
    private final VIInputField city = new VIInputField();
    private final VIInputField state = new VIInputField();
    private final VIInputField postalCode = new VIInputField();
    private final VIInputField status = new VIInputField('No');
    private String thisURL;
    private String returnURL;
    private Boolean canEditLocation;
    private Id facilityId;
    private String facilityName;
    private List<Account> locations = new List<Account>();
    private List<VIAccount> viAccounts;
    public VIAccount viFacility    {get; private set;}

    public Boolean isExpresCare    {get; private set;}
    public Boolean isVperksUser    {get; private set;}
    public Boolean showDbugMsgs    {get; private set;}

    public String biwUrl           {get; private set;}

    public String biwHashStringEnc {get; private set;}
    public String biwHashStringTxt {get; private set;}

    public String biwTimestampEnc  {get; private set;}
    public String biwTimestampTxt  {get; private set;}

    public String biwUniqueIdEnc   {get; private set;}
    public String biwUniqueIdTxt   {get; private set;}

    public String accNum           {get; set;}

    Account facility;

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'VILocationListController : ' + s);}

    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}

    private void addInfoMsg(String s) {addMsg(INFO, s);}

    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }

    public Integer getMaxSearchResults() {return maxSearchResults;}

    public void setMaxSearchResults(Integer maxSearchResults) {this.maxSearchResults = maxSearchResults;}

    public VIInputField getLocationName() {return locationName;}

    public VIInputField getCity() {return city;}

    public VIInputField getState() {return state;}

    public VIInputField getPostalCode() {return postalCode;}

    public VIInputField getStatus() {return status;}

    public String getThisURL() {return thisURL;}

    public Boolean getCanEditLocation() {return canEditLocation;}

    public Id getFacilityId() {return facilityId;}

    public String getFacilityName() {return facilityName;}

    public List<Account> getLocations() {return locations;}

    public List<VIAccount> getViAccounts() {return viAccounts;}

    public void init() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        returnURL = params.get(PARAM_RETURN_URL);
        canEditLocation = true;

        isVperksUser = VIUtils.isVperksUser();
        facility = VIUtils.getFacility(params);
        if (facility != null) {
            facilityId = facility.Id;
            facilityName = facility.Name;
            viFacility = new VIAccount(facility);
        }
        isExpresCare = VIUtils.isExpressCare(facility);

        locationName.setValue(params.get(PARAM_LOCATION_NAME));
        city.setValue(params.get(PARAM_CITY));
        state.setValue(params.get(PARAM_STATE));
        postalCode.setValue(params.get(PARAM_POSTAL_CODE));
        if (params.containsKey(PARAM_STATUS)) {
            status.setValue(params.get(PARAM_STATUS));
        }

        searchLocations();

        if (params.containsKey(PARAM_SHOW_MSG1)) {
            String t = params.get(PARAM_SHOW_MSG1);
            if (t != null && t.equals(PARAM_VALUE_YES)) {addInfoMsg(MSG1);}
        }
    }

    public void searchLocations() {
        calcThisURL();

        locations = new List<Account>();
        if (facilityId == null) {return;}

        String soql = 'SELECT Id, Name,  AccountNumber, ParentId, '
                + ' AVI_Locator_Name__c, Inactive_Account__c,'
                + ' SAP_Customer_Number__c, VI_Account_Type__c, Phone, Fax, Website,'
                + ' BillingStreet, BillingCity, BillingState, BillingPostalCode'
                + ' FROM Account'
                + ' WHERE ParentId = \'' + facilityId + '\''
                + ' AND VI_Account_Type__c = \'' + VIUtils.ACCOUNT_TYPE_LOCATION + '\'';

        soql += filter('Name', locationName.getValue());
        soql += filter('BillingCity', city.getValue());
        soql += filter('BillingState', state.getValue());
        soql += filter('BillingPostalCode', postalCode.getValue());
        if ('Yes'.equalsIgnoreCase(status.getValue())) {
            soql += ' AND Inactive_Account__c = TRUE';
        } else if ('No'.equalsIgnoreCase(status.getValue())) {
            soql += ' AND Inactive_Account__c = FALSE';
        }
        soql += ' ORDER BY Name';
        soql += ' LIMIT ' + String.valueOf(maxSearchResults + 1);

        try {
            locations = Database.query(soql);
            createViAccounts(locations);
        } catch (Exception e) {ApexPages.addMessages(e);}
    }

    private void createViAccounts(List<Account> alist) {
        viAccounts = new List<VIAccount>();    VIAccount va;
        for (Account a : alist) {
            va = new VIAccount(a); viAccounts.add(va);
        }
    }

    private String filter(String fieldName, String fieldValue) {
        String s = '';
        if (fieldValue != null) {
            s = ' AND ' + fieldName + ' LIKE \'%' + String.escapeSingleQuotes(fieldValue) + '%\'';
        }
        return s;
    }

    private void calcThisURL() {
        PageReference pageRef = Page.VILocationList2;
        pageRef.getParameters().put(PARAM_FACILITY_ID, facilityId);
        pageRef.getParameters().put(PARAM_LOCATION_NAME, locationName.getValue());
        pageRef.getParameters().put(PARAM_CITY, city.getValue());
        pageRef.getParameters().put(PARAM_STATE, state.getValue());
        pageRef.getParameters().put(PARAM_POSTAL_CODE, postalCode.getValue());
        pageRef.getParameters().put(PARAM_STATUS, status.getValue());
        //pageRef.getParameters().put(PARAM_RETURN_URL, returnURL);

        thisURL = pageRef.getUrl();
    }

    public PageReference cancel() {
        //PageReference pageRef = new PageReference('/home/home.jsp');
        PageReference pageRef = null;
        if (!isNull(returnURL)) {pageRef = new PageReference(returnURL);}
        //pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference newLocation() {
        PageReference pageRef = Page.VILocationEdit2;
        pageRef.getParameters().put(VILocationEditController.PARAM_FACILITY_ID, facilityId);
        //pageRef.getParameters().put(VILocationEditController.PARAM_RETURN_URL,
        //        EncodingUtil.urlEncode(thisURL, UTF_8));
        //pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference gotoBiwPage() {
        if (isNull(accNum)) {return null;} biwUniqueIdTxt = accNum;
        biwUrl = VIUtils.BIW_URL; showDbugMsgs = VIUtils.SHOW_DEBUG_MSGS;
        //biwUniqueIdTxt = 'cheritest1';
        biwUniqueIdEnc = VIUtils.getEncrypted256(BIW_CRYPTO_KEY, BIW_INIT_VECTR, biwUniqueIdTxt);
        biwTimestampTxt = DateTime.now().formatGmt(DATE_TIME_FMT1);
        // biwTimestampTxt = '2013-11-12 16:37:00';
        biwTimestampEnc = VIUtils.getEncrypted256(BIW_CRYPTO_KEY, BIW_INIT_VECTR, biwTimestampTxt);
        biwHashStringTxt = (biwUniqueIdTxt + biwTimestampTxt + BIW_SECRET_KEY).toUpperCase();
        biwHashStringEnc = VIUtils.getDigestMD5(biwHashStringTxt);
        return Page.VI_BIW_Page;
    }

    public PageReference gotoBrandMusclePage() {
        if (isNull(accNum)) {return null;}
        return VIUtils.getBrandMusclePageRef(accNum);
    }
}