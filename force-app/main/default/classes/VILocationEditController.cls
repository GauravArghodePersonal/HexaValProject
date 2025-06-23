public with sharing class VILocationEditController {
    public static final String PARAM_LOCATION_ID = 'id';
    public static final String PARAM_FACILITY_ID = 'facilityId';
    public static final String PARAM_RETURN_URL = 'retURL';

    private static final String ERROR_ENTER_A_VALUE = 'You must enter a value';
    private static final String ERROR_MISSING_REQUIRED_FIELDS = 'Please enter a value for all required fields';

    private final VIInputField name = new VIInputField();
    private final VIInputField aviLocatorName = new VIInputField();
    private final VIInputField billingStreet = new VIInputField();
    private final VIInputField billingCity = new VIInputField();
    private final VIInputField billingState = new VIInputField();
    private final VIInputField billingPostalCode = new VIInputField();
    private final VIInputField phone = new VIInputField();
    private final VIInputField fax = new VIInputField();
    private final VIInputField website = new VIInputField();
    private final VIInputField active = new VIInputField('Yes');

    public VIInputField storeHoursMonOpen {get; private set;}
    public VIInputField storeHoursTueOpen {get; private set;}
    public VIInputField storeHoursWedOpen {get; private set;}
    public VIInputField storeHoursThuOpen {get; private set;}
    public VIInputField storeHoursFriOpen {get; private set;}
    public VIInputField storeHoursSatOpen {get; private set;}
    public VIInputField storeHoursSunOpen {get; private set;}

    public VIInputField storeHoursMonClose {get; private set;}
    public VIInputField storeHoursTueClose {get; private set;}
    public VIInputField storeHoursWedClose {get; private set;}
    public VIInputField storeHoursThuClose {get; private set;}
    public VIInputField storeHoursFriClose {get; private set;}
    public VIInputField storeHoursSatClose {get; private set;}
    public VIInputField storeHoursSunClose {get; private set;}

    public VIInputField estimateGallons    {get; private set;}
    public VIInputField maxlifeVolPercent  {get; private set;}
    public VIInputField oilChangePercent   {get; private set;}
    public VIInputField synpowerPercent    {get; private set;}
    public VIInputField vpsPercent         {get; private set;}
    public VIInputField wiperBladesPercent {get; private set;}

    private Id userId = UserInfo.getUserId();
    private Boolean portalUser = VIUtils.isPortalUser();
    private String facilityId;
    private String facilityName;
    private String locationId;
    private Account facility;
    private Account location;
    private Boolean readOnly = false;
    private String returnURL;

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'VILocationEditController : ' + s);}

    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}

    public VIInputField getName() {return name;}

    public VIInputField getAviLocatorName() {return aviLocatorName;}

    public VIInputField getBillingStreet() {return billingStreet;}

    public VIInputField getBillingCity() {return billingCity;}

    public VIInputField getBillingState() {return billingState;}

    public VIInputField getBillingPostalCode() {return billingPostalCode;}

    public VIInputField getPhone() {return phone;}

    public VIInputField getFax() {return fax;}

    public VIInputField getWebsite() {return website;}

    public VIInputField getActive() {return active;}

    public String getFacilityId() {return facilityId;}

    public String getFacilityName() {return facilityName;}

    public String getLocationId() {return locationId;}

    public Account getLocation() {return location;}

    public Boolean getReadOnly() {return readOnly;}

    public List<SelectOption> getStoreHourOptions() {
        return VIUtils.STORE_HOUR_SELECT_OPTIONS;
    }

    public void init() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        facilityId = params.get(PARAM_FACILITY_ID);
        locationId = params.get(PARAM_LOCATION_ID);
        returnURL = params.get(PARAM_RETURN_URL);

        storeHoursMonOpen = new VIInputField();
        storeHoursTueOpen = new VIInputField();
        storeHoursWedOpen = new VIInputField();
        storeHoursThuOpen = new VIInputField();
        storeHoursFriOpen = new VIInputField();
        storeHoursSatOpen = new VIInputField();
        storeHoursSunOpen = new VIInputField();

        storeHoursMonClose = new VIInputField();
        storeHoursTueClose = new VIInputField();
        storeHoursWedClose = new VIInputField();
        storeHoursThuClose = new VIInputField();
        storeHoursFriClose = new VIInputField();
        storeHoursSatClose = new VIInputField();
        storeHoursSunClose = new VIInputField();

        estimateGallons    = new VIInputField();
        maxlifeVolPercent  = new VIInputField();
        oilChangePercent   = new VIInputField();
        synpowerPercent    = new VIInputField();
        vpsPercent         = new VIInputField();
        wiperBladesPercent = new VIInputField();

        location = null;
        if ((locationId != null) && (facilityId != null)) {
            List<Account> locations = [SELECT Id, ParentId, Name, Phone, Fax, Website,
                    BillingStreet, BillingCity, BillingState, BillingPostalCode,
                    AVI_Locator_Name__c, Inactive_Account__c, SAP_Customer_Number__c
                    //,
                    //VI_Store_Hours_Mon_Open__c, 
                    //VI_Store_Hours_Mon_Close__c,
                    //VI_Store_Hours_Tue_Open__c, 
                    //VI_Store_Hours_Tue_Close__c,
                    //VI_Store_Hours_Wed_Open__c, 
                    //VI_Store_Hours_Wed_Close__c,
                    //VI_Store_Hours_Thu_Open__c, 
                    //VI_Store_Hours_Thu_Close__c,
                    //VI_Store_Hours_Fri_Open__c, 
                    //VI_Store_Hours_Fri_Close__c,
                    //VI_Store_Hours_Sat_Open__c, 
                    //VI_Store_Hours_Sat_Close__c,
                    //VI_Store_Hours_Sun_Open__c, 
                    //VI_Store_Hours_Sun_Close__c,
                    //VI_Estimate_Annual_Gallons__c,
                   //VI_MaxLife_Volume_Percent__c,
                    //VI_Oil_Change_Percent__c,
                    //VI_SynPower_Volume_Percent__c
                    //VI_VPS_Percent__c,
                   // VI_Wiper_Blades_Percent__c
                    FROM Account
                    WHERE Id = :locationId
                    AND ParentId = :facilityId
                    AND VI_Account_Type__c = :VIUtils.ACCOUNT_TYPE_LOCATION
                    ];

            if (!locations.isEmpty()) {
                location = locations.get(0);
                name.setValue(location.Name);
                String aln = location.AVI_Locator_Name__c;
                if (aln == null || aln.trim().length() == 0) {
                    aln = location.Name;
                }
                aviLocatorName.setValue(aln);
                billingStreet.setValue(location.BillingStreet);
                billingCity.setValue(location.BillingCity);
                billingState.setValue(location.BillingState);
                billingPostalCode.setValue(location.BillingPostalCode);
                phone.setValue(location.Phone);
                fax.setValue(location.Fax);
                website.setValue(location.Website);
                active.setValue(location.Inactive_Account__c ? 'No' : 'Yes');

               // storeHoursMonOpen.setValue(location.VI_Store_Hours_Mon_Open__c);
                //storeHoursTueOpen.setValue(location.VI_Store_Hours_Tue_Open__c);
                //storeHoursWedOpen.setValue(location.VI_Store_Hours_Wed_Open__c);
                //storeHoursThuOpen.setValue(location.VI_Store_Hours_Thu_Open__c);
               // storeHoursFriOpen.setValue(location.VI_Store_Hours_Fri_Open__c);
                //storeHoursSatOpen.setValue(location.VI_Store_Hours_Sat_Open__c);
               // storeHoursSunOpen.setValue(location.VI_Store_Hours_Sun_Open__c);

               // storeHoursMonClose.setValue(location.VI_Store_Hours_Mon_Close__c);
                //storeHoursTueClose.setValue(location.VI_Store_Hours_Tue_Close__c);
                //storeHoursWedClose.setValue(location.VI_Store_Hours_Wed_Close__c);
                //storeHoursThuClose.setValue(location.VI_Store_Hours_Thu_Close__c);
                //storeHoursFriClose.setValue(location.VI_Store_Hours_Fri_Close__c);
                //storeHoursSatClose.setValue(location.VI_Store_Hours_Sat_Close__c);
                //storeHoursSunClose.setValue(location.VI_Store_Hours_Sun_Close__c);

                //estimateGallons.setDecimal(location.VI_Estimate_Annual_Gallons__c);
                //maxlifeVolPercent.setDecimal(location.VI_MaxLife_Volume_Percent__c);
                //oilChangePercent.setDecimal(location.VI_Oil_Change_Percent__c);
                //synpowerPercent.setDecimal(location.VI_SynPower_Volume_Percent__c);
                //vpsPercent.setDecimal(location.VI_VPS_Percent__c);
                //wiperBladesPercent.setDecimal(location.VI_Wiper_Blades_Percent__c);

                facilityId = location.ParentId;
                readOnly = (location.SAP_Customer_Number__c != null);
            }
        }
        if (location == null) 
        {
            location = new Account();
                              
        }

        /*facility = null;
        if (facilityId != null) {
            facility = VIUtils.getFacility(facilityId);
            facilityName = facility.Name;
        }*/

    }

    public PageReference save() {
        List<VIInputField> requiredFields = new List<VIInputField>();
        requiredFields.add(active);
        requiredFields.add(name);
        requiredFields.add(billingStreet);
        requiredFields.add(billingCity);
        requiredFields.add(billingState);
        requiredFields.add(billingPostalCode);
        requiredFields.add(phone);

        Boolean missingRequiredFields = false;
        for (VIInputField requiredField : requiredFields) {
            if (requiredField.getValue() == null) {
                missingRequiredFields = true;
                requiredField.setError(ERROR_ENTER_A_VALUE);
            }
        }

        if (missingRequiredFields) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    ERROR_MISSING_REQUIRED_FIELDS));
            return null;
        }

        PageReference pageRef = null;
        Savepoint sp = Database.setSavepoint();
        try {
            List<String> addressLines = Address_Functions.convert1LineAddressto4(billingStreet.getValue());
            while (addressLines.size() < 4) {
                addressLines.add(null);
            }

            Boolean isNew = (location.Id == null);
            if (isNew) {
                List<RecordType> recordTypes = [SELECT Id
                        FROM RecordType
                        WHERE IsActive = TRUE
                        AND SobjectType = 'Account'
                        AND Name = :VIUtils.ACCOUNT_RECORD_TYPE_PROSPECT];

                if (!recordTypes.isEmpty()) {
                    location.RecordTypeId = recordTypes.get(0).Id;
                }

                location.ParentId = facility.Id;
                location.OwnerId = facility.OwnerId;
                //location.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_LOCATION;
            }
            location.Name = name.getValue();
            location.AVI_Locator_Name__c = aviLocatorName.getValue();
            location.BillingStreet = billingStreet.getValue();
            location.BillingCity = billingCity.getValue();
            location.BillingState = billingState.getValue();
            location.BillingPostalCode = billingPostalCode.getValue();
            location.SAP_Street__c = addressLines.get(0);
            location.SAP_StreetSuppl1__c = addressLines.get(1);
            location.SAP_StreetSuppl2__c = addressLines.get(2);
            location.SAP_StreetSuppl3__c = addressLines.get(3);
            location.SAP_City__c = billingCity.getValue();
            location.SAP_State__c = billingState.getValue();
            location.SAP_Zip_Code__c = billingPostalCode.getValue();
            location.Phone = phone.getValue();
            location.Fax = fax.getValue();
            location.Website = website.getValue();
            location.Inactive_Account__c = 'No'.equalsIgnoreCase(active.getValue());

            //location.VI_Store_Hours_Mon_Open__c = storeHoursMonOpen.getValue();
            //location.VI_Store_Hours_Tue_Open__c = storeHoursTueOpen.getValue();
            //location.VI_Store_Hours_Wed_Open__c = storeHoursWedOpen.getValue();
            //location.VI_Store_Hours_Thu_Open__c = storeHoursThuOpen.getValue();
            //location.VI_Store_Hours_Fri_Open__c = storeHoursFriOpen.getValue();
            //location.VI_Store_Hours_Sat_Open__c = storeHoursSatOpen.getValue();
            //location.VI_Store_Hours_Sun_Open__c = storeHoursSunOpen.getValue();

            //location.VI_Store_Hours_Mon_Close__c = storeHoursMonClose.getValue();
            //location.VI_Store_Hours_Tue_Close__c = storeHoursTueClose.getValue();
            //location.VI_Store_Hours_Wed_Close__c = storeHoursWedClose.getValue();
            //location.VI_Store_Hours_Thu_Close__c = storeHoursThuClose.getValue();
            //location.VI_Store_Hours_Fri_Close__c = storeHoursFriClose.getValue();
            //location.VI_Store_Hours_Sat_Close__c = storeHoursSatClose.getValue();
            //location.VI_Store_Hours_Sun_Close__c = storeHoursSunClose.getValue();

            //location.VI_Estimate_Annual_Gallons__c = estimateGallons.getDecimal();
           //location.VI_MaxLife_Volume_Percent__c  = maxlifeVolPercent.getDecimal();
            //location.VI_Oil_Change_Percent__c      = oilChangePercent.getDecimal();
           //location.VI_SynPower_Volume_Percent__c = synpowerPercent.getDecimal();
            //location.VI_VPS_Percent__c             = vpsPercent.getDecimal();
           // location.VI_Wiper_Blades_Percent__c    = wiperBladesPercent.getDecimal();

            Boolean submitForApproval = isAccountNeedsToBeApproved(location);

            upsert location;

            if (submitForApproval) {submitForApproval(location);}

            pageRef = cancel();
            if (isNew) {
                pageRef.getParameters().put(VILocationListController.PARAM_SHOW_MSG1,
                                            VILocationListController.PARAM_VALUE_YES);
            }
        }
        catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessages(e);
        }

        return pageRef;
    }

    public Boolean isAccountNeedsToBeApproved(Account acc) {
        return (acc.Id == null && portalUser && acc.OwnerId != userId);
    }

    public void submitForApproval(Account acc) {
        String s1 = 'Submitting New Installer for Approval';
        String s2 = s1 + ' Failed : ';
        try {Custom_Approval_Functions.submitForApproval(acc.Id, s1);}
        catch(Exception e) {
            debug('submitForApproval : ' + s2 + e.getMessage());
            throw new CustomException(s2);
        }
    }

    /**
    * Return to the facility list page without saving any changes.
    */
    public PageReference cancel() {
        PageReference pageRef = Page.VILocationList2;
        pageRef.getParameters().put(VILocationListController.PARAM_FACILITY_ID, facilityId);
        if (!isNull(returnURL)) {pageRef = new PageReference(returnURL);}
        //pageRef.setRedirect(true);
        return pageRef;
    }
}