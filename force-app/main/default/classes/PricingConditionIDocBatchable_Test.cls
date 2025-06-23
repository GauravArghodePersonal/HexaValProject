@isTest
private class PricingConditionIDocBatchable_Test {
   public static testmethod void PricingConditionIDocBatchableMethod(){
    Test.startTest();
    PricingConditionIDocBatchable obj = new PricingConditionIDocBatchable();
    DataBase.executeBatch(obj); 
    Test.stopTest();
    PricingConditionIDocBatchable.submitBatchJob();
        }
        }