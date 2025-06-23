public class LWCSampleTestInformationCtrl {

    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getRecordTypes(String lwrId){
        List<LWR__c> lwrRecord = [SELECT Id, Technical_Center__c, Request__c FROM LWR__c WHERE Id =: lwrId];
        // system.debug('technical center '+lwrRecord);
        String region = '';
        if(!lwrRecord.isEmpty() && String.isNotBlank(lwrRecord[0].Technical_Center__c) && (lwrRecord[0].Request__c == 'Standard Request' || lwrRecord[0].Request__c == 'R&D Standard Request' ) ){
            Technical_Center_Region_Mapping__mdt mdt = Technical_Center_Region_Mapping__mdt.getInstance(lwrRecord[0].Technical_Center__c);
            if(mdt.Active__c){ 
                region = mdt.Region__c;
            }
        }
        List<OptionWrapper> options = new List<OptionWrapper>();
        for(RecordTypeInfo info: Sample_Test_Information__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.isAvailable() && info.getName() != 'Master' && info.getName() != 'Mestra' && info.getName() != 'Mestre'  && String.isNotBlank(region) && info.getName().startsWith(region)) {
                options.add(new OptionWrapper(info.getName(),info.getRecordTypeId()));
            }
        }

        return options;
    }
       
    @AuraEnabled(cacheable=true)
    public static Sample_Test_Information_Settings__mdt getPreDefinedData(String recordType, String testList){
        return [SELECT Id,
                    Analyses__c,
                    Sample_Volume__c
                    FROM
                        Sample_Test_Information_Settings__mdt
                    WHERE
                        Form__c =:recordType
                    AND
                        Test_List__c =:testList
                    LIMIT 1
               ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ListViewWrapper> getListViews(){
        List<ListViewWrapper> result = new List<ListViewWrapper>();
        for(ListView lv : [SELECT Id, Name FROM ListView WHERE SobjectType = 'Sample_Test_Information__c']){
            result.add(new ListViewWrapper(lv.Name, lv.Id));
        }
        
        return result;
    }
    
    public class ListViewWrapper {
        @AuraEnabled
        public string name { get;set; }
        @AuraEnabled
        public string id   { get;set; }
        
        public ListViewWrapper() {
            this.name = '';
            this.id = '';
        }
        
        public ListViewWrapper(String listviewName, String listviewId){
            this.name = listviewName;
            this.id = listviewId;
        }
    }

    public class OptionWrapper {
        @AuraEnabled
        public string label { get;set; }
        @AuraEnabled
        public string value   { get;set; }
        
        public OptionWrapper() {
            this.label = '';
            this.value = '';
        }
        
        public OptionWrapper(String recordTypeName, String recordTypeId){
            this.label = recordTypeName;
            this.value = recordTypeId;
        }
    }
}