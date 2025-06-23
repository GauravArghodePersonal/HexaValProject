public without sharing class FlintSiteHomeController {

    private static final String SUCCESS = 'success';
    private static final String FAILURE = 'failure';
    private static final Flint_Portal_Settings__c FPS = Flint_Portal_Settings__c.getInstance();
    
    public String loginResult {get; set;}
    public String portalId    {get; set;}
    public String username    {get; set;}
        
    public void login() {
        loginResult = FAILURE;
        if (FPS != null) {portalId = FPS.Partner_Portal_ID__c; loginResult = SUCCESS;}
    }
}