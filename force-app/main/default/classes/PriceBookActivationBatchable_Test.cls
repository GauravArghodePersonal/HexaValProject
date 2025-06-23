@isTest
private class PriceBookActivationBatchable_Test{
   public static testmethod void PriceBookActivationBatchableMethod(){
   
           PriceBookActivationBatchable obj = new PriceBookActivationBatchable();
           DataBase.executeBatch(obj);   
           PriceBookActivationBatchable.submitBatchJob();
           
        }
 }