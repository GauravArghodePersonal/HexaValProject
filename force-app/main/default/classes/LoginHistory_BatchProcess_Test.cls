@isTest(SeeAllData=true)
private class LoginHistory_BatchProcess_Test {

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

        //*************************
        //LoginHistory_BatchProcess
        //*************************

        string s = LoginHistory_BatchProcess.querySinceLastRun();
        String query = LoginHistory_BatchProcess.queryForAll();
        query += ' LIMIT 200';
        
        /*Database.QueryLocator QL;
        Database.BatchableContext BC;
        
        LoginHistory_BatchProcess loginBatch = new LoginHistory_BatchProcess(query);
        QL = loginBatch.start(BC);
        loginBatch.execute(BC,lhRecs);*/
        
        string msg = LoginHistory_BatchProcess.submitBatchJob(query);
        
        //loginBatch.finish(BC);
        
        //ID batchprocessid = LoginHistory_BatchProcess.submitBatchJob(query);
        
        //************************
        //LoginHistory_Schedulable
        //************************
        //System.schedule('Login History Update Job', '0 0 * * * ?', new LoginHistory_Schedulable());
        Test.StopTest();

    }
}