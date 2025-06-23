@IsTest
public class SecureFormsControllerTest {
    @TestSetup
    static void makeData(){
        String recordTypeId = SecureFormsRecordTypeController.getRecordTypeIdByDeveloperName('SecureFormLink__c', SecureFormsConstants.CUSTOMER_INFORMATION_PACKET_RECORD_TYPE);
        insert SecureFormLinkTestDataFactory.getSecureFormLinks(10, recordTypeId);
    }
    @IsTest
    static void testGetTokenInfo(){
        SecureFormLink__c link = [Select Id From SecureFormLink__c Limit 1];
        Test.startTest();
        //Success case
        SecureFormsController.GetTokenInfoResponse response = SecureFormsController.getTokenInfo(link.Id);
        System.assertEquals(true, response.isSuccess,'Should return a success response');
        link.ExpirationDate__c = Date.today().addDays(-1);
        update link;
        //Expired token case
        response = SecureFormsController.getTokenInfo(link.Id);
        System.assertEquals(false, response.isSuccess,'Should return a non-success response');
        link.IsUsed__c = true;
        update link;
        //Used token case
        response = SecureFormsController.getTokenInfo(link.Id);
        System.assertEquals(false, response.isSuccess,'Should return a non-success response');
        link.IsVoid__c = true;
        update link;
        response = SecureFormsController.getTokenInfo(link.Id);
        System.assertEquals(false, response.isSuccess,'Should return a non-success response');
        Test.stopTest();
    }
    @IsTest
    static void testMarkTokenAsUsed(){
        SecureFormLink__c link = [Select Id From SecureFormLink__c Limit 1];
        Test.startTest();
        //Success case
        AuraOperationResponseTest.assertSuccessResponse(SecureFormsController.markTokenAsUsed(link.Id,''));
        //Token not exist case
        AuraOperationResponseTest.assertWarningResponse(SecureFormsController.markTokenAsUsed(null,''));
        Test.stopTest();
        
    }
}