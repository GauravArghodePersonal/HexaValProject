@isTest
private class BatchRunner_T {
/****************************************************************************
 * Test Class BatchRunner_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - BatchRunner Apex Class
 *   - BatchRunnerBatchJob Apex Class
 *   - BatchRunnerJobs Apex Class
 *   - BatchRunnerSchedulable Apex Class
 ****************************************************************************/
 
    //Test Data
    public static Market_Price_Book_Entry__c marketPriceBookEntry = new Market_Price_Book_Entry__c();
    public static Id mpbeId = marketPriceBookEntry.Id; 

    public static BatchRunner.Entry entry1 = new BatchRunner.Entry('Market Price Book Entry Change',mpbeId);
    public static BatchRunner.Entry entry2 = new BatchRunner.Entry('Market Price Book Entry Change',mpbeId,'param2');
    public static BatchRunner.Entry entry3 = new BatchRunner.Entry('Market Price Book Entry Change',mpbeId,'param2','param3');
    
    
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
		BatchRunner.addEntry('Market Price Book Entry Change',mpbeId);
        BatchRunner.addEntry('Market Price Book Entry Change',mpbeId,'param2');
        BatchRunner.addEntry('Market Price Book Entry Change',mpbeId,'param2','param3');

		BatchRunner.addEntries(entry1);

		List<BatchRunner.Entry> entries = new List<BatchRunner.Entry>();
		entries.add(entry1);		

		BatchRunner.addEntries(entries);

		List<Batch_Runner_Queue_Entry__c> queueEntriestoProcess = new List<Batch_Runner_Queue_Entry__c>();
		queueEntriestoProcess = [SELECT Id, Type__c, Param_1__c, Param_2__c, Param_3__c, Processed__c, Errors_Occurred__c, Results__c, Priority__c 
       		                       FROM Batch_Runner_Queue_Entry__c 
       		                      WHERE Processed__c = FALSE
       		                     ORDER BY Priority__c DESC, CreatedDate
       		                      LIMIT 50000
       		                    ];
		
		BatchRunner.processQueueEntries(queueEntriestoProcess);
    }

}