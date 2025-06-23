global with sharing class WebMethodsInterfaceResult {
	
	public WebMethodsInterfaceResult(Boolean success,
	                                 String key,
	                                 Id id,
	                                 String result,
	                                 List<String> errors) {
		this.success = success;
		this.key = key;
		this.id = id;
		this.result = result;
		this.errors = errors;
		this.processedAt = DateTime.now().format('MM/dd/yyyy KK:mm:ss a','America/New_York') + ' EST';
	}
	
    webservice Boolean success {get; set;}
    webservice String key {get; set;}
    webservice Id id {get; set;}
    webservice String result {get; set;}
    webservice List<String> errors {get; set;}
    webservice String processedAt {get; set;}
    
    
    public static List<WebMethodsInterfaceResult> createFromUpsertResults(String sObjectType, String keyField, List<SObject> records, List<Database.upsertResult> uResults) {
		List<WebMethodsInterfaceResult> results = new List<WebMethodsInterfaceResult>();

 		for (Integer i=0; i<uResults.size(); i++) {
 			Database.upsertResult uResult = uResults[i];

			Boolean success;
 			String keyValue;
 			Id recId;
 			String resultText = '';
 			List<String> errors = new List<String>();
 			
 			SObject rec = records[i];
 			success = uResult.isSuccess();
 			keyValue = (String)rec.get(keyField);
 			recId = uResult.getId();
 			
 			if (uResult.getErrors().size() == 0) {
	 			if (uResult.isCreated()) {
	 				resultText = 'Record Inserted';
	 			} else {
	 				resultText = 'Record Updated';
	 			}
 			} else {
 				resultText = 'Errors Occurred';
	 			for (Database.Error error:uResult.getErrors()) {
	 				errors.add(error.getStatusCode() + ' - ' + error.getMessage());
	 			}
 			}
 			
            results.add(new WebMethodsInterfaceResult(success,keyValue,recId,resultText,errors));
        }
		
		return results;
	}
    
    public static List<WebMethodsInterfaceResult> createFromDeleteResults(String sObjectType, String keyField, List<SObject> records, List<SObject> recordsDeleteAttemptedOn, List<Database.deleteResult> dResults) {
		List<WebMethodsInterfaceResult> results = new List<WebMethodsInterfaceResult>();

		//Build a lookup Map of DeleteResults based on External Id
		Map<String,Database.deleteResult> deleteResultsMap = new Map<String,Database.deleteResult>();
		for (Integer i=0;i<dResults.size();i++) {
			String externalId = (String)recordsDeleteAttemptedOn[i].get(keyField);
			Database.deleteResult dResult = dResults[i];
			deleteResultsMap.put(externalId,dResult);
		}

		for (SObject record:records) {
			Boolean success;
 			String keyValue;
 			Id recId;
 			String resultText = '';
 			List<String> errors = new List<String>();
 			
 			keyValue = (String)record.get(keyField);
 			
			Database.deleteResult recDeleteResult = deleteResultsMap.get(keyValue);

			if (recDeleteResult != null) {
	 			success = recDeleteResult.isSuccess();
	 			recId = recDeleteResult.getId();
				
 				if (recDeleteResult.getErrors().size() == 0) {
		 			resultText = 'Record Deleted';
	 			} else {
	 				resultText = 'Errors Occurred While Deleting';
		 			for (Database.Error error:recDeleteResult.getErrors()) {
		 				errors.add(error.getStatusCode() + ' - ' + error.getMessage());
		 			}
 				}
			} else {
				success = false;
				recId = null;
				resultText = 'Record Not Found';
				errors.add('Record Not Found, unable to Delete');
			}		
			
            results.add(new WebMethodsInterfaceResult(success,keyValue,recId,resultText,errors));
		}

		return results;
	}
    
}