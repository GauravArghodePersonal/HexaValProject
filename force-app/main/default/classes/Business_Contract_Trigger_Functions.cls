public class Business_Contract_Trigger_Functions {

    private static final String DELIM = '-';
    private static final Map<Id, Schema.RecordTypeInfo> RT_MAP1 = 
        Schema.SObjectType.Business_Contract__c.getRecordTypeInfosById();
    //, 'AHWT Business Contract'    
    private static final Set<String> RT_SET1 = new Set<String>{
    	'ASI Business Contract'
    };
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Business_Contract_Trigger_Functions : ' + s);
    }

    public static void doBeforeUpsert(List<Business_Contract__c> bcs) {
    	Set<Id> accIds = new Set<Id>();
        Map<Id, Id> accOwners = new Map<Id, Id>();
    	for (Business_Contract__c bc : bcs) {accIds.add(bc.Customer_Name__c);}
    	for (Account a : [select Id, OwnerId from Account where Id in :accIds]) {
            accOwners.put(a.Id, a.OwnerId);
        } 
        setOwnerId(bcs, accOwners);
    }
    
    private static void setOwnerId(List<Business_Contract__c> bcs, Map<Id, Id> accOwners) {
        String rectype;
        for (Business_Contract__c bc : bcs) {
        	rectype = RT_MAP1.get(bc.RecordTypeId).getName();
            if (RT_SET1.contains(rectype) && accOwners.containsKey(bc.Customer_Name__c)) {
                bc.OwnerId = accOwners.get(bc.Customer_Name__c);
            }
        }
    }   
    
    private static Map<Id, Business_Contract__c> getBCMap(Set<Id> accIds) {
        Map<Id, Business_Contract__c> bcMap = new 
        Map<Id, Business_Contract__c>();
        for (Business_Contract__c bc : [select Id, Customer_Name__c, RecordTypeId 
                                          from Business_Contract__c
                                         where Customer_Name__c in :accIds]) {
            bcMap.put(bc.Id, bc);
        }
        return bcMap;
    }

    public static void updateOwnerId(Map<Id, Id> accOwners) {
        Set<Id> accIds = accOwners.keySet();
        Map<Id, Business_Contract__c> bcMap = getBCMap(accIds);
        List<Business_Contract__c> bcs = bcMap.values();
        setOwnerId(bcs, accOwners);
        try {update bcs;} catch(Exception e) {debug(e.getMessage());} 
    }
    
/*    
    public static void updateSharing(Map<Id, Id> newOwners, Map<Id, Id> oldOwners) {
        Set<Id> accIds = newOwners.keySet();
        Map<Id, Business_Contract__c> bcMap = getBCMap(accIds); 
        Set<Id> bcIds = bcMap.keySet();
        Map<String, Business_Contract__Share> bcsMap = new 
        Map<String, Business_Contract__Share>();
        for (Business_Contract__Share bcs : [select Id, ParentId, UserOrGroupId 
                                               from Business_Contract__Share
                                              where ParentId in :bcIds]) {
            bcsMap.put(bcs.ParentId + DELIM + bcs.UserOrGroupId, bcs);
        }
    }
*/
}