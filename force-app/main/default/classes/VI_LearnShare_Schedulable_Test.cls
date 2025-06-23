@isTest
public class VI_LearnShare_Schedulable_Test{
 @isTest static void VI_LearnShare_Schedulablemethod(){
    Test.startTest();
    VI_LearnShare_Schedulable sh1 = new VI_LearnShare_Schedulable(VI_LearnShare_Batchable.PROC_STEP_DELETE);
    VI_LearnShare_Schedulable sh2 = new VI_LearnShare_Schedulable(VI_LearnShare_Batchable.PROC_STEP_CREATE);
    String sch = '0 0 17 30 * ?';
    String sch1 =  '0 0 19 30 * ?';
    system.schedule('Test Shedule', sch, sh1);
     system.schedule('Test Shedule1', sch1, sh2);
    Test.stopTest();
   }
}