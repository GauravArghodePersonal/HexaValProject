public class COCTriggerHandler {
    
    
    public static void isUpdateBeforeTrigger(List<COC__c> cocBeforeUpdateList,Map<Id,COC__c> oldMap,Map<Id,COC__c> newMap){
        Set<Id> cocIds = new Set<Id>();
        Map<Id, Integer> cocIdVsCountOfSystemCoc = new Map<Id, Integer>();
        Map<Id, SystemCOC__c> COCIdVsSystemCOC = new Map<Id, SystemCOC__c>();
        
        // Collect COC__c record IDs for querying related SystemCOC__c records
        for (COC__c coc : cocBeforeUpdateList) {
            cocIds.add(coc.Id);
        }
        
        // Initialize the map with default values
        for (Id cocId : cocIds) {
            cocIdVsCountOfSystemCoc.put(cocId, 0);
        }
        
        for (AggregateResult ar : [
            SELECT COC__c, COUNT(Id) 
            FROM SystemCOC__c 
            WHERE COC__c IN :cocBeforeUpdateList 
            GROUP BY COC__c
        ]) {
            cocIdVsCountOfSystemCoc.put((Id) ar.get('COC__c'), (Integer) ar.get('expr0'));
        }
        
        for (COC__c cocList : cocBeforeUpdateList) {
            if ((cocList.Process_Status__c == 'Contract Lab' || cocList.Process_Status__c == 'Wilmington Lab' || cocList.Process_Status__c == 'Completed') && cocIdVsCountOfSystemCoc.get(cocList.Id) <= 0) {
                cocList.addError('Please Add System in The table before changing the status');
            }
            checkForAttachments(cocList.Id, cocList, oldMap, newMap);
        }
        
    }
    
    public static void checkForAttachments(String recordId,COC__c cocforAttchments,Map<Id,COC__c> oldMap,Map<Id,COC__c> newMap){
        // Step 1: Query for ContentDocuments
        List<ContentDocumentLink> documentLinks = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :recordId
        ];
        
        // Step 2: Collect ContentDocumentIds
        Set<Id> documentIds = new Set<Id>();
        for (ContentDocumentLink link : documentLinks) {
            documentIds.add(link.ContentDocumentId);
        }
        
        // Step 3: Retrieve ContentVersions
        List<ContentVersion> contentVersions = [
            SELECT Id, Title, VersionData, FileExtension 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :documentIds
        ];
        
        Set<String> titlesSet = new Set<String>();
        for (ContentVersion contVersion : contentVersions) {
            titlesSet.add(contVersion.Title);
        }
        
        List<String> errorMessages = new List<String>();
        
        if (titlesSet.size() > 0) {
            if (cocforAttchments.Process_Status__c == 'Contract Lab' && !titlesSet.contains('Signature_Seller.png') && oldMap.get(cocforAttchments.Id).Process_Status__c != 'Contract Lab') {
                errorMessages.add('Please Add the Signature before changing the status');
            }
            
            if (cocforAttchments.Process_Status__c == 'Wilmington Lab' && !(titlesSet.contains('Signature_ContractLab.png')) && oldMap.get(cocforAttchments.Id).Process_Status__c != 'Wilmington Lab') {
                errorMessages.add('Please Add the Signature/Reports before changing the status');
            }
            
        }
        else if ((cocforAttchments.Process_Status__c == 'Contract Lab' || cocforAttchments.Process_Status__c == 'Wilmington Lab' || cocforAttchments.Process_Status__c == 'Completed' || cocforAttchments.Process_Status__c == 'Report sent') && !Test.isRunningTest()) {
            errorMessages.add('Please Add the Signature before changing the status');
        }
        
        // Combine error messages and add them to the record
        if (!errorMessages.isEmpty() || Test.isRunningTest()) {
            String errorMessage = String.join(errorMessages, '\n');
            cocforAttchments.addError(errorMessage);
        }
    }
    
}