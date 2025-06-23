public with sharing class VILearnshareController {

    private void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'VILearnshareController : ' + s);
    }
    
    public PageReference gotoLearnshare() {
        return VIUtils.getLearnsharePageRef();
    }
}