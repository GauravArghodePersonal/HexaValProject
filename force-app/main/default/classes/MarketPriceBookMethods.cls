public class MarketPriceBookMethods {

    public static final String MAX_LIMIT   = ' limit 10000';

    public static final String ACTIVE      = 'Active';
    public static final String APPROVED    = 'Approved but not Active yet';
    public static final String DRAFT       = 'Draft';
    public static final String EXPIRED     = 'Expired';
    public static final String SUBMITTED   = 'In Approval Process';

    public static final String ASSOCIATED  = 'associated';
    public static final String HARD_WIRED  = 'hardWired';
    public static final String SOFT_WIRED  = 'softWired';

    public static final String SEMI_COLON  = ';';

    public static final List<String> MPB_KEY_FIELDS = new List<String>{
        'Sales_Org_Key__c',
        'Dist_Channel_Key__c',
        'Division_Key__c',
        'PAC_Industry_Segment_Key__c',
        'Country_Key__c',
        'Family_Key__c',
        'Segment_Key__c',
        'Sub_Segment_Key__c',
        'IncoTerm_Key__c',
        'Customer_Group_1_Key__c',
        'VCP_Rating_Key__c',
        'Product_Line_Key__c'
    };

    public static final Set<String> WIRED_TYPES  = new Set<String>{ASSOCIATED, HARD_WIRED, SOFT_WIRED};

    public static final Set<String> PC_STATS1 = new Set<String>{
        PricingConditionFunctions.CANCELLED, PricingConditionFunctions.EXPIRED
    };

    public static final Set<String> PC_STATS2 = new Set<String>{
        PricingConditionFunctions.ACTIVE, PricingConditionFunctions.APPROVED
    };

    public static final Set<String> PB_STATS2 = new Set<String>{ACTIVE, APPROVED};

    public static final String EXPIRE_MPBS = 'Expire Matching Market Price Books';

    private static Boolean debugMode, crudfailed;

    static {
        Market_Price_Book_Security__c mpbSecurity = Market_Price_Book_Security__c.getInstance();
        setDebugMode(mpbSecurity.Apex_Debug_Mode__c);
    }
    @TestVisible private static void setDebugMode(Boolean b) {debugMode = b;}
    public static Boolean getDebugMode() {return debugMode;}

    private static void debug(String s) {System.debug(LoggingLevel.INFO, 'MarketPriceBookMethods : ' + s);}

    public static String getMpbQry() {
        String s = '';
        s += 'select Id, Name, Active__c, Expired_By__c,';
        s += '       Current_State__c, Record_Status__c,';
        s += '       Valid_From_Date__c, Valid_To_Date__c';
        s += '  from Market_Price_Book__c';
        return s;
    }

    public static String getMpbWrkQry() {
        String s = '';
        s += 'select Id, Name, MFD__c, Market_Price_Book__c, Pricing_Condition__c';
        s += '  from Market_Price_Book_Work_When_Approved__c';
        return s;
    }

    public static String getMpbeQry() {
        String s = '';
        s += 'select Id, Name, CurrencyIsoCode, Market_Price_Book__c, Material_Sales_Data2__c,';
        s += '       Selling_UOM__c, Valid_From_Date__c, Valid_To_Date__c, Volume_UOM__c,';
        s += '      (select Id, Name, Maximum_Volume__c, Minimum_Volume__c,';
        s += '              Quantity_Surcharge__c, Selling_Price__c';
        s += '         from Market_Price_Book_Scaled_Pricing_Entries__r)';
        s += '  from Market_Price_Book_Entry__c';
        return s;
    }

    public static String getPcnQry() {
        String s = '';
        s += 'select Id, Name, Account__c, Market_Price_Book_Entry__c,';
        s += '       Market_Pricing_Type__c, Record_Status__c';
        s += '  from Pricing_Condition__c';
        s += ' where Market_Price_Book_Entry__c != null';
        return s;
    }

    public static String getAccMpbeQry() {
        String s = '';
        s += 'select Id, Account__c, Market_Price_Book_Entry__c, Material_Sales_Data2__c';
        s += '  from Account_To_Market_Price_Book_Entry__c';
        return s;
    }

    private Enum Crud {DEL, INS, UPD, UPS}

    private static void doCrud(Crud c, List<SObject> alist, String msg) {
        crudfailed = false; debug('debugMode = ' + debugMode);
        if (debugMode || alist == null || alist.isEmpty()) {return;}
        try {
            if (c == Crud.DEL) {delete alist;} else
            if (c == Crud.INS) {insert alist;} else
            if (c == Crud.UPD) {update alist;} else
            if (c == Crud.UPS) {upsert alist;} else {}
        } catch(Exception e) {
            crudfailed = true; debug('Error : ' + msg + ' : ' + e.getMessage());
        }
    }

    public static void doBeforeUpsert(List<Market_Price_Book__c> alist) {
        String astat;
        for (Market_Price_Book__c a : alist) {
            astat = a.Record_Status__c == null ? '' : a.Record_Status__c;
            if (!EXPIRED.equalsIgnoreCase(astat)) {a.Expired_By__c = null;}
        }
    }

    public static void doAfterUpdate(List<Market_Price_Book__c> alist, Map<Id, Market_Price_Book__c> omap) {
        Market_Price_Book__c o; Set<Id> aprvdSet = new Set<Id>();
        for (Market_Price_Book__c a : alist) {
            o = omap.get(a.Id); if (isApproved(a, o)) {aprvdSet.add(a.Id);}
        }
        //setMatchingMpbsToExpire(aprvdSet);
    }

    private static Boolean isApproved(Market_Price_Book__c a, Market_Price_Book__c o) {
        String astat = a.Record_Status__c == null ? '' : a.Record_Status__c.toLowerCase();
        String ostat = o.Record_Status__c == null ? '' : o.Record_Status__c.toLowerCase();
        return (astat != ostat && ACTIVE.equalsIgnoreCase(astat));
    }

    private static Boolean isApproved(Market_Price_Book__c a) {
        return PB_STATS2.contains(a.Record_Status__c);
    }

    private static Boolean isExpired(Market_Price_Book__c a) {
        String astat = a.Record_Status__c == null ? '' : a.Record_Status__c;
        return (EXPIRED.equalsIgnoreCase(astat) && a.Expired_By__c == null);
    }

    private static Boolean isExpired(Market_Price_Book_Entry__c a) {
        String astat = a.Record_Status__c == null ? '' : a.Record_Status__c;
        return (EXPIRED.equalsIgnoreCase(astat) && a.Expired_By__c == null);
    }

    @TestVisible
    private static Boolean isExpiredByClone(Market_Price_Book__c a) {
        String astat = a.Record_Status__c == null ? '' : a.Record_Status__c;
        return (EXPIRED.equalsIgnoreCase(astat) && a.Expired_By__c != null);
    }

    private static Boolean isExpiredByClone(Market_Price_Book_Entry__c a) {
        String astat = a.Record_Status__c == null ? '' : a.Record_Status__c;
        return (EXPIRED.equalsIgnoreCase(astat) && a.Expired_By__c != null);
    }

    private static Boolean isApproved(Pricing_Condition__c pc) {
        return PC_STATS2.contains(pc.Record_Status__c);
    }

    private static Boolean isDraft(Pricing_Condition__c pc) {
        return PricingConditionFunctions.DRAFT.equals(pc.Record_Status__c);
    }

    private static Boolean isExpired(Pricing_Condition__c pc) {
        return PC_STATS1.contains(pc.Record_Status__c);
    }

    private static Boolean isInApproval(Pricing_Condition__c pc) {
        return PricingConditionFunctions.SUBMITTED.equals(pc.Record_Status__c);
    }

    private static Boolean isWired(Pricing_Condition__c pc) {
        return (pc != null && pc.Market_Pricing_Type__c != null &&
                WIRED_TYPES.contains(pc.Market_Pricing_Type__c));
    }

    public static Id relateMarketPriceEntrytoAccount(id marketPriceEntryId, id accountId,
                                                     String availableMarketPricingTypes) {
        Account_To_Market_Price_Book_Entry__c rec;

        if (availableMarketPricingTypes == '') {
            availableMarketPricingTypes = 'hardwired;softWired;associated';
        }

        try {
            rec = [SELECT Id,
                          Account__c,
                          Available_Market_Pricing_Types__c,
                          Market_Price_Book_Entry__c,
                          Material_Sales_Data2__c
                     FROM Account_To_Market_Price_Book_Entry__c
                    WHERE Account__c = :accountId
                      AND Market_Price_Book_Entry__c = :marketPriceEntryId
                  ];
        }
        catch (Exception e) {
            rec = new Account_To_Market_Price_Book_Entry__c();
            rec.Account__c = accountId;
            rec.Market_Price_Book_Entry__c = marketPriceEntryId;
            rec.Material_Sales_Data2__c = [
                SELECT Material_Sales_Data2__c FROM Market_Price_Book_Entry__c
                 WHERE Market_Price_Book_Entry__c.Id = :marketPriceEntryId].Material_Sales_Data2__c;
        }

        rec.Available_Market_Pricing_Types__c = availableMarketPricingTypes;

        upsert rec;

        return rec.Id;
    }

    public static void unrelateMarketPriceEntrytoAccount(id marketPriceEntryId, id accountId) {
        Account_To_Market_Price_Book_Entry__c rec;

        try {
            rec = [SELECT Id,
                          Account__c,
                          Available_Market_Pricing_Types__c,
                          Material_Sales_Data2__c,
                          Market_Price_Book_Entry__c
                     FROM Account_To_Market_Price_Book_Entry__c
                    WHERE Account__c = :accountId
                      AND Market_Price_Book_Entry__c = :marketPriceEntryId
                  ];
             delete rec;
        }
        catch (Exception e) {}
    }

    public static Boolean isUserAllowedToExpireMPB() {
        Market_Price_Book_Security__c mpbSecurity = Market_Price_Book_Security__c.getInstance();
        return mpbSecurity.Allowed_to_Expire_MPB__c;
    }

    public static Boolean isUserAllowedToUnexpireMPB() {
        Market_Price_Book_Security__c mpbSecurity = Market_Price_Book_Security__c.getInstance();
        return mpbSecurity.Admin_Allowed_to_Unexpire_MPB__c;
    }

    private static Market_Price_Book__c retrieveMPB(Id mpbId) {
        Market_Price_Book__c mpb = [
            SELECT Id, Active__c, Current_State__c, Record_Status__c
              FROM Market_Price_Book__c WHERE Id = :mpbId];
        return mpb;
    }

    public static Boolean canBeExpired(Id mpbId) {
        Market_Price_Book__c mpb = retrieveMPB(mpbId);
        return (isUserAllowedToExpireMPB() && mpb.Current_State__c != EXPIRED && mpb.Active__c);
    }

    public static Boolean canBeUnexpired(Id mpbId) {
        Market_Price_Book__c mpb = retrieveMPB(mpbId);
        return (isUserAllowedToUnexpireMPB() && mpb.Current_State__c == EXPIRED);
    }

    public static List<AshError> expire(Id mpbId) {
        List<AshError> errors = new List<AshError>();

        Market_Price_Book__c mpb = retrieveMPB(mpbId); setToExpire(mpb);

        try {
            update mpb;
        }
        catch (Exception e) {
            AshError error = new AshError('Error setting a Market Price Book to Expired. ' + e.getMessage(),
                                          AshError.SEVERITY_FATAL);
            errors.add(error);
        }

        return errors;
    }

    public static List<AshError> unexpireAndMakeDraft(Id mpbId) {
        List<AshError> errors = new List<AshError>();

        Market_Price_Book__c mpb = retrieveMPB(mpbId); setToDraft(mpb);

        try {
            update mpb;
        }
        catch (Exception e) {
            AshError error = new AshError('Error setting a Market Price Book to Draft. ' + e.getMessage(),
                                          AshError.SEVERITY_FATAL);
            errors.add(error);
        }

        return errors;
    }

    private static Boolean isToExpire(Market_Price_Book__c a) {
        Boolean b;
        b = (a != null && a.Active__c != null && a.Active__c &&
             a.Valid_To_Date__c != null && a.Valid_To_Date__c < Date.today());
        debug('isToExpire : b = ' + b + ' : a = ' + a);
        return b;
    }

    private static void setToActive(Market_Price_Book__c a) {
        a.Active__c = true;
        a.Current_State__c = ACTIVE;
        a.Record_Status__c = ACTIVE;
    }

    private static void setToDraft(Market_Price_Book__c a) {
        a.Active__c = false;
        a.Current_State__c = DRAFT;
        a.Record_Status__c = DRAFT;
    }

    @TestVisible
    private static void setToExpire(Market_Price_Book__c a) {
        a.Active__c = false;
        a.Current_State__c = EXPIRED;
        a.Record_Status__c = EXPIRED;
    }

    private static Double n2z(Decimal d) {return (d == null ? 0.0 : d.doubleValue());}

    //private static Double n2z(Double d) {return (d == null ? 0.0 : d);}

    private static Boolean notEqual(Decimal d1, Decimal d2) {
        debug('notEqual : d1 = ' + d1 + ' : d2 = ' + d2);
        return (n2z(d1) != n2z(d2));
    }

    //private static Boolean notEqual(Double d1, Double d2) {return (n2z(d1) != n2z(d2));}

    private static Boolean notEqual(Date d1, Date d2) {
        return (d1 == null && d2 != null) || (d1 != null && d2 == null) || (d1 != d2);
    }

    private static Map<Integer, Market_Price_Book_Scaled_Pricing_Entry__c> getMpbSpeMap(Market_Price_Book_Entry__c e2) {
        Map<Integer, Market_Price_Book_Scaled_Pricing_Entry__c> smap2 = new
        Map<Integer, Market_Price_Book_Scaled_Pricing_Entry__c>();
        List<Market_Price_Book_Scaled_Pricing_Entry__c> slist2 = e2.Market_Price_Book_Scaled_Pricing_Entries__r;
        if (slist2 == null || slist2.isEmpty()) {return smap2;}
        for (Market_Price_Book_Scaled_Pricing_Entry__c s : slist2) {
            if (s.Minimum_Volume__c != null) {smap2.put(s.Minimum_Volume__c.intValue(), s);}
        }
        return smap2;
    }

    @TestVisible
    private static Boolean isChanged(Market_Price_Book_Entry__c e1, Market_Price_Book_Entry__c e2) {
        Boolean b = false; if (e1 == null || e2 == null) {return b;}
        b = notEqual(e1.Valid_From_Date__c, e2.Valid_From_Date__c) ||
            notEqual(e1.Valid_To_Date__c, e2.Valid_To_Date__c); if (b) {return b;}
        List<Market_Price_Book_Scaled_Pricing_Entry__c> slist1 = e1.Market_Price_Book_Scaled_Pricing_Entries__r,
                                                        slist2 = e2.Market_Price_Book_Scaled_Pricing_Entries__r;
        b = (slist1 == null && slist2 != null) || (slist1 != null && slist2 == null) ||
            (slist1 != null && slist2 != null && slist1.size() != slist2.size()); if (b) {return b;}
        Map<Integer, Market_Price_Book_Scaled_Pricing_Entry__c> smap2 = getMpbSpeMap(e2);
        Market_Price_Book_Scaled_Pricing_Entry__c s2; Integer k;
        for (Market_Price_Book_Scaled_Pricing_Entry__c s1 : slist1) {
            if (s1.Minimum_Volume__c == null) {continue;}
            k = s1.Minimum_Volume__c.intValue(); if (!smap2.containsKey(k)) {return true;}
            s2 = smap2.get(k); if (isChanged(s1, s2)) {return true;}
        }
        return false;
    }

    private static Boolean isChanged(Market_Price_Book_Scaled_Pricing_Entry__c s1,
                                     Market_Price_Book_Scaled_Pricing_Entry__c s2) {
        if ((s1 == null && s2 != null) || (s1 != null && s2 == null))     {return true;}
        if (notEqual(s1.Maximum_Volume__c,     s2.Maximum_Volume__c))     {return true;}
        if (notEqual(s1.Quantity_Surcharge__c, s2.Quantity_Surcharge__c)) {return true;}
        if (notEqual(s1.Selling_Price__c,      s2.Selling_Price__c))      {return true;}
        return false;
    }
/*
    @TestVisible
    private static Boolean isChanged(Market_Price_Book_Entry__c pbe, Pricing_Condition__c pcn) {
        Boolean b = false; if (pbe == null || pcn == null) {return b;}
        b = notEqual(pbe.Valid_From_Date__c, pcn.Valid_From_Date__c) ||
            notEqual(pbe.Valid_To_Date__c, pcn.Valid_To_Date__c); if (b) {return b;}
        List<Market_Price_Book_Scaled_Pricing_Entry__c> mlist = pbe.Market_Price_Book_Scaled_Pricing_Entries__r;
        List<Pricing_Condition_Scaled_Pricing__c> plist = pcn.Pricing_Condition_Scaled_Pricing__r;
        b = (mlist == null && plist != null) || (mlist != null && plist == null) ||
            (mlist != null && plist != null && mlist.size() != plist.size());
        if (b) {return b;}
        Map<Integer, Pricing_Condition_Scaled_Pricing__c> pmap = new
        Map<Integer, Pricing_Condition_Scaled_Pricing__c>();
        for (Pricing_Condition_Scaled_Pricing__c p : plist) {
            if (p.Minimum_Volume__c != null) {pmap.put(p.Minimum_Volume__c.intValue(), p);}
        }
        Pricing_Condition_Scaled_Pricing__c p; Integer k;
        Double adj = n2z(pcn.Market_Pricing_Adjustment_Value__c);
        for (Market_Price_Book_Scaled_Pricing_Entry__c m : mlist) {
            if (m.Minimum_Volume__c == null) {continue;}
            k = m.Minimum_Volume__c.intValue(); if (!pmap.containsKey(k)) {return true;}
            p = pmap.get(k); if (isChanged(m, p, adj)) {return true;}
        }
        return false;
    }

    private static Boolean isChanged(Market_Price_Book_Scaled_Pricing_Entry__c m,
                                     Pricing_Condition_Scaled_Pricing__c p, Double adj) {
        if ((m == null && p != null) || (m != null && p == null)) {return true;}
        if (notEqual(m.Maximum_Volume__c, p.Maximum_Volume__c)) {return true;}
        if (notEqual(m.Quantity_Surcharge__c, p.Quantity_Surcharge__c)) {return true;}
        Double msp = n2z(m.Selling_Price__c);
        Double psp = n2z(p.Scaled_Selling_Price__c) - n2z(p.Quantity_Surcharge__c) - adj;
        if (notEqual(msp, psp)) {return true;}
        return false;
    }
*/
    public static Account_To_Market_Price_Book_Entry__c getClonedAccMpbe(Account_To_Market_Price_Book_Entry__c a) {
        List<Account_To_Market_Price_Book_Entry__c> alist = new List<Account_To_Market_Price_Book_Entry__c>{a};
        List<Account_To_Market_Price_Book_Entry__c> clist = alist.deepClone(true); clist = clist.deepClone(false);
        return clist[0];
    }

    public static Pricing_Condition__c getClonedPcn(Pricing_Condition__c pcn, Market_Price_Book_Entry__c pbe,
                                                    List<Pricing_Condition_Scaled_Pricing__c> blist) {
        Pricing_Condition__c pc = PricingConditionFunctions.getClonedPricingCondition(pcn);
        pc.Market_Price_Book_Entry__c = pbe.Id;
        if (ASSOCIATED == pc.Market_Pricing_Type__c) {
            for (Pricing_Condition_Scaled_Pricing__c b : pc.Pricing_Condition_Scaled_Pricing__r) {blist.add(b);}
            return pc;
        }
        setPcnFields2(pc, pbe);
        List<Market_Price_Book_Scaled_Pricing_Entry__c> alist = pbe.Market_Price_Book_Scaled_Pricing_Entries__r;
        if (alist == null || alist.isEmpty()) {return pc;} Pricing_Condition_Scaled_Pricing__c b;
        if (blist == null) {blist = new List<Pricing_Condition_Scaled_Pricing__c>();}
        for (Market_Price_Book_Scaled_Pricing_Entry__c a : alist) {
            b = new Pricing_Condition_Scaled_Pricing__c();
            setPcnScaleFields(pbe, a, pc, b); blist.add(b);
        }
        return pc;
    }

    private static void setPcnFields1(Pricing_Condition__c pc, Market_Price_Book_Entry__c pbe) {
        pc.Market_Price_Book_Entry__c = pbe.Id;
        if (ASSOCIATED == pc.Market_Pricing_Type__c) {return;}
        setPcnFields2(pc, pbe);
        Map<Integer, Market_Price_Book_Scaled_Pricing_Entry__c> amap = getMpbSpeMap(pbe);
        if (amap.isEmpty()) {return;}
        Market_Price_Book_Scaled_Pricing_Entry__c a; Integer k;
        for (Pricing_Condition_Scaled_Pricing__c b : pc.Pricing_Condition_Scaled_Pricing__r) {
            if (b.Minimum_Volume__c == null) {continue;}
            k = b.Minimum_Volume__c.intValue();
            if (amap.containsKey(k)) {a = amap.get(k); setPcnScaleFields(pbe, a, pc, b);}
        }
    }

    private static void setPcnFields2(Pricing_Condition__c pc, Market_Price_Book_Entry__c pbe) {
        pc.CurrencyIsoCode = pbe.CurrencyIsoCode; pc.Selling_UOM__c = pbe.Selling_UOM__c; pc.Volume_UOM__c = pbe.Volume_UOM__c;
        pc.Valid_From_Date__c = pbe.Valid_From_Date__c; pc.Valid_To_Date__c = pbe.Valid_To_Date__c;
    }

    private static void setPcnScaleFields(Market_Price_Book_Entry__c pbe,
                                          Market_Price_Book_Scaled_Pricing_Entry__c a,
                                          Pricing_Condition__c pc,
                                          Pricing_Condition_Scaled_Pricing__c b) {
        b.CurrencyIsoCode       = pbe.CurrencyIsoCode;
        b.Maximum_Volume__c     = a.Maximum_Volume__c;
        b.Minimum_Volume__c     = a.Minimum_Volume__c;
        b.Quantity_Surcharge__c = a.Quantity_Surcharge__c;
        b.Selling_Price__c      = a.Selling_Price__c + b.Quantity_Surcharge__c;
        if (SOFT_WIRED == pc.Market_Pricing_Type__c) {
            b.Selling_Price__c += pc.Market_Pricing_Adjustment_Value__c;
        }
        b.Scaled_Selling_Price__c         = b.Selling_Price__c;
        b.Selling_Price_with_Upcharges__c = b.Scaled_Selling_Price__c;
    }

    public static List<Market_Price_Book__c> getMpbList() {
        String q = getMpbQry() + MAX_LIMIT;
        return Database.query(q);
    }

    public static Market_Price_Book__c getMpb(Id mpbId) {
        Set<Id> aset = new Set<Id>{mpbId};
        List<Market_Price_Book__c> alist = getMpbs(aset);
        return alist[0];
    }

    private static List<Market_Price_Book__c> getMpbs(Set<Id> aset) {
        List<Market_Price_Book__c> alist = new List<Market_Price_Book__c>();
        if (aset == null || aset.isEmpty()) {return alist;}
        String q = getMpbQry() + ' where Id in :aset';
        alist = Database.query(q); return alist;
    }

    public static Market_Price_Book_Entry__c getMpbe(String mpbeId) {
        Set<String> mpbeIds = new Set<String>{mpbeId};
        Map<String, Market_Price_Book_Entry__c> amap = getMpbeMap(mpbeIds);
        return amap.values()[0];
    }

    public static Map<String, Market_Price_Book_Entry__c> getMpbeMap(List<String> mpbeIds) {
        Map<String, Market_Price_Book_Entry__c> amap = new Map<String, Market_Price_Book_Entry__c>();
        if (mpbeIds == null || mpbeIds.isEmpty()) {return amap;}
        Set<String> aset = new Set<String>(); aset.addAll(mpbeIds);
        return getMpbeMap(aset);
    }

    public static Map<String, Market_Price_Book_Entry__c> getMpbeMap(Set<String> mpbeIds) {
        Map<String, Market_Price_Book_Entry__c> amap = new Map<String, Market_Price_Book_Entry__c>();
        if (mpbeIds == null || mpbeIds.isEmpty()) {return amap;}
        String q = getMpbeQry() + ' where Id in :mpbeIds';
        for (Market_Price_Book_Entry__c a : Database.query(q)) {amap.put(a.Id, a);}
        return amap;
    }

    public static Map<String, Market_Price_Book_Entry__c> getMpbeMap(Set<Id> pbIds, Set<Id> matIds) {
        Map<String, Market_Price_Book_Entry__c> amap = new Map<String, Market_Price_Book_Entry__c>();
        if (pbIds == null || pbIds.isEmpty() || matIds == null || matIds.isEmpty()) {return amap;}
        String q = getMpbeQry() + ' where Market_Price_Book__c in :pbIds';
        q +=                        ' and Material_Sales_Data2__c in :matIds';
        for (Market_Price_Book_Entry__c a : Database.query(q)) {
            amap.put(getKey(a.Market_Price_Book__c, a.Material_Sales_Data2__c), a);
        }
        return amap;
    }

    public static List<Market_Price_Book_Work_When_Approved__c> getMpbWrks(Set<Id> wrkIds) {
        List<Market_Price_Book_Work_When_Approved__c> alist = new
        List<Market_Price_Book_Work_When_Approved__c>();
        if (wrkIds == null || wrkIds.isEmpty()) {return alist;}
        String q = getMpbWrkQry() + ' where Id in :wrkIds';
        q += ' and MFD__c = false';
        alist = Database.query(q); return alist;
    }

    public static List<Market_Price_Book_Work_When_Approved__c> getMpbWrkPcns(Set<Id> pcnIds) {
        List<Market_Price_Book_Work_When_Approved__c> alist = new
        List<Market_Price_Book_Work_When_Approved__c>();
        if (pcnIds == null || pcnIds.isEmpty()) {return alist;}
        String q = getMpbWrkQry() + ' where Pricing_Condition__c in :pcnIds';
        q += ' and MFD__c = false';
        alist = Database.query(q); return alist;
    }

    public static List<Account_To_Market_Price_Book_Entry__c> getAccMpbes(Set<Id> aset) {
        List<Account_To_Market_Price_Book_Entry__c> alist = new
        List<Account_To_Market_Price_Book_Entry__c>();
        if (aset == null || aset.isEmpty()) {return alist;}
        String q = getAccMpbeQry() + ' where Market_Price_Book_Entry__r.Market_Price_Book__c in :aset';
        alist = Database.query(q); return alist;
    }

    private static Set<String> getAccMpbesKeys(Set<Id> aset, Set<Id> eset) {
        Set<String> kset = new Set<String>();
        if (aset == null || aset.isEmpty() || eset == null || eset.isEmpty()) {return kset;}
        String q = getAccMpbeQry();
        q += ' where Account__c in :aset and Market_Price_Book_Entry__c in :eset';
        for (Account_To_Market_Price_Book_Entry__c a : Database.query(q)) {
            kset.add(getKey(a.Account__c, a.Market_Price_Book_Entry__c));
        }
        return kset;
    }

    private static Map<String, String> getMatMpbeMap(Id mpbId) {
        Map<String, String> amap = new Map<String, String>(); if (String.isBlank(mpbId)) {return amap;}
        for (Market_Price_Book_Entry__c a : [
            select Id, Material_Sales_Data2__c
              from Market_Price_Book_Entry__c
             where Market_Price_Book__c = :mpbId]) {
            amap.put(a.Material_Sales_Data2__c, a.Id);
        }
        return amap;
    }

    public static void setMatchingMpbsToExpire(Set<Id> aset) {
        if (aset == null || aset.isEmpty()) {return;}
        List<Market_Price_Book__c> alist = getMpbs(aset);
        setMatchingMpbsToExpire(alist);
    }

    public static void setMatchingMpbsToExpire(List<Market_Price_Book__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        List<Market_Price_Book_Work_When_Approved__c> ilist = new
        List<Market_Price_Book_Work_When_Approved__c>();
        Market_Price_Book_Work_When_Approved__c i;
        Date tdate = Date.today(); String astat;
        for (Market_Price_Book__c a : alist) {
            astat = a.Record_Status__c == null ? '' : a.Record_Status__c;
            if (!ACTIVE.equalsIgnoreCase(astat) || a.Valid_From_Date__c > tdate) {continue;}
            i = new Market_Price_Book_Work_When_Approved__c();
            i.Market_Price_Book__c = a.Id;
            i.Operation__c = EXPIRE_MPBS;
            ilist.add(i);
        }
        debug('setMatchingMpbsToExpire : ' + ilist);
        //doCrud(Crud.INS, ilist, 'setMatchingMpbsToExpire');
    }

    public static void activateMpbs(Set<Id> aset) {activateMpbs(aset, debugMode);}

    public static void activateMpbs(Set<Id> aset, Boolean dbgmd) {
        if (aset == null || aset.isEmpty()) {return;}
        List<Market_Price_Book__c> alist = getMpbs(aset);
        debugMode = dbgmd; activateMpbs(alist);
    }

    public static void activateMpbs(List<Market_Price_Book__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        List<Market_Price_Book__c> mlist, ulist = new List<Market_Price_Book__c>();
        Date tdate = Date.today(); String astat, mstat; Set<Id> mset;
        for (Market_Price_Book__c a : alist) {
            debug('activateMpbs : ' + a.Name + ' : ' + a.Id);
            astat = a.Record_Status__c == null ? '' : a.Record_Status__c;
            if (!APPROVED.equalsIgnoreCase(astat) || a.Valid_From_Date__c > tdate) {continue;}
            setToActive(a); ulist.add(a);
            mlist = getMatchingMpbs(a.Id); mset = new Set<Id>();
            for (Market_Price_Book__c m : mlist) {
                if (m.Id == a.Id) {continue;}
                mstat = m.Record_Status__c == null ? '' : m.Record_Status__c;
                debug('activateMpbs : ' + m.Name + ' : ' + mstat + ' : ' + m.Valid_From_Date__c);
                if (!ACTIVE.equalsIgnoreCase(mstat) || m.Valid_From_Date__c > tdate) {continue;}
                mset.add(m.Id); debug('activateMpbs : m = ' + m.Name + ' : ' + m.Id);
            }
            debug('activateMpbs : expiring = ' + mset);
            if (!mset.isEmpty()) {expireMpbs(a.Id, mset);}
        }
        debug('activateMpbs : activating = ' + ulist);
        doCrud(Crud.UPD, ulist, 'activateMpbs');
    }

    public static void expireMpbs(Set<Id> aset) {expireMpbs(aset, debugMode);}

    public static void expireMpbs(Set<Id> aset, Boolean dbgmd) {
        if (aset == null || aset.isEmpty()) {return;} debugMode = dbgmd;
        List<Market_Price_Book__c> blist = new List<Market_Price_Book__c>();
        Date tdate = Date.today().addDays(-1);
        for (Market_Price_Book__c a : getMpbs(aset)) {
            if (!isApproved(a)) {continue;}
            if (a.Valid_From_Date__c > tdate) {a.Valid_From_Date__c = tdate;}
            if (a.Valid_To_Date__c   > tdate) {a.Valid_To_Date__c   = tdate;}
            blist.add(a); debug('expiring : ' + a);
        }
        if (blist.isEmpty()) {return;}
        doCrud(Crud.UPD, blist, 'expireMpbs'); if (crudfailed) {return;}
        expireMpbs(blist);
    }

    public static void expireMpbs(List<Market_Price_Book__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        List<Market_Price_Book__c> blist = new List<Market_Price_Book__c>();
        for (Market_Price_Book__c a : alist) {
            if (isToExpire(a)) {setToExpire(a); blist.add(a);}
        }
        debug('expireMpbs : blist.size = ' + blist.size());
        doCrud(Crud.UPD, blist, 'expireMpbs');
    }

    private static void expireMpbs(Id mpbId, Set<Id> aset) {
        if (aset == null || aset.isEmpty()) {return;}
        List<Market_Price_Book__c> alist = getMpbs(aset);
        Map<String, String> amap = getMatMpbeMap(mpbId);
        for (Market_Price_Book__c a : alist) {
            setToExpire(a); a.Expired_By__c = mpbId;
            expireMpbes(a.Id, amap);
        }
        debug('expireMpbs : ' + alist);
        doCrud(Crud.UPD, alist, 'expireMpbs');
    }

    private static void expireMpbes(Id mpbId, Map<String, String> mpbeMap) {
        if (mpbeMap == null || mpbeMap.isEmpty()) {return;}
        String expiredBy; List<Market_Price_Book_Entry__c> blist;
        for (List<Market_Price_Book_Entry__c> alist : [
            select Id, Expired_By__c, Material_Sales_Data2__c
              from Market_Price_Book_Entry__c
             where Market_Price_Book__c = :mpbId]) {
            blist = new List<Market_Price_Book_Entry__c>();
            for (Market_Price_Book_Entry__c a : alist) {
                if (mpbeMap.containsKey(a.Material_Sales_Data2__c)) {
                    expiredBy = mpbeMap.get(a.Material_Sales_Data2__c);
                    a.Expired_By__c = expiredBy; blist.add(a);
                    debug('expireMpbes : a = ' + a);
                }
            }
            doCrud(Crud.UPD, blist, 'expireMpbes');
        }
    }

    private static String getSortedPickList(String s1) {
        String s2 = ''; if (String.isBlank(s1)) {return s2;}
        List<String> sa = s1.split(SEMI_COLON); sa.sort();
        for (String s : sa) {s2 += s.trim();}
        //debug('getSortedPickList : ' + s2);
        return s2;
    }

    private static Boolean isMatching(Market_Price_Book__c m1, Market_Price_Book__c m2) {
        String s1, s2;

        for (String s : MPB_KEY_FIELDS) {
            s1 = getSortedPickList((String)m1.get(s));
            s2 = getSortedPickList((String)m2.get(s));
            if (!s1.equals(s2)) {
                debug(s + ':' + m1.Name + ':' + s1 + ':' +  m2.Name + ':' + s2);
                return false;
            }
        }

        return true;
    }

    private static List<Market_Price_Book__c> getMatchingMpbs(Id mpbId) {
        Market_Price_Book__c mpb = [select Id, Name,
                Sales_Org_Key__c,
                Dist_Channel_Key__c,
                Division_Key__c,
                PAC_Industry_Segment_Key__c,
                Country_Key__c,
                Family_Key__c,
                Segment_Key__c,
                Sub_Segment_Key__c,
                IncoTerm_Key__c,
                Customer_Group_1_Key__c,
                VCP_Rating_Key__c,
                Product_Line_Key__c
           from Market_Price_Book__c where Id = :mpbId];

        List<Market_Price_Book__c> mpbs = new List<Market_Price_Book__c>();

        for (Market_Price_Book__c m : getMpbs(
            mpb.Sales_Org_Key__c,
            mpb.Dist_Channel_Key__c,
            mpb.Division_Key__c,
            mpb.PAC_Industry_Segment_Key__c,
            mpb.Country_Key__c,
            mpb.Family_Key__c,
            mpb.Segment_Key__c,
            mpb.Sub_Segment_Key__c,
            mpb.IncoTerm_Key__c,
            mpb.Customer_Group_1_Key__c,
            mpb.VCP_Rating_Key__c,
            mpb.Product_Line_Key__c)) {
            if (isMatching(mpb, m)) {mpbs.add(m);}
        }

        return mpbs;
    }

    public static List<Market_Price_Book__c> getMpbs(
        String salesOrgKey,
        String distChannelKey,
        String divisionKey,
        String PACIndustrySegmentKey,
        String countryKey,
        String familyKey,
        String segmentKey,
        String subSegmentKey,
        String incoTermKey,
        String custGroup1Key,
        String vcpRatingKey,
        String productLineKey) {
        List<Market_Price_Book__c> alist = [
             SELECT Id, Name, Expired_By__c, Record_Status__c, Valid_From_Date__c,
                    Sales_Org_Key__c,
                    Dist_Channel_Key__c,
                    Division_Key__c,
                    PAC_Industry_Segment_Key__c,
                    Country_Key__c,
                    Family_Key__c,
                    Segment_Key__c,
                    Sub_Segment_Key__c,
                    IncoTerm_Key__c,
                    Customer_Group_1_Key__c,
                    VCP_Rating_Key__c,
                    Product_Line_Key__c
               FROM Market_Price_Book__c
              WHERE Sales_Org_Key__c includes (:salesOrgKey)
                AND Dist_Channel_Key__c includes (:distChannelKey)
                AND Division_Key__c includes (:divisionKey)
                AND PAC_Industry_Segment_Key__c includes (:PACIndustrySegmentKey)
                AND Country_Key__c includes (:countryKey)
                AND Family_Key__c includes (:familyKey)
                AND Segment_Key__c includes (:segmentKey)
                AND Sub_Segment_Key__c includes (:subSegmentKey)
                AND IncoTerm_Key__c includes (:incoTermKey)
                AND Customer_Group_1_Key__c includes (:custGroup1Key)
                AND VCP_Rating_Key__c includes (:vcpRatingKey)
                AND Product_Line_Key__c includes (:productLineKey)];
        return alist;
    }

    private static String getKey(Id id1, Id id2) {return id1 + ':' + id2;}

    private static void setMpbMaps(Set<Id> pbeIds,
                                   Map<String, Market_Price_Book__c> bmap,
                                   Map<String, Market_Price_Book_Entry__c> emap) {
        if (pbeIds == null || pbeIds.isEmpty()) {return;}
        Set<Id> pbids = new Set<Id>();
        for (Market_Price_Book_Entry__c a : [
            select Id, Expired_By__c, Market_Price_Book__c, Record_Status__c
              from Market_Price_Book_Entry__c
             where Id in :pbeIds]) {
            emap.put(a.Id, a); pbids.add(a.Market_Price_Book__c);
        }
        for (Market_Price_Book__c a : getMpbs(pbids)) {bmap.put(a.Id, a);}
    }

    private static Map<String, Account_To_Market_Price_Book_Entry__c> getAccMpbeMap(Set<Id> accIds, Set<Id> pbeIds) {
        Map<String, Account_To_Market_Price_Book_Entry__c> amap = new
        Map<String, Account_To_Market_Price_Book_Entry__c>();
        if (accIds == null || accIds.isEmpty() || pbeIds == null || pbeIds.isEmpty()) {return amap;}
        for (Account_To_Market_Price_Book_Entry__c a : [
            select Account__c, Market_Price_Book_Entry__c
              from Account_To_Market_Price_Book_Entry__c
             where Account__c in :accIds
               and Market_Price_Book_Entry__c in :pbeIds]) {
            amap.put(getKey(a.Account__c, a.Market_Price_Book_Entry__c), a);
        }
        return amap;
    }

    private static void setAccMpbeMap(Map<String, Account_To_Market_Price_Book_Entry__c> amap,
                                      Id accId, Market_Price_Book_Entry__c mpbe) {
        String k = getKey(accId, mpbe.Id); if (amap.containsKey(k)) {return;}
        Account_To_Market_Price_Book_Entry__c a = new Account_To_Market_Price_Book_Entry__c();
        a.Account__c = accId; a.Market_Price_Book_Entry__c = mpbe.Id;
        a.Material_Sales_Data2__c = mpbe.Material_Sales_Data2__c;
        amap.put(k, a); debug('setAccMpbeMap : ampbe = ' + a);
    }

    private static void insertAccMpbes(List<Account_To_Market_Price_Book_Entry__c> accMpbes) {
        if (accMpbes == null || accMpbes.isEmpty()) {return;}
        Set<Id> accIds = new Set<Id>(), pbeIds = new Set<Id>();
        for (Account_To_Market_Price_Book_Entry__c a : accMpbes) {
            accIds.add(a.Account__c); pbeIds.add(a.Market_Price_Book_Entry__c);
        }
        Map<String, Account_To_Market_Price_Book_Entry__c> amap = getAccMpbeMap(accIds, pbeIds);
        List<Account_To_Market_Price_Book_Entry__c> alist = new
        List<Account_To_Market_Price_Book_Entry__c>();
        Account_To_Market_Price_Book_Entry__c a; String k;
        for (Account_To_Market_Price_Book_Entry__c b : accMpbes) {
            k = getKey(b.Account__c, b.Market_Price_Book_Entry__c);
            if (!amap.containsKey(k)) {alist.add(b);}
        }
        doCrud(Crud.INS, alist, 'Insert AccMpbes');
    }

    @TestVisible
    private static void processMpbWrkPcns(Set<Id> pcnIds) {
        if (pcnIds == null || pcnIds.isEmpty()) {return;}
        List<Market_Price_Book_Work_When_Approved__c> alist = getMpbWrkPcns(pcnIds);
        processMpbWrks(alist);
    }

    public static void processMpbWrks(Set<Id> wrkIds) {processMpbWrks(wrkIds, debugMode);}

    public static void processMpbWrks(Set<Id> wrkIds, Boolean dbgmd) {
        if (wrkIds == null || wrkIds.isEmpty()) {return;}
        List<Market_Price_Book_Work_When_Approved__c> alist = getMpbWrks(wrkIds);
        debugMode = dbgmd; processMpbWrks(alist);
    }

    public static void processMpbWrks(List<Market_Price_Book_Work_When_Approved__c> alist1) {
        if (alist1 == null || alist1.isEmpty()) {return;}
        Set<Id> pbIds  = new Set<Id>(), pcIds  = new Set<Id>(),
                accIds = new Set<Id>(), matIds = new Set<Id>();

        List<Market_Price_Book_Work_When_Approved__c>    alist2 = new
        List<Market_Price_Book_Work_When_Approved__c>(), alist3 = new
        List<Market_Price_Book_Work_When_Approved__c>();

        for (Market_Price_Book_Work_When_Approved__c a1 : alist1) {
            if (a1.MFD__c || a1.Market_Price_Book__c == null || a1.Pricing_Condition__c == null) {continue;}
            pbIds.add(a1.Market_Price_Book__c); pcIds.add(a1.Pricing_Condition__c); alist2.add(a1);
        }
        if (alist2.isEmpty()) {return;}

        Map<String, Market_Price_Book__c> bmap = new Map<String, Market_Price_Book__c>();
        for (Market_Price_Book__c a : getMpbs(pbids)) {
            if (isApproved(a)) {bmap.put(a.Id, a);}
        }
        if (bmap.isEmpty()) {return;}

        Map<String, Pricing_Condition__c> pmap = new Map<String, Pricing_Condition__c>();
        for (Pricing_Condition__c a : PricingConditionFunctions.getPricingConditions(pcids)) {
            if (!isExpired(a)) {
                pmap.put(a.Id, a); accIds.add(a.Account__c); matIds.add(a.Material2__c);
            }
        }
        if (pmap.isEmpty()) {return;}

        Map<String, Market_Price_Book_Entry__c> emap = getMpbeMap(pbIds, matIds);

        Market_Price_Book__c b; Market_Price_Book_Entry__c e; Pricing_Condition__c p;
        Map<String, Account_To_Market_Price_Book_Entry__c> amap = new Map<String, Account_To_Market_Price_Book_Entry__c>();
        Map<String, Pricing_Condition__c> pcmap = new Map<String, Pricing_Condition__c>();
        Map<String, List<Pricing_Condition_Scaled_Pricing__c>> spmap = new Map<String, List<Pricing_Condition_Scaled_Pricing__c>>();
        List<Pricing_Condition_Scaled_Pricing__c> sps; Integer n = 0; String k; Pricing_Condition__c pc2;
        Map<String, String> pcMpbeMap = new Map<String, String>();

        for (Market_Price_Book_Work_When_Approved__c a2 : alist2) {
            b = bmap.get(a2.Market_Price_Book__c);      if (b == null) {continue;}
            p = pmap.get(a2.Pricing_Condition__c);      if (p == null) {continue;}
            e = emap.get(getKey(b.Id, p.Material2__c)); if (e == null) {continue;}
            debug('processMpbWrks : pc = ' + p.Name + ' : mpbe = ' + e.Name);
            pcMpbeMap.put(p.Id, e.Id); setAccMpbeMap(amap, p.Account__c, e);
            alist3.add(a2); k = 'PCN-' + (++n);

        }
        if (alist3.isEmpty()) {return;}
        upsertPcns(pcMpbeMap); if (crudfailed) {return;}

        insertAccMpbes(amap.values()); if (crudfailed) {return;}

        for (Market_Price_Book_Work_When_Approved__c a3 : alist3) {a3.MFD__c = true;}
        doCrud(Crud.UPD, alist3, 'Update MpbWwa');
    }

    public static List<Pricing_Condition__c> getMpbePcnList() {
        String q = getPcnQry() + MAX_LIMIT;
        return Database.query(q);
    }

    public static void processPcns(Set<Id> idSet) {processPcns(idSet, debugMode);}

    public static void processPcns(Set<Id> idSet, Boolean dbgmd) {
        if (idSet == null || idSet.isEmpty()) {return;}
        String q = getPcnQry() + ' and Id in :idSet';
        List<Pricing_Condition__c> alist = Database.query(q);
        debugMode = dbgmd; processPcns(alist);
    }

    public static void processPcns(List<Pricing_Condition__c> pcns) {
        Set<Id> accIds = new Set<Id>(), pbeIds = new Set<Id>(); String k;
        for (Pricing_Condition__c pc : pcns) {
            if (pc.Account__c == null || pc.Market_Price_Book_Entry__c == null ||
                isExpired(pc)) {continue;}
            accIds.add(pc.Account__c); pbeIds.add(pc.Market_Price_Book_Entry__c);
        }
        Market_Price_Book__c mpb; Market_Price_Book_Entry__c mpbe;
        Account_To_Market_Price_Book_Entry__c ampbe;
        Set<Id> eset = new Set<Id>(), pset = new Set<Id>();
        Set<String> rset = new Set<String>();
        Map<String, String> pcMpbeMap = new Map<String, String>();

        Map<String, Account_To_Market_Price_Book_Entry__c> amap = getAccMpbeMap(accIds, pbeIds);
        Map<String, Market_Price_Book__c>                  bmap = new Map<String, Market_Price_Book__c>();
        Map<String, Market_Price_Book_Entry__c>            emap = new Map<String, Market_Price_Book_Entry__c>();
        setMpbMaps(pbeIds, bmap, emap);
        Boolean b1, b2, b3, b4, b5, b6;
        for (Pricing_Condition__c pc : pcns) {
            if (pc.Account__c == null || pc.Market_Price_Book_Entry__c == null ||
                isExpired(pc)) {continue;}
            debug('pc = ' + pc.Name + ' : ' + pc.Id);
            k = pc.Market_Price_Book_Entry__c; mpbe = emap.get(k);
            k = getKey(pc.Account__c, pc.Market_Price_Book_Entry__c); ampbe = amap.get(k);

            b1 = (mpbe == null); if (b1) {debug('mpbe not found');}
            if (!b1) {k = mpbe.Market_Price_Book__c; mpb = bmap.get(k);}

            b2 = (ampbe == null); if (b2) {debug('ampbe not found');}

            b3 = (mpb == null); if (b3) {debug('mpb not found');}

            b4 = isExpired(mpb); if (b4) {debug('mpb expired');}

            b5 = isExpired(mpbe); if (b5) {debug('mpbe expired');}

            b6 = isExpiredByClone(mpbe); if (b6) {debug('mpbe cloned');}

            if (b6 && !b2) {
                pcMpbeMap.put(pc.Id, mpbe.Expired_By__c);
                debug('mpbe expired by : ' + mpbe.Expired_By__c);
            } else
            if (b2 && !b6) {
                if (isApproved(pc)) {
                    eset.add(pc.Id); debug('pcn to expire : ' + pc.Name);
                }
            } else
            if (b1 || b2 || b3 || b4 || b5) {
                if (isInApproval(pc)) {
                    rset.add(pc.Id); debug('pcn to recall : ' + pc.Name);
                }
            } else {
                pset.add(pc.Id); debug('pcn to process : ' + pc.Name);
            }
        }
        if (!eset.isEmpty())      {expirePcns(eset);       }
        if (!rset.isEmpty())      {recallPcns(rset);       }
        if (!pcMpbeMap.isEmpty()) {upsertPcns(pcMpbeMap);  }
        if (!pset.isEmpty())      {processMpbWrkPcns(pset);}
    }

    @TestVisible private static void expirePcns(Set<Id> pcIds) {
        debug('expirePcns  : ' + pcIds);
        if (debugMode || pcIds == null || pcIds.isEmpty()) {return;}
        PricingConditionFunctions.expirePricingConditions(pcIds);
    }

    @TestVisible private static void recallPcns(Set<String> pcIds) {
        debug('recallPcns  : ' + pcIds);
        if (debugMode || pcIds == null || pcIds.isEmpty()) {return;}
        String s = 'Recalled due to MPB change';
        Custom_Approval_Functions.recallObjects(pcIds, s);
        List<Pricing_Condition__c> pcs = getPcns(pcIds);
        PricingConditionNotifications.sendNotificationsForRecalled(pcs);
    }

    @TestVisible private static void submitPcnsForApproval(Set<String> pcIds) {
        debug('submitPcns  : ' + pcIds);
        if (debugMode || pcIds == null || pcIds.isEmpty()) {return;}
        Custom_Approval_Functions.submitForApproval(pcIds);
    }

    private static List<Pricing_Condition__c> getPcns(Set<String> pcIds) {
        return Database.query(PricingConditionFunctions.SELECT_QRY_1 + ' where Id in :pcIds');
    }

    private static void upsertPcns(Map<String, String> pcMpbeMap) {
        if (pcMpbeMap == null || pcMpbeMap.isEmpty()) {return;}
        Id mpbeId; Market_Price_Book_Entry__c mpbe1, mpbe2;
        Map<String, Pricing_Condition__c> pcmap = new Map<String, Pricing_Condition__c>();
        Map<String, List<Pricing_Condition_Scaled_Pricing__c>> spmap = new
        Map<String, List<Pricing_Condition_Scaled_Pricing__c>>();
        List<Pricing_Condition_Scaled_Pricing__c> sps;
        Integer n = 0; String s, k; Pricing_Condition__c pc2; Set<Id> eset = new Set<Id>();
        Set<String> rset = new Set<String>(), pbeIds = new Set<String>(), pcIds = pcMpbeMap.keySet();
        List<Pricing_Condition__c> plist = getPcns(pcIds), ulist = new List<Pricing_Condition__c>();
        for (String t : pcMpbeMap.values()) {pbeIds.add(t);}
        for (Pricing_Condition__c pc : plist) {
            s = pc.Market_Price_Book_Entry__c; if (!String.isBlank(s)) {pbeIds.add(s);}
        }
        Map<String, Market_Price_Book_Entry__c> mpbeMap = getMpbeMap(pbeIds);
        for (Pricing_Condition__c pc : plist) {
            mpbeId = pc.Market_Price_Book_Entry__c; if (mpbeId == null) {continue;}
            mpbe1  = mpbeMap.get(mpbeId);           if (mpbe1  == null) {continue;}

            mpbeId = pcMpbeMap.get(pc.Id);          if (mpbeId == null) {continue;}
            mpbe2  = mpbeMap.get(mpbeId);           if (mpbe2  == null) {continue;}
            debug(pc.Name + ' : ' + mpbe1.Name + ' : ' + mpbe2.Name);

            if (isApproved(pc) && isWired(pc) && isChanged(mpbe1, mpbe2)) {
                k = 'PCN-' + (++n);
                sps = new List<Pricing_Condition_Scaled_Pricing__c>();
                pc2 = getClonedPcn(pc, mpbe2, sps); debug('Cloned PCN : ' + pc2);
                pcmap.put(k, pc2); spmap.put(k, sps);
            } else {
                setPcnFields1(pc, mpbe2); ulist.add(pc); debug('Updated PCN : ' + pc);
                if (isInApproval(pc)) {rset.add(pc.Id);}
            }
        }
        updatePcns1(ulist); if (crudfailed) {return;}
        insertPcns(pcmap, spmap); if (crudfailed) {return;}
        if (!eset.isEmpty()) {expirePcns(eset);}
        if (!rset.isEmpty()) {recallPcns(rset);}
    }

    private static void updatePcns1(List<Pricing_Condition__c> pcs) {
        List<Pricing_Condition_Scaled_Pricing__c> sps = new
        List<Pricing_Condition_Scaled_Pricing__c>();
        for (Pricing_Condition__c pc : pcs) {
            sps.addAll(pc.Pricing_Condition_Scaled_Pricing__r);
        }
        doCrud(Crud.UPD, sps, 'Update PcnScales'); if (crudfailed) {return;}
        updatePcns2(pcs);
    }

    private static void updatePcns2(List<Pricing_Condition__c> pcs) {
        PricingConditionFunctions.doPricingConditionUpdates(pcs);
        doCrud(Crud.UPD, pcs, 'Update Pcns'); if (crudfailed) {return;}
    }

    private static void insertPcns(Map<String, Pricing_Condition__c> pcmap,
                                   Map<String, List<Pricing_Condition_Scaled_Pricing__c>> spmap) {
        if (pcmap == null || pcmap.isEmpty()) {return;}
        List<Pricing_Condition__c> pcs = pcmap.values();
        doCrud(Crud.INS, pcs, 'Insert Pcns');
        List<Pricing_Condition_Scaled_Pricing__c> sps = new
        List<Pricing_Condition_Scaled_Pricing__c>();
        Pricing_Condition__c pc; Set<String> pcIds = new Set<String>(); Id pcId;
        for (String k : spmap.keySet()) {
            pc = pcmap.get(k); if(pc == null) {continue;}
            pcId = pc.Id; if (pcId != null) {pcIds.add(pcId);}
            for (Pricing_Condition_Scaled_Pricing__c sp : spmap.get(k)) {
                if (pcId != null) {sp.Id = null; sp.Pricing_Condition__c = pcId; sps.add(sp);}
                debug('PCN-SP to insert : ' + sp);
            }
        }
        doCrud(Crud.INS, sps, 'Insert PcnScales'); if (crudfailed) {return;}
        pcs = getPcns(pcIds); updatePcns2(pcs);
        PricingConditionNotifications.sendNotificationsForCreated(pcs);
        //submitPcnsForApproval(pcIds);
    }

    public static void processAccMpbes(Set<Id> idSet) {processAccMpbes(idSet, debugMode);}

    public static void processAccMpbes(Set<Id> idSet, Boolean dbgmd) {
        if (idSet == null || idSet.isEmpty()) {return;}
        String q = getAccMpbeQry() + ' where Id in :idSet';
        List<Account_To_Market_Price_Book_Entry__c> alist = Database.query(q);
        debugMode = dbgmd; processAccMpbes(alist);
    }

    public static void processAccMpbes(List<Account_To_Market_Price_Book_Entry__c> alist) {
        if (alist == null || alist.isEmpty()) {return;}
        Set<Id> pbeIds = new Set<Id>();
        for (Account_To_Market_Price_Book_Entry__c a : alist) {pbeIds.add(a.Market_Price_Book_Entry__c);}
        Map<String, Market_Price_Book__c>       bmap = new Map<String, Market_Price_Book__c>();
        Map<String, Market_Price_Book_Entry__c> emap = new Map<String, Market_Price_Book_Entry__c>();

        setMpbMaps(pbeIds, bmap, emap);
        List<Account_To_Market_Price_Book_Entry__c> dlist = new List<Account_To_Market_Price_Book_Entry__c>(),
                                                    ilist = new List<Account_To_Market_Price_Book_Entry__c>();
        Market_Price_Book__c b; Market_Price_Book_Entry__c e; Account_To_Market_Price_Book_Entry__c i;
        for (Account_To_Market_Price_Book_Entry__c a : alist) {
            e = emap.get(a.Market_Price_Book_Entry__c); if (e == null) {dlist.add(a); continue;}
            b = bmap.get(e.Market_Price_Book__c);       if (b == null) {dlist.add(a); continue;}
            if (isExpired(b) || isExpired(e)) {
                dlist.add(a); debug('processAccMpbes : to delete : ' + a);
            } else
            if (isExpiredByClone(e)) {
                dlist.add(a); debug('processAccMpbes : to delete : ' + a);
                i = getClonedAccMpbe(a); i.Market_Price_Book_Entry__c = e.Expired_By__c;
                ilist.add(i); debug('processAccMpbes : to insert : ' + i);
            }
        }
        ilist = getAccMpbesToInsert(ilist);
        doCrud(Crud.INS, ilist, 'Insert AccMpbes'); if (crudfailed) {return;}
        doCrud(Crud.DEL, dlist, 'Delete AccMpbes');
    }

    private static List<Account_To_Market_Price_Book_Entry__c> getAccMpbesToInsert(
                   List<Account_To_Market_Price_Book_Entry__c> ilist) {
        List<Account_To_Market_Price_Book_Entry__c> olist = new
        List<Account_To_Market_Price_Book_Entry__c>(), elist;
        if (ilist == null || ilist.isEmpty()) {return olist;}
        Set<Id> aset = new Set<Id>(), eset = new Set<Id>();
        for (Account_To_Market_Price_Book_Entry__c i : ilist) {
            aset.add(i.Account__c); eset.add(i.Market_Price_Book_Entry__c);
        }
        Set<String> kset = getAccMpbesKeys(aset, eset); String k;
        if (kset == null || kset.isEmpty()) {return ilist;}
        for (Account_To_Market_Price_Book_Entry__c i : ilist) {
            k = getKey(i.Account__c, i.Market_Price_Book_Entry__c);
            if (!kset.contains(k)) {olist.add(i);}
        }
        return olist;
    }

}