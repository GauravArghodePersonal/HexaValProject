@isTest
private class BusinessContractNextApproverBatch_Test{
   public static testmethod void BusinessContractNextApproverBatchMethod(){
      List<ProcessInstance> piList = new  List<ProcessInstance>();
      ProcessInstance pr = new ProcessInstance();
      Business_Contract__c bu = new Business_Contract__c();
      Test.startTest();
      BusinessContractNextApproverBatch obj = new BusinessContractNextApproverBatch();
      DataBase.executeBatch(obj); 
      Test.stopTest();
    }
}