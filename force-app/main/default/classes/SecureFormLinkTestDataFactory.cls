@IsTest
public class SecureFormLinkTestDataFactory {
    public static List<SecureFormLink__c> getSecureFormLinks(Integer count,String recordTypeId){
        List<SecureFormLink__c> toReturn = new List<SecureFormLink__c>();
        String emails = 'test@domain.com;test1@domain.com';
        Date expiration = Date.today().addDays(10);
        for(Integer i = 1; i<= count;i++){
            toReturn.add(new SecureFormLink__c(
                RecordTypeId = recordTypeId,
                ToAddress__c = emails,
                Body__c = 'Test',
                ExpirationDate__c = expiration
            ));
        }
        return toReturn;
    }
}