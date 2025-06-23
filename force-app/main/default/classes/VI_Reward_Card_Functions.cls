public class VI_Reward_Card_Functions {
	
	public static final String DELIM = '-';
	
	public static void doBeforeUpsert(List<VI_Promotion_Upsell__c> alist) {
		for (VI_Promotion_Upsell__c a : alist) {
			a.Name = getUpsellName(a.Product_Category__c, a.Primary_Product__c, a.Reward_Card_Value__c);
		}
	}
	
    public static String getUpsellName(VI_Reward_Card_Value__c c) {
    	String s = ''; Double d = c.Reward_Card_Value__c; 
    	if (d != null) {s = d.format();}
        return getUpsellName(c.Product_Category__c, c.Primary_Product__c, s);
    }
    
	public static String getUpsellName(String prodCategory, String prodName, String cardValue) {
		return prodCategory + DELIM + prodName + DELIM + cardValue;
	}
	
	public static VI_Promotion__c getPromo(String promoId) {
		VI_Promotion__c p = null;
		List<VI_Promotion__c> plist = [select Id, Name, Product_Category__c,
            (select Id, Name, Key__c, Primary_Product__c, Product_Category__c, Promotion__c, 
                    Reward_Card__c, Reward_Card_Value__c, Upsell_Percent__c 
               from VI_Reward_Card_Values__r)
            from VI_Promotion__c where Id = :promoId];
		if (plist != null && !plist.isEmpty()) {p = plist[0];}
		return p;
	}
	
	public static Map<String, VI_Promotion_Upsell__c> getUpsellMap(String prodCategory) {
		Map<String, VI_Promotion_Upsell__c> amap = new Map<String, VI_Promotion_Upsell__c>();
		for (VI_Promotion_Upsell__c a : [select Id, Name,  
                 Primary_Product__c, Product_Category__c, Reward_Card_Value__c, Upsell_Percent__c
            from VI_Promotion_Upsell__c where Product_Category__c = :prodCategory]) {amap.put(a.Name, a);}
        return amap;
	}
	
	public static List<String> getProductCategories() {
		List<String> alist = new List<String>();
        for (AggregateResult[] ars : [
            select Product_Category__c pcat
              from VI_Promotion_Upsell__c 
          group by Product_Category__c]) {
            for (AggregateResult ar : ars) {alist.add((String)ar.get('pcat'));}
        }
        return alist;
	}

}