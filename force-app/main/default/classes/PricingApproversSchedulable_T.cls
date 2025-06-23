@isTest
private class PricingApproversSchedulable_T{
 @isTest static void PricingApproversSchedulablemethod(){
    Test.startTest();
    PricingApproversSchedulable sh1 = new PricingApproversSchedulable();
    String sch = '0 0 5 * * ?';
    system.schedule('Test Shedule', sch, sh1);
    Test.stopTest();
 }
}