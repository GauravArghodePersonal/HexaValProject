@isTest
private class AdVic_B2BUtilsTest {
    // Test method for cache miss scenario
    @isTest static void testResolveCommunityIdToWebstoreId_CacheMiss() {
        WebStore store = new WebStore(Name = 'Solenis Eshop');
        insert store;
        AdVic_B2BUtils.resolveCommunityIdToWebstoreId('test');
    }
}