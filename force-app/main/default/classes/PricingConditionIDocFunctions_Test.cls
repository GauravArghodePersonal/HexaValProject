@isTest
private class PricingConditionIDocFunctions_Test {

    static Pricing_Condition_IDoc__c idoc;

    static void createIdoc(Pricing_Condition__c pc) {
        idoc = new Pricing_Condition_IDoc__c();
        idoc.Key__c = pc.Id; idoc.Pricing_Condition__c = pc.Id;
        upsert idoc Pricing_Condition_IDoc__c.Fields.Key__c;
    }
    
    static testMethod void test01() {
        Test.startTest();
        PricingConditionIDocFunctions pcs1 =new PricingConditionIDocFunctions();
        Pricing_Condition__c pc1 = PricingConditionFunctions_Test.getPc1();
        Set<String> pcids = new Set<String>{pc1.Id};
        PricingConditionIDocFunctions.getIDocString(pc1.Id);
        createIdoc(pc1); 
        Test.stopTest();
        /*PricingConditionIDocFunctions.deleteIDoc(pc1.Id);
        PricingConditionIDocFunctions.createIDoc(pc1.Id);
       // PricingConditionIDocFunctions.upsertIDocs(pcids, false);
        createIdoc(pc1); 
        //PricingConditionIDocFunctions.updateIDocs();
        PricingConditionIDocFunctions.getUpdatedIDocs(10);
        List<String> idocIds = new List<String>{idoc.Id};
        PricingConditionIDocFunctions.setExportStatus(idocIds, 10);
        Test.stopTest();
    }
    
    static testMethod void test01() {
        Test.startTest();
        PricingConditionIDocFunctions pcs1 =new PricingConditionIDocFunctions();
        Pricing_Condition__c pc1 = PricingConditionFunctions_Test.getPc1();
        Set<String> pcids = new Set<String>{pc1.Id};
        PricingConditionIDocFunctions.getIDocString(pc1.Id);
        createIdoc(pc1); 
        PricingConditionIDocFunctions.deleteIDoc(pc1.Id);
        PricingConditionIDocFunctions.createIDoc(pc1.Id);
       // PricingConditionIDocFunctions.upsertIDocs(pcids, false);
        createIdoc(pc1); 
        //PricingConditionIDocFunctions.updateIDocs();
        PricingConditionIDocFunctions.getUpdatedIDocs(10);
        List<String> idocIds = new List<String>{idoc.Id};
        PricingConditionIDocFunctions.setExportStatus(idocIds, 10);
        Test.stopTest();*/
    }
    
    static testMethod void test02() {
        Test.startTest();
        Pricing_Condition__c pc1 = PricingConditionFunctions_Test.getPc1();
        PricingConditionIDocFunctions.deleteIDoc(pc1.Id);
        PricingConditionIDocFunctions.createIDoc(pc1.Id);
       // PricingConditionIDocFunctions.upsertIDocs(pcids, false);
        Test.stopTest();
    }
    
    static testMethod void test03() {
        Test.startTest();
        Pricing_Condition__c pc1 = PricingConditionFunctions_Test.getPc1();
        createIdoc(pc1); 
        PricingConditionIDocFunctions.getUpdatedIDocs(10);
        List<String> idocIds = new List<String>{idoc.Id};
            PricingConditionIDocFunctions.setExportStatus(idocIds, 10);
        Test.stopTest();
    }

}