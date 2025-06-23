public with sharing class MarketPriceBookStats {
	public Map<Id,Market_Price_Book_Entry__c> marketPriceBookEntries {get; set;} 
	public Map<Id,Account_To_Market_Price_Book_Entry__c> accountToMarketPriceBookEntries {get; set;} 
	public Map<Id,Pricing_Condition__c> activePricingConditions {get; set;}
	public Map<Id,Pricing_Condition__c> draftPricingConditions {get; set;}
	public Map<Id,Pricing_Condition__c> approvedNotYetActivePricingConditions {get; set;}
	public Map<Id,Pricing_Condition__c> inApprovalProcessPricingConditions {get; set;}
	
	public MarketPriceBookStats(Id mpbId) {
		marketPriceBookEntries = new Map<Id,Market_Price_Book_Entry__c>(MarketPriceBookExpirationMethods.retrieveRelatedMarketPriceBookEntries(mpbId));
		
		List<Id> mpbeIds = new List<Id>(marketPriceBookEntries.keySet());
		 
		accountToMarketPriceBookEntries = new Map<Id,Account_To_Market_Price_Book_Entry__c>(MarketPriceBookExpirationMethods.retrieveRelatedAccountToMarketPriceBookEntryRecords(mpbeIds));
		activePricingConditions = new Map<Id,Pricing_Condition__c>(MarketPriceBookExpirationMethods.retrieveRelatedPricingConditionRecords(mpbeIds,'Active'));
		draftPricingConditions = new Map<Id,Pricing_Condition__c>(MarketPriceBookExpirationMethods.retrieveRelatedPricingConditionRecords(mpbeIds,'Draft'));
		List<String> statuses = new List<String>();
		statuses.add('Approved, Not Yet Active');
		statuses.add('Not Active Yet');
		approvedNotYetActivePricingConditions = new Map<Id,Pricing_Condition__c>(MarketPriceBookExpirationMethods.retrieveRelatedPricingConditionRecords(mpbeIds,statuses));
		inApprovalProcessPricingConditions = new Map<Id,Pricing_Condition__c>(MarketPriceBookExpirationMethods.retrieveRelatedPricingConditionRecords(mpbeIds,'In Approval Process'));
	}
}