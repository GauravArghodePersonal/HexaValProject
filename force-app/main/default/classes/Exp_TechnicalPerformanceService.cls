/**
 * @description Cumulocity API Technical Performance Service Class
 */
public without sharing class Exp_TechnicalPerformanceService {

    static final String ALARM_CRITICAL = 'CRITICAL';
    static final String ALARM_MAJOR    = 'MAJOR';
    static final String ALARM_MINOR    = 'MINOR';
    static final String ALARM_WARNING  = 'WARNING';

    /**
     * @description Checks technical performance score data lastmodified data 
     *              to make a callout to cumulocity api if the data is expired
     *              otherwise pulls from org to display in the experience cloud widget
     */
    public static String checkAndObtainPerformanceData(String customerId) {
        String json = '';
        try{
            String cumulocityId = getCumulocityID(customerId);
            Boolean latestDataNotAvailable = !checkForLatestPerformance(customerId);
            if(latestDataNotAvailable){
                json = makeMetadataAPICallout(cumulocityId,customerId);
            } else {
                json = getStoredTechnicalPerformanceData(customerId);
            }
        } catch(Exception ex){
            System.debug('--Something went wrong!-->' + ex.getStackTraceString());
        }
        
        return json;
    }     

    /**
     * @description Make a callout to cumulocity api passing customer identifier
     */
    private static String makeMetadataAPICallout(String cumulocityId, String customerId) {       
        String metadataJSON = '[]';
        External_System_Credential__mdt credentials = getCumulocityMetadataAPICredentials();
        String endpoint = credentials == null?'':credentials.Endpoint_URL__c;
        String code = credentials == null?'':credentials.Code__c;
        endpoint += '?code=' + code + '&external_id=' + cumulocityId;
        String authorization = credentials == null?'':('Basic' + ' ' + credentials.Access_Token__c);
        if(String.isNotBlank(endpoint) && String.isNotBlank(authorization) && String.isNotBlank(cumulocityId)) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint) ;
            request.setMethod('GET');
            request.setHeader('Authorization',authorization);
            request.setTimeout(120000);
            try {
                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200 && String.isNotBlank(response.getBody())) {
                    metadataJSON =  response.getBody(); 
                    List<Site> siteList = (List<Site>)JSON.deserializeStrict(response.getBody(),List<Site>.class);
                    upsertTechnicalPerformanceData(siteList,customerId);
                } else {
                    System.debug('---Something went wrong with Cumulocity API Request-->' + response.getBody());
                }
            } catch(Exception ex) {
                System.debug('---Something went wrong with Cumulocity API Request-->' + ex.getMessage());
            }
        }

        return metadataJSON;
    }

    /**
     * @description Upsert the technical performance metadata returned by cumulocity api in sf
     */
    private static void upsertTechnicalPerformanceData(List<Site> siteList, String customerId) {
        List<Technical_Performance_Score__c> technicalPerformanceScoreList = new List<Technical_Performance_Score__c>();
        for(Site st : siteList){
            // Get Alarms Map
            Map<String,Integer> alarmsMap = getAlarmsMap(st.alarm);
            for(App ap : st.apps){
                Technical_Performance_Score__c newTPS = new Technical_Performance_Score__c();
                newTPS.Application_Id__c      = ap.appId;
                newTPS.Application_Name__c    = ap.appName;
                newTPS.Application_Performance_Status__c = ap.appPerformanceStatus; 
                newTPS.Application_Performance_Error_Message__c = ap.appPerformanceErrorMessage;
                newTPS.Customer__c     = customerId;
                newTPS.Device_Count__c = st.deviceCount; 
                newTPS.Site_Id__c      = st.siteId;
                newTPS.Site_Name__c    = st.siteName;
                newTPS.Site_URL__c     = st.siteURL;
                newTPS.Critical_Alarms__c = alarmsMap.get(ALARM_CRITICAL) == null?
                                                0:alarmsMap.get(ALARM_CRITICAL);
                newTPS.Major_Alarms__c    = alarmsMap.get(ALARM_MAJOR) == null?
                                                0:alarmsMap.get(ALARM_MAJOR);
                newTPS.Minor_Alarms__c    = alarmsMap.get(ALARM_MINOR) == null?
                                                0:alarmsMap.get(ALARM_MINOR);
                newTPS.Warning_Alarms__c  = alarmsMap.get(ALARM_WARNING) == null?
                                                0:alarmsMap.get(ALARM_WARNING);
                technicalPerformanceScoreList.add(newTPS);
            }
            
        }

        // Upsert the sites 
        Database.UpsertResult[] results = Database.upsert(technicalPerformanceScoreList,
                                                          Technical_Performance_Score__c.Fields.Application_Id__c,
                                                          false);
        String strInsertError = '';
        // Check results.
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                System.debug('Successfully site upsert ID: ' + results[i].getId());
            } else {
                System.debug('Error: could not upsert site ' + 'for array element ' + i + '.');
                strInsertError = 'The error reported was: ' + results[i].getErrors()[0].getMessage() + '\n';
                System.debug(strInsertError);
            }
        }
    }

    /**
     * @description Obtains the customer id specific technical performance metadata 
     *              and create a json wrapper to pass to technical performance component
     */
    private static String getStoredTechnicalPerformanceData(String customerId){
        Map<String,Site> siteWrapperById = new Map<String,Site>();
        for(Technical_Performance_Score__c tps : getExistingTechnicalPerformance(customerId)) {
            Site siteWrapper = siteWrapperById.get(tps.Site_Id__c);
            if(siteWrapper == null){
                // Create Site Wrapper Instance
                siteWrapper = new Site();
                siteWrapper.apps = new List<App>();
                siteWrapper.deviceCount = Integer.valueOf(tps.Device_Count__c);
                siteWrapper.siteId = tps.Site_Id__c;
                siteWrapper.siteName = tps.Site_Name__c;
                siteWrapper.siteURL = tps.Site_URL__c;

                // Create Alarm Wrapper Instances
                Alarm alarm_A = new Alarm();
                alarm_A.severity = ALARM_CRITICAL;
                alarm_A.count = Integer.valueOf(tps.Critical_Alarms__c);
                siteWrapper.alarm.add(alarm_A);
                
                Alarm alarm_B = new Alarm();
                alarm_B.severity = ALARM_MAJOR;
                alarm_B.count = Integer.valueOf(tps.Major_Alarms__c);
                siteWrapper.alarm.add(alarm_B);
                
                Alarm alarm_C = new Alarm();
                alarm_C.severity = ALARM_CRITICAL;
                alarm_C.count = Integer.valueOf(tps.Critical_Alarms__c);
                siteWrapper.alarm.add(alarm_C);
                
                Alarm alarm_D = new Alarm();
                alarm_D.severity = ALARM_CRITICAL;
                alarm_D.count = Integer.valueOf(tps.Critical_Alarms__c);
                siteWrapper.alarm.add(alarm_D);
            }
            // Create App Wrapper Instance
            App appWrapper = new App();
            appWrapper.appId = tps.Application_Id__c;
            appWrapper.appName = tps.Application_Name__c;
            appWrapper.appPerformanceStatus = Integer.valueOf(tps.Application_Performance_Status__c);
            appWrapper.appPerformanceErrorMessage = tps.Application_Performance_Error_Message__c;

            siteWrapper.apps.add(appWrapper);
            // Add Site Id to map
            siteWrapperById.put(tps.Site_Id__c,siteWrapper);
        }

        return JSON.serialize(siteWrapperById.values());
    }

    /**
     * @description Make a query to obtain technical performance based on customer id
     */
    private static List<Technical_Performance_Score__c> getExistingTechnicalPerformance(String customerId) {
        return [SELECT Application_Id__c, 
                       Application_Name__c, 
                       Application_Performance_Status__c,
                       Application_Performance_Error_Message__c,
                       Critical_Alarms__c,
                       Customer__c,
                       Device_Count__c,
                       Major_Alarms__c,
                       Minor_Alarms__c, 
                       Site_Id__c,
                       Site_Name__c,
                       Site_URL__c,
                       Warning_Alarms__c
                    FROM Technical_Performance_Score__c
                    WHERE Customer__c = :customerId];
    }  

    /**
     * @description Obtain cumulocity api credentials
     */
    private static External_System_Credential__mdt getCumulocityMetadataAPICredentials() {
        return External_System_Credential__mdt.getInstance('IoT_Cumulocity_Metadata_API'); 
    }

    /**
     * @description Make a query to obtain cumulocity Id from sold to customer
     */
    private static String getCumulocityID(String customerId){
        List<Account> accounts = [SELECT Id, 
                                         Salesforce_CY8_Intg_ID__c 
                                    FROM Account
                                    WHERE Id = :customerId];
       return accounts.isEmpty()?'':accounts[0].Salesforce_CY8_Intg_ID__c;
    }
    
    /**
     * @description Check the customer has recent technical performance data
     */
    private static Boolean checkForLatestPerformance(String customerId){
    	Integer refreshTimeFrame = Integer.valueOf(System.Label.TechnicalPerformanceDataRefreshTimeframe);
        DateTime nextSynchTime = DateTime.now().addHours(-refreshTimeFrame);
        List<Technical_Performance_Score__c> results = [SELECT Id, 
                                                             Customer__c
                                                        FROM Technical_Performance_Score__c
                                                        WHERE LastModifiedDate > :nextSynchTime 
                                                        ORDER BY LastModifiedDate, Customer__c];
        Boolean isLatest = false;
        for(Technical_Performance_Score__c data : results) {
            if(data.Customer__c == customerId){
                isLatest = true;
                break;
            }
        }
        
        return isLatest;
    }

    /**
     * @description Obtain the alarm map from alarm wrapper instances
     */
    private static Map<String,Integer> getAlarmsMap(List<Alarm> alarms){
        Map<String,Integer> alarmsMap = new Map<String,Integer>();
        for(Alarm alarm : alarms) {
            alarmsMap.put(alarm.severity, alarm.count);
        }

        return alarmsMap;
    }

    
    /**
     * @description Site wrapper class
     */
    public class Site {
        @AuraEnabled
        public Integer deviceCount          { get;set; }
        @AuraEnabled
        public String siteId                { get;set; }
        @AuraEnabled
        public String siteName              { get;set; }
        @AuraEnabled
        public String siteUrl               { get;set; }
        @AuraEnabled
        public List<Alarm> alarm            { get;set; }
        @AuraEnabled
        public List<App> apps               { get;set; }
        
        public Site() {
            this.deviceCount = 0;
            this.siteId      = '';
            this.siteName    = '';
            this.siteUrl     = '';
            this.alarm       = new List<Alarm>();
            this.apps        = new List<App>();
        }
        
    } 

    /**
     * @description App wrapper class
     */
    public class App {        
        @AuraEnabled
        public String appId                  { get;set; } 
        @AuraEnabled
        public String appName                { get;set; }
        @AuraEnabled
        public Integer appPerformanceStatus  { get;set; }
        @AuraEnabled
        public String appPerformanceErrorMessage  { get;set; }
    
        public App() {
            this.appId   = '';
            this.appName = '';
            this.appPerformanceStatus       = 0;
            this.appPerformanceErrorMessage = '';
        }
    }

    /**
     * @description Alarm wrapper class
     */
    public class Alarm {
        @AuraEnabled
        public String severity  { get;set; }
        @AuraEnabled
        public Integer count    { get;set; }
        
        public Alarm() {
            this.severity = '';
            this.count    = 0;
        }
    }
   
}