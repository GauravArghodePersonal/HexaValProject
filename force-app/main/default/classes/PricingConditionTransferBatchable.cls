global with sharing class PricingConditionTransferBatchable implements Database.Batchable<sObject> {

    public final static String userEmail        = User_Functions.getLoggedInUserEmail();

    public final static String CREATE_MATERIALS = 'CREATE_MATERIALS';
    public final static String DELETE_MATERIALS = 'DELETE_MATERIALS';
    public final static String DELETE_REQUESTS  = 'DELETE_REQUESTS';
    public final static String MERGE_ACCOUNTS   = 'MERGE_ACCOUNTS';
    public final static String UPDATE_MATERIALS = 'UPDATE_MATERIALS';
    public final static String CREATE_PCTMS     = 'CREATE_PCTMS';
    public final static String CREATE_PCTMS2    = 'CREATE_PCTMS2';
    public final static String CREATE_PCNS      = 'CREATE_PCNS';
    public final static String CREATE_IDOCS     = 'CREATE_IDOCS';
    public final static String COPY_PCNS1       = 'COPY_PCNS1';
    
    final static Set<String> pctmProcSteps = new Set<String>{DELETE_MATERIALS, UPDATE_MATERIALS, CREATE_PCNS};
    
    final static Map<String, Integer> BATCH_SIZES = new Map<String, Integer>{
    	CREATE_MATERIALS => 1, 
        CREATE_PCTMS => 1, 
        CREATE_PCTMS2 => 1, 
        DELETE_MATERIALS => 200, 
        DELETE_REQUESTS => 200, 
    	UPDATE_MATERIALS => 10, 
    	MERGE_ACCOUNTS => 10,
        CREATE_PCNS => 10, 
        CREATE_IDOCS => 10 
    };
    
    final String procStep; final String procName;
    
    final Id createdById;
    
    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'PricingConditionTransferBatchable : ' + s);
    }

    global PricingConditionTransferBatchable(String procStep) {
    	this(procStep, null);
    }
    
    global PricingConditionTransferBatchable(String procStep, String procName) {
        this.procStep = procStep; this.procName = procName;
        this.createdById = UserInfo.getUserId();
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
    	Database.Querylocator ql;
    	if (pctmProcSteps.contains(procStep)) {
            ql = PricingConditionTransferFunctions.getPctmQryLctr(createdById);
    	} else {
            ql = PricingConditionTransferFunctions.getPctrQryLctr(createdById);
    	}
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Pricing_Condition_Transfer_Material__c> pctms;
        List<Pricing_Condition_Transfer_Request__c> pctrs;

        if (DELETE_REQUESTS.equals(procStep)) {
            pctrs = (List<Pricing_Condition_Transfer_Request__c>) alist;
            delete pctrs;} else

        if (DELETE_MATERIALS.equals(procStep)) {
            pctms = (List<Pricing_Condition_Transfer_Material__c>) alist;
            delete pctms;} else

        if (CREATE_MATERIALS.equals(procStep)) {
            pctrs = (List<Pricing_Condition_Transfer_Request__c>) alist;
            PricingConditionTransferFunctions.createMaterials(pctrs);} else 

        if (UPDATE_MATERIALS.equals(procStep)) {
            pctms = (List<Pricing_Condition_Transfer_Material__c>) alist;
            PricingConditionTransferFunctions.updateMaterials(pctms);} else

        if (MERGE_ACCOUNTS.equals(procStep)) {
            pctrs = (List<Pricing_Condition_Transfer_Request__c>) alist;
            PricingConditionTransferFunctions.mergeAccounts(pctrs);} else

        if (CREATE_PCTMS.equals(procStep)) {
            pctrs = (List<Pricing_Condition_Transfer_Request__c>) alist;
            PricingConditionTransferFunctions.createPCTMs(pctrs);} else

        if (CREATE_PCTMS2.equals(procStep)) {
            pctrs = (List<Pricing_Condition_Transfer_Request__c>) alist;
            PricingConditionTransferFunctions.createPCTMs2(pctrs);} else

        if (CREATE_IDOCS.equals(procStep)) {
            pctrs = (List<Pricing_Condition_Transfer_Request__c>) alist;
            PricingConditionTransferFunctions.createIDocs(pctrs);} else

        if (CREATE_PCNS.equals(procStep)) {
            pctms = (List<Pricing_Condition_Transfer_Material__c>) alist;
            PricingConditionTransferFunctions.createPricingConditions(pctms);} 
    }
    
    global void finish(Database.BatchableContext bc){
        sendEmail(bc); debug('procStep : procName = ' + procStep + ' : ' + procName);
        if (procName == null) {return;}
        if (procName == MERGE_ACCOUNTS) {
            if (procStep == DELETE_MATERIALS) {submitBatchJob(CREATE_MATERIALS, procName);} else
            if (procStep == CREATE_MATERIALS) {submitBatchJob(UPDATE_MATERIALS, procName);} else
            if (procStep == UPDATE_MATERIALS) {submitBatchJob(MERGE_ACCOUNTS,   procName);} else
            if (procStep == MERGE_ACCOUNTS)   {submitBatchJob(DELETE_REQUESTS,  procName);} else
            if (procStep == DELETE_REQUESTS)  {submitBatchJob(DELETE_MATERIALS, null);}
        } else
        if (procName == COPY_PCNS1) { 
            if (procStep == DELETE_MATERIALS) {submitBatchJob(CREATE_PCTMS,     procName);} else
            if (procStep == CREATE_PCTMS)     {submitBatchJob(CREATE_PCNS,      procName);} else
            if (procStep == CREATE_PCNS)      {submitBatchJob(DELETE_REQUESTS,  procName);} else
            if (procStep == DELETE_REQUESTS)  {submitBatchJob(DELETE_MATERIALS, null);}
        } else
        if (procName == CREATE_PCTMS) { 
            if (procStep == DELETE_MATERIALS) {submitBatchJob(CREATE_PCTMS,     null);}
        } else
        if (procName == CREATE_PCNS) { 
            if (procStep == CREATE_PCNS)      {submitBatchJob(DELETE_REQUESTS,  procName);} else
            if (procStep == DELETE_REQUESTS)  {submitBatchJob(DELETE_MATERIALS, null);}
        }
    }
    
    private void sendEmail(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id = :bc.getJobId()];
        String s = 'Apex Batch Job - PCNs - ' + 
                             procStep + ' - ' + 
                             a.Status + ' - ' + 
                      a.TotalJobItems + ' batches - ' + 
                     a.NumberOfErrors + ' failures';
        String b = s + ' - Job Id - ' + a.Id;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {userEmail});
        mail.setReplyTo(userEmail);
        mail.setSenderDisplayName('SysAdmin');
        mail.setSubject(s);
        mail.setPlainTextBody(b);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob(String procStep, String procName) {
    	if (procStep == null || procStep.trim().length() == 0) {return '';}
        PricingConditionTransferBatchable b = new PricingConditionTransferBatchable(procStep, procName);
        String msg; Integer batchSize = 1;
        if (BATCH_SIZES.containsKey(procStep)) {batchSize = BATCH_SIZES.get(procStep);}
        if (!Test.isRunningTest()) {
	        try {msg = Database.executeBatch(b, batchSize);} 
	        catch(Exception e) {msg = e.getMessage(); b.debug(msg);}
        }
        return msg;
    }

}