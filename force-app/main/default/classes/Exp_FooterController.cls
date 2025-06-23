public class Exp_FooterController {

    @AuraEnabled(cacheable=true)
    public static List<FooterWrapper> getFooterLinks() {
        
        List <Exp_Configs__c> links = [ SELECT Id, Name, Label__c,Type__c, Value__c FROM Exp_Configs__c
                                      WHERE RecordType.DeveloperName = 'Footer'];
        List<FooterWrapper> listOfWrapper = new List<FooterWrapper>();
        Map<String,FooterWrapper> mapp = new Map<String,FooterWrapper>();
        
        for(Exp_Configs__c s: links){
            FooterWrapper fw = new FooterWrapper();
            fw.label = s.Label__c;
            fw.type = s.Type__c;
            fw.link = s.Value__c;
            listOfWrapper.add(fw);
        }
        
        return listOfWrapper;

    }
    
    public class FooterWrapper{
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public String link {get;set;}
    }
}