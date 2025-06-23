@isTest
private class PricingConditionTransferBatchable_Test{
   public static testmethod void PricingConditionTransferBatchableMethod(){
      String procStep = 'CREATE_MATERIALS';
      String procName ='MERGE_ACCOUNTS';
      Test.startTest();
      PricingConditionTransferBatchable obj = new PricingConditionTransferBatchable(procStep);
      DataBase.executeBatch(obj); 
      Test.stopTest();
      PricingConditionTransferBatchable.submitBatchJob(procStep,procName);
   }
}