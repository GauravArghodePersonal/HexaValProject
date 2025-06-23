public class PortalSiteHomeController {

    private final static String SUCCESS = 'success';
    private final static String FAILURE = 'failure';
    
    public String loginResult {get; set;}
    public String portalId    {get; set;}
    public String username    {get; set;}
    
    public void login() {
        loginResult = FAILURE;
        if (!String.isBlank(portalId)) {loginResult = SUCCESS;}
    }

}