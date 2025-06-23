global class LATAMscheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {

      LATAM_schedule myBatchObject = new LATAM_schedule(); 
      Database.executeBatch(myBatchObject);
   }
}