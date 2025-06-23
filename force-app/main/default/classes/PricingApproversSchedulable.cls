global with sharing class PricingApproversSchedulable implements Schedulable {

    /* Run this code to schedule to run this job at 5 AM every day
    System.schedule('Pricing Approval Reminders', 
                    '0 0 5 * * ?',
                    new PricingApproversSchedulable());
    */
    
    global void execute(SchedulableContext sc) {
        PricingApproversBatchable pcab = new PricingApproversBatchable(false, null);
        Id processId;
        try {
            processId = Database.executeBatch(pcab);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}