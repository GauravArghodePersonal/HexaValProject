public with sharing class VIApproveEnrollmentDeletesController {
    // Constants
    public static final String PARAM_RETURN_URL = 'retURL';
    public static final String PARAM_PROMOTION_ID = 'promotion';
    
    // Fields
    private transient List<VI_Enrollment_Delete__c> enrollmentDeletes;
    private List<VI_Promotion__c> promotions;
    private transient List<SelectOption> promotionSelectOptions;
    private String returnURL;
    private Id promotionId;
    private List<ApprovalPendingItem> pendingItems;
    private String comments;
    
    private List<VI_Enrollment_Delete__c> getEnrollmentDeletes() {
        if (enrollmentDeletes == null) {
            enrollmentDeletes = [
                SELECT Id, Name,
                       Account__r.Id, 
                       Account__r.Name,
                       Account__r.BillingStreet,
                       Account__r.BillingCity, 
                       Account__r.BillingState,
                       Account__r.BillingPostalCode,
                       Account__r.VI_Account_Type__c,
                       Enrollment__c, Enrollment_Location__c
                  FROM VI_Enrollment_Delete__c
                 WHERE Account__r.OwnerId = :UserInfo.getUserId()
                   AND Status__c = :VIUtils.ENROLLMENT_STATUS_SUBMITTED
                   AND Promotion__c = :promotionId
                 ORDER BY Promotion__r.Name, Account__r.Name, CreatedDate
                 LIMIT 1000
            ];
        }
        return enrollmentDeletes;
    }
    
    public List<VI_Promotion__c> getPromotions() {
        if (promotions == null) {
            Set<Id> promotionIds = new Set<Id>();
            for (VI_Enrollment_Delete__c ed : [
                SELECT Promotion__c
                  FROM VI_Enrollment_Delete__c
                 WHERE Account__r.OwnerId = :UserInfo.getUserId()
                   AND Status__c = :VIUtils.ENROLLMENT_STATUS_SUBMITTED
                 LIMIT 1000
               ]) {
                promotionIds.add(ed.Promotion__c);
            }
            
            promotions = [SELECT Id, Name, Pre_Order_End_Date__c
                    FROM VI_Promotion__c
                    WHERE Id IN :promotionIds
                    ORDER BY Name, CreatedDate];
        }
        return promotions;
    }
    
    public List<SelectOption> getPromotionSelectOptions() {
        if (promotionSelectOptions == null) {
            promotionSelectOptions = new List<SelectOption>();
            for (VI_Promotion__c promotion : getPromotions()) {
                promotionSelectOptions.add(new SelectOption(promotion.Id, promotion.Name));
            }
        }
        return promotionSelectOptions;
    }
    
    public Id getPromotionId() {
        return promotionId;
    }
    
    public void setPromotionId(Id promotionId) {
        if (promotionId != this.promotionId) {
            this.promotionId = promotionId;
            enrollmentDeletes = null;
            pendingItems = null;
            comments = null;
        }
    }
    
    public VI_Promotion__c getSelectedPromotion() {
        VI_Promotion__c selectedPromotion = null;
        if (promotionId != null) {
            for (VI_Promotion__c promotion : getPromotions()) {
                if (promotion.Id == promotionId) {
                    selectedPromotion = promotion;
                    break;
                }
            }
        }
        return selectedPromotion;
    }
    
    public List<ApprovalPendingItem> getPendingItems() {
        if (pendingItems == null) {
            pendingItems = new List<ApprovalPendingItem>();
            for (VI_Enrollment_Delete__c ed : getEnrollmentDeletes()) {
                ApprovalPendingItem pendingItem = new ApprovalPendingItem(ed);
                pendingItems.add(pendingItem);
            }
        }
        return pendingItems;
    }
    
    public String getComments() {
        return comments;
    }
    
    public void setcomments(String comments) {
        this.comments = comments;
    }
    
    public void init() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        returnURL = params.get(PARAM_RETURN_URL);
        promotionId = params.get(PARAM_PROMOTION_ID);
        if ((promotionId == null) && (!getPromotions().isEmpty())) {
            promotionId = getPromotions().get(0).Id;
        }
    }
    
    public void submit() {
        Savepoint sp = Database.setSavepoint();
        try {
            List<VI_Enrollment_Delete__c> enrollmentDeletesToUpdate = new List<VI_Enrollment_Delete__c>();
            Set<Id> enrollmentIds = new Set<Id>();
            Set<Id> enrollmentLocationIds = new Set<Id>();
            for (ApprovalPendingItem pendingItem : getPendingItems()) {
                if (pendingItem.approved || pendingItem.rejected) {
                    String approvalStatus = VIUtils.ENROLLMENT_STATUS_APPROVED;
                    String comments = getComments();
                    if (!pendingItem.approved) {
                        approvalStatus = VIUtils.ENROLLMENT_STATUS_REJECTED;
                    }
                    
                    enrollmentDeletesToUpdate.add(new VI_Enrollment_Delete__c(
                            Id = pendingItem.getEnrollmentDeleteId(),
                            Status__c = approvalStatus,
                            Comments__c = comments));
                    
                    if (pendingItem.approved) {
                    	enrollmentIds.add(pendingItem.getEnrollment());
                    	enrollmentLocationIds.add(pendingItem.getEnrollmentLocation());
                    }
                }
            }
            
            if (!enrollmentDeletesToUpdate.isEmpty()) {
                update enrollmentDeletesToUpdate;
            }
            
            if (!enrollmentLocationIds.isEmpty()) {
            	List<VI_Enrollment_Location__c> enlocs = getEnrollmentLocations(enrollmentLocationIds);
                delete enlocs;
                List<VI_Enrollment__c> enrols = getEnrollments(enrollmentIds);
                delete enrols;
            }
            
            enrollmentDeletes = null;
            pendingItems = null;
            comments = null;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
                    'Enrollment Deletes successfully processed!'));
        }
        catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessages(e);
        }
    }
    
    private List<VI_Enrollment_Location__c> getEnrollmentLocations(Set<Id> ids) {
    	List<VI_Enrollment_Location__c> alist = [
    	   select Id from VI_Enrollment_Location__c where Id in :ids
    	];
    	return alist;
    } 
    
    private List<VI_Enrollment__c> getEnrollments(Set<Id> ids) {
        List<VI_Enrollment__c> alist = [
           select Id from VI_Enrollment__c 
            where Total_Locations__c = 0
              and Id in :ids
        ];
        return alist;
    } 
    
    public PageReference cancel() {
        String url = returnURL;
        if ((url == null) || (url.length() == 0)) {
            url = '/home/home.jsp';
        }
        
        PageReference pageRef = new PageReference(url);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public class ApprovalPendingItem {
        private final VI_Enrollment_Delete__c ved;
        public Boolean approved {get; set;}
        public Boolean rejected {get; set;}
        
        public ApprovalPendingItem(VI_Enrollment_Delete__c ed) {
            this.ved = ed;
            approved = false;
            rejected = false;
        }
        
        public Id getEnrollmentDeleteId() {
            return ved.Id;
        }
        
        public Id getEnrollment() {
            return ved.Enrollment__c;
        }
        
        public Id getEnrollmentLocation() {
            return ved.Enrollment_Location__c;
        }
        
        public Account getLocation() {
            return ved.Account__r;
        }
        
    }
}