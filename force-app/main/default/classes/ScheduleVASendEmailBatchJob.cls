global class ScheduleVASendEmailBatchJob implements Schedulable {
    global void execute(SchedulableContext sc) {      
         Integer batchSize = 50;
        system.debug('batchSize' +batchSize);
        VASendEmailToAccountOwnersBatch batch = new VASendEmailToAccountOwnersBatch(batchSize);
        system.debug('batchSize' +batchSize);
        Database.executeBatch(batch);
    }

}