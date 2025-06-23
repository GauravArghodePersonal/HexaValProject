@isTest
private class PricingConditionListBatchable_Test{
   public static testmethod void PricingConditionListBatchableMethod(){
        Test.startTest();
        PricingConditionListBatchable obj = new PricingConditionListBatchable ('select id from AsyncApexJob');
        DataBase.executeBatch(obj);      
        }
        }