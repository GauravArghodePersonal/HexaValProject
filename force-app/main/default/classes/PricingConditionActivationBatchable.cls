global with sharing class PricingConditionActivationBatchable implements Database.Batchable<sObject> {

    private static final String ACTIVE = 'Active';
    private static final String APPROVED = 'Approved,Not Yet Active';
    private static final String CANCELLED = 'Cancelled';
    private static final String EXPIRED = 'Expired';
    private static final Set<String> REC_STATS = new Set<String>{ACTIVE, APPROVED};
    
    global PricingConditionActivationBatchable() {
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        Date currentDate = System.today();
        ql = Database.getQueryLocator([
                select Id, Account__r.AccountNumber, 
                       Active__c, Comments_Exist__c,
                       CPI_INCO_Term_to_be_Updated__c,
                       Material2__c,
                       Name,
                       Record_Status__c,
                       Send_Notification_1__c,
                       Valid_From_Date__c,
                       Valid_To_Date__c
                  from Pricing_Condition__c
                 where Record_Status__c in :REC_STATS
                 order by Record_Status__c, Name
             ]);
        return ql;
    }


    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>)alist;
        PricingConditionActivationFunctions.activatePricingConditions(pcs);
        System.debug('DMLStatements : '+Limits.getDMLStatements()+'/'+Limits.getLimitDMLStatements());
        System.debug('ScriptStatements : '+Limits.getScriptStatements()+'/'+Limits.getLimitScriptStatements());
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('PricingCondition Batch Processing');
        mail.setSubject('Apex Batch Job - PricingConditionActivation - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob() {
        PricingConditionActivationBatchable b = new PricingConditionActivationBatchable();
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