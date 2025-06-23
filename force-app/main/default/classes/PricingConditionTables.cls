public class PricingConditionTables {

    public static final String DIST_CHANNEL_AHWT = '10';
    public static final String DIST_CHANNEL_APM  = '20';
    public static final String DIST_CHANNEL_AAFI = '50';
    public static final String DISTRIBUTORS = 'DISTRIBUTORS';
    public static final String SHIPTO = 'Ship To';
    public static final String SOLDTO = 'Sold To';
    
    public static final Set<String> SALES_ORGS_AP = SAP_Queries_Functions.SALES_ORGS_AP;
    public static final Set<String> SALES_ORGS_EU = SAP_Queries_Functions.SALES_ORGS_EU;

    // for AAFI Distributors
    public static final String A640 = 'A640'; // shipto
    public static final String A641 = 'A641'; // soldto
    public static final String A736 = 'A736'; // shipto + pacIndustry
    public static final String A737 = 'A737'; // soldto + pacIndustry
    public static final String A746 = 'A746'; // soldto + endUseCust
    
    // for AHWT
    public static final String A541 = 'A541'; // shipto
    public static final String A538 = 'A538'; // soldto
    public static final String A942 = 'A942'; // cherky

    // for AHWT - AP
    public static final String A564 = 'A564'; // shipto
    public static final String A565 = 'A565'; // soldto

    // for AAFI and AHWT - On-Invoice-Discount
    public static final String A557 = 'A557'; // shipto
    public static final String A552 = 'A552'; // soldto
    public static final String A559 = 'A559'; // cherky
    
    // PricingConditionTable Map : Code - Description
    public static final Map<String, String> PCT_MAP = new Map<String, String>{
		A538 => 'SOrg/DC/Sold to/CondGrp 1/Material/Dep Indic',
		A541 => 'SOrg/DC/Ship to/CondGrp 1/Material/Dep Indic',
		A552 => 'SOrg/DC/Sold to/Material',
		A557 => 'SOrg/DC/Ship To/Material',
		A559 => 'SOrg/DC/Div/Cust Hier/Material',
        A564 => 'SOrg/DC/Ship-To Pt/Plant/Incoterms/Material/Dep Indic',
        A565 => 'SOrg/DC/Sold to/Plant/Incoterms/Material/Dep Indic',
		A640 => 'SOrg/DC/Ship To/Incoterms/CondGrp 1/Material/Dep Indic',
		A641 => 'SOrg/DC/Sold to/Incoterms/CondGrp 1/Material/Dep Indic',
        A736 => 'SO/DC/ShipTo/Cust group/Incoterms/CondGrp1/Matl/Dep Ind',
		A737 => 'SO/DC/SoldTo/Cust group/Incoterms/CondGrp1/Matl/Dep Ind',
		A746 => 'SO/DC/SoldTo/EndUseCust/CustGrp/Incotrm/Condgrp1/Matl/DepInd',
		A942 => 'SOrg/DC/Cust Hier/CondGrp1/Matl/Dep Indic'
    };
    
    public static String getVAKey(Pricing_Condition__c pc) {
    	return getVAKey(pc, pc.SAP_Pricing_Table__c);
    }
    
    public static String getVAKey(Pricing_Condition__c pc, String t) {
        String s = '';
        if (isNull(t)) {return s;}
        String z0 = 'Z0';
        String sorg = pc.Material2__r.Sales_Org_Code__c;
        String dchan = pc.Dist_Channel_Code__c;
        String accnum = pc.Account__r.AccountNumber;
        String eucust = pc.EndUse_Customer__r.AccountNumber;
        String pacseg = pc.PAC_Industry_Segment__c;
        String incoterm = pc.INCO_Term_Code__c;
        String matnum = pc.Material2__r.Material_Number__c;
        String plant = pc.Plant_Code__c;
        String s1 = sorg + dchan + accnum;
        if (t.equals(A538)) {return s1 + z0 + matnum;}
        if (t.equals(A541)) {return s1 + z0 + matnum;}
        if (t.equals(A552)) {return s1 + matnum;}
        if (t.equals(A557)) {return s1 + matnum;}
        if (t.equals(A559)) {return s1 + matnum;}
        if (t.equals(A564)) {return s1 + plant + incoterm + matnum;}
        if (t.equals(A565)) {return s1 + plant + incoterm + matnum;}
        if (t.equals(A640)) {return s1 + incoterm + z0 + matnum;}
        if (t.equals(A641)) {return s1 + incoterm + z0 + matnum;}
        if (t.equals(A736)) {return s1 + pacseg + incoterm + z0 + matnum;}
        if (t.equals(A737)) {return s1 + pacseg + incoterm + z0 + matnum;}
        if (t.equals(A746)) {return s1 + eucust + pacseg + incoterm + z0 + matnum;}
        if (t.equals(A942)) {return s1 + z0 + matnum;}
        return s;
    }
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }

    public static void setPricingTables(Pricing_Condition__c pc) {
    	if (isNull(pc.Account_Level_Condition_Applies_To__c)) {return;}
        String tn, td;
    	tn = getTableName(pc);
    	if (tn != null) {
	        pc.SAP_Pricing_Table__c = tn;
	        td = getTableDesc(tn);
	        pc.SAP_Pricing_Table_Desc__c = td;
    	}
        tn = getDiscountTable(pc);
        if (tn != null) {
	        pc.Discount_Condition_Table__c = tn;
	        td = getTableDesc(tn);
	        pc.Discount_Condition_Table_Desc__c = td;
        }
        tn = getEquipmentUpchargeTable(pc);
        if (tn != null) {
            pc.Equipment_Upcharge_Table__c = tn;
            td = getTableDesc(tn);
            pc.Equipment_Upcharge_Table_Desc__c = td;
        }
        debug(''+pc);
    }
    
    private static String getTableDesc(String tableName) {
        return tableName + ' : ' + PCT_MAP.get(tableName);
    }
    
    private static String getTableName(Pricing_Condition__c pc) {
        if (isAAFI(pc)) {
        	return getTableForAAFI(pc);
        } else if (isAHWT(pc)) {
            return getTableForAHWT(pc);
        } else if (isAPM(pc)) {
            return getTableForPM(pc);
        }
    	return null;
    }
    
    private static String getDiscountTable(Pricing_Condition__c pc) {
        if (!pc.Has_On_Invoice_Discount__c) {
        	return null;
        }
        String acctype = pc.Account_Level_Condition_Applies_To__c;
        if (acctype == SHIPTO) {
            return A557;
        } else if (acctype == SOLDTO) {
        	return A552;
        } else {
        	return A559;
        }
    }
    
    private static String getEquipmentUpchargeTable(Pricing_Condition__c pc) {
        if (pc.Equipment_Up_Charge__c == null ||
            pc.Equipment_Up_Charge__c == 0.0) {
            return null;
        }
        String acctype = pc.Account_Level_Condition_Applies_To__c;
        if (acctype == SHIPTO) {
            return A557;
        } else if (acctype == SOLDTO) {
            return A552;
        } else {
            return A559;
        }
    }
    
    private static Boolean isDistributor(Pricing_Condition__c pc) {
        return (pc.Dist_Channel_Code__c == DIST_CHANNEL_AAFI && 
                pc.Customer_Group1_Desc__c == DISTRIBUTORS);
    }
    
    private static Boolean isAPM(Pricing_Condition__c pc) {
        return (pc.Dist_Channel_Code__c == DIST_CHANNEL_APM);
    }
    
    private static Boolean isAHWT(Pricing_Condition__c pc) {
    	return (pc.Dist_Channel_Code__c == DIST_CHANNEL_AHWT);
    }
    
    private static Boolean isAAFI(Pricing_Condition__c pc) {
        return (pc.Dist_Channel_Code__c == DIST_CHANNEL_AAFI);
    }
    
    private static Boolean isAPSalesOrg(Pricing_Condition__c pc) {
        return isSalesOrgInSet(pc, SALES_ORGS_AP);
    }
    
    private static Boolean isEUSalesOrg(Pricing_Condition__c pc) {
        return isSalesOrgInSet(pc, SALES_ORGS_EU);
    }
    
    private static Boolean isSalesOrgInSet(Pricing_Condition__c pc, 
                                           Set<String> socodes) {
        if (pc == null) {return false;}
        String salesOrgCode = pc.SAP_Sales_Org__c;
        return socodes.contains(salesOrgCode);
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private static Boolean notNull(String s) {
    	return (s != null && s.trim().length() > 0);
    }
    
    private static String getTableForAAFI(Pricing_Condition__c pc) {
        String acctype = pc.Account_Level_Condition_Applies_To__c;
        String endusecust = pc.EndUse_Customer__c;
        String pacindseg = pc.PAC_Industry_Segment__c;
        debug('acctype : ' + acctype);
    	if (acctype == SHIPTO) {
            if (notNull(pacindseg))  {return A736;} else 
    		                         {return A640;}
    	} else
    	if (acctype == SOLDTO) {
    		if (notNull(endusecust)) {return A746;} else 
    		if (notNull(pacindseg))  {return A737;} else 
    		                         {return A641;}
        } else                       {return A942;}
    	return null;
    }
    
    private static String getTableForAHWT(Pricing_Condition__c pc) {
        String acctype = pc.Account_Level_Condition_Applies_To__c;
        Boolean isAPSorg = isAPSalesOrg(pc);
        Boolean isEUSorg = isEUSalesOrg(pc);
        if (acctype == SHIPTO) {
            if (isAPSorg) {return A564;} else 
            if (isEUSorg) {return A640;} else 
                          {return A541;}
        } else 
        if (acctype == SOLDTO) {
            if (isAPSorg) {return A565;} else 
            if (isEUSorg) {return A641;} else 
                          {return A538;}
        } else            {return A942;}
        return null;
    }

    private static String getTableForPM(Pricing_Condition__c pc) {
        String acctype = pc.Account_Level_Condition_Applies_To__c;
        if (acctype == SHIPTO) {return A541;} else 
        if (acctype == SOLDTO) {return A538;} else
                               {return A942;}
        return null;
    }

/*    
    @isTest static void test01() {
    	Pricing_Condition__c pc = [
    	   select Account_Level_Condition_Applies_To__c,
    	          Customer_Group1_Desc__c,
                  Discount_Condition_Table__c,
    	          Dist_Channel_Code__c,
    	          EndUse_Customer__c,
    	          Equipment_Upcharge_Table__c,
    	          PAC_Industry_Segment__c,
    	          SAP_Pricing_Table__c,
    	          SAP_Sales_Org__c
    	     from Pricing_Condition__c
    	    where Id = 'a44P000000000x5IAA' 
    	   ];
    	setPricingTables(pc);
    	debug(''+pc);
    }
*/    
}