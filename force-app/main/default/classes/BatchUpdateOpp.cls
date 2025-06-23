global class BatchUpdateOpp implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
         
        String query = 'select id, Opportunity__r.SAP_Customer_Group_Desc__c,Currency_from_PFx__c,CurrencyIsoCode,Material_Number__c,Market__c,Customer_Group__c,Sfdc_Key__c from Opportunity_Material__c where Sfdc_Key__c = null';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Opportunity_Material__c> OppMaterialList) {
        
        
        for(Opportunity_Material__c oppMat : OppMaterialList){
      
            if(oppMat.Currency_from_PFx__c != null){
                oppMat.CurrencyIsoCode= oppMat.Currency_from_PFx__c;
            }else{
                oppMat.CurrencyIsoCode = null;
            }
              
        }
        
       update OppMaterialList;
        }
       
         
       
     
    global void finish(Database.BatchableContext BC) {
        
    }
}