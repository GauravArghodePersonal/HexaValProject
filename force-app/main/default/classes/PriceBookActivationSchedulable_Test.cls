@isTest
public class PriceBookActivationSchedulable_Test{
 @isTest static void PriceBookActivationSchedulablemethod(){
    Test.startTest();
    PriceBookActivationSchedulable sh1 = new PriceBookActivationSchedulable();
    String sch = '0 0 * * * ?';
    system.schedule('Test Shedule', sch, sh1);
    Test.stopTest();
   }
}