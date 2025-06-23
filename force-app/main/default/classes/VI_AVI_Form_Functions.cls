public with sharing class VI_AVI_Form_Functions {

    public static final String AVI_FORM_APPROVED = 'Approved'; 
    public static final String AVI_FORM_REJECTED = 'Rejected'; 
    public static final String AVI_FORM_SUBMITTED = 'Submitted'; 
    
    public static void processAfterUpsert(List<VI_AVI_Form__c> alist) {
    	updateAccounts(alist);
    }
    
    private static void updateAccounts(List<VI_AVI_Form__c> alist) {
    	List<Id> accountIds = new List<Id>();
    	for (VI_AVI_Form__c a : alist) {
    		if (AVI_FORM_APPROVED.equalsIgnoreCase(a.Approval_Status__c)) {
    			accountIds.add(a.Location__c);
    		}
    	}
    	if (accountIds.isEmpty()) {return;}
    	List<Account> accs = [select Id, AVI_Certified__c
    	                        from Account
    	                       where Id in :accountIds
    	                         and AVI_Certified__c = false];
        if (accs == null || accs.isEmpty()) {return;}
        for (Account a : accs) {
        	a.AVI_Certified__c = true;
        	a.AVI_Application_Status__c = AVI_FORM_APPROVED;
        	//a.AVI_Expiry_Date__c
        }
        try {
        	update accs;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
    
}