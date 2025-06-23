@isTest
global class BatchTool_T implements Database.Batchable<sObject> {
/****************************************************************************
* Test Class BatchTool_T
* --------------------------------------------------------------------------
* Responsible for Testing:
*   - BatchTool Apex Class
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
        BatchTool_T testBatchJob = new BatchTool_T();
        Database.executeBatch(testBatchJob, 1);
        
        AsyncApexJob a = [SELECT Id FROM AsyncApexJob LIMIT 1];
        
        
        // Test Instance Methods
        BatchTool batchTool;

		Batch_Job_Settings__c settings = Batch_Job_Settings.retrieveBatchJobSettings('BatchTool_T',false);
		settings.Send_Results_to_Submitter_Email__c = true;
		settings.Send_Results_To_Email__c = 'test@test.test';
		settings.Send_Error_Results_to_Email__c = 'test@test.test';
        settings.Reply_To_Email__c = 'test@test.test';
        settings.Results_Subject__c = 'subject';
        settings.Create_Results_App_Log_Entry__c = true;
        settings.Create_Summary_App_Log_Entry__c = true;
        update settings;

		batchTool = new BatchTool(a.Id,false);
		batchTool.writeLog('logCategory','taskName','logType','summary','body');
		batchTool.refreshJobInfo();
		batchTool.sendNotifications();
		batchTool.sendNotifications('Test');
		batchTool.sendNotifications('Test',new List<String>());
		batchTool.sendNotifications('Test',new List<String>(),'');
		batchTool.sendNotifications('Test',new List<String>(),'','');
		batchTool.sendNotifications('Test',new List<String>(),'','','');

		batchTool = new BatchTool(a.Id,true,'processName','subProcess');
		batchTool.sendNotifications();
		List<String> errors = new List<String>();
		errors.add('error');
		batchTool.sendNotifications('Test',errors);


		// Test Static Methods
		Boolean alreadyRunning = batchTool.asyncApexJobIdIsRunning();
    } 
    
    /***************************************
     * Batch Job Implementation for Testing
     ***************************************/
    
	global Database.Querylocator start(Database.BatchableContext bc) {
	    Database.Querylocator query;
	    query = Database.getQueryLocator([SELECT Id FROM Account LIMIT 1]);
	    return query;
	}

	global void execute(Database.BatchableContext bc, List<SObject> recsIn){
	}
    
	global void finish(Database.BatchableContext bc) {
	}
}