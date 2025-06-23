global class BatchApexforLightningDefault_scheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
            BatchApexforLightningDefault_User LU= new  BatchApexforLightningDefault_User(); 
        database.executebatch(LU,200);
   }
}