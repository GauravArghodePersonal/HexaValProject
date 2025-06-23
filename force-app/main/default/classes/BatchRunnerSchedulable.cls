global with sharing class BatchRunnerSchedulable implements Schedulable {

    /* Run this code to schedule as hourly job
    System.schedule('Batch Runner Batch Job', 
                    '0 0 * * * ?',
                    new BatchRunnerBatchJob());
    */
    
    global void execute(SchedulableContext sc) {
    	BatchRunnerBatchJob.submitBatchJob();
    }
}