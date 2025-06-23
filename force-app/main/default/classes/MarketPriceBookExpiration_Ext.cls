public with sharing class MarketPriceBookExpiration_Ext {
	/* Constructor */
    public MarketPriceBookExpiration_Ext(ApexPages.StandardController stdController) {
        Market_Price_Book__c primaryMPB = (Market_Price_Book__c)stdController.getRecord();
        mpbId = primaryMPB.Id;
        mpb = retrieveMarketPriceBook(mpbId);
        stats = new MarketPriceBookStats(mpbId);
        UpdateMessagesBasedOnStats();
    }


	/* Public Vars */
	public Market_Price_Book__c mpb {get;set;}
	public Id mpbId {get;set;}
	
	
    public MarketPriceBookStats stats {get;set;}  

	public Boolean showMarketPriceBookEntriesBlock {get {return stats.marketPriceBookEntries.size() > 0;}}
	public String marketPriceBookEntriesMessage {get;set;}
	public List<Market_Price_Book_Entry__c> marketPriceBookEntries {get {return stats.marketPriceBookEntries.Values();}}

	public Boolean showAccountToMarketPriceBookEntriesBlock {get {return stats.accountToMarketPriceBookEntries.size() > 0;}}
	public String accountToMarketPriceBookEntriesMessage {get;set;}
	public List<Account_To_Market_Price_Book_Entry__c> accountToMarketPriceBookEntries {get {return stats.accountToMarketPriceBookEntries.Values();}}

	public Boolean showActivePricingConditionsBlock {get {return stats.activePricingConditions.Size() > 0;}}
	public String activePricingConditionsMessage {get;set;}
	public List<Pricing_Condition__c> activePricingConditions {get {return stats.activePricingConditions.Values();}}

	public Boolean showDraftPricingConditionsBlock {get {return stats.draftPricingConditions.Size() > 0;}}
	public String draftPricingConditionsMessage {get;set;}
	public List<Pricing_Condition__c> draftPricingConditions {get {return stats.draftPricingConditions.Values();}}

	public Boolean showApprovedNotYetActivePricingConditionsBlock {get {return stats.approvedNotYetActivePricingConditions.Size() > 0;}}
	public String approvedNotYetActivePricingConditionsMessage {get;set;}
	public List<Pricing_Condition__c> approvedNotYetActivePricingConditions {get {return stats.approvedNotYetActivePricingConditions.Values();}}

	public Boolean showInApprovalProcessPricingConditionsBlock {get {return stats.inApprovalProcessPricingConditions.Size() > 0;}}
	public String inApprovalProcessPricingConditionsMessage {get;set;}
	public List<Pricing_Condition__c> inApprovalProcessPricingConditions {get {return stats.inApprovalProcessPricingConditions.Values();}}


	public Boolean warningNeeded {get {
		return (
		       stats.accountToMarketPriceBookEntries.size() > 0 ||
		       stats.activePricingConditions.Size() > 0 ||
		       stats.draftPricingConditions.Size() > 0 ||
		       stats.approvedNotYetActivePricingConditions.Size() > 0 ||
		       stats.inApprovalProcessPricingConditions.Size() > 0
		       );
		}
	}

    /* Page Actions */

    public PageReference redirectToMarketPriceBookViewerPage() {
    	PageReference redirect = Page.App_MarketPriceBookViewer_WebApp_View;
    	redirect.getParameters().put('id',mpbId);
    	redirect.setRedirect(true);
    	return redirect;
    }
    
    /* Private Methods */
    
    private Market_Price_Book__c retrieveMarketPriceBook(Id mpbId) {
    	return [SELECT Id, Name, Description__c FROM Market_Price_Book__c WHERE Id = :mpbId];
    }
    
    private void UpdateMessagesBasedOnStats() {
    	if (stats.marketPriceBookEntries.Size() < MarketPriceBookExpirationMethods.DEFAULT_LIMIT) {
    		marketPriceBookEntriesMessage = 'There are a total of ' + stats.marketPriceBookEntries.Size() + (stats.marketPriceBookEntries.Size() == 1 ? ' entry ' : ' entries ') + 'related to this Market Price Book.';
    	}
    	else { 
    		marketPriceBookEntriesMessage = 'There at least ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' Entries related to this Market Price Book.  Details of the first ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' are shown below.';
    	}
    	
    	if (stats.accountToMarketPriceBookEntries.Size() < MarketPriceBookExpirationMethods.DEFAULT_LIMIT) {
			accountToMarketPriceBookEntriesMessage = 'There are a total of ' + stats.accountToMarketPriceBookEntries.Size() + (stats.accountToMarketPriceBookEntries.Size() == 1 ? ' Account ' : ' Accounts ') + 'related to Entries in this Market Price Book.';
    	}
    	else {
    		accountToMarketPriceBookEntriesMessage = 'There at least ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' Accounts related to Entries in this Market Price Book.  Details of the first ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' are shown below.';
    	}
			
		if (stats.activePricingConditions.Size() < MarketPriceBookExpirationMethods.DEFAULT_LIMIT) {
			activePricingConditionsMessage = 'There are a total of ' + stats.activePricingConditions.Size() + ' "Active"' + (stats.activePricingConditions.Size() == 1 ? ' Pricing Condition ' : ' Pricing Conditions ') + 'related to entries in this Market Price Book.';
    	}
    	else {
    		activePricingConditionsMessage = 'There are at least ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' "Active" Pricing Conditions related to Entries in this Market Price Book.  Details of the first ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' are shown below.';
    	}
			
    	if (stats.draftPricingConditions.Size() < MarketPriceBookExpirationMethods.DEFAULT_LIMIT) {
			draftPricingConditionsMessage = 'There are a total of ' + stats.draftPricingConditions.Size() + ' "Draft"' + (stats.draftPricingConditions.Size() == 1 ? ' Pricing Condition ' : ' Pricing Conditions ') + 'related to entries in this Market Price Book.';
    	}
    	else {
    		draftPricingConditionsMessage = 'There are at least ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' "Draft" Pricing Conditions related to Entries in this Market Price Book.  Details of the first ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' are shown below.';
    	}


    	if (stats.approvedNotYetActivePricingConditions.Size() < MarketPriceBookExpirationMethods.DEFAULT_LIMIT) {
			approvedNotYetActivePricingConditionsMessage = 'There are a total of ' + stats.approvedNotYetActivePricingConditions.Size() + ' "Approved, Not Yet Active"' + (stats.approvedNotYetActivePricingConditions.Size() == 1 ? ' Pricing Condition ' : ' Pricing Conditions ') + 'related to Entries in this Market Price Book.';
    	}
    	else {
    		approvedNotYetActivePricingConditionsMessage = 'There are at least ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' "Approved, Not Yet Active" Pricing Conditions related to Entries in this Market Price Book.  Details of the first ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' are shown below.';
    	}


    	if (stats.inApprovalProcessPricingConditions.Size() < MarketPriceBookExpirationMethods.DEFAULT_LIMIT) {
			inApprovalProcessPricingConditionsMessage = 'There are a total of ' + stats.inApprovalProcessPricingConditions.Size() + ' "In Approval Process"' + (stats.inApprovalProcessPricingConditions.Size() == 1 ? ' Pricing Condition ' : ' Pricing Conditions ') + 'related to Entries in this Market Price Book.';
    	}
    	else {
    		inApprovalProcessPricingConditionsMessage = 'There are at least ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' "In Approval Process" Pricing Conditions related to Entries in this Market Price Book.  Details of the first ' + MarketPriceBookExpirationMethods.DEFAULT_LIMIT + ' are shown below.';
    	}
    }
}