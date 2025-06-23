global class VIEnrollmentLocationBatchable implements Database.Batchable<sObject> {

    public static final String QRY_ALL = ''
        + 'select Id, Enrollment__r.Promotion__c, '
        + '      (select Id, Material__c, Promotion_Material__c '
        + '         from Enrollment_Location_Materials__r) '
        + '  from VI_Enrollment_Location__c ';
    
    final String qry; 
    
    global VIEnrollmentLocationBatchable(String q) {this.qry = q;}
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(qry);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<VI_Enrollment_Location__c> els = (List<VI_Enrollment_Location__c>)alist;
        VIEnrollmentLocationFunctions.updateEnrollmentMaterials(els);
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('VIEnrollmentLocationBatchable Processing');
        mail.setSubject('Apex Batch Job - VIEnrollmentLocationBatchable - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob(String q) {
        VIEnrollmentLocationBatchable b = new VIEnrollmentLocationBatchable(q);
        String msg;
        try {
            msg = Database.executeBatch(b);
        } catch(Exception e) {
            msg = e.getMessage();
            System.debug(e);
        }
        return msg;
    }
    
    @isTest static void test1() {
    	Test.startTest();
    	VIEnrollmentLocationBatchable.submitBatchJob(QRY_ALL + 'limit 2');
    	Test.stopTest(); // do not remove this line 
    }

}