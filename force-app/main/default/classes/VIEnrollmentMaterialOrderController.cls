public class VIEnrollmentMaterialOrderController {

    public Blob emosBlob           {get; set;}
    public Boolean renderMsgTables {get; set;}
    public Boolean renderUploadBtn {get; set;}
    public Boolean renderUpdateBtn {get; set;}
    public Integer currentStep     {get; private set;}
    public String emosFileName     {get; set;}
    public List<String> smsgs      {get; private set;}
    public List<String> emsgs      {get; private set;}
    
    public VIEnrollmentMaterialOrderController() {init();}
    
    private void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    private void init() {
        debug('VIEnrollmentMaterialOrderController : init');
        currentStep = 1; renderMsgTables = false;
        renderUploadBtn = true; renderUpdateBtn = true;
    }
    
    public void updateShippingData() {
        renderUploadBtn = false; renderUpdateBtn = false;
        ApexPages.Message msg = null; Integer n = 0;
        smsgs = new List<String>(); emsgs = new List<String>();
        if (emosBlob != null) {
            String s = emosBlob.toString(); emosBlob = null;
            n = VIEnrollmentMaterialOrderFunctions.updateShippingData(s, smsgs, emsgs);
            renderMsgTables = (smsgs.size() > 0 || emsgs.size() > 0);
            //msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Updated Records Count = '+n);
        } else {
            msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No data found in the file');
            renderUploadBtn = true; renderUpdateBtn = true;
        }
        if (msg != null) {ApexPages.addMessage(msg);}
    }
    
}