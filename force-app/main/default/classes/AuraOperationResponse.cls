public inherited sharing class AuraOperationResponse {
    public AuraOperationResponse(String operationResult,String message){
        this.operationResult = operationResult;
        this.message = message;
    }
    @AuraEnabled
    public String operationResult{get;set;}
    @AuraEnabled
    public String message{get;set;}
    public static AuraOperationResponse getSuccessResponse(){
        return new AuraOperationResponse(SecureFormsConstants.AURA_OPERATION_RESPONSE_SUCCESS,null);
    }
    public static AuraOperationResponse getWarningResponse(String message){
        return new AuraOperationResponse(SecureFormsConstants.AURA_OPERATION_RESPONSE_WARNING,message);
    }
}