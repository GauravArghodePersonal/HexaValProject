@isTest
private class ARTRequestManagementControllerMethods_T {
/****************************************************************************
 * Test Class ARTRequestManagementControllerMethods_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ARTRequestManagementControllerMethods Apex Class
 ****************************************************************************/
 
    //Test Data
    public static ARTRequestManagementControllerMethods.URLParameters urlParameters;
    public static List<Id> ids;     
    
    //Test Settings
    public static Map<String,String> fakeURLParameters1 = new Map<String,String>();
    public static Map<String,String> fakeURLParameters2 = new Map<String,String>();
    public static Map<String,String> fakeURLParameters3 = new Map<String,String>();
    public static Map<String,String> fakeURLParameters4 = new Map<String,String>();
    
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
    	fakeURLParameters1.put('devUserId','005000000000000');

    	fakeURLParameters2.put('devUserId','unassigned');
    	
    	fakeURLParameters3.put('showOnlyMe','true');
    	
    	fakeURLParameters4.put('hiddenColumnsOverride','Status__c');
    }
  
    private static void executeTest01() {
        // Execute Tests
		urlParameters = new ARTRequestManagementControllerMethods.URLParameters(fakeURLParameters1); 
		urlParameters = new ARTRequestManagementControllerMethods.URLParameters(fakeURLParameters2); 
		urlParameters = new ARTRequestManagementControllerMethods.URLParameters(fakeURLParameters3); 
		urlParameters = new ARTRequestManagementControllerMethods.URLParameters(fakeURLParameters4); 

		ids = ARTRequestManagementControllerMethods.determineInitialProjectIds('');
		ids = ARTRequestManagementControllerMethods.determineInitialProjectIds('001000000000000');

		ids = ARTRequestManagementControllerMethods.determineInitialReleaseIds('');
		ids = ARTRequestManagementControllerMethods.determineInitialReleaseIds('001000000000000');
    }
}