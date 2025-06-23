public without sharing class MarketPriceBookExpirationMethods {

	public static final Integer DEFAULT_LIMIT = 250;

    public static List<Market_Price_Book_Entry__c> retrieveRelatedMarketPriceBookEntries(Id mpbId) {return retrieveRelatedMarketPriceBookEntries(mpbId,DEFAULT_LIMIT);}
    public static List<Market_Price_Book_Entry__c> retrieveRelatedMarketPriceBookEntries(Id mpbId, Integer recLimit) {
    	List<Market_Price_Book_Entry__c> results;
    	
    	try {
    		results = [SELECT Id,
    		                  Name,
    		                  Material_Sales_Data2__r.Material_Number__c, 
    		                  Material_Sales_Data2__r.Material_Number_Trimmed__c, 
    		                  Material_Sales_Data2__r.Material_Desc__c 
    		             FROM Market_Price_Book_Entry__c 
    		            WHERE Market_Price_Book__c = :mpbId 
    		            LIMIT :recLimit];
    	}
    	catch(Exception e) {results = new List<Market_Price_Book_Entry__c>();}
    	
    	return results;
    }
 
    public static List<Account_To_Market_Price_Book_Entry__c> retrieveRelatedAccountToMarketPriceBookEntryRecords(List<Id> mpbeIds) {
    	return retrieveRelatedAccountToMarketPriceBookEntryRecords(mpbeIds,DEFAULT_LIMIT);
    }
    public static List<Account_To_Market_Price_Book_Entry__c> retrieveRelatedAccountToMarketPriceBookEntryRecords(List<Id> mpbeIds, Integer recLimit) {
    	List<Account_To_Market_Price_Book_Entry__c> results;
    	
    	try {
    		results = [SELECT Id,
    		                  Name,
    		                  Account__r.Id,
    		                  Account__r.Name,
    		                  Account__r.OwnerId,
    		                  Account__r.Owner.Name,
    		                  Market_Price_Book_Entry__r.Id,
    		                  Market_Price_Book_Entry__r.Name,
    		                  Market_Price_Book_Entry__r.Material_Sales_Data2__r.Material_Number__c,
    		                  Market_Price_Book_Entry__r.Material_Sales_Data2__r.Material_Number_Trimmed__c,
    		                  Market_Price_Book_Entry__r.Material_Sales_Data2__r.Material_Desc__c
    		             FROM Account_To_Market_Price_Book_Entry__c 
    		            WHERE Market_Price_Book_Entry__c IN :mpbeIds 
    		            LIMIT :recLimit];
    	}
    	catch(Exception e) {results = new List<Account_To_Market_Price_Book_Entry__c>();}
    	
    	return results;
    }

    public static List<Pricing_Condition__c> retrieveRelatedPricingConditionRecords(List<Id> mpbeIds, String status) {return retrieveRelatedPricingConditionRecords(mpbeIds, status, DEFAULT_LIMIT);}
    public static List<Pricing_Condition__c> retrieveRelatedPricingConditionRecords(List<Id> mpbeIds, String status, Integer recLimit) {return retrieveRelatedPricingConditionRecords(mpbeIds,ListMethods.newWithData(status),recLimit);}
    public static List<Pricing_Condition__c> retrieveRelatedPricingConditionRecords(List<Id> mpbeIds, List<String> statuses) {return retrieveRelatedPricingConditionRecords(mpbeIds,statuses,DEFAULT_LIMIT);}
    public static List<Pricing_Condition__c> retrieveRelatedPricingConditionRecords(List<Id> mpbeIds, List<String> statuses, Integer recLimit) {
    	List<Pricing_Condition__c> results;
    	
    	try {
    		results = [SELECT Id,
    		                  Name,
    		                  Account__r.Id,
    		                  Account__r.Name,
    		                  Account__r.OwnerId,
    		                  Account__r.Owner.Name,
    		                  Material2__r.Material_Number__c, 
    		                  Material2__r.Material_Number_Trimmed__c, 
    		                  Material2__r.Material_Desc__c 
    		             FROM Pricing_Condition__c 
    		            WHERE Market_Price_Book_Entry__c IN :mpbeIds
    		              AND Record_Status__c IN :statuses
    		            LIMIT :recLimit];
    		 
    	}
    	catch(Exception e) {results = new List<Pricing_Condition__c>();}
    	
    	return results;
    }
}