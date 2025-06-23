public with sharing class Account_Hierarchy_Controller {

    private static final String CRNL = '\r\n';

    public String accountNumbersText {get; set;}
    
    Set<String> accountNumbers;

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Account_Hierarchy_Controller : ' + s);
    }
    
    private void setAccountNumbers() {
        accountNumbers = new Set<String>();
        List<String> sa = accountNumbersText.split(CRNL);
        for (String s : sa) {
        	s = s.replace(' ', ''); s = s.trim();
        	accountNumbers.add(s);
        }
    }

    public PageReference setCustomerHierarchyIds() {
    	setAccountNumbers();
    	List<Account> acs = [select Id, Name from Account
    	                      where Account_Number__c in :accountNumbers];
        if (!acs.isEmpty()) {
        	Account_Hierarchy_Functions.setCustomerHierarchyIds(acs, true);
        }
    	return null;
    }
    
    public PageReference submitBatchJob() {
        setAccountNumbers();
        Account_Hierarchy_Batchable b = new Account_Hierarchy_Batchable(accountNumbers);
        ApexPages.Message msg; String jobId;
        try {
            jobId = Database.executeBatch(b, Account_Hierarchy_Batchable.BATCH_SIZE);
            msg = new ApexPages.Message(
                      ApexPages.Severity.INFO, 
                     'Your request is in progress. You will be notified by email when it completes.');
        } catch(Exception e) {
            msg = new ApexPages.Message(
                      ApexPages.Severity.ERROR, e.getMessage());
            debug(e.getMessage());
        }
        ApexPages.addMessage(msg);
        return null;
    }
    
}