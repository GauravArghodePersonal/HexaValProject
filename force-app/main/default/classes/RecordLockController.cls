public with sharing class RecordLockController {

    private static final String ANY_OBJECT = 'Any_Object__c';
    
    public Boolean renderUnlockBtn {get; private set;}
    public RecordLock recordLock   {get; private set;}
    
    private String editURL, recId, retURL;
    
    private Record_Lock_Settings__c rls = Record_Lock_Settings__c.getInstance();
    
    private void debug(String s) {
        System.debug(LoggingLevel.INFO, s);
    }

    public RecordLockController() {
        debug('constructor()');
        Map<String, String> pmap = ApexPages.currentPage().getParameters();
        recId = pmap.get('id'); retURL = pmap.get('retURL');
        recordLock = new RecordLock(recId);
    }   
    
    public RecordLockController(ApexPages.StandardController sc) {
        debug('constructor(sc)');
        SObject obj = sc.getRecord(); recId = obj.Id;
        String objType = obj.getSObjectType().getDescribe().getName();
        initRenderUnlockBtn(objType);
        retURL = 'retURL=/apex/RecordUnlock?id=' + recId;
        editURL = '/' + recId + '/e?nooverride=1&' + retURL;
        recordLock = new RecordLock(recId);
    }
    
    private void initRenderUnlockBtn(String objType) {
        renderUnlockBtn = false;
        if (rls == null) {return;}
        Boolean b1 = (Boolean)rls.get(ANY_OBJECT), b2 = (Boolean)rls.get(objType);
        renderUnlockBtn = (b1 != null && b1 == true) || (b2 != null && b2 == true);
    }   
    
    public PageReference lockRecord() {
        Boolean lockSuccess = recordLock.lockRecord();
        PageReference pr = null;
        if (lockSuccess) {pr = new PageReference(editURL);}
        return pr;
    }

    public PageReference unlockRecord() {
        Boolean unlockSuccess = recordLock.unlockRecord();
        return returnToView();
    }

    public PageReference returnToView() {
        PageReference pr = new PageReference('/' + recId);
        return pr;
    }
}