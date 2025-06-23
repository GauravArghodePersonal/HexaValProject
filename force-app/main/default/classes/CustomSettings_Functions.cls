public with sharing class CustomSettings_Functions {

    private static final String CRNL = '\r\n';
    private static final CustomSettings__c CUSTOM_SETTINGS = CustomSettings__c.getOrgDefaults();

    private static Map<String, Object_Field_Ids__c> objectFieldIds;

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'CustomSettings_Functions : ' + s);
    }

    public static Date getBW_Data_Start_Date() {
        Date sDate = null;
        if (CUSTOM_SETTINGS != null) {
            sDate = CUSTOM_SETTINGS.BW_Data_Start_Date__c;
        }
        if (sDate == null) {
            sDate = System.Today().addMonths(-1);
        }
        return sDate;
    }

    public static String getBW_Data_BatchSize() {
        String s = null;
        if (CUSTOM_SETTINGS != null) {
            s = CUSTOM_SETTINGS.BW_Data_BatchSize__c;
        }
        if (s == null || s.trim().length() == 0) {
            s = '200';
        }
        return s;
    }

    public static String getBW_Data_LastModified_DateTime() {
        DateTime sdt = null;
        if (CUSTOM_SETTINGS != null) {
            sdt = CUSTOM_SETTINGS.BW_Data_LastModified_DateTime__c;
        }
        if (sdt == null) {
            sdt = DateTime.now();
        }
        String s = sdt.format('yyyy-MM-dd HH:mm:ss.SSS');
        s = s.substring(0, 10) + 'T' + s.substring(11) + 'Z';
        return s;
    }

    public static Boolean getBW_Data_Updating() {
        if (CUSTOM_SETTINGS != null) {
            return CUSTOM_SETTINGS.BW_Data_Updating__c;
        }
        return false;
    }

    public static Boolean ignoreApexTrigger() {
        if (CUSTOM_SETTINGS != null) {
            return CUSTOM_SETTINGS.Ignore_Apex_Trigger__c;
        }
        return false;
    }

    public static Map<String, Object_Field_Ids__c> getObjectFieldIds() {
        if (objectFieldIds == null) {objectFieldIds = Object_Field_Ids__c.getAll();}
        return objectFieldIds;
    }

    public static String getObjectFieldId(String key) {
        getObjectFieldIds(); if (!objectFieldIds.containsKey(key)) {return null;}
        return objectFieldIds.get(key).Field_Id__c;
    }
}