/**
 * @description
 */
public without sharing class CQ_SL_Utilities {
    
    /**
     *@description  Determines if custom triggers are to be disabled
     *@return A Boolean value indicating whether custom triggers should be disable.
     */
    public static Boolean disableCQCustomTriggers() {
        CQ_SL_SQX_Trigger_Settings__c cqSlTriggerSettings = CQ_SL_SQX_Trigger_Settings__c.getInstance();
        return cqSlTriggerSettings.CQ_SL_Disable_All_CQ_Custom_Triggers__c;
    }

}