public with sharing class BatchTool {
	private static final String DEFAULT_PREFIX = 'Default';
	private static final String SCHEDULED_SUFFIX = '-S';
	private static final String UNSCHEDULED_SUFFIX = '-U';
	private static final Integer MAX_CUSTOM_SETTING_NAME_LENGTH = 38;

	/**************
	 * Constructor 
	 **************/

	public BatchTool(Id asyncApexJobId, Boolean isScheduled) {
		this.asyncApexJobId_Internal = asyncApexJobId;
		this.isScheduled_Internal = isScheduled;
		this.jobInfo_Internal = BatchTool.retrieveJobInfo(asyncApexJobId);
		this.settings_Internal = Batch_Job_Settings.retrieveBatchJobSettings(jobInfo.ApexClass.Name, isScheduled);
		String appName = buildAppName(); 
		this.appLog_Internal = new AppLogV2('General','Batch Job',appName,'');
	}
	
	public BatchTool(Id asyncApexJobId, Boolean isScheduled, String processName, String subProcess) {
		this.asyncApexJobId_Internal = asyncApexJobId;
		this.isScheduled_Internal = isScheduled;
		this.jobInfo_Internal = BatchTool.retrieveJobInfo(asyncApexJobId);
		this.settings_Internal = Batch_Job_Settings.retrieveBatchJobSettings(jobInfo.ApexClass.Name, isScheduled);
		String appName = buildAppName();
		this.appLog_Internal = new AppLogV2(processName,subProcess,appName,''); 
	}

	/********************
	 * Public Properties 
	 ********************/

	public Id asyncApexJobId {get {return asyncApexJobId_Internal;}}
	public Boolean isScheduled {get {return isScheduled_Internal;}}
	public AsyncApexJob jobInfo {get {return jobInfo_Internal;}}
	public Batch_Job_Settings__c settings {get {return settings_Internal;}}
	public AppLogV2 appLog {get {return appLog_Internal;}}

	/***************
	 * Private Vars 
	 ***************/

	private Id asyncApexJobId_Internal;
	private Boolean isScheduled_Internal;
	private AsyncApexJob jobInfo_Internal;
	private Batch_Job_Settings__c settings_Internal;
	private AppLogV2 appLog_Internal;


	public void writeLog(String logCategory,String taskName, String logType, String summary, String body) {
		Id AppLogId = appLog.write(logCategory,taskName,logType,summary,body,jobInfo.Id,'AsyncApexJob');
	}

	/**************************
	 * Public Instance Methods 
	 **************************/

	public void refreshJobInfo() {
        this.jobInfo_Internal = BatchTool.retrieveJobInfo(asyncApexJobId);
	}

	public Boolean asyncApexJobIdIsRunning() {
		return BatchTool.alreadyRunning(jobInfo.ApexClass.Name);
	} 

	public void sendNotifications() {sendNotifications('', new List<String>(), '', '', '');}
	public void sendNotifications(String customTitle) {sendNotifications(customTitle, new List<String>(), '', '', '');}
	public void sendNotifications(String customTitle, List<String> errors) {sendNotifications(customTitle, errors, '', '', '');}
	public void sendNotifications(String customTitle, List<String> errors, String extraMessage1) {sendNotifications(customTitle, errors, extraMessage1, '', '');}
	public void sendNotifications(String customTitle, List<String> errors, String extraMessage1, String extraMessage2) {sendNotifications(customTitle, errors, extraMessage1, extraMessage2, '');}
	public void sendNotifications(String customTitle, List<String> errors, String extraMessage1, String extraMessage2, String extraMessage3) {
        Boolean errorsOccurred = false; 
        Boolean sendEmail = false;
        Set<String> emailAddresses = new Set<String>();
		String replyToAddress = '';
		String replyToDisplayName = '';
		String title = '';
		String subject = '';
        String bodyText = '';
        String errorDetail = '';
        String errorText = '';
	
		refreshJobInfo();
	
		// Determine if Errors Occurred 
        errorsOccurred = (jobInfo.NumberOfErrors > 0) || (errors.size() > 0); 
        
		// Build the toAddress
		if (settings.Send_Results_to_Submitter_Email__c) {
			emailAddresses.add(jobInfo.CreatedBy.Email);
		} 
		 
		if (String.isNotEmpty(settings.Send_Results_To_Email__c)) { 
        	emailAddresses.addAll(settings.Send_Results_To_Email__c.split(','));
		}
        
        if (errorsOccurred) {
        	if (String.isNotEmpty(settings.Send_Error_Results_to_Email__c)) {
	        	emailAddresses.addAll(settings.Send_Error_Results_to_Email__c.split(','));
        	}
        }
        
        if (emailAddresses.size() > 0) {sendEmail = true;}

		// Build the replyToAddress
		if (String.isNotEmpty(settings.Reply_To_Email__c)) {
			replyToAddress = settings.Reply_To_Email__c; 
		}
		else {
			replyToAddress = jobInfo.CreatedBy.Email; 
		}
        
		// Build the replyToDisplayName
		replyToDisplayName = settings.Reply_To_Display_Name__c; 
        
		// Build the Title
		List<String> titleParts = new List<String>();
		if (String.isNotEmpty(customTitle)) {titleParts.add(customTitle);}
		if (String.isNotEmpty(settings.Results_Subject__c)) {titleParts.add(settings.Results_Subject__c);}
		titleParts.add(jobInfo.ApexClass.Name);
		title = String.join(titleParts,' - ');
		 
		// Build the Subject
		List<String> subjectParts = new List<String>();
        subjectParts.add(SalesforceOrgType.determineOrgInstance());
		if (isScheduled) {subjectParts.add('Scheduled Job');} else {subjectParts.add('Manual Job');}
		subjectParts.add(title);
		subjectParts.add(jobInfo.Status);
		subjectParts.add(jobInfo.TotalJobItems + ' batches');
		subject = String.join(subjectParts,' - ');
		
		// Build the Body
        bodyText += 'Job Id : ' + jobInfo.Id + ' processed ' + jobInfo.TotalJobItems + ' batches with ' + jobInfo.NumberOfErrors + ' failures. ';

		if (isScheduled) {
			bodyText += '\n\n  - This is a scheduled job.';				
		}
		else {
			bodyText += '\n\n  - This is a manual job that was submitted by ' + jobInfo.createdBy.Name + ' (' + jobInfo.createdBy.Email + ').';				
		}

		if (extraMessage1 != '') {bodyText += '\n\n' + '  - ' + extraMessage1;}
		if (extraMessage2 != '') {bodyText += '\n\n' + '  - ' + extraMessage2;}
		if (extraMessage3 != '') {bodyText += '\n\n' + '  - ' + extraMessage3;}
 
 
        if (errors.size() > 0) {
        	errorDetail = String.join(errors,'\n  - ');
        	if (settings.Include_Error_Detail_in_Results_Email__c) {
        		errorText += '\n\n' + errors.size() + ' errors occurred during processing (Max errors shown is first 1000 errors):\n\n' + errorDetail;
        	}
        	else {
        		errorText += '\n\n' + errors.size() + ' errors occurred during processing.  Review AppLogs for more detail.';
        	}
        	bodyText += '\n\n' + errorText;
        }
        
		// Create AppLog Entry for Results if necessary
		if (settings.Create_Results_App_Log_Entry__c) {
  	        Id resultsAppLogId = appLog.write(AppLogV2.LOGCATEGORY_EMAILLOG,customTitle,AppLogV2.LOGTYPE_INFO,title,bodyText,jobInfo.Id,'AsyncApexJob');
        	bodyText += '\n\n' + 'Email AppLog Entry --> <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + resultsAppLogId + '">Link</a>';
		}
		
		// Create AppLog Entry for Summary if necessary
		if (settings.Create_Summary_App_Log_Entry__c) {
			String summaryText = subject;
			if (String.isNotEmpty(errorDetail)) {summaryText += '\n\n Error Details\n\n' + errorDetail;}
  	        Id summaryAppLogId = appLog.write(AppLogV2.LOGCATEGORY_SUMMARY,customTitle,AppLogV2.LOGTYPE_SUMMARY,title,summaryText,jobInfo.Id,'AsyncApexJob');
        	bodyText += '\n\n' + 'Summary AppLog Entry --> <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + summaryAppLogId + '">Link</a>';
		}
		
		if (sendEmail) {
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses(new List<String>(emailAddresses));
	        mail.setReplyTo(replyToAddress);
	        mail.setSenderDisplayName(replyToDisplayName);
	        mail.setSubject(subject);
	        mail.setPlainTextBody(bodyText);
	        String htmlBodyText = bodyText.replace('\n','<BR>');
	        mail.setHtmlBody(htmlBodyText);
	        
        	MessagingMethods.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
		}
	}

	/*******************
	 * Private  Methods 
	 *******************/

	private String buildAppName() {
		String result = '';
		if (isScheduled) {
			result = 'Scheduled Batch - ' + jobInfo.ApexClass.Name;
		}
		else {
			result = 'Manual Batch - ' + jobInfo.ApexClass.Name;
		}
		return result;
	}

	/************************
	 * Public Static Methods 
	 ************************/
	
	public static AsyncApexJob retrieveJobInfo(Id id) {
		AsyncApexJob result;
		
        result = [SELECT Id, 
    	                 ApexClassID, 
    	                 ApexClass.Name, 
    	                 Status, 
    	                 ExtendedStatus,
    	                 JobType, 
    	                 MethodName, 
    	                 NumberOfErrors, 
    	                 JobItemsProcessed, 
    	                 TotalJobItems, 
    	                 CreatedBy.Email, 
    	                 CreatedBy.Name, 
    	                 CompletedDate 
    	            FROM AsyncApexJob 
    	           WHERE Id =:id
    	         ];
    	         
    	return result;		
	} 

    public static Boolean alreadyRunning(String batchClassName) {
    	Boolean result = false;
    	
    	List<AsyncApexJob> jobs = [SELECT Id, 
    	                                  ApexClassID, 
    	                                  ApexClass.Name, 
    	                                  Status, 
    	                                  ExtendedStatus,
    	                                  JobType, 
    	                                  MethodName, 
    	                                  NumberOfErrors, 
    	                                  JobItemsProcessed, 
    	                                  TotalJobItems, 
    	                                  CreatedBy.Email, 
    	                                  CompletedDate 
    	                             FROM AsyncApexJob  
    	                            WHERE JobType = 'BatchApex'
    	                              AND ApexClass.Name = :batchClassName
    	                              AND Status IN ('Queued','Processing','Preparing')
    	                           ];
		
		if (jobs.size() > 0) {result = true;}
		
		return result;    	                           
    }
}