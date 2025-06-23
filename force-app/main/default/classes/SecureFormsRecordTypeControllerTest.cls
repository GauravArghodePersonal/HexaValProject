@IsTest
public class SecureFormsRecordTypeControllerTest {
    @IsTest
    static void testGetRecordTypeId(){
        Test.startTest();
        SecureFormsRecordTypeController.getRecordTypeIdByDeveloperName('SecureFormLink__c', SecureFormsConstants.CUSTOMER_INFORMATION_PACKET_RECORD_TYPE);
        Test.stopTest();
    }
}