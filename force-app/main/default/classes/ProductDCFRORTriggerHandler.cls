public class ProductDCFRORTriggerHandler {
    
    public static void processBeforeInsert(List<Product_DCFROR__c> plist) {
        
        system.debug('Isinsert trigger');  
    set<Id> parentAccIds=new set<Id>();
    for(Product_DCFROR__c dc:plist)
    {
        parentAccIds.add(dc.DCFROR__c);
    }
    //get all parent Account currency
    Map<Id,DCFROR__c> accDetailById=new Map<Id,DCFROR__c>();
    accDetailById.putAll([select id,CurrencyIsoCode from DCFROR__c where id IN :parentAccIds]);
    
    for(Product_DCFROR__c gr:plist)
    {
        gr.CurrencyIsoCode=accDetailById.get(gr.DCFROR__c).CurrencyIsoCode;
    }
    }

}