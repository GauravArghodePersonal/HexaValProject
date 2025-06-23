global with sharing class VI_LearnShare_Schedulable implements Schedulable {

    /* Run this code to schedule to run these jobs at 5:30 and 7:30 PM every day
    System.schedule('Valvoline LearnShare Data Delete Job', 
                    '0 0 17 30 * ?',
                    new VI_LearnShare_Schedulable(VI_LearnShare_Batchable.PROC_STEP_DELETE));
    System.schedule('Valvoline LearnShare Data Create Job', 
                    '0 0 19 30 * ?',
                    new VI_LearnShare_Schedulable(VI_LearnShare_Batchable.PROC_STEP_CREATE));
    */
    
    private final Integer maxCount = 100000;
    private String procStep;
    
    global VI_LearnShare_Schedulable(String pstep) {procStep = pstep;}
    
    global void execute(SchedulableContext sc) {
        VI_LearnShare_Batchable b = new VI_LearnShare_Batchable(procStep, maxCount);
        Id processId;
        try {
            processId = Database.executeBatch(b);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }

}