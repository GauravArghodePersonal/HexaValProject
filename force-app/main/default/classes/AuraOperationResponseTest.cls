@IsTest
public class AuraOperationResponseTest {
    @IsTest
    static void testGetSuccessResponse(){
        Test.startTest();
        AuraOperationResponse response = AuraOperationResponse.getSuccessResponse();
        assertSuccessResponse(response);
        Test.stopTest();
    }
    @IsTest
    static void testGetWarningResponse(){
        String message = 'Dummy warning';
        Test.startTest();
        AuraOperationResponse response = AuraOperationResponse.getWarningResponse(message);
        System.assertEquals(message, response.message,'Should have the specified message');
        assertWarningResponse(response);
        Test.stopTest();
    }
    public static void assertWarningResponse(AuraOperationResponse response){
        System.assertEquals(SecureFormsConstants.AURA_OPERATION_RESPONSE_WARNING, response.operationResult,'Should return a warning response');
    }
    public static void assertSuccessResponse(AuraOperationResponse response){
        System.assertEquals(SecureFormsConstants.AURA_OPERATION_RESPONSE_SUCCESS, response.operationResult,'Should return a success response');
    }
}