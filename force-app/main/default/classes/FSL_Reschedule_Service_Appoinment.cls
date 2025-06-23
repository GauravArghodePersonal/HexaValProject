global class FSL_Reschedule_Service_Appoinment implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    return Database.getQueryLocator('select id,StartDate,EndDate,Accountid,Assetid,Status,(select id from ServiceAppointments) from WorkOrder where StartDate = NEXT_N_DAYS:21  and Status=\'Draft\'');
    }
    global void execute(Database.BatchableContext BC,List<WorkOrder> scope){
        List<ServiceAppointment> ServiceAppointmentList= New List<ServiceAppointment>();
            For(WorkOrder WO:scope){
                if(WO.ServiceAppointments.size()<1){
                ServiceAppointment sa = New ServiceAppointment();
                    sa.Status = 'None';
                    sa.EarliestStartTime=WO.StartDate-4;
                    sa.DueDate=WO.StartDate+4;
                    sa.ParentRecordId=WO.id;
                    ServiceAppointmentList.add(sa);
                    }
            }
            
            insert ServiceAppointmentList;
           system.debug('<<ServiceAppointmentList>>'+ServiceAppointmentList);
        
    }
    global void finish(Database.BatchableContext BC){
        
    }


}