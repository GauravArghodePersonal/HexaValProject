public with sharing class MergeboardAccountItem {
	
	public Boolean selected {get;set;}
	public Mergeboard_Account_Item__c sourceRec {get;set;}
	
	public Id mergeboardAccountItemId {get;set;}
	public Id accountId {get;set;}
	public String name {get;set;}
	public String accountNumber {get;set;}
	public Id ownerId {get;set;}
	public String ownerName {get;set;}
	public String accountType {get;set;}
	public String recordTypeName {get;set;}
	public String salesArea {get;set;}
	public String stateCityCountry {get;set;}
	
	
	
	public MergeboardAccountItem() {
		selected = false;
	}
}