public with sharing class BCS_SObjectTypeConfiguration {

    @AuraEnabled
    public String objectName                { get; set; }
    @AuraEnabled
    public String objectLabel               { get; set; }
    @AuraEnabled
    public String tabIcon                   { get; set; }
    @AuraEnabled
    public List<String> recordIds           { get; set; }
    @AuraEnabled
    public String recordTypeId              { get; set; }
    @AuraEnabled
    public String layoutType                { get; set; }
    @AuraEnabled
    public String mode                      { get; set; }
    @AuraEnabled
    public List<FieldConfiguration> fields  { get; set; }

    /**
     * @description Barcode scanner field configuration wrapper Class
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     */
    public class FieldConfiguration {
        @AuraEnabled
        public String fieldName                 { get; set; }
        @AuraEnabled
        public Boolean isEditable               { get; set; }
        @AuraEnabled
        public Boolean isDisplayOnUI            { get; set; }
        @AuraEnabled
        public Boolean isDisplayOnSearchTableUI { get; set; }

        public FieldConfiguration() {
            this.fieldName     = '';
            this.isEditable    = false;
            this.isDisplayOnUI = false;
            this.isDisplayOnSearchTableUI = false;
        }

        public FieldConfiguration(String fieldAPI, Boolean editableField, Boolean displayOnUI, Boolean searchTableDisplay) {
            this.fieldName     = fieldAPI;
            this.isEditable    = editableField;
            this.isDisplayOnUI = displayOnUI;
            this.isDisplayOnSearchTableUI = searchTableDisplay;
        }
    }
}