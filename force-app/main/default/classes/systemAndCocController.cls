public class systemAndCocController {
    
    public string currentCOC;
    @AuraEnabled(cacheable=true)
    public static List<systemAndCocControllerWrapper> getSystems(String AccountId, String CocId) {
        string currentCOC=CocId;
        List<System__c> systemList = new List<System__c>();
        List<SystemCOC__c> systemCOCList = new List<SystemCOC__c>();
        List<Id> systemIdList = new List<Id>();
        Map<Id, SystemCOC__c> sysIdVsSysCOCMap = new Map<Id, SystemCOC__c>();
        for(System__c sys : [SELECT Id, System_Name__c, Account_Name__c FROM System__c WHERE Account_Name__c =: AccountId AND LSTP_Covered_System__c = true]){
            systemList.add(sys);
            systemIdList.add(sys.Id);
        }
        
        for(SystemCOC__c sysCOC : [SELECT Id,System__r.System_Name__c, Related_System_Selection__c,Rejected__c, Date_Time_Sample_Collected_Rep_Use__c, Date_Time_Sample_Received_Lab_Use__c, 
                                   Date_Time_Sample_Reported_Lab_Use__c, Total_Sample_Vol_Submitted_ml__c,Potable_Stream__c
                                   FROM SystemCOC__c WHERE System__c IN: systemIdList AND COC__c =: CocId]) {
                                       sysIdVsSysCOCMap.put(sysCOC.System__c, sysCOC);
                                       systemCOCList.add(sysCOC);
                                   }
        
        List<systemAndCocControllerWrapper> fullData = new List<systemAndCocControllerWrapper>();
        
        // No System-COC data
        if(systemCOCList.size() <= 0) {
            return new List<systemAndCocControllerWrapper>();
        }
        
        // Get System-COC record data
        for(SystemCOC__c sysCoc: systemCOCList) {
            systemAndCocControllerWrapper wrap = new systemAndCocControllerWrapper();
            wrap.Id = sysCoc.System__c;
            wrap.SystemName = sysCoc.System__r.System_Name__c;
            wrap.RelatedSystemSelection = sysCoc.Related_System_Selection__c;
            wrap.Rejected = sysCoc.Rejected__c;
            wrap.DatetimeSampleCollected = sysCoc.Date_Time_Sample_Collected_Rep_Use__c;
            wrap.DatetimeSampleRecieved = sysCoc.Date_Time_Sample_Received_Lab_Use__c;
            wrap.DatetimeSampleReported = sysCoc.Date_Time_Sample_Reported_Lab_Use__c;
            wrap.TotalSampleVolSubmitted = sysCoc.Total_Sample_Vol_Submitted_ml__c;
            wrap.PotableStream = sysCoc.Potable_Stream__c;
            fullData.add(wrap);
        }
        
        return fullData;
    }
    
    @AuraEnabled(Cacheable = true)
    public static List<systemOptionsWrapper> getSystemOptions(String AccountId) {
        List<System__c> systemList = new List<System__c>();
        Map<Id, SystemCOC__c> sysIdVsSysCOCMap = new Map<Id, SystemCOC__c>();
        for(System__c sys : [SELECT Id, System_Name__c, Account_Name__c FROM System__c WHERE Account_Name__c =: AccountId AND LSTP_Covered_System__c = true]){
            systemList.add(sys);
        }
        
        List<systemOptionsWrapper> fullData = new List<systemOptionsWrapper>();
        for(System__c sys: systemList) {
            systemOptionsWrapper wrap = new systemOptionsWrapper();
            wrap.label = sys.System_Name__c;
            wrap.value = sys.Id;
            fullData.add(wrap);
        }
        return fullData;
    }
    
    @AuraEnabled
    public static Boolean upsertCOCData(String data, String cocId) {
        
        List<systemAndCocControllerWrapper> wrapRecs = (List<systemAndCocControllerWrapper>) JSON.deserialize(data, List<systemAndCocControllerWrapper>.class);
        
        Set<Id> systemIds = new Set<Id>();
        for(systemAndCocControllerWrapper wrap: wrapRecs) {
            systemIds.add(wrap.Id);
        }
        
        Map<String, SystemCOC__c> sysCocMap = new Map<String, SystemCOC__c>();
        List<SystemCOC__c> sysCocRecs = new List<SystemCOC__c>();
        for(SystemCOC__c sysCoc : [SELECT Id, System__c, COC__c, Rejected__c, Date_Time_Sample_Collected_Rep_Use__c, Date_Time_Sample_Received_Lab_Use__c, Date_Time_Sample_Reported_Lab_Use__c, Total_Sample_Vol_Submitted_ml__c  FROM SystemCOC__c WHERE System__c IN: systemIds AND COC__c =: cocId]) {
            sysCocMap.put(String.valueOf(sysCoc.System__c) + String.valueOf(sysCoc.COC__c), sysCoc);
        }
        
        // Update the Wrapper with existing data + modified data
        for(systemAndCocControllerWrapper wrap: wrapRecs) {
            if(wrap.Id != null && cocId != null){
                String systemCOCIds =  wrap.Id + cocId;
                if(sysCocMap.containsKey(systemCOCIds)){
                    wrap.Rejected = (wrap.Rejected == null || wrap.Rejected == false) ? false : true;
                    wrap.DatetimeSampleCollected = wrap.DatetimeSampleCollected == null ? sysCocMap.get(systemCOCIds).Date_Time_Sample_Collected_Rep_Use__c : wrap.DatetimeSampleCollected;
                    wrap.DatetimeSampleRecieved = wrap.DatetimeSampleRecieved == null ? sysCocMap.get(systemCOCIds).Date_Time_Sample_Received_Lab_Use__c : wrap.DatetimeSampleRecieved;
                    wrap.DatetimeSampleReported = wrap.DatetimeSampleReported == null ? sysCocMap.get(systemCOCIds).Date_Time_Sample_Reported_Lab_Use__c : wrap.DatetimeSampleReported;
                    wrap.TotalSampleVolSubmitted = wrap.TotalSampleVolSubmitted == null ? sysCocMap.get(systemCOCIds).Total_Sample_Vol_Submitted_ml__c : wrap.TotalSampleVolSubmitted;
                }
            }
        }
        
        // Prepare data for Upsert System-COC records
        List<SystemCOC__c> sysCocToUpsert = new List<SystemCOC__c>();
        for(systemAndCocControllerWrapper wrap: wrapRecs) {
            if(wrap.Id != null && cocId != null){
                String systemCOCIds =  wrap.Id + cocId;
                if(sysCocMap.containsKey(systemCOCIds)){
                    SystemCOC__c sysCocRec = sysCocMap.get(systemCOCIds);
                    sysCocRec.System__c = wrap.Id;
                    sysCocRec.COC__c = cocId;
                    sysCocRec.Rejected__c = (wrap.Rejected == null || wrap.Rejected == false) ? false : true;
                    sysCocRec.Date_Time_Sample_Collected_Rep_Use__c = wrap.DatetimeSampleCollected;
                    sysCocRec.Date_Time_Sample_Received_Lab_Use__c = wrap.DatetimeSampleRecieved;
                    sysCocRec.Date_Time_Sample_Reported_Lab_Use__c = wrap.DatetimeSampleReported;
                    sysCocRec.Total_Sample_Vol_Submitted_ml__c = wrap.TotalSampleVolSubmitted;
                    sysCocToUpsert.add(sysCocRec);
                } else {
                    SystemCOC__c sysCocRec = new SystemCOC__c();
                    sysCocRec.System__c = wrap.Id;
                    sysCocRec.COC__c = cocId;
                    sysCocRec.Rejected__c = (wrap.Rejected == null || wrap.Rejected == false) ? false : true;
                    sysCocRec.Date_Time_Sample_Collected_Rep_Use__c = wrap.DatetimeSampleCollected;
                    sysCocRec.Date_Time_Sample_Received_Lab_Use__c = wrap.DatetimeSampleRecieved;
                    sysCocRec.Date_Time_Sample_Reported_Lab_Use__c = wrap.DatetimeSampleReported;
                    sysCocRec.Total_Sample_Vol_Submitted_ml__c = wrap.TotalSampleVolSubmitted;
                    sysCocToUpsert.add(sysCocRec);
                }
            }
        }
        if(!Test.isRunningTest()){
        upsert sysCocToUpsert;
        }
        return true;
    }
    
    @AuraEnabled(Cacheable = true)
    public static List<SystemCOC__c> getContacts(string recId) {
        return [SELECT Id,System__r.System_Name__c, Related_System_Selection__c,Rejected__c, Date_Time_Sample_Collected_Rep_Use__c, Date_Time_Sample_Received_Lab_Use__c, 
                Date_Time_Sample_Reported_Lab_Use__c, Total_Sample_Vol_Submitted_ml__c,Potable_Stream__c
                FROM SystemCOC__c where COC__c=: recId];
    }
    
    @AuraEnabled
    public static string updatecocsys( Object data ) {        
        List < SystemCOC__c > accsForUpdate = ( List < SystemCOC__c > ) JSON.deserialize(
            JSON.serialize( data ),
            List < SystemCOC__c >.class
        );
        try {
            update accsForUpdate;
            return 'Success: System for coc updated successfully';
        } catch (Exception e) {
            return 'The following exception has occurred: ' + e.getMessage();
        }
    }
    
    @AuraEnabled
    public static void deleteSystemCOCData(String CId,String SystemId) {
        
        delete[select Id from SystemCOC__c where COC__c=:CId AND System__c=:SystemId];
        
    }
    
    
    public class systemAndCocControllerWrapper {
        @AuraEnabled public String Id {get; set;}
        @AuraEnabled public String SystemName {get; set;}
        @AuraEnabled public Decimal RelatedSystemSelection {get; set;}
        @AuraEnabled public Boolean Rejected {get; set;}
        @AuraEnabled public Datetime DatetimeSampleCollected {get; set;}
        @AuraEnabled public Datetime DatetimeSampleRecieved {get; set;}
        @AuraEnabled public Datetime DatetimeSampleReported {get; set;}
        @AuraEnabled public Decimal TotalSampleVolSubmitted {get; set;}
        @AuraEnabled public Decimal SampleTempInDeg {get; set;}
        @AuraEnabled Public Boolean PotableStream {get; set;}
        @AuraEnabled public String Results {get; set;}
    }
    
    public class systemOptionsWrapper {
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}
    }
}