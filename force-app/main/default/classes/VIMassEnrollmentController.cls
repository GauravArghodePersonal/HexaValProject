public class VIMassEnrollmentController {

    private Map<String, String> params;

    private static final Integer ACCOUNTS_LIMIT = 1000;
    private static final String COLON = ':';
    private static final String ACCOUNT_TYPE_LOCATION = VIUtils.ACCOUNT_TYPE_LOCATION;

    public Boolean showEnrolled {get; set;}
    public Boolean isAVI {get; private set;}
    public Boolean renderAccountList {get; private set;}
    public Boolean renderPromos {get; private set;}
    public Integer currStep {get; private set;}
    public String custGroup5 {get; set;}
    public String salesOrg {get; set;}
    public Integer maxLimit {get; set;}
    public List<SelectOption> custGroup5s {get; private set;}
    public List<SelectOption> salesOrgs {get; private set;}
    public List<VIPromotion> promos {get; private set;}
    public VIPromotion selectedPromo {get; private set;}
    public List<VIEnrollmentLocation> enrolls {get; set;}
    public List<VIEnrollmentLocation> locationEnrolls {get; private set;}
    public List<VIEnrollmentLocation> materialEnrolls {get; private set;}
    public List<VI_Enrollment_Location_Material__c> defaultQuantities {get; private set;}

    private Map<String, VIEnrollmentLocation> enrollMap = new Map<String, VIEnrollmentLocation>();
    private Map<String, VI_Enrollment_Location_Material__c> defaultMatMap = new Map<String, VI_Enrollment_Location_Material__c>();
    private List<VI_Enrollment_Location__c> locsToDelete = new List<VI_Enrollment_Location__c>();
    private List<VI_Enrollment_Location_Material__c> matsToDelete = new List<VI_Enrollment_Location_Material__c>();
    private List<VI_Enrollment_Location_Material__c> matsToUpdate = new List<VI_Enrollment_Location_Material__c>();
    private Map<Id, Double> matQtyMap = new Map<Id, Double>();

    private Map<String, VI_Enrollment_Location__c> enrollmentMap = new Map<String, VI_Enrollment_Location__c>();
    private Set<Id> enrolledFacilityIds = new Set<Id>();
    private Set<Id> enrolledLocationIds = new Set<Id>();
    private Set<Id> submittedEnrolocIds = new Set<Id>();

    private Boolean isEditEnroll;
    private Integer thisYear, nextYear;

    public VIMassEnrollmentController() {
        init();
    }

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'VIMassEnrollmentController : ' + s);
    }

    public Boolean getShowCost() {
        return !VIUtils.isPortalUser();
    }

    public void init() {
        params = ApexPages.currentPage().getParameters();
        thisYear = Date.today().year();
        nextYear = thisYear + 1;
        setCustGroup5s(); setSalesOrgs(); salesOrg = '1000';
        currStep = 0; maxLimit = ACCOUNTS_LIMIT;
        renderAccountList = false; renderPromos = false; isEditEnroll = false; isAVI = false;
    }

    public void getEnrollments() {
        debug('getEnrollments : starts');
        enrolls = new List<VIEnrollmentLocation>();
        if (selectedPromo == null) {return;}
        VIEnrollmentLocation el;
        Set<Id> facilityIds = new Set<Id>();
        //List<Account> facilities = VIUtils.getFacilitiesByCustGroup5(custGroup5, isAVI, maxLimit);
        List<Account> facilities = VIUtils.getFacilitiesByCustGroup5(custGroup5, selectedPromo, maxLimit);
        for (Account a : facilities) {
            el = getVIEnrollmentLocation(a);
            if (!el.isEnrolled || el.isEnrolled && showEnrolled) {
                facilityIds.add(a.Id);
            }
        }

        List<Account> locations = getLocations(facilityIds);
        for (Account a : locations) {getVIEnrollmentLocation(a);}
        renderAccountList = (enrolls.size() > 0);
        sortEnrollments();
        debug('getEnrollments : ends');
    }

    private void sortEnrollments() {
        List<VIEnrollmentLocation> els = new List<VIEnrollmentLocation>();
        Map<Id, VIEnrollmentLocation> elmap = new Map<Id, VIEnrollmentLocation>();
        List<VIAccount> accs = new List<VIAccount>();
        for (VIEnrollmentLocation el : enrolls) {
            elmap.put(el.viacc.acc.Id, el);
            accs.add(el.viacc);
        }
        accs = VIUtils.getSortedVIAccounts(accs, true);
        VIEnrollmentLocation el;
        for (VIAccount a : accs) {
            //System.debug(a);
            el = elmap.get(a.acc.Id);
            el.recordNumber = a.recordNumber;
            els.add(el);
        }
        enrolls = els;
    }

    private VIEnrollmentLocation getVIEnrollmentLocation(Account a) {
        VIEnrollmentLocation el = new VIEnrollmentLocation(selectedPromo.promo, a);
        String k = selectedPromo.promo.Id + COLON + a.Id;
        enrollMap.put(k, el);
        el.isEnrolled = enrollmentMap.containsKey(k);
        el.selected = el.isEnrolled; el.viacc.isEnrolled = el.isEnrolled;
        el.materials = getPromotionMaterials();
        if (!el.isEnrolled || el.isEnrolled && showEnrolled) {
            enrolls.add(el);
        }
        return el;
    }

    private List<Account> getLocations(Set<Id> facilityIds) {
        String q = VIUtils.getAccountQryForPromo(selectedPromo);
        q += ' AND ParentId in :facilityIds';
        q += ' AND VI_Account_Type__c = :ACCOUNT_TYPE_LOCATION';
        q += ' AND Id not in :enrolledLocationIds';
        q += ' LIMIT :maxLimit';
        debug('getLocations : ' + q);
        return Database.query(q);
    }

    public PageReference getInstallers() {
        isEditEnroll = false; currStep = 2;
        if (enrolls != null && !enrolls.isEmpty()) {return null;}
        Boolean b = getSelectedPromo();
        if (!b) {
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.FATAL,
                                       'Select a Promotion to enroll');
            ApexPages.addMessage(msg);
            return null;
        }
        getEnrollmentMap(); getEnrollments();
        enrollMap = new Map<String, VIEnrollmentLocation>();
        if (enrolls == null || enrolls.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.INFO,
                                       'No Installer found to be enrolled or all are already enrolled');
            ApexPages.addMessage(msg);
        }
        return null;
    }

    private Boolean getSelectedPromo() {
        // order by clause is important for this class functionality
        // and it should be same for VI_Enrollment_Location_Materials query also
        for (VIPromotion p : promos) {
            if (p.selected) {
                List<VI_Promotion__c> ps = [SELECT Id, Channel__c, Program_Name__c,
                                                   Program_Description__c, Start_Date__c,
                                                   End_Date__c, Pre_Order_End_Date__c,
                                                   Redemption_Date__c, AVI__c, AVI_Name__c,
                                                   AVI_Description__c, Promotional_Group__c,
                                                  (SELECT Id, Material__c, Default_Quantity__c,
                                                          Cost__c, Warehouse_SKU__c
                                                     FROM Promotion_Materials__r
                                                    order by Material__c, Warehouse_SKU__c
                                                  )
                                             FROM VI_Promotion__c
                                            WHERE Id = :p.promo.Id];
                if (ps != null && !ps.isEmpty()) {
                    selectedPromo = new VIPromotion(ps.get(0));
                    isAVI = selectedPromo.isAVIPromo();
                    setDefaultQuantities();
                    return true;
                }
            }
        }
        return false;
    }

    public void getEnrollmentMap() {
        debug('getEnrollmentMap : starts');
        enrollMap = new Map<String, VIEnrollmentLocation>();
        enrollmentMap = new Map<String, VI_Enrollment_Location__c>();
        enrolledFacilityIds = new Set<Id>();
        enrolledLocationIds = new Set<Id>();
        submittedEnrolocIds = new Set<Id>();
        if (selectedPromo == null) return;
        String promoId = selectedPromo.promo.Id;
        String k;
        for (VI_Enrollment_Location__c el : [select Id, Name,
                                                    Approval_Status__c,
                                                    Facility__c,
                                                    Location__c,
                                                    Promotion__c
                                               from VI_Enrollment_Location__c
                                              where Promotion__c = :promoId
                                            ]) {
            k = el.Promotion__c + COLON + el.Location__c;
            enrollmentMap.put(k, el);
            enrolledFacilityIds.add(el.Facility__c);
            enrolledLocationIds.add(el.Location__c);
            if (VIUtils.ENROLLMENT_STATUS_SUBMITTED.equalsIgnoreCase(el.Approval_Status__c)) {
                submittedEnrolocIds.add(el.Id);
            }
        }
        debug('getEnrollmentMap : ends');
    }

    public void getSubmittedEnrollments() {
        enrolls = new List<VIEnrollmentLocation>();
        locationEnrolls = new List<VIEnrollmentLocation>();
        if (selectedPromo == null) {return;}
        VIEnrollmentLocation vel;
        for (VI_Enrollment_Location__c el : [
            select Id, Name, Approval_Status__c,
                   Facility__c,
                   Location__r.Id, Location__r.AccountNumber,
                   Location__r.BillingCity,
                   Location__r.BillingPostalCode,
                   Location__r.BillingState,
                   Location__r.BillingStreet,
                   Location__r.Name, Location__r.ParentId,
                   Location__r.AVI_Locator_Name__c,
                   Location__r.SAP_Customer_Number__c,
                   Location__r.VI_Account_Type__c,
                   Promotion__c,
                  (select Id, Name, Cost__c, Material__c,
                          Quantity__c, Material_SKU__c
                     from Enrollment_Location_Materials__r
                    order by Material__c, Material_SKU__c)
              from VI_Enrollment_Location__c
             where Id in :submittedEnrolocIds
            ]) {
            vel = new VIEnrollmentLocation(el);
            updateMatQtyMap(vel);
            enrolls.add(vel);
        }
        addMissingPromoMaterials();
        sortEnrollments();
        for (VIEnrollmentLocation el : enrolls) {
            locationEnrolls.add(el);
        }
        enrolls = new List<VIEnrollmentLocation>();
    }

    private void addMissingPromoMaterials() {
        String k;
        VI_Enrollment_Location_Material__c elm;
        List<VI_Enrollment_Location_Material__c> elms;
        for (VIEnrollmentLocation el : enrolls) {
            elms = new List<VI_Enrollment_Location_Material__c>();
            for (VI_Promotion_Material__c pm : selectedPromo.promo.Promotion_Materials__r) {
                //k = pm.Material__c + DELIM + pm.Warehouse_SKU__c;
                k = pm.Id;
                if (el.matMap.containsKey(k)) {
                    elms.add(el.matMap.get(k));
                } else {
                    elm = new VI_Enrollment_Location_Material__c();
                    elm.Cost__c = pm.Cost__c;
                    elm.Material__c = pm.Material__c;
                    elm.Promotion_Material__c = pm.Id;
                    elm.Quantity__c = 0;
                    elms.add(elm);
                    el.matMap.put(k, elm);
                }
            }
            el.materials = elms;
        }
    }

    public PageReference applyQuantities() {
        if (locationEnrolls != null) {
            String k;
            VI_Enrollment_Location_Material__c elm;
            List<VI_Enrollment_Location_Material__c> elms;
            for (VIEnrollmentLocation el : locationEnrolls) {
                elms = new List<VI_Enrollment_Location_Material__c>();
                for (VI_Enrollment_Location_Material__c m : defaultQuantities) {
                    //k = m.Material__c + DELIM + m.Material_SKU__c;
                    k = m.Promotion_Material__c;
                    if (el.matMap.containsKey(k)) {
                        elm = el.matMap.get(k);
                        elm.Quantity__c = m.Quantity__c;
                        elms.add(elm);
                    }
                }
                el.materials = elms;
            }
            calculateTotalCost();
        }
        return null;
    }

    private void updateMatQtyMap(VIEnrollmentLocation vel) {
        for (VI_Enrollment_Location_Material__c elm : vel.materials) {
            matQtyMap.put(elm.Id, elm.Quantity__c);
        }
    }

    public PageReference editEnrollments() {
        isEditEnroll = true;
        if (enrolls != null && !enrolls.isEmpty()) {
            return null;
        }
        Boolean b = getSelectedPromo();
        if (!b) {
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.FATAL,
                                       'Select a Promotion');
            ApexPages.addMessage(msg);
            return null;
        }
        getEnrollmentMap();
        getSubmittedEnrollments();
        if (locationEnrolls.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.INFO,
                'No Submitted Enrollments found for the selected Promotion : ' + selectedPromo.promoName);
            ApexPages.addMessage(msg);
        } else {
            currStep = 3;
        }
        return null;
    }

    public PageReference getPromotions() {
        promos = new List<VIPromotion>();
        List<VIPromotion> tps = getPromotions(thisYear);
        List<VIPromotion> nps = getPromotions(nextYear);
        promos.addAll(tps);
        promos.addAll(nps);
        renderPromos = (promos.size() > 0);
        currStep = 1;
        if (promos == null || promos.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.INFO,
                                       'No Promotions found for the Customer Group : ' + custGroup5);
            ApexPages.addMessage(msg);
        } else {
            for (Integer i = 0; i < promos.size(); i++) {
                promos[i].recordNumber = (i+1);
            }
        }
        enrolls = null;
        return null;
    }

    private List<VIPromotion> getPromotions(Integer yyyy) {
        Date startDate = Date.newInstance(yyyy, 1, 1);
        Date endDate = Date.newInstance(yyyy + 1, 1, 1).addDays(-1);
        List<VIPromotion> plist = new List<VIPromotion>();
        VIPromotion vp;
        for (VI_Promotion__c p : [SELECT Id, AVI__c, Channel__c,
            Program_Name__c, Program_Description__c,
            AVI_Name__c, AVI_Description__c,
            Start_Date__c, End_Date__c, Fiscal_Year__c,
            Redemption_Date__c, Pre_Order_End_Date__c,
            Promotional_Group__c
            FROM VI_Promotion__c
            WHERE (Start_Date__c >= :startDate AND Start_Date__c <= :endDate)
            AND Redemption_Date__c >= TODAY
            AND Active__c = TRUE
            AND SalesOrg_Code__c = :salesOrg
            AND Customer_Group5__c INCLUDES (:custGroup5)
            ORDER BY Promotional_Group__c, Program_Name__c, Start_Date__c]) {
            vp = new VIPromotion(p);
            //System.debug(vp);
            plist.add(vp);
        }
        return plist;
    }

    public PageReference selectEnrollmentMaterials() {
        setLocationEnrolls();
        if (locationEnrolls.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.INFO,
                                       'Either none selected to enroll or all are already enrolled');
            ApexPages.addMessage(msg);
        } else {
            currStep = 3;
        }
        return null;
    }

    public PageReference reviewEnrollmentMaterials() {
        Double totalQuantity = getTotalQuantity();
        //if (!isEditEnroll && totalQuantity == 0) {
        if (false) {
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.INFO,
                                       'Enter Material Quantities to enroll');
            ApexPages.addMessage(msg);
        } else {
            currStep = 4;
        }
        return null;
    }

    public PageReference goback() {
        if (currStep == 3 && isEditEnroll) {currStep = 2;}
        currStep -= 1;
        return null;
    }

    public PageReference cancel() {
        currStep = 1;
        enrolls = null;
        return null;
    }

    public PageReference submit() {
        if (isEditEnroll) {
            updateEnrolls();
        } else {
            createEnrolls();
        }
        currStep = 9;
        return null;
    }

    private void setEnrollsToUpdate() {
        locsToDelete = new List<VI_Enrollment_Location__c>();
        matsToDelete = new List<VI_Enrollment_Location_Material__c>();
        matsToUpdate = new List<VI_Enrollment_Location_Material__c>();
        Double locqty, mq;
        for (VIEnrollmentLocation vel : locationEnrolls) {
            locqty = 0;
            for (VI_Enrollment_Location_Material__c m : vel.materials) {
                debug(''+m);
                if (m.Id == null) {continue;}
                mq = m.Quantity__c;
                if (mq == null || mq == 0) {
                    matsToDelete.add(m);
                } else if (mq > 0) {
                    locqty += mq;
                    if (isMatQtyChanged(m)) {matsToUpdate.add(m);}
                }
            }
            if (locqty == 0) {locsToDelete.add(vel.enloc);}
        }
        debug('locsToDelete : '+locsToDelete);
        debug('matsToDelete : '+matsToDelete);
        debug('matsToUpdate : '+matsToUpdate);
    }

    private Boolean isMatQtyChanged(VI_Enrollment_Location_Material__c m) {
        Boolean b = false;
        Double oq = null, nq = m.Quantity__c;
        if (matQtyMap.containsKey(m.Id)) {oq = matQtyMap.get(m.Id);}
        debug('oq : '+oq+' : nq : '+nq);
        b = (oq != null && nq != null && oq != nq);
        return b;
    }

    private void updateEnrolls() {
        setEnrollsToUpdate();
        Savepoint sp = Database.setSavepoint();
        try {
            if (!matsToUpdate.isEmpty()) {update matsToUpdate;}
            if (!matsToDelete.isEmpty()) {delete matsToDelete;}
            if (!locsToDelete.isEmpty()) {delete locsToDelete;}
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.CONFIRM,
                                       'Updated the Submitted Enrollments in Promotion : ' + selectedPromo.promoName);
            ApexPages.addMessage(msg);
        } catch(Exception ex) {
            Database.rollback(sp);
            ApexPages.addMessages(ex);
        }
    }

    private void createEnrolls() {
        try {
            VIEnrollmentFunctions.saveEnrollments(selectedPromo.promo.Id, locationEnrolls, enrollmentMap);
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.CONFIRM,
                                       'Enrolled the selected Installers in Promotion : ' + selectedPromo.promoName);
            ApexPages.addMessage(msg);
        } catch(Exception ex) {
            ApexPages.addMessages(ex);
        }

        for (VIEnrollmentLocation vel : locationEnrolls) {
            //if (vel.totalQuantity > 0) {
            if (vel.enloc.Id != null) {
                vel.isEnrolled = true;
            }
        }

    }

    private void setLocationEnrolls() {
        locationEnrolls = new List<VIEnrollmentLocation>();
        if (enrolls != null) {
            for (VIEnrollmentLocation ve1 : enrolls) {
                if (ve1.selected && !ve1.isEnrolled) {
                    locationEnrolls.add(ve1);
                }
            }
        }
    }

    private Double getTotalQuantity() {
        Double totalQuantity = 0;
        if (locationEnrolls != null) {
            for (VIEnrollmentLocation vel : locationEnrolls) {
                vel.setMaterialTotals();
                totalQuantity += vel.totalQuantity;
            }
        }
        return totalQuantity;
    }

    public Double getTotalCost() {
        Double totalCost = 0;
        if (locationEnrolls != null) {
            for (VIEnrollmentLocation vel : locationEnrolls) {
                vel.setMaterialTotals();
                totalCost += vel.totalCost;
            }
        }
        return totalCost;
    }

    public PageReference calculateTotalCost() {
        getTotalCost();
        return null;
    }

    public void setDefaultQuantities(List<VIEnrollmentLocation> vels) {
        setDefaultQuantities();
        for (VIEnrollmentLocation vel : vels) {
            vel.materials = defaultQuantities;
        }
    }

    private void setDefaultQuantities() {
        defaultQuantities = new List<VI_Enrollment_Location_Material__c>();
        defaultMatMap = new Map<String, VI_Enrollment_Location_Material__c>();
        if (selectedPromo == null) {return;}
        VI_Enrollment_Location_Material__c elm;
        String k;
        for (VI_Promotion_Material__c pm : selectedPromo.promo.Promotion_Materials__r) {
            //k = pm.Id + DELIM + pm.Material__c + DELIM + pm.Warehouse_SKU__c;
            k = pm.Id;
            elm = new VI_Enrollment_Location_Material__c();
            elm.Cost__c = pm.Cost__c;
            elm.Material__c = pm.Material__c;
            elm.Promotion_Material__c = pm.Id;
            elm.Quantity__c = pm.Default_Quantity__c;
            defaultQuantities.add(elm);
            defaultMatMap.put(k, elm);
        }
    }

    private List<VI_Enrollment_Location_Material__c> getPromotionMaterials() {
        List<VI_Enrollment_Location_Material__c> elms = new List<VI_Enrollment_Location_Material__c>();
        if (selectedPromo == null) {return elms;}
        VI_Enrollment_Location_Material__c elm;
        for (VI_Promotion_Material__c pm : selectedPromo.promo.Promotion_Materials__r) {
            elm = new VI_Enrollment_Location_Material__c();
            elm.Cost__c = pm.Cost__c;
            elm.Material__c = pm.Material__c;
            elm.Promotion_Material__c = pm.Id;
            elms.add(elm);
        }
        return elms;
    }

    private void setCustGroup5s() {
        if (custGroup5s != null) {return;}
        Schema.DescribeFieldResult dfr = VI_Promotion__c.Customer_Group5__c.getDescribe();
        custGroup5s = VIUtils.getSelectOptionList(dfr);
    }

    private void setSalesOrgs() {
        if (salesOrgs != null) {return;}
        salesOrgs = VIUtils.getSalesOrgOptionList();
    }

}