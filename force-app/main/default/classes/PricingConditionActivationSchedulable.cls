global with sharing class PricingConditionActivationSchedulable implements Schedulable {

    /* Run this code to schedule to run this job at every hour
    System.schedule('Pricing Condition Activations', '0 0 * * * ?',
                     new PricingConditionActivationSchedulable());
    */
    
    global void execute(SchedulableContext sc) {
        PricingConditionActivationBatchable pcab = new PricingConditionActivationBatchable();
        Id processId;
        try {
            processId = Database.executeBatch(pcab);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}