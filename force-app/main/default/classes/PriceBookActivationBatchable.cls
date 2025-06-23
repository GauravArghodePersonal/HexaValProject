global class PriceBookActivationBatchable implements Database.Batchable<sObject> {

    public static final Integer BATCH_SIZE = 1;
    private static final String APPROVED = 'Approved but not Active yet';
    private static final Set<String> APPROVED_RECS = new Set<String>{APPROVED};

    global PriceBookActivationBatchable() {
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        Date tdate = Date.today();
        ql = Database.getQueryLocator([
            select Id, Active__c,
                   Description__c,
                   Dist_Channel__c,
                   Dist_Channel_Code__c,
                   Division__c,
                   Division_Code__c,
                   Effective_Date__c,
                   vcp_Grade__c,
                   Expired_By__c,
                   Name,
                   Product_Segment_Code__c,
                   Record_Status__c
              from Price_Book__c
             where Effective_Date__c <= :tdate
               and Record_Status__c in :APPROVED_RECS
             order by Name
        ]);
        return ql;
    }


    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Price_Book__c> blist = (List<Price_Book__c>)alist;
        List<Price_Book__c> clist = PriceBookFunctions.activatePriceBooks(blist);
        if (clist != null && !clist.isEmpty()) {
            try {
                System.debug(clist);
                update clist;
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
        System.debug('DMLStatements : '+Limits.getDMLStatements()+'/'+Limits.getLimitDMLStatements());
        System.debug('ScriptStatements : '+Limits.getScriptStatements()+'/'+Limits.getLimitScriptStatements());
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        List<User> ulist = [Select Id, Name, Email from User 
                             where Username = 'solenissfdcsupport@solenis.com'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{a.CreatedBy.Email});
        if (!ulist.isEmpty()) {mail.setCcAddresses(new String[]{ulist[0].Email});}
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('PriceBook Batch Processing');
        mail.setSubject('Apex Batch Job - PriceBookActivation - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches - ' +
                         a.NumberOfErrors + ' failures');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob() {
        PriceBookActivationBatchable b = new PriceBookActivationBatchable();
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