global without sharing class WebMethodsInterface {

	//----------------------------------
	// Ashland Web Site Leads Interface
	//----------------------------------
	
    webservice static AshlandWebSiteLeadInsertResults createAshlandWebSiteLead(Lead newLead) {
  	    return Lead_Functions.createAshlandWebSiteLead(newLead);
    }

	//----------------------------------    
    // Ultimate Parent zTable Interface
	//----------------------------------    
    
    /* Upsert Into SAP_Ultimate_Parent__c Table */
 	webservice static WebMethodsInterfaceResult upsertSAPUltimateParent(SAP_Ultimate_Parent__c record) {
 		List<SAP_Ultimate_Parent__c> records = new List<SAP_Ultimate_Parent__c>();
 		records.add(record);
 		List<WebMethodsInterfaceResult> results = upsertSAPUltimateParents(records);
 		if (results.size() > 0) {return results[0];} else {return null;}
 	}
 
 	webservice static List<WebMethodsInterfaceResult> upsertSAPUltimateParents(List<SAP_Ultimate_Parent__c> records) {
 		List<WebMethodsInterfaceResult> results = new List<WebMethodsInterfaceResult>();
 		Schema.SObjectField keyField = SAP_Ultimate_Parent__c.Fields.Legal_Ultimate_Parent_Number__c;
 		List<Database.upsertResult> uResults = Database.upsert(records,keyField,false);
 		results = WebMethodsInterfaceResult.createFromUpsertResults('SAP_Ultimate_Parent__c', 'Legal_Ultimate_Parent_Number__c', records, uResults);
 		return results;
 	}

    /* Delete From SAP_Ultimate_Parent__c Table */
 	webservice static WebMethodsInterfaceResult deleteSAPUltimateParent(SAP_Ultimate_Parent__c record) {
 		List<SAP_Ultimate_Parent__c> records = new List<SAP_Ultimate_Parent__c>();
 		records.add(record);
 		List<WebMethodsInterfaceResult> results = deleteSAPUltimateParents(records);
 		if (results.size() > 0) {return results[0];} else {return null;}
 	}
 
 	webservice static List<WebMethodsInterfaceResult> deleteSAPUltimateParents(List<SAP_Ultimate_Parent__c> records) {
 		List<WebMethodsInterfaceResult> results = new List<WebMethodsInterfaceResult>();
 		
 		List<String> recKeys = new List<String>();
 		for (SAP_Ultimate_Parent__c record:records) {recKeys.add(record.Legal_Ultimate_Parent_Number__c);}
 		List<SAP_Ultimate_Parent__c> recsToDelete = [SELECT Id, Legal_Ultimate_Parent_Number__c FROM SAP_Ultimate_Parent__c WHERE Legal_Ultimate_Parent_Number__c = :recKeys];
 		List<Database.deleteResult> dResults = Database.delete(recsToDelete,false);

 		results = WebMethodsInterfaceResult.createFromDeleteResults('SAP_Ultimate_Parent__c', 'Legal_Ultimate_Parent_Number__c',records, recsToDelete, dResults);
 		
 		return results;
 	}

	//----------------------------------------- 
 	// eCustomer Account Integration Interface
	//----------------------------------------- 

    /* Upsert Into SAP_ECOM_Customer__c Table */
 	webservice static WebMethodsInterfaceResult upsertSAPECOMCustomer(SAP_ECOM_Customer__c record) {
 		List<SAP_ECOM_Customer__c> records = new List<SAP_ECOM_Customer__c>();
 		records.add(record);
 		List<WebMethodsInterfaceResult> results = upsertSAPECOMCustomers(records);
 		if (results.size() > 0) {return results[0];} else {return null;}
 	}
 
 	webservice static List<WebMethodsInterfaceResult> upsertSAPECOMCustomers(List<SAP_ECOM_Customer__c> records) {
 		List<WebMethodsInterfaceResult> results = new List<WebMethodsInterfaceResult>();
 		
 		for (SAP_ECOM_Customer__c record:Records) {record.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(record);}
 		
 		Schema.SObjectField keyField = SAP_ECOM_Customer__c.Fields.Key__c;
 		List<Database.upsertResult> uResults = Database.upsert(records,keyField,false);
 		results = WebMethodsInterfaceResult.createFromUpsertResults('SAP_ECOM_Customer__c', 'Key__c', records, uResults);
 		
 		return results;
 	}
  
    /* Delete From SAP_ECOM_Customer__c Table */
 	webservice static WebMethodsInterfaceResult deleteSAPECOMCustomer(SAP_ECOM_Customer__c record) {
 		List<SAP_ECOM_Customer__c> records = new List<SAP_ECOM_Customer__c>();
 		records.add(record);
 		List<WebMethodsInterfaceResult> results = deleteSAPECOMCustomers(records);
 		if (results.size() > 0) {return results[0];} else {return null;}
 	}
 
 	webservice static List<WebMethodsInterfaceResult> deleteSAPECOMCustomers(List<SAP_ECOM_Customer__c> records) {
 		List<WebMethodsInterfaceResult> results = new List<WebMethodsInterfaceResult>();

 		for (SAP_ECOM_Customer__c record:Records) {record.Key__c = SAP_ECOM_Customer.buildKey_SAP_ECOM_Customer(record);}

 		List<String> recKeys = new List<String>();
 		for (SAP_ECOM_Customer__c record:records) {recKeys.add(record.Key__c);}
 		List<SAP_ECOM_Customer__c> recsToDelete = [SELECT Id, Key__c FROM SAP_ECOM_Customer__c WHERE Key__c = :recKeys];
 		List<Database.deleteResult> dResults = Database.delete(recsToDelete,false);

 		results = WebMethodsInterfaceResult.createFromDeleteResults('SAP_ECOM_Customer__c', 'Key__c',records, recsToDelete, dResults);

 		return results;
 	}
    
    //---------------
 	// TSR Interface
    //---------------

    webservice static List<String> GetAllTSRData() {
    	return CaseWebService.GetAllTSRData();
		//return new List<String>();
    }

    webservice Static List<WebMethodsInterfaceResult> updateCasesFromCaseNumbers(string caseNumbers) {
        List<WebMethodsInterfaceResult> results = new List<WebMethodsInterfaceResult>();
        CaseWebService.updateCasesFromCaseNumbers(caseNumbers);
        return results;
    }

}