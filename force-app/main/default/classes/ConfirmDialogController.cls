public class ConfirmDialogController {
    
    private static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    private static final ApexPages.Severity INFO  = ApexPages.Severity.INFO;
    private static final ApexPages.Severity WARN  = ApexPages.Severity.WARNING;
    
    public ConfirmDialogParam param;

    public ConfirmDialogController() {}
    
    private void debug(String s) {System.debug(LoggingLevel.INFO, 'CDC : ' + s);}
    
    @TestVisible private void addErrMsg(String s) {addMsg(ERROR, s);}
    
    @TestVisible private void addInfoMsg(String s) {addMsg(INFO, s);}
    
    @TestVisible private void addWarnMsg(String s) {addMsg(WARN, s);}
    
    private void addMsg(ApexPages.Severity mtype, String s) {
    	if (!String.isBlank(s)) { 
	        ApexPages.Message msg = new ApexPages.Message(mtype, s);
	        ApexPages.addMessage(msg);
    	}
    }
    
    public ConfirmDialogParam getParam() {return param;}
    public void setParam(ConfirmDialogParam p) {
        if (param != null) {return;}
        param = p; debug('setParam : ' + p);
        if (param != null) {addWarnMsg(param.warnMsg1);}
    }
    
    public PageReference gotoCancel() {
        if (param == null) {return null;}
        param.renderComp = false;
        if (param.cancelUrl == null) {return null;}
    	return new PageReference(param.cancelUrl);
    }

    public PageReference gotoContinue() {
    	if (param != null) {param.renderComp = false;}
        return null;
    }

    public PageReference gotoYes() {
    	if (param != null) {param.renderComp = false; param.clickedYes = true;}
        return null;
    }
    
    public PageReference gotoNo() {
    	if (param != null) {param.renderComp = false; param.clickedNo = true;}
        return null;
    }
        

}