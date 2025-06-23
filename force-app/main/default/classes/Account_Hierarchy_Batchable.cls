global with sharing class Account_Hierarchy_Batchable implements Database.Batchable<sObject> {

    public static final Integer BATCH_SIZE = 10;

    private Set<String> accountNumbers;
    
    global Account_Hierarchy_Batchable(Set<String> accNums) {
    	this.accountNumbers = accNums;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        ql = Database.getQueryLocator([
                select Id, Name
                  from Account
                 where Account_Number__c in :accountNumbers
             ]);
        return ql;
    }


    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Account> acs = (List<Account>)alist;
        Account_Hierarchy_Functions.setCustomerHierarchyIds(acs, true);
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Account Hierarchy Batch Processing');
        mail.setSubject('Apex Batch Job - Account Hierarchy - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob(List<String> alist) {
    	Set<String> aset = new Set<String>();
    	aset.addAll(alist);
        Account_Hierarchy_Batchable b = new Account_Hierarchy_Batchable(aset);
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