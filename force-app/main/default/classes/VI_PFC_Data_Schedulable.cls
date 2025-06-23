global with sharing class VI_PFC_Data_Schedulable implements Schedulable {

    /* Run this code to schedule to run these jobs at 1 and 8 PM every day
    System.schedule('Valvoline PFC Data Delete Job', 
                    '0 0 13 * * ?',
                    new VI_PFC_Data_Schedulable(VI_PFC_Data_Batchable.PROC_STEP_DELETE));
    System.schedule('Valvoline PFC Data Create Job', 
                    '0 0 20 * * ?',
                    new VI_PFC_Data_Schedulable(VI_PFC_Data_Batchable.PROC_STEP_CREATE));
    */
    
    private String procStep;
    
    global VI_PFC_Data_Schedulable(String pstep) {procStep = pstep;}
    
    global void execute(SchedulableContext sc) {
        VI_PFC_Data_Batchable b = new VI_PFC_Data_Batchable(procStep);
        Id processId;
        try {
            processId = Database.executeBatch(b);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}