@isTest(SeeAllData=false)
private class PricingConditionTransferFunctions_Test {
    static Pricing_Condition_Transfer_Request__c pctr;
    static List<Pricing_Condition_Transfer_Request__c> pctrs;
    static Pricing_Condition_Transfer_Material__c pctm;
    static List<Pricing_Condition_Transfer_Material__c> pctms;
    static String pctrCsvRec; static Blob pctrsBlob;
    static List<Pricing_Condition__c> pcs;
    static Account soldto, shipto;

    static testMethod void test01() {
        createTestData();
        Test.startTest();
        PricingConditionTransferFunctions.createPCTRequests(pctrCsvRec);
        getPCTRs();
        PricingConditionTransferFunctions.getPctmQryLctr();
        PricingConditionTransferFunctions.getPctrQryLctr();
        PricingConditionTransferFunctions.createPCTMs(pctrs);
        getPCTMs();
        //PricingConditionTransferFunctions.createPricingConditions(pctms);
        PricingConditionTransferFunctions.deletePCTMaterials();
        PricingConditionTransferFunctions.createMaterials(pctrs);
        getPCTMs();
        PricingConditionTransferFunctions.updateMaterials(pctms);
        PricingConditionTransferFunctions.mergeAccounts(pctrs);
        //Test.stopTest();
    }

    static testMethod void test02() {
        createTestData();
        Test.startTest();
        PricingConditionTransferController c = new PricingConditionTransferController();
        c.pctrsBlob = pctrsBlob;
        c.next(); c.prev();
        c.createPCTRequests(); 
        c.createPCTMs(); c.createPCNs();
        c.createMaterials(); c.updateMaterials();
        //c.mergeAccounts(); 
        c.deletePCTRequests();
        //Test.stopTest();
    }

    
    static void debug(String s) {
    	System.debug(LoggingLevel.INFO, s);
    }
    
    static void createTestData() {
    	PricingConditionTransferFunctions.deletePCTRequests();
        PricingConditionTransferFunctions.deletePCTMaterials();
        PricingConditionFunctions_Test.createTestData();
        pcs = PricingConditionFunctions_Test.pcs;
        pctr = new Pricing_Condition_Transfer_Request__c();
        Pricing_Condition__c pc1 = pcs[0]; pctr.Account_From__c = pc1.Account__c; 
        String s1 = pc1.Account__r.Account_Number__c;
        pctm = new Pricing_Condition_Transfer_Material__c();
        pctm.Material2__c = pc1.Material2__c; 
        pctm.Pricing_Condition__c = pc1.Id; pctm.Key__c = pc1.Id;
        insert pctm;
        Pricing_Condition__c pc2 = pcs[1]; pctr.Account_To__c = pc2.Account__c;
        pctrCsvRec = s1 + ',' + pc2.Account__r.Account_Number__c;
        debug('pctrCsvRec : ' + pctrCsvRec);
        pctrsBlob = Blob.valueOf(pctrCsvRec);
    }
/*    
    static Pricing_Condition__c getPc(String dc) {
        List<Pricing_Condition__c> pcs = [
              select Id, Name, Account__c, Account__r.Account_Number__c,
                     Material2__c
                from Pricing_Condition__c
               where Record_Status__c = 'Active'
                 and Dist_Channel_Code__c = :dc
               limit 1];
        if (pcs == null || pcs.isEmpty()) {return null;}
        return pcs[0];
    }
*/    
    static void getPCTMs() {
        String q = PricingConditionTransferFunctions.QRY_PCTM + ' limit 10';
        pctms = Database.query(q);
    }
    
    static void getPCTRs() {
    	String q = PricingConditionTransferFunctions.QRY_PCTR + ' limit 10';
        pctrs = Database.query(q);
        debug('pctrs : '+pctrs);
    }
    
}