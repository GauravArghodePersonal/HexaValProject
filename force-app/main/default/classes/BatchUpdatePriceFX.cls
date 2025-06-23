global class BatchUpdatePriceFX implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
         
        String query = 'select id, Opportunity__r.SAP_Customer_Group_Desc__c,Currency_from_PFx__c,Market__c,Sfdc_Key__c from Opportunity_Material__c where Sfdc_Key__c != null';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Opportunity_Material__c> OppMatList) {
       
        Map<String,String> MarketwithCustomer = new Map<String,String>();
        Set<String> sfdcIds = new Set<String>();
        for(Opportunity_Material__c Oppmat : OppMatList) {        
            sfdcIds.add(Oppmat.Sfdc_Key__c);
        }
       
        Map<String, decimal> sfdckeywithtargetprice = new Map<String, decimal>();
       Map<String, String> sfdckeywithcurrency = new Map<String, String>();
        for(PFx_Price_Book__c price : [select id,Target_Price__c,SFDC_Key__c,CurrencyIsoCode  from PFx_Price_Book__c where SFDC_Key__c IN: sfdcIds]){         
			sfdckeywithtargetprice.put(price.SFDC_Key__c,price.Target_Price__c);
            sfdckeywithcurrency.put(price.SFDC_Key__c,price.CurrencyIsoCode);
        }
       
        List<Opportunity_Material__c> oppmatlistUpdate = OppMatList;
        
        try {
            for(Opportunity_Material__c Oppmat : OppMatList) { 
               Oppmat.Target_Price_from_PFx__c= sfdckeywithtargetprice.get(Oppmat.Sfdc_Key__c);
                Oppmat.Currency_from_PFx__c = sfdckeywithcurrency.get(Oppmat.Sfdc_Key__c);
                }
            update   OppMatList; 
        	 	
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        
    }
}