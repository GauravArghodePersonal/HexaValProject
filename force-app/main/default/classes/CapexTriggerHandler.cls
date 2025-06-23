public class CapexTriggerHandler {
public static void processBeforeInsert(List<CAPEX__c> clist) {
    system.debug('Isinsert trigger');  
    set<Id> parentAccIds=new set<Id>();
    for(CAPEX__c dc:clist)
    {
        parentAccIds.add(dc.DCFROR__c);
    }
    //get all parent Account currency
    Map<Id,DCFROR__c> accDetailById=new Map<Id,DCFROR__c>();
    accDetailById.putAll([select id,CurrencyIsoCode from DCFROR__c where id IN :parentAccIds]);
    
    for(CAPEX__c gr:clist)
    {
        gr.CurrencyIsoCode=accDetailById.get(gr.DCFROR__c).CurrencyIsoCode;
    }
}
}