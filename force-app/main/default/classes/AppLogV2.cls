global without sharing class AppLogV2 {
	
	/********************************************************************* 
	  AppLog Instructions 
	 ---------------------------------------------------------------------
	  Suggested Use:
	  
	      // Instantiate an instance of AppLog in your class:
	      
	      AppLogV2 appLog = new AppLogV2('Process','Sub Process','Application Name','Version Info');

		  // A number of const values are defined in the AppLog class for PROCESS, SUBPROCESS, APPNAME, LOGCATEGORY, and LOGTYPE.
		  // These const values are suggestions that should provide an idea of the intent of these parameters.  You can choose
		  // To use these const values directly, or pass in whatever you would like.
	      
	      // To use the appLog, make calls like the following (3 variations): 
	      
	      appLog.write('Log Category','Task','Log Type','Summary','Detailed Log');
	      appLog.write('Log Category','Task','Log Type','Summary','Detailed Log','Related To Key', 'Related To Key Type');
	      appLog.write('Log Category','Task','Log Type','Summary','Detailed Log','Related To Key', 'Related To Key Type','Record Key');
	  
	  	  // the write method will return the record id for the AppLog__c entry created or updated.
	  
	      // The record key is an External Id field that if populated, will cause the record to be upserted instead of inserted
	      // and any previous log record with the same record key value will be overwritten.
	      //
	      // An example where this might be useful is tracking things like "LAST LOGIN", etc.  
	      
	      // NOTE: Be sure that your external key is unique.  This means that you will need to include more than an Id, as it may
	      //       Not be unique across all log types stored in this solution.
	  
	
		  // Another way to call the writes is using a deferred method.  This is useful in situations where may writes may be
		  // occurring and the log writing might adversely impact governor limits.  Performing writes this way has a risk though, in that
		  // the AppLog instance needs to be told to "Flush" the cache.  The cache will be flushed in two scenarios, with by calling a 
		  // flushCache method directly, or calling a non-cached write, like the above examples.  If neither of these methods are used 
		  // to flush the cache, the cached log entries will be lost.  Since where logs are typically important in error conditions, appropriate
		  // Try/Catch Exception Handling is needed and flushing of the cache should be incorporated appropriately.
		  
	      appLog.cachedWrite('Log Category','Task','Log Type','Summary','Detailed Log');
	      appLog.cachedWrite('Log Category','Task','Log Type','Summary','Detailed Log','Related To Key', 'Related To Key Type');
	      appLog.cachedWrite('Log Category','Task','Log Type','Summary','Detailed Log','Related To Key', 'Related To Key Type','Record Key');
	  
		  // To flush the cached writes to Salesforce, the following can be called:
	
		  appLog.flushCache();
	
	 *********************************************************************/

	/* Processes */
	global static final String PROCESS_PRICING = 'Pricing';
	global static final String PROCESS_ULTIMATEPARENT = 'Ultimate Parent';
	global static final String PROCESS_SAPINTEGRATION = 'SAP Integration';
	global static final String PROCESS_ACCOUNTMANAGEMENT = 'Account Management';
	global static final String PROCESS_USERSECURITY = 'User Security';

	/* General Sub Processes */
	global static final String SUBPROCESS_DYNAMICPERMISSIONSETS = 'Dynamic Permission Sets';

	/* Pricing Sub Processes */
	global static final String SUBPROCESS_SHIPANDBILL = 'Ship and Bill';
	global static final String SUBPROCESS_PRICEBOOKS = 'Price Books';
	global static final String SUBPROCESS_MARKETPRICEBOOKS = 'Market Price Books';
	
	/* Ultimate Parent Sub Processes */
	global static final String SUBPROCESS_ACCOUNTROLLUPS = 'Account Rollups';
	global static final String SUBPROCESS_ACCOUNTRELATIONSHIPS = 'Account Relationships';
	
	/* SAP Integration Sub Processes */
	global static final String SUBPROCESS_SAPECOMCUSTOMER = 'SAP ECOM Customer';
	global static final String SUBPROCESS_SAPULTIMATEPARENT = 'SAP Ultimate Parent';
	
	/* Application Names */
	global static final String APPNAME_PRICINGWIZARD = 'Pricing Wizard';
	global static final String APPNAME_MARKETPRICEBOOKWIZARD = 'Market Price Book Wizard';
	global static final String APPNAME_PRICEBOOKWIZARD = 'Price Book Wizard';

	/* General Log Categories */
	global static final String LOGCATEGORY_EMAILLOG = 'Email Log';
	global static final String LOGCATEGORY_LASTLOGIN = 'Last Login';
	global static final String LOGCATEGORY_LOGIN = 'Login';
	global static final String LOGCATEGORY_SUMMARY = 'Summary';
	global static final String LOGCATEGORY_FLASHVERSION = 'Flash Version';
	global static final String LOGCATEGORY_BATCHPROCESS = 'Batch Process';

	/* General Log Categories */
	global static final String TASK_REFRESH = 'Refresh';
	global static final String TASK_BATCHPROCESSSKIPPED = 'Batch Process Skipped - Already Running';

	/* General Log Types */
	global static final String LOGTYPE_INFO = 'Info';
	global static final String LOGTYPE_WARNING = 'Warning';
	global static final String LOGTYPE_ERROR = 'Error';
	global static final String LOGTYPE_SUMMARY = 'Summary';
	global static final String LOGTYPE_SECURITY = 'Security';



	/* Instance Private Vars */
	private String processName = '';
	private String subProcess = '';
	private String applicationName = '';
	private String versionInfo = '';
	
	private List<AppLog__c> cache = new List<AppLog__c>();
	
	/* Instance Constructor */
	global AppLogV2(String processName,
    	            String subProcess,
		            String applicationName,
    	            String versionInfo) {
		this.processName = processName;
		this.subProcess = subProcess;
		this.applicationName = applicationName;
		this.versionInfo = versionInfo;
	}

	public id write(String logCategory,String task,String logType,String summary,String log) {
    	return write(logCategory,task,logType,summary,log,'','','',false);                	
    }

	public void cachedWrite(String logCategory,String task,String logType,String summary,String log) {
    	write(logCategory,task,logType,summary,log,'','','',true);                	
    }

	public id write(String logCategory,String task,String logType,String summary,String log,String relatedToKey,String relatedToKeyType) {
    	return write(logCategory,task,logType,summary,log,relatedToKey,relatedToKeyType,'',false);                	
    }

	public void cachedWrite(String logCategory,String task,String logType,String summary,String log,String relatedToKey,String relatedToKeyType) {
    	write(logCategory,task,logType,summary,log,relatedToKey,relatedToKeyType,'',true);                	
    }

	public id write(String logCategory,String task,String logType,String summary,String log,String relatedToKey,String relatedToKeyType,String recordKey) {
    	return write(logCategory,task,logType,summary,log,relatedToKey,relatedToKeyType,recordKey,false);                	
	}
	
	public void cachedWrite(String logCategory,String task,String logType,String summary,String log,String relatedToKey,String relatedToKeyType,String recordKey) {
    	write(logCategory,task,logType,summary,log,relatedToKey,relatedToKeyType,recordKey,true);                	
	}
	
	public id write(String logCategory,String task,String logType,String summary,String log,String relatedToKey,String relatedToKeyType,String recordKey,Boolean cacheWrite) {
		if (cacheWrite) {
			AppLog__c newLog = AppLogV2.createNewAppLogRecord(processName,subProcess,applicationName,versionInfo,logCategory,task,logType,summary,log,relatedToKey,relatedToKeyType,recordKey);
			cache.add(newLog);
			return null;
		}
		else {
			flushCache();
			return AppLogV2.write(processName,subProcess,applicationName,versionInfo,logCategory,task,logType,summary,log,relatedToKey,relatedToKeyType,recordKey);
		}
	}

	public void flushCache() {
		AppLogV2.writeMultiple(cache);
		cache.clear();
	}

	public static AppLog__c createNewAppLogRecord(String processName,
    		   	    					   	      String subProcess,
										          String applicationName,
					    			              String versionInfo,
					                              String logCategory,
					                              String task,
					                              String logType,
					                              String summary,
					                              String log,
					                              String relatedToKey,
					                              String relatedToKeyType,
					                              String recordKey) {
		AppLog__c newLog = new AppLog__c();
            
        newLog.Application_Name__c = applicationName;
        newLog.Version_Info__c = versionInfo;
        newLog.User__c = UserInfo.getUserId();
        newLog.Process__c = processName;
        newLog.Sub_Process__c = subProcess;
        newLog.Log_Type__c = logType;
        newLog.Task__c = task;
        newLog.Log_Category__c = logCategory;
        newLog.Log_Date_Time__c = System.now();
        newLog.Summary__c = summary;
        newLog.Related_To_Key__c = relatedToKey;
        newLog.Related_To_Key_Type__c = relatedToKeyType;
        newLog.Log__c = log;
        newLog.Record_Key__c = recordKey;
                   	
        return newLog;                         	
	}

	Webservice static Id write(String processName,
    			               String subProcess,
  							   String applicationName,
		    			       String versionInfo,
		                       String logCategory,
		                       String task,
		                       String logType,
		                       String summary,
		                       String log,
		                       String relatedToKey,
		                       String relatedToKeyType,
		                       String recordKey) {
        AppLog__c newLog = createNewAppLogRecord(processName,subProcess,applicationName,versionInfo,logCategory,task,logType,summary,log,relatedToKey,relatedToKeyType,recordKey);
        return write(newLog);                         	
    }

	Webservice static void writeMultiple(List<AppLog__c> newLogs) {
		Map<String,AppLog__c> newLogUpserts = new Map<String,AppLog__c>();
		List<AppLog__c> newLogInserts = new List<AppLog__c>();
        try {       
			for (AppLog__c newLog : newLogs) {
	            if (newLog.Record_Key__c != '') {
	            	newLogUpserts.put(newLog.Record_Key__c,newLog);
	            }
	            else {
	            	newLogInserts.add(newLog);
	            }
			}        	

			if (newLogUpserts.size() > 0) {upsert newLogUpserts.values() Record_Key__c;}
			if (newLogInserts.size() > 0) {insert newLogInserts;}
        }
        catch (Exception e) {}
	}

	static Id write(AppLog__c newLog) {
        try {       
            if (newLog.Record_Key__c != '') {
                upsert newLog Record_Key__c;
            }
            else {
                insert newLog;
            }
        }
        catch (Exception e) {
        	System.debug('Error Writing AppLog - ' + newLog);
        	System.debug('AppLog write Exception - ' + e);
        	}
        return newLog.Id;
	}
}