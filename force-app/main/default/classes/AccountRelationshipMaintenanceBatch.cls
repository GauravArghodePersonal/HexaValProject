global with sharing class AccountRelationshipMaintenanceBatch implements Database.Batchable<sObject>, Database.Stateful {
  
	/********************
	 * General Constants
	 ********************/
    public static final String CLASS_NAME = 'AccountRelationshipMaintenanceBatch';
    public static final String PROCESS_NAME = AppLogV2.PROCESS_ACCOUNTMANAGEMENT;
    public static final String SUBPROCESS_NAME = AppLogV2.SUBPROCESS_ACCOUNTRELATIONSHIPS;
    public static final String CATEGORY_NAME = AppLogV2.LOGCATEGORY_BATCHPROCESS;
    public static final String TASK_NAME = 'Account Relationships Maintenance';
  
	/*-*-*-*-*-*-*-*-*-*-*
	 *                   *
	 * Batchable Section *
	 *                   *
	 *-*-*-*-*-*-*-*-*-*-*/

	/* Developer Console Code Samples - Batchable
	AccountRelationshipMaintenanceBatch.ApplyNewRecalcNeededToAll(true); // Reset all Recalc_Needed__c to True
	AccountRelationshipMaintenanceBatch.ApplyNewRecalcNeededToAll(false); // Reset all Recalc_Needed__c to False
	AccountRelationshipMaintenanceBatch.EnableRecalcToUltimateParentRecords(); // Set anything UP Related to true
	*/ 

	/*********************** 
	 * Consts for Batchable
	 ***********************/
    public static final Integer BATCH_SIZE = 200;
	private static final String APPLY_NEW_RECALC_NEEDED_TO_ALL = 'APPLY_NEW_RECALC_NEEDED_TO_ALL';
	private static final String ENABLE_RECALC_TO_ULTIMATEPARENT_RECORDS = 'ENABLE_RECALC_TO_ULTIMATEPARENT_RECORDS';

	/***************************
	 * Private Vars - Batchable
	 ***************************/
	private BatchTool batchTool;
    private Boolean isScheduled = false;
	 
    private String jobType = '';
    private Boolean newValue = false;

	/*******************************
	 * Constructor(s) for Batchable
	 *******************************/
    global AccountRelationshipMaintenanceBatch(Boolean isScheduled, String jobType) {
    	this.isScheduled = isScheduled;
    	this.jobType = jobType;
    }
    
    global AccountRelationshipMaintenanceBatch(Boolean isScheduled, String jobType, Boolean newValue) {
    	this.isScheduled = isScheduled;
    	this.jobType = jobType;
    	this.newValue = newValue;
    }

	/*********************************
	 * Public Interface for Batchable
	 *********************************/
    global static String ApplyNewRecalcNeededToAll(Boolean newValue) {
        AccountRelationshipMaintenanceBatch b = new AccountRelationshipMaintenanceBatch(System.isScheduled(),AccountRelationshipMaintenanceBatch.APPLY_NEW_RECALC_NEEDED_TO_ALL, newValue);
        String msg;
        try {msg = Database.executeBatch(b, BATCH_SIZE);} catch(Exception e) {msg = e.getMessage();System.debug(e);}
        return msg;
    }

    global static String EnableRecalcToUltimateParentRecords() {
        AccountRelationshipMaintenanceBatch b = new AccountRelationshipMaintenanceBatch(System.isScheduled(),AccountRelationshipMaintenanceBatch.ENABLE_RECALC_TO_ULTIMATEPARENT_RECORDS);
        String msg;
        try {msg = Database.executeBatch(b, BATCH_SIZE);} catch(Exception e) {msg = e.getMessage();System.debug(e);}
        return msg;
    }
    
	/***************************************
	 * Private Static Methods for Batchable
	 ***************************************/

	/********************************
	 * Private Methods for Batchable
	 ********************************/

	/***************************
	 * Batchable Implementation
	 ***************************/
    global Database.Querylocator start(Database.BatchableContext bc) {
    	batchTool = new BatchTool(bc.getJobId(), isScheduled, PROCESS_NAME, SUBPROCESS_NAME);
    	
        Database.Querylocator query; 

		if (jobType == AccountRelationshipMaintenanceBatch.APPLY_NEW_RECALC_NEEDED_TO_ALL) {
	    	query = Database.getQueryLocator([SELECT Id, Child_Account__c, 
	    	                                         Recalc_Needed__c
	   		                                    FROM Account_Relationship__c
	   		                                   WHERE Recalc_Needed__c != :newValue
	   		                                 ]);
		}

		if (jobType == AccountRelationshipMaintenanceBatch.ENABLE_RECALC_TO_ULTIMATEPARENT_RECORDS) {
	    	query = Database.getQueryLocator([SELECT Id, Child_Account__c, 
	    	                                         Recalc_Needed__c
	   		                                    FROM Account_Relationship__c
	   		                                   WHERE (Child_Account__r.RecordType.Name = 'Ultimate Parent'
	   		                                          OR Child_Account_Parent_Chain__c != '')
	   		                                     AND Recalc_Needed__c = false
	   		                              ]);
		}
         
        return query;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn){
        //------------------------
        // Process Data Passed in
        //------------------------
        List<Account_Relationship__c> recs = (List<Account_Relationship__c>)recsIn;

		if (jobType == AccountRelationshipMaintenanceBatch.APPLY_NEW_RECALC_NEEDED_TO_ALL) {
	        Account_Relationship.setRecalcNeeded(recs,newValue);
		}

		if (jobType == AccountRelationshipMaintenanceBatch.ENABLE_RECALC_TO_ULTIMATEPARENT_RECORDS) {
	        Account_Relationship.setRecalcNeeded(recs,true);
		}
    }
   
    
   
    global void finish(Database.BatchableContext bc) {
    	batchTool.sendNotifications(TASK_NAME);
    }
}