public without sharing class AccountRollupExtension {

    /***********************
     * Generic Private Vars
     ***********************/
    private Account account;
    public Id accountId {get;set;}

    public String startingSection {get;set;}  
    public String focusId {get;set;}  

    public void AssignURLParams() {
        System.debug('*** - startingSection set to ' + startingSection);
        System.debug('*** - focusId set to ' + focusId);
    }

    /**************
     * Constructor
     **************/
    public AccountRollupExtension(ApexPages.StandardController stdController) {
        Account primaryAccount = (Account)stdController.getRecord();
        accountId = primaryAccount.Id;
        account = retrieveAccount(accountId);
        
        System.debug('*** - AccountRollupExtension stdController.view().getUrl() = ' + stdController.view().getUrl());
        System.debug('*** - AccountRollupExtension stdController.view().getParameters() = ' + stdController.view().getParameters());
        System.debug('*** - AccountRollupExtension ApexPages.currentPage().getUrl() = ' + ApexPages.currentPage().getUrl());
        System.debug('*** - AccountRollupExtension ApexPages.currentPage().getParameters() = ' + ApexPages.currentPage().getParameters());
        
    }

    /**************************
     * Generic Private Methods
     **************************/
    private Account retrieveAccount(Id accountId) {
        return [SELECT Id,
                       RecordTypeId,
                       RecordType.Name, 
                       Account_Rollup__c 
                  FROM Account
                 WHERE Id = :accountId];
    }
}