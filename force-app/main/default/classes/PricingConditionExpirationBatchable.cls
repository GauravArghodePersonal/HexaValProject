global class PricingConditionExpirationBatchable implements Database.Batchable<sObject> {

    private static final String ACTIVE = 'Active';
    private static final String APPROVED = 'Approved,Not Yet Active';
    private static final String CANCELLED = 'Cancelled';
    private static final String EXPIRED = 'Expired';

    global PricingConditionExpirationBatchable() {
    }

    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        Date currentDate = System.today();
        ql = Database.getQueryLocator([
                select Id, CreatedDate, Name,
                       Account__r.Id, Account__r.Name,
                       Account__r.AccountNumber, Account__r.sales_area__c,
                       Comments__c,
                       Dist_Channel_Code__c, EndUse_Customer__c,
                       EndUse_Customer__r.AccountNumber,
                       INCO_Term_Code__c, Invoice_Price__c,
                       Material2__r.Id, Material2__r.Material_Number__c,
                       Material2__r.Material_Desc__c, Material2__r.Sales_Org_Code__c,
                       PAC_Industry_Segment__c, Plant_Code__c,
                       Record_Status__c, SAP_Pricing_Table__c,
                       Valid_From_Date__c, Valid_To_Date__c
                  from Pricing_Condition__c
                 where Active__c = true
                   and Record_Status__c = :ACTIVE
              order by Account__c, Material2__c,
                       SAP_Pricing_Table__c,
                       CreatedDate, Name
             ]);
        return ql;
    }


    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>)alist;
        PricingConditionsToExpireFunctions.expirePricingConditions(pcs);
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
        mail.setSenderDisplayName('PricingCondition Expiration Batch Processing');
        mail.setSubject('Apex Batch Job - PricingConditionExpiration - ' +
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    Webservice static String submitBatchJob() {
        PricingConditionExpirationBatchable b = new PricingConditionExpirationBatchable();
        String msg;
        try {msg = Database.executeBatch(b);} catch(Exception e) {
            msg = e.getMessage(); System.debug(e);
        }
        return msg;
    }

}