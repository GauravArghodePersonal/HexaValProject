@IsTest
public class SecureFormLinkEmailHelperTest {
    @TestSetup
    static void makeData(){
        String recordTypeId = SecureFormsRecordTypeController.getRecordTypeIdByDeveloperName('SecureFormLink__c', SecureFormsConstants.CUSTOMER_INFORMATION_PACKET_RECORD_TYPE);
        insert SecureFormLinkTestDataFactory.getSecureFormLinks(10, recordTypeId);
    }
    @IsTest
    static void testExecute(){
        List<Id> toProcess = new List<Id>();
        List<SecureFormLink__c> links = new List<SecureFormLink__c>();
        for(SecureFormLink__c sfl : [Select Id From SecureFormLink__c]){
            toProcess.add(sfl.Id);
            links.add(sfl);
        }
        Test.startTest();
        SecureFormLinkEmailHelper.execute(toProcess);
        Test.stopTest();
    }
    
}