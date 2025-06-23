global with sharing class Pricing_Rebate_Batchable implements Database.Batchable<sObject> {

    private static final String APPROVED = Pricing_Rebate_Functions.APPROVED;

    global Pricing_Rebate_Batchable() {
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        Date tdate = Date.today();
        ql = Database.getQueryLocator([
                select Id, Status__c, 
                       Rebate_End_Date__c
                  from Pricing_Rebate__c
                 where Status__c = :APPROVED
                   and Rebate_End_Date__c < :tdate
             ]);
        return ql;
    }


    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Pricing_Rebate__c> prs = (List<Pricing_Rebate__c>)alist;
        Pricing_Rebate_Functions.expirePricingRebates(prs);
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Pricing Rebate Expire Batch Processing');
        mail.setSubject('Apex Batch Job - Pricing Rebate Expire - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    Webservice static String submitBatchJob() {
        Pricing_Rebate_Batchable b = new Pricing_Rebate_Batchable();
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