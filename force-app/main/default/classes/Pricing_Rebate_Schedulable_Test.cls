@isTest
private class Pricing_Rebate_Schedulable_Test{
 @isTest static void Pricing_Rebate_SchedulableMethod (){
   Test.startTest();
   Pricing_Rebate_Schedulable P1 = new Pricing_Rebate_Schedulable();
   String sch = '0 0 * * * ?';
   system.schedule('Test Shedule', sch, P1);
    Test.stopTest();
    }
    }