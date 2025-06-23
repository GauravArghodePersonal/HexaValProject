public without sharing class BCS_ServiceClass {

    /**
    * @description Obtain Bar Code Scanner Configurations
    * @author      Lavakusa
    * @date        Created: 14-Jul-2022
    * @return      Bar code scanner Configuration records
    */
    public static List<Barcode_Scanner_SObject_Configuration__mdt> getConfigurations(Boolean searchConfiguration) {
        return BCS_DataAccessor.getBarCodeScannerConfigurations(searchConfiguration);
    }

    /**
     * @description Obtain Barcode Scanner SOSL Query Returning FieldSpec
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     * @param       configs Bar code scanner configurations
     * @return      SOSL Returning FieldSpec String
     */
    public static String getReturningFieldSpec(List<Barcode_Scanner_SObject_Configuration__mdt> configs) {
        return BCS_Utilis.getReturningFieldSpec(configs);
    }

    /**
    * @description Search for records based on barcode id
    * @author      Lavakusa
    * @date        Created: 14-Jul-2022
    * @param       barcodeId Bar code Identifier
    * @param       searchGroup Scope of fields to search
    * @param       returningFieldSpec Information to return in the search result
    * @return      List of SObject records contains the barcode identifier value
    */
    public static List<List<SObject>> getBarcodeLinkedRecord(String barcodeId, String searchGroup, String returningFieldSpec) {
        return BCS_DataAccessor.getSearchResults(barcodeId, searchGroup, returningFieldSpec);
    }

    /**
     * @description Create Bar Code Scanner Configuration Wrapper records based on search results
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     * @param       configurations Bar code scanner Configuration records
     * @param       searchResults Scanner Code Records
     * @return      Bar Code Scanner Configuration Wrapper records
     */
    public static BCS_SObjectTypeConfiguration getSObjectSpecificConfigurationWrapper(List<Barcode_Scanner_SObject_Configuration__mdt> configurations, List<List<SObject>> searchResults, Boolean isSearchContext) {
        BCS_SObjectTypeConfiguration wrapperInstance = new BCS_SObjectTypeConfiguration();
        Map<String, Barcode_Scanner_SObject_Configuration__mdt> configurationMap = BCS_Utilis.getConfigurationMap(configurations);
        if (!searchResults.isEmpty()) {
            List<SObject> searchResult = getNonEmptySObjectList(searchResults);
            wrapperInstance = createSObjectConfigurationWrapper(configurationMap, searchResult, isSearchContext);
        }
        return wrapperInstance;
    }

    /**
     * @description Creates Configuration Wrapper Record
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     * @param       configuration Bar Code Scanner Object Configuration record
     * @param       searchResults Search result SObject records
     * @param       BarCode Scanner Configuration Wrapper Records
     */
    @TestVisible private static BCS_SObjectTypeConfiguration createSObjectConfigurationWrapper(Map<String, Barcode_Scanner_SObject_Configuration__mdt> configurationMap, List<SObject> searchResults, Boolean isSearchContext) {
        if (!configurationMap.isEmpty() && !searchResults.isEmpty()) {
            DescribeSObjectResult sObjectDescResult = searchResults[0].getSObjectType().getDescribe();
            String sObjectType = String.valueOf(sObjectDescResult.getName());
            String sObjectLabel = String.valueOf(sObjectDescResult.getLabel());
            String tabIconName = BCS_Utilis.getObjectSpecificIconName(sObjectType);
            List<RecordType> recordTypes = BCS_DataAccessor.getRecordTypes(sObjectType);

            Barcode_Scanner_SObject_Configuration__mdt objectConfig = configurationMap.get(sObjectType);
            BCS_SObjectTypeConfiguration objectConfigInstance = new BCS_SObjectTypeConfiguration();
            objectConfigInstance.objectName = sObjectType;
            objectConfigInstance.objectLabel = sObjectLabel;
            objectConfigInstance.tabIcon = tabIconName;
            objectConfigInstance.layoutType = objectConfig.Layout_Type__c;
            objectConfigInstance.mode = objectConfig.Mode__c;
            objectConfigInstance.recordIds = getRecordsId(searchResults);
            objectConfigInstance.recordTypeId = (!recordTypes.isEmpty()) ? String.valueOf(searchResults[0].get('RecordTypeId')) : null;

            List<BCS_SObjectTypeConfiguration.FieldConfiguration> fieldConfigWrappers = new List<BCS_SObjectTypeConfiguration.FieldConfiguration>();
            for (Barcode_Scanner_Field_Configuration__mdt fieldConfig : objectConfig.Field_Configurations__r) {
                BCS_SObjectTypeConfiguration.FieldConfiguration fieldConfigWrapper = new BCS_SObjectTypeConfiguration.FieldConfiguration(fieldConfig.Field_API_Name__c,
                        isSearchContext ? fieldConfig.Editable_On_UI_Record_Search__c : fieldConfig.Editable_On_UI__c,
                        fieldConfig.UI_Display__c, isSearchContext ? fieldConfig.Search_UI_Display__c : false);
                fieldConfigWrappers.add(fieldConfigWrapper);
            }

            objectConfigInstance.fields = fieldConfigWrappers;
            return objectConfigInstance;
        }

        return null;
    }

    /**
     * @description Obtain the non-empty sobject list
     * @author      Lavakusa
     * @date        Created: 27-jul-2022
     * @param       searchResults Search result SObject records
     */
    private static List<SObject> getNonEmptySObjectList(List<List<SObject>> searchResults) {
        for (List<SObject> searchResult : searchResults) {
            if (!searchResult.isEmpty()) {
                return searchResult;
            }
        }
        return new List<SObject>();
    }

     /**
     * @description Obtain the sobject records Id
     * @author      Lavakusa
     * @date        Created: 27-Aug-2022
     */
    private static List<String> getRecordsId(List<SObject> searchResults){
        List<String> recordsId = new List<String>();
        for(SObject sobj : searchResults) {
            recordsId.add(String.valueOf(sobj.get('Id')));
        }
        
        return recordsId;
    }
}