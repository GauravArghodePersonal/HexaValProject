@isTest
private class TempBatchable_Test{
   public static testmethod void TempBatchableMethod(){
      for(Temp_Batch__c p : [select Id from Temp_Batch__c]){}
      Test.startTest();
      TempBatchable obj = new TempBatchable();
      DataBase.executeBatch(obj); 
      Test.stopTest();
      TempBatchable.submitBatchJob(10);
       }
   }