public class SolenisVDPButton{
    @AuraEnabled public boolean enabled {get; set;}

    @AuraEnabled(cacheable=true)
    public static SolenisVDPButton getcheckVdp(string recordId){
    SolenisVDPButton sBtn= new SolenisVDPButton(recordId);
    return sBtn;
    }
    
    public SolenisVDPButton(string recordId){
        ValueAdvantage__c val = [select id,Project_Status__c from ValueAdvantage__c where id=:recordId];
        if(val.Project_Status__c=='Approved'){
                enabled = true;
        }
    }
}