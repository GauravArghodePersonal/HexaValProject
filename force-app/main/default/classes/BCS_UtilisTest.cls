@isTest
private class BCS_UtilisTest {
    
    /**
     * @description Test method for getReturningFieldSpec method
     * @author      Lavakusa
     * @date        Created:
     */
    @isTest static void getReturningFieldSpecTest() {
        List<Barcode_Scanner_SObject_Configuration__mdt> configs = BCS_DataAccessor.getBarCodeScannerConfigurations(false);
        Test.startTest();
        String result = BCS_Utilis.getReturningFieldSpec(configs);
        Test.stopTest();
        System.assert(String.isNotBlank(result), 'getReturningFieldSpec - not working as expected!');
    }

    /**
     * @description Test method for getConfigurationMap method
     * @author      Lavakusa
     * @date        Created:
     */
    @isTest static void getConfigurationMapTest() {
        List<Barcode_Scanner_SObject_Configuration__mdt> configs = BCS_DataAccessor.getBarCodeScannerConfigurations(false);
        Test.startTest();
        Map<String, Barcode_Scanner_SObject_Configuration__mdt> result = BCS_Utilis.getConfigurationMap(configs);
        Test.stopTest();
        System.assert(!result.isEmpty(), 'getConfigurationMap - not working as expected!');
    }

     /**
     * @description Test method for getObjectSpecificIconName method
     * @author      Lavakusa
     * @date        Created:
     */
    @isTest static void getObjectSpecificIconNameTest() {
        Test.startTest();
        String result = BCS_Utilis.getObjectSpecificIconName('Asset');
        Test.stopTest();
        System.assert(String.isNotBlank(result), 'getObjectSpecificIconName - not working as expected!');
    }
}