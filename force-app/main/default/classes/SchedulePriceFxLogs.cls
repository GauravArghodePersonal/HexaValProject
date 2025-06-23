global class SchedulePriceFxLogs implements Schedulable{
   global void execute(SchedulableContext sc) {
        PriceFxLogMaintenance b = new PriceFxLogMaintenance();
        database.executebatch(b);
   }
}