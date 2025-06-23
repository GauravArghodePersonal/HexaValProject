@isTest
private class PricingApproversBatchable_Test{
   public static testmethod void PricingApproversBatchableMethod(){
      List<String> sl = new List<String>();
      sl.add('test');
      Test.startTest();
      PricingApproversBatchable obj = new PricingApproversBatchable(true,sl);
      DataBase.executeBatch(obj); 
      Test.stopTest();
      PricingApproversBatchable.submitBatchJob(true,'test');
   }
}