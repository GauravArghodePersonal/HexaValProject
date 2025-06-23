@isTest
private class Email_Functions_T {
/****************************************************************************
 * Test Class Email_Functions_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - Email_Functions Apex Class
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
        // No Test Data Needed
    }
  
    private static void executeTest01() {
        // Execute Tests
	    List<String> toAddresses = new List<String>();
	    toAddresses.add('solenissfdcsupport@solenis.com');
	
	    Boolean result = Email_Functions.sendEmail(toAddresses,
	                               null,
	                               null,
	                               'solenissfdcsupport@solenis.com','SolenisSSO SFDC',
	                               false,false,
	                               'Test Class',
	                               'This is a test of the Test Class.',null);       
	                                                       
	    System.assertEquals(true,result);                               
    }
}