global with sharing class LoginHistory_Schedulable implements Schedulable {

    /* Run this code to schedule as hourly job
    System.schedule('Login History Update Job', '0 0 * * * ?', new LoginHistory_Schedulable());
    */
    
    global void execute(SchedulableContext sc) {
       	String query = LoginHistory_BatchProcess.querySinceLastRun();
    	LoginHistory_BatchProcess.submitBatchJob(query);
    }
}