public with sharing class VIDeleteEnrollmentController {

    public static final String DELIM = ':';
    public static final String PARAM_PROMOTION_ID  = 'promotion';
    public static final String PARAM_LOCATION_ID   = 'location';
    public static final String PARAM_RETURN_URL    = 'retURL';

    public Boolean renderDeleteBtn {get; private set;}
    public String  locationId      {get; private set;}

    private Boolean portalUser = VIUtils.isPortalUser();

    private VI_Promotion__c promotion;
    private Account location;
    private List<VIEnrollmentLocation> lineItems;
    private String returnURL;

    public Boolean getPortalUser() {return portalUser;}

    public VI_Promotion__c getPromotion() {return promotion;}

    public Account getLocation() {return location;}

    public List<VIEnrollmentLocation> getLineItems() {return lineItems;}

    private void debug(String s) {System.debug(LoggingLevel.INFO, s);}

    public List<VIEnrollmentLocation> getSelectedLineItems() {
        List<VIEnrollmentLocation> selectedLineItems = new List<VIEnrollmentLocation>();
        for (VIEnrollmentLocation lineItem : getLineItems()) {
            if (lineItem.selected) {
                selectedLineItems.add(lineItem);
            }
        }
        return selectedLineItems;
    }

    public void init() {
        renderDeleteBtn = true;
        Map<String, String> params = ApexPages.currentPage().getParameters();
        debug('init : params : ' + params);
        returnURL = params.get(PARAM_RETURN_URL); locationId = params.get(PARAM_LOCATION_ID);
        loadPromotion(params.get(PARAM_PROMOTION_ID)); loadLocation(locationId);
        if ((promotion != null) && (location != null)) {
            getEnrollmentLocations(promotion, location);
            if (lineItems.isEmpty()) {addErrMsg('No enrollments found');}
        }
    }

    private void addErrMsg(String s) {
        renderDeleteBtn = false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, s));
    }

    private void loadPromotion(String promotionId) {
        List<VI_Promotion__c> promotions = [SELECT Id, Channel__c, Program_Name__c,
                Program_Description__c, Start_Date__c, End_Date__c, Pre_Order_End_Date__c,
                Redemption_Date__c, AVI__c, AVI_Name__c, AVI_Description__c,
                Promotional_Group__c
                FROM VI_Promotion__c
                WHERE Id = :promotionId
                AND Active__c = TRUE];
        if (!promotions.isEmpty()) {promotion = promotions.get(0);} else {
            addErrMsg('Invalid or missing promotion ID.');
        }
    }

    private void loadLocation(String locationId) {
        List<Account> alist = [
            SELECT Id, OwnerId, Name, AccountNumber,
                   BillingStreet, BillingCity, BillingState, BillingPostalCode, ParentId,
                   AVI_Certified__c, AVI_Locator_Name__c, SAP_Customer_Number__c, SAP_Customer_Group_5_Desc__c,
                   VI_Account_Type__c, VI_Channel__c, VI_Ineligible_for_Promotions__c, VI_Promotional_Group__c
              FROM Account WHERE Id = :locationId];
        if (!alist.isEmpty()) {location = alist.get(0);} else {
            addErrMsg('Invalid or missing location ID.');}
    }

    private void getEnrollmentLocations(VI_Promotion__c promotion,
                                        Account location) {
        lineItems = new List<VIEnrollmentLocation>(); VIEnrollmentLocation lineItem;
        Set<Id> accIds = new Set<Id>(), enrIds = new Set<Id>(); String k;
        Map<String, VI_Enrollment_Location__c> elmap = new Map<String, VI_Enrollment_Location__c>();
        for (VI_Enrollment_Location__c el : [
             SELECT Id, Name, Approval_Status__c, Enrollment__r.Id, Enrollment__r.Name,
                    Facility__c, Location__c, Promotion__c
               FROM VI_Enrollment_Location__c
              WHERE Approval_Status__c != :VIUtils.ENROLLMENT_STATUS_REJECTED
                AND Promotion__c = :promotion.Id AND Location__c = :location.Id limit 1000]) {
            lineItem = new VIEnrollmentLocation(promotion, location); lineItem.selected = true;
            lineItem.setEnrollment(el.Enrollment__r); lineItem.setEnrollmentLocation(el);
            lineItems.add(lineItem);
        }
    }

    public PageReference submit() {
        Id currentUserId = UserInfo.getUserId();
        Boolean isAdmin = VIUtils.isAdmin();
        Boolean isPortalUser = VIUtils.isPortalUser();
        PageReference pageRef = null;
        Savepoint sp = Database.setSavepoint();
        try {
            List<VIEnrollmentLocation> selectedLineItems = getSelectedLineItems();

            List<VI_Enrollment_Location__c> enlocsToDelete = new List<VI_Enrollment_Location__c>();

            Map<Id, VI_Enrollment_Delete__c> edmap = new Map<Id, VI_Enrollment_Delete__c>();
            Set<Id> enrollmentIds = new Set<Id>();
            for (VIEnrollmentLocation lineItem : selectedLineItems) {
                Account acc = lineItem.viacc.acc;
                VI_Enrollment__c enrol = lineItem.enrol;
                VI_Enrollment_Location__c enloc = lineItem.enloc;
                String status = VIUtils.ENROLLMENT_STATUS_SUBMITTED;
                if (!isPortalUser) {
                    status = VIUtils.ENROLLMENT_STATUS_APPROVED;
                    enlocsToDelete.add(enloc);
                    enrollmentIds.add(enrol.Id);
                }

                edmap.put(acc.Id, new VI_Enrollment_Delete__c(
                        Account__c = acc.Id,
                        Enrollment__c = enrol.Id,
                        Enrollment_Location__c = enloc.Id,
                        Promotion__c = promotion.Id,
                        Status__c = status));
            }
            if (!enlocsToDelete.isEmpty()) {
                insert edmap.values(); delete enlocsToDelete;
                List<VI_Enrollment__c> enrolsToDelete = getEnrollments(enrollmentIds);
                delete enrolsToDelete;
                getEnrollmentLocations(promotion, location);
            }

            pageRef = cancel();
        } catch (Exception e) {Database.rollback(sp); ApexPages.addMessages(e);}

        return pageRef;
    }

    private List<VI_Enrollment__c> getEnrollments(Set<Id> ids) {
        return [select Id from VI_Enrollment__c
                 where Total_Locations__c = 0 and Id in :ids];
    }

    public PageReference cancel() {
        PageReference pageRef = Page.VIAvailablePromotions2;
        if (location != null) {pageRef.getParameters().put('id', locationId);}
        return pageRef;
    }

}