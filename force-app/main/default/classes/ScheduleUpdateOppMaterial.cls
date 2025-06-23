global class ScheduleUpdateOppMaterial implements schedulable{
    
    global void execute(Schedulablecontext sc){
        BatchUpdatePriceFX UpdatePrice = New BatchUpdatePriceFX();
        Database.executeBatch(UpdatePrice);
    }

}