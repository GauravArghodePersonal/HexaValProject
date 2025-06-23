global with sharing class PricingConditionApproversSchedulable implements Schedulable {

    /* Run this code to schedule to run this job at 7 AM every day
    System.schedule('Pricing Condition Approval Reminders', 
                    '0 0 7 * * ?',
                    new PricingConditionApproversSchedulable());
    */
    
    global void execute(SchedulableContext sc) {
        PricingConditionApproversBatchable pcab = new PricingConditionApproversBatchable(false, null);
        Id processId;
        try {
            processId = Database.executeBatch(pcab);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}