global with sharing class PriceBookActivationSchedulable implements Schedulable {

    public static final Integer BATCH_SIZE = PriceBookActivationBatchable.BATCH_SIZE;

    global void execute(SchedulableContext sc) {
        PriceBookActivationBatchable pbab = new PriceBookActivationBatchable();
        Id processId;
        try {
            processId = Database.executeBatch(pbab, BATCH_SIZE);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
    }
}