public with sharing class UpdateSAPAssetNumberHandler {
   
  public static void updateSAPNumberAsync(Set<ID> ass_Ids){
    
    Map<Id, String> SAPAssetMap = new Map<Id, String>();
      
    List<SAP_Asset__c> sapasset = [select id, Equipment__c,SAP_Asset_Number__c from SAP_Asset__c 
      where Equipment__c IN :ass_Ids order by SAP_Asset_Number__c];
      
    for (SAP_Asset__c ar : sapasset) {
      if (!SAPAssetMap.containsKey(ar.Equipment__c)) {
      
        SAPAssetMap.put(ar.Equipment__c,ar.SAP_Asset_Number__c);
      } else {
        
        SAPAssetMap.put(ar.Equipment__c,SAPAssetMap.get(ar.Equipment__c) + 
          ', ' + ar.SAP_Asset_Number__c);
      }
    }
    
    
    List<Asset> assets = [select id from Asset where Id IN :ass_Ids];
    
    // add the comma separated list of asset number
    for (Asset a : assets)
      a.SAP_Asset_Number__c = SAPAssetMap.get(a.id);
    
    update assets;
    
  }  
  
}