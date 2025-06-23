public class PricingConditionTransferController {
    
    private static final String COMMA = ',';
    private static final String CRNL  = '\r\n';
    private static final String URL1  = '/apex/PricingConditionCopyPage1'; 

    public Blob    pctrsBlob            {get; set;}
    public Boolean renderUploadAccsBtn  {get; set;}
    public Boolean renderMergeAccsBtn   {get; set;}
    public Boolean renderCreateMatsBtn  {get; set;}
    public Boolean renderUpdateMatsBtn  {get; set;}
    public Boolean renderMessageTables  {get; set;}
    public Boolean renderCreatePctmsBtn {get; set;}
    public Boolean renderCreatePcnsBtn  {get; set;}

    public Boolean renderCopyBtn        {get; set;}
    public Boolean renderNextBtn        {get; set;}
    public Boolean renderPrevBtn        {get; set;}
    public Boolean disableInput1        {get; set;}
    public Boolean disableInput2        {get; set;}
    public String  accountId1           {get; set;}
    public String  accountId2           {get; set;}
    public String  accountKey1          {get; set;}
    public String  accountKey2          {get; set;}

    public String  pctrsFileName        {get; set;}
    public String  pctrsText            {get; set;}
    public String  processName          {get; set;}
    
    public Pricing_Condition_Transfer_Request__c pctr {get; set;}

    public Account account1             {get; private set;}
    public Account account2             {get; private set;}
    
    public Integer currentStep          {get; private set;}
    public List<String> smsgs           {get; private set;}
    public List<String> emsgs           {get; private set;}
    
    private Boolean isAccMerge = false, isPcTrnsfr = false, isCopyPcns = false;
    private Boolean isParamId1 = false, isParamId2 = false;
    
    public PricingConditionTransferController() {
    	init();
        Map<String, String> params = System.currentPageReference().getParameters();
        accountId1 = params.get('fid'); isParamId1 = !String.isBlank(accountId1); 
        accountId2 = params.get('tid'); isParamId2 = !String.isBlank(accountId2);
        setAccounts(); init2();
    }
    
    private void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    public void init() {
        debug('PricingConditionTransferController : init');
        currentStep = 1; renderMessageTables = false;
        renderUploadAccsBtn = true; renderMergeAccsBtn = false;
        renderCreateMatsBtn = false; renderUpdateMatsBtn = false;
        renderCreatePctmsBtn = false; renderCreatePcnsBtn = false;
        renderCopyBtn = false; renderNextBtn = true; renderPrevBtn = false;
        accountId1 = ''; accountId2 = ''; accountKey1 = ''; accountKey2 = '';
        pctr = new Pricing_Condition_Transfer_Request__c();
    }
    
    private void init2() {
        disableInput1 = isParamId1; disableInput2 = isParamId2;
    }
    
    public void reset() {
    	if (!disableInput1) {
    		accountId1 = ''; accountKey1 = '';
    		pctr.Account_From__c = null; pctr.Account_From__r = null;
    	}  
        if (!disableInput2) {
            accountId2 = ''; accountKey2 = '';
            pctr.Account_To__c = null; pctr.Account_To__r = null;
        }  
    }
    
    public PageReference cancel() {
    	String s = URL1;
    	if (isParamId1) {s = '/' + accountId1;} else
        if (isParamId2) {s = '/' + accountId2;}
        return new PageReference(s); 
    }
    
    public void initAccMerge() {isAccMerge = true;}
    public void initPcTrnsfr() {isPcTrnsfr = true;}
    public void initCopyPcns() {isCopyPcns = true;}
    
    private Account getAccount(String accId, String accKey) {
    	String q = 'select Id, Name, Account_Number__c from Account where ';
        if (!validId(accId)){accId = null;}
    	if (!String.isBlank(accId))  {q += 'Id = :accId';} else
    	if (!String.isBlank(accKey)) {q += 'Account_Number__c = :accKey';} else
    	return null;
    	List<Account> accs = Database.query(q);
    	if (accs == null || accs.isEmpty()) {return null;}
    	return accs[0];
    }
    
    private Boolean validId(String s) {
    	Boolean b = false;
    	if (!String.isBlank(s)) {
    		try {Id i = s; b = true;} catch(Exception e){}
    	}
    	return b;
    }
    
    private void setAccounts() {
    	if (String.isBlank(accountId1)) {accountId1 = pctr.Account_From__c;}
        if (String.isBlank(accountId2)) {accountId2 = pctr.Account_To__c;}
    	account1 = getAccount(accountId1, accountKey1); 
        account2 = getAccount(accountId2, accountKey2);
        pctr.Account_From__r = account1;
        pctr.Account_From__c = null;
        pctr.Account_To__r = account2;
        pctr.Account_To__c = null;
        if (account1 != null) {
            pctr.Account_From__c = account1.Id;
        	accountId1 = account1.Id;
        	accountKey1 = account1.Account_Number__c;
        } 
        if (account2 != null) {
            pctr.Account_To__c = account2.Id;
            accountId2 = account2.Id;
            accountKey2 = account2.Account_Number__c;
        } 
    }
    
    public void next() {
        currentStep++; if (currentStep > 6) {currentStep = 1;}
        setAccounts(); renderNextBtn = false; renderPrevBtn = true;
        disableInput1 = true; disableInput2 = true;
        renderCopyBtn = (accountId1 != null && accountId2 != null && accountId1 != accountId2); 
    }
    
    public void prev() {
        currentStep--; if (currentStep < 1) {currentStep = 1;}
        renderCopyBtn = false; renderNextBtn = true; renderPrevBtn = false;
        init2();
    }
    
    public void deletePCTRequests() {
        PricingConditionTransferFunctions.deletePCTRequests();
    }

    public void deletePCTMaterials() {
        PricingConditionTransferFunctions.deletePCTMaterials();
    }
    
    public void createPCTRequests() {
        String s = pctrsText;
        if (String.isBlank(s) && pctrsBlob != null) {s = pctrsBlob.toString();}
        createPCTRequests(s);
    }
    
    private void createPCTRequests(String s) {
        ApexPages.Message msg;
        smsgs = new List<String>();
        emsgs = new List<String>();
        Integer n = 0;
        if (!String.isBlank(s)) {
            deletePCTRequests();
            PricingConditionTransferFunctions.createPCTRequests(s, smsgs, emsgs);
            renderMessageTables = (smsgs.size() > 0 || emsgs.size() > 0);
            pctrsBlob = null; n = PricingConditionTransferFunctions.getPCTReqCount();
            msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Uploaded Records Count = '+n);
        } else {
            msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No Data found to Upload');
        }
        ApexPages.addMessage(msg);
        renderMergeAccsBtn = (n > 0); renderUploadAccsBtn = !(n > 0);
        renderCreateMatsBtn = (n > 0); if (isPcTrnsfr) {renderMergeAccsBtn = false;}
        renderCreatePctmsBtn = (n > 0);
    }
    
    public void gotoMergeAccounts() {
        renderMessageTables = false; renderCreateMatsBtn = false;
        renderUpdateMatsBtn = false; renderMergeAccsBtn = true;
    }
    
    public void createMaterials() {
        deletePCTMaterials();
        submitBatchJob(PricingConditionTransferBatchable.CREATE_MATERIALS);
        renderMessageTables = false; renderCreateMatsBtn = false; renderUpdateMatsBtn = true;
    }
    
    public void updateMaterials() {
        Integer n = PricingConditionTransferFunctions.getPCTMatCount();
        if (n > 0) {
            submitBatchJob(PricingConditionTransferBatchable.UPDATE_MATERIALS);
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 
                                    'No Materials found to Update.'));
        }
        gotoMergeAccounts();
    }
    
    public void mergeAccounts() {
        submitBatchJob(PricingConditionTransferBatchable.DELETE_MATERIALS,
                       PricingConditionTransferBatchable.MERGE_ACCOUNTS);
        renderMessageTables = false; renderUploadAccsBtn = false; renderMergeAccsBtn = false;
    }
    
    public void copyPCNs() {
    	renderCopyBtn = false; renderMessageTables = false;
        if (String.isBlank(accountKey1) || String.isBlank(accountKey2)) {return;}
        String s = accountKey1 + COMMA + accountKey2; createPCTRequests(s);
        submitBatchJob(PricingConditionTransferBatchable.DELETE_MATERIALS,
                       PricingConditionTransferBatchable.COPY_PCNS1);
    }
    
    public void createPCTMs() {
        submitBatchJob(PricingConditionTransferBatchable.DELETE_MATERIALS,
                       PricingConditionTransferBatchable.CREATE_PCTMS);
        renderMessageTables = false; renderCreatePctmsBtn = false; renderCreatePcnsBtn = true;
    }
    
    public void createPCNs() {
        submitBatchJob(PricingConditionTransferBatchable.CREATE_PCNS,
                       PricingConditionTransferBatchable.CREATE_PCNS);
        renderMessageTables = false; renderCreatePctmsBtn = false; renderCreatePcnsBtn = false;
    }

    private void submitBatchJob(String s) {submitBatchJob(s, null);}
        
    private void submitBatchJob(String s, String p) {
        ApexPages.Message msg;
        try {
            PricingConditionTransferBatchable.submitBatchJob(s, p);
            msg = new ApexPages.Message(ApexPages.Severity.INFO, 
           'A batch job is submitted and you will be notified by email when it completes.');
        } catch(Exception e) {
            msg = new ApexPages.Message(
                      ApexPages.Severity.ERROR, e.getMessage());
            debug(e.getMessage());
        }
        ApexPages.addMessage(msg);
    }

/*
 ****************************************************************
 Test Methods are in PricingConditionTransferFunctions_Test class
 **************************************************************** 
 */    
}