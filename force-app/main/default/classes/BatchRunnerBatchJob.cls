global with sharing class BatchRunnerBatchJob implements Database.Batchable<sObject> {

    public static final Integer BATCH_SIZE = 1;

	/* Developer Console Test Code
	BatchRunnerBatchJob.submitBatchJob();
	*/ 

    global BatchRunnerBatchJob() {
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
       	ql = Database.getQueryLocator(
       		[SELECT Id, Type__c, Param_1__c, Param_2__c, Param_3__c, Processed__c, Errors_Occurred__c, Results__c, Priority__c 
       		   FROM Batch_Runner_Queue_Entry__c 
       		  WHERE Processed__c = FALSE
       		  ORDER BY Priority__c DESC, CreatedDate
       		  LIMIT 50000
       		]);
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn){
        List<Batch_Runner_Queue_Entry__c> queueEntriestoProcess = (List<Batch_Runner_Queue_Entry__c>)recsIn;
        BatchRunner.processQueueEntries(queueEntriestoProcess);
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:bc.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Batch Runner - Batch Processing');
        mail.setSubject('Apex Batch Job - Batch Runner - ' + a.Status + ' - ' + a.TotalJobItems + ' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.');
        
        MessagingMethods.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob() {
    	BatchRunnerBatchJob b = new BatchRunnerBatchJob();
        String msg;
        try {msg = Database.executeBatch(b, BATCH_SIZE);} catch(Exception e) {msg = e.getMessage();System.debug(e);}
        return msg;
    }
}