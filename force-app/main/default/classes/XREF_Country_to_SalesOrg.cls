public with sharing class XREF_Country_to_SalesOrg {

	public static List<String> availableSalesOrgsForCountry(String countryCode) {
		List<String> results = new List<String>();
		
		Set<String> uniqueSalesOrgs = new Set<String>();
		
		List<XREF_Country_to_SalesOrg__c> xrefs = [SELECT Sales_Org__c FROM XREF_Country_to_SalesOrg__c WHERE Cust_ShipTo_Country_Code__c = :countryCode];
		
		for (XREF_Country_to_SalesOrg__c xref : xrefs) {
			uniqueSalesOrgs.add(xref.Sales_Org__c);
		}
		
		results = new List<String>(uniqueSalesOrgs);
		
		return results;
	}

}