public with sharing class VIPfcPageController {

    private static final String PARAM_ACCOUNT_NUMBER = 'accNum';

    private void debug(String s) {
        System.debug(LoggingLevel.INFO, 'VIPfcPageController : ' + s);
    }
    
    public PageReference gotoPfc() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
    	String accountNumber = params.get(PARAM_ACCOUNT_NUMBER);
    	//accountNumber = '0002279-12240';
        debug('accountNumber : ' + accountNumber);
        PageReference pageRef = VIUtils.getPfcPageRef(accountNumber);
        debug(pageRef.getUrl());
        //pageRef = null;
        return pageRef;
    }
}