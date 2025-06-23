@isTest
private class Sample_Request_Feedback_Test {

    static Sample_Request__c srq;
    static List<Sample_Material__c> sms;
    
    static void createTestData() {
        srq = new Sample_Request__c();
        insert srq;
        
        sms = new List<Sample_Material__c>();
        Sample_Material__c sm = new Sample_Material__c();
        sm.Sample_Request__c = srq.Id;
        sms.add(sm);
        insert sms;
    }
    
    static testMethod void test01() {
        createTestData();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(srq);
        Sample_Request_Feedback c = new Sample_Request_Feedback(sc);
        Sample_Request_Feedback sam = new Sample_Request_Feedback ();
        sam.copyFeedbackToMaterials();
        sam.cancel();
    
    }
}