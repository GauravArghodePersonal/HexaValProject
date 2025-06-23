public class PricingConditionListFunctions {

    public static final Set<String> MKT_PB_WIRED = new Set<String>{'H','S'};

    private static final Set<String> DLVRY_PGM_EXCL_PH3_SET = PricingConditionFunctions.DLVRY_PGM_EXCL_PH3_SET;
    private static final Set<String> DLVRY_PGM_EXCL_PLNT_SET = PricingConditionFunctions.DLVRY_PGM_EXCL_PLNT_SET;
    private static final String SHIPTO = Account_Partner_Functions.ACC_TYPE_SHIPTO;
    private static final String SOLDTO = Account_Partner_Functions.ACC_TYPE_SOLDTO;
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'PricingConditionListFunctions : ' + s);
    }
    
    private static Boolean isNull(String s) {return (s == null || s.trim().length() == 0);}

    public static Database.Querylocator getPricingConditionQueryLocator(Set<String> pcids) {
        String qry = PricingConditionFunctions.SELECT_QRY_1 + ' where Id in :pcids';
        return Database.getQueryLocator(qry);
    }
    
    public static void expirePricingConditions(String userComments, List<Pricing_Condition> slist) {
        updateUserComments(userComments, slist);
        PricingConditionFunctions.expirePricingConditions(slist);
    }
    
    public static void deletePricingConditions(List<Pricing_Condition> slist) {
        PricingConditionFunctions.deletePricingConditions(slist);
    }
    
    public static Integer setExtendableFlag(Account acc, Date edate, List<Pricing_Condition> slist) {
        Boolean isAAFI = SAP_Queries_Functions.isAAFI(acc);
        Boolean isAHWT = SAP_Queries_Functions.isAHWT(acc);
        Boolean isAHWT_EMEA = SAP_Queries_Functions.isAHWT_EMEA(acc);
        Pricing_Condition__c spc; Integer extendableCount = 0;
        Date fdate = Date.today(); 
        String c1 = 'The Account is marked for deletion.<br/>' + 
                    'Price condition cannot be extended.';
        String c2 = 'More than 30 days since Price expired.<br/>' +
                    'Price condition cannot be extended.<br/>' + 
                    'Create a new price condition and back date<br/>' +
                    'to the previous expiration date plus one day.';
        String c3 = 'Extend-To Date is earlier than Valid-To Date.<br/>' + 
                    'Price condition cannot be extended.';
        String c4 = 'Price condition cannot be extended and<br/>' + 
                    'must be edited due to change in freight<br/>' +
                    'calculation.';
        String c5 = 'Market Price Book maintains the<br/>' + 
                    'Price and so cannot be extended.';
        for (Pricing_Condition t : slist) {
            t.comments = ''; t.isExtendable = true;
            spc = t.pricingCondition;
            Integer d = spc.Valid_To_Date__c.daysBetween(edate);
            Integer e = spc.Valid_To_Date__c.daysBetween(fdate);
            if (spc.Account__r.Inactive_Account__c) {
                t.comments = c1; t.isExtendable = false;
            } else 
            if (PricingConditionFunctions.isExpired(spc) && e > 30) {
                t.comments = c2; t.isExtendable = false;
            } else 
            if (d <= 0) {
                t.comments = c3; t.isExtendable = false;
            } else {
                String ph3 = spc.PH3_Product_Group__c;
                String plant = spc.Plant_Code__c;
                Double dpcost = (spc.Fleet_Cost__c   != null ? spc.Fleet_Cost__c : 0) + 
                                (spc.Program_Cost__c != null ? spc.Program_Cost__c : 0);
                if (DLVRY_PGM_EXCL_PLNT_SET.contains(plant) && 
                    DLVRY_PGM_EXCL_PH3_SET.contains(ph3) &&
                    dpcost > 0) {t.comments = c4;  t.isExtendable = false;}
            }
            debug('setExtendableFlag : mpt = ' + t.marketPricingType);
            if (MKT_PB_WIRED.contains(t.marketPricingType)) {
            	t.comments = c5; t.isExtendable = false;
            }
            if (t.isExtendable) {
            	PricingConditionFunctions.setExtendToFields(spc, edate);
            	extendableCount++;
            }
        }
        if (extendableCount > 0) {
        	doPricingConditionUpdates(slist);
        	if (isAHWT) {extendableCount = setPriceBookEntries(slist);}
        }
        return extendableCount;
    }
    
    private static void doPricingConditionUpdates(List<Pricing_Condition> slist) {
        List<Pricing_Condition__c> pca = new List<Pricing_Condition__c>();
        for (Pricing_Condition t : slist) {
            if (t.isExtendable) {pca.add(t.pricingCondition);}
        }
        if (pca.isEmpty()) {return;}
        PricingConditionFunctions.doPricingConditionUpdates(pca);
        String c1 = 'The Invoice Price will be changed<br/>' + 
                    'due to change in the Program/Fleet Cost<br/>' +
                    'of this ULSV, PRSV, Custom Bulk or<br/>' +
                    'Returnable Bin material.';
        Double d1, d2;
        for (Pricing_Condition t : slist) {
            t.isInvoicePriceChanged = false; //t.comments = '';
            d1 = t.invoicePrice; d2 = t.pricingCondition.Invoice_Price__c;
            if (compare(d1, d2)) {t.comments = c1; t.isInvoicePriceChanged = true;}
        }
    }
    
    private static Boolean compare(Double d1, Double d2) {
    	return (d1 == null && d2 != null) ||
    	       (d1 != null && d2 == null) ||
    	       (d1 != d2);
    }
    
    private static Integer setPriceBookEntries(List<Pricing_Condition> slist) {
        PricingConditionFunctions.setPriceBookEntries(slist);
        String c1 = 'Price Book information not found.<br/>' + 
                    'Price condition cannot be extended.';
        Pricing_Condition__c spc; Integer extendableCount = 0;
        for (Pricing_Condition t : slist) {
            if (!t.isExtendable) {continue;}
            spc = t.pricingCondition;
            if (spc.Price_Book_Entry__c == null) {
                t.comments = c1; t.isExtendable = false;
            } else {extendableCount++;} 
        }
        return extendableCount;
    }
    
    private static void setSoldToLevel(Boolean extendAtSoldTo, List<Pricing_Condition> slist) {
        if (!extendAtSoldTo) {return;}
        Pricing_Condition__c pcc; String s;
        for (Pricing_Condition p : slist) {
            pcc = p.pricingCondition;
            s = pcc.Account_Level_Condition_Applies_To__c;
            if (s != null && s.equals(SHIPTO)) {
                pcc.Account_Level_Condition_Applies_To__c = SOLDTO;
            }
        }
    }
    
    public static void updateUserComments(String userComments, List<Pricing_Condition> slist) {
        if (isNull(userComments)) {return;}
        String dt = Datetime.now().format();
        String un = UserInfo.getName();
        String s2 = dt + ' : ' + un + ' : ' + userComments + '\n';
        String s1;
        Pricing_Condition__c pcc;
        for (Pricing_Condition p : slist) {
            pcc = p.pricingCondition;
            s1 = pcc.Comments__c;
            if (isNull(s1)) {s1 = '';}
            s1 = s2 + s1;
            pcc.Comments__c = s1;
        }
    }
    
    public static List<Pricing_Condition> getExtendablePricingConditions(List<Pricing_Condition> slist) {
        List<Pricing_Condition> elist = new List<Pricing_Condition>();
        debug('slist : ' + slist);
        if (slist == null || slist.isEmpty()) {return elist;}
        for (Pricing_Condition p : slist) {
            if (p.isExtendable) {elist.add(p);}
        }
        return elist;
    }
    
    private static Set<String> getPricingConditionIds(List<Pricing_Condition> slist) {
        Set<String> aset = new Set<String>();
        for (Pricing_Condition p : slist) {aset.add(p.pricingCondition.Id);}
        return aset;
    }
    
    private static List<Pricing_Condition> getPricingConditionList(List<Pricing_Condition__c> pcs) {
        List<Pricing_Condition> plist = new List<Pricing_Condition>();
        if (pcs == null || pcs.isEmpty()) {return plist;}
        for (Pricing_Condition__c pc : pcs) {
            Pricing_Condition p = new Pricing_Condition(pc);
            plist.add(p);
        }
        return plist;
    }
    
    private static Account getAccount(String accountId) {
        Account acc = null;
        try {
            acc = [select Id, Name, AccountNumber, Inactive_Account__c, RecordTypeId,
                          SAP_Customer_Group_1_Desc__c, SAP_DistChannel__c, 
                          SAP_Sales_Org__c, sales_area__c 
                     from Account 
                    where Id = :accountId];
        } catch(Exception e) {}
        return acc;
    }
    
    // called from PricingConditionListController
    public static void extendAndSubmitForApproval(Boolean extendAtSoldTo, 
                                                  Date extendToDate, String userComments, 
                                                  List<Pricing_Condition> slist) {
        if (slist == null || slist.isEmpty()) {return;}
        updateUserComments(userComments, slist); setSoldToLevel(extendAtSoldTo, slist);
        Set<String> oids = PricingConditionFunctions.extendPricingConditions(slist, extendToDate);
        if (oids == null || oids.isEmpty()) {return;}
        Custom_Approval_Functions.submitForApproval(oids, userComments);
    }
    
    // called from PricingConditionListBatchable
    public static void extendAndSubmitForApproval(String accountId, Boolean extendAtSoldTo, 
                                                  Date extendToDate, String userComments, 
                                                  List<Pricing_Condition__c> pcs) {
        try {Account acc = getAccount(accountId); if (acc == null) {return;}
            List<Pricing_Condition> slist = getPricingConditionList(pcs);
            Integer extendableCount = setExtendableFlag(acc, extendToDate, slist);
            if (extendableCount == 0) {return;} 
            slist = getExtendablePricingConditions(slist);
            extendAndSubmitForApproval(extendAtSoldTo, extendToDate, userComments, slist);
        } catch(Exception e) {System.debug(LoggingLevel.INFO, e);}
    }
    
    // called from PricingConditionListController
    public static String submitExtendBatchJob(String accountId, Boolean extendAtSoldTo, 
                                              Date extendToDate, String userComments, 
                                              List<Pricing_Condition> slist) {
        String jobId, s = PricingConditionListBatchable.EXTEND_PCNS; Integer batchSize = 10;
        Set<String> pcIds = getPricingConditionIds(slist); if (pcIds.isEmpty()) {return null;}
        PricingConditionListBatchable b = new PricingConditionListBatchable(s);
        b.accountId = accountId; b.extendAtSoldTo = extendAtSoldTo; b.extendToDate = extendToDate;
        b.pcIds = pcIds; b.userComments = userComments;
        try {jobId = Database.executeBatch(b, batchSize);
        } catch(Exception e) {debug(e.getMessage());}
        return jobId;
    }
    
}