@isTest
private class Account_Hierarchy_Batchable_Test{
   public static testmethod void Account_Hierarchy_BatchableMethod(){
     Set<String> accNums = new set<String>{'001'};
     Test.startTest();
     Account_Hierarchy_Batchable obj = new Account_Hierarchy_Batchable(accNums);
     DataBase.executeBatch(obj); 
     Test.stopTest();
 }
}