global class VI_PFC_Data_Batchable implements Database.Batchable<SObject> {

    public static final String PROC_STEP_CREATE = 'CREATE';
    public static final String PROC_STEP_DELETE = 'DELETE';
    
    public static final Integer MAX_COUNT = 10000;
    
    public static final String COMMA = ',';
    public static final String DELIM = '-';
    
    public static final String userEmail = User_Functions.getLoggedInUserEmail();
    public static final String approved = VIUtils.ENROLLMENT_STATUS_APPROVED;
    public static final String ACCOUNT_TYPE_FACILITY = VIUtils.ACCOUNT_TYPE_FACILITY;
    public static final String ACCOUNT_TYPE_LOCATION = VIUtils.ACCOUNT_TYPE_LOCATION;
    public static final Set<String> VI_ACCOUNT_TYPES = new Set<String>{
    	ACCOUNT_TYPE_FACILITY, ACCOUNT_TYPE_LOCATION
    };
    
    private final String procStep;
    private final Date promoStartDate;
    private final Datetime lastModifiedTime;

    public static final String qry1 = 'select Id from VI_Promotion_Fulfillment__c';

    public static final String qry2 = '' +
        ' select AccountNumber, AVI_Certified__c,' + 
        '        BillingStreet, Id,' + 
        '        Owner.Id, Owner.Name, Owner.SAP_Cust_Num__c,' + 
        '        VI_Account_Type__c,' +
        '       (select Promotion__r.Id,' +
        '               Promotion__r.Program_Code__c' +
        '          from Enrollment_Locations__r' +
        '         where Promotion__r.Start_Date__c >= :promoStartDate)' +
        '   from Account' +
        '  where Inactive_Account__c = false' +
        '    and VI_Account_Type__c in :VI_ACCOUNT_TYPES';
    
    @TestVisible private void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>> ' + s);
    }
    
    global VI_PFC_Data_Batchable(String pstep) {
    	promoStartDate = Date.today().addYears(-1);
    	lastModifiedTime = Datetime.now();
    	procStep = pstep;
        debug(''+promoStartDate+' : '+lastModifiedTime);
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
    	Database.Querylocator ql; String q;
        if (procStep.equals(PROC_STEP_DELETE)) {q = qry1;} else
        if (procStep.equals(PROC_STEP_CREATE)) {q = qry2;}
        return Database.getQueryLocator(q);
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
    	if (procStep.equals(PROC_STEP_DELETE)) {
    		List<VI_Promotion_Fulfillment__c> pfs = (List<VI_Promotion_Fulfillment__c>)alist;
    		delete pfs;
    	} else if (procStep.equals(PROC_STEP_CREATE)) {
            List<Account> acs = (List<Account>)alist;
            upsertPromotionFulfillments(acs);
    	}
    }
    
    global void finish(Database.BatchableContext bc){
    	sendEmail(bc); debug('procStep = ' + procStep);
    	if (procStep.equals(PROC_STEP_DELETE)) {submitBatchJob(PROC_STEP_CREATE);}
    }
    
    private void sendEmail(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        String s = 'Apex Batch Job - Valvoline PFC Data - ' + procStep + ' - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches';
        String b = 'Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.';
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
    
    Webservice static String submitBatchJob(String pstep) {
        VI_PFC_Data_Batchable b = new VI_PFC_Data_Batchable(pstep);
        String msg;
        try {
            msg = Database.executeBatch(b);
        } catch(Exception e) {
            msg = e.getMessage(); System.debug(LoggingLevel.INFO, msg);
        }
        return msg;
    }

    private String getRecordKey(Account a, VI_Promotion__c p) {
    	String s = a.AccountNumber + DELIM + a.VI_Account_Type__c;
        if (p != null) {s += (DELIM + p.Program_Code__c);}
        return s;
    }
    
    @TestVisible private void upsertPromotionFulfillments(List<Account> acs) {
        Map<String, VI_Promotion_Fulfillment__c> amap = new Map<String, VI_Promotion_Fulfillment__c>();
        VI_Promotion_Fulfillment__c v; VI_Promotion__c p;
        List<VI_Enrollment_Location__c> els;
    	for (Account a : acs) {
    		els = a.Enrollment_Locations__r;
    		if (els == null || els.isEmpty()) {
                    v = getPromotionFulfillment(a, null);
                    if (v != null) {amap.put(v.Record_Key__c, v);}
    		} else {
                for (VI_Enrollment_Location__c el : els) {
                    p = el.Promotion__r;
                    v = getPromotionFulfillment(a, p);
                    if (v != null) {amap.put(v.Record_Key__c, v);}
                }
    		}
    	}
        upsertPromotionFulfillments(amap);
    }

    private void upsertPromotionFulfillments(List<VI_Enrollment_Location__c> els) {
        Map<String, VI_Promotion_Fulfillment__c> amap = new Map<String, VI_Promotion_Fulfillment__c>();
        VI_Promotion_Fulfillment__c v;
        for (VI_Enrollment_Location__c el : els) {
            v = getPromotionFulfillment(el);
            if (v != null) {amap.put(v.Record_Key__c, v);}
        }
        upsertPromotionFulfillments(amap);
    }
    
    private void upsertPromotionFulfillments(Map<String, VI_Promotion_Fulfillment__c> amap) {
    	if (amap == null || amap.isEmpty()) {return;}
        try {upsert amap.values() VI_Promotion_Fulfillment__c.Fields.Record_Key__c;}
        catch (Exception e) {
            debug(e.getMessage());
            sendEmail('VI PFC Data Upsert Error', e.getMessage());
        }
    }
    
    private VI_Promotion_Fulfillment__c getPromotionFulfillment(VI_Enrollment_Location__c el) {
        Account a = el.Location__r;
        VI_Promotion__c p = el.Promotion__r;
        return getPromotionFulfillment(a, p);
    }
    
    private VI_Promotion_Fulfillment__c getPromotionFulfillment(Account a, VI_Promotion__c p) {
        VI_Promotion_Fulfillment__c v = new VI_Promotion_Fulfillment__c();
        //debug(''+a+p);
        if (a == null) {return null;}
        Boolean avi = (a.AVI_Certified__c != null && a.AVI_Certified__c);
        String k = getRecordKey(a, p);
        v.AVI_Status__c =  avi ? 'A' : '';
        v.Installer__c = a.Id;
        v.Installer_Owner__c = a.Owner.Id;
        if (p != null) {v.Promotion__c = p.Id;}
        v.Record_Key__c = k;
        v.Name = k;
        setAddressLines(a.BillingStreet, v);
        setAccountOwnerName(a, v);
        return v;
    }
    
    private void setAddressLines(String s, VI_Promotion_Fulfillment__c v) {
        List<String> sa;
        if (s != null) {sa = s.split('\n');}
        if (sa != null) {
            if (sa.size() > 0) {
                v.Installer_Address1__c = sa[0];
                if (sa.size() > 1) {v.Installer_Address2__c = sa[1];}
            }
        }
    }
    
    private void setAccountOwnerName(Account a, VI_Promotion_Fulfillment__c v) {
        String accOwnerName = a.Owner.Name;
        String s = a.Owner.SAP_Cust_Num__c;
        if (s != null) {
            List<String> sa = s.split(COMMA);
            if (sa != null && !sa.isEmpty()) {
                accOwnerName += ' - ' + String_Functions.removeLeadingZeros(sa[0]);
            }
        }
        v.Installer_Owner_Name__c = accOwnerName;
    }
  
    @TestVisible private void deletePromotionFulfillments(Integer lc) {
        for (List<VI_Promotion_Fulfillment__c> alist : [
            select Id from VI_Promotion_Fulfillment__c
             where LastModifiedDate < :lastModifiedTime 
             limit :lc]) {
            try {delete alist;}
            catch (Exception e) {
                debug(e.getMessage());
                sendEmail('VI PFC Data Delete Error', e.getMessage());
            }
        }
    }
    
}