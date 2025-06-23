public with sharing class GEERReusedEquipmentController {
    private final static Integer MAX_RESULTS = 5;
    private final static String OBJECT_TYPE_ASSET = 'Asset';
    private final static String ICON_ASSET_OBJECT = 'standard:asset_object';

    @AuraEnabled(Cacheable=true)
    public static List<Solenis_Commercial_LookupSearchResult> search(String searchTerm, List<String> selectedIds, String geerId) {
        // Prepare query paramters
        searchTerm += '*';

        // Execute search query
        List<List<SObject>> searchResults = [
            FIND :searchTerm
            IN ALL FIELDS
            RETURNING
                Asset(Id, Equipment_Number__c, Name WHERE id NOT IN :selectedIds AND GEER__c != :geerId)               
            LIMIT :MAX_RESULTS
        ];

        // Prepare results
        List<solenis_Commercial_LookupSearchResult> results = new List<solenis_Commercial_LookupSearchResult>();

        // Extract Assets & convert them into LookupSearchResult
        Asset[] assets = (List<Asset>) searchResults[0];
        for (Asset a : assets) {
            results.add(
                new solenis_Commercial_LookupSearchResult(
                    a.Id,
                    OBJECT_TYPE_ASSET,
                    ICON_ASSET_OBJECT,
                    a.Equipment_Number__c + ' , ' + a.Name                   
                )
            );
        }

        // Optionnaly sort all results on title
        results.sort();

        return results;
    }

    @AuraEnabled
    public static void updateGEERWithAssets(String equipmentIdsJSON, Id geerId){
        try {
            SelectedEquipmentWrapper instance = (SelectedEquipmentWrapper) System.JSON.deserialize(equipmentIdsJSON, 
                                                                                                   SelectedEquipmentWrapper.class);
            Id accountId = [SELECT Id,Ship_To__c FROM GEER__c WHERE Id =:geerId].Ship_To__c;
            List<Asset> reusedEquipments = new List<Asset>();
            GEER__c geer = new GEER__c();
            geer.Id = geerId;
            if(String.isNotBlank(instance.firstLookup)){
                geer.Existing_EQ_One__c   = instance.firstLookup;
                reusedEquipments.add(new Asset(Id=instance.firstLookup,AccountId=accountId));
            }

            if(String.isNotBlank(instance.secondLookup)){
                geer.Existing_EQ_Two__c   = instance.secondLookup;
                reusedEquipments.add(new Asset(Id=instance.secondLookup,AccountId=accountId));
            }

            if(String.isNotBlank(instance.thirdLookup)){
                geer.Existing_EQ_Three__c = instance.thirdLookup;
                reusedEquipments.add(new Asset(Id=instance.thirdLookup,AccountId=accountId));
            }

            if(String.isNotBlank(instance.fourLookup)){
                geer.Existing_EQ_Four__c  = instance.fourLookup;
                reusedEquipments.add(new Asset(Id=instance.fourLookup,AccountId=accountId));
            }

            if(String.isNotBlank(instance.fiveLookup)){
                geer.Existing_EQ_Five__c  = instance.fiveLookup;
                reusedEquipments.add(new Asset(Id=instance.fiveLookup,AccountId=accountId));
            }

            update geer;
            update reusedEquipments;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,Solenis_Commercial_LookupSearchResult> getSelectedReuseEquipmentIds(String geerId) {
        // Prepare results
        Map<String,solenis_Commercial_LookupSearchResult> results = new Map<String, solenis_Commercial_LookupSearchResult>();

        List<GEER__c> geer = [SELECT Id, 
                                    Existing_EQ_One__c, 
                                    Existing_EQ_One__r.Equipment_Number__c,
                                    Existing_EQ_One__r.Name,
                                    Existing_EQ_Two__c, 
                                    Existing_EQ_Two__r.Equipment_Number__c,
                                    Existing_EQ_Two__r.Name,
                                    Existing_EQ_Three__c, 
                                    Existing_EQ_Three__r.Equipment_Number__c,
                                    Existing_EQ_Three__r.Name,
                                    Existing_EQ_Four__c, 
                                    Existing_EQ_Four__r.Equipment_Number__c,
                                    Existing_EQ_Four__r.Name,
                                    Existing_EQ_Five__c,
                                    Existing_EQ_Five__r.Equipment_Number__c,
                                    Existing_EQ_Five__r.Name 
                                FROM GEER__c 
                                WHERE Id = :geerId
                                LIMIT 1];
        if(!geer.isEmpty()) {
            if(String.isNotBlank(geer[0].Existing_EQ_One__c)) {
                String lookupLabel = geer[0].Existing_EQ_One__r.Equipment_Number__c + ' , ' + geer[0].Existing_EQ_One__r.Name;
                solenis_Commercial_LookupSearchResult result =  new solenis_Commercial_LookupSearchResult(
                                                                                                            geer[0].Existing_EQ_One__c,
                                                                                                            OBJECT_TYPE_ASSET,
                                                                                                            ICON_ASSET_OBJECT,
                                                                                                            lookupLabel                                                                                                        
                                                                                                        );
                results.put('firstEQ', result);
            }
    
            if(String.isNotBlank(geer[0].Existing_EQ_Two__c)) {
                String lookupLabel = geer[0].Existing_EQ_Two__r.Equipment_Number__c + ' , ' + geer[0].Existing_EQ_Two__r.Name;
                solenis_Commercial_LookupSearchResult result =  new solenis_Commercial_LookupSearchResult(
                                                                                                            geer[0].Existing_EQ_Two__c,
                                                                                                            OBJECT_TYPE_ASSET,
                                                                                                            ICON_ASSET_OBJECT,
                                                                                                            lookupLabel                                                                                                        
                                                                                                        );
                results.put('secondEQ', result);
            }
    
            if(String.isNotBlank(geer[0].Existing_EQ_Three__c)) {
                String lookupLabel = geer[0].Existing_EQ_Three__r.Equipment_Number__c + ' , ' + geer[0].Existing_EQ_Three__r.Name;
                solenis_Commercial_LookupSearchResult result =  new solenis_Commercial_LookupSearchResult(
                                                                                                            geer[0].Existing_EQ_Three__c,
                                                                                                            OBJECT_TYPE_ASSET,
                                                                                                            ICON_ASSET_OBJECT,
                                                                                                            lookupLabel                                                                                                        
                                                                                                        );
                results.put('thridEQ', result);
            }
    
            if(String.isNotBlank(geer[0].Existing_EQ_Four__c)) {
                String lookupLabel = geer[0].Existing_EQ_Four__r.Equipment_Number__c + ' , ' + geer[0].Existing_EQ_Four__r.Name;
                solenis_Commercial_LookupSearchResult result =  new solenis_Commercial_LookupSearchResult(
                                                                                                            geer[0].Existing_EQ_Four__c,
                                                                                                            OBJECT_TYPE_ASSET,
                                                                                                            ICON_ASSET_OBJECT,
                                                                                                            lookupLabel                                                                                                        
                                                                                                        );
                results.put('fourEQ', result);
            }
    
            if(String.isNotBlank(geer[0].Existing_EQ_Five__c)) {
                String lookupLabel = geer[0].Existing_EQ_Five__r.Equipment_Number__c + ' , ' + geer[0].Existing_EQ_Five__r.Name;
                solenis_Commercial_LookupSearchResult result =  new solenis_Commercial_LookupSearchResult(
                                                                                                            geer[0].Existing_EQ_Five__c,
                                                                                                            OBJECT_TYPE_ASSET,
                                                                                                            ICON_ASSET_OBJECT,
                                                                                                            lookupLabel                                                                                                        
                                                                                                        );
                results.put('fiveEQ', result);
            }
        }        

        return results;
    }

    public class SelectedEquipmentWrapper {
        public string firstLookup  { get;set; }
        public string secondLookup { get;set; }
        public string thirdLookup  { get;set; }
        public string fourLookup   { get;set; }
        public string fiveLookup   { get;set; }
    }
}