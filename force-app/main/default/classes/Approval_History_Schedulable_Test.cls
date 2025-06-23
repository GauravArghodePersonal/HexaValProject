@isTest
public class Approval_History_Schedulable_Test{
 @isTest static void Approval_History_Schedulablemethod(){
    Test.startTest();
    Approval_History_Schedulable sh1 = new Approval_History_Schedulable (Approval_History_Batchable.PRICING_CONDITION, 1);
    String sch = '0 0 2 * * ?';
    system.schedule('Test Shedule', sch, sh1);
    Test.stopTest();
    }
 }