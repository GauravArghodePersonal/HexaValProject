public with sharing class Material2ConversionFunctions {

    //   Input Map<ObjectId containing OldMaterial, OldMaterialId>
    // Returns Map<ObjectId containing OldMaterial, NewMaterialId>
    public static Map<Id, Id> getMaterial2Map(Map<Id, Id> materialMap) {
    	Map<Id, Id> m2map = new Map<Id, Id>();
    	if (materialMap == null || materialMap.isEmpty()) {return m2map;}
        Id oldMaterialId; 
        CIS_Materials__c oldMaterial;
        String newMaterialKey;
        Material_Sales_Data2__c newMaterial;
    	Set<Id> oldMaterialIds = new Set<Id>();
    	oldMaterialIds.addAll(materialMap.values());
    	Map<Id, CIS_Materials__c> oldMaterialMap = getOldMaterials(oldMaterialIds);
    	Set<Id> objIds = materialMap.keySet();
    	Set<String> newMaterialKeys = new Set<String>(); 
    	for (Id objId : objIds) {
            oldMaterialId = materialMap.get(objId);
            if (oldMaterialMap.containsKey(oldMaterialId)) {
	            oldMaterial = oldMaterialMap.get(oldMaterialId);
	            newMaterialKey = oldMaterial.Material_Number__c + 
	                             oldMaterial.Sales_Org__c +
	                             oldMaterial.Distribution_Channel__c;
                newMaterialKeys.add(newMaterialKey);
            }
    	}
    	Map<String, Material_Sales_Data2__c> newMaterialMap = getNewMaterials(newMaterialKeys);
        for (Id objId : objIds) {
            oldMaterialId = materialMap.get(objId);
            if (oldMaterialMap.containsKey(oldMaterialId)) {
	            oldMaterial = oldMaterialMap.get(oldMaterialId);
	            newMaterialKey = oldMaterial.Material_Number__c + 
	                             oldMaterial.Sales_Org__c +
	                             oldMaterial.Distribution_Channel__c;
                if (newMaterialMap.containsKey(newMaterialKey)) {
                    newMaterial = newMaterialMap.get(newMaterialKey);
                    m2map.put(objId, newMaterial.Id);
                }
            }
        }
    	return m2map;
    }
    
    // Map<OldMaterialId, OldMaterial>
    private static Map<Id, CIS_Materials__c> getOldMaterials(Set<Id> materialIds) {
    	List<CIS_Materials__c> l = [select Id, Name, 
    	                                   Distribution_Channel__c,
    	                                   Division_Code__c,
    	                                   Ext_Unique_ID_c__c,
    	                                   Material_Holder_Account__c,
    	                                   Material_Number__c,
    	                                   Sales_Org__c
    	                              from CIS_Materials__c
    	                             where Id in :materialIds
    	                           ];
        Map<Id, CIS_Materials__c> m1map = new Map<Id, CIS_Materials__c>(l);
        return m1map;
    }
    
    // Map<NewMaterialKey, NewMaterial>
    private static Map<String, Material_Sales_Data2__c> getNewMaterials(Set<String> recordKeys) {
    	Map<String, Material_Sales_Data2__c> m2map = new Map<String, Material_Sales_Data2__c>();
    	if (recordKeys == null || recordKeys.isEmpty()) {return m2map;}
        for (Material_Sales_Data2__c m : [select id, Material_General_Data__c,
                                                   DistChannel_Code__c, DistChannel_Desc__c,
                                                   Dist_Channel_Code__c, Material_Number__c,
                                                   Product_Hierarchy__c, Record_Key__c,
                                                   SalesOrg_Code__c, SalesOrg_Desc__c,
                                                   Sales_Org_Code__c
                                              from Material_Sales_Data2__c
                                             where Record_Key__c in :recordKeys
                                         ]) {
            m2map.put(m.Record_Key__c, m);
        }
    	return m2map;
    }
    
}