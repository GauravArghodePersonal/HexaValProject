global class PricingConditionIDocSchedulable implements Schedulable {

    /* Run this code to schedule to run this job at 15 min every hour
    System.schedule('Pricing Condition IDocs', '0 15 * * * ?',
                     new PricingConditionIDocSchedulable());
    */
    
    global void execute(SchedulableContext sc) {
        PricingConditionIDocBatchable pcab = new PricingConditionIDocBatchable();
        Id processId;
        try {
            processId = Database.executeBatch(pcab);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}