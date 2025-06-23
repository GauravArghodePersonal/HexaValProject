public with sharing class MergeboardMethods {

    public static final Integer MAX_NUMBER_OF_MERGEBOARD_ACCOUNT_ITEMS = 50;

	public class AddAccountToMergeboardResult {
		public Id id {get;set;}
		public Boolean success {get;set;}
		public String errorMessage {get;set;}
		
		public AddAccountToMergeboardResult() {
			id = null;
			success = false;
			errorMessage = '';
		}
	}

	public static AddAccountToMergeboardResult addAccountToMergeboard(Account account) {return addAccountToMergeboard(account.Id);}
	public static AddAccountToMergeboardResult addAccountToMergeboard(Id id) {
		AddAccountToMergeboardResult result = new AddAccountToMergeboardResult();
		Id insertedRecordId;
		Integer recCount = getAccountsInMergeboardCount();

		if (recCount < MAX_NUMBER_OF_MERGEBOARD_ACCOUNT_ITEMS) {
			Mergeboard_Account_Item__c newItem = new Mergeboard_Account_Item__c();
			newItem.Account__c = id;
			newItem.Record_Key__c = id + '_' + UserInfo.getUserId();
			
			try {
				Schema.SObjectField f = Mergeboard_Account_Item__c.Fields.Record_Key__c;
				Database.upsertResult upsertResult = Database.upsert(newItem, f);
				if (upsertResult.isSuccess()) {
					insertedRecordId = upsertResult.getId();
				}
			}
			catch (Dmlexception e) {
				System.debug(e.getMessage());
			}
			
			if (insertedRecordId != null) {
				result.success = true;
			}
			else {
				result.success = false;
				result.errorMessage = 'Error: Unable to add to Mergeboard!  Read/Write Access to this account is needed to add.';
			}
		}
		else {
			result.success = false;
			result.errorMessage = 'Error: Item cannot be added! The Mergeboard is full(' + MAX_NUMBER_OF_MERGEBOARD_ACCOUNT_ITEMS + ' Max). Remove some accounts before trying to add more.';
		}	
		
		return result;
	}

	public static Boolean mergeboardEnabled() {
		Boolean result = false;
		String setting = OrgSettings.retrieveSetting('Mergeboard_Enabled__c');
		
		if (setting != null) {
			result = Boolean.valueOf(setting);
		}
		return result;
	}

	public static Boolean accountExistsinMergeboard(Id accountId) {
		Boolean result = false;
		List<Mergeboard_Account_Item__c> items;

		items = [SELECT Id FROM Mergeboard_Account_Item__c WHERE Account__c = :accountId AND CreatedById = :UserInfo.getUserId()];
		
		if (items.size() > 0) {result = true;}
		
		return result;
	}

	public static Integer getAccountsInMergeboardCount() {
		Integer result = 0;
		
		try {
			result = [SELECT COUNT() FROM Mergeboard_Account_Item__c WHERE CreatedById = :UserInfo.getUserId()];
		}
		catch (Exception e) {}
		
		return result;
	}

	public static String getAccountsInMergeboardSummary() {
		String result = '';
		
		List<MergeboardAccountItem> items = retrieveAccountItems();
		
		for (MergeboardAccountItem item : items) {
			result += item.accountNumber + ' - ' + item.name + '\n';			
		}

		return result;
	}

	public static void removeAccountFromMergeboard(Id id) {
		Mergeboard_Account_Item__c itemToDelete;
		Schema.SObjectType sobjectType = id.getSObjectType();
		Schema.DescribeSObjectResult dr = sobjectType.getDescribe();
		String objectName = dr.getName();
		
		if (objectName == 'Mergeboard_Account_Item__c') {
			itemToDelete = [SELECT Id FROM Mergeboard_Account_Item__c WHERE Id = :id];
		}

		if (objectName == 'Account') {
			itemToDelete = [SELECT Id FROM Mergeboard_Account_Item__c WHERE Account__c = :id AND CreatedById = :UserInfo.getUserId()];
		}

		try {
			if (itemToDelete != null) {
				delete itemToDelete;
			}
		}
		catch (Dmlexception e) {
			System.debug(e.getMessage());
		}	
	}

	public static void removeAllMergeboardAccountItemsForAccountId(Id id) {
		removeAllMergeboardAccountItemsForAccountIds(ListMethods.newWithData(id));
	}

	public static void removeAllMergeboardAccountItemsForAccountIds(List<Id> ids) {
		List<Mergeboard_Account_Item__c> itemsToDelete;
		
		itemsToDelete = [SELECT Id FROM Mergeboard_Account_Item__c WHERE Account__c IN :ids];

		try {
			if (itemsToDelete.size() > 0) {
				delete itemsToDelete;
			}
		}
		catch (Dmlexception e) {
			System.debug(e.getMessage());
		}	
	}

	public static List<MergeboardAccountItem> retrieveAccountItems() {
		List<MergeboardAccountItem> items = new List<MergeboardAccountItem>();
		
		List<Mergeboard_Account_Item__c> itemsInClipboard = [SELECT Id, 
		                                                            Account__c, 
		                                                            Account__r.Name,
		                                                            Account__r.AccountNumber,
		                                                            Account__r.Owner.Id,
		                                                            Account__r.Owner.Name,
		                                                            Account__r.RecordType.Name,
		                                                            Account__r.Type,
		                                                            Account__r.sales_area__c, 
		                                                            Account__r.State_City_Country__c 
		                                                       FROM Mergeboard_Account_Item__c WHERE CreatedById = :UserInfo.getUserId()];
		
		for (Mergeboard_Account_Item__c item : itemsInClipboard) {
			MergeboardAccountItem newItem = new MergeboardAccountItem();
			newItem.selected = false;
			newItem.sourceRec = item;
			newItem.mergeboardAccountItemId = item.Id;
			newItem.accountId = item.Account__c;
			newItem.name = item.Account__r.Name;
			newItem.accountNumber = item.Account__r.AccountNumber;
			newItem.ownerId = item.Account__r.Owner.Id;
			newItem.ownerName = item.Account__r.Owner.Name;
			newItem.recordTypeName = item.Account__r.RecordType.Name;
			newItem.accountType = item.Account__r.Type;
			newItem.salesArea = item.Account__r.sales_area__c; 
			newItem.stateCityCountry = item.Account__r.State_City_Country__c; 
			items.add(newItem);
		}
		
		return items;
	}
}