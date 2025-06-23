public with sharing class VIAvailablePromotionsController {

    // Constants
    public static final String PARAM_ID = 'id';
    public static final String PARAM_PROMOTION_ID = 'promotion';
    public static final String PARAM_RETURN_URL = 'retURL';

    public static final String SHIP_TO_CONTACT = 'contact';
    public static final String SHIP_TO_CUSTOM = 'custom';
    public static final String SHIP_TO_DISTRIBUTOR = 'distributor';
    public static final String SHIP_TO_LOCATION = 'location';

    private static final String AVI_NO = 'No';
    private static final String AVI_YES = 'Yes';
    private static final String AVI_YES_ONLY = 'Yes - AVI Only';

    private static final String COLON = ':';

    private static final String ERROR_ENTER_A_VALUE = 'You must enter a value';
    private static final String ERROR_INCOMPLETE_ADDRESS = 'Shipping Address is Incomplete';
    private static final String ERROR_MISSING_REQUIRED_FIELDS = 'Please enter a value for all required fields';
    private static final String ERROR_INELIGIBLE = 'The facility is not eligible for the selected promotion.';
    private static final String ERROR_ZERO_QUANTITY = '{0} ({1}, {2}): Total quantity of all materials must be 1 or greater.';
    private static final String ERROR_ZERO_LOCATION = 'Please select at least one location';

    private static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    private static final ApexPages.Severity INFO  = ApexPages.Severity.INFO;
    private static final ApexPages.Severity WARN  = ApexPages.Severity.WARNING;

    private Id userId = UserInfo.getUserId();

    public Account acc {get; private set;}
    public Contact cntact {get; private set;}

    private Account distributor, facility;

    private Boolean canDeleteEnrollment = false;
    private Boolean canEnterEnrollment = false;
    private Boolean isCustomerPortalUser = false;
    private String accountId;
    private String contactId;
    private String facilityName;
    private Boolean aviCertified = false;
    private Boolean portalUser = VIUtils.isPortalUser();
    private Double totalCost = 0.0;
    private Integer currentStep = -1;
    private Integer thisYear;
    private Integer nextYear;
    private List<VIAccount> locations, selectedLocations;
    private List<VIPromotion> thisYearPromotions = new List<VIPromotion>();
    private List<VIPromotion> nextYearPromotions = new List<VIPromotion>();
    private List<VIPromotion> selectedPromotions = new List<VIPromotion>();
    private List<VI_Enrollment_Location_Material__c> defaultQuantities;
    //private List<VIEnrollmentLocationMaterial> defaultQuantities;
    private Map<String, VI_Enrollment_Location_Material__c> dqmap;
    private List<VIEnrollmentLocation> enrollmentLocations;
    private Set<Id> selectedPromotionIds, selectedLocationIds;
    private Set<String> pelset; // Set<promotionId:enrollmentLocationId>
    private final VIInputField locationName = new VIInputField();
    private final VIInputField locationStreet = new VIInputField();
    private final VIInputField locationCity = new VIInputField();
    private final VIInputField locationState = new VIInputField();
    private final VIInputField locationPostalCode = new VIInputField();
    private final VIInputField locationPhone = new VIInputField();
    private final VIInputField locationFax = new VIInputField();
    private final VIInputField locationWebsite = new VIInputField();
    private final VIInputField shipTo = new VIInputField(SHIP_TO_LOCATION);

    private String returnURL, thisURL;

    private void debug(String s) {System.debug(LoggingLevel.INFO, 'VIAvailablePromotionsController : ' + s);}

    private void addErrMsg(String s) {addMsg(ERROR, s);}

    private void addInfoMsg(String s) {addMsg(INFO, s);}

    private void addWarnMsg(String s) {addMsg(WARN, s);}

    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }

    private Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}

    private String getString(String s) {return isNull(s) ? '' : s.trim();}

    public Boolean getCanDeleteEnrollment() {return canDeleteEnrollment;}
    public Boolean getCanEnterEnrollment() {return canEnterEnrollment;}

    public Boolean getIsCustomerPortalUser() {return isCustomerPortalUser;}

    public Boolean getPortalUser() {return portalUser;}

    public String getAccountId() {return accountId;}

    public Account getDistributor() {return distributor;}

    public Account getFacility() {return facility;}

    public String getFacilityName() {return facilityName;}

    public Boolean getAVICertified() {return aviCertified;}

    public Integer getCurrentStep() {return currentStep;}

    public Integer getThisYear() {return thisYear;}

    public Integer getNextYear() {return nextYear;}

    public List<VIPromotion> getThisYearPromotions() {return thisYearPromotions;}

    public List<VIPromotion> getNextYearPromotions() {return nextYearPromotions;}

    public List<Contact> contacts {get; private set;}

    public String getReturnURL() {return returnURL;}

    public String getThisURL() {return thisURL;}

    public VIInputField getLocationName()       {return locationName;}
    public VIInputField getLocationStreet()     {return locationStreet;}
    public VIInputField getLocationCity()       {return locationCity;}
    public VIInputField getLocationState()      {return locationState;}
    public VIInputField getLocationPostalCode() {return locationPostalCode;}
    public VIInputField getLocationPhone()      {return locationPhone;}
    public VIInputField getLocationFax()        {return locationFax;}
    public VIInputField getLocationWebsite()    {return locationWebsite;}
    public VIInputField getShipTo()             {return shipTo;}

    public void step1() {currentStep = 1;}

    public void step2() {currentStep = 2; setEnrollmentLocations();}

    public void step3() {
        if (!shipToCustom()) {cntact = new Contact(); initMsgs3();}
        currentStep = 3;
    }

    public void step4() {
        if (!validate3()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    ERROR_MISSING_REQUIRED_FIELDS));
            return;
        }
        setContact(); if (!validate4()) {return;}
        currentStep = 4; 
    }

    public String msgFirstName {get; private set;}
    public String msgLastName  {get; private set;}
    public String msgStreet    {get; private set;}
    public String msgCity      {get; private set;}
    public String msgState     {get; private set;}
    public String msgZip       {get; private set;}
    public String msgPhone     {get; private set;}
    public String msgEmail     {get; private set;}

    private void initMsgs3() {
        msgFirstName = ''; msgLastName  = ''; msgStreet    = ''; msgCity      = '';
        msgState     = ''; msgZip       = ''; msgPhone     = ''; msgEmail     = '';
    }

    private Boolean validate3() {
        Boolean b = true; if (!shipToCustom()) {return b;}
        msgFirstName = getMsg(cntact.FirstName);         b &= isNull(msgFirstName);
        msgLastName  = getMsg(cntact.LastName);          b &= isNull(msgLastName);
        msgStreet    = getMsg(cntact.MailingStreet);     b &= isNull(msgStreet);
        msgCity      = getMsg(cntact.MailingCity);       b &= isNull(msgCity);
        msgState     = getMsg(cntact.MailingState);      b &= isNull(msgState);
        msgZip       = getMsg(cntact.MailingPostalCode); b &= isNull(msgZip);
        msgPhone     = getMsg(cntact.Phone);             b &= isNull(msgPhone);
        msgEmail     = getMsg(cntact.Email);             b &= isNull(msgEmail);
        return b;
    }

    private Boolean validate4() {
        Boolean b = isNull(cntact.MailingStreet) ||
                    isNull(cntact.MailingCity) ||
                    isNull(cntact.MailingState) ||
                    isNull(cntact.MailingPostalCode);
        if (b) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    ERROR_INCOMPLETE_ADDRESS));
        	return false;
        }
        return true;
    }

    private String getMsg(String s) {
        if (isNull(s)) {return ERROR_ENTER_A_VALUE;} return '';
    }

    public void step99() {currentStep = 99;}

    public Boolean getShowCost() {return !portalUser;}

    public Boolean getInternalUser() {return !portalUser;}

    public Boolean renderContacts {get; private set;}

    public void init() {
        accountId = null; cntact = new Contact(); renderContacts = false;
        canDeleteEnrollment = false; canEnterEnrollment = false; isCustomerPortalUser = false;
        thisYearPromotions = new List<VIPromotion>();
        nextYearPromotions = new List<VIPromotion>();
        pelset = new Set<String>();

        Map<String, String> params = ApexPages.currentPage().getParameters();
        returnURL = params.get(PARAM_RETURN_URL);
        PageReference thisPage = Page.VIAvailablePromotions2;
        if (!isNull(returnURL)) {
            thisPage.getParameters().put(PARAM_RETURN_URL, returnURL);
        }
        thisURL = thisPage.getUrl();

        if (VIUtils.isCustomerPortalUser()) {
            // Customer portal users are not allowed to enter enrollments
            accountId = VIUtils.getPortalAccountId(); isCustomerPortalUser = true;
        } else {
            accountId = params.get(PARAM_ID); canEnterEnrollment = true;
        }

        if (accountId == null) {return;} Id tmpId = accountId; accountId = '' + tmpId;
        debug('init : accountId : ' + accountId);
        thisPage.getParameters().put(PARAM_ID, accountId); thisURL = thisPage.getUrl();

        acc = VIUtils.getAccount(accountId);
        if (acc == null || acc.Inactive_Account__c) {acc = new Account(); return;}
        setContacts();

        canDeleteEnrollment = !portalUser;

        facilityName = acc.Name;

        String channel = VIUtils.getChannel(acc.VI_Channel__c, acc.SAP_Customer_Group_5_Desc__c);
        aviCertified = acc.AVI_Certified__c;
        if (acc.VI_Ineligible_for_Promotions__c) {canEnterEnrollment = false;}

        Map<Id, VIPromotion> promotionMap = new Map<Id, VIPromotion>(); VIPromotion vipromo;
        String salesOrgCode = acc.SAP_Sales_Org__c;
        if (isNull(salesOrgCode)) {salesOrgCode = VIUtils.DEFAULT_SALESORG;}

        Set<String> aviOptions = new Set<String>{AVI_YES};
        if (aviCertified == true) {aviOptions.add(AVI_YES_ONLY);}
        else {aviOptions.add(AVI_NO);}

        //Set<String> allPromotionalGroups = getAllPromotionalGroups();
        Set<String> allPromotionalGroups = new Set<String>{'####'};

        String promotionalGroup = acc.VI_Promotional_Group__c;
        thisYear = Date.today().year(); nextYear = thisYear + 1;

        Set<String> thisYearGroups = getPromotionalGroupsForYear(promotionalGroup, thisYear);
        if (thisYearGroups.isEmpty()) {thisYearGroups.addAll(allPromotionalGroups);}

        Set<String> nextYearGroups = getPromotionalGroupsForYear(promotionalGroup, nextYear);
        if (nextYearGroups.isEmpty()) {nextYearGroups.addAll(allPromotionalGroups);}

        Date startDate, endDate; List<VI_Promotion__c> plist;

        // Get available promotions for the current year
        startDate = Date.newInstance(thisYear, 1, 1);
        endDate = Date.newInstance(thisYear + 1, 1, 1).addDays(-1);
        plist = getPromotions(startDate, endDate, salesOrgCode, channel, aviOptions, thisYearGroups);
        setPromos(plist, promotionMap, thisYearPromotions);

        // Get available promotions for next year
        startDate = Date.newInstance(nextYear, 1, 1);
        endDate = Date.newInstance(nextYear + 1, 1, 1).addDays(-1);
        plist = getPromotions(startDate, endDate, salesOrgCode, channel, aviOptions, nextYearGroups);
        setPromos(plist, promotionMap, nextYearPromotions);

        if (thisYearPromotions.isEmpty() && nextYearPromotions.isEmpty()) {canEnterEnrollment = false;}
        setPromoEnroLocaSet(promotionMap);

    }

    private List<VI_Promotion__c> getPromotions(Date startDate, Date endDate,
        String salesOrgCode, String channel, Set<String> aviOptions, Set<String> promoGroups) {
        List<VI_Promotion__c> plist = [SELECT Id, AVI__c,
                AVI_Name__c, AVI_Description__c, Customer_Group5__c,
                Channel__c, End_Date__c, Pre_Order_End_Date__c,
                Program_Code__c, Program_Name__c, Program_Description__c,
                Promotional_Group__c, Redemption_Date__c,
                SalesOrg_Code__c, Start_Date__c
                FROM VI_Promotion__c WHERE Active__c = true
                AND Redemption_Date__c >= TODAY
                AND Start_Date__c >= :startDate
                AND Start_Date__c <= :endDate
                AND SalesOrg_Code__c = :salesOrgCode
                AND Promotional_Group__c IN :promoGroups
                AND Channel__c INCLUDES (:channel)
                AND AVI__c IN :aviOptions
                ORDER BY Promotional_Group__c, Program_Name__c, Start_Date__c
                LIMIT 100];
        return plist;
    }

    private void setPromos(List<VI_Promotion__c> plist, Map<Id, VIPromotion> viPromoMap,
                           List<VIPromotion> viPromoList) {
        Boolean isEven = false; String previousGroup = null; VIPromotion vipromo;
        for (VI_Promotion__c p : plist) {

            //if (!isPromotionAvailable(acc, p)) {continue;}

            isEven = !isEven;

            vipromo = new VIPromotion(p);
            vipromo.isEven = isEven;

            if (p.Promotional_Group__c != previousGroup) {
                isEven = !isEven;

                vipromo.beginGroup = true;
                vipromo.isEven = isEven;

                previousGroup = p.Promotional_Group__c;
            }

            viPromoList.add(vipromo);
            viPromoMap.put(p.Id, vipromo);
        }

        if (!viPromoList.isEmpty()) {
            viPromoList.get(0).isFirst = true;
            viPromoList.get(viPromoList.size() - 1).isLast = true;
        }

    }
/*
    private Boolean isPromotionAvailable(Account a, VI_Promotion__c p) {
        Boolean b = true;
        if (isNull(p.Customer_Group5__c)) {return true;}
        if (isNull(a.SAP_Customer_Group_5_Desc__c)) {return false;}
        b = VIUtils.isPicklistContains(p.Customer_Group5__c, a.SAP_Customer_Group_5_Desc__c);
        return b;
    }
*/
    private void setPromoEnroLocaSet(Map<Id, VIPromotion> viPromoMap) {
        if (viPromoMap.isEmpty() || isNull(accountId)) {return;}
        // Determine which (if any) promotions the facility has already enrolled in
        for (VI_Enrollment_Location__c el : [SELECT Id,
                Facility__c, Location__c, Enrollment__r.Promotion__c
                FROM VI_Enrollment_Location__c
                WHERE Enrollment__r.Promotion__c IN :viPromoMap.keySet()
                AND Location__c = :accountId
                AND Approval_Status__c != :VIUtils.ENROLLMENT_STATUS_REJECTED
                ORDER BY CreatedDate DESC
                LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
            Id pid = el.Enrollment__r.Promotion__c;
            VIPromotion promotion = viPromoMap.get(pid);
            if (promotion != null) {promotion.reorder = true;}
            if (el.Facility__c != null) {pelset.add(pid + COLON + el.Facility__c);}
            if (el.Location__c != null) {pelset.add(pid + COLON + el.Location__c);}
        }
    }

    public PageReference cancel() {return getReturnPageRef();}

    private PageReference getReturnPageRef() {
        PageReference pageRef = null;
        if (!isNull(returnURL)) {pageRef = new PageReference(returnURL);}
        return pageRef;
    }

    private Set<String> getAllPromotionalGroups() {
        Set<String> promotionalGroups = new Set<String>();

        Schema.DescribeFieldResult field = VI_Promotion__c.Promotional_Group__c.getDescribe();
        for (Schema.PicklistEntry entry : field.getPicklistValues()) {
            promotionalGroups.add(entry.getValue());
        }

        return promotionalGroups;
    }

    private Set<String> getPromotionalGroupsForYear(String promotionalGroup, Integer year) {
        Set<String> theList = new Set<String>();

        List<String> theGroups = new List<String>();
        if (promotionalGroup != null) {
            theGroups = promotionalGroup.split(';');
        }

        Integer numGroups = theGroups.size();
        for (Integer i = 0; i < numGroups; i++) {
            String theGroup = theGroups.get(i).trim();
            if (theGroup.length() >= 5) {
                String theYear = theGroup.substring(0, 4);
                if (theYear == String.valueOf(year)) {
                    theList.add(theGroup.substring(4));
                }
            }
        }

        return theList;
    }

    public PageReference gotoAvailablePromotionsPage() {
        PageReference pr = Page.VIAvailablePromotions2;
        pr.setRedirect(false);
        return pr;
    }

    public PageReference enrollSelectedPromotion() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        Id promoId = params.get(PARAM_PROMOTION_ID);
        Set<Id> spids = new Set<Id>{promoId};
        setSelectedPromotions(spids);
        return getEnterEnrollmentsPage1();
    }

    public PageReference enrollSelectedPromotions() {
        Set<Id> spids = new Set<Id>();
        for (VIPromotion p : thisYearPromotions) {if (p.selected) {spids.add(p.promo.Id);}}
        for (VIPromotion p : nextYearPromotions) {if (p.selected) {spids.add(p.promo.Id);}}
        setSelectedPromotions(spids);
        return getEnterEnrollmentsPage1();
    }

    private PageReference getEnterEnrollmentsPage1() {
        PageReference pr = Page.VIEnterEnrollmentsPage1;
        pr.setRedirect(false); step1();
        return pr;
    }

    private void setSelectedPromotions(Set<Id> spids) {
        List<VIPromotion> sps = new List<VIPromotion>(); VIPromotion sp; String s;
        debug('setSelectedPromotions : ' + pelset);
        for (VI_Promotion__c p : [
            SELECT Id, AVI__c, AVI_Name__c, AVI_Description__c, Channel__c, End_Date__c,
                   Pre_Order_End_Date__c, Program_Code__c, Program_Name__c,
                   Program_Description__c, Promotional_Group__c,
                   Redemption_Date__c, Start_Date__c,
                  (SELECT Id, Material__c, Default_Quantity__c, convertCurrency(Cost__c),
                          Warehouse_SKU__c
                     FROM Promotion_Materials__r
                    ORDER BY Material__c)
                FROM VI_Promotion__c
                WHERE Id in :spids
                AND Active__c = TRUE]) {
            sp = new VIPromotion(p);
            s = p.Id + COLON + accountId;
            debug('setSelectedPromotions : ' + s);
            sp.reorder = pelset.contains(s);
            sps.add(sp);
        }
        selectedPromotions = sps;
        selectedPromotionIds = spids;
        setDefaultQuantityMap();
        setLocations();
    }

    private void setDefaultQuantityMap() {
        String delim = '<=>', key; VI_Enrollment_Location_Material__c elm;
        dqmap = new Map<String, VI_Enrollment_Location_Material__c>();
        defaultQuantities = new List<VI_Enrollment_Location_Material__c>();
        Set<String> kset = new Set<String>();
        for (VIPromotion sp : selectedPromotions) {
            for (VI_Promotion_Material__c pm : sp.promo.Promotion_Materials__r) {
                key = pm.Id; elm = dqmap.get(key);
                if (elm == null || elm.Quantity__c < pm.Default_Quantity__c) {
                    elm = new VI_Enrollment_Location_Material__c(
                                    Material__c = pm.Material__c,
                                    Promotion_Material__c = pm.Id,
                                    Promotion_Material__r = pm,
                                    Quantity__c = pm.Default_Quantity__c);
                    dqmap.put(key, elm); defaultQuantities.add(elm);
                }
            }
        }
    }

    public List<VIPromotion> getSelectedPromotions() {
        return selectedPromotions;
    }

    public List<VI_Enrollment_Location_Material__c> getDefaultQuantities() {
        return defaultQuantities;
    }

    private void setLocations() {
        locations = new List<VIAccount>();
        VIAccount loc = new VIAccount(acc); loc.selected = true;
        locations.add(loc);
    }

    public List<VIAccount> getLocations() {return locations;}

    public List<VIEnrollmentLocation> getEnrollmentLocations() {
        return enrollmentLocations;
    }

    private Map<String, String> getEnrolledLocationMap() {
        Map<String, String> amap = new Map<String, String>();
        for (VI_Enrollment_Location__c el : [select Id, Location__c, Promotion__c
                                            from VI_Enrollment_Location__c
                                            where Promotion__c in :selectedPromotionIds
                                                and Location__c in :selectedLocationIds
                                            limit :(Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
            amap.put(el.Promotion__c + COLON + el.Location__c, el.Id);
        }
        return amap;
    }

    private void setEnrollmentLocations() {
        selectedLocations = new List<VIAccount>(); selectedLocationIds = new Set<Id>();
        for (VIAccount a : locations) {if (a.selected) {
            selectedLocations.add(a); selectedLocationIds.add(a.acc.Id);}
        }
        VIEnrollmentLocation el; String k; Integer n; totalCost = 0.0;
        Map<String, String> elmap = getEnrolledLocationMap();
        enrollmentLocations = new List<VIEnrollmentLocation>();
        for (VIPromotion p : selectedPromotions) {n = 0;
            for (VIAccount l : selectedLocations) {
                k = p.promo.Id + COLON + l.acc.Id;
                el = new VIEnrollmentLocation(p, l);
                el.setEnrollmentMaterials(getEnrollmentMaterials(p));
                totalCost += el.totalCost;
                el.recordNumber = ++n;
                el.isEnrolled = elmap.containsKey(k);
                enrollmentLocations.add(el);
            }
        }
        if (enrollmentLocations.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_ZERO_LOCATION));
            step1();
        }
    }

    private List<VIEnrollmentLocationMaterial> getEnrollmentMaterials(VIPromotion vp) {
        List<VIEnrollmentLocationMaterial> velms = new List<VIEnrollmentLocationMaterial>();
        VIEnrollmentLocationMaterial velm;
        for (VI_Enrollment_Location_Material__c elm : defaultQuantities) {
            velm = new VIEnrollmentLocationMaterial(elm.clone()); velm.elm.Quantity__c = null;
            for (VI_Promotion_Material__c pm : vp.promo.Promotion_Materials__r) {
                if (velm.elm.Promotion_Material__c == pm.Id) {
                    velm.elm.Cost__c = pm.Cost__c;
                    velm.elm.Quantity__c = pm.Default_Quantity__c;
                    velm.selected = true; break;
                }
            }
            velms.add(velm);
        }
        return velms;
    }

    public void calculateTotalCost() {
        totalCost = 0.0;
        for (VIEnrollmentLocation el : enrollmentLocations) {
            el.setMaterialTotals();
            totalCost += el.totalCost;
        }
    }

    public Double getTotalCost() {return totalCost;}

    private void setContact() {
        contactId = null;
        if (shipToCustom()) {}
        else if (shipToDistributor()) {
            cntact.MailingCity       = distributor.BillingCity;
            cntact.MailingPostalCode = distributor.BillingPostalCode;
            cntact.MailingState      = distributor.BillingState;
            cntact.MailingStreet     = distributor.BillingStreet;}
        else if (shipToLocation()) {
            cntact.MailingCity       = acc.BillingCity;
            cntact.MailingPostalCode = acc.BillingPostalCode;
            cntact.MailingState      = acc.BillingState;
            cntact.MailingStreet     = acc.BillingStreet;}
        else {setSelectedContact();}
    }

    private Boolean shipToCustom() {
        return SHIP_TO_CUSTOM.equalsIgnoreCase(shipTo.getValue());
    }

    private Boolean shipToDistributor() {
        return SHIP_TO_DISTRIBUTOR.equalsIgnoreCase(shipTo.getValue()) && distributor != null;
    }

    private Boolean shipToLocation() {
        return SHIP_TO_LOCATION.equalsIgnoreCase(shipTo.getValue());
    }

    private void setSelectedContact() {
        contactId = shipTo.getValue();
        try {
            cntact = [select id, Name, Firstname, Lastname, Phone,
                             MobilePhone, Fax, Email, MailingStreet,
                             MailingCity, MailingState, MailingPostalCode,
                             MailingCountry, Salutation from Contact
                       where Id = :contactId];
        } catch(Exception e) {debug(e.getMessage());}
    }

    // Map<PromotionId, EnrollmentId>
    private Map<String, String> createEnrollments() {
        List<VI_Enrollment__c> alist = new List<VI_Enrollment__c>();
        Map<String, String> amap = new Map<String, String>();
        Set<String> aset = new Set<String>(); String key;
        facility = VIUtils.getFacility(acc.ParentId);
        Id facId = facility != null ? facility.Id : accountId;
        for (VIEnrollmentLocation el : enrollmentLocations) {
            key = el.vipromo.promo.Id + COLON + facId;
            if (aset.contains(key)) {continue;}
            aset.add(key);
            alist.add(new VI_Enrollment__c(
                Promotion__c = el.vipromo.promo.Id,
                Facility__c = facId,
                Key__c = key));
        }
        if (alist.isEmpty()) {return amap;}
        try {
            upsert alist Key__c;
            for (VI_Enrollment__c a : alist) {amap.put(a.Promotion__c, a.Id);}
        } catch(Exception e){ApexPages.addMessages(e);}
        return amap;
    }

    // Map<PromotionId + LocationId, EnrollmentLocationId>
    private Map<String, String> createEnrollmentLocations(Map<String, String> emap) {
        String pid, eid, key;
        String approvalStatus = VIUtils.ENROLLMENT_STATUS_SUBMITTED;
        Datetime approvalDate = null;
        if (!portalUser) {
            approvalStatus = VIUtils.ENROLLMENT_STATUS_APPROVED;
            approvalDate = Datetime.now();
        }
        Map<String, String> amap = new Map<String, String>();
        Set<String> aset = new Set<String>();
        List<VI_Enrollment_Location__c> els = new List<VI_Enrollment_Location__c>();
        for (VIEnrollmentLocation vel : enrollmentLocations) {
            pid = vel.vipromo.promo.Id;
            if (!emap.containsKey(pid)) {continue;}
            eid = emap.get(pid);
            acc = vel.viacc.acc;
            key = pid + COLON + accountId;
            if (acc.Id != null) {key = pid + COLON + acc.Id;}
            debug('createEnrollmentLocations : key = ' + key);
            if (aset.contains(key)) {continue;}
            aset.add(key);
            VI_Enrollment_Location__c el = new VI_Enrollment_Location__c();
            el.Enrollment__c = eid;
            el.Contact__c = contactId;
            el.Facility__c = accountId;
            el.Location__c = acc.Id;
            el.Key__c = key;
            el.Promotion__c = pid;
            el.Shipping_Street__c = cntact.MailingStreet;
            el.Shipping_City__c = cntact.MailingCity;
            el.Shipping_State__c = cntact.MailingState;
            el.Shipping_Postal_Code__c = cntact.MailingPostalCode;
            el.Reorder__c = vel.isEnrolled;
            el.Approval_Status__c = approvalStatus;
            el.Approval_Date__c = approvalDate;
            els.add(el);
        }
        if (els.isEmpty()) {return amap;}
        try {
            upsert els Key__c;
            for (VI_Enrollment_Location__c a : els) {
                amap.put(a.Promotion__c + COLON + a.Location__c, a.Id);
            }
        } catch(Exception e){ApexPages.addMessages(e);}
        return amap;
    }

    private void createEnrollmentLocationMaterials(Map<String, String> elmap) {
        List<VI_Enrollment_Location_Material__c> elms = new List<VI_Enrollment_Location_Material__c>();
        Set<String> aset = new Set<String>();
        for (VIEnrollmentLocation vel : enrollmentLocations) {
            String k = vel.vipromo.promo.Id + COLON + vel.viacc.acc.Id, key;
            for (VI_Enrollment_Location_Material__c elm : vel.materials) {
                if (elm.Quantity__c == null || elm.Quantity__c == 0.0) {continue;}
                key = elmap.get(k) + COLON + elm.Promotion_Material__c;
                if (aset.contains(key)) {continue;}
                aset.add(key);
                elms.add(new VI_Enrollment_Location_Material__c(
                             Enrollment_Location__c = elmap.get(k),
                             Key__c = key,
                             Material__c = elm.Material__c,
                             Promotion_Material__c = elm.Promotion_Material__c,
                             Quantity__c = (elm.Quantity__c != null) ? elm.Quantity__c : 0,
                             Cost__c = elm.Cost__c));
            }
        }
        if (elms.isEmpty()) {return;}
        try {upsert elms Key__c;} catch(Exception e){ApexPages.addMessages(e);}
        createEnrollmentMaterialOrders(elms);
    }

    private void createEnrollmentMaterialOrders(List<VI_Enrollment_Location_Material__c> elms) {
        List<VI_Enrollment_Material_Order__c> emos = new List<VI_Enrollment_Material_Order__c>();
        for (VI_Enrollment_Location_Material__c elm : elms) {
            if (elm.Quantity__c == null || elm.Quantity__c == 0.0) {continue;}
            emos.add(new VI_Enrollment_Material_Order__c(
                         Enrollment_Location_Material__c = elm.Id,
                         Key__c = elm.Id,
                         Quantity__c = (elm.Quantity__c != null) ? elm.Quantity__c : 0));
        }
        if (emos.isEmpty()) {return;}
        try {insert emos;} catch(Exception e){ApexPages.addMessages(e);}
    }

    private void setContacts() {
        contacts = [select id, Name, Firstname, Lastname, Phone,
                           MobilePhone, Fax, Email, MailingStreet,
                           MailingCity, MailingState, MailingPostalCode,
                           MailingCountry, Salutation from Contact
                     where AccountId = :acc.Id order by Name limit 200];
        renderContacts = contacts != null && !contacts.isEmpty();
        if (renderContacts) {debug('# of contacts : ' + contacts.size());}
    }

    private void createContact() {
        Map<String, Id> rtmap = Schema_Functions.getRecordTypeNameMap('Contact');
        Id rtid = rtmap.get('Valvoline');
        cntact.AccountId = acc.Id; cntact.RecordTypeId = rtid;
        try {insert cntact; contactId = cntact.Id;}
        catch(Exception e) {ApexPages.addMessages(e);}
    }

    public PageReference submit() {

        PageReference pageRef = VIUtils.getHomePageRef(accountId);
        Map<String, String> emap, elmap;
        Boolean sendNotifications = false;
        Savepoint sp = Database.setSavepoint();
        try {
            if (shipToCustom()) {createContact();}

            emap = createEnrollments();

            elmap = createEnrollmentLocations(emap);

            createEnrollmentLocationMaterials(elmap);

            sendNotifications = true;
        }
        catch (Exception e) {
            pageRef = null; Database.rollback(sp);
            ApexPages.addMessages(e);
        }

        if (sendNotifications) {
            List<String> enlocIds = elmap.values();
            VIEnrollmentNotification.sendNotifications(enlocIds);
            if (portalUser) {
                VIEnrollmentNotification.notifyEnrollmentApprovers(enlocIds);
            }
        }

        return pageRef;
    }

    private Boolean isAccountNeedsToBeApproved(Account acc) {
        return (portalUser && acc.OwnerId != userId);
    }

    private void submitForApproval(Account acc) {
        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
        psr.setComments('Submitting New Installer for Approval.');
        psr.setObjectId(acc.Id);
        Approval.ProcessResult pr = Approval.process(psr);
        if (!pr.isSuccess()) {
            throw new CustomException('Submitting New Installer for Approval Failed');
        }
    }

}