global class BatchToCalculateINFORCount implements Database.Batchable<sObject>, Database.Stateful,Schedulable {
    global integer numberOfINFOR = 0;
     
    global Database.QueryLocator start(Database.BatchableContext bc){
        String soqlQuery = 'SELECT id,Material_Description__c,Material_Number__c From INFOR_Forecast__c';
        return Database.getQueryLocator(soqlQuery);
    }
     
    global void execute(Database.BatchableContext bc, List<INFOR_Forecast__c> scope){
         
        for (INFOR_Forecast__c infor : scope){
            if(infor.Material_Number__c != 'ZZZZZZZZZZZZZZZZZZ'){
                numberOfINFOR = numberOfINFOR + 1;
            }
            
        }
    }
     
    global void finish(Database.BatchableContext bc){
        List<INFOR_Forecast__c> existinginfor = [Select id,Material_Number__c,Ship_to_Number__c,M1__c,Material_Description__c from INFOR_Forecast__c where Material_Number__c = 'ZZZZZZZZZZZZZZZZZZ'];
        System.debug('existinginfor++' + existinginfor);
        if(existinginfor.size()>0 ){
            System.debug('In updating INFOR Count+++');
            INFOR_Forecast__c inforupdate = new INFOR_Forecast__c(id = existinginfor[0].id);
            inforupdate.M1__c = numberOfINFOR;
            inforupdate.Material_Description__c = 'Count of INFOR';
            update inforupdate;
        }
        
        
    }

    global void execute(SchedulableContext sc)
    {
        
        BatchToCalculateINFORCount objClass = new BatchToCalculateINFORCount();
        Database.executeBatch (objClass,2000);
    }
}