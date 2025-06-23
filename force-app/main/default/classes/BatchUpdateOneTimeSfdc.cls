global class BatchUpdateOneTimeSfdc implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
         
        String query = 'select id,Material__r.Material_Number__c,Opportunity_Material__c.Customer_Group__c,Material_Number__c,Opportunity_Material__c.Opportunity_Sales_Org__c,Opportunity__r.SAP_Customer_Group_Desc__c,Opportunity__r.SAP_Sales_Org__c from Opportunity_Material__c where Sfdc_Key__c = null';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Opportunity_Material__c> OppMaterialList) {
        
         Set<String> CustomerGroup = new Set<String>();
         Map<String,String> CustomerwithMarketMap = new Map<String,String>();
        Set<Id> MaterialIds = New set<Id>();
        for(Opportunity_Material__c oppMat : OppMaterialList){
           CustomerGroup.add(oppMat.Customer_Group__c);
          }
         for(Customer_Group_Market__c customermarket : [select id,Market__c,Customer_Group__c from Customer_Group_Market__c where Customer_Group__c IN: CustomerGroup]){
            CustomerwithMarketMap.put(customermarket.Customer_Group__c,customermarket.Market__c);
         }
        List<Opportunity_Material__c> oppmatList = new List<Opportunity_Material__c>();
        
        for(Opportunity_Material__c oppMat : OppMaterialList){
              oppMat.Market__c = CustomerwithMarketMap.get(oppMat.Customer_Group__c);
             // oppMat.Sfdc_Key__c= 'X';
              oppMat.Sfdc_Key__c= oppMat.Material_Number__c+ oppMat.Opportunity_Sales_Org__c+ CustomerwithMarketMap.get(oppMat.Customer_Group__c);
          // SYstem.debug('oppMat.Opportunity__r.SAP_Customer_Group_Desc__c' +oppMat.Sfdc_Key__c);
         
        }
        
       update OppMaterialList;
        }
       
         
       
     
    global void finish(Database.BatchableContext BC) {
        
    }

}