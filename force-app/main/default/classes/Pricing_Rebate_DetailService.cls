public with sharing class Pricing_Rebate_DetailService {
	
	private static Map<Id, Pricing_Rebate__c> getPricingRebateMap(Pricing_Rebate_Detail__c[] newPRDs) {
		//Populate set of PR IDs
		Set<Id> prIds = new Set<Id>();
		for(Pricing_Rebate_Detail__c prd : newPRDs)
			prIds.add(prd.Pricing_Rebate__c);
		//Retrieve PRs for incomring PRDs that were cloned from another PR
		Map<Id, Pricing_Rebate__c> prMap = new Map<Id, Pricing_Rebate__c>([select Id
				from Pricing_Rebate__c
				where Cloned_from_Pricing_Rebate__c != null
				and Id in :prIds]);
		return prMap;
	}
	
	public static void processBeforeUpsert(Pricing_Rebate_Detail__c[] newPRDs, 
	                                       Map<Id, Pricing_Rebate_Detail__c> oldPRDsMap) {
		Map<Id, Pricing_Rebate__c> prMap = getPricingRebateMap(newPRDs);
		//Get PRDs to update and set Change Tracker field, only ones where related PR is in PR map (i.e. PR was cloned)
		Pricing_Rebate_Detail__c[] prdsToUpdate = new Pricing_Rebate_Detail__c[]{};
		for(Pricing_Rebate_Detail__c newPRD : newPRDs) {
			newPRD.Key__c = newPRD.Account__c + ':' + newPRD.Material_Sales_Data2__c;
			if(prMap.containsKey(newPRD.Pricing_Rebate__c)) {
				//If Approved Rebate is checked, the set Change Tracker to changed, otherwise New
				if(newPRD.Approved_Rebate__c) {
					//If oldPRDsMap is null then it's an insert, don't do anything
					if(oldPRDsMap != null && !oldPRDsMap.isEmpty())	{
						//Only change field if any of the values below changed
						Pricing_Rebate_Detail__c oldPRD = oldPRDsMap.get(newPRD.Id);
						if(oldPRD.Amount__c != newPRD.Amount__c
								|| oldPRD.Unit__c != newPRD.Unit__c
								|| oldPRD.Per__c != newPRD.Per__c
								|| oldPRD.UoM__c != newPRD.UoM__c
								|| oldPRD.Accrual__c != newPRD.Accrual__c
								|| oldPRD.MFD__c != newPRD.MFD__c)
							newPRD.Change_Tracker__c = 'Changed';
					}
				}
				else
					newPRD.Change_Tracker__c = 'New';
			}
		}
	}
}