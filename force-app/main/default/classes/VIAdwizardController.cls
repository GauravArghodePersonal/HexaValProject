public with sharing class VIAdwizardController {

    private static final String LOGIN_URL = VI_Portal_Settings__c.getInstance().Adwizard_Login_URL__c;
    private static final String USR_GROUP = VI_Portal_Settings__c.getInstance().Adwizard_User_Group__c;
    private static final String USR_GROUP_EC = 'Users/Expresscare';
    private static final String EXPRESS_CARE = 'EXPRESS CARE';

    // Constants
    public static final String PARAM_FACILITY_ID = 'facilityId';
    public static final String PARAM_LOCATION_NAME = 'location';
    public static final String PARAM_CITY = 'city';
    public static final String PARAM_STATE = 'state';
    public static final String PARAM_POSTAL_CODE = 'zip';
    public static final String PARAM_STATUS = 'status';
    public static final String PARAM_RETURN_URL = 'retURL';
    
    // Fields
    private final VIInputField locationName = new VIInputField();
    private final VIInputField city = new VIInputField();
    private final VIInputField state = new VIInputField();
    private final VIInputField postalCode = new VIInputField();
    private final VIInputField status = new VIInputField('No');

    public Integer currentStep {get; private set;}
    public String thisURL {get; private set;}
    public String returnURL {get; private set;}
    public Boolean canEditLocation {get; private set;}
    public Id facilityId {get; private set;}
    public String facilityName {get; private set;}
    public List<Account> locations {get; private set;}
    public Account facility {get; private set;}
    public User loggedInUser {get; private set;}
    public Boolean isExpressCare {get; private set;}

    public void initAction() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        returnURL = params.get(PARAM_RETURN_URL);
        loggedInUser = VIUtils.getUser(UserInfo.getUsername());
        
        if (!VIUtils.isPortalUser() || VIUtils.isPartnerPortalUser()) {
            // Non-portal users and partner portal users can add/edit locations
            canEditLocation = true;
            
            // Use facility ID param
            String id = params.get(PARAM_FACILITY_ID);
            if (id != null) {
                facility = VIUtils.getFacility(id);
                if (facility != null) {
                    facilityId = facility.Id;
                    facilityName = facility.Name;
                }
            }
        }
        else {
            // Customer portal users can only add/edit locations if they are at the facility level
            // and that facility is an off-book facility
            canEditLocation = false;
            
            String portalAccountType = VIUtils.getPortalAccountType();
            if (VIUtils.ACCOUNT_TYPE_FACILITY.equalsIgnoreCase(portalAccountType)) {
                // User's account is a facility
                facility = VIUtils.getFacility(VIUtils.getPortalAccountId());
                if (facility != null) {
                    facilityId = facility.Id;
                    facilityName = facility.Name;
                    canEditLocation = (facility.SAP_Customer_Number__c == null);
                }
            }
            else {
                // User's account is a location
                Account location = VIUtils.getLocation(VIUtils.getPortalAccountId());
                if (location != null) {
                    facility = VIUtils.getFacility(location.ParentId);
                    if (facility != null) {
                        facilityId = facility.Id;
                        facilityName = facility.Name;
                    }
                }
            }
        }
        
        // Read initial criteria values
        locationName.setValue(params.get(PARAM_LOCATION_NAME));
        city.setValue(params.get(PARAM_CITY));
        state.setValue(params.get(PARAM_STATE));
        postalCode.setValue(params.get(PARAM_POSTAL_CODE));
        if (params.containsKey(PARAM_STATUS)) {
            status.setValue(params.get(PARAM_STATUS));
        }
        isExpressCare = (facility != null && 
                         EXPRESS_CARE.equalsIgnoreCase(facility.SAP_Customer_Group_5_Desc__c));
    	step1();
    }
    
    public void step1() {
        currentStep = 1;
        calcThisURL();
        
        try {
            locations = VIUtils.getLocations(facility);
        }
        catch (Exception e) {
            ApexPages.addMessages(e);
        }
    }
    
    private void calcThisURL() {
        PageReference pageRef = Page.VIAdwizardPage;
        pageRef.getParameters().put(PARAM_FACILITY_ID, facilityId);
        pageRef.getParameters().put(PARAM_LOCATION_NAME, locationName.getValue());
        pageRef.getParameters().put(PARAM_CITY, city.getValue());
        pageRef.getParameters().put(PARAM_STATE, state.getValue());
        pageRef.getParameters().put(PARAM_POSTAL_CODE, postalCode.getValue());
        pageRef.getParameters().put(PARAM_STATUS, status.getValue());
        pageRef.getParameters().put(PARAM_RETURN_URL, returnURL);
        
        thisURL = pageRef.getUrl();
    }
    
    public PageReference step2() {
        currentStep = 2;
        String uname = UserInfo.getUserName();
        //uname = 'ghill@ashland.com'; // for testing
        String ugroup = USR_GROUP;
        if (isExpressCare) {ugroup = USR_GROUP_EC;}
        String loginUrl = LOGIN_URL + '?user=' + uname + '&group=' + ugroup;
        System.debug(loginUrl);
        PageReference pageRef = new PageReference(loginUrl);
        try {
            VIAdwizardFunctions.sendAddressesToAdwizard(locations, loggedInUser, loginUrl);
        } catch (Exception e) {
            ApexPages.addMessages(e);
            pageRef = ApexPages.currentPage();
        }
        return pageRef;
    }

}