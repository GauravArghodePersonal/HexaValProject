global with sharing class PricingConditionUpdateBatchable implements Database.Batchable<sObject> {

    public Double priceIncreaseAmount   {get; set;}
    public Double priceIncreasePercnt   {get; set;}
    public Date effectFromDate          {get; set;}
    public Date effectToDate            {get; set;}
    public String dchanCode             {get; set;}
    public Boolean submitForApproval    {get; set;}
    public Set<String> sorgCodes        {get; set;}
    public Set<String> salesDsts        {get; set;}
    public Set<String> salesOfcs        {get; set;}
    public Set<String> salesGrps        {get; set;}
    public Set<String> accountIds       {get; set;}
    public Set<String> ph5Descs         {get; set;}
    public Set<String> ph6Descs         {get; set;}
    public Set<String> ph7Descs         {get; set;}
    public Set<String> baseCodes        {get; set;}
    public Set<String> materialIds      {get; set;}

    global PricingConditionUpdateBatchable() {
    }

    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql = PricingConditionUpdateFunctions.getQueryLocator(
                                       dchanCode,
                                       effectFromDate,
                                       effectToDate,
                                       sorgCodes,
                                       salesDsts,
                                       salesOfcs,
                                       salesGrps,
                                       accountIds,
                                       ph5Descs,
                                       ph6Descs,
                                       ph7Descs,
                                       baseCodes,
                                       materialIds);
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>)alist;
        PricingConditionUpdateFunctions.cloneAndSubmitForApproval(
            pcs, priceIncreaseAmount, priceIncreasePercnt, effectFromDate, effectToDate, submitForApproval);
    }

    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        User u = [Select Id, Name, Email from User
                   where Username = 'solenissfdcsupport@solenis.com'];
        if (u != null) {mail.setCcAddresses(new String[]{u.Email});}
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('PricingConditionUpdates Batch Job');
        mail.setSubject('Apex Batch Job - PricingConditionUpdates - ' +
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}