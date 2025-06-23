global class LATAM_schedule implements Database.Batchable<sObject> {
    
        
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select id from ServiceAppointment where LATAM_scheduling__c = true AND Status = \'None\' and Called_Scheduled_Service__c = false';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ServiceAppointment> scope) {
        List<ServiceAppointment> succSA = new List<ServiceAppointment>();
        for (ServiceAppointment sa : scope){
            string result = '';
            result = FSL_scheduleClass.scheduleAppointment(sa);
            if(result == 'success'){
                sa.Called_Scheduled_Service__c = true;
                succSA.add(sa);   
            }
            
        }       
    }   
     
    global void finish(Database.BatchableContext BC) {
    
    }
}