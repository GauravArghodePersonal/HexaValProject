global with sharing class PricingConditionExpirationSchedulable implements Schedulable {

    /* Run this code to schedule to run this job at 6 AM every day
    System.schedule('Pricing Condition Expirations', '0 0 6 * * ?',
                     new PricingConditionExpirationSchedulable());
    */
    
    global void execute(SchedulableContext sc) {
        PricingConditionExpirationBatchable pcab = new PricingConditionExpirationBatchable();
        Id processId;
        try {
            processId = Database.executeBatch(pcab);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}