global with sharing class Open_Orders_Batchable implements Database.Batchable<SObject> {

    global final static String UPDATE_SAMPLE_REQUESTS = 'UPDATE_SAMPLE_REQUESTS';
    
    global final String query, method;
    
    global Open_Orders_Batchable(String mth, String qry) {
        method = mth; query = qry; 
    }
    
    global database.querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext bc, List<SObject> alist){
        if (method.equals(UPDATE_SAMPLE_REQUESTS)) {
        	Open_Orders_Functions.updateSampleRequests(alist);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('OpenOrders Batch Processing');
        mail.setSubject('Apex Batch Job - OpenOrders-UpdateSampleRequests - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    Webservice static String submitBatchJob(String mth, String qry) {
        Open_Orders_Batchable b = new Open_Orders_Batchable(mth, qry);
        String msg;
        try {
            msg = Database.executeBatch(b);
        } catch(Exception e) {
            msg = e.getMessage();
            System.debug(LoggingLevel.INFO, e);
        }
        return msg;
    }

}