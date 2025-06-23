global class Internal_Complaint_Batchable implements Database.Batchable<sObject>, Schedulable{

    public final static Integer BATCH_SIZE = 200;
    public final static Integer MAX_COUNT = 10000;

    private final static String userEmail = User_Functions.getLoggedInUserEmail();
    private final Integer maxCount;
    private final Boolean updateAll;
    
    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Internal_Complaint_Batchable : ' + s);
    }
    
    global Internal_Complaint_Batchable(Integer mcount, Boolean updAll) {
        if (mcount == null || mcount < 1) {mcount = MAX_COUNT;}
        if (updAll == null) {updAll = false;}
        maxCount = mcount; updateAll = updAll;
    }
    
    global void execute(SchedulableContext sc) {
        Internal_Complaint_Batchable b = new Internal_Complaint_Batchable(MAX_COUNT, false);
        Id processId;
        try {
            processId = Database.executeBatch(b);
        } catch(Exception e) {
            debug(e.getMessage());
        }
    }

    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        ql = Database.getQueryLocator([
                select Id, Status__c 
                  from Internal_Complaint__c
                 limit :maxCount
        ]);
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> olist){
        List<Internal_Complaint__c> alist = (List<Internal_Complaint__c>)olist;
        Internal_Complaint_Functions.updateStatusDays(alist, updateAll);
    }

    global void finish(Database.BatchableContext bc){
        if (!Test.isRunningTest()) {sendEmail(bc);}
    }    

    private void sendEmail(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id = :bc.getJobId()];
        String s = 'Apex Batch Job - Internal Complaints - ' + 
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
    
    Webservice static String submitBatchJob(Integer mcount, Boolean updAll) {
        Internal_Complaint_Batchable b = new Internal_Complaint_Batchable(mcount, updAll);
        String msg; Integer batchSize = BATCH_SIZE;
        try {msg = Database.executeBatch(b, batchSize);} 
        catch(Exception e) {msg = e.getMessage(); System.debug(LoggingLevel.INFO, e);}
        return msg;
    }

}