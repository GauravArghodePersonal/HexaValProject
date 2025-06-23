@isTest
private class BCS_DataAccessorTest {
    
    /**
     * @description Test method for getBarCodeScannerConfigurations method
     * @author      Lavakusa
     * @date        Created:
     */
    @isTest static void getBarCodeScannerConfigurationsTest() {
        Test.startTest();
        List<Barcode_Scanner_SObject_Configuration__mdt> configs = BCS_DataAccessor.getBarCodeScannerConfigurations(false);
        Test.stopTest();
        System.assert(!configs.isEmpty(), 'getBarCodeScannerConfigurations - not working as expected!');
    }

    /**
     * @description Test method for getSearchResults method
     * @author      Lavakusa
     * @date        Created:
     */
    @isTest static void getSearchResultsTest() {
        Test.startTest();
        List<List<SObject>> result = BCS_DataAccessor.getSearchResults('test', 'ALL FIELDS', 'RETURNING  Account(Id)');
        Test.stopTest();
        System.assert(!result.isEmpty(), 'getSearchResults - not working as expected!');
    }

     /**
     * @description Test method for getRecordTypes method
     * @author      Lavakusa
     * @date        Created:
     */
    @isTest static void getRecordTypesTest() {
        Test.startTest();
        List<RecordType> result = BCS_DataAccessor.getRecordTypes('Asset');
        Test.stopTest();
        System.assert(!result.isEmpty(), 'getRecordTypes - not working as expected!');
    }
}