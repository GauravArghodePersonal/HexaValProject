@isTest
private class VI_DataLoad_Test {

    static final String FAC = VIUtils.ACCOUNT_TYPE_FACILITY;
    static final String LOC = VIUtils.ACCOUNT_TYPE_FACILITY;
    
    static Account f, l;
    static VI_Promotion__c p;
    static VI_Enrollment__c e;
    static VI_Enrollment_Location__c el;
    static VI_DataLoad_Record__c dlr;
    static VI_DataLoad_Batchable dlb;
    
    static void createTestData() {
        f = new Account(Name=FAC, AccountNumber=FAC, VI_Account_Type__c=FAC);
        insert f;
        l = new Account(Name=LOC, AccountNumber=LOC, ParentId=f.Id, VI_Account_Type__c=LOC);
        insert l;
        p = new VI_Promotion__c();
        p.Program_Code__c = 'PC1001';
        p.Channel__c = 'Test Channel';
        p.Program_Name__c = 'Test Promotion';
        insert p;
        e = new VI_Enrollment__c();
        e.Facility__c = f.Id;
        e.Promotion__c = p.Id;
        insert e;
        el = new VI_Enrollment_Location__c();
        el.Approval_Status__c = VIUtils.ENROLLMENT_STATUS_SUBMITTED;
        el.Enrollment__c = e.Id;
        el.Location__c = l.Id;
        el.Promotion__c = p.Id;
        insert el;
        dlr = new VI_DataLoad_Record__c();
        dlr.Account__c = l.Id; dlr.Promotion__c = p.Id;
        dlr.Field1__c = p.Id + ':' + f.Id;
        insert dlr;
    }
    
    static testMethod void test01() {
    	createTestData();
    	List<VI_DataLoad_Record__c> dlrs = Database.query(VI_DataLoad_Batchable.qry2);
    	dlb = new VI_DataLoad_Batchable(VI_DataLoad_Batchable.CREATE_ENROLLMENTS);
    	dlb.createEnrollments(dlrs);
        dlb.createEnrollments(dlrs);
        Test.startTest();
        VI_DataLoad_Batchable.submitBatchJob(VI_DataLoad_Batchable.DELETE_DATALOADS, 200);
        Test.stopTest();
    }
    
    static testMethod void test02() {
        createTestData();
        Test.startTest();
        VI_DataLoad_Batchable.submitBatchJob(VI_DataLoad_Batchable.CREATE_ENROLLMENTS, 1);
        Test.stopTest();
    }
    
    static testMethod void test03() {
        createTestData();
        Test.startTest();
        VI_DataLoad_Batchable.submitBatchJob(VI_DataLoad_Batchable.PROCESS_1, 1);
        Test.stopTest();
    }

    static testMethod void test04() {
        Test.startTest(); String ps = VI_PFC_Data_Batchable.PROC_STEP_CREATE;
        Set<String> VI_ACCOUNT_TYPES = VI_PFC_Data_Batchable.VI_ACCOUNT_TYPES;
        VI_PFC_Data_Batchable c = new VI_PFC_Data_Batchable(ps);
        String s = VI_PFC_Data_Batchable.qry2 + ' limit 10'; 
        Date promoStartDate = Date.today().addYears(-1);
        List<Account> acs = Database.query(s);
        c.upsertPromotionFulfillments(acs);
        List<VI_Promotion_Fulfillment__c> pfs = [
            select Id, Installer_Owner_Name__c  
              from VI_Promotion_Fulfillment__c
             limit 10
        ];
        for (VI_Promotion_Fulfillment__c pf : pfs) {c.debug(''+pf);}
        c.deletePromotionFulfillments(10);
        VI_PFC_Data_Batchable.submitBatchJob(ps);
        Test.stopTest();
    }
    
    static testMethod void test05() {
        Test.startTest(); String ps = VI_LearnShare_Batchable.PROC_STEP_CREATE;
        VI_LearnShare_Batchable.submitBatchJob(ps, 10);
        Test.stopTest();
    }
}