global with sharing class Pricing_Debug_Log_Functions {

	webservice static void createPricingDebugLog(
	                                             String application,
	                                             String userId,
	                                             String debugLog 
	                                            ) {
		try {
			Pricing_Security__c Pricing_Security = Pricing_Security__c.getInstance();

			List<String> logs = new List<String>();
			Integer numLogs = (debugLog.length() / 32000) + 1;
			
			for (Integer i=0;i<numLogs;i++)
				{
				String newLog = '';
				Integer startPos = (32000 * i);
				Integer endPos = (startPos + 32000);
				if (endPos > (debugLog.length() - 1)) {endPos = (debugLog.length() - 1);}
				newLog = debugLog.subString(startPos,endPos);
				logs.add(newLog);
				}
			
			if (Pricing_Security.Save_Debug_Log__c == true)
				{
					
				for(String log:logs)
					{
					Pricing_Debug_Log__c newPricingDebugLog = new Pricing_Debug_Log__c();
					newPricingDebugLog.Application__c = application;
					newPricingDebugLog.User__c = userId;
					newPricingDebugLog.Log_Detail__c = log;
					
		            insert(newPricingDebugLog);
					}
				}
		}
		 
		catch (Exception e) {}
	}

}