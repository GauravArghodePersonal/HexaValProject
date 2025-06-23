global with sharing class Approval_History_Batchable implements Database.Batchable<SObject> {

    private static final Time T1159PM = Time.newInstance(23, 59, 59, 999);
    
    public static final String PRICING_CONDITION = 'Pricing_Condition__c';
    
    private static String userEmail = User_Functions.getLoggedInUserEmail();
    public String objectName, queryString;
    private Datetime lastModifiedTime;

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Approval_History_Batchable : ' + s);
    }
    
    global Approval_History_Batchable(String objName, Integer days) {
        Date d = Date.today().addDays(-days);
        lastModifiedTime = Datetime.newInstance(d, T1159PM);
        objectName = objName;
        queryString = 'select Id from ' + objectName + 
                      ' where LastModifiedDate > :lastModifiedTime';
        debug(lastModifiedTime + ' : ' + queryString);
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        debug(lastModifiedTime + ' : ' + queryString);
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        if (objectName.equals(PRICING_CONDITION)) {
            List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>)alist;
            Approval_History_Functions.upsertPCApprovalHistory(pcs);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob where Id =:bc.getJobId()];
        String s = 'Apex Batch Job - Approval History - ' + 
                   objectName + ' - ' + a.Status + ' - ' + 
                   a.TotalJobItems + ' batches - ' +
                   a.NumberOfErrors + ' failures';
        String b = 'Job Id : ' + a.Id + ' : ' + s;
        sendEmail(s, b);
    }
    
    private void sendEmail(String s, String b) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {userEmail});
        mail.setReplyTo(userEmail);
        mail.setSenderDisplayName('SysAdmin');
        mail.setSubject(s);
        mail.setPlainTextBody(b);
        MessagingMethods.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob(String objName, Integer days) {
        Approval_History_Batchable b = new Approval_History_Batchable(objName, days);
        String msg;
        try {msg = Database.executeBatch(b);} catch(Exception e) {
             msg = e.getMessage(); System.debug(e);}
        return msg;
    }
}