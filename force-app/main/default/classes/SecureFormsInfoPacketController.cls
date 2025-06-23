public without sharing class SecureFormsInfoPacketController {
    @AuraEnabled
    public static Account getCustomerCreationRequest(Id recordId){
        List<SecureFormLink__c> result = [SELECT Id,Name,Account__c
                                                    FROM SecureFormLink__c 
                                                    WHERE Id = :recordId];
        String AccountId = result.isEmpty() ? null: result[0].Account__c;
        

        List<Account> accountResult = [SELECT Id,OwnerId,Name
                                                    FROM Account
                                                    WHERE Id = :AccountId];
        return accountResult.isEmpty() ? null : accountResult[0];
    }

    @AuraEnabled
    public static String insertCustomerCreationRequest(Customer_Information_Packet__c record, string idAccount){
        record.Account_Name__c = idAccount;

        try {
            insert record;
            
            
        } catch (Exception e) {

            String errorMsg = e.getMessage();
            throw new AuraHandledException(ErrorMsg);
        }
        return record.Id;
    }
}