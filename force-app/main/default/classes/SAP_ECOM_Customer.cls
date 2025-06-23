public with sharing class SAP_ECOM_Customer {

	public static void processSAPECOMCustomer(SAP_ECOM_Customer__c rec) {
		List<SAP_ECOM_Customer__c> recs = new List<SAP_ECOM_Customer__c>();
		recs.add(rec);
		processSAPECOMCustomers(recs);
	}
	
	public static void processSAPECOMCustomers(List<SAP_ECOM_Customer__c> recs) {
		List<SAP_ECOM_Customer__c> ecomCustomers = retrieveFullSAPECOMCustomerRecords(recs);
		List<String> ecomCustomerAccountKeys = buildListofSAPECOMCustomerAccountKeys(ecomCustomers);
		List<Account> accounts = retrieveAccountsForExternalIds(ecomCustomerAccountKeys);
		
		// Refresh Account Lookup Fields on Records
		refreshAccountLookupFields(ecomCustomers,accounts);
		
		// Apply Parenting to Account Records
		applyParentingToAccounts(ecomCustomers,accounts);
	}	

	public static void processDeletedSAPECOMCustomers(List<SAP_ECOM_Customer__c> recs) {
		List<Id> accountIds = buildListofRelatedAccountsIds(recs);
		
		System.debug('*** processDeletedSAPECOMCustomers - recs = ' + recs);
		System.debug('*** processDeletedSAPECOMCustomers - accountIds = ' + accountIds);
		
		processAccounts(accountIds);
	}	

	public static void processAccount(Id recId) {
		List<Id> recIds = ListMethods.newWithData(recId);
		processAccounts(recIds,true);
	}

	public static void processAccounts(List<Id> recIds) {
		processAccounts(recIds,true);
	}

	public static void processAccounts(List<Id> recIds, Boolean performClearProcessing) {
		List<Account> recs = [SELECT Id FROM Account WHERE Id IN :recIds];
		processAccounts(recs,performClearProcessing);
	}

	public static void processAccounts(List<Account> recs) {
		processAccounts(recs,true);
	}
	
	public static void processAccounts(List<Account> recs, Boolean performClearProcessing) {
		List<Id> accountIds = new List<Id>(createAccountMapbyId(recs).keySet());
		
		List<Account> accounts = [SELECT Id,
										 Account_Number__c, 
					                     ParentId, 
					                     RecordTypeId, 
					                     RecordType.Name, 
					                     Related_Bill_To__c, 
					                     Related_Payer__c, 
					                     HQ_Account__c,
					                     Sales_Ultimate_Parent__c,
					                     Legal_Ultimate_Parent__c,
		                                 (SELECT Id FROM SAP_ECOM_Customer_Ship_Tos__r),
		                                 (SELECT Id FROM SAP_ECOM_Customer_Sold_Tos__r),
		                                 (SELECT Id FROM SAP_ECOM_Customer_Bill_Tos__r),
		                                 (SELECT Id FROM SAP_ECOM_Customer_Payers__r),
		                                 (SELECT Id FROM SAP_ECOM_Customer_Hiers__r),
		                                 (SELECT Id FROM SAP_ECOM_Customer_Sales_Ultimate_Parents__r),
		                                 (SELECT Id FROM SAP_ECOM_Customer_Legal_Ultimate_Parents__r)
		                            FROM Account WHERE Id IN :accountIds
		                         ];		
		System.debug('*** processAccounts - accounts.size() = ' + accounts.size());

		Map<Id,Account> accountsToClearMap = new Map<Id,Account>();
		
		Map<Id,SAP_ECOM_Customer__c> ecomCustsToProcessMap = new Map<Id,SAP_ECOM_Customer__c>();
		
		for (Account account:accounts) {
			Map<Id,SAP_ECOM_Customer__c> accountECOMCustRecsToProcessMap = new Map<Id,SAP_ECOM_Customer__c>(); 
			
			for (SAP_ECOM_Customer__c rec:account.SAP_ECOM_Customer_Ship_Tos__r) {accountECOMCustRecsToProcessMap.put(rec.Id,rec);ecomCustsToProcessMap.put(rec.Id,rec);} 
			for (SAP_ECOM_Customer__c rec:account.SAP_ECOM_Customer_Sold_Tos__r) {accountECOMCustRecsToProcessMap.put(rec.Id,rec);ecomCustsToProcessMap.put(rec.Id,rec);} 
			for (SAP_ECOM_Customer__c rec:account.SAP_ECOM_Customer_Bill_Tos__r) {accountECOMCustRecsToProcessMap.put(rec.Id,rec);ecomCustsToProcessMap.put(rec.Id,rec);} 
			for (SAP_ECOM_Customer__c rec:account.SAP_ECOM_Customer_Payers__r) {accountECOMCustRecsToProcessMap.put(rec.Id,rec);ecomCustsToProcessMap.put(rec.Id,rec);} 
			for (SAP_ECOM_Customer__c rec:account.SAP_ECOM_Customer_Hiers__r) {accountECOMCustRecsToProcessMap.put(rec.Id,rec);ecomCustsToProcessMap.put(rec.Id,rec);} 
			for (SAP_ECOM_Customer__c rec:account.SAP_ECOM_Customer_Sales_Ultimate_Parents__r) {accountECOMCustRecsToProcessMap.put(rec.Id,rec);ecomCustsToProcessMap.put(rec.Id,rec);} 
			for (SAP_ECOM_Customer__c rec:account.SAP_ECOM_Customer_Legal_Ultimate_Parents__r) {accountECOMCustRecsToProcessMap.put(rec.Id,rec);ecomCustsToProcessMap.put(rec.Id,rec);} 

			if (accountECOMCustRecsToProcessMap.size() == 0) {
				accountsToClearMap.put(account.Id,account);
			}
			System.debug('*** processAccounts - accountECOMCustRecsToProcessMap.size() = ' + accountECOMCustRecsToProcessMap.size());
		}

		System.debug('*** processAccounts - accountsToClearMap.size() = ' + accountsToClearMap.size());

		List<Account> accountsToClear = new List<Account>();
		
		if (performClearProcessing) {
			for (Account account:accountsToClearMap.values()) {
				Boolean accountUpdated = false;
				accountUpdated |= removeParentRelationship(account);		
				accountUpdated |= clearRelatedBillTo(account);		
				accountUpdated |= clearRelatedPayer(account);		
				accountUpdated |= clearRelatedHier(account);		
				accountUpdated |= clearRelatedSalesUltimateParent(account);		
				accountUpdated |= clearRelatedLegalUltimateParent(account);		
				
				if (accountUpdated) {
					accountsToClear.add(account);
				}
			}

			if (accountsToClear.size() > 0) {
				update accountsToClear;
			}
			
			System.debug('*** processAccounts - accountsToClear.size() = ' + accountsToClear.size());
		}

		System.debug('*** processAccounts - ecomCustsProcessMap.size() = ' + ecomCustsToProcessMap.size());

		if (ecomCustsToProcessMap.size() > 0) {
			processSAPECOMCustomers(ecomCustsToProcessMap.values());
		}
	}
	
    public static Boolean validSAPECOMCustomerRecordforBatchProcessing(SAP_ECOM_Customer__c rec) {
    	Boolean result = false;
    	
    	if (rec.Dist_Channel__c != '40' && rec.Division__c != '40') {result = true;}
    	
    	return result;
    }

	public static Boolean validAccountforBatchProcessing(Account rec) {
		Boolean result = false;
		
		String AccountType = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(rec.recordTypeId);
		
		if (AccountType == 'Customer' && rec.SAP_Dist_Channel_Desc__c != '40' && rec.SAP_DivisionCode__c != '40') {
			result = true;
		}
		
		return result;
	}

	public static String buildKey_SAP_ECOM_Customer(SAP_ECOM_Customer__c record) {return record.Mandt__c + ':' + 
		                                                                                 record.Sap_Company__c + ':' + 
		                                                                                 record.Sales_Org__c + ':' +
                                                                                         record.Dist_Channel__c + ':' +
                                                                                         record.Division__c + ':' +
                                                                                         record.Payer_Account__c + ':' + 
                                                                                         record.Bill_Account__c + ':' + 
                                                                                         record.Sold_Account__c + ':' +
                                                                                         record.Ship_Account__c;
                                                                                  }

	
	
	public static String buildAccountExternalId(String acctNum, String salesOrg, String distChan, String div) {
		return acctNum + salesOrg + distChan + div;
	}

	private static List<SAP_ECOM_Customer__c> retrieveFullSAPECOMCustomerRecords(List<SAP_ECOM_Customer__c> recs) {
		List<SAP_ECOM_Customer__c> results;
		List<Id> ids = new List<Id>();
		for (SAP_ECOM_Customer__c rec:recs) {ids.add(rec.Id);}
		try {
		results = [SELECT Id,
		                  Sales_Org__c,
		                  Dist_Channel__c,
		                  Division__c,
		                  Ship_Account__c, Ship_To__c, Ship_To_Account_Key__c,
		                  Sold_Account__c, Sold_To__c, Sold_To_Account_Key__c,
		                  Bill_Account__c, Bill_To__c, Bill_To_Account_Key__c,
		                  Payer_Account__c, Payer__c, Payer_Account_Key__c,
		                  Hier_Account__c, Hier__c, Hier_Account_Key__c,
		                  Ship_Sup_Number__c, Ship_Sup_Account__c, Ship_Sup_Number_Account_Key__c,
		                  Legal_Parent__c, Legal_Parent_Account__c, Legal_Parent_Account_Key__c
		             FROM SAP_ECOM_Customer__c 
		            WHERE Id in :ids
		              AND Del_Flag__c = ''
		           ];
		} catch (Exception e) {results = new List<SAP_ECOM_Customer__c>();}
		
		return results;
	}

	public static void refreshAccountLookupFields(List<Account> recs) {
		List<Account> accounts = retrieveAccountsForIds(recs);
		List<SAP_ECOM_Customer__c> ecomCusts = retrieveEcomCustomersforAccounts(accounts);
		refreshAccountLookupFields(ecomCusts);
	}

	public static List<SAP_ECOM_Customer__c> retrieveEcomCustomersforAccounts(List<Account> recs) {
		List<SAP_ECOM_Customer__c> results = new List<SAP_ECOM_Customer__c>();
		Map<String,Account> accountExternalIdsMap = createAccountMapbyExternalId(recs);
		List<String> accountExternalKeys = new List<String>(accountExternalIdsMap.keySet());
		
		results = [SELECT Id
		             FROM SAP_ECOM_Customer__c
		            WHERE Del_Flag__c = ''
		              AND (
		                      Ship_To_Account_Key__c in :accountExternalKeys
		                   OR Sold_To_Account_Key__c in :accountExternalKeys
		                   OR Bill_To_Account_Key__c in :accountExternalKeys
		                   OR Payer_Account_Key__c in :accountExternalKeys
		                   OR Ship_Sup_Number_Account_Key__c in :accountExternalKeys
		                   OR Legal_Parent_Account_Key__c in :accountExternalKeys
		                  )
		          ];
		
		return results;
	}

	public static void refreshAccountLookupFields(List<SAP_ECOM_Customer__c> recs) {
		List<SAP_ECOM_Customer__c> ecomCustomers = retrieveFullSAPECOMCustomerRecords(recs);
		List<String> ecomCustomerAccountKeys = buildListofSAPECOMCustomerAccountKeys(ecomCustomers);
		List<Account> accounts = retrieveAccountsForExternalIds(ecomCustomerAccountKeys);
		
		// Refresh Account Lookup Fields on Records
		refreshAccountLookupFields(ecomCustomers,accounts);
	}
	
	public static void refreshAccountLookupFields(List<SAP_ECOM_Customer__c> recs, List<Account> accounts) {
		Map<String,Account> accountMap = createAccountMapbyExternalId(accounts);
    	List<SAP_ECOM_Customer__c> recsToUpdate = new List<SAP_ECOM_Customer__c>();
		
		for (SAP_ECOM_Customer__c rec:recs) {
			String shipToKey = rec.Ship_To_Account_Key__c;
			String soldToKey = rec.Sold_To_Account_Key__c;
			String billToKey = rec.Bill_To_Account_Key__c;
			String payerKey = rec.Payer_Account_Key__c;
			String hierKey = rec.Hier_Account_Key__c;
			String salesUltimateParentKey = rec.Ship_Sup_Number_Account_Key__c;
			String legalUltimateParentKey = rec.Legal_Parent_Account_Key__c;
//			String billToKey = buildAccountExternalId(rec.Bill_Account__c,rec.Sales_Org__c,rec.Dist_Channel__c,rec.Division__c);
//			String hierKey = buildAccountExternalId(rec.Hier_Account__c,rec.Sales_Org__c,rec.Dist_Channel__c,rec.Division__c);
//			String payerKey = buildAccountExternalId(rec.Payer_Account__c,rec.Sales_Org__c,rec.Dist_Channel__c,rec.Division__c);
//			String shipToKey = buildAccountExternalId(rec.Ship_Account__c,rec.Sales_Org__c,rec.Dist_Channel__c,rec.Division__c);
//			String soldToKey = buildAccountExternalId(rec.Sold_Account__c,rec.Sales_Org__c,rec.Dist_Channel__c,rec.Division__c);
//			String salesUltimateParentKey = SAP_Ultimate_Parent.generateUltimateParentKey(rec.Ship_Sup_Number__c);
//			String legalUltimateParentKey = SAP_Ultimate_Parent.generateUltimateParentKey(rec.Legal_Parent__c);
			
			Boolean updateRec = false;
			
			Account billToAccount = accountMap.get(billToKey);
			if (billToAccount != null) {
				if (rec.Bill_To__c != billToAccount.Id) {rec.Bill_To__c = billToAccount.Id;updateRec = true;}
			}
			else {
				if (rec.Bill_To__c != null) {rec.Bill_To__c = null;updateRec = true;}
			}

			Account hierAccount = accountMap.get(hierKey);
			if (hierAccount != null) {
				if (rec.Hier__c != hierAccount.Id) {rec.Hier__c = hierAccount.Id;updateRec = true;}
			}
			else {
				if (rec.Hier__c != null) {rec.Hier__c = null;updateRec = true;}
			}

			Account payerAccount = accountMap.get(payerKey);
			if (payerAccount != null) {
				if (rec.Payer__c != payerAccount.Id) {rec.Payer__c = payerAccount.Id;updateRec = true;}
			}
			else {
				if (rec.Payer__c != null) {rec.Payer__c = null;updateRec = true;}
			}

			Account shipToAccount = accountMap.get(shipToKey);
			if (shipToAccount != null) {
				if (rec.Ship_To__c != shipToAccount.Id) {rec.Ship_To__c = shipToAccount.Id;updateRec = true;}
			}
			else {
				if (rec.Ship_To__c != null) {rec.Ship_To__c = null;updateRec = true;}
			}

			Account soldToAccount = accountMap.get(soldToKey);
			if (soldToAccount != null) {
				if (rec.Sold_To__c != soldToAccount.Id) {rec.Sold_To__c = soldToAccount.Id;updateRec = true;}
			}
			else {
				if (rec.Sold_To__c != null) {rec.Sold_To__c = null;updateRec = true;}
			}

			Account salesUltimateParentAccount = accountMap.get(salesUltimateParentKey);
			if (salesUltimateParentAccount != null) {
				if (rec.Ship_Sup_Account__c != salesUltimateParentAccount.Id) {rec.Ship_Sup_Account__c = salesUltimateParentAccount.Id;updateRec = true;}
			}
			else {
				if (rec.Ship_Sup_Account__c != null) {rec.Ship_Sup_Account__c = null;updateRec = true;}
			}
			
			Account legalUltimateParentAccount = accountMap.get(legalUltimateParentKey);
			if (legalUltimateParentAccount != null) {
				if (rec.Legal_Parent_Account__c != legalUltimateParentAccount.Id) {rec.Legal_Parent_Account__c = legalUltimateParentAccount.Id;updateRec = true;}
			}
			else {
				if (rec.Legal_Parent_Account__c != null) {rec.Legal_Parent_Account__c = null;updateRec = true;}
			}
			
			if (updateRec) {recsToUpdate.add(rec);}
		}		
		
		update recsToUpdate;
	} 
	
	private static List<String> buildListofSAPECOMCustomerAccountKeys(List<SAP_ECOM_Customer__c> recs) {
		return buildListofSAPECOMCustomerAccountKeys(recs,true,true,true,true,true,true,true);
	}
	
	private static List<String> buildListofSAPECOMCustomerAccountKeys(List<SAP_ECOM_Customer__c> recs,
		                                                              Boolean includeShipTos,
		                                                              Boolean includeSoldTos,
		                                                              Boolean includeBillTos,
		                                                              Boolean includePayers,
		                                                              Boolean includeHiers,
		                                                              Boolean includeSalesUltimateParents,
		                                                              Boolean includeLegalUltimateParents
	                                                                  ) {
		List<String> accountKeys = new List<String>();
		
		for (SAP_ECOM_Customer__c rec:recs) {
			
			String shipToKey = rec.Ship_To_Account_Key__c;
			String soldToKey = rec.Sold_To_Account_Key__c;
			String billToKey = rec.Bill_To_Account_Key__c;
			String payerKey = rec.Payer_Account_Key__c;
			String hierKey = rec.Hier_Account_Key__c;
			String salesUltimateParentKey = rec.Ship_Sup_Number_Account_Key__c;
			String legalUltimateParentKey = rec.Legal_Parent_Account_Key__c;
			
			if (includeShipTos && String.isNotEmpty(shipToKey)) {accountKeys.add(shipToKey);}
			if (includeSoldTos && String.isNotEmpty(soldToKey)) {accountKeys.add(soldToKey);}
			if (includeBillTos && String.isNotEmpty(billToKey)) {accountKeys.add(billToKey);}
			if (includePayers && String.isNotEmpty(payerKey)) {accountKeys.add(payerKey);}
			if (includeHiers && String.isNotEmpty(hierKey)) {accountKeys.add(hierKey);}
			if (includeSalesUltimateParents && String.isNotEmpty(salesUltimateParentKey)) {accountKeys.add(salesUltimateParentKey);}
			if (includeLegalUltimateParents && String.isNotEmpty(legalUltimateParentKey)) {accountKeys.add(legalUltimateParentKey);}
		}

		return accountKeys;		
	}

	private static List<Id> buildListofRelatedAccountsIds(List<SAP_ECOM_Customer__c> recs) {
		return buildListofRelatedAccountsIds(recs,true,true,true,true,true,true,true);
	}

	private static List<Id> buildListofRelatedAccountsIds(List<SAP_ECOM_Customer__c> recs,
		                                                              Boolean includeShipTos,
		                                                              Boolean includeSoldTos,
		                                                              Boolean includeBillTos,
		                                                              Boolean includePayers,
		                                                              Boolean includeHiers,
		                                                              Boolean includeSalesUltimateParents,
		                                                              Boolean includeLegalUltimateParents) {
		List<String> ids = new List<String>();
		
		for (SAP_ECOM_Customer__c rec:recs) {
			if (includeShipTos && rec.Ship_To__c != null) {ids.add(rec.Ship_To__c);}
			if (includeSoldTos && rec.Sold_To__c != null) {ids.add(rec.Sold_To__c);}
			if (includeBillTos && rec.Bill_To__c != null) {ids.add(rec.Bill_To__c);}
			if (includePayers && rec.Payer__c != null) {ids.add(rec.Payer__c);}
			if (includeHiers && rec.Hier__c != null) {ids.add(rec.Hier__c);}
			if (includeSalesUltimateParents && rec.Ship_Sup_Account__c != null) {ids.add(rec.Ship_Sup_Account__c);}
			if (includeLegalUltimateParents && rec.Legal_Parent_Account__c != null) {ids.add(rec.Legal_Parent_Account__c);}
		}

		return ids;		
	}


		
	private static List<Account> retrieveAccountsForExternalIds(List<String> externalIds) {
		List<Account> accounts = new List<Account>();
		
		accounts = [SELECT Id, 
		                   Account_Number__c, 
		                   ParentId, 
		                   RecordTypeId, 
		                   RecordType.Name, 
		                   Related_Bill_To__c, 
		                   Related_Payer__c, 
		                   HQ_Account__c,
		                   Sales_Ultimate_Parent__c,
		                   Legal_Ultimate_Parent__c
                      FROM Account 
                     WHERE Account_Number__c IN :externalIds
                   ];
		                         
		return accounts;		                         
	}
	
	private static List<Account> retrieveAccountsForIds(List<Account> recs) {
		Map<Id,Account> idMap = new Map<Id,Account>(recs);
		List<Id> ids = new List<Id>(idMap.keySet());
		return retrieveAccountsForIds(ids); 
	}
	
	private static List<Account> retrieveAccountsForIds(List<Id> ids) {
		List<Account> accounts = new List<Account>();
		
		accounts = [SELECT Id, 
		                   Account_Number__c, 
		                   ParentId, 
		                   RecordTypeId, 
		                   RecordType.Name, 
		                   Related_Bill_To__c, 
		                   Related_Payer__c, 
		                   HQ_Account__c,
		                   Sales_Ultimate_Parent__c,
		                   Legal_Ultimate_Parent__c
                      FROM Account 
                     WHERE Id IN :ids
                   ];
		                         
		return accounts;		                         
	}
	
	private static Map<String,Account> createAccountMapbyExternalId(List<Account> accounts) {
		Map<String,Account> accountMap = new Map<String,Account>();
		for (Account account:accounts) {accountMap.put(account.Account_Number__c,account);}
		return accountMap;
	}
	
	private static Map<Id,Account> createAccountMapbyId(List<Account> accounts) {
		Map<Id,Account> accountMap = new Map<Id,Account>();
		for (Account account:accounts) {accountMap.put(account.Id,account);}
		return accountMap;
	}
	

    public static void applyParentingToAccounts(List<SAP_ECOM_Customer__c> recs, List<Account> accounts) {
    	Map<Id,Account> accountMap = createAccountMapbyId(accounts);
    	Map<Id,Account> accountsToUpdateMap = new Map<Id,Account>();
    	List<Account> accountsToUpdate = new List<Account>();
    	
    	for (SAP_ECOM_Customer__c rec:recs) {
			Account shipTo = accountMap.get(rec.Ship_To__c);
			Account soldTo = accountMap.get(rec.Sold_To__c);
			Account billTo = accountMap.get(rec.Bill_To__c);
			Account payer = accountMap.get(rec.Payer__c);
			Account hier = accountMap.get(rec.Hier__c);
			Account salesUltimateParent = accountMap.get(rec.Ship_Sup_Account__c);
			Account legalUltimateParent = accountMap.get(rec.Legal_Parent_Account__c);

			Boolean shipToExists = (shipTo != null);
			Boolean soldToExists = (soldTo != null);
			Boolean billToExists = (billTo != null);
			Boolean payerExists = (payer != null);
			Boolean hierExists = (hier != null);
			Boolean salesUltimateParentExists = (salesUltimateParent != null);
			Boolean legalUltimateParentExists = (legalUltimateParent != null);
			
			Boolean shipToUpdated = false;
			Boolean soldToUpdated = false;
			Boolean billToUpdated = false;
			Boolean payerUpdated = false;
			Boolean hierUpdated = false;
			Boolean salesUltimateParentUpdated = false;
			Boolean legalUltimateParentUpdated = false;
			
			// Relate Ship To --> Sold To --> Sales Ultimate Parent
			
			// NOTE: x |= y --> OR assignment operator (Right associative). 
			//       If x, a Boolean, and y, a Boolean, are both false, then x remains false. 
			//       Otherwise, x is assigned the value of true
			
			//Set the logic up this way to be more readable.  Only 1 If statement will get executed
			
			//000
			if (!salesUltimateParentExists && !soldToExists && !shipToExists) {
				// Do Nothing							
			}
			
			//001
			if (!salesUltimateParentExists && !soldToExists && shipToExists) {
				// Clear Ship To Parent
				shipToUpdated |= removeParentRelationship(shipTo);		
			}
			
			//010
			if (!salesUltimateParentExists && soldToExists && !shipToExists) {
				// Clear Sold To Parent
				soldToUpdated |= removeParentRelationship(soldTo);		
			}
			
			//011
			if (!salesUltimateParentExists && soldToExists && shipToExists) {
				// Relate Ship To to Sold To	
				shipToUpdated |= relateChildToParent(shipTo,soldTo);		

				// Clear Sold To Parent
				soldToUpdated |= removeParentRelationship(soldTo);		
			}
			
			//100
			if (salesUltimateParentExists && !soldToExists && !shipToExists) {
				// Do Nothing			
			}
			
			//101
			if (salesUltimateParentExists && !soldToExists && shipToExists) {
				// Relate Ship To to Ultimate Parent
				shipToUpdated |= relateChildToParent(shipTo,salesUltimateParent);			
			}
			
			//110
			if (salesUltimateParentExists && soldToExists && !shipToExists) {
				// Relate Sold To to Ultimate Parent		
				soldToUpdated |= relateChildToParent(soldTo,salesUltimateParent);	
			}
			
			//111
			if (salesUltimateParentExists && soldToExists && shipToExists) {
				// Relate Ship To to Sold To
				shipToUpdated |= relateChildToParent(shipTo,soldTo);
				
				// Relate Sold To to Ultimate Parent
				soldToUpdated |= relateChildToParent(soldTo,salesUltimateParent);			
			}


			// Apply Bill To, Payer, and Hier to Ship To
			if (shipToExists) {
				if (billToExists) {shipToUpdated |= relateBillTo(shipTo, billTo);} else {shipToUpdated |= clearRelatedBillTo(shipTo);}
				if (payerExists) {shipToUpdated |= relatePayer(shipTo, payer);} else {shipToUpdated |= clearRelatedPayer(shipTo);}
				if (hierExists) {shipToUpdated |= relateHier(shipTo, hier);} else {shipToUpdated |= clearRelatedHier(shipTo);}
				if (salesUltimateParentExists) {shipToUpdated |= relateSalesUltimateParent(shipTo, salesUltimateParent);} else {shipToUpdated |= clearRelatedSalesUltimateParent(shipTo);}
				if (legalUltimateParentExists) {shipToUpdated |= relateLegalUltimateParent(shipTo, legalUltimateParent);} else {shipToUpdated |= clearRelatedLegalUltimateParent(shipTo);}
			}			
			
			// Apply Hier to Sold To
			if (soldToExists) {
				if (hierExists) {soldToUpdated |= relateHier(soldTo, hier);} else {soldToUpdated |= clearRelatedHier(soldTo);}
				if (salesUltimateParentExists) {soldToUpdated |= relateSalesUltimateParent(soldTo, salesUltimateParent);} else {soldToUpdated |= clearRelatedSalesUltimateParent(soldTo);}
				if (legalUltimateParentExists) {soldToUpdated |= relateLegalUltimateParent(soldTo, legalUltimateParent);} else {soldToUpdated |= clearRelatedLegalUltimateParent(soldTo);}
			}

			// Apply Ultimate Parent to Bill To
			if (billToExists) {
				//Temp to clean up logic change - JHK 2013-03-13
				//billToUpdated |= removeParentRelationship(billTo);
					
				if (salesUltimateParentExists) {
					//billToUpdated |= relateChildToParent(billTo,salesUltimateParent);
					billToUpdated |= relateSalesUltimateParent(billTo, salesUltimateParent);
				}
				else {
					//billToUpdated |= removeParentRelationship(billTo);
					billToUpdated |= clearRelatedSalesUltimateParent(billTo);
				}
				if (legalUltimateParentExists) {
					billToUpdated |= relateLegalUltimateParent(billTo, legalUltimateParent);
				}
				else {
					billToUpdated |= clearRelatedLegalUltimateParent(billTo);
				}
			}
				
			// Apply Ultimate Parent to Payer
				//Temp to clean up logic change - JHK 2013-03-13
				//payerUpdated |= removeParentRelationship(payer);
			
			if (payerExists) {
				if (salesUltimateParentExists) {
					//payerUpdated |= relateChildToParent(payer, salesUltimateParent);
					payerUpdated |= relateSalesUltimateParent(payer, salesUltimateParent);
				}
				else {
					//payerUpdated |= removeParentRelationship(payer);
					payerUpdated |= clearRelatedSalesUltimateParent(payer);
				}
				if (legalUltimateParentExists) {
					payerUpdated |= relateLegalUltimateParent(payer, legalUltimateParent);
				}
				else {
					payerUpdated |= clearRelatedLegalUltimateParent(payer);
				}
			}
			
			
			// Apply Ultimate Parent to Hier
			if (hierExists) {
				if (salesUltimateParentExists) {
					hierUpdated |= relateChildToParent(hier, salesUltimateParent);
					hierUpdated |= relateSalesUltimateParent(hier, salesUltimateParent);
				}
				else {
					hierUpdated |= removeParentRelationship(hier);
					hierUpdated |= clearRelatedSalesUltimateParent(hier);
				}
				if (legalUltimateParentExists) {
					hierUpdated |= relateLegalUltimateParent(hier, legalUltimateParent);
				}
				else {
					hierUpdated |= clearRelatedLegalUltimateParent(hier);
				}
			}



			if (shipToUpdated) {accountsToUpdateMap.put(shipTo.Id,shipTo);}
			if (soldToUpdated) {accountsToUpdateMap.put(soldTo.Id,soldTo);}
			if (billToUpdated) {accountsToUpdateMap.put(billTo.Id,billTo);}
			if (payerUpdated) {accountsToUpdateMap.put(payer.Id,payer);}
			if (hierUpdated) {accountsToUpdateMap.put(hier.Id,hier);}
			if (salesUltimateParentUpdated) {accountsToUpdateMap.put(salesUltimateParent.Id,salesUltimateParent);}
			if (legalUltimateParentUpdated) {accountsToUpdateMap.put(legalUltimateParent.Id,legalUltimateParent);}
    	}

		accountsToUpdate = new List<Account>(accountsToUpdateMap.values());
    	
    	
    	if (accountsToUpdate.size() > 0) {
    		try {
    			update accountsToUpdate;
    		}
    		catch (Exception e) {
    			// This can error once in a while, due to 'UNABLE_TO_LOCK_ROW, unable to obtain exclusive access to this record'
    			// When this happens, don't error and let it process correctly in the next hourly run
    		}
    	}
    }

	private static Boolean relateChildToParent(Account child, Account parent) {
		Boolean updated = false;
		
		if (!sameAccount(child,parent)) {
			if (child.parentId != parent.Id) {
				child.parentId = parent.Id;
				updated = true;
			}
		}
		else {
			updated |= removeParentRelationship(child);
		}
		
		return updated;
	}

	private static Boolean removeParentRelationship(Account account) {
		Boolean updated = false;
		
		if (account.ParentId != null) {
			account.ParentId = null;
			updated = true;
		}
		
		return updated;
	}

	private static Boolean relateBillTo(Account account,Account billToAccount) {
		Boolean updated = false;

		if (!sameAccount(account,billToAccount)) {
			if (account.Related_Bill_To__c != billToAccount.Id) {
				account.Related_Bill_To__c = billToAccount.Id;
				updated = true;
			}
		}
		else {
			updated |= clearRelatedBillTo(account);
		}
		
		return updated;
	}

	private static Boolean clearRelatedBillTo(Account account) {
		Boolean updated = false;
		
		if (account.Related_Bill_To__c != null) {
			account.Related_Bill_To__c = null;
			updated = true;
		}
		
		return updated;
	}

	private static Boolean relatePayer(Account account,Account payerAccount) {
		Boolean updated = false;

		if (!sameAccount(account,payerAccount)) {
			if (account.Related_Payer__c != payerAccount.Id) {
				account.Related_Payer__c = payerAccount.Id;
				updated = true;
			}
		}
		else {
			updated |= clearRelatedPayer(account);
		}
		
		return updated;
	}

	private static Boolean clearRelatedPayer(Account account) {
		Boolean updated = false;
		
		if (account.Related_Payer__c != null) {
			account.Related_Payer__c = null;
			updated = true;
		}
		
		return updated;
	}

	private static Boolean relateHier(Account account,Account hierAccount) {
		Boolean updated = false;

		if (!sameAccount(account,hierAccount)) {
			if (account.HQ_Account__c != hierAccount.Id) {
				account.HQ_Account__c = hierAccount.Id;
				updated = true;
			}
		}
		else {
			updated |= clearRelatedHier(account);
		}
		
		return updated;
	}

	private static Boolean clearRelatedHier(Account account) {
		Boolean updated = false;
		
		if (account.HQ_Account__c != null) {
			account.HQ_Account__c = null;
			updated = true;
		}
		
		return updated;
	}

	private static Boolean relateSalesUltimateParent(Account account,Account salesUltimateParentAccount) {
		Boolean updated = false;

		if (!sameAccount(account,salesUltimateParentAccount)) {
			if (account.Sales_Ultimate_Parent__c != salesUltimateParentAccount.Id) {
				account.Sales_Ultimate_Parent__c = salesUltimateParentAccount.Id;
				updated = true;
			}
		}
		else {
			updated |= clearRelatedSalesUltimateParent(account);
		}
		
		return updated;
	}

	private static Boolean clearRelatedSalesUltimateParent(Account account) {
		Boolean updated = false;
		
		if (account.Sales_Ultimate_Parent__c != null) {
			account.Sales_Ultimate_Parent__c = null;
			updated = true;
		}
		
		return updated;
	}

	private static Boolean relateLegalUltimateParent(Account account,Account legalUltimateParentAccount) {
		Boolean updated = false;

		if (!sameAccount(account,legalUltimateParentAccount)) {
			if (account.Legal_Ultimate_Parent__c != legalUltimateParentAccount.Id) {
				account.Legal_Ultimate_Parent__c = legalUltimateParentAccount.Id;
				updated = true;
			}
		}
		else {
			updated |= clearRelatedLegalUltimateParent(account);
		}
		
		return updated;
	}

	private static Boolean clearRelatedLegalUltimateParent(Account account) {
		Boolean updated = false;
		
		if (account.Legal_Ultimate_Parent__c != null) {
			account.Legal_Ultimate_Parent__c = null;
			updated = true;
		}
		
		return updated;
	}


	private static Boolean sameAccount(Account acct1, Account acct2) {
		Boolean same = false;
		if (acct1.Id == acct2.Id) {same = true;}
		return same;
	}
}