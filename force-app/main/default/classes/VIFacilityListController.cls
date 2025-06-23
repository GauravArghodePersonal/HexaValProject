public with sharing class VIFacilityListController {

    public static final String PARAM_DISTRIBUTOR_ID = 'id';
    public static final String PARAM_ACCOUNT_NUMBER = 'accountNum';
    public static final String PARAM_FACILITY_NAME = 'facility';
    public static final String PARAM_CITY = 'city';
    public static final String PARAM_STATE = 'state';
    public static final String PARAM_POSTAL_CODE = 'zip';
    public static final String PARAM_STATUS = 'status';
    public static final String PARAM_RETURN_URL = 'retURL';

    public static final Integer DEFAULT_MAX_SEARCH_RESULTS = 50;

    private final VIInputField accountNumber = new VIInputField();
    private final VIInputField facilityName = new VIInputField();
    private final VIInputField city = new VIInputField();
    private final VIInputField state = new VIInputField();
    private final VIInputField postalCode = new VIInputField();
    private final VIInputField status = new VIInputField('No');
    private String thisURL;
    private String returnURL;
    private Boolean canEditFacility;
    private Account distributor;
    private List<Account> facilities = new List<Account>();
    private List<VIAccount> viAccounts;

    public Integer maxSearchResults {get; set;}
    public String contactId         {get; private set;}
    public String distributorId     {get; private set;}

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'VIFLC : ' + s);}

    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}

    public VIInputField getAccountNumber() {return accountNumber;}

    public VIInputField getFacilityName() {return facilityName;}

    public VIInputField getCity() {return city;}

    public VIInputField getState() {return state;}

    public VIInputField getPostalCode() {return postalCode;}

    public VIInputField getStatus() {return status;}

    public String getThisURL() {return thisURL;}

    public Boolean getCanEditFacility() {return canEditFacility;}

    public Account getDistributor() {return distributor;}

    public List<Account> getFacilities() {return facilities;}

    public List<VIAccount> getViAccounts() {return viAccounts;}

    public void init() {
        maxSearchResults = DEFAULT_MAX_SEARCH_RESULTS;
        Map<String, String> params = ApexPages.currentPage().getParameters();
        returnURL = params.get(PARAM_RETURN_URL);
        User usr = VIUtils.getUser(UserInfo.getUserName());
        contactId = usr.ContactId;

        distributorId = VIUtils.getPortalAccountId();
        if (distributorId == null) {distributorId = params.get(PARAM_DISTRIBUTOR_ID);}
        if (distributorId != null) {
            List<Account> distributors = [SELECT Id, Name
                    FROM Account
                    WHERE Id = :distributorId
                    AND VI_Account_Type__c = :VIUtils.ACCOUNT_TYPE_DISTRIBUTOR];

            if (!distributors.isEmpty()) {
                distributor = distributors.get(0);
            }
        }

        setFieldFromParam(accountNumber, params, PARAM_ACCOUNT_NUMBER);
        setFieldFromParam(facilityName, params, PARAM_FACILITY_NAME);
        setFieldFromParam(city, params, PARAM_CITY);
        setFieldFromParam(state, params, PARAM_STATE);
        setFieldFromParam(postalCode, params, PARAM_POSTAL_CODE);
        setFieldFromParam(status, params, PARAM_STATUS);

        calcThisURL();

        Set<String> criteriaParams = new Set<String>();
        criteriaParams.add(PARAM_ACCOUNT_NUMBER);
        criteriaParams.add(PARAM_FACILITY_NAME);
        criteriaParams.add(PARAM_CITY);
        criteriaParams.add(PARAM_STATE);
        criteriaParams.add(PARAM_POSTAL_CODE);
        criteriaParams.add(PARAM_STATUS);
        for (String criteriaParam : criteriaParams) {
            String value = params.get(criteriaParam);
            if ((value != null) && (value.trim().length() > 0)) {
                searchFacilities();
                break;
            }
        }
    }

    public void searchFacilities() {
        calcThisURL();

        String soql = 'SELECT Id, AccountNumber, Name, ParentId, AVI_Locator_Name__c, '
                + ' Inactive_Account__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, '
                + ' SAP_Customer_Number__c, VI_Account_Type__c '
                + ' FROM Account'
                + ' WHERE ParentId = \'' + distributor.Id + '\''
                + ' AND VI_Account_Type__c = \'' + VIUtils.ACCOUNT_TYPE_FACILITY + '\'';

        soql += filter('AccountNumber', accountNumber.getValue());
        soql += filter('Name', facilityName.getValue());
        soql += filter('BillingCity', city.getValue());
        soql += filter('BillingState', state.getValue());
        soql += filter('BillingPostalCode', postalCode.getValue());
        if ('Yes'.equalsIgnoreCase(status.getValue())) {
            soql += ' AND Inactive_Account__c = TRUE';
        }
        else if ('No'.equalsIgnoreCase(status.getValue())) {
            soql += ' AND Inactive_Account__c = FALSE';
        }
        soql += ' ORDER BY Name';
        soql += ' LIMIT ' + String.valueOf(maxSearchResults + 1);
        debug('soql : ' + soql);
        try {
            facilities = Database.query(soql);
            createViAccounts(facilities);
        }
        catch (Exception e) {
            ApexPages.addMessages(e);
        }
    }

    private void createViAccounts(List<Account> alist) {
        viAccounts = new List<VIAccount>();
        VIAccount va;
        for (Account a : alist) {
            va = new VIAccount(a);
            viAccounts.add(va);
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
        PageReference pageRef = Page.VIFacilityList2;
        pageRef.getParameters().put(PARAM_ACCOUNT_NUMBER, accountNumber.getValue());
        pageRef.getParameters().put(PARAM_FACILITY_NAME, facilityName.getValue());
        pageRef.getParameters().put(PARAM_CITY, city.getValue());
        pageRef.getParameters().put(PARAM_STATE, state.getValue());
        pageRef.getParameters().put(PARAM_POSTAL_CODE, postalCode.getValue());
        pageRef.getParameters().put(PARAM_STATUS, status.getValue());
        //pageRef.getParameters().put(PARAM_RETURN_URL, returnURL);

        thisURL = pageRef.getUrl();
    }

    private void setFieldFromParam(VIInputField field, Map<String, String> params, String paramName) {
        if (params.containsKey(paramName)) {
            String paramValue = params.get(paramName);
            if (!isNull(paramValue)) {field.setValue(paramValue);}
        }
    }

    public PageReference cancel() {
        PageReference pageRef = null;
        if (!isNull(returnURL)) {pageRef = new PageReference(returnURL);}
        return pageRef;
    }

    public PageReference newFacility() {
        PageReference pageRef = Page.VIFacilityEdit2;
        return pageRef;
    }
}