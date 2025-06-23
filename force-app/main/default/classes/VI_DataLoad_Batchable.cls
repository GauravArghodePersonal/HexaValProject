global with sharing class VI_DataLoad_Batchable implements Database.Batchable<SObject> {

    public static final String CREATE_ENROLLMENTS = 'CREATE_ENROLLMENTS';
    public static final String DELETE_DATALOADS = 'DELETE_DATALOADS';
    public static final String PROCESS_1 = 'PROCESS_1';
    public static final String COLON = ':';
    public static final Integer BATCH_SIZE = 200;

    public static final String userEmail = User_Functions.getLoggedInUserEmail();
    public static final String qry1 = 'select Id, Field1__c from VI_DataLoad_Record__c';
    public static final String qry2 = 'select Id, ' + 
        'Account__c, Account__r.AccountNumber, Account__r.Name, Account__r.ParentId, ' +
        'Account__r.BillingCity, Account__r.BillingPostalCode, ' +
        'Account__r.BillingState, Account__r.BillingStreet, ' + 
        'Account__r.AVI_Locator_Name__c, Account__r.SAP_Customer_Number__c, ' +
        'Account__r.VI_Account_Type__c, ' +
        'Promotion__c, Promotion__r.AVI__c, Promotion__r.AVI_Name__c, ' +
        'Promotion__r.AVI_Description__c, ' +
        'Promotion__r.Program_Name__c, Promotion__r.Program_Description__c ' +
        'from VI_DataLoad_Record__c';

    private final String procStep;

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>> ' + s);
    }
    
    global VI_DataLoad_Batchable(String pstep) {
        procStep = pstep;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql; String q = qry1;
        if (procStep.equals(CREATE_ENROLLMENTS)) {q = qry2;}
        return Database.getQueryLocator(q);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<VI_DataLoad_Record__c> rs = (List<VI_DataLoad_Record__c>)alist;
        if (procStep.equals(DELETE_DATALOADS)) {delete rs;} else
        if (procStep.equals(CREATE_ENROLLMENTS)) {createEnrollments(rs);} else
        if (procStep.equals(PROCESS_1)) {doProcess1(rs);}
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        String s = 'Apex Batch Job - VI DataLoad - ' + procStep + ' - ' + 
                         a.Status + ' - ' + a.TotalJobItems + ' batches - ' +
                         a.NumberOfErrors + ' failures';
        String b = 'Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.';
        sendEmail(s, b);
    }
    
    Webservice static String submitBatchJob(String pstep, Integer batchSize) {
        VI_DataLoad_Batchable b = new VI_DataLoad_Batchable(pstep);
        String msg;
        try {
            if (batchSize == null || batchSize < 1) {batchSize = BATCH_SIZE;}
            msg = Database.executeBatch(b, batchSize);
        } catch(Exception e) {msg = e.getMessage();}
        debug('msg : ' + msg);
        return msg;
    }
    
    public void createEnrollments(List<VI_DataLoad_Record__c> rs) {
    	if (rs == null || rs.isEmpty()) {return;}
    	Set<String> ks1 = new Set<String>(), ks2 = new Set<String>();
       	for (VI_DataLoad_Record__c r : rs) {ks1.add(r.Promotion__c + COLON + r.Account__c);}
        List<VI_Enrollment_Location__c> els1 = [
            select Key__c from VI_Enrollment_Location__c where Key__c in :ks1];
        if (els1 != null && !els1.isEmpty()) {
        	for (VI_Enrollment_Location__c el : els1) {ks2.add(el.Key__c);}
        }
        List<VIEnrollmentLocation> els2 = new List<VIEnrollmentLocation>();
        for (VI_DataLoad_Record__c r : rs) {
        	if (!ks2.contains(r.Promotion__c + COLON + r.Account__c)) {
        		els2.add(new VIEnrollmentLocation(r.Promotion__r, r.Account__r));
        	}
        }
        VIEnrollmentFunctions.createEnrollments(els2);
    }
    
    public void doProcess1(List<VI_DataLoad_Record__c> rs) {
        if (rs == null || rs.isEmpty()) {return;}
        Set<String> ks1 = new Set<String>();
        for (VI_DataLoad_Record__c r : rs) {ks1.add(r.Field1__c);}
        List<VI_Enrollment__c> es = [select Id, Key__c, Promotion__c, Facility__c
            from VI_Enrollment__c where Key__c in :ks1
        ];
        if (es.isEmpty()) {return;}
        Map<String, Id> amap = new Map<String, Id>();
        Set<Id> ps = new Set<Id>(), fs = new Set<Id>();
        for (VI_Enrollment__c e : es) {
        	amap.put(e.Key__c, e.Id); ps.add(e.Promotion__c); fs.add(e.Facility__c);
        }
        List<VI_Enrollment_Location__c> els1 = new List<VI_Enrollment_Location__c>(),
                                        els2 = new List<VI_Enrollment_Location__c>();
        els1 = [select Id, Enrollment__c, Promotion__c, Facility__c
            from VI_Enrollment_Location__c 
           where Promotion__c in :ps and Facility__c in :fs];
        if (els1.isEmpty()) {return;}
        for (VI_Enrollment_Location__c el : els1) {
        	String k = el.Promotion__c + COLON + el.Facility__c;
        	if (!amap.containsKey(k)) {continue;}
        	Id eid = amap.get(k);
        	if (el.Enrollment__c != eid) {
        		el.Enrollment__c = eid; els2.add(el);
        	}
        }
        if (!els2.isEmpty()) {update els2;}
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