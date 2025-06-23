public class leadTriggerHandler{
    public static void beforeUpdateTrigger(List<Lead> newlist,Map<id,Lead> oldmapValue){    
        updateRegion(newlist);
    }
    
    public static void beforeInsertTrigger(List<Lead> newlist){
        updateRegion(newlist);    
    }
    public static void updateRegion(List<Lead> leadnewlist){
        Id LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Web Request').getRecordTypeId();
        For(Lead Ld: leadnewlist){
             System.debug('<<<>>>>');
            if(Ld.RecordTypeid==LeadRecordTypeId){
                    System.debug('<<<>>>>');
                    If(Ld.Country=='United States' || Ld.Country=='Canada'){
                        Ld.Region__c='NORTH AMERICA';
                    }
                else if(Ld.Country=='Austria' || Ld.Country=='Belarus' || Ld.Country=='Benelux' || Ld.Country=='Denmark' || Ld.Country=='Eastern Europe' 
                    || Ld.Country=='Finland & Baltic States' || Ld.Country=='France' || Ld.Country=='Germany' || Ld.Country=='Italy' || Ld.Country=='Middle East' 
                    || Ld.Country=='North Africa' || Ld.Country=='Norway' || Ld.Country=='Spain' || Ld.Country=='Sub-Saharan Africa' || Ld.Country=='Sweden' 
                    || Ld.Country=='Switzerland' || Ld.Country=='Poland' || Ld.Country=='Portugal' || Ld.Country=='Russia & CIS' 
                    || Ld.Country=='Turkey' || Ld.Country=='Ukraine' || Ld.Country=='United Kingdom & Ireland '){
                    
                    Ld.Region__c='EUROPE, MIDDLE EAST, AFRICA';
                }
                else If(Ld.Country=='Australia' || Ld.Country=='China' || Ld.Country=='India' || Ld.Country=='Indonesia' || Ld.Country=='Japan'
                         || Ld.Country=='Korea' || Ld.Country=='New Zealand' || Ld.Country=='Singapore' || Ld.Country=='Southeast Asia'|| Ld.Country=='Taiwan'){
                        Ld.Region__c='ASIA PACIFIC';
                    }
                else If(Ld.Country=='Argentina' || Ld.Country=='Brazil' || Ld.Country=='Chile' || Ld.Country=='Colombia' || Ld.Country=='Mexico'
                         || Ld.Country=='Trinidad and Tobago'){
                        Ld.Region__c='LATIN AMERICA';
                    }
                else{
                    Ld.Region__c='';

                }    
            }
        }
        
    }
}