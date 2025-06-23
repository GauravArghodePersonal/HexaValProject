public with sharing class VIPromotion {

    private static final String AVI_NO = 'No';
    private static final String AVI_YES = 'Yes';
    private static final String AVI_YES_ONLY = 'Yes - AVI Only';

    public VI_Promotion__c promo    {get; private set;}
    public Boolean beginGroup       {get; set;}
    public Boolean isEven           {get; set;}
    public Boolean isFirst          {get; set;}
    public Boolean isLast           {get; set;}
    public Boolean reorder          {get; set;}
    public Boolean selected         {get; set;}
    public String promoName         {get; private set;}
    public String promoDesc         {get; private set;}
    
    public List<VIPromotionMaterial> materials {get; set;}
    
    public Integer recordNumber     {get; set;}

    public String variable {
        get {
            return null;
        }
    }
    
    public VIPromotion(VI_Promotion__c p) {
        promo = p;
        init();
    }
    
    public Boolean isPromoForNonAVI() {
        String avi = promo.AVI__c;
        return (AVI_NO.equalsIgnoreCase(avi));
    }
    
    public Boolean isPromoForAVIOnly() {
        String avi = promo.AVI__c;
        return (AVI_YES_ONLY.equalsIgnoreCase(avi));
    }
    
    public Boolean isPromoForAll() {
        String avi = promo.AVI__c;
        return (AVI_YES.equalsIgnoreCase(avi));
    }
    
    public Boolean isAVIPromo() {
    	return (isPromoForAll() || isPromoForAVIOnly());
    }
    
    private void init() {
        beginGroup = false; isEven = false; isFirst = false; isLast = false; 
        reorder = false; selected = false;
        promoName = promo.Program_Name__c;
        promoDesc = promo.Program_Description__c;
        if (isAVIPromo()) {
            promoName = promo.AVI_Name__c;
            promoDesc = promo.AVI_Description__c;
        }
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public static void processBeforeUpsert(List<VI_Promotion__c> plist) {
    	String defaultSalesOrg = 'USA - 1000';
        for (VI_Promotion__c p : plist) {
            if (isNull(p.Sales_Org__c)) {p.Sales_Org__c = defaultSalesOrg;}
            Integer n = p.Sales_Org__c.length() - 4; 
            p.SalesOrg_Code__c = p.Sales_Org__c.substring(n);
        }
    }

}