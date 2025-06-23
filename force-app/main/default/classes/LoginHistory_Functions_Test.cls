@isTest(SeeAllData=true)
private class LoginHistory_Functions_Test {

    static testMethod void myUnitTest() {
    	LoginHistory lh = [SELECT ApiType, 
        	                      ApiVersion, 
        	                      Application, 
        	                      Browser, 
        	                      ClientVersion, 
        	                      Id, 
        	                      LoginTime, 
        	                      LoginType, 
        	                      LoginUrl, 
        	                      Platform, 
        	                      SourceIp, 
        	                      Status, 
        	                      UserId 
        	                 FROM LoginHistory LIMIT 1];
    	
    	List<LoginHistory> lhRecs = new List<LoginHistory>(); 
    	lhRecs.add(lh);
    
    	Test.StartTest();

		//******************************
		//LoginHistory_Functions Methods
		//******************************
    	LoginHistory_Functions.upsertLoginHistoryRecstoCustom(lhRecs);
    	
		//*************************
    	//LoginHistory_BatchProcess
		//*************************
    	//LoginHistory_BatchProcess.querySinceLastRun();
    	String query = LoginHistory_BatchProcess.queryForAll();
    	query += ' LIMIT 200';
	    //ID batchprocessid = LoginHistory_BatchProcess.submitBatchJob(query);
    	
    	//************************
    	//LoginHistory_Schedulable
    	//************************
    	//System.schedule('Login History Update Job', '0 0 * * * ?', new LoginHistory_Schedulable());
    	
    	Test.StopTest();
    }
}