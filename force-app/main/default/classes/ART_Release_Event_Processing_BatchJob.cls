global with sharing class ART_Release_Event_Processing_BatchJob implements Database.Batchable<sObject>, Database.Stateful {

	/********************
	 * General Constants
	 ********************/
    public static final String CLASS_NAME = 'ART_Release_Event_Processing_BatchJob';
    public static final String PROCESS_NAME = 'Ashland Release Tracker';
    public static final String SUBPROCESS_NAME = 'Release Events';
    public static final String CATEGORY_NAME = AppLogV2.LOGCATEGORY_BATCHPROCESS;
    public static final String TASK_NAME = 'Upsert Events for All ART_Release__c records';
  
	/*-*-*-*-*-*-*-*-*-*-*
	 *                   *
	 * Batchable Section *
	 *                   *
	 *-*-*-*-*-*-*-*-*-*-*/

	/* Developer Console Code Samples - Batchable
	ART_Release_Event_Processing_BatchJob.submitBatchJob();
	ART_Release_Event_Processing_BatchJob.submitBatchJob(50);
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
    global ART_Release_Event_Processing_BatchJob(Boolean isScheduled) {
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
    	if (!BatchTool.alreadyRunning('ART_Release_Event_Processing_BatchJob')) {
	        ART_Release_Event_Processing_BatchJob b = new ART_Release_Event_Processing_BatchJob(System.isScheduled());
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
       	query = Database.getQueryLocator([SELECT Id
       	                                    FROM ART_Release__c
       	                                 ]);
        return query;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn){
        List<ART_Release__c> releases = (List<ART_Release__c>)recsIn;
        List<Id> releaseIds = new List<Id>();

        for (ART_Release__c release : releases) {
        	releaseIds.add(release.Id);
        }
        
		if (releaseIds.size() > 0) {
			ART_Release.updateEventsforReleases(releaseIds);
		}
        
    }
    
    global void finish(Database.BatchableContext bc) {
    	batchTool.sendNotifications(TASK_NAME);
    }
}