@isTest
private class Public_Calendar_T {

/****************************************************************************
 * Test Class Public_Calendar_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Public_Calendar Apex Class
 ****************************************************************************/
 
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
	    Public_Calendar__c settings;
	    settings = new Public_Calendar__c(Name='Test');
	    settings.Public_Calendar_Id__c = '001000000000000';
	    insert settings;
    }
  
    private static void executeTest01() {
        // Execute Tests
		Public_Calendar.getId('Bad');
		Public_Calendar.getId('Test');
    }
}