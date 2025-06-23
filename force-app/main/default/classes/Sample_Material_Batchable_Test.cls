@isTest
private class Sample_Material_Batchable_Test{
   public static testmethod void Sample_Material_BatchableMethod(){
      Test.startTest();
      Sample_Material_Batchable obj = new Sample_Material_Batchable(10);
      DataBase.executeBatch(obj); 
      Test.stopTest();
      Sample_Material_Batchable.submitBatchJob(200);
     }
    }