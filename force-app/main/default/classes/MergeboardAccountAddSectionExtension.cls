public with sharing class MergeboardAccountAddSectionExtension {

	public Boolean accountInMergeboard {get;set;}
	public String status {get;set;}
	public Boolean mergeboardEnabled {
		get {
			return MergeboardMethods.mergeboardEnabled();
		}
		private set;
	}

	private Id accountId;

    private final ApexPages.StandardController controller;
	public MergeboardAccountAddSectionExtension(ApexPages.StandardController controller) {
		this.controller = controller;
		accountId = ApexPages.currentPage().getParameters().get('id');
		
		refreshShowValues();
	}

	public void refreshShowValues() {
		accountInMergeboard = MergeboardMethods.accountExistsinMergeboard(accountId);
		System.debug('accountId=' + accountId);
		System.debug('accountInMergeboard=' + accountInMergeboard);
	}

	public void addToMergeboard() {
		MergeboardMethods.AddAccountToMergeboardResult result = MergeboardMethods.addAccountToMergeboard(accountId);
		
		if (result.success) {
			status = 'Item Added To Mergeboard';
		}
		else {
			status = result.errorMessage;
		}
		
		refreshShowValues();
	}
	
	public void removeFromMergeboard() {
		status = 'Item Removed From Mergeboard';
		MergeboardMethods.removeAccountFromMergeboard(accountId);
		refreshShowValues();
	}
	
	public void openingMergeboardURL() {
		status = '';
	}
	
	public PageReference openMergeboardURL() {
		PageReference result = new PageReference('/apex/Mergeboard');
		result.setRedirect(true);
		return result;
	}

	public Integer mergeboardItemCount {
		get {
			return MergeboardMethods.getAccountsInMergeboardCount();
		}
		set;
	}

	public String mergeboardItemSummary {
		get {
			return MergeboardMethods.getAccountsInMergeboardSummary();
		}
		set;
	}

}