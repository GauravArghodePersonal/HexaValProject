public without sharing class SecureFormsController {
    @AuraEnabled
    public static GetTokenInfoResponse getTokenInfo(String token){
        List<SecureFormLink__c> result = [
            Select 
                Id,
                ExpirationDate__c,
                IsUsed__c,
                RecordType.DeveloperName
            From SecureFormLink__c
            Where Id = :token
            And IsVoid__c = false];
        return new GetTokenInfoResponse(result.isEmpty() ? null : result[0]);
    }
    @AuraEnabled
    public static AuraOperationResponse markTokenAsUsed(String token,String cipRecordId){
        SecureFormLink__c sfl = getTokenInfo(token).record;
        if(sfl == null){
            return AuraOperationResponse.getWarningResponse('Invalid token');
        }
        if(String.isNotBlank(cipRecordId)){
            sfl.CustomerInformationPacket__c = cipRecordId;
            update sfl;
        }
        sfl.IsUsed__c = true;
        sfl.CompletionDate__c = Datetime.now();
        update sfl;
        return AuraOperationResponse.getSuccessResponse();
    }
    public class GetTokenInfoResponse{
        public GetTokenInfoResponse(SecureFormLink__c link){
            record = link;
            isSuccess = false;
            if(link == null){
                message = System.Label.CIPTokenNotFound;
                return;
            }
            if(link.IsUsed__c){
                message = System.Label.CIPFormAlreadySubmitted;
                return;
            }
            if(link.ExpirationDate__c < Date.today()){
                message = System.Label.CIPTokenExpired;
                return;                
            }
            isSuccess = true;
        }
        @AuraEnabled
        public String message{get;set;}
        @AuraEnabled
        public SecureFormLink__c record{get;set;}
        @AuraEnabled
        public Boolean isSuccess{get;set;}
    }
}