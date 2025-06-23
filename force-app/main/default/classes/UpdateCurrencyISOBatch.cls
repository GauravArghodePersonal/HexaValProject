global class UpdateCurrencyISOBatch implements Database.Batchable<Sobject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'select id,CurrencyIsoCode,Sales_Org__c from INFOR_Forecast__c where Sum_M1__c=0 and Sum_M2__c =0 and Sum_M3__c =0 and Sum_M4__c =0 and Sum_M5__c =0 and Sum_M6__c =0 and Sum_M7__c =0 and Sum_M8__c =0 and Sum_M9__c =0 and Sum_M10__c =0 and Sum_M11__c =0 and Sum_M12__c =0 and Sum_M2__c =0';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<INFOR_Forecast__c> Inforlist){
        Set<String> Salesorgs = new Set<String>();
        for(INFOR_Forecast__c Infor : Inforlist){
            Salesorgs.add(Infor.Sales_Org__c);
        }
        Map<String,String> salesorgwithCurrency = new Map<String,String>();
        for(SalesOrg_Currency__c salecur : [select id,Sales_Org__c,CurrencyIsoCode from SalesOrg_Currency__c where Sales_Org__c IN: Salesorgs]){
            salesorgwithCurrency.put(salecur.Sales_Org__c, salecur.CurrencyIsoCode);
        } 
        for(INFOR_Forecast__c Infor : Inforlist){
            String curr = salesorgwithCurrency.get(Infor.Sales_Org__c);
            Infor.CurrencyIsoCode = curr;
        }
        Update Inforlist;
    }
    
    global void finish(database.BatchableContext BC){
        
    }

}