global with sharing class SAP_ECOM_Customer_Account_BatchProcess implements Database.Batchable<sObject>, Database.Stateful, Schedulable  {

	/********************
	 * General Constants
	 ********************/
    public static final String CLASS_NAME = 'SAP_ECOM_Customer_Account_BatchProcess';
    public static final String PROCESS_NAME = AppLogV2.PROCESS_SAPINTEGRATION;
    public static final String SUBPROCESS_NAME = AppLogV2.SUBPROCESS_SAPECOMCUSTOMER;
    public static final String CATEGORY_NAME = AppLogV2.LOGCATEGORY_BATCHPROCESS;
    public static final String TASK_NAME = 'SAP_ECOM_Customer Account Batch';
  
	/*-*-*-*-*-*-*-*-*-*-*-*
	 *                     *
	 * Schedulable Section *
	 *                     *
	 *-*-*-*-*-*-*-*-*-*-*-*/

    /* Developer Console Code Samples - Schedulable
	SAP_ECOM_Customer_Account_BatchProcess.startSchedule();
	SAP_ECOM_Customer_Account_BatchProcess.startSchedule('0 0 * * * ?');
    */

	/*************************
	 * Consts for Schedulable
	 *************************/
    public static final String SCHEDULE_NAME = 'SAP ECOM Customer Account Batch Process';
    public static final String DEFAULT_CRON = '0 15 1,5,9,13,17,21 * * ?';

	/***********************************
	 * Public Interface for Schedulable
	 ***********************************/
    global static String startSchedule() {
    	return startSchedule(DEFAULT_CRON);
    }

    global static String startSchedule(String cronExpression) {
    	String result = '';
    	try {result = SystemMethods.schedule(SCHEDULE_NAME,cronExpression,new SAP_ECOM_Customer_Account_BatchProcess());}
    	catch(Exception e) {result = e.getMessage();System.debug(e);}
    	return result;
    }

	/*****************************
	 * Schedulable Implementation 
	 *****************************/
    private SAP_ECOM_Customer_Account_BatchProcess() { 
    }

    global void execute(SchedulableContext sc) {
    	SAP_ECOM_Customer_Account_BatchProcess.submitBatchJob();
    }

	/*-*-*-*-*-*-*-*-*-*-*
	 *                   *
	 * Batchable Section *
	 *                   *
	 *-*-*-*-*-*-*-*-*-*-*/

	/* Developer Console Code Samples - Batchable
	SAP_ECOM_Customer_Account_BatchProcess.submitBatch();
	SAP_ECOM_Customer_Account_BatchProcess.submitBatch(50);
	*/

	/***********************
	 * Consts for Batchable
	 ***********************/
    public static final Integer BATCH_SIZE = 200;
	 
	/***************************
	 * Private Vars - Batchable
	 ***************************/
	private BatchTool batchTool;
    private Boolean isScheduled = false;

	/*******************************
	 * Constructor(s) for Batchable
	 *******************************/
    global SAP_ECOM_Customer_Account_BatchProcess(Boolean isScheduled) {
    	this.isScheduled = isScheduled;
    }

	/*********************************
	 * Public Interface for Batchable
	 *********************************/
    global static String submitBatchJob() {
    	return submitBatch(BATCH_SIZE);	
    }
    
    global static String submitBatchJob(Integer batchSize) {
    	return submitBatch(batchSize);	
    }

	/***************************************
	 * Private Static Methods for Batchable
	 ***************************************/
    private static String submitBatch(Integer batchSize) {
        String msg; 
    	if (!BatchTool.alreadyRunning('SAP_ECOM_Customer_Account_BatchProcess')) {
	        SAP_ECOM_Customer_Account_BatchProcess b = new SAP_ECOM_Customer_Account_BatchProcess(System.isScheduled());
	        try {msg = Database.executeBatch(b, batchSize);} catch(Exception e) {msg = e.getMessage();System.debug(e);}
    	} 
    	else {
    		msg = 'Job is already Running';
    		AppLogV2 appLog = new AppLogV2(PROCESS_NAME,SUBPROCESS_NAME,CLASS_NAME,'');
	       	appLog.write(AppLogV2.LOGCATEGORY_BATCHPROCESS,AppLogV2.TASK_BATCHPROCESSSKIPPED,AppLogV2.LOGTYPE_INFO,AppLogV2.TASK_BATCHPROCESSSKIPPED,AppLogV2.TASK_BATCHPROCESSSKIPPED);
    	}
        return msg;
    }
    	
	/********************************
	 * Private Methods for Batchable
	 ********************************/
	/***************************
	 * Batchable Implementation
	 ***************************/
    global Database.Querylocator start(Database.BatchableContext bc) {
    	batchTool = new BatchTool(bc.getJobId(), isScheduled, PROCESS_NAME, SUBPROCESS_NAME);
    	
        Database.Querylocator query;
         
        DateTime lastRunDateTime = SAP_ECOM_Customer_Settings.retrieveAccountLastRunDateTime();
        SAP_ECOM_Customer_Settings.updateAccountNewBatchJobStarted(DateTime.now());
        SAP_ECOM_Customer_Settings.updateAccountBatchJobRunning(true);
        
       	query = Database.getQueryLocator([SELECT Id,
       	                                         RecordTypeId,
       	                                         SAP_Dist_Channel_Desc__c,
       	                                         SAP_DivisionCode__c
       	                                    FROM Account WHERE SystemModstamp >= :lastRunDateTime]);
        return query;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn) {
        List<Account> accountsIn = (List<Account>)recsIn;
        List<Account> recsToProcess = new List<Account>();
        
        for (Account rec:accountsIn) {
        	if (SAP_ECOM_Customer.validAccountforBatchProcessing(rec)) {recsToProcess.add(rec);}
        } 
        
        if (recsToProcess.size() > 0) {
	        SAP_ECOM_Customer.processAccounts(recsToProcess);
        }
    }
     
    global void finish(Database.BatchableContext bc) {
    	batchTool.sendNotifications(TASK_NAME);

        batchTool.refreshJobInfo();
        if (batchTool.jobInfo.NumberOfErrors == 0) {
	        DateTime newLastRunDateTime = SAP_ECOM_Customer_Settings.retrieveAccountNewBatchJobStarted();
        	SAP_ECOM_Customer_Settings.updateAccountLastRunDateTime(newLastRunDateTime);
        }

        SAP_ECOM_Customer_Settings.updateAccountNewBatchJobStarted(null);
        SAP_ECOM_Customer_Settings.updateAccountBatchJobRunning(false);
    }
}