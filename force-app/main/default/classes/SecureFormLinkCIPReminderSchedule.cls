global with sharing class SecureFormLinkCIPReminderSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        Database.executeBatch(new SecureFormLinkCIPReminderBatch());
    }
}