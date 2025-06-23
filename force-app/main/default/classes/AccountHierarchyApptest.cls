@isTest
private class AccountHierarchyApptest{
    @isTest 
    Private static void AccountHierarchyApptests(){
        account acc =TestDataFactory.createAccount(true);
        AccountHierarchyApp.getOrgUrl();
        string accid=acc.id;
        AccountHierarchyApp.getAccountHierarchy(accid,false);
    }
  }