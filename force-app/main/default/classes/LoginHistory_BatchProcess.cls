global with sharing class LoginHistory_BatchProcess implements Database.Batchable<sObject> {

    public static final Integer BATCH_SIZE = 200;
    private string query = '';

	/* Developer Console Test Code
	
	//Refresh since last run
	String query = LoginHistory_BatchProcess.querySinceLastRun();
	LoginHistory_BatchProcess.submitBatchJob(query);

    //Refresh all
	String query = LoginHistory_BatchProcess.queryForAll();
	LoginHistory_BatchProcess.submitBatchJob(query);
	*/

    global LoginHistory_BatchProcess(String query) {
    	this.query = query;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
       	ql = Database.getQueryLocator(query);
        return ql;
    }

    global void execute(Database.BatchableContext bc, List<SObject> recsIn){
    	if (recsIn.size() > 0)
    	{
	        List<LoginHistory> recsToProcess = (List<LoginHistory>)recsIn;
	        LoginHistory_Functions.upsertLoginHistoryRecstoCustom(recsToProcess);
	    }
    }
      
     
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:bc.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Custom Login History Batch Processing');
        mail.setSubject('Apex Batch Job - Custom Login History Batch Processing - ' + a.Status + ' - ' + a.TotalJobItems + ' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ' + '\n\n\nQuery was ' + query);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }


    Webservice static String submitBatchJob(String query) {
        LoginHistory_BatchProcess b = new LoginHistory_BatchProcess(query);
        String msg;
        
        try {
            msg = Database.executeBatch(b, BATCH_SIZE);
        } 
        catch(Exception e) {
            msg = e.getMessage();
            System.debug(e);
        }
        
        return msg;
    }

	/* Developer Console Test Code
	System.debug('*** - ' + LoginHistory_BatchProcess.querySinceLastRun());
	System.debug('*** - ' + LoginHistory_BatchProcess.queryForAll());
	*/
     
    public static String querySinceLastRun() {
    	String query = ''; 
    	LoginHistory__c lastRec;
    	Boolean loginHistoryExists = true;
    
    	//Get Latest Record
    	try {
    		lastRec = [SELECT Id, Login_Time__c FROM LoginHistory__c ORDER BY Login_Time__c DESC LIMIT 1];
    		}
    	catch (Exception e) {loginHistoryExists = false;}
    	
    	if (loginHistoryExists)
    	{
    		DateTime startDT = lastRec.Login_Time__c;
    		startDT = startDT.addDays(-2); //Adding this because weird timezone issues
 			query = 'SELECT ApiType, ApiVersion, Application, Browser, ClientVersion, Id, LoginTime, LoginType, LoginUrl, Platform, SourceIp, Status, UserId FROM LoginHistory WHERE LoginTime >= ' + startDT.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
 		}
 		else
 		{
 			query = queryForAll();
 		}
		return query;
    }
    
    public static String queryForAll() {
		String query = 'SELECT ApiType, ApiVersion, Application, Browser, ClientVersion, Id, LoginTime, LoginType, LoginUrl, Platform, SourceIp, Status, UserId FROM LoginHistory';
		return query;
    }
    
}