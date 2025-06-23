public class Risk_Functions {
    
    public static final String SEMI_COLON = ';';
    public static final String ACTIVE = 'Active';
    public static final String APPROVED = 'Approved';
    public static final String CANCELLED = 'Cancelled';
    public static final String CLOSED = 'Closed';
    public static final String DRAFT = 'Draft';
    public static final String STAGE_NEW = 'New';
    public static final List<String> STATUS_LIST = new List<String>{ACTIVE, CLOSED, DRAFT};
    
    public static final String SELECT_QRY1 = 'select'
        + ' Id, Name, CurrencyIsoCode, Account__c, Complaint_Number__c,'
        + ' Amount_at_Risk_CY__c, Amount_at_Risk_NY__c,'
        + ' Case__c, Cloned_From__c, Competitor__c, Contact__c,' 
        + ' Customer_Group__c, Customer_Group_Desc__c, Description__c,'
        + ' EndUse_Customer__c, EndUse_Customer_Desc__c,'
        + ' Industry__c, Industry_Desc__c, Key_Risk_To_Plan__c, Opportunity__c,'
        + ' PAC_Description__c, PAC_Industry_Code__c,'
        + ' Probability_of_Risk_CY__c, Probability_of_Risk_NY__c,CreatedDate,LastModifiedDate,CreatedBy.name,LastModifiedBy.name,'
        + ' Reason__c, Record_Status__c, Sales_District__c, Sales_District_Desc__c,'
        + ' Sales_Group__c, Sales_Group_Desc__c, Sales_Office__c, Sales_Office_Desc__c,'
        + ' SBU__c, Seller__c, Seller_Name__c, Stage__c,'
        + ' Weighted_Amount_at_Risk_CY__c, Weighted_Amount_at_Risk_NY__c,'
        + ' (select Id from Cloned_Risks__r),'
        + ' (select Id, Name, CurrencyIsoCode, '
        + '         Amount_at_Risk_CY__c, Amount_at_Risk_NY__c,'
        + '         Competitor_Product_Name__c, Competitor_Product_Type__c,'  
        + '         Material__c, Material__r.Name, Price_CY__c, Price_NY__c,'
        + '         Product_Sales_Plan__r.Sales_Volume__c,'
        + '         Product_Sales_Plan__r.Sales_Volume_UOM__c, Risk__c,' 
        + '         Volume_at_Risk_CY__c, Volume_at_Risk_NY__c, Volume_UOM_at_Risk__c' 
        + '    from Risk_Details__r)'
        + ' from Risk__c ';     
    
    public static void debug(String s) {
        DebugLog_Functions.info('Risk_Functions : ' + s);
    }
    
    public static void doBeforeUpsert(List<Risk__c> alist) {
    }
    
    public static Boolean isApproved(Risk__c a) {
        return (a.Stage__c != null && a.Stage__c == APPROVED);
    }
    
    public static Boolean isClosed(Risk__c a) {
        return (a.Stage__c != null && a.Stage__c == CLOSED) || 
               (a.Record_Status__c != null && a.Record_Status__c == CLOSED);
    }
    
    public static Boolean isDraft(Risk__c a) {
        return (a.Record_Status__c != null && a.Record_Status__c == DRAFT);
    }
    
    public static Account getAccount(String accountId) {
        Account acc = [select Id, Name, AccountNumber, 
            BillingCity, BillingCountry, BillingPostalCode, 
            BillingState, BillingStreet, Phone, 
            SAP_SalesGroup__c, SAP_Sales_Group_Desc__c 
            from Account where Id = :accountId];
        return acc;
    }
    
    public static Risk__c getRisk(String riskId) {
        String q = SELECT_QRY1 + 'where Id = :riskId';
        List<Risk__c> tlist = Database.query(q);
        if (tlist != null && !tlist.isEmpty()) {return tlist[0];}
        return null;
    }
    
    public static PaginationController getProductPlansPC(String accountId, Integer pageSize) {
        return getProductPlansPC(accountId, null, pageSize);
    }
    
    public static PaginationController getProductPlansPC(String accountId, String matName, Integer pageSize) {
        return Sales_Plan_Functions.getProductPlansPC(accountId, matName, pageSize);
    }
    
    public static Set<String> getMaterialIds(List<Risk_Detail__c> tdlist) {
        Set<String> aset = new Set<String>();
        if (tdlist == null || tdlist.isEmpty()) {return aset;}
        for (Risk_Detail__c td : tdlist) {aset.add(td.Material__c);}
        return aset;
    }
    
    private static List<Risk_Detail__c> getDetailsToCreate(Risk__c th, List<Risk_Detail__c> tdlist) {
        List<Risk_Detail__c> alist = new List<Risk_Detail__c>();
        if (tdlist == null || tdlist.isEmpty()) {return alist;}
        Set<String> matIds = getMaterialIds(th.Risk_Details__r);
        for (Risk_Detail__c td : tdlist) {
            if (!matIds.contains(td.Material__c)) {alist.add(td);}
        }
        return alist;
    }
    
    private static List<Risk_Detail__c> getDetailsToDelete(Risk__c th, List<Risk_Detail__c> tdlist) {
        List<Risk_Detail__c> dlist = new List<Risk_Detail__c>();
        if (th.Risk_Details__r == null || th.Risk_Details__r.isEmpty()) {return dlist;}
        Set<String> matIds = getMaterialIds(tdlist);
        for (Risk_Detail__c td : th.Risk_Details__r) {
            if (!matIds.contains(td.Material__c)) {dlist.add(td);}
        }
        return dlist;
    }
    
    private static List<Risk_Detail__c> getDetailsToUpdate(Risk__c th, List<Risk_Detail__c> tdlist) {
        List<Risk_Detail__c> ulist = new List<Risk_Detail__c>();
        if (tdlist == null || tdlist.isEmpty()) {return ulist;}
        for (Risk_Detail__c td : tdlist) {
            if (td.Id != null) {ulist.add(td);}
        }
        return ulist;
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public static Boolean compare1(String s, String t) {
        return (isNull(s) || (!isNull(t) && s.trim().equalsIgnoreCase(t.trim())));
    }
    
    public static Boolean compare2(String s, String t) {
        if (isNull(s)) {return true;}
        List<String> alist = s.split(SEMI_COLON);
        if (alist == null || alist.isEmpty()) {return true;}
        Set<String> aset = new Set<String>();
        for (String a : alist) {aset.add(a.trim());}
        return ((!isNull(t) && aset.contains(t.trim())));
    }
    
    public static void saveRisk(Risk__c th, List<Risk_Detail__c> tdlist) {
        String msg = 'Risk Saved';
        try {
            if (th.Id == null) {createRisk(th, tdlist);} 
            else {updateRisk(th, tdlist);}
        } catch(Exception e) {
            throw new CustomException(e.getMessage());
        }
    }
    
    private static void createRisk(Risk__c th, List<Risk_Detail__c> tdlist) {
        String msg = 'Risk Created';
        savepoint sp = Database.setSavepoint();
        try {insert th; createRiskDetails(th.Id, tdlist);} 
        catch(Exception e) {Database.rollback(sp);
            throw new CustomException(e.getMessage());
        }
    }
    
    private static void createRiskDetails(String riskId, List<Risk_Detail__c> tdlist) {
        if (riskId == null || tdlist == null || tdlist.isEmpty()) {return;}
        for (Risk_Detail__c td : tdlist) {td.Risk__c = riskId;}
        try {insert tdlist;} catch(Exception e) {
            debug('createRiskDetails : ' + e.getMessage());}
    }

    private static void updateRisk(Risk__c th, List<Risk_Detail__c> tdlist) {
        String msg = 'Risk Updated';
        List<Risk_Detail__c> alist = getDetailsToCreate(th, tdlist);
        List<Risk_Detail__c> dlist = getDetailsToDelete(th, tdlist);
        List<Risk_Detail__c> ulist = getDetailsToUpdate(th, tdlist);
        savepoint sp = Database.setSavepoint();
        try {
            if (!dlist.isEmpty()) {delete dlist;}
            update th;
            if (!ulist.isEmpty()) {update ulist;}
            if (!alist.isEmpty()) {createRiskDetails(th.Id, alist);}
        } catch(Exception e) {Database.rollback(sp);
            throw new CustomException(e.getMessage());
        }
    }
    
    public static void activateNextYearRisks(List<Risk__c> tlist) {
        List<Risk__c> clist = new List<Risk__c>(), rlist; Boolean b;
        for (Risk__c t : tlist) {
            if (isClosed(t)) {continue;}
            b = false; rlist = t.Cloned_Risks__r;
            if (rlist != null && !rlist.isEmpty()) {t.Record_Status__c = CLOSED; b = true;}
            if (isDraft(t)) {t.Record_Status__c = ACTIVE; b = true;}
            if (b) {clist.add(t);}
        }
        debug('activateNextYearRisks : clist = ' + clist);
        if (!clist.isEmpty()) {update clist;}
    }
    
    public static List<Risk__c> createNextYearRisks(List<Risk__c> tlist) {
        List<Risk__c> dlist = new List<Risk__c>();
        List<Risk__c> clist = getRisksToClose(tlist);
        if (clist.isEmpty()) {return dlist;}
        dlist = getClonedRisks(clist);
        for (Risk__c t : dlist) {
            t.Probability_of_Risk_CY__c = t.Probability_of_Risk_NY__c == null ? 0 : 
                                          t.Probability_of_Risk_NY__c;
            t.Probability_of_Risk_NY__c = 0; t.Record_Status__c = DRAFT;
        }
        insert dlist; debug('createNextYearRisks : dlist = ' + dlist);
        List<Risk_Detail__c> tds = getNextYearRiskDetails(dlist);
        if (!tds.isEmpty()) {insert tds;}
        return dlist;
    }
    
    private static List<Risk__c> getClonedRisks(List<Risk__c> tlist) {
        List<Risk__c> clist = tlist.deepClone(true);
        for (Risk__c c : clist) {c.Cloned_From__c = c.Id;}
        clist = clist.deepClone(false);
        return clist;
    }

    private static List<Risk_Detail__c> getClonedRiskDetails(List<Risk__c> tlist) {
        List<Risk_Detail__c> tds = new List<Risk_Detail__c>();
        for (Risk__c t : tlist) {
            List<Risk_Detail__c> tdlist = t.Risk_Details__r;
            tdlist = tdlist.deepClone(false);
            for (Risk_Detail__c td : tdlist) {td.Risk__c = t.Id; tds.add(td);}
        }
        return tds;
    }
    
    private static List<Risk_Detail__c> getNextYearRiskDetails(List<Risk__c> dlist) {
        List<Risk_Detail__c> tds = getClonedRiskDetails(dlist);
        if (!tds.isEmpty()) {
            for (Risk_Detail__c td : tds) {
                td.Price_CY__c = td.Price_NY__c == null ? 0 : td.Price_NY__c;
                td.Volume_at_Risk_CY__c = td.Volume_at_Risk_NY__c == null ? 0 : td.Volume_at_Risk_NY__c;
                td.Price_NY__c = 0; td.Volume_at_Risk_NY__c = 0;
            }
        }
        return tds;
    }
    
    private static List<Risk__c> getRisksToClose(List<Risk__c> tlist) {
        List<Risk__c> clist = new List<Risk__c>(), rlist;
        debug('getRisksToClose : tlist = ' + tlist);
        for (Risk__c t : tlist) {
            if (isClosed(t) || isDraft(t)) {continue;}
            rlist = t.Cloned_Risks__r;
            if (rlist == null || rlist.isEmpty()) {clist.add(t);}
        }
        debug('getRisksToClose : clist = ' + clist);
        return clist;
    } 
        
}