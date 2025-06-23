public with sharing class FlexAppContainerController {

    private String versionToRun = '';
    //public String overrideVersionToRunParam {get;set;}
    private String overrideVersionToRun;

    public String overrideVersionToRunParam { 
        get;
        set {
            if (overrideVersionToRun != value) {
                overrideVersionToRun = value;

                if (String.isNotEmpty(overrideVersionToRun)) {
                    System.debug('*** updating versionToRun');
                    versionToRun = overrideVersionToRun.toUpperCase();
                }
            }
        }
    }
 

    public FlexAppContainerController() {
        try {
            FlexAppSettings__c flexAppSettings = FlexAppSettings__c.getInstance();
            String defaultVersion = flexAppSettings.Default_Version__c.toUpperCase();
            if (defaultVersion == 'PROD' || defaultVersion == 'DEBUG' || defaultVersion == 'BETA' || defaultVersion == 'ALPHA') {
               versionToRun = defaultVersion;
            }
        } catch (Exception e) {versionToRun = 'PROD';}
        
        System.debug('*** overrideVersionToRunParam = ' + overrideVersionToRunParam);
        System.debug('*** versionToRun = ' + versionToRun);
        
        if (String.isNotEmpty(overrideVersionToRunParam)) {
            System.debug('*** updating versionToRun');
            versionToRun = overrideVersionToRunParam.toUpperCase();
        }

        System.debug('*** overrideVersionToRunParam = ' + overrideVersionToRunParam);
        System.debug('*** versionToRun = ' + versionToRun);
    }

    public Boolean getRunProd() {return (versionToRun == 'PROD');}
    public Boolean getRunDebug() {return (versionToRun == 'DEBUG');}
    public Boolean getRunBeta() {return (versionToRun == 'BETA');} 
    public Boolean getRunAlpha() {return (versionToRun == 'ALPHA');} 

    public Boolean getNoChoiceMade() {return (versionToRun == '');}

    public void startProdVersion() {versionToRun = 'PROD';}
    public void startDebugVersion() {versionToRun = 'DEBUG';}
    public void startBetaVersion() {versionToRun = 'BETA';}
    public void startAlphaVersion() {versionToRun = 'ALPHA';} 
    
    
    
    public String getfixServerURL(String url) {
        String result = url;
        
        result = result.replace('https://solenis--qa.cs66.my.salesforce.com','solenis.salesforce.com');
        
        return result;
    }
}