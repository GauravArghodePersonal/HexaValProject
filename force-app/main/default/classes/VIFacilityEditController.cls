public with sharing class VIFacilityEditController {

    public static final String PARAM_FACILITY_ID = 'id';
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

    private Account distributor;
    private Account facility;
    private String facilityId;
    private String returnURL, thisURL;
    private Boolean readOnly = false;

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'VIFEC : ' + s);}

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

    public Account getDistributor() {return distributor;}

    public Account getFacility() {return facility;}

    public String getFacilityId() {return facilityId;}

        public Boolean getReadOnly() {return readOnly;}

    public List<SelectOption> getStoreHourOptions() {return VIUtils.STORE_HOUR_SELECT_OPTIONS;}

    public void init() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
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

        facility = new Account();
        facilityId = params.get(PARAM_FACILITY_ID);
        calcThisURL(); readOnly = false;
            if (facilityId != null) {
            List<Account> facilities = [SELECT Id, Name, ParentId, Phone, Fax, Website,
                    BillingStreet, BillingCity, BillingState, BillingPostalCode,
                    AVI_Locator_Name__c, Inactive_Account__c, SAP_Customer_Number__c
                    //,
                    //VI_Store_Hours_Mon_Open__c, VI_Store_Hours_Mon_Close__c,
                   // VI_Store_Hours_Tue_Open__c, 
                   //VI_Store_Hours_Tue_Close__c,
                    //VI_Store_Hours_Wed_Open__c, VI_Store_Hours_Wed_Close__c,
                    //VI_Store_Hours_Thu_Open__c, 
                    //VI_Store_Hours_Thu_Close__c,
                    //, VI_Store_Hours_Fri_Close__c,
                    //VI_Store_Hours_Sat_Open__c, 
                    //VI_Store_Hours_Sat_Close__c,
                    //VI_Store_Hours_Sun_Open__c, 
                    //VI_Store_Hours_Sun_Close__c,
                    //VI_Estimate_Annual_Gallons__c,
                   // VI_MaxLife_Volume_Percent__c,
                    //VI_Oil_Change_Percent__c,
                    //VI_SynPower_Volume_Percent__c,
                    //VI_VPS_Percent__c
                    //,
                    //VI_Wiper_Blades_Percent__c
                    FROM Account
                    WHERE Id = :facilityId
                    //AND VI_Account_Type__c = :VIUtils.ACCOUNT_TYPE_FACILITY
                    ];

            if (!facilities.isEmpty()) {
                facility = facilities.get(0);
                name.setValue(facility.Name);
                String aln = facility.AVI_Locator_Name__c;
                if (aln == null || aln.trim().length() == 0) {
                    aln = facility.Name;
                }
                aviLocatorName.setValue(aln);
                billingStreet.setValue(facility.BillingStreet);
                billingCity.setValue(facility.BillingCity);
                billingState.setValue(facility.BillingState);
                billingPostalCode.setValue(facility.BillingPostalCode);
                phone.setValue(facility.Phone);
                fax.setValue(facility.Fax);
                website.setValue(facility.Website);
                active.setValue(facility.Inactive_Account__c ? 'No' : 'Yes');
                readOnly = (facility.SAP_Customer_Number__c != null);

                //storeHoursMonOpen.setValue(facility.VI_Store_Hours_Mon_Open__c);
                //storeHoursTueOpen.setValue(facility.VI_Store_Hours_Tue_Open__c);
                //storeHoursWedOpen.setValue(facility.VI_Store_Hours_Wed_Open__c);
                //storeHoursThuOpen.setValue(facility.VI_Store_Hours_Thu_Open__c);
                //storeHoursFriOpen.setValue(facility.VI_Store_Hours_Fri_Open__c);
                //storeHoursSatOpen.setValue(facility.VI_Store_Hours_Sat_Open__c);
                //storeHoursSunOpen.setValue(facility.VI_Store_Hours_Sun_Open__c);

                //storeHoursMonClose.setValue(facility.VI_Store_Hours_Mon_Close__c);
                //storeHoursTueClose.setValue(facility.VI_Store_Hours_Tue_Close__c);
                //storeHoursWedClose.setValue(facility.VI_Store_Hours_Wed_Close__c);
                //storeHoursThuClose.setValue(facility.VI_Store_Hours_Thu_Close__c);
               // storeHoursFriClose.setValue(facility.VI_Store_Hours_Fri_Close__c);
               // storeHoursSatClose.setValue(facility.VI_Store_Hours_Sat_Close__c);
                //storeHoursSunClose.setValue(facility.VI_Store_Hours_Sun_Close__c);

                //estimateGallons.setDecimal(   facility.VI_Estimate_Annual_Gallons__c);
                //maxlifeVolPercent.setDecimal( facility.VI_MaxLife_Volume_Percent__c);
                //oilChangePercent.setDecimal(  facility.VI_Oil_Change_Percent__c);
                //synpowerPercent.setDecimal(   facility.VI_SynPower_Volume_Percent__c);
               // vpsPercent.setDecimal(        facility.VI_VPS_Percent__c);
                //wiperBladesPercent.setDecimal(facility.VI_Wiper_Blades_Percent__c);

            }
        }
        setDistributor();
    }

    private void setDistributor() {
        Id distributorId = null;
        if (VIUtils.isPartnerPortalUser()) {
            distributorId = VIUtils.getPortalAccountId();
        } else if (facility != null){
            distributorId = facility.ParentId;
        }
        if (distributorId != null) {
            List<Account> distributors = [SELECT Id, Name, OwnerId
                    FROM Account
                    WHERE Id = :distributorId
                    //AND VI_Account_Type__c = :VIUtils.ACCOUNT_TYPE_DISTRIBUTOR
                    ];

            if (!distributors.isEmpty()) {
                distributor = distributors.get(0);
            }
        }
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

            Boolean isNew = (facility.Id == null);
            if (isNew) {
                List<RecordType> recordTypes = [SELECT Id
                        FROM RecordType
                        WHERE IsActive = TRUE
                        AND SobjectType = 'Account'
                        AND Name = :VIUtils.ACCOUNT_RECORD_TYPE_PROSPECT];

                if (!recordTypes.isEmpty()) {
                    facility.RecordTypeId = recordTypes.get(0).Id;
                }

                facility.ParentId = distributor.Id;
                facility.OwnerId = distributor.OwnerId;
               // facility.VI_Account_Type__c = VIUtils.ACCOUNT_TYPE_FACILITY;
            }
            facility.Name = name.getValue();
            facility.AVI_Locator_Name__c = aviLocatorName.getValue();
            facility.BillingStreet = billingStreet.getValue();
            facility.BillingCity = billingCity.getValue();
            facility.BillingState = billingState.getValue();
            facility.BillingPostalCode = billingPostalCode.getValue();
            facility.SAP_Street__c = addressLines.get(0);
            facility.SAP_StreetSuppl1__c = addressLines.get(1);
            facility.SAP_StreetSuppl2__c = addressLines.get(2);
            facility.SAP_StreetSuppl3__c = addressLines.get(3);
            facility.SAP_City__c = billingCity.getValue();
            facility.SAP_State__c = billingState.getValue();
            facility.SAP_Zip_Code__c = billingPostalCode.getValue();
            facility.Phone = phone.getValue();
            facility.Fax = fax.getValue();
            facility.Website = website.getValue();
            facility.Inactive_Account__c = 'No'.equalsIgnoreCase(active.getValue());

           // facility.VI_Store_Hours_Mon_Open__c = storeHoursMonOpen.getValue();
           // facility.VI_Store_Hours_Tue_Open__c = storeHoursTueOpen.getValue();
            //facility.VI_Store_Hours_Wed_Open__c = storeHoursWedOpen.getValue();
            //facility.VI_Store_Hours_Thu_Open__c = storeHoursThuOpen.getValue();
           // facility.VI_Store_Hours_Fri_Open__c = storeHoursFriOpen.getValue();
           // facility.VI_Store_Hours_Sat_Open__c = storeHoursSatOpen.getValue();
            //facility.VI_Store_Hours_Sun_Open__c = storeHoursSunOpen.getValue();

            //facility.VI_Store_Hours_Mon_Close__c = storeHoursMonClose.getValue();
           // facility.VI_Store_Hours_Tue_Close__c = storeHoursTueClose.getValue();
            //facility.VI_Store_Hours_Wed_Close__c = storeHoursWedClose.getValue();
           // facility.VI_Store_Hours_Thu_Close__c = storeHoursThuClose.getValue();
            //facility.VI_Store_Hours_Fri_Close__c = storeHoursFriClose.getValue();
            //facility.VI_Store_Hours_Sat_Close__c = storeHoursSatClose.getValue();
            //facility.VI_Store_Hours_Sun_Close__c = storeHoursSunClose.getValue();

            //facility.VI_Estimate_Annual_Gallons__c = estimateGallons.getDecimal();
           // facility.VI_MaxLife_Volume_Percent__c  = maxlifeVolPercent.getDecimal();
            //facility.VI_Oil_Change_Percent__c      = oilChangePercent.getDecimal();
            //facility.VI_SynPower_Volume_Percent__c = synpowerPercent.getDecimal();
           // facility.VI_VPS_Percent__c             = vpsPercent.getDecimal();
           // facility.VI_Wiper_Blades_Percent__c    = wiperBladesPercent.getDecimal();

            upsert facility;

            pageRef = cancel();
        }
        catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessages(e);
        }

        return pageRef;
    }

    private void calcThisURL() {
        PageReference pageRef = Page.VIFacilityEdit2;
        pageRef.getParameters().put(PARAM_FACILITY_ID, facilityId);
        thisURL = pageRef.getUrl();
    }

    public PageReference cancel() {
        PageReference pageRef = Page.VIFacilityList2;
        if (!isNull(returnURL)) {pageRef = new PageReference(returnURL);}
        return pageRef;
    }

    public PageReference availablePromotions() {
        PageReference pageRef = Page.VIAvailablePromotions2;
        pageRef.getParameters().put(VIAvailablePromotionsController.PARAM_ID, facilityId);
        return pageRef;
    }

}