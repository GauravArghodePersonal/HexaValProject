public with sharing class ForecastProDataController {
	@AuraEnabled
    public static Boolean insertForecastProRecord(List<Forecast_PRO__c> arrForecastPro) {
        system.debug(arrForecastPro);
        Database.SaveResult[] srForecastPro = Database.insert(arrForecastPro);
        if(srForecastPro != null && srForecastPro[0].isSuccess()) {
            return true;
        } else {
            return false;
        }
    }
}