@isTest
private class PricingConditionActivationSchedulable_T{
 @isTest static void PricingConditionActivationSchedulablemethod(){
    Test.startTest();
    PricingConditionActivationSchedulable sh1 = new PricingConditionActivationSchedulable();
    String sch = '0 0 * * * ?';
    system.schedule('Test Shedule', sch, sh1);
    Test.stopTest();
 }
}