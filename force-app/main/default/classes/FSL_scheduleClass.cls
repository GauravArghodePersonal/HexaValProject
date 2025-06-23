public class FSL_scheduleClass{
    public static string scheduleAppointment(ServiceAppointment sas){
        string result = '';
        try{
            
            Id schedulingPolicyId = [SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name='LATAM' limit 1].Id;
            FSL.ScheduleResult myResult = new FSL.ScheduleResult();
            myResult = FSL.ScheduleService.schedule(schedulingPolicyId,sas.Id); 
            System.debug('myResult>>'+myResult);
            result = 'success';
            return result;
        }
        catch(Exception e){
            system.debug('<<<<<>>>>>'+e);
            return result = '';    
        }
  
    }
}