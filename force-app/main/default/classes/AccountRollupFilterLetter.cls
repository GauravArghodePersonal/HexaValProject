public with sharing class AccountRollupFilterLetter {
	
	public AccountRollupFilterLetter(String filterLabel,String filterValue) {
		this.filterLabel = filterLabel;
		this.filterValue = filterValue;
	}
	
	public String filterLabel{get; set;}
	public String filterValue{get; set;}
}