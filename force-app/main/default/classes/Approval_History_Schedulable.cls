global with sharing class Approval_History_Schedulable implements Schedulable {

    /* Run this code to schedule these jobs
    System.schedule('PC Approval History Update Job', 
                    '0 0 2 * * ?',
                    new Approval_History_Schedulable(Approval_History_Batchable.PRICING_CONDITION, 1));
    */
    
    private String objectName; private Integer numberOfdays;
    
    global Approval_History_Schedulable(String objName, Integer days) {
    	objectName = objName; numberOfdays = days;
    }
    
    global void execute(SchedulableContext sc) {
        Approval_History_Batchable b = new Approval_History_Batchable(objectName, numberOfdays);
        try {Id pid = Database.executeBatch(b);} catch(Exception e) {System.debug(e);}
    }
}