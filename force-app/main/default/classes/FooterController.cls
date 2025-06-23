public class FooterController {
	@AuraEnabled  
    public static List<footerWrapper> fetchMetaListLwc() {
        
        List < Footer_Links__mdt  > fetchMeta = [ SELECT Id, Label,Type__c, Value__c FROM Footer_Links__mdt];
        List<footerWrapper> listOfWrapper = new List<footerWrapper>();
        Map<String,footerWrapper> mapp = new Map<String,footerWrapper>();
        
        for(Footer_Links__mdt s: fetchMeta){
            footerWrapper fw = new footerWrapper();
            fw.label = s.Label;
            fw.type = s.Type__c;
            fw.link = s.Value__c;
            listOfWrapper.add(fw);
//            mapp.put(s.Label,fw);
        }
        
                
        return listOfWrapper;

    }
    
    public class footerWrapper{
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public String link {get;set;}
    }
}