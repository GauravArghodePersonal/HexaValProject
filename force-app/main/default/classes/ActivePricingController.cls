public with sharing class ActivePricingController {
/*	
    private static final String ACC_REC_TYPE_AAFI = 'Aqualon Customer'; 
    private static final String ACC_REC_TYPE_AHWT = 'Drew Customer'; 
    private static final Map<Id,String> ACCOUNT_RECTYPES = RecordType_Functions.RetrieveRecordTypeIdMap('Account');
    
    private String accountId;
    private String accDetailsUrl;
    private String extendPageUrl;
    private String expirePageUrl;
    
    private final Account acc;
    
    List<Pricing_Condition> plist;
    List<Pricing_Condition> slist;
    
    public String userComments {get; set;} 
    public Boolean allSelected {get; set;}
    public Boolean disableSubmit {get; set;}
    public Pricing_Condition__c pc {get; set;}
    public String accountRecordType {get; set;}
    
    private void init() {
    	userComments = '';
    	allSelected = false;
    	accDetailsUrl = '/'+accountId;
    	extendPageUrl = '/apex/ActivePricingExtendPage1?accountId='+accountId;
        expirePageUrl = '/apex/ActivePricingExpirePage1?accountId='+accountId;
        pc = new Pricing_Condition__c();
        pc.Valid_To_Date__c = Date.today().addDays(30);
        if (acc != null) {
            accountRecordType = ACCOUNT_RECTYPES.get(acc.RecordTypeId);
        }
    }
    
    public ActivePricingController(ApexPages.Standardcontroller sc) {
    	accountId = ApexPages.currentPage().getParameters().get('accountId');
        acc = [select Id, RecordTypeId from Account where Id = :accountId];
    	init();
    }
    
    public List<Pricing_Condition> getPricingConditions() {
    	Set<String> accountIds = new Set<String>{accountId};
        plist = PricingConditionFunctions.getPricingConditionsForAccounts(accountIds);
        allSelected = PricingConditionFunctions.setSelectedFlags(plist, slist);
        return plist;
    }
    
    public List<Active_Pricing> getActivePricingList() {
    	List<Active_Pricing> aplist = ActivePricingFunctions.getActivePricing(accountId);
    	return aplist;
    }
    
    public List<Pricing_Condition> getActivePricingConditions() {
        Set<String> pcIds = getActivePricingConditionIds();
        plist = PricingConditionFunctions.getPricingConditions(pcIds);
        allSelected = PricingConditionFunctions.setSelectedFlags(plist, slist);
        return plist;
    }
    
    private Set<String> getActivePricingConditionIds() {
    	Set<String> ids = new Set<String>();
    	List<Active_Pricing> aplist = getActivePricingList();
    	for (Active_Pricing ap : aplist) {
    		if (ap.pricingCondition != null) {
        		Pricing_Condition__c pc = ap.pricingCondition;
        		ids.add(pc.Id);
    		}
    	}
    	return ids;
    }
    
    private Boolean validateUserComments() {
        if (userComments == null || userComments.trim().length() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Comments are required');
            ApexPages.addMessage(msg);
            return false;
        }
        return true;
    }
    
    private Boolean validateExtendToDate() {
        if (pc.Valid_To_Date__c == null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'ExtendToDate is required');
            ApexPages.addMessage(msg);
            return false;
        }
        Date tdate = Date.today();
        Integer d = tdate.daysBetween(pc.Valid_To_Date__c);
        if (d < 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid ExtendToDate');
            ApexPages.addMessage(msg);
            return false;
        }
        return true;
    }
    
    public PageReference gotoExtendPage2() {
    	Boolean b1 = validateExtendToDate();
    	Boolean b2 = validateUserComments();
    	disableSubmit = !(b1 && b2);
        return Page.ActivePricingExtendPage2;
    }
    
    public PageReference gotoExpirePage2() {
        Boolean b2 = validateUserComments();
        disableSubmit = !(b2);
        return Page.ActivePricingExpirePage2;
    }
    
    public PageReference getPageRef(String url) {
        return new PageReference(url);
    }
    
    public PageReference gotoAccountDetails() {
    	init();
        return getPageRef(accDetailsUrl);
    }
    
    public PageReference gotoExtendPage1() {
        return getPageRef(extendPageUrl);
    }
    
    public PageReference gotoExpirePage1() {
        return getPageRef(expirePageUrl);
    }
    
    public List<Pricing_Condition> getSelectedPricingConditions() {
    	slist = PricingConditionFunctions.getSelectedPricingConditions(plist);
        return slist;
    }
    
    private void extendAndSubmitForApproval() {
        try {
            Set<String> oids = PricingConditionFunctions.extendPricingConditions(slist, pc.Valid_To_Date__c);
            if (oids == null || oids.isEmpty()) {
            	return;
            }
	    	Custom_Approval_Functions.submitForApproval(oids, userComments);
        } catch(Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
    }
    
    public PageReference extendPricingConditions() {
    	extendAndSubmitForApproval();
        init();
        return new PageReference(extendPageUrl);
    }
    
    public PageReference expirePricingConditions() {
        try {
            PricingConditionFunctions.expirePricingConditions(slist);
        } catch(Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
        init();
        return new PageReference(expirePageUrl);
    }
    
    public Boolean isDefaultLayout {
        get {
            return (!isAafiLayout && !isAhwtLayout);
            //return false; // for testing only
        }
    }
    
    public Boolean isAafiLayout {
        get {
        	return ACC_REC_TYPE_AAFI.equals(accountRecordType);
            //return true; // for testing only
        }
    }
    
    public Boolean isAhwtLayout {
        get {
        	return ACC_REC_TYPE_AHWT.equals(accountRecordType);
            //return false; // for testing only
        }
    }
*/    
}