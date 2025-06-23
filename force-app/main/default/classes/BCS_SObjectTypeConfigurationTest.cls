@isTest
private class BCS_SObjectTypeConfigurationTest {
    
    /**
     * @description Test method for BCS_SObjectTypeConfiguration
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     */
    @isTest static void createInstanceTest() {
        Test.startTest();
        BCS_SObjectTypeConfiguration result = new BCS_SObjectTypeConfiguration();
        result.fields = new List<BCS_SObjectTypeConfiguration.FieldConfiguration>();
        result.fields.add(new BCS_SObjectTypeConfiguration.FieldConfiguration());
        Test.stopTest();

        System.assertEquals('', result.fields[0].fieldName, 'Something went wrong!');
    }
}