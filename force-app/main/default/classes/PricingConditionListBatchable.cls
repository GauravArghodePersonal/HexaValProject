global class PricingConditionListBatchable implements Database.Batchable<sObject> {

    public final static String EXTEND_PCNS = 'Extend';

    final static Map<String, Integer> BATCH_SIZES = new Map<String, Integer>{
        EXTEND_PCNS => 10 
    };
    
    public Date extendToDate      {get; set;}
    public Boolean extendAtSoldTo {get; set;}
    public String accountId       {get; set;}
    public String userComments    {get; set;}
    public Set<String> pcIds      {get; set;}
    
    final String procStep;

    global PricingConditionListBatchable(String procStep) {this.procStep = procStep;}
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        return PricingConditionListFunctions.getPricingConditionQueryLocator(pcIds);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>)alist;
        if (EXTEND_PCNS.equals(procStep)) {
            PricingConditionListFunctions.extendAndSubmitForApproval(
                accountId, extendAtSoldTo, extendToDate, userComments, pcs);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        List<User> ulist = [Select Id, Name, Email from User 
                             where Username = 'sysadmin@cisproduction.com'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{a.CreatedBy.Email});
        if (!ulist.isEmpty()) {mail.setCcAddresses(new String[]{ulist[0].Email});}
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('PricingConditions ' + procStep + ' Batch Job');
        mail.setSubject('Apex Batch Job - PricingConditions ' + procStep + ' - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches - ' +
                         a.NumberOfErrors + ' failures');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}