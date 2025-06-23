global with sharing class TempBatchable implements Database.Batchable<sObject> {

    final static Integer BATCH_SIZE = 10;
    
    private static final String userEmail = User_Functions.getLoggedInUserEmail();
    
    private void debug(String s) {System.debug(LoggingLevel.INFO, '>>>>>>>>>>> ' + s);}
    
    global TempBatchable() {}
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select Id, Pricing_Condition__c from Temp_Batch__c]);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
    	processBatch(alist);
    }

    global void finish(Database.BatchableContext bc){
    	if (!Test.isRunningTest()) {sendEmail(bc);}
    }
    
    private void processBatch(List<SObject> alist) {
    	delete alist;
    }
    
    private void sendEmail(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob where Id =:bc.getJobId()];
        String s = 'Apex Batch Job - TempBatchable - ' + 
                   ' - ' + a.Status + ' - ' + a.TotalJobItems + ' batches' +
                   ' - ' + a.NumberOfErrors + ' failures';
        String b = 'Job Id : ' + a.Id + ' processed ' + a.TotalJobItems +
                   ' batches with ' + a.NumberOfErrors + ' failures.';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {userEmail});
        mail.setReplyTo(userEmail);
        mail.setSenderDisplayName('SysAdmin');
        mail.setSubject(s);
        mail.setPlainTextBody(b);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob(Integer batchSize) {
        TempBatchable b = new TempBatchable();  String msg;
        if (batchSize == null || batchSize < 1) {batchSize = BATCH_SIZE;}
        try {msg = Database.executeBatch(b, batchSize);}
        catch(Exception e) {msg = e.getMessage(); b.debug(msg);}
        return msg;
    }

}