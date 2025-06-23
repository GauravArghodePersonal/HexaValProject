global with sharing class SAP_ECOM_Customer_BatchProcess implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
  
	/********************
	 * General Constants
	 ********************/
    public static final String CLASS_NAME = 'SAP_ECOM_Customer_BatchProcess';
    public static final String PROCESS_NAME = AppLogV2.PROCESS_SAPINTEGRATION;
    public static final String SUBPROCESS_NAME = AppLogV2.SUBPROCESS_SAPECOMCUSTOMER;
    public static final String CATEGORY_NAME = AppLogV2.LOGCATEGORY_BATCHPROCESS;
    public static final String TASK_NAME = 'SAP_ECOM_Customer Batch';
    public static final String TASK_NAME_UPDATE_ACCOUNT_LOOKUPS = 'SAP_ECOM_Customer Batch - Update Account Lookups';
  
	/*-*-*-*-*-*-*-*-*-*-*-*
	 *                     *
	 * Schedulable Section *
	 *                     *
	 *-*-*-*-*-*-*-*-*-*-*-*/

    /* Developer Console Code Samples - Schedulable
	SAP_ECOM_Customer_BatchProcess.startSchedule();
	SAP_ECOM_Customer_BatchProcess.startSchedule('0 0 * * * ?');
    */

	/*************************
	 * Consts for Schedulable
	 *************************/
    public static final String SCHEDULE_NAME = 'SAP ECOM Customer Batch Process';
    public static final String DEFAULT_CRON = '0 30 0,4,8,12,16,20 * * ?';

	/***********************************
	 * Public Interface for Schedulable
	 ***********************************/
    global static String startSchedule() {
    	return startSchedule(DEFAULT_CRON);
    }

    global static String startSchedule(String cronExpression) {
    	String result = '';
    	try {result = SystemMethods.schedule(SCHEDULE_NAME,cronExpression,new SAP_ECOM_Customer_BatchProcess());}
    	catch(Exception e) {result = e.getMessage();System.debug(e);}
    	return result;
    }

	/*****************************
	 * Schedulable Implementation 
	 *****************************/
    private SAP_ECOM_Customer_BatchProcess() { 
    }

    global void execute(SchedulableContext sc) {
    	SAP_ECOM_Customer_BatchProcess.submitBatchJob();
    }

	/*-*-*-*-*-*-*-*-*-*-*
	 *                   *
	 * Batchable Section *
	 *                   *
	 *-*-*-*-*-*-*-*-*-*-*/

	/* Developer Console Code Samples - Batchable
	SAP_ECOM_Customer_BatchProcess.updateAccountLookups();
	SAP_ECOM_Customer_BatchProcess.submitBatchJob();
	SAP_ECOM_Customer_BatchProcess.submitBatchJob(50);
	*/ 

	/***********************
	 * Consts for Batchable
	 ***********************/
    public static final Integer BATCH_SIZE = 200;
    private static final String UPDATE_ACCOUNT_LOOKUPS = 'UPDATE_ACCOUNT_LOOKUPS';
    private static final String FULL_PROCESSING = 'FULL_PROCESSING';
    

	/***************************
	 * Private Vars - Batchable
	 ***************************/
	private BatchTool batchTool;
    private Boolean isScheduled = false;
    private String jobType = '';

	/*******************************
	 * Constructor(s) for Batchable
	 *******************************/
    global SAP_ECOM_Customer_BatchProcess(Boolean isScheduled, String jobType) {
    	this.isScheduled = isScheduled;
    	this.jobType = jobType;
    }

	/*********************************
	 * Public Interface for Batchable
	 *********************************/
    global static String updateAccountLookups() {
    	return submitBatch(BATCH_SIZE,UPDATE_ACCOUNT_LOOKUPS);	
    }
    
    global static String submitBatchJob() {
    	return submitBatch(BATCH_SIZE,FULL_PROCESSING);	
    }

    global static String submitBatchJob(Integer batchSize) {
    	return submitBatch(batchSize,FULL_PROCESSING);	
    }
    
	/***************************************
	 * Private Static Methods for Batchable
	 ***************************************/
    private static String submitBatch(Integer batchSize, String jobType) {
        String msg;
    	if (!BatchTool.alreadyRunning('SAP_ECOM_Customer_BatchProcess')) {
	        SAP_ECOM_Customer_BatchProcess b = new SAP_ECOM_Customer_BatchProcess(System.isScheduled(),jobType);
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
       	query = Database.getQueryLocator([SELECT Id,
       	                                         Dist_Channel__c,
       	                                         Division__c
       	                                    FROM SAP_ECOM_Customer__c
       	                                   WHERE Del_Flag__c = ''
       	                                 ]);
        return query;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn){
        List<SAP_ECOM_Customer__c> ecomCustRecsIn = (List<SAP_ECOM_Customer__c>)recsIn;
        List<SAP_ECOM_Customer__c> recsToProcess = new List<SAP_ECOM_Customer__c>();
        
    	if (jobType == FULL_PROCESSING) {
	        for (SAP_ECOM_Customer__c rec:ecomCustRecsIn) {
	        	if (SAP_ECOM_Customer.validSAPECOMCustomerRecordforBatchProcessing(rec)) {recsToProcess.add(rec);}
	        } 
        
	        if (recsToProcess.size() > 0) {
		        SAP_ECOM_Customer.processSAPECOMCustomers(recsToProcess);
        	}
    	}
    	else if (jobType == UPDATE_ACCOUNT_LOOKUPS) {
       		SAP_ECOM_Customer.refreshAccountLookupFields(ecomCustRecsIn);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        	if (jobType == FULL_PROCESSING) {
		    	batchTool.sendNotifications(TASK_NAME);
        	}
        	else if (jobType == UPDATE_ACCOUNT_LOOKUPS) {
		    	batchTool.sendNotifications(TASK_NAME_UPDATE_ACCOUNT_LOOKUPS);
        	}
    }
}