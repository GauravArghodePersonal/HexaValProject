global class scheduleReprocessPriceFx implements Schedulable {
   global void execute(SchedulableContext SC) {
      string res = reprocessPriceFx.reProcess();
      system.debug('Response>>'+res);
   }
}