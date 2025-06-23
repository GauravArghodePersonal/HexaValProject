public class VA_Update_ctrl {
    /* Created By Sandeep Kobaku 
     * Test Class - ValueAdvatageTriggerHandlertest
     * Coverage 100%. 
     * Date - 04-12-2022 */
    @AuraEnabled
    public static ValueAdvantage__c getValueAdvantageById(String ValuerecId){
        if(String.isNotBlank(ValuerecId)){
        	return [SELECT Id, Project_Status__c FROM ValueAdvantage__c WHERE Id=:ValuerecId];
        }
        return null;
    }

}