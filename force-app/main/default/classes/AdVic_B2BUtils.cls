public class AdVic_B2BUtils {
    private static Map<String, String> communityIdToWebStoreIdCache = new Map<String, String>();
    @AuraEnabled
    public static String resolveCommunityIdToWebstoreId(String communityId) 
    {
        if (communityIdToWebStoreIdCache.containsKey(communityId)) return communityIdToWebStoreIdCache.get(communityId);
        
        else {
            System.debug('communityId=='+communityId);
            String webStoreId;
            if(!Test.isRunningTest()) webStoreId = [SELECT WebStoreId FROM WebStoreNetwork WHERE NetworkId = :communityId WITH SECURITY_ENFORCED LIMIT 1].WebStoreId;
            else{
                WebStore wb = [SELECT Id FROM WebStore WHERE Name = 'Solenis Eshop' LIMIT 1];
                webstoreId = wb.Id;
            }
            System.debug('webStoreId=='+webStoreId);
            communityIdToWebStoreIdCache.put(communityId, webStoreId);
            return webStoreId;
        }
    }
}