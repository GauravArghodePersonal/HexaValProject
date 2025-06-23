public without sharing class BCS_Utilis {
    
    /**
     * @description Get returning field spec string
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     * @param       configs Bar code scanner configurations
     * @return      Returning FieldSpec
     */
    public static string getReturningFieldSpec(List<Barcode_Scanner_SObject_Configuration__mdt> objectConfigs) {
        String returningFieldSpec = 'RETURNING ';
        for (Barcode_Scanner_SObject_Configuration__mdt objectConfig : objectConfigs) {
            returningFieldSpec += objectConfig.SObject_Type__c;
            String fields = 'Id, Name';
            for (Barcode_Scanner_Field_Configuration__mdt fieldConfig : objectConfig.Field_Configurations__r) {
                if (fieldConfig.Field_API_Name__c != 'Name') {
                    fields += ' ' + ',' + fieldConfig.Field_API_Name__c;
                }
            }
            fields = String.isNotBlank(fields) ? ('(' + fields + ')') : fields;
            returningFieldSpec += fields + ',';
        }
        return returningFieldSpec.removeEnd(',');
    }

    /**
     * @description Get Barcode Scanner Object Configurations Map
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     * @param       configs Bar code scanner configurations
     * @return      Barcode Scanner Object Configurations Map
     */
    public static Map<String, Barcode_Scanner_SObject_Configuration__mdt> getConfigurationMap(List<Barcode_Scanner_SObject_Configuration__mdt> configs) {
        Map<String, Barcode_Scanner_SObject_Configuration__mdt> configurationMap = new Map<String, Barcode_Scanner_SObject_Configuration__mdt>();
        for (Barcode_Scanner_SObject_Configuration__mdt config : configs) {
            configurationMap.put(config.SObject_Type__c, config);
        }
        return configurationMap;
    }

    /**
     * @description Get Object's Tab Icon
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     */
    public static String getObjectSpecificIconName(String sObjectName) {
        String tabIconName = '';
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();

        for (Schema.DescribeTabSetResult tsr : tabSetDesc) {
            tabDesc.addAll(tsr.getTabs());
        }

        for (Schema.DescribeTabResult tr : tabDesc) {
            if (sObjectName == tr.getSobjectName()) {
                if (tr.isCustom() == true) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    tabIconName = 'standard:' + sObjectName.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml') {
                tabIconName = 'custom:' + ir.getUrl().substringBetween('custom/', '.svg').substringBefore('_');
                break;
            }
        }


        return appendTextToIconName(tabIconName);
    }

    /**
     * @description Append text to icon name to obtain the icon
     * @author      Lavakusa
     * @date        Created: 14-Jul-2022
     */
    private static String appendTextToIconName(String iconName) {
        iconName = iconName.toLowerCase();
        switch on iconName {
            when 'standard:asset' {
                iconName += '_object';
            }
        }

        return iconName;
    }
}