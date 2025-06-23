@isTest
public class ProductDCFRORCtrl_T {
    @isTest 
    static void getUSDConversionRateTest(){
        Decimal result = ProductDCFRORCtrl.getUSDConversionRate('EUR');
        assert.isNotNull(result);
    }
}