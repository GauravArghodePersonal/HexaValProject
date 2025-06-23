@isTest
global class AbstractNextApproverBatch_T extends AbstractNextApproverBatch {
/****************************************************************************
 * Test Class AbstractNextApproverBatch_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - AbstractNextApproverBatch Apex Class
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
         Account a = TestObjects.NewAccount();
    }
  
    private static void executeTest01() {
        // Execute Tests
		AbstractNextApproverBatch_T b = new AbstractNextApproverBatch_T();
		b.log('test');
		Database.executeBatch(b, 1);				
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
    	String testSOQL = 'SELECT Id FROM Account';
        qryLocator = Database.getQueryLocator(testSOQL);
        return qryLocator;
    }
    
    global void execute(Database.BatchableContext bc, list<SObject> objs) {
    }
    
}