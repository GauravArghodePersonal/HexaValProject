@isTest
private class solenis_Commercial_UserLookupTests{
     @isTest
    static void search_should_return_Account_and_Opportunity() {
        List<Id> fixedResults = new List<Id>(2);
        user account = TestDataFactory.createUser(true,'test1@solenis.com.test','12345');
        fixedResults.add(account.Id);
       // Opportunity oppty = createOpportunity('Oppty');
     // fixedResults.add(oppty.Id);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();

      solenis_Commercial_UserLookupController.search('Acc', selectedIds);

        
    }

    @isTest
    static void search_should_not_return_selected_item() {
        List<Id> fixedResults = new List<Id>(2);
        User account1 = TestDataFactory.createUser(true,'test2@solenis.com.test','3456789');
        fixedResults.add(account1.Id);
        user account2 = TestDataFactory.createUser(true,'test3@solenis.com.test','09876543');
        fixedResults.add(account2.Id);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();
        selectedIds.add(account2.Id);

        solenis_Commercial_UserLookupController.search('test', selectedIds);

       
    }
  
}