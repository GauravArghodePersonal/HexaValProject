@isTest
private class WebMethodsInterfaceResult_T {
/****************************************************************************
 * Test Class APEXCLASS_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - APEXCLASS Apex Class
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
		Account a = TestObjects.newAccount();
		WebMethodsInterfaceResult t = new WebMethodsInterfaceResult(true,'0',a.Id,'result',new List<String>());

		Account b = TestObjects.newAccount(false);
		List<sObject> accts = new List<sObject>();
		List<Account> acctsToUpsert = new List<Account>();
		acctsToUpsert.add(b);
		List<Database.upsertResult> uResults = Database.upsert(acctsToUpsert);
		accts.add(b);
		List<WebMethodsInterfaceResult> results1 = WebMethodsInterfaceResult.createFromUpsertResults('Account', 'Id', accts, uResults);
		
		List<Database.deleteResult> dResults = Database.delete(accts);
		List<WebMethodsInterfaceResult> results2 = WebMethodsInterfaceResult.createFromDeleteResults('Account', 'Id', accts, accts, dResults);
    }
}