global with sharing class Pricing_Rebate_Schedulable implements Schedulable {

    /* Run this code to schedule to run this job at 1 AM every day
    System.schedule('Pricing Rebate Expirations', '0 0 1 * * ?',
                     new Pricing_Rebate_Schedulable());
    */
    
    global void execute(SchedulableContext sc) {
        Pricing_Rebate_Batchable b = new Pricing_Rebate_Batchable();
        Id processId;
        try {
            processId = Database.executeBatch(b);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}