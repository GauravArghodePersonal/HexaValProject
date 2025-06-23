@isTest
private class SAP_Seller_Functions_Test {

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }

    static testMethod void test01() {
        Test.startTest();
        List<SAP_Seller__c> ssa; User u; SAP_Seller__c ss;
        ssa = [select Name, User__c from SAP_Seller__c where User__r.isActive = true limit 2];
        SAP_Seller_Functions.processAfterUpsert(ssa);
        String userId = UserInfo.getUserId();
        u = [select Id, SAP_Cust_Num__c from User where Id = :userId limit 1];
        ss = new SAP_Seller__c(Name = '0000123456', User__c = u.Id);
        insert ss;
        Map<String, User> umap = SAP_Seller_Functions.getSellerMap(new Set<String>{'0000123456'});
        debug('umap : ' + umap);
        u = [select Id, SAP_Cust_Num__c from User where Id = :userId limit 1];
        debug('after insert : '+u);
        delete ss;
        u = [select Id, SAP_Cust_Num__c from User where Id = :userId limit 1];
        debug('after delete : '+u);
        SAP_Seller_Functions.MAX_RECS = 10;
        SAP_Seller_Functions.deleteInactiveSellerRecords();
    }
      static testMethod void testGetSellerNumbers() {
     Test.startTest();
        Set<String> aset = SAP_Seller_Functions.getSellerNumbers();
        System.assert(aset.isEmpty(),'List should be empty for user in test context');
     }
}