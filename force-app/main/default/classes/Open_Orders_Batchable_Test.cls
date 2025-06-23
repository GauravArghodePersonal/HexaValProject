@isTest
private class Open_Orders_Batchable_Test {
   public static testmethod void Open_Orders_BatchableMethod(){
    Test.startTest();
            Open_Orders_Batchable obj = new Open_Orders_Batchable ('select id from AsyncApexJob','select Status from AsyncApexJob');
            DataBase.executeBatch(obj); 
        Test.stopTest();
        Open_Orders_Batchable.submitBatchJob(Open_Orders_Batchable.UPDATE_SAMPLE_REQUESTS,'10');
        }
        }