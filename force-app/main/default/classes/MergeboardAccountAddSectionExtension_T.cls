@isTest
private class MergeboardAccountAddSectionExtension_T {
/****************************************************************************
 * Test Class MergeboardAccountAddSectionExtension_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - MergeboardAccountAddSectionExtension Apex Class
 ****************************************************************************/
 
    //Test Data
    
    
    //Test Settings
    
    
    private static testMethod void myUnitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        // No Test Data Needed
    }
  
    private static void executeTest01() {
        // Execute Tests
        Account a = TestObjects.NewAccount();
        ApexPages.currentpage().getparameters().put( 'id', a.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        MergeboardAccountAddSectionExtension e = new MergeboardAccountAddSectionExtension(sc);

		e.refreshShowValues();
		e.addToMergeboard();
		e.removeFromMergeboard();
		e.openingMergeboardURL();
		e.openMergeboardURL();

		Integer i = e.mergeboardItemCount;
		String s = e.mergeboardItemSummary;
    }
}