global with sharing class VI_LearnShare_Batchable implements Database.Batchable<SObject> {

    public static final String PROC_STEP_CREATE = 'CREATE';
    public static final String PROC_STEP_DELETE = 'DELETE';
    
    private static final String userEmail = User_Functions.getLoggedInUserEmail();
    private static final String DST = VIUtils.ACCOUNT_TYPE_DISTRIBUTOR;
    private static final String FAC = VIUtils.ACCOUNT_TYPE_FACILITY;
    private static final String LOC = VIUtils.ACCOUNT_TYPE_LOCATION;
    private static final Set<String> ACC_TYPES = new Set<String>{DST, FAC, LOC};
    
    private final Integer maxCount;
    private final String procStep;

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>> ' + s);
    }
    
    global VI_LearnShare_Batchable(String pstep, Integer mcount) {
        procStep = pstep; maxCount = mcount;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        if (procStep.equals(PROC_STEP_DELETE)) {ql = Database.getQueryLocator([
        	select Id from VI_LearnShare__c limit :maxCount
        ]);} else
        if (procStep.equals(PROC_STEP_CREATE)) {ql = Database.getQueryLocator([
            select Contact.Account.AccountNumber,
                   Contact.Account.AVI_Certified__c, 
                   Contact.Account.Id,
                   Contact.Account.Inactive_Account__c, 
                   Contact.Account.Name, 
                   Contact.Account.Parent.AccountNumber, 
                   Contact.Account.Parent.Id, 
                   Contact.Account.Parent.Name, 
                   Contact.Account.Parent.VI_Account_Type__c,
                   Contact.Account.SAP_Customer_Group_5_Desc__c, 
                   Contact.Account.VI_Account_Type__c, 
                   Contact.Account.VI_Channel__c, 
                   Contact.Email,
                   Contact.Fax,
                   Contact.FirstName,   
                   Contact.Id, 
                   Contact.LastName,   
                   Contact.Account.BillingCity,   
                   Contact.Account.BillingCountry,   
                   Contact.Account.BillingPostalCode,   
                   Contact.Account.BillingState,   
                   Contact.Account.BillingStreet,   
                   Contact.Name,
                   Contact.Phone,
                   Contact.Title,
                   Id, 
                   Name,
                   ProfileId,
                   SAP_Cust_Num__c, 
                   UserName, 
                   UserRoleId, 
                   UserType
              from User
             where IsActive = true
               and IsPortalEnabled = true
               and UserType not in ('Guest')
               and Contact.Account.Inactive_Account__c = false
               and Contact.Account.VI_Account_Type__c in :ACC_TYPES
             order by Name
             limit :maxCount
        ]);}
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        if (procStep.equals(PROC_STEP_DELETE)) {
            List<VI_LearnShare__c> ll = (List<VI_LearnShare__c>)alist;
            delete ll;
        } else if (procStep.equals(PROC_STEP_CREATE)) {
            List<User> usrs = (List<User>)alist;
            VI_LearnShare_Functions.upsertLearnShareRecords(usrs);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        sendEmail(bc); debug('procStep = ' + procStep);
        if (procStep.equals(PROC_STEP_DELETE)) {submitBatchJob(PROC_STEP_CREATE, maxCount);}
    }
    
    private void sendEmail(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        String s = 'Apex Batch Job - Valvoline LearnShare Data - ' + procStep + ' - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches';
        String b = 'Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.';
        sendEmail(s, b);
    }
    
    private void sendEmail(String s, String b) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {userEmail});
        mail.setReplyTo(userEmail);
        mail.setSenderDisplayName('SysAdmin');
        mail.setSubject(s);
        mail.setPlainTextBody(b);
        MessagingMethods.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob(String pstep, Integer mcount) {
        VI_LearnShare_Batchable b = new VI_LearnShare_Batchable(pstep, mcount);
        String msg;
        try {
            msg = Database.executeBatch(b);
        } catch(Exception e) {
            msg = e.getMessage();
            System.debug(e);
        }
        return msg;
    }

}