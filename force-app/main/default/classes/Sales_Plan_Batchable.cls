global with sharing class Sales_Plan_Batchable implements Database.Batchable<SObject> {

    public static final String PROD_PLAN_ACTIVATE = 'PROD_PLAN_ACTIVATE';
    public static final String PROD_PLAN_CREATE = 'PROD_PLAN_CREATE';

    private static final String userEmail = User_Functions.getLoggedInUserEmail();

    private final Integer maxCount;
    private final String procStep;

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>> ' + s);
    }

    global Sales_Plan_Batchable(String pstep, Integer mcount) {
        procStep = pstep; maxCount = mcount;
    }

    global Database.Querylocator start(Database.BatchableContext bc) {
        String q = '';
        if (procStep.equals(PROD_PLAN_CREATE) ||
            procStep.equals(PROD_PLAN_ACTIVATE)) {
            q = Sales_Plan_Functions.PRODUCT_PLAN_QRY1;
        }
        //q += ' where Id = \'a5DW000000091La\'';
        if (maxCount != null) {q += ' limit :maxCount';}
        Database.Querylocator ql = Database.getQueryLocator(q);
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Product_Sales_Plan__c> plist;
        if (procStep.equals(PROD_PLAN_CREATE) ||
            procStep.equals(PROD_PLAN_ACTIVATE)) {
            plist = (List<Product_Sales_Plan__c>)alist;
        }
        if (procStep.equals(PROD_PLAN_CREATE)) {
            Sales_Plan_Functions.createNextYearProdPlans(plist);
        } else if (procStep.equals(PROD_PLAN_ACTIVATE)) {
            Sales_Plan_Functions.activateNextYearProdPlans(plist);
        }
    }

    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob where Id =:bc.getJobId()];
        String s = 'Apex Batch Job - Sales Plan - Next Year Data - ' + procStep +
                   ' - ' + a.Status + ' - ' + a.TotalJobItems + ' batches' +
                   ' - ' + a.NumberOfErrors + ' failures';
        String b = 'Job Id : ' + a.Id + ' processed ' + a.TotalJobItems +
                   ' batches with ' + a.NumberOfErrors + ' failures.';
        sendEmail(s, b);
    }

    Webservice static String submitBatchJob(String pstep, Integer mcount) {
        Sales_Plan_Batchable b = new Sales_Plan_Batchable(pstep, mcount); String msg;
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
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    @isTest static void test01() {
        Test.startTest();
        submitBatchJob(PROD_PLAN_CREATE, 10);
        Test.stopTest();
    }

    @isTest static void test02() {
        Test.startTest();
        submitBatchJob(PROD_PLAN_ACTIVATE, 10);
        Test.stopTest();
    }
}