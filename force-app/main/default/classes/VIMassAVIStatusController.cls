public with sharing class VIMassAVIStatusController {

    // option to load Customer Group5 selection list from Account data.
    private static final String PARAM_CUSTGRP5_NAME = 'cg5';
    private static final String PARAM_CUSTGRP5_VAL1 = 'd';
    
    private Map<String, String> params;
    
    public Boolean renderAccountList {get; private set;}
    public Boolean disableSaveButton {get; private set;}
    public Integer currentStep {get; private set;}
    public String aviCertified {get; set;}
    public String custGroup5 {get; set;}
    public List<SelectOption> custGroup5s {get; private set;}
    public List<VIAccount> viAccounts {get; private set;}
    public List<VIAccount> selectedAccounts {get; private set;}
    
    public VIMassAVIStatusController() {
    	params = ApexPages.currentPage().getParameters();
    }
    
    public void init() {
        //createTestData();
        setCustGroup5s();
        currentStep = 1;
        renderAccountList = false;
        disableSaveButton = true;
    }

    public PageReference getInstallers() {
    	return getInstallers(null);
    }
    
    public PageReference getInstallers(Integer limitCount) {
    	Boolean b = 'Yes'.equalsIgnoreCase(aviCertified);
        viAccounts = VIUtils.getVIAccountsByCustGroup5(custGroup5, b, limitCount);
        renderAccountList = (viAccounts != null && viAccounts.size() > 0);
        disableSaveButton = !renderAccountList;
        if (viAccounts == null || viAccounts.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(
                                        ApexPages.Severity.INFO, 
                                       'No Installers found for the selected criteria');
            ApexPages.addMessage(msg);
        }
        return null;
    }
    
    public PageReference save() {
    	List<Account> accs = getAccounts();
    	try {
    		update accs;
    		ApexPages.Message msg = new ApexPages.Message(
    		                            ApexPages.Severity.CONFIRM, 
    		                           'Changes Saved Successfully');
            ApexPages.addMessage(msg);
    	} catch(Exception e) {
    		ApexPages.addMessages(e);
    	}
        return null;
    }
    
    private List<Account> getAccounts() {
        List<Account> accs = new List<Account>();
        for (VIAccount a : viAccounts) {
        	accs.add(a.acc);
        }
        return accs;
    }
    
    private void setCustGroup5s() {
        if (custGroup5s != null) {return;}
        String p = params.get(PARAM_CUSTGRP5_NAME);
        if (PARAM_CUSTGRP5_VAL1.equalsIgnoreCase(p)) {
	        custGroup5s = new List<SelectOption>();
	        List<String> sa = VIUtils.getCustGroup5List();
	        for (String s : sa) {
	            custGroup5s.add(new SelectOption(s, s));
	        }
        } else {
	        Schema.DescribeFieldResult dfr = Account.SAP_Customer_Group_5_Desc__c.getDescribe();
	        custGroup5s = VIUtils.getSelectOptionList(dfr);
        }
    }
    
    private void createTestData() {
/*     
        custGroup5s = new List<SelectOption>{
            new SelectOption('value1', 'Customer Group 1'),
            new SelectOption('value2', 'Customer Group 2'),
            new SelectOption('value3', 'Customer Group 3')
        };
        
        viAccounts = new List<VIAccount>();
        for (Integer i = 1; i < 11; i++) {
            Account a = new Account();
            a.Name = 'Facility - ' + i; 
            VIAccount a2 = new VIAccount(a);
            viAccounts.add(a2);
        }
//*/        
    }
}