global class AppLog {

    static webservice Id write(String applicationName,
                               String versionInfo,
                               String logType,
                               String logCategory,
                               String recordKey,
                               String log) {
                            
        AppLog__c newLog = new AppLog__c();
        try {      
            newLog = AppLog.createAppLogRecord(applicationName,versionInfo,logType,logCategory,recordKey,log);
           
            if (newLog.Record_Key__c != '')
            {
                upsert newLog Record_Key__c;
            }
            else
            {
                insert newLog;
            }
        }
        catch (Exception e) {}
        return newLog.Id;
    }

  static webservice AppLog__c createAppLogRecord(String applicationName,
                                                   String versionInfo,
                                                   String logType,
                                                   String logCategory,
                                                   String recordKey,
                                                   String log) {
          AppLog__c newLog = new AppLog__c();
          
          newLog.Application_Name__c = applicationName;
          newLog.Version_Info__c = versionInfo;
          newLog.User__c = UserInfo.getUserId();
          newLog.Log_Type__c = logType;
          newLog.Log_Category__c = logCategory;
          newLog.Record_Key__c = recordKey;
          newLog.Log_Date_Time__c = System.now();
          newLog.Log__c = log;
          
          return newLog;
  }

}