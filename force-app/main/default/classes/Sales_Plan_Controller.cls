public class Sales_Plan_Controller {

    private static final Integer BATCH_SIZE = 200;
    private static final String BATCH_JOB_MSG = 'Your request is in progress. You will be notified by email when it completes.';

    private static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    private static final ApexPages.Severity INFO = ApexPages.Severity.INFO;

    public Boolean disableProdPlanActJobBtn      {get; private set;}
    public Boolean disableProdPlanCrtJobBtn      {get; private set;}

    public Sales_Plan_Controller() {init();}
    
    private void init() {
        disableProdPlanActJobBtn = false; 
        disableProdPlanCrtJobBtn = false;
    }
    
    private void addErrMsg(String s) {addMsg(ERROR, s);}
    
    private void addInfoMsg(String s) {addMsg(INFO, s);}
    
    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }
    
    private void submitBatchJob(String pstep) {
        Sales_Plan_Batchable b = new Sales_Plan_Batchable(pstep, null);
        //Sales_Plan_Batchable b = new Sales_Plan_Batchable(pstep, 1);
        try {Database.executeBatch(b, BATCH_SIZE); addInfoMsg(BATCH_JOB_MSG);}
        catch(Exception e) {addErrMsg(e.getMessage());}
    }
    
    public void createNextYearProdPlans() {
        submitBatchJob(Sales_Plan_Batchable.PROD_PLAN_CREATE);
        disableProdPlanCrtJobBtn = true; 
    }

    public void activateNextYearProdPlans() {
        submitBatchJob(Sales_Plan_Batchable.PROD_PLAN_ACTIVATE);
        disableProdPlanActJobBtn = true; 
    }
}