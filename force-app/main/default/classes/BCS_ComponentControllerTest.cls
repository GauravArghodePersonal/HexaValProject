@isTest
private class BCS_ComponentControllerTest {
    
    /**
     * @description Test method for getSObjectTypeConfiguration 
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     */
    @isTest static void getSObjectTypeConfigurationTest() {
        Account acc = TestDataFactory.createAccount(false);
        acc.ParentId = null;
        Insert acc;
        String barcodeNumber = 'ABC123';
        Asset equip = TestDataFactory.createAsset(false, acc.Id);
        equip.Bar_code_number__c = barcodeNumber;
        Insert equip;

        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = equip.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        BCS_SObjectTypeConfiguration result = BCS_ComponentController.getSObjectTypeConfiguration(barcodeNumber, '');
        Test.stopTest();

        System.assert(!result.fields.isEmpty(), 'getSObjectTypeConfiguration - not working as expected!' );
    }
}