global with sharing class PricingApproversBatchable implements Database.Batchable<sObject> {

    final static Integer BATCH_SIZE = 10000;
    final static Set<String> SUBMITTED_STATUS_SET = PricingFunctions.SUBMITTED_STATUS_SET;
    final static String qry = PricingFunctions.QRY_FOR_SUBMITTED;
    Boolean emailCcOnly;
    List<String> ccIds; 

    global PricingApproversBatchable(Boolean b, List<String> sl) {
        emailCcOnly = b;
        ccIds = sl;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(qry);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Pricing__c> pcs = (List<Pricing__c>)alist;
        PricingFunctions.sendApprovalPendingMails(pcs, emailCcOnly, ccIds);
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('PricingApprovers Batch Job');
        mail.setSubject('Apex Batch Job - PricingApprovers - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob(Boolean emailCcOnly, String emailIds) {
        //System.debug(LoggingLevel.INFO, 'emailCcOnly = '+emailCcOnly);
        //System.debug(LoggingLevel.INFO, 'emailIds = '+emailIds);
        if (emailCcOnly == null) {emailCcOnly = false;}
        List<String> ccIds = null;
        if (emailIds != null && emailIds.trim().length() > 0) {
            ccIds = emailIds.trim().split(',');
        } else if (emailCcOnly) {
            return 'Email Id is required to run in test mode';
        }
        //System.debug(LoggingLevel.INFO, 'ccIds = '+ccIds);
        PricingApproversBatchable b = new PricingApproversBatchable(emailCcOnly, ccIds);
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