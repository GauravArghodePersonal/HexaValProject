@isTest
private class PricingConditionApproversSchedulable_T{
 @isTest static void PricingConditionApproversSchedulablemethod(){
    Test.startTest();
    PricingConditionApproversSchedulable sh1 = new PricingConditionApproversSchedulable();
    String sch = '0 0 7 * * ?';
    system.schedule('Test Shedule', sch, sh1);
    Test.stopTest();
 }
}