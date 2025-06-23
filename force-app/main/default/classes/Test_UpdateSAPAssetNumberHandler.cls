@isTest
private class Test_UpdateSAPAssetNumberHandler{
  
  @isTest Private static void testInsertRecords() {
    
    Account Acc= TestDataFactory.createAccount(false);
    Acc.SAP_Sales_Org__c='1020';
    insert Acc;
    Asset ass = TestDataFactory.createAsset(true,Acc.Id);
    List<SAP_Asset__c> sasset = new List<SAP_Asset__c>();
    
    Test.startTest();
    
      sasset.add(new SAP_Asset__c(Equipment__c=ass.Id,SAP_Asset_Number__c='300974'));
      
      insert sasset;

    
    Test.stopTest();
    
    
  }
  
  @isTest Private static void testDeleteRecords() {
    
    Account Acc= TestDataFactory.createAccount(false);
    Acc.SAP_Sales_Org__c='1020';
    insert Acc; 
    Asset ass = TestDataFactory.createAsset(true,Acc.Id);
    List<SAP_Asset__c> sasset = new List<SAP_Asset__c>();
    
    Test.startTest();
    
      sasset.add(new SAP_Asset__c(Equipment__c=ass.Id));      
      insert sasset;
    
      // now delete a record
      delete sasset;
    
    Test.stopTest();
    
    
  }
  
}