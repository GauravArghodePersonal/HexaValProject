global without sharing class AppLogWebServices {

	Webservice static Id write(String processName,
    			               String subProcess,
  							   String applicationName,
		    			       String versionInfo,
		                       String logCategory,
		                       String task,
		                       String logType,
		                       String summary,
		                       String log,
		                       String relatedToKey,
		                       String relatedToKeyType,
		                       String recordKey) {
        return AppLogV2.write(processName,subProcess,applicationName,versionInfo,logCategory,task,logType,summary,log,relatedToKey,relatedToKeyType,recordKey);
    }
}