global class update_FY_VA_scheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
        update_FY_VA VA = new update_FY_VA(); 
        database.executebatch(VA,200);
   }
}