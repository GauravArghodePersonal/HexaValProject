public with sharing class BCS_ComponentController {
    
    @AuraEnabled
    public static BCS_SObjectTypeConfiguration getSObjectTypeConfiguration(String barcodeId, String searchKeyword) {
        List<Barcode_Scanner_SObject_Configuration__mdt> configurations = BCS_ServiceClass.getConfigurations(String.isNotBlank(searchKeyword));
        String returningFieldSpec = BCS_ServiceClass.getReturningFieldSpec(configurations);
        List<List<SObject>> relatedRecords = BCS_ServiceClass.getBarcodeLinkedRecord(String.isNotBlank(barcodeId) ? barcodeId : searchKeyword.toLowerCase(), 'ALL FIELDS', returningFieldSpec);
        BCS_SObjectTypeConfiguration sobjTypeConfigRecord = BCS_ServiceClass.getSObjectSpecificConfigurationWrapper(configurations, relatedRecords, String.isBlank(barcodeId));
        return sobjTypeConfigRecord;
    }
}