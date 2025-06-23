@isTest
private class Internal_Complaint_Batchable_Test {
   public static testmethod void Internal_Complaint_BatchableMethod(){
            Internal_Complaint__c com = new Internal_Complaint__c();
            com.Status__c = 'Closed - Resolved';
            insert com;
            Test.startTest();
            Internal_Complaint_Batchable int2 = new Internal_Complaint_Batchable(10000,true);
            String intr = '0 0 * * * ?';
            system.schedule('Test Shedule', intr,int2);
            Internal_Complaint_Batchable obj = new Internal_Complaint_Batchable(200,true);
            Internal_Complaint_Batchable obj1 = new Internal_Complaint_Batchable(10000,false);
            DataBase.executeBatch(obj);
            DataBase.executeBatch(obj1); 
            Test.stopTest();
            Internal_Complaint_Batchable.submitBatchJob(200,true);
            Internal_Complaint_Batchable.submitBatchJob(10000,false);
       }
  }