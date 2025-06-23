global class ScheduleUpdateOppMatCurrency implements schedulable{
    
    global void execute(schedulablecontext sc){
        BatchUpdateOpp OppMatCurrency= new BatchUpdateOpp();
        Database.executeBatch(OppMatCurrency);
    }

}