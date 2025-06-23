public with sharing class SAP_Ultimate_Parent {

	//public SAP_Ultimate_Parent__c sapUltimateParent;
	
	//public SAP_Ultimate_Parent(SAP_Ultimate_Parent__c rec) {
	//	sapUltimateParent = rec;
	//}

	public static void createUltimateParentAccounts(Map<Id,SAP_Ultimate_Parent__c> recsIn) {
		List<Account> newAccounts = new List<Account>();
				
		Id acctRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Ultimate Parent' AND SobjectType = 'Account'].Id;
				
		List<SAP_Ultimate_Parent__c> recs = retrieveSAPUltimateParentRecords(recsIn.keySet());
				                                      
		for (SAP_Ultimate_Parent__c rec:recs) {
			Account newAccount = new Account();
			populateAccountFromSAPUltimateParentRec(newAccount,rec,acctRecordTypeId,false);
			newAccounts.add(newAccount);
		}
	
		System.debug('*** CreateUltimateParentAccounts newAccounts - ' + newAccounts);
	
		Schema.SObjectField keyField = Account.Fields.Account_Number__c;
		List<Database.upsertResult> upsertResults = Database.upsert(newAccounts,keyField,false);
		
		Map<Id,Id> acctIdLookup = new Map<Id,Id>();
		for (Integer i=0;i<recs.size();i++) {
			acctIdLookup.put(recs[i].Id,upsertResults[i].getId());
		}

		for (SAP_Ultimate_Parent__c rec:recs) {
			rec.Account__c = acctIdLookup.get(rec.Id); 
		}

		System.debug('*** CreateUltimateParentAccounts recs - ' + recs);
		
		update recs;
	}

	public static void updateUltimateParentAccounts(Map<Id,SAP_Ultimate_Parent__c> recsIn) {
		Id acctRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Ultimate Parent' AND SobjectType = 'Account'].Id;
				
		List<SAP_Ultimate_Parent__c> recs = retrieveSAPUltimateParentRecords(recsIn.keySet());

		// Review recsIn and if Account__c isn't populated, process as insert, else process as update
		Map<Id,SAP_Ultimate_Parent__c> recsToInsert = new Map<Id,SAP_Ultimate_Parent__c>();
		List<Account> acctsToUpdate = new List<Account>();
		
		for (SAP_Ultimate_Parent__c rec:recsIn.values()) {
			if (rec.Account__c == null) {
				recsToInsert.put(rec.Id,rec);	
			}
			else {
				Account acctUpdate = new Account();
				populateAccountFromSAPUltimateParentRec(acctUpdate,rec,acctRecordTypeId,false);
				acctsToUpdate.add(acctUpdate);
			}
		}
		
		//Perform Inserts
		if (recsToInsert.size() > 0) {
			createUltimateParentAccounts(recsToInsert);
		}
		
		//Perform Updates
		if (acctsToUpdate.size() > 0) {
			upsert acctsToUpdate Account_Number__c;
		}
	}

	public static void deleteUltimateParentAccounts(Map<Id,SAP_Ultimate_Parent__c> recsIn) {
		List<SAP_Ultimate_Parent__c> recs = retrieveSAPUltimateParentRecords(recsIn.keySet());
		
		List<Account> acctsToDelete = new List<Account>();
		
		for (SAP_Ultimate_Parent__c rec:recsIn.values()) {
			if (rec.Account__c != null) {
				Account acctToDelete = new Account();
				acctToDelete.Id = rec.Account__c; 
				acctToDelete.OwnerId = SAP_Ultimate_Parent_Settings.defaultSettings().Account_Owner_Id_When_Deleted__c;
				acctsToDelete.add(acctToDelete);
			}
		}

		//Perform Account Deletes (Moving to Different Owner
		if (acctsToDelete.size() > 0) {
			System.debug('*** ' + acctsToDelete);
			update acctsToDelete;
		}
	}

	public static void undeleteUltimateParentAccounts(Map<Id,SAP_Ultimate_Parent__c> recsIn) {
		createUltimateParentAccounts(recsIn);
	}

	private static Account populateAccountFromSAPUltimateParentRec(Account account, SAP_Ultimate_Parent__c rec, Id recordTypeId, Boolean populateId) {
		if (populateId) {
			if (rec.Account__c != null) {account.Id = rec.Account__c;}
		} 
		account.Name = rec.Legal_Ultimate_Parent_Name__c;
		account.AccountNumber = rec.Legal_Ultimate_Parent_Number__c;
		account.SAP_Customer_Number__c = rec.Legal_Ultimate_Parent_Number__c;
		account.RecordTypeId = recordTypeId;
		account.OwnerId = SAP_Ultimate_Parent_Settings.defaultSettings().Account_Owner_Id__c;
		account.Account_Number__c = generateUltimateParentKey(rec.Legal_Ultimate_Parent_Number__c);
		account.Type = 'Ultimate Parent';
		
		return account;
	}

	public static String generateUltimateParentKey(String accountNumber) {
		return accountNumber;
	}

	private static List<SAP_Ultimate_Parent__c> retrieveSAPUltimateParentRecords(Set<Id> recIds) {
		List<SAP_Ultimate_Parent__c> recs = [SELECT Id, 
		                                            Account__c, 
		                                            Date_Added_in_SAP__c, 
		                                            Date_Changed_in_SAP__c, 
		                                            Legal_Ultimate_Parent_Name__c, 
		                                            Legal_Ultimate_Parent_Number__c, 
		                                            User_Who_Added_in_SAP__c, 
		                                            User_Who_Changed_in_SAP__c,
		                                            Account__r.Id,
		                                            Account__r.Name,
		                                            Account__r.AccountNumber,
		                                            Account__r.RecordTypeId,
		                                            Account__r.OwnerId
		                                       FROM SAP_Ultimate_Parent__c
		                                      WHERE Id in :recIds];
		                                      
		return recs;		                                      
	}

}