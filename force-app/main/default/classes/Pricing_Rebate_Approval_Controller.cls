public class Pricing_Rebate_Approval_Controller {

    private static final String OBJECT_NAME = 'Pricing_Rebate__c';
    private static final String BR = '<br/>';

    private final Pricing_Rebate__c pricingRebate;
    public String userLocale {get; set;}
    public String pricingRebateTabUrl {get; set;}
    
    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Pricing_Rebate_Approval_Controller : ' + s);
    }
    
    public Pricing_Rebate_Approval_Controller() {
        String objPrefix = ObjectPrefixFunctions.getObjectKeyPrefix(OBJECT_NAME);
        pricingRebateTabUrl = '/' + objPrefix + '/o';
        userLocale = UserInfo.getLocale();
        debug(userLocale + ' : ' + pricingRebateTabUrl);
    }
    
    public List<Pricing_Rebate> plist {get; private set;}
    public List<Pricing_Rebate__c> slist {get; private set;}
    
    public String userComments {get; set;} 
    public Boolean allSelected {get; set;}
    
    private void init() {
        plist = new List<Pricing_Rebate>();
        slist = new List<Pricing_Rebate__c>();
        allSelected = false;
        userComments = '';
    } 
    
    public List<Pricing_Rebate> getPricingRebates() {
        Set<String> ids = Custom_Approval_Functions.getPendingApprovalObjectIds(OBJECT_NAME);
        setPricingRebates(ids);
        return plist;
    }
    
    public void setPricingRebates(Set<String> ids) {
        init();
        if (ids == null || ids.isEmpty()) {return;}
        List<Pricing_Rebate__c> alist = [select Id, Name, Approver_Comments__c,
                  Condition_Type__c, Internal_Comments__c,
                  Rebate_Agreement_Type__c, Rebate_End_Date__c, 
                  Rebate_Recipient__r.Id, Rebate_Recipient__r.Name, 
                  Rebate_Recipient__r.AccountNumber,
                  Rebate_Start_Date__c, SAP_Rebate_Agreement_Number__c, Tables__c 
             from Pricing_Rebate__c where Id in :ids
        ];
        if (alist == null || alist.isEmpty()) {return;}
        Set<String> prKeys = new Set<String>(); String k;
        for (Pricing_Rebate__c a : alist) {
            Pricing_Rebate pr = new Pricing_Rebate(a); k = pr.getKey();
            if (!prKeys.contains(k)) {prKeys.add(k); plist.add(pr);}
        }
    }
    
    private Set<String> getSelectedObjectIds() {
        Set<String> ss = new Set<String>();
        for (Pricing_Rebate p : plist) {
            if (p.selected) {ss.add(p.pr.id);}
        }
        return ss;
    }
    
    public PageReference approveSelectedList() {
        updateApproverComments();
        Set<String> oids = getSelectedObjectIds();
        Custom_Approval_Functions.approveObjects(oids, userComments);
        return null;
    }
    
    public PageReference rejectSelectedList() {
        if (userComments == null || userComments.trim().length() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                         'Reject Comments are required');
            ApexPages.addMessage(msg);
            return null;
        }
        updateApproverComments();
        Set<String> oids = getSelectedObjectIds();
        Custom_Approval_Functions.rejectObjects(oids, userComments);
        return null;
    }
    
    private void updateApproverComments() {
        if (isNull(userComments)) {return;}
        String dt = Datetime.now().format(), un = UserInfo.getName(), ac;
        String cs = dt + ' : ' + un + ' : ' + userComments + '\n';
        slist = new List<Pricing_Rebate__c>();
        for (Pricing_Rebate p : plist) {
            if (p.selected) {
                ac = p.pr.Approver_Comments__c;
                if (isNull(ac)) {ac = '';}
                ac = cs + ac; p.pr.Approver_Comments__c = ac;
                slist.add(p.pr);
            }
        }
        if (!slist.isEmpty()) {
            try {update slist;} catch(Exception e) {}
        }
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

}