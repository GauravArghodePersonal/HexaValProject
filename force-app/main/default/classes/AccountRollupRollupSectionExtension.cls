public with sharing class AccountRollupRollupSectionExtension {

    /**************
     * Constructor
     **************/
      
    public AccountRollupRollupSectionExtension(ApexPages.StandardController stdController) {
        Account primaryAccount = (Account)stdController.getRecord();
        accountId = primaryAccount.Id;
        account = retrieveAccount(accountId);
        startupInit();
    }

    /****************************
     * User Action Init Routines
     ****************************/
    private void startupInit() {
    	populateRollupRec(account.Account_Rollup__c);
    	retrieveAndProcessChildAccountRelationships();
    }
    
    /***************************
     * Generic Public Interface
     ***************************/
     // General Interface Vars
    public Boolean recalcPending {get;set;}
    public Boolean ChildInfoExists {get;set;}
    public Boolean getNoChildInfoExists() {return !this.ChildInfoExists;}
    public Boolean AccountRollupRecExists {get;set;}

    /***********************
     * Generic Private Vars
     ***********************/
    // Current Account  
    private Account account;
    private Boolean requeryNeeded = false;
    private Boolean requeryCountNeeded = false;
    
    public Id accountId {get;set;}
    
    // Related Child Account Ids
    private List<Id> childAccountIds {get;set;}

    /**************************
     * Generic Private Methods
     **************************/
    private Account retrieveAccount(Id accountId) {
        return [SELECT Id, 
                       Account_Rollup__c 
                  FROM Account
                 WHERE Id = :accountId];
    }

    private void retrieveAndProcessChildAccountRelationships() {
        List<Account_Relationship__c> childAccountRelationships;
        this.recalcPending = false;

        childAccountRelationships = [SELECT Child_Account__c,
                                            Recalc_Needed__c
                                       FROM Account_Relationship__c
                                      WHERE Parent_Account__c = :account.Id
                                   ORDER BY Child_Account__r.Name, Child_Account__r.AccountNumber
                                    ];

        if (childAccountRelationships.size() > 0)
        {
            ChildInfoExists = true;
            childAccountIds = new List<Id>();
            for (Account_Relationship__c ar : childAccountRelationships)
            {
                childAccountIds.add(ar.Child_Account__c);
                if (ar.Recalc_Needed__c && this.recalcPending == false) {this.recalcPending = true;}
            }
        }
        else
        {
            ChildInfoExists = false;
        }
    } 
     

    /************************
     * rollupSection Methods
     ************************/
    private Account_Rollup__c rollupRec;

    public Account_Rollup__c getRollupRec() {
        populateRollupRec(account.Account_Rollup__c);
        return rollupRec;
    }
    
    private void populateRollupRec(Id rollupRecId) {
        if (rollupRec == null || requeryNeeded) {
            requeryNeeded = false;
            rollupRec = AccountRollupPageQueries.retrieveRollupRec(rollupRecId);
        }
    }

    public Boolean getShowAdminPanel() {return (User_Functions.isSysAdmin() || User_Functions.isSupport());}

    public void recalcAccountNow() {
        Account_Rollup.recalcRollups(account);
        account = retrieveAccount(account.Id);
        retrieveAndProcessChildAccountRelationships();
        requeryNeeded = true;
        requeryCountNeeded = true;
        //refreshData(visibleSection);
    }
     
    public void submitBatchJob_RecalcRollups() {
        AccountRollupRefreshBatch.submitBatchJob();
        requeryNeeded = true;
        requeryCountNeeded = true;
        //refreshData(visibleSection);
    }

    public void submitBatchJob_RecalcRollups_RefreshAll() {
        AccountRollupRefreshBatch.submitBatchJob_RefreshAll();
        requeryNeeded = true;
        requeryCountNeeded = true;
        //refreshData(visibleSection);
    }
}