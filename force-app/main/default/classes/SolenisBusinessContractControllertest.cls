@isTest
private class SolenisBusinessContractControllertest{
      @isTest 
    Private static void SolenisBusinessContractests(){
        Account Acc= TestDataFactory.createAccount(True); 
        Business_Contract__c Bc = New Business_Contract__c();
        Bc.Customer_Name__c  =Acc.id;
        Bc.Annual_Contract_Sales_Revenue__c=10;
        insert Bc;
        
        SolenisBusinessContractExpireController.bContExpire(Bc.id);    
    }
     
 }