global class ScheduleCloseCase implements Schedulable{
    public Boolean testMode=false;
    String batchQuery;  
   global void execute(SchedulableContext sc) {
        Date d=date.valueOf(Date.today().addDays(-365));
        //Reorg2015-Changing role from "US MM AD" to "US MM CET DIR"
       // batchQuery='Select Id,CaseId from WorkOrder where Status=\'Completed\' and Completed_Date_Formula__c=TODAY';
       //batchQuery='Select Id,CaseId from WorkOrder where RecordTypeId in (SELECT Id FROM RecordType WHERE Name = \'ESR-Tank / Tank Request\') and Status=\'Completed\' and case.status= \'In Scheduling\' and Completed_Date_Formula__c <= TODAY';
         batchQuery ='Select Id,CaseId from WorkOrder where RecordTypeId NOT in (SELECT Id FROM RecordType WHERE Name = \'Tank WorkOrder\') and Status=\'Completed\' and case.status= \'In Scheduling\' and Completed_Date_Formula__c <= TODAY';
        batchQuery += this.Testmode ? ' LIMIT 200':'';
        System.debug('batchquery---SFDCSupport'+batchQuery);
        //BatchCloseCase b = new BatchCloseCase(batchQuery);
        BulkCloseCase b = new BulkCloseCase(batchQuery);
        database.executebatch(b);
   }
}