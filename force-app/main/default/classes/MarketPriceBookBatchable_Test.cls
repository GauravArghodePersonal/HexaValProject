@isTest
private class MarketPriceBookBatchable_Test{
   public static testmethod void MarketPriceBookBatchableMethod(){
            Test.startTest();
            MarketPriceBookBatchable obj = new MarketPriceBookBatchable ('select id from AsyncApexJob');
            DataBase.executeBatch(obj); 
            Test.stopTest();
        }
        }