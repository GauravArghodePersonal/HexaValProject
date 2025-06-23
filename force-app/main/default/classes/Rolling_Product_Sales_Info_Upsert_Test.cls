@isTest
private class Rolling_Product_Sales_Info_Upsert_Test{
   public static testmethod void Rolling_Product_Sales_Info_UpsertMethod(){
      Test.startTest();
      Rolling_Product_Sales_Info_Upsert obj = new Rolling_Product_Sales_Info_Upsert();
      DataBase.executeBatch(obj); 
      Rolling_Product_Sales_Info_Upsert.submitBatchJob();
      Test.stopTest();
      }
  }