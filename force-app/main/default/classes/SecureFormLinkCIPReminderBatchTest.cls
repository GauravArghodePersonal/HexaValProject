@IsTest
public class SecureFormLinkCIPReminderBatchTest {
    @TestSetup
    static void makeData(){
        String recordTypeId = SecureFormsRecordTypeController.getRecordTypeIdByDeveloperName('SecureFormLink__c', SecureFormsConstants.CUSTOMER_INFORMATION_PACKET_RECORD_TYPE);
        List<SecureFormLink__c> links = SecureFormLinkTestDataFactory.getSecureFormLinks(10, recordTypeId);
        Integer daysToSendFirstReminder = Integer.valueOf(SecureFormParameter__mdt.getInstance('DaysToSendFirstReminder').Value__c);
        for(SecureFormLink__c link : links){
            Date lastReminderDate = Date.today().addDays((daysToSendFirstReminder * -1));
            link.LastReminderDate__c = lastReminderDate;
        }
        insert links;
    }
    @IsTest
    static void testBatch(){
        Test.startTest();
        Database.executeBatch(new SecureFormLinkCIPReminderBatch());
        Test.stopTest();
    }
}