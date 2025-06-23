public with sharing class TempPricingConditionFunctions2 {

    public static void processBeforeUpdate2(List<Pricing_Condition__c> pca) {
        Id pcid = pca[0].Id;
        Pricing_Condition__c p1 = pca[0];
        Pricing_Condition__c pc = [select Id, Floor_Price__c, Market_Price__c,
                                          Target_Gross_Profit_Percent__c,
                                          Price_Book_Entry_Scaled_Pricing__r.Floor_Price__c,
                                          Price_Book_Entry_Scaled_Pricing__r.Selling_Price__c,
                                          Price_Book_Entry__r.GPPct__c
                                     from Pricing_Condition__c where Id = :pcid
                                  ];
        Price_Book_Entry_Scaled_Pricing__c pbesp = pc.Price_Book_Entry_Scaled_Pricing__r;
        Price_Book_Entry__c pbe = pc.Price_Book_Entry__r;
        //System.debug(pbesp.Floor_Price__c + ':' + pbesp.Selling_Price__c + ':' + pbe.GPPct__c);
        if (pbesp != null && p1.Floor_Price__c == null) {p1.Floor_Price__c = pbesp.Floor_Price__c;}
        if (pbesp != null && p1.Market_Price__c == null) {p1.Market_Price__c = pbesp.Selling_Price__c;}
        if (pbe != null && p1.Target_Gross_Profit_Percent__c == null) {p1.Target_Gross_Profit_Percent__c = pbe.GPPct__c;}
    }

}