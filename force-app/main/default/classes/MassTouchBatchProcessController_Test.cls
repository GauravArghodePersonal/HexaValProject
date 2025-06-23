@isTest
private class MassTouchBatchProcessController_Test{
    @isTest static void MassTouchBatchProcessControllermethod (){
    String objectName ='Test';
    Integer recordLimit = 50000000;
    Integer batchSize = 200;
    MassTouchBatchProcessController controller = new MassTouchBatchProcessController();  
    controller.submitUpdateBatchJob();
    controller.submitDeleteBatchJob();
    controller.getDateTimeString();
    }
 }