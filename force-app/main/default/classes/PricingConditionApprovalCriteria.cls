public class PricingConditionApprovalCriteria {
	
    private static final Set<String> INCO_TERMS_EU = new Set<String>{
        'DDP'
    };
    
    private static final Set<String> INCO_TERMS_NA = new Set<String>{
        'ZD1', 'ZO1'
    };
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, '\n\n>>>>>>>>> PCApprovalCriteria : ' + s + '\n');
    }
    
    private static Boolean isAHWT_EMEA(Account acc) {
    	return SAP_Queries_Functions.isAHWT_EMEA(acc);
    }
    
    private static Boolean isAHWT(Account acc) {
    	return SAP_Queries_Functions.isAHWT(acc);
    }
    
    private static Boolean isAHWT_AP(Account acc) {
        return SAP_Queries_Functions.isAHWT_AP(acc);
    }
    
    private static Boolean isAHWT_NA(Account acc) {
        return SAP_Queries_Functions.isAHWT_NA(acc);
    }
    
    private static Boolean isEUSalesOrg(Account acc) {
    	return SAP_Queries_Functions.isEUSalesOrg(acc);
    }
    
    private static Boolean isNASalesOrg(Account acc) {
    	return SAP_Queries_Functions.isNASalesOrg(acc);
    }
    
    private static Boolean isNotEqual(String s1, String s2) {
        s1 = trimString(s1);
        s2 = trimString(s2);
        Boolean b = (s1 != null && s2 != null && s1 != s2);
        //System.debug(s1 + ':' + s2 + ':' + b);
        return b;
    }
    
    private static String trimString(String s) {
        if (s != null) {
            s = s.trim();
            if (s == '' || s.length() == 0) {s = null;}
        }
        return s;
    }
    
    public static void setRouteForApprovalFields(Pricing_Condition__c pc,
                                                 Account acc,
                                                 Double minPrice) {
        if (pc == null || acc == null) {return;}
    	pc.Route_Price_for_Approval_1__c = getRouteForApproval1(pc, acc, minPrice);
        pc.Route_Price_for_Approval_2__c = getRouteForApproval2(pc, acc, minPrice);
        pc.Route_Price_for_Approval_3__c = getRouteForApproval3(pc, acc, minPrice);
        pc.Route_Price_for_Approval_4__c = getRouteForApproval4(pc, acc, minPrice);
    }
    
    private static Boolean getRouteForApproval1(Pricing_Condition__c pc,
                                                Account acc,
                                                Double minPrice) {
        Boolean b1 = false, b2 = false, b3 = false, b4 = false;
        
        Double floorPrice = pc.Floor_Price__c; 
        if (floorPrice == null) {floorPrice = 0.0;}
        Double marketPrice = pc.Market_Price__c;
        if (marketPrice == null) {marketPrice = 0.0;}
        String cpiIncoTerm = pc.CPI_INCO_Term_Code__c;
        String pcIncoTerm = pc.INCO_Term_Code__c;
        String accPmntTerm = pc.Account_Payment_Terms__c;
        String pcPmntTerm = pc.Payment_Terms__c;

        debug('getRouteForApproval1 : minPrice    : ' + minPrice);
        debug('getRouteForApproval1 : floorPrice  : ' + floorPrice);
        debug('getRouteForApproval1 : marketPrice : ' + marketPrice);
        debug('getRouteForApproval1 : cpiIncoTerm : ' + cpiIncoTerm);
        debug('getRouteForApproval1 : pcIncoTerm  : ' + pcIncoTerm);
        debug('getRouteForApproval1 : accPmntTerm : ' + accPmntTerm);
        debug('getRouteForApproval1 : pcPmntTerm  : ' + pcPmntTerm);
        
        b1 = (isEUSalesOrg(acc) && minPrice >= floorPrice && minPrice < marketPrice);
        debug('getRouteForApproval1 : b1 : ' + b1);

        b2 = isAHWT_EMEA(acc) && (isNotEqual(pcIncoTerm, cpiIncoTerm));
        debug('getRouteForApproval1 : b2 : ' + b2);
              
        b3 = (isAHWT_AP(acc) && minPrice >= marketPrice);
        debug('getRouteForApproval1 : b3 : ' + b3);

        return (b1 || b2 || b3);
    }
    
    private static Boolean getRouteForApproval2(Pricing_Condition__c pc,
                                                Account acc,
                                                Double minPrice) {

        if (isAHWT_EMEA(acc)) {
        	return false;
        }
        
        Boolean b1 = false, b2 = false, 
                b3 = false, b4 = false,
                b5 = false, b6 = false; 
                
        Double freightUpcharge = pc.Freight_Up_Charge__c;
        Double discountPercent = pc.Discount_Percent__c;
        Double floorPrice = pc.Floor_Price__c; 
        if (floorPrice == null) {floorPrice = 0.0;}
        Double marketPrice = pc.Market_Price__c;
        if (marketPrice == null) {marketPrice = 0.0;}
        String cpiIncoTerm = pc.CPI_INCO_Term_Code__c;
        String pcIncoTerm = pc.INCO_Term_Code__c;
        String accPmntTerm = pc.Account_Payment_Terms__c;
        String pcPmntTerm = pc.Payment_Terms__c;

        b1 = (discountPercent > 0);
        debug('getRouteForApproval2 : b1 : ' + b1);

        b2 = isNotEqual(pcIncoTerm, cpiIncoTerm);
        debug('getRouteForApproval2 : b2 : ' + b2);

        b3 = (isAHWT_AP(acc) && minPrice >= floorPrice && minPrice < marketPrice);
        debug('getRouteForApproval2 : b3 : ' + b3);
             
        b4 = ((isAHWT_NA(acc) || isEUSalesOrg(acc)) && minPrice < floorPrice);
        debug('getRouteForApproval2 : b4 : ' + b4);
             
        return (b1 || b2 || b3 || b4);
    }
    
    private static Boolean getRouteForApproval3(Pricing_Condition__c pc,
                                                Account acc,
                                                Double minPrice) {
        Boolean b1 = false;
        
        Double floorPrice = pc.Floor_Price__c;
        if (floorPrice == null) {floorPrice = 0.0;}
        b1 = ((isAHWT_AP(acc) || isAHWT_EMEA(acc)) && minPrice < floorPrice);
        debug(acc.SAP_Sales_Org__c + ':' + minPrice + ':' +  floorPrice);
        debug('getRouteForApproval3 : b1 : ' + b1);
        
        return b1;
    }
    
    private static Boolean getRouteForApproval4(Pricing_Condition__c pc,
                                                Account acc,
                                                Double minPrice) {
        Boolean b1 = false, b2 = false, 
                b3 = false, b4 = false;
        String pcIncoTerm = pc.INCO_Term_Code__c;
        Double discountPercent = pc.Discount_Percent__c;
        Double floorPrice = pc.Floor_Price__c;
        if (floorPrice == null) {floorPrice = 0.0;}
        Double marketPrice = pc.Market_Price__c;
        if (marketPrice == null) {marketPrice = 0.0;}

        b1 = (isAHWT_NA(acc) && minPrice >= floorPrice && minPrice < marketPrice);
        debug('getRouteForApproval4 : b1 : ' + b1);
             
        if (pcIncoTerm != null) {
            b2 = (isNASalesOrg(acc) && INCO_TERMS_NA.contains(pcIncoTerm));
        }
        debug('getRouteForApproval4 : b2 : ' + b2);

        b3 = (isAHWT_EMEA(acc) && discountPercent > 0);
        debug('getRouteForApproval4 : b3 : ' + b3);

        b4 = (isAHWT_EMEA(acc) && minPrice < floorPrice);
        debug('getRouteForApproval4 : b4 : ' + b4);

        return (b1 || b2 || b3 || b4);
    }
    
}