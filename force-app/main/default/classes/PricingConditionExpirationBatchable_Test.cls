@isTest
private class PricingConditionExpirationBatchable_Test{
   public static testmethod void PricingConditionExpirationBatchableMethod(){
      Test.startTest();
      PricingConditionExpirationBatchable obj = new PricingConditionExpirationBatchable();
      DataBase.executeBatch(obj); 
      Test.stopTest();
      PricingConditionExpirationBatchable.submitBatchJob();
       }
   }