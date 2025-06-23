@isTest
private class SampleRequestApprovalController_Test {

    static List<SampleRequestApprovalController.SampleRequest> srs;
    static Set<String> srids;
    
    static void createTestData() {
        Map<String, Id> rtmap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        Id rtid = rtmap.get('Aqualon Customer');
        Account a  = new Account(Name='TestAccount',
                                 AccountNumber='Prospect',
                                 SAP_Sales_Org__c='0315',
                                 RecordTypeId=rtid);
        insert a;
        Sample_Request__c sr = new Sample_Request__c(Account__c=a.Id);
        insert sr;
        Sample_Material__c sm = new Sample_Material__c(Name='TestMaterial',
                                                       Sample_Request__c=sr.Id);
        insert sm;
        srids = new Set<String>{sr.Id};
    }
    
    static testMethod void test01() {
        createTestData();
        SampleRequestApprovalController c = new SampleRequestApprovalController();
        c.getSampleReqsPendingApproval();
        c.userComments = 'TestComments';
        srs = c.getSampleRequests(srids);
        for (SampleRequestApprovalController.SampleRequest sr : srs) {sr.selected = true;}
        c.approveSelectedList(); c.rejectSelectedList();
        Test.startTest();
        Test.stopTest();
    }
}