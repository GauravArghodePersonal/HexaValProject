global class FSL_ReSchedule_S_Appoinment_Scheduler implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    FSL_Reschedule_Service_Appoinment b = new FSL_Reschedule_Service_Appoinment(); //ur batch class
      database.executebatch(b,200);
    }
}