@isTest
public class PricingConditionExpirationSchedulable_T{
 @isTest static void PricingConditionExpirationSchedulablemethod(){
     Test.startTest();
     PricingConditionExpirationSchedulable sh1 = new PricingConditionExpirationSchedulable();
     String sch = '0 0 6 * * ?';
     system.schedule('Test Shedule', sch, sh1);
     Test.stopTest();
  }
}