global with sharing class AccountRelationshipRefreshBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
  
    /********************
     * General Constants
     ********************/
    public static final String CLASS_NAME = 'AccountRelationshipsRefreshBatch';
    public static final String PROCESS_NAME = AppLogV2.PROCESS_ACCOUNTMANAGEMENT;
    public static final String SUBPROCESS_NAME = AppLogV2.SUBPROCESS_ACCOUNTRELATIONSHIPS;
    public static final String CATEGORY_NAME = AppLogV2.LOGCATEGORY_BATCHPROCESS;
    public static final String TASK_NAME = 'Account Relationships Refresh';
  
    /*-*-*-*-*-*-*-*-*-*-*-*
     *                     *
     * Schedulable Section *
     *                     *
     *-*-*-*-*-*-*-*-*-*-*-*/

    /* Developer Console Code Samples - Schedulable
    AccountRelationshipRefreshBatch.startSchedule();
    AccountRelationshipRefreshBatch.startSchedule('0 0 * * * ?');
    AccountRelationshipRefreshBatch.scheduleBatch(1);
    */ 

    /*************************
     * Consts for Schedulable
     *************************/
    public static final String SCHEDULE_NAME = 'Account Relationships Refresh Process';
    public static final String DEFAULT_CRON = '0 45 2,6,10,14,18,22 * * ?';

    /***********************************
     * Public Interface for Schedulable
     ***********************************/
    global static String startSchedule() {
        return startSchedule(DEFAULT_CRON);
    }

    global static String startSchedule(String cronExpression) {
        String result = '';
        try {result = SystemMethods.schedule(SCHEDULE_NAME,cronExpression,new AccountRelationshipRefreshBatch());}
        catch(Exception e) {result = e.getMessage();System.debug(e);}
        return result;
    }
 
	global static String scheduleBatch(Integer minutesFromNow) {
        String result = '';
        try {result = SystemMethods.scheduleBatch(new AccountRelationshipRefreshBatch(),SCHEDULE_NAME,minutesFromNow);}
        catch(Exception e) {result = e.getMessage();System.debug(e);}
        return result;
	}

    /*****************************
     * Schedulable Implementation 
     *****************************/
    private AccountRelationshipRefreshBatch() { 
    }

    global void execute(SchedulableContext sc) {
        AccountRelationshipRefreshBatch.submitBatchJob();
    }

    /*-*-*-*-*-*-*-*-*-*-*
     *                   *
     * Batchable Section *
     *                   *
     *-*-*-*-*-*-*-*-*-*-*/

    /* Developer Console Code Samples - Batchable
    AccountRelationshipRefreshBatch.submitBatchJob(); // Only Process Relationships that Need Reprocessed;
    AccountRelationshipRefreshBatch.submitBatchJob_RefreshAll(); // Reprocess All Accounts
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

    private Boolean refreshAll = false;
    private Integer processedCount = 0;
    private Integer savedForFutureBatch = 0;
    private List<String> allErrors = new List<String>();
    private Boolean relationshipsNeededProcessing = false; 

    /*******************************
     * Constructor(s) for Batchable
     *******************************/
    global AccountRelationshipRefreshBatch(Boolean isScheduled, Boolean refreshAll) {
        this.isScheduled = isScheduled;
        this.refreshAll = refreshAll;
        this.processedCount = 0;
    }

    /*********************************
     * Public Interface for Batchable
     *********************************/
    global static String submitBatchJob() {
        return submitBatch(false);
    }

    global static String submitBatchJob_RefreshAll() {
        return submitBatch(true);
    }
    
    /***************************************
     * Private Static Methods for Batchable
     ***************************************/
    private static String submitBatch(Boolean refreshAll) {
        String msg;
        if (!BatchTool.alreadyRunning(CLASS_NAME)) {
            AccountRelationshipRefreshBatch b = new AccountRelationshipRefreshBatch(System.isScheduled(),refreshAll);
            try {msg = Database.executeBatch(b, BATCH_SIZE);} catch(Exception e) {msg = e.getMessage();System.debug(e);}
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
    private Boolean relationshipRecordNeedsRefreshed(Account account) {
        Boolean result = false;

        if (refreshAll || (account.Parent_Chain__c != account.Prev_Parent_Chain__c)) {
            result = true;              
        }
        
        return result;
    } 

    /***************************
     * Batchable Implementation
     ***************************/
    global Database.Querylocator start(Database.BatchableContext bc) {
        batchTool = new BatchTool(bc.getJobId(), isScheduled, PROCESS_NAME, SUBPROCESS_NAME);

        Database.Querylocator query; 

        relationshipsNeededProcessing = Account_Relationship_Settings.relationshipsNeedProcessed();

        if (relationshipsNeededProcessing || refreshAll) {
            Account_Relationship_Settings.relationshipsNeedProcessed(false);
            query = Database.getQueryLocator([SELECT Id, 
                                                     ParentId, 
                                                     Parent_Chain__c, 
                                                     Prev_Parent_Chain__c
                                                FROM Account
                                          ]);
                                      
            batchTool.writeLog(CATEGORY_NAME,'Relationships Need Processing',AppLogV2.LOGTYPE_SUMMARY,'Relationships Need Processing','Relationships Need Processing');
        }  
        else {
            // This should never return a row
            query = Database.getQueryLocator([SELECT Id FROM Account WHERE Id='000000000000000']);
            batchTool.writeLog(CATEGORY_NAME,'No Relationship Processing Needed',AppLogV2.LOGTYPE_SUMMARY,'No Relationship Processing Needed','No Relationship Processing Needed');
        }
         
        return query;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn){
        //------------------------
        // Process Data Passed in
        //------------------------
        List<Account> accountsIn = (List<Account>)recsIn;
        
        //------------------------------------------------------------
        // Initialize Lists to hold records identified for processing
        //------------------------------------------------------------
        List<Account> accountsToProcess = new List<Account>();
        
        //---------------
        // Initial Setup
        //---------------
        Boolean processChildren;
        Integer postponed = 0;

        if (refreshAll) {
            processChildren = false; // Since all records will be processed, there is no need to process children automatically
        }
        else {
            processChildren = true;
        }
        
        //----------------------------------------------------
        // Record Analysis - Identify Records to be processed
        //----------------------------------------------------
        for (Account rec : accountsIn) {

            Boolean addAccountToProcessList = false;
            Boolean updateAccountSwitch = false; 

            //-----------------------------------
            // Determine what to do with Account
            //-----------------------------------
            if (relationshipRecordNeedsRefreshed(rec)) {
                addAccountToProcessList = true;
            }
            
            //-----------------------------------------------
            // Populate Lists based on what needs to be done
            //-----------------------------------------------
            if (addAccountToProcessList) {accountsToProcess.add(rec);}
        }

        //--------------------------------
        // Process the Records Identified 
        //--------------------------------
        if (accountsToProcess.size() > 0) {
            //------
            // Init
            //------
            processedCount += accountsToProcess.size();

            //-------
            // Do it
            //-------
            Account_Relationship.CreateAccountRelationshipRecordsResult results = Account_Relationship.createAccountRelationshipRecords(accountsToProcess,processChildren);
            postponed = results.postponed;
            
            //-------------------
            // Log What Happened
            //-------------------
            Map<Id,Account> accountsProcessedMap = new Map<Id,Account>(accountsToProcess);
            List<Id> accountIdsProcessed = new List<Id>(accountsProcessedMap.keySet());
            processedCount += accountsToProcess.size();
            
            if (postponed > 0) {
                savedForFutureBatch += postponed;   
            }
            
            if (results.errors.size() > 0) {
                batchTool.writeLog(CATEGORY_NAME,'Relationship Processing',AppLogV2.LOGTYPE_ERROR,'Errors Occurred During Relationship Processing','Errors Occurred = ' + String.join(results.errors,'\n'));
                
                if ((allErrors.size() + results.errors.size()) < 1000) {
                    allErrors.addAll(results.errors);
                }
            }
        }
    }
   
    global void finish(Database.BatchableContext bc) {
        String extraMessage1 = processedCount + ' Relationships were processed.';
        String extraMessage2 = '';

        if (savedForFutureBatch > 0) {
            extraMessage2 = savedForFutureBatch + ' items were postponed to a future batch process.';
        }

        batchTool.sendNotifications(TASK_NAME, allErrors, extraMessage1, extraMessage2);
    }
}