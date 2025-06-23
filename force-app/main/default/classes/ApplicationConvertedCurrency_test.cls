@isTest
private class ApplicationConvertedCurrency_test {
    private static testmethod void createApplication(){
        Application__c ap = new Application__c();
        ap.Name = 'Acid cleaning';
        ap.Annual_Revenue__c = 148000;
        ap.CurrencyIsoCode = 'CAD';
        ap.Supplier__c = 'ACI';
        insert ap;
    }
}