global with sharing class Permission_Set_Rules_Batch_Processing implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
  
	/********************
	 * General Constants
	 ********************/
    public static final String CLASS_NAME = 'Permission_Set_Rules_Batch_Processing';
    public static final String PROCESS_NAME = AppLogV2.PROCESS_USERSECURITY;
    public static final String SUBPROCESS_NAME = AppLogV2.SUBPROCESS_DYNAMICPERMISSIONSETS;
    public static final String CATEGORY_NAME = AppLogV2.LOGCATEGORY_BATCHPROCESS;
    public static final String TASK_NAME = 'Apply Dynamic Permission Sets to Users';
  
	/*-*-*-*-*-*-*-*-*-*-*-*
	 *                     *
	 * Schedulable Section *
	 *                     *
	 *-*-*-*-*-*-*-*-*-*-*-*/

    /* Developer Console Code Samples - Schedulable
	Permission_Set_Rules_Batch_Processing.startSchedule();
	Permission_Set_Rules_Batch_Processing.startSchedule('0 0 * * * ?');
    */

	/*************************
	 * Consts for Schedulable
	 *************************/
    public static final String SCHEDULE_NAME = 'Apply Dynamic Permission Sets to Users';
    public static final String DEFAULT_CRON = '0 10 * * * ?';

	/***********************************
	 * Public Interface for Schedulable
	 ***********************************/
    global static String startSchedule() {
    	return startSchedule(DEFAULT_CRON);
    }

    global static String startSchedule(String cronExpression) {
    	String result = '';
    	try {result = SystemMethods.schedule(SCHEDULE_NAME,cronExpression,new Permission_Set_Rules_Batch_Processing());}
    	catch(Exception e) {result = e.getMessage();System.debug(e);}
    	return result;
    }

	/*****************************
	 * Schedulable Implementation 
	 *****************************/
    private Permission_Set_Rules_Batch_Processing() { 
    }

    global void execute(SchedulableContext sc) {
    	Permission_Set_Rules_Batch_Processing.submitBatchJob();
    }

	/*-*-*-*-*-*-*-*-*-*-*
	 *                   *
	 * Batchable Section *
	 *                   *
	 *-*-*-*-*-*-*-*-*-*-*/

	/* Developer Console Code Samples - Batchable
	Permission_Set_Rules_Batch_Processing.submitBatchJob();
	Permission_Set_Rules_Batch_Processing.submitBatchJob(1);
	*/ 

	/***********************
	 * Consts for Batchable
	 ***********************/
    public static final Integer BATCH_SIZE = 1;

	/***************************
	 * Private Vars - Batchable
	 ***************************/
	private BatchTool batchTool;
    private Boolean isScheduled = false;

	/*******************************
	 * Constructor(s) for Batchable
	 *******************************/
    global Permission_Set_Rules_Batch_Processing(Boolean isScheduled) {
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
    	if (!BatchTool.alreadyRunning(CLASS_NAME)) {
	        Permission_Set_Rules_Batch_Processing b = new Permission_Set_Rules_Batch_Processing(System.isScheduled());
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
       	                                         Group_Name__c
       	                                    FROM Permission_Set_Rule_Group__c
       	                                   WHERE Is_Active__c = true
       	                                     AND Record_Valid__c = true
       	                                     AND Group_Valid__c = true
       	                                 ]);
        return query;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn){
        List<Permission_Set_Rule_Group__c> items = (List<Permission_Set_Rule_Group__c>)recsIn;
        
        for (Permission_Set_Rule_Group__c item : items) {
    		Permission_Set_Rules_Processor.ProcessingResults processingResults = Permission_Set_Rules_Processor.processRulesForPermissionSetRuleGroupId(item.Id);
    		if (processingResults.instructions.size() > 0) {
    			batchTool.writeLog(AppLogV2.LOGCATEGORY_SUMMARY,TASK_NAME, AppLogV2.LOGTYPE_INFO, 'Results for ' + item.Group_Name__c, processingResults.instructions[0].outputToStringSummary());
    		}
        }
    }
    
    global void finish(Database.BatchableContext bc) {
    	batchTool.sendNotifications(TASK_NAME);
    }
}