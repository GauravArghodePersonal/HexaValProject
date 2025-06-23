public class CustomPageController {

    static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    static final ApexPages.Severity INFO = ApexPages.Severity.INFO;

    ApexPages.StandardController sc;
    
    public CustomPageController() {}
    
    public CustomPageController(ApexPages.StandardController sc) {this.sc = sc;}
    
    private void debug(String s) {DebugLog_Functions.info('>>>>>>>> ' + s);}
    
    private void addErrMsg(String s) {addMsg(ERROR, s);}
    
    private void addInfoMsg(String s) {addMsg(INFO, s);}
    
    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    } 

    public PageReference saveAndSubmit() {
    	PageReference pr = null; String msg = 'Error in Saving Data - ';
        if (sc == null) {
            addErrMsg(msg + 'Unknown Standard Controller');
        } else {
            pr = sc.save(); 
            String objectId = sc.getId();
            if (isNull(objectId)) {
                addErrMsg(msg + 'Unknown Object Id');
            } else {
            	Custom_Approval_Functions.submitForApproval(objectId);
            }
        }
        return pr;
    }
    
}