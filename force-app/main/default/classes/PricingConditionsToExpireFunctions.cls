public class PricingConditionsToExpireFunctions {

    private static final String ACTIVE = 'Active';
    private static final String CANCELLED = 'Cancelled';
    private static final String EXPIRED = 'Expired';
    private static final String DELIM = '-';

    private static final String DIST_CHAN_AHWT = '10';
    private static final String DIST_CHAN_AAFI = '50';

    public static Integer MAX_RECS = 10000;

    public class Pricing_Condition {
        public Pricing_Condition__c p1 {get; private set;} // PC to expire
        public Pricing_Condition__c p2 {get; private set;}
        public String accountNumber {get; private set;}
        public String materialNumber {get; private set;}
        public Integer recordNumber {get; private set;}
        public Boolean selected {get; set;}

        public Pricing_Condition(Pricing_Condition__c pc1,
                                 Pricing_Condition__c pc2,
                                 Integer recnum) {
            p1 = pc1;
            p2 = pc2;
            init2(recnum);
        }

        public Pricing_Condition(Pricing_Condition__c pc,
                                 Map<String, Pricing_Condition__c> pmap,
                                 Integer recnum) {
            init(pc, pmap, recnum);
        }

        private void init(Pricing_Condition__c pc,
                          Map<String, Pricing_Condition__c> pmap,
                          Integer recnum) {
            p1 = pc;
            String k = PricingConditionFunctions.getPricingConditionKey(pc);
            if (pmap != null && pmap.containsKey(k)) {
                p2 = pmap.get(k);
            }
            init2(recnum);
        }

        private void init2(Integer recnum) {
            recordNumber = recnum;
            accountNumber = String_Functions.removeLeadingZeros(p1.Account__r.AccountNumber);
            materialNumber = String_Functions.removeLeadingZeros(p1.Material2__r.Material_Number__c);
            selected = false;
        }
    }

    public static List<Pricing_Condition> getSelectedPricingConditions(List<Pricing_Condition> plist) {
        List<Pricing_Condition> slist = new List<Pricing_Condition>();
        for (Pricing_Condition pc : plist) {
            if (pc.selected) {slist.add(pc);}
        }
        if (!slist.isEmpty()) {return slist;}
        return null;
    }

    public static void expirePricingConditions(List<Pricing_Condition> plist) {
        if (plist == null || plist.isEmpty()) {return;}
        List<Pricing_Condition__c> ulist = new List<Pricing_Condition__c>();
        Pricing_Condition__c pc;
        for (Pricing_Condition p : plist) {
            pc = p.p1; pc.Comments__c = 'Replaced by '+ p.p2.Name; pc.Active__c = false;
            pc.Current_State__c = EXPIRED; pc.Record_Status__c = EXPIRED; ulist.add(pc);
        }
        try {update ulist;} catch(Exception e) {System.debug(e.getMessage());}
    }

    public static void expirePricingConditions(List<Pricing_Condition__c> pcs) {
        List<Pricing_Condition> plist = new List<Pricing_Condition>();
        Map<String, Pricing_Condition__c> pmap = new Map<String, Pricing_Condition__c>();
        String k;
        for (Pricing_Condition__c p : pcs) {
            k = PricingConditionFunctions.getPricingConditionKey(p);
            pmap.put(k, p);
        }
        if (pmap == null || pmap.isEmpty()) {return;}
        Integer recnum = 0;
        Pricing_Condition__c p2;
        for (Pricing_Condition__c p : pcs) {
            k = PricingConditionFunctions.getPricingConditionKey(p);
            p2 = pmap.get(k);
            if (p.Id == p2.Id) {
                continue;
            }
            plist.add(new Pricing_Condition(p, pmap, ++recnum));
        }
        if (plist == null || plist.isEmpty()) {return;}
        expirePricingConditions(plist);
    }

    public static List<Pricing_Condition> getPricingConditionsToExpire(String distChan) {
        List<Pricing_Condition> plist = new List<Pricing_Condition>();
        Map<String, String> pmap1 = getActivePricingConditions(distChan);
        if (pmap1 == null || pmap1.isEmpty()) {return plist;}
        Set<String> pset = new Set<String>();
        pset.addAll(pmap1.Values());
        Map<String, List<String>> pmap2 = new Map<String, List<String>>();
        for (Pricing_Condition__c p : [select Id, CreatedDate, Name,
                                              Account__r.Id, Account__r.Name,
                                              Account__r.AccountNumber, Account__r.sales_area__c,
                                              Comments__c,
                                              Dist_Channel_Code__c, EndUse_Customer__c,
                                              EndUse_Customer__r.AccountNumber,
                                              INCO_Term_Code__c, Invoice_Price__c,
                                              Material2__r.Id, Material2__r.Material_Number__c,
                                              Material2__r.Material_Desc__c, Material2__r.Sales_Org_Code__c,
                                              PAC_Industry_Segment__c, Plant_Code__c,
                                              Record_Status__c,
                                              SAP_Pricing_Table__c,
                                              Valid_From_Date__c, Valid_To_Date__c
                                         from Pricing_Condition__c
                                        where Active__c = true
                                          and Record_Status__c = :ACTIVE
                                          and Dist_Channel_Code__c = :distChan
                                          and Id not in :pset
                                        order by Account__c, Material2__c,
                                              SAP_Pricing_Table__c,
                                              CreatedDate, Name
                                        limit :MAX_RECS
                                      ]) {
            String k = PricingConditionFunctions.getPricingConditionKey(p);
            if (pmap1.containsKey(k)) {
                pmap2.put(k, new List<String>{p.Id, pmap1.get(k)});
            }
        }
        plist = getPricingConditionsToExpire(pmap2);
        return plist;
    }

    private static List<Pricing_Condition> getPricingConditionsToExpire(Map<String, List<String>> pmap1) {
        List<Pricing_Condition> plist = new List<Pricing_Condition>();
        if (pmap1 == null || pmap1.isEmpty()) {return plist;}
        Set<String> pset = new Set<String>();
        List<String> pids;
        for (String k1 : pmap1.keySet()) {
            pset.addAll(pmap1.get(k1));
        }
        Map<String, Pricing_Condition__c> pmap2 = getPricingConditions(pset);
        Map<String, List<Pricing_Condition__c>> pmap3 = new Map<String, List<Pricing_Condition__c>>();
        Integer recnum = 0;
        Pricing_Condition__c p1, p2;
        for (String k2 : pmap1.keySet()) {
            pids = pmap1.get(k2);
            p1 = pmap2.get(pids[0]);
            p2 = pmap2.get(pids[1]);
            plist.add(new Pricing_Condition(p1, p2, ++recnum));
        }
        return plist;
    }

    private static Map<String, Pricing_Condition__c> getPricingConditions(Set<String> pset) {
        Map<String, Pricing_Condition__c> pmap = new Map<String, Pricing_Condition__c>();
        if (pset == null || pset.isEmpty()) {return pmap;}
        for (Pricing_Condition__c p : [select Id, CreatedDate, Name,
                                              Account__r.Id, Account__r.Name,
                                              Account__r.AccountNumber, Account__r.sales_area__c,
                                              Comments__c,
                                              Dist_Channel_Code__c, EndUse_Customer__c,
                                              EndUse_Customer__r.AccountNumber,
                                              INCO_Term_Code__c, Invoice_Price__c,
                                              Material2__r.Id, Material2__r.Material_Number__c,
                                              Material2__r.Material_Desc__c, Material2__r.Sales_Org_Code__c,
                                              PAC_Industry_Segment__c, Plant_Code__c,
                                              Record_Status__c,
                                              SAP_Pricing_Table__c,
                                              Valid_From_Date__c, Valid_To_Date__c
                                         from Pricing_Condition__c
                                        where Id in :pset
                                        limit :MAX_RECS
                                      ]) {
            pmap.put(p.Id, p);
        }
        return pmap;
    }

    private static Map<String, String> getActivePricingConditions(String distChan) {
        Map<String, String> pmap = new Map<String, String>();
        for (Pricing_Condition__c p : [select Id, CreatedDate, Name,
                                              Account__r.Id, Account__r.Name,
                                              Account__r.AccountNumber, Account__r.sales_area__c,
                                              Comments__c,
                                              Dist_Channel_Code__c, EndUse_Customer__c,
                                              EndUse_Customer__r.AccountNumber,
                                              INCO_Term_Code__c, Invoice_Price__c,
                                              Material2__r.Id, Material2__r.Material_Number__c,
                                              Material2__r.Material_Desc__c, Material2__r.Sales_Org_Code__c,
                                              PAC_Industry_Segment__c, Plant_Code__c,
                                              Record_Status__c,
                                              SAP_Pricing_Table__c,
                                              Valid_From_Date__c, Valid_To_Date__c
                                         from Pricing_Condition__c
                                        where Active__c = true
                                          and Record_Status__c = :ACTIVE
                                          and Dist_Channel_Code__c = :distChan
                                        order by Account__c, Material2__c,
                                              SAP_Pricing_Table__c,
                                              CreatedDate, Name
                                        limit :MAX_RECS
                                      ]) {
            String k = PricingConditionFunctions.getPricingConditionKey(p);
            pmap.put(k, p.Id);
        }
        return pmap;
    }

}