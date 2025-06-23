global with sharing class AttachmentRelationshipRefreshBatch implements Database.Batchable<sObject> {

    public static final Integer BATCH_SIZE = 200;

	/* Developer Console Test Code
	AttachmentRelationshipRefreshBatch.submitBatchJob();
	*/

    global AttachmentRelationshipRefreshBatch() {
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        ql = Database.getQueryLocator([SELECT Id FROM Attachment]);
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn){
        List<Attachment> recordsToProcess = (List<Attachment>)recsIn;
        List<Id> recordIdsToProcess = new List<Id>();
        for (Attachment a:recordsToProcess) {recordIdsToProcess.add(a.Id);}
        Attachment_Relationship.updateAttachmentRelationship(recordIdsToProcess);
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:bc.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Attachment Relationships Refresh Batch Processing');
        mail.setSubject('Apex Batch Job - Attachment Relationships Refresh - ' + a.Status + ' - ' + a.TotalJobItems + ' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.');
        MessagingMethods.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob() {
        AttachmentRelationshipRefreshBatch b = new AttachmentRelationshipRefreshBatch();
        String msg;
        try {
            msg = Database.executeBatch(b, BATCH_SIZE);
        } catch(Exception e) {
            msg = e.getMessage();
            System.debug(e);
        }
        return msg;
    }
}