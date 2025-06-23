global class CCRToSAPQuaterlyJobScheduale implements Schedulable{
    global void execute(SchedulableContext SC){
        CCRtoSAPQuaterlyJob cr = new CCRtoSAPQuaterlyJob();
        database.executebatch(cr,5);
        
    }

}