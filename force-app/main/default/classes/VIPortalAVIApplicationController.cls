/**
 * Allows the user to submit an application for a location to become AVI certified.
 */
public with sharing class VIPortalAVIApplicationController {
    // Constants
    public static final String PARAM_ID = 'id';
    public static final String PARAM_TYPE = 'type';
    
    private static final String ERROR_ENTER_A_VALUE = 'You must enter a value';
    private static final String ERROR_MISSING_REQUIRED_FIELDS = 'Please enter a value for all required fields';
    
    // Fields
    private Account location;
    private final VI_AVI_Form__c application = new VI_AVI_Form__c();
    private VIInputField street = new VIInputField();
    private VIInputField city = new VIInputField();
    private VIInputField state = new VIInputField();
    private VIInputField postalCode = new VIInputField();
    private VIInputField phone = new VIInputField();
    private VIInputField fax = new VIInputField();
    private VIInputField website = new VIInputField();
    private Boolean userAccepted = false;
    private Boolean isPortalUser = false;
    private Id facilityId;
    private String facilityName;
    private String facilityChannel;
    private PageReference returnPageRef;
    
    Account facility; 
    
    /**
     * Gets the location.
     */
    public Account getLocation() {
        return location;
    }
    
    /**
     * Gets the AVI application.
     */
    public VI_AVI_Form__c getApplication() {
        return application;
    }
    
    /**
     * Gets the location's street address.
     */
    public VIInputField getStreet() {
        return street;
    }
    
    /**
     * Gets the location's city.
     */
    public VIInputField getCity() {
        return city;
    }
    
    /**
     * Gets the location's state.
     */
    public VIInputField getState() {
        return state;
    }
    
    /**
     * Gets the location's zip/postal code.
     */
    public VIInputField getPostalCode() {
        return postalCode;
    }
    
    /**
     * Gets the location's phone number.
     */
    public VIInputField getPhone() {
        return phone;
    }
    
    /**
     * Gets the location's fax number.
     */
    public VIInputField getFax() {
        return fax;
    }
    
    /**
     * Gets the location's website URL.
     */
    public VIInputField getWebsite() {
        return website;
    }
    
    /**
     * Gets a value that indicates whether the user has accepted the agreement.
     */
    public Boolean getUserAccepted() {
        return userAccepted;
    }
    
    /**
     * Sets a value that indicates whether the user has accepted the agreement.
     */
    public void setUserAccepted(Boolean userAccepted) {
        this.userAccepted = userAccepted;
    }
    
    public Id getFacilityId() {
        return facilityId;
    }
    
    /**
     * Gets the parent facility's name.
     */
    public String getFacilityName() {
        return facilityName;
    }
    
    /**
     * Gets the parent facility's channel.
     */
    public String getFacilityChannel() {
        return facilityChannel;
    }
    
    /**
     * Initializes the controller.
     */
    public void init() {
        isPortalUser = VIUtils.isPortalUser();
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String accid = params.get(PARAM_ID);
        String acctype = params.get(PARAM_TYPE);
        returnPageRef = new PageReference('/'+accid);
        if (isPortalUser) {returnPageRef = Page.VIPortalAVIStatus;}
        returnPageRef.setRedirect(true);
        // Get the location
        List<Account> locations = [SELECT Id, ParentId, Name, BillingStreet, BillingCity,
                BillingState, BillingPostalCode, Phone, Fax, Website, OwnerId
                //, VI_Channel__c
                FROM Account
                WHERE Id = :accid
                //AND VI_Account_Type__c = :acctype
                ];
        if (!locations.isEmpty()) {
            location = locations.get(0);

            if (VIUtils.ACCOUNT_TYPE_FACILITY.equalsIgnoreCase(acctype)) {
                facility = locations.get(0);
            } else if (VIUtils.ACCOUNT_TYPE_LOCATION.equalsIgnoreCase(acctype)) {
                facility = VIUtils.getFacility(location.ParentId);
            }

            if (facility != null) {
                facilityId = facility.Id;
                facilityName = facility.Name;
                //facilityChannel = facility.VI_Channel__c;
            }

            application.Location__c = location.Id;
            
            street.setValue(location.BillingStreet);
            city.setValue(location.BillingCity);
            state.setValue(location.BillingState);
            postalCode.setValue(location.BillingPostalCode);
            
            phone.setValue(location.Phone);
            fax.setValue(location.Fax);
            website.setValue(location.Website);
            
        }
    }
    
    /**
     * Submits the AVI application.
     */
    public PageReference submit() {
        // Ensure all requured fields contain a value
        List<VIInputField> requiredFields = new List<VIInputField>();
        requiredFields.add(street);
        requiredFields.add(city);
        requiredFields.add(state);
        requiredFields.add(postalCode);
        requiredFields.add(phone);
        
        Boolean missingRequiredFields = false;
        for (VIInputField requiredField : requiredFields) {
            if (requiredField.getValue() == null) {
                missingRequiredFields = true;
                requiredField.setError(ERROR_ENTER_A_VALUE);
            }
        }
        
        // If any required fields are empty, display an error and exit
        if (missingRequiredFields) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    ERROR_MISSING_REQUIRED_FIELDS));
            return null;
        }
        
        // Make sure the user accepted the agreement
        if (userAccepted != true) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'You must accept the agreement before you can submit the application.'));
            return null;
        }
        
        PageReference pageRef = null;
        Savepoint sp = Database.setSavepoint();
        try {
            // Update the location
            List<String> addressLines = Address_Functions.convert1LineAddressto4(street.getValue());
            while (addressLines.size() < 4) {
                addressLines.add(null);
            }
            
            location.BillingStreet = street.getValue();
            location.BillingCity = city.getValue();
            location.BillingState = state.getValue();
            location.BillingPostalCode = postalCode.getValue();
            location.SAP_Street__c = addressLines.get(0);
            location.SAP_StreetSuppl1__c = addressLines.get(1);
            location.SAP_StreetSuppl2__c = addressLines.get(2);
            location.SAP_StreetSuppl3__c = addressLines.get(3);
            location.SAP_City__c = city.getValue();
            location.SAP_State__c = state.getValue();
            location.SAP_Zip_Code__c = postalCode.getValue();
            location.Phone = phone.getValue();
            location.Fax = fax.getValue();
            location.Website = website.getValue();
            update location;
            
            // Insert the AVI Form record
            VI_AVI_Form__c clonedApplication = application.clone(false, false);
            clonedApplication.Approval_Status__c = VIUtils.AVI_STATUS_APPROVED;
            if (isPortalUser) {clonedApplication.Approval_Status__c = VIUtils.AVI_STATUS_SUBMITTED;}
            insert clonedApplication;
            
            if (isPortalUser) {
                // Submit the approval request for the AVI application
                Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
                request.setObjectId(clonedApplication.Id);
                request.setComments('Submitting AVI application for approval.');
                request.setNextApproverIds(new List<Id>{facility.OwnerId});
                
                Approval.ProcessResult result = Approval.process(request);
                if (!result.isSuccess()) {
                    // Approval submission failed
                    CustomException.throwException(
                            new List<String> { 'Failed to submit application for approval.' });
                }
            }
            
        }
        catch (Exception e) {
            // Rollback the transaction and display the error
            Database.rollback(sp);
            ApexPages.addMessages(e);
        }
        
        return returnPageRef;
    }
    
    /**
     * Cancels the application entry and return to the status page.
     */
    public PageReference cancel() {
        return returnPageRef;
    }
    
}