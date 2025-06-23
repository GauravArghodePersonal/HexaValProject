global with sharing class Risk_Batchable implements Database.Batchable<SObject> {

    public static final String ACTIVATE_NEW_RISKS_DATA = 'ACTIVATE';
    public static final String CREATE_NEW_RISKS_DATA = 'CREATE';
    
    private static final String userEmail = User_Functions.getLoggedInUserEmail();
    
    private final Integer maxCount;
    private final String procStep;

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>> ' + s);
    }
    
    global Risk_Batchable(String pstep, Integer mcount) {
        procStep = pstep; maxCount = mcount;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        String q = Risk_Functions.SELECT_QRY1;
        //q += ' where Id = \'a5DW000000091La\'';
        if (maxCount != null) {q += ' limit :maxCount';}
        Database.Querylocator ql = Database.getQueryLocator(q);
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Risk__c> tlist = (List<Risk__c>)alist;
        if (procStep.equals(CREATE_NEW_RISKS_DATA)) {
            Risk_Functions.createNextYearRisks(tlist);
        } else if (procStep.equals(ACTIVATE_NEW_RISKS_DATA)) {
            Risk_Functions.activateNextYearRisks(tlist);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob where Id =:bc.getJobId()];
        String s = 'Apex Batch Job - Risks - Next Year Data - ' + procStep + 
                   ' - ' + a.Status + ' - ' + a.TotalJobItems + ' batches' +
                   ' - ' + a.NumberOfErrors + ' failures';
        String b = 'Job Id : ' + a.Id + ' processed ' + a.TotalJobItems +
                   ' batches with ' + a.NumberOfErrors + ' failures.';
        sendEmail(s, b);
    }
    
    Webservice static String submitBatchJob(String pstep, Integer mcount) {
        Risk_Batchable b = new Risk_Batchable(pstep, mcount); String msg;
        try {msg = Database.executeBatch(b);}
        catch(Exception e) {msg = e.getMessage(); b.debug(msg);}
        return msg;
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
}