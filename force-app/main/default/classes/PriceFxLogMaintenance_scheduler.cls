global class PriceFxLogMaintenance_scheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
        PriceFxLogMaintenance sm = new PriceFxLogMaintenance();
        Database.executeBatch(sm,200);

   }
}