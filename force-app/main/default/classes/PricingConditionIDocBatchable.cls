global class PricingConditionIDocBatchable implements Database.Batchable<sObject> {

    final static Integer BATCH_SIZE = 50;

    global PricingConditionIDocBatchable() {}
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        return PricingConditionIDocFunctions.getQueryLocator(BATCH_SIZE);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Pricing_Condition_IDoc__c> idocs = (List<Pricing_Condition_IDoc__c>)alist;
        PricingConditionIDocFunctions.updateIDocs(idocs);
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('PricingConditionIDocs Batch Job');
        mail.setSubject('Apex Batch Job - PricingConditionIDocs - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob() {
        PricingConditionIDocBatchable b = new PricingConditionIDocBatchable();
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