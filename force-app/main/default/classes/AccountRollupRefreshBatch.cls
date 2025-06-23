global with sharing class AccountRollupRefreshBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
  
	/********************
	 * General Constants
	 ********************/
    public static final String CLASS_NAME = 'AccountRollupRefreshBatch';
    public static final String PROCESS_NAME = AppLogV2.PROCESS_ACCOUNTMANAGEMENT;
    public static final String SUBPROCESS_NAME = AppLogV2.SUBPROCESS_ACCOUNTROLLUPS;
    public static final String CATEGORY_NAME = AppLogV2.LOGCATEGORY_BATCHPROCESS;
    public static final String TASK_NAME = 'Account Recalc Rollups';
  
	/*-*-*-*-*-*-*-*-*-*-*-*
	 *                     *
	 * Schedulable Section *
	 *                     *
	 *-*-*-*-*-*-*-*-*-*-*-*/

    /* Developer Console Code Samples - Schedulable
	AccountRollupRefreshBatch.startSchedule();
	AccountRollupRefreshBatch.startSchedule('0 0 * * * ?');
    */

	/*************************
	 * Consts for Schedulable
	 *************************/
    public static final String SCHEDULE_NAME = 'AccountRollup Recalc';
    public static final String DEFAULT_CRON = '0 0 * * * ?';

	/***********************************
	 * Public Interface for Schedulable
	 ***********************************/
    global static String startSchedule() {
    	return startSchedule(DEFAULT_CRON);
    }

    global static String startSchedule(String cronExpression) {
    	String result = '';
    	try {result = SystemMethods.schedule(SCHEDULE_NAME,cronExpression,new AccountRollupRefreshBatch());}
    	catch(Exception e) {result = e.getMessage();System.debug(e);}
    	return result;
    }

	/*****************************
	 * Schedulable Implementation 
	 *****************************/
    private AccountRollupRefreshBatch() { 
    }

    global void execute(SchedulableContext sc) {
    	AccountRollupRefreshBatch.submitBatchJob();
    }

	/*-*-*-*-*-*-*-*-*-*-*
	 *                   *
	 * Batchable Section *
	 *                   *
	 *-*-*-*-*-*-*-*-*-*-*/

	/* Developer Console Code Samples - Batchable
	AccountRollupRefreshBatch.submitBatchJob();
	AccountRollupRefreshBatch.submitBatchJob_RefreshAll(5,2000000);
	AccountRollupRefreshBatch.submitBatchJob_RefreshAll_ValidateOnly();
	*/ 

	/***********************
	 * Consts for Batchable
	 ***********************/
    public static final Integer BATCH_SIZE = 4;
    public static final Integer BATCH_SIZE_VALIDATE_ONLY = 200;
    public static final Integer QUERY_ROW_LIMIT = 200000;
    public static final Integer QUERY_ROW_LIMIT_VALIDATE_ONLY = 2000000;

	/***************************
	 * Private Vars - Batchable
	 ***************************/
	private BatchTool batchTool;
    private Boolean isScheduled = false;

    private Boolean refreshAll = false;
    private Boolean onlyPerformAccountRollupValidation = false;
    private Integer queryRowLimit = AccountRollupRefreshBatch.QUERY_ROW_LIMIT;

    private List<String> allErrors = new List<String>();

	/*******************************
	 * Constructor(s) for Batchable
	 *******************************/
    global AccountRollupRefreshBatch(Boolean isScheduled, Boolean refreshAll, Boolean onlyPerformAccountRollupValidation, Integer queryRowLimit) {
    	this.isScheduled = isScheduled;
    	this.refreshAll = refreshAll;
    	this.onlyPerformAccountRollupValidation = onlyPerformAccountRollupValidation;
    	this.queryRowLimit = queryRowLimit;
    }

	/*********************************
	 * Public Interface for Batchable
	 *********************************/
    global static String submitBatchJob() {
    	return submitBatch(false,false,BATCH_SIZE,QUERY_ROW_LIMIT);
    }

    global static String submitBatchJob(Integer BatchSizeOverride) {
    	return submitBatch(false,false,BatchSizeOverride,QUERY_ROW_LIMIT);
    }

    global static String submitBatchJob(Integer BatchSizeOverride, Integer queryRowLimitOverride) {
    	return submitBatch(false,false,BatchSizeOverride,queryRowLimitOverride);
    }

    global static String submitBatchJob_RefreshAll() {
    	return submitBatch(true,false,BATCH_SIZE,QUERY_ROW_LIMIT);
    }
    
    global static String submitBatchJob_RefreshAll(Integer BatchSizeOverride) {
    	return submitBatch(true,false,BatchSizeOverride,QUERY_ROW_LIMIT);
    }
    
    global static String submitBatchJob_RefreshAll(Integer BatchSizeOverride, Integer queryRowLimitOverride) {
    	return submitBatch(true,false,BatchSizeOverride,queryRowLimitOverride);
    }
    
    global static String submitBatchJob_RefreshAll_ValidateOnly() {
    	return submitBatch(true,true,BATCH_SIZE_VALIDATE_ONLY,QUERY_ROW_LIMIT_VALIDATE_ONLY);
    }

	/***************************************
	 * Private Static Methods for Batchable
	 ***************************************/
    private static String submitBatch(Boolean refreshAll,Boolean onlyPerformAccountRollupValidation,Integer batchSize,Integer queryRowLimit) {
        String msg;
    	if (!BatchTool.alreadyRunning('AccountRollupRefreshBatch')) {
	        AccountRollupRefreshBatch b = new AccountRollupRefreshBatch(System.isScheduled(),refreshAll,onlyPerformAccountRollupValidation,queryRowLimit);
	        try {msg = Database.executeBatch(b, batchSize);} catch(Exception e) {msg = e.getMessage();System.debug(e);}
    	} 
    	else {
    		msg = 'Job is already Running';
    		AppLogV2 appLog = new AppLogV2(PROCESS_NAME,SUBPROCESS_NAME,CLASS_NAME,'');
	       	appLog.write(AppLogV2.LOGCATEGORY_BATCHPROCESS,AppLogV2.TASK_BATCHPROCESSSKIPPED,AppLogV2.LOGTYPE_INFO,AppLogV2.TASK_BATCHPROCESSSKIPPED,AppLogV2.TASK_BATCHPROCESSSKIPPED);
    	}
        return msg;
    }
	
	/***************************
	 * Batchable Implementation
	 ***************************/
    global Database.Querylocator start(Database.BatchableContext bc) {
    	batchTool = new BatchTool(bc.getJobId(), isScheduled, PROCESS_NAME, SUBPROCESS_NAME);
    	
        Database.Querylocator query;
        if (refreshAll) {
        	if (!onlyPerformAccountRollupValidation) {
        		query = Database.getQueryLocator([SELECT Id, ParentId, Parent_Chain__c, CurrencyIsoCode FROM Account WHERE Id IN (SELECT Child_Account__c FROM Account_Relationship__c) LIMIT :queryRowLimit]);
        	}
        	else {
        		query = Database.getQueryLocator([SELECT Id, ParentId, Parent_Chain__c, CurrencyIsoCode FROM Account WHERE Id IN (SELECT Child_Account__c FROM Account_Relationship__c) AND Account_Rollup__c = null LIMIT :queryRowLimit]);
        	}
        }
        else {
        	query = Database.getQueryLocator([SELECT Id, ParentId, Parent_Chain__c, CurrencyIsoCode FROM Account WHERE Id IN (SELECT Child_Account__c FROM Account_Relationship__c WHERE Recalc_Needed__c = TRUE) LIMIT :queryRowLimit]);
        }
        
        return query;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn) {
        List<Account> accountstoProcess = (List<Account>)recsIn;
        if (onlyPerformAccountRollupValidation) {
        	Account_Rollup.validateAccountRollupRecsExist(accountstoProcess);
        } 
        else {
        	Account_Rollup.RecalcRollupsResult results = Account_Rollup.recalcRollups(accountstoProcess);

    		if (results.errors.size() > 0) {
    			batchTool.writeLog(CATEGORY_NAME,'Refresh Errors',AppLogV2.LOGTYPE_ERROR,'Errors Occurred in Batch Process','Errors Occurred = ' + String.join(results.errors,'\n'));
	        	
	        	if (allErrors.size() + results.errors.size() < 1000) {
	        		allErrors.addAll(results.errors);
	        	}
    		}
        	
        }
    }
     
    global void finish(Database.BatchableContext bc) {
    	batchTool.sendNotifications(TASK_NAME,allErrors);
    }
}