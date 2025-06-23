global class Sample_Material_Batchable implements Database.Batchable<sObject>, Schedulable{

    public final static Integer BATCH_SIZE = 200;
    public final static Integer MAX_COUNT = 10000;

    private final static String userEmail = User_Functions.getLoggedInUserEmail();
    private final static Set<String> MSET1 = new Set<String>{'Draft'};
    private final static Set<String> RSET1 = new Set<String>{'Approved', 'Cancelled'};
    private final Integer maxCount;
    
    private void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'Sample_Material_Batchable : ' + s);
    }
    
    global Sample_Material_Batchable(Integer mcount) {
        if (mcount == null || mcount < 1) {mcount = MAX_COUNT;}
    	maxCount = mcount;
    }
    
    global void execute(SchedulableContext sc) {
        Sample_Material_Batchable b = new Sample_Material_Batchable(MAX_COUNT);
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
                select Id, Record_Status__c, 
                       Sample_Request__r.Id, Sample_Request__r.Status__c  
                  from Sample_Material__c
                 where Record_Status__c in :MSET1
                   and Sample_Request__r.Status__c in :RSET1
                 limit :maxCount
        ]);
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> olist){
    	List<Sample_Material__c> alist = (List<Sample_Material__c>)olist;
    	Sample_Material_Functions.updateMaterials1(alist);
    }

    global void finish(Database.BatchableContext bc){
        if (!Test.isRunningTest()) {sendEmail(bc);}
    }    

    private void sendEmail(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id = :bc.getJobId()];
        String s = 'Apex Batch Job - Sample Materials - ' + 
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
    
    Webservice static String submitBatchJob(Integer mcount) {
        Sample_Material_Batchable b = new Sample_Material_Batchable(mcount);
        String msg; Integer batchSize = BATCH_SIZE;
        try {msg = Database.executeBatch(b, batchSize);} 
        catch(Exception e) {msg = e.getMessage(); System.debug(LoggingLevel.INFO, e);}
        return msg;
    }

}