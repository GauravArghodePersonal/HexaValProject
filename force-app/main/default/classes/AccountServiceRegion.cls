public with sharing class AccountServiceRegion {
    //Sumeet:[2016-03-22] For setting service region
     public static void processBeforeInsert(List<Account> alist) {
     	setServiceRegion(alist);
    }
    public static void setServiceRegion(List<Account> alist)
    {
    	List<ESR_Region_Map__c> serviceRegionList=[select Name,Region__c From ESR_Region_Map__c];
     	Map<String,String> esrMap=new Map<String,String>();
       	for(ESR_Region_Map__c esr:serviceRegionList)
       		esrMap.put(esr.Name,esr.Region__c);
       	for(Account acc:aList)
       	{
       		if(esrMap.containsKey(acc.BillingState))
       			acc.Service_Region__c=esrMap.get(acc.BillingState);
       		else if(esrMap.containsKey(acc.BillingCountry))
       			acc.Service_Region__c=esrMap.get(acc.BillingCountry);	
       			
       	}
    }
}