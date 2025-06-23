public with sharing class UltimateParentDataAnalyzerController {

 	public String accountId {get;set;}
 	public List<acctCompare> results {get;set;}
 	public Boolean showAll {get;set;}
 	
 	public Integer allCount {get;set;}
 	public Integer issueCount {get;set;}
 	
 	public void toggleShowAll() {
 		showAll = !showAll;
 		refreshData();
 	}

	public UltimateParentDataAnalyzerController() {
		accountId = ApexPages.currentPage().getParameters().get('id');
		showAll = false;
    	init();
	}



	public void init() {
		refreshData();
	}

	private void refreshData() {
		List<Account_Relationship__c> acctRelationships = [SELECT Id, 
		                                                          Child_Account__c, 
		                                                          Child_Account__r.Id,
		                                                          Child_Account__r.Name,
		                                                          Child_Account__r.ParentId,
		                                                          Child_Account__r.Parent_Chain__c,
		                                                          Child_Account__r.LastModifiedDate,
		                                                          Parent_Account__c, 
		                                                          Separation__c, 
		                                                          Child_Account_Parent_Chain__c 
		                                                     FROM Account_Relationship__c 
		                                                    WHERE Parent_Account__c = :accountId];
		                                                    
		Map<Id,Account_Relationship__c> acctRelationshipsMap = new Map<Id,Account_Relationship__c>(acctRelationships);
		Map<Id,Account_Relationship__c> childAccountMap = new Map<Id,Account_Relationship__c>();
		for (Account_Relationship__c ar : acctRelationships) {
			childAccountMap.put(ar.Child_Account__c,ar);
		} 
		
		//Query Records based on Accounts Tab
	    List<Account> accounts = [SELECT Id, 
	                                     ParentId, 
	                                     Parent_Chain__c,
	                                     Name,
	                                     Account_Rollup__c,
	                                     LastModifiedDate 
	                                FROM Account 
	                               WHERE (ParentId = :accountId 
	                                  OR Parent.ParentId = :accountId  
	                                  OR Parent.Parent.ParentId = :accountId  
	                                  OR Parent.Parent.Parent.ParentId = :accountId)  
	                            ORDER BY LastModifiedDate LIMIT 20000];
		Map<Id,Account> accountsMap = new Map<Id,Account>(accounts); 		                                               
		
		//Compare and Show Diff		
		
		Set<Id> distinctAccountIds = new Set<Id>();
		distinctAccountIds.addAll(accountsMap.keySet());
		distinctAccountIds.addAll(childAccountMap.keySet());
		
		Map<Id,acctCompare> resultsMap = new Map<Id,acctCompare>();
		
		for (Id accountId : distinctAccountIds) {
			AcctCompare acctCompare = new AcctCompare(accountId,accountsMap.get(accountId),childAccountMap.get(accountId));
			resultsMap.put(accountId,acctCompare);
		}
		
		
		results = resultsMap.values();

		allCount = results.size();
		issueCount = 0;

		List<AcctCompare> newResults = new List<AcctCompare>();
		for (AcctCompare rec : results) {
			if (String.isNotEmpty(rec.message)) {
				newResults.add(rec);
				issueCount++;
				}
		}
			
		if (!showAll) {
			results = newResults;
		}
		
		//Make sure results size doesn't exceed 1000
		if (results.size() > 1000) {
			List<AcctCompare> trimmedResults = new List<AcctCompare>();
			for (Integer i=0; i<1000;i++) {
				trimmedResults.add(results[i]);
			} 			
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning, 'Only the first 1000 records are shown');
			ApexPages.addMessage(myMsg);
			results = trimmedResults;
		}
	}


	public String accountIdToRebuildARs {get;set;}

	public void rebuildAccountRelationshipsforAccount() {
		List<Account> accounts = new List<Account>();
		accounts = [SELECT Id, ParentId, Parent_Chain__c, Prev_Parent_Chain__c FROM Account WHERE Id = :accountIdToRebuildARs LIMIT 1];
		Account_Relationship.CreateAccountRelationshipRecordsResult results = Account_Relationship.createAccountRelationshipRecords(accounts);

		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Creation Results:');
		ApexPages.addMessage(myMsg);

		myMsg = new ApexPages.Message(ApexPages.Severity.INFO, '  - Postponed Items: ' + results.postponed);
		ApexPages.addMessage(myMsg);
		
		for (String error : results.errors) {
			myMsg = new ApexPages.Message(ApexPages.Severity.INFO, '  - Error: ' + error);
			ApexPages.addMessage(myMsg);
		}

		refreshData();
	}

	public String ARRecIdToDelete {get;set;}

	public void deleteAccountRelationshipRecord() {
		List<Account_Relationship__c> ARs = new List<Account_Relationship__c>();
		ARs = [SELECT Id FROM Account_Relationship__c WHERE Id = :ARRecIdToDelete LIMIT 1];
		
		if (ARs.size() > 0) {
			delete ARs;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The Account Relationship Record was Deleted.');
			ApexPages.addMessage(myMsg);
		}
		else {
		}
		refreshData();
	}

	public String AccountIdToRebuildRollupRecord {get;set;}

	public void rebuildAccountRollupRecord() {
		List<Account> accounts = new List<Account>();
		accounts = [SELECT Id, ParentId, Parent_Chain__c FROM Account WHERE Id = :AccountIdToRebuildRollupRecord];
		Account_Rollup.recalcRollups(accounts);

		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The Account Rollup Record for ' + AccountIdToRebuildRollupRecord + ' was reprocessed.');
		ApexPages.addMessage(myMsg);

		refreshData();
	}

	public String AccountIdToReprocessECOMCustRecords {get;set;}

	public void reprocessECOMCustRecords() {
		List<Account> accounts = new List<Account>();
		accounts = [SELECT Id, ParentId, Parent_Chain__c FROM Account WHERE Id = :AccountIdToReprocessECOMCustRecords];
		SAP_ECOM_Customer.processAccounts(accounts);

		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The ECOM Cust Records for ' + AccountIdToReprocessECOMCustRecords + ' were reprocessed.');
		ApexPages.addMessage(myMsg);

		refreshData();
	}

	public class AcctCompare {
		
		public AcctCompare(Id accountId, Account account,Account_Relationship__c ar) {
			this.accountId = accountId;
			this.account = account;
			this.ar = ar;
			
		}
		
		public Id accountId {get;set;}
		public Account account {get;set;}
		public Account_Relationship__c ar {get;set;}
		public String message {get {
			String result = '';
			
			if (account == null) {
				result = 'Account Relationship exists but is not part of Account Parent Chain';
			}
			
			if (ar == null) {
				result = 'Account is in Parent Chain but no Account Relationship record exists';
			}
			
			return result;	
		}
		set;}
	} 


}