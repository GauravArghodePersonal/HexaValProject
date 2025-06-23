public class ProductDCFRORCtrl {
   //used while New Product creation - Currency rate conversion (LWC SolenisProductDCFROR)
  @AuraEnabled(cacheable=true)
  public static Decimal getUSDConversionRate(String currencyIsoCode) {
	Decimal conversionRate = 0.0;
	if(String.isNotBlank(currencyIsoCode)){
		CurrencyType cType = [SELECT Id, ConversionRate FROM CurrencyType WHERE IsoCode = :currencyIsoCode AND IsActive = TRUE];
		conversionRate = cType.ConversionRate;
	}
	//system.debug('converison rate'+conversionRate);
 	return conversionRate;
  } 
}