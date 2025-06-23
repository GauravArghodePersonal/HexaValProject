global class FSL_ServiceAppointment_Batch implements
    Database.Batchable<sObject>, Database.Stateful {
    //private Id schedulingPolicyId;
    // instance member to retain state across transactions 
    global Integer recordsProcessed = 0; 
    global Database.QueryLocator start(Database.BatchableContext bc) {
    //schedulingPolicyId=[SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name='Solenis v1' LIMIT 1].Id;
        return Database.getQueryLocator('SELECT ID,status FROM ServiceAppointment where Status=\'None\' and SAP_Service_Region__c=\'EMEA\' and CreatedDate= Today LIMIT 200');
        
    }
    global void execute(Database.BatchableContext bc, List<ServiceAppointment> scope){
    // process each batch of records
    System.debug('<<2>>'+ scope);
    FSL.ScheduleResult myResult = new FSL.ScheduleResult();
    ID PolicyId = FSL_SA_Scheduling_Policy__c.getInstance('Solenis v1').Policy_Id__c;
        //System.debug('<<3>>'+schedulingPolicyId);
        for (ServiceAppointment sa : scope) 
        {
           //sa.FSL__Auto_Schedule__c=true;
           if(!Test.isRunningTest()){
           myResult = FSL.ScheduleService.schedule(PolicyId,sa.Id);
           }
           System.debug('<<1>>'+ myResult);

        }
        
    }    
    global void finish(Database.BatchableContext bc){
        
    }    
}