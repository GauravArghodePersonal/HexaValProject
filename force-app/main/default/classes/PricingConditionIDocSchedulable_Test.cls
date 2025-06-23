@isTest
private class PricingConditionIDocSchedulable_Test{
 @isTest static void PricingConditionIDocSchedulablemethod(){
    Test.startTest();
    PricingConditionIDocSchedulable sh1 = new PricingConditionIDocSchedulable();
    String sch = '0 15 * * * ?';
    system.schedule('Test Shedule', sch, sh1);
    Test.stopTest();
    new PricingConditionIDocSchedulable().execute(null);
 }
}