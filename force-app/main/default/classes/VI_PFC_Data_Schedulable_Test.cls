@isTest
public class VI_PFC_Data_Schedulable_Test{
  @isTest static void VI_PFC_Data_Schedulablemethod(){
    Test.startTest();
    VI_PFC_Data_Schedulable sh1 = new VI_PFC_Data_Schedulable(VI_PFC_Data_Batchable.PROC_STEP_DELETE);
    VI_PFC_Data_Schedulable  sh2 = new VI_PFC_Data_Schedulable (VI_PFC_Data_Batchable.PROC_STEP_CREATE);
    String sch = '0 0 13 * * ?';
    String sch1 =   '0 0 20 * * ?';
    system.schedule('Test Shedule', sch, sh1);
    system.schedule('Test Shedule1', sch1, sh2);
    Test.stopTest();
   }
}