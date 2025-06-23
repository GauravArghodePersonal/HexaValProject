global with sharing class MassTouchBatchProcessor implements Database.Batchable<SObject> {

    public static final String DEL = 'Delete';
    public static final String UPD = 'Update';
    public static String userEmail = User_Functions.getLoggedInUserEmail();
    
    global final String query, ptype;
    
    global MassTouchBatchProcessor(String qry, String ptp) {
    	query = qry; ptype = ptp;
    }
    
    global database.querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext bc, List<SObject> alist){
        if (ptype == UPD) {update alist;} else
        if (ptype == DEL) {delete alist;}
        System.debug('DMLStatements : '+Limits.getDMLStatements()+'/'+Limits.getLimitDMLStatements());
        System.debug('ScriptStatements : '+Limits.getScriptStatements()+'/'+Limits.getLimitScriptStatements());
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob where Id =:bc.getJobId()];
        String s = 'Apex Batch Job - Mass ' + ptype + ' - ' +
                   a.Status + ' - ' + 
                   a.TotalJobItems + ' batches - ' +
                   a.NumberOfErrors + ' failures';
        String b = 'Job Id : ' + a.Id + ' : ' + s + '\n\n' + query;
        sendEmail(s, b);
    }
    
    private void sendEmail(String s, String b) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {userEmail});
        mail.setReplyTo(userEmail);
        mail.setSenderDisplayName('SysAdmin');
        mail.setSubject(s);
        mail.setPlainTextBody(b);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}