@isTest
private class MassTouchBatchProcessor_Test {
   public static testmethod void MassTouchBatchProcessorMethod(){
    Test.startTest();
            MassTouchBatchProcessor obj = new MassTouchBatchProcessor('select id from AsyncApexJob','select Status from AsyncApexJob');
            DataBase.executeBatch(obj); 
        Test.stopTest();
        }
        }