public class SolenisBusinessContractExpireController{
 @AuraEnabled
    public static Business_Contract__c bContExpire(Id bcontId){
        try{
            Business_Contract__c bCont = [SELECT Id, Name,Status__c  
                   FROM Business_Contract__c
                   WHERE Id=:bcontId];   
                bCont.Status__c='Inactive';                  
               Update bCont;   
            return bCont;
        }
        catch (Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
}