public class SAP_LISD_Functions {

    public static final Integer MAX_RECS = 10000;
    public static final String DELIM = ' - ';
    public static final String NONE = '-- None --';

    public static final Map<String, SAP_LISD_Settings__c> LISD_CNFG_MAP = SAP_LISD_Settings__c.getAll();
    public static final Map<String, Id> ACC_RTN_MAP = Schema_Functions.getRecordTypeNameMap('Account');
    public static final String KNA1_RT_ID = ACC_RTN_MAP.get('KNA1');

    public class SelectOpts {
        public List<SelectOption> sos {get; set;}
        public SelectOption so        {get; set;}
    }

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'SAP_LISD_Functions : ' + s);
    }

    private static Boolean isNull(String s) {return String.isBlank(s);}

    public static Boolean isMultiLevelIndustryAccount(Id accId) {
        debug('isMultiLevelIndustryAccount : Id = ' + accId);
        Account account = [SELECT Id, Multi_Level_Industry__c FROM Account WHERE Id = :accId];
        return isMultiLevelIndustryAccount(account);
    }

    public static Boolean isMultiLevelIndustryAccount(Account a) {
        debug('isMultiLevelIndustryAccount : a = ' + a);
        return (a.Multi_Level_Industry__c != null &&
                a.Multi_Level_Industry__c.equals('2'));
    }

    private static Boolean isEmpty(List<SelectOption> slist) {
        Boolean b = (slist == null || slist.isEmpty());
        debug('isEmpty 1: b = ' + b);
        if (b) {return b;}
        b = (slist.size() == 1 && NONE.equals(slist[0].getValue()));
        debug('isEmpty 2: b = ' + b);
        return b;
    }

    public static SAP_LISD_Settings__c getLisdSettings(Account a) {
        debug('getLisdSettings : acc = ' + a);
        SAP_LISD_Settings__c sls = new SAP_LISD_Settings__c();
        String s = null; if (a != null) {s = a.SAP_DistChannel__c;}
        if (String.isBlank(s)) {s = '00';}
        if (LISD_CNFG_MAP.containsKey(s)) {sls = LISD_CNFG_MAP.get(s);}
        debug('getLisdSettings : sls = ' + sls);
        return sls;
    }

    public static SelectOption getSelectOption(List<SelectOption> slist, String val) {
        SelectOption so = new SelectOption(NONE, NONE); String v;
        debug('getSelectOption 1: so = ' + so);
        if (slist == null || slist.isEmpty()) {return so;}
        for (SelectOption s : slist) {v = s.getValue();
            if (!isNull(v) && !isNull(val) && v.equals(val)) {so = s; break;}
        }
        debug('getSelectOption 2: so = ' + so);
        return so;
    }

    private static Map<String, Account> getAccountMap(Set<String> accNums) {
        debug('getAccountMap : accNums = ' + accNums);
        Map<String, Account> amap = new Map<String, Account>();
        List<Account> alist = [select Id, Account_Number__c
           from Account where Account_Number__c in :accNums];
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Account a : alist) {amap.put(a.Account_Number__c, a);}
        return amap;
    }

    private static String getAccNum(SAP_Line_Item_Sales_Detail__c a) {
        String s = a.ShipTo_Number__c + a.Sales_Org__c + a.Dist_Channel__c + a.Division__c;
        debug('getAccNum : s = ' + s);
        return s;
    }

    private static String getLisdKey(SAP_Line_Item_Sales_Detail__c a) {
        String s = a.Sales_Org__c + DELIM + a.Dist_Channel__c + DELIM +
                   a.Division__c + DELIM + a.ShipTo_Number__c + DELIM + a.L1_Segment__c;
        if (!isNull(a.EndUseCust_Number__c)) {s += DELIM + a.EndUseCust_Number__c;}
        debug('getLisdKey : s = ' + s);
        return s;
    }

    public static void doBeforeUpsert(List<SAP_Line_Item_Sales_Detail__c> alist) {
        debug('doBeforeUpsert(lisd list)');
        Set<String> accNums = new Set<String>();
        for(SAP_Line_Item_Sales_Detail__c a : alist) {accNums.add(getAccNum(a));}
        Map<String, Account> accMap = getAccountMap(accNums);
        for(SAP_Line_Item_Sales_Detail__c a : alist) {
            setShipToAccount(a, accMap);
        }
    }

    public static void doBeforeUpsert(List<SAP_L1_Segment__c> alist) { }

    public static void doBeforeUpsert(List<SAP_L2_Segment__c> alist) { }

    private static String getL1SegmentKey(SAP_L1_Segment__c a) {
        String s = a.Dist_Channel__c + DELIM + a.L1_Segment__c;
        debug('getL1SegmentKey : s = ' + s);
        return s;
    }

    private static String getL2SegmentKey(SAP_L2_Segment__c a) {
        String s = a.Dist_Channel__c + DELIM + a.L1_Segment__c + DELIM + a.L2_Segment__c;
        debug('getL2SegmentKey : s = ' + s);
        return s;
    }

    private static void setShipToAccount(SAP_Line_Item_Sales_Detail__c a,
                                         Map<String, Account> accMap) {
        debug('setShipToAccount');
        String accNum = getAccNum(a);
        if (accMap.containsKey(accNum)) {
            Account acc = accMap.get(accNum);
            a.ShipTo_Account__c = acc.Id;
        }
    }

    private static String getL1Segment(String dchan, String custGrp) {
        String s = '';
        List<SAP_L1_Segment__c> slist = [
            select Id, Name, Customer_Group__c, Dist_Channel__c,
                   Industry_Name__c, L1_Segment__c
              from SAP_L1_Segment__c
             where Dist_Channel__c = :dchan
               and Customer_Group__c = :custGrp
          order by L1_Segment__c limit 1];
        if (slist != null && !slist.isEmpty()) {s = slist[0].L1_Segment__c;}
        if (s != null && s.length() > 10) {s = s.substring(0,10);}
        debug('getL1Segment : s = ' + s);
        return s;
    }

    private static List<SAP_Line_Item_Sales_Detail__c> getSapLisds(Set<String> lisdIds) {
        debug('getSapLisds : lisdIds = ' + lisdIds);
        List<SAP_Line_Item_Sales_Detail__c> slist = [
            select Id, Name, Customer_Group__c, Customer_Group1__c,
                   Deleted__c, Dist_Channel__c, Division__c,
                   EndUseCust_Number__c, Key__c, L1_Segment__c, Multi_Level_Industry__c,
                   Sales_District__c, Sales_Group__c, Sales_Office__c,
                   Sales_Org__c, Seller_Number__c, ShipTo_Account__c, ShipTo_Number__c
              from SAP_Line_Item_Sales_Detail__c
             where Id in :lisdIds
          order by L1_Segment__c, EndUseCust_Number__c, Sales_District__c,
                   Sales_Office__c, Sales_Group__c, Customer_Group__c, Seller_Number__c
             limit :MAX_RECS];
        return slist;
    }

    private static void setAccountFldSets(Set<Id> accIds, Set<String> accntnums,
        Set<String> distchans, Set<String> divisions, Set<String> salesorgs) {
        debug('setAccountFldSets');
        for (Account a : [select AccountNumber, SAP_DistChannel__c,
                                 SAP_DivisionCode__c, SAP_Sales_Org__c
                            from Account where Id in :accIds]) {
            accntnums.add(a.AccountNumber);
            distchans.add(a.SAP_DistChannel__c);
            divisions.add(a.SAP_DivisionCode__c);
            salesorgs.add(a.SAP_Sales_Org__c);
        }
    }

    private static void setSapLisdIds(Account acc, Set<String> lisdIds,
                                      Map<String, User> smap) {
        debug('setSapLisdIds');
        Set<String> accLisdIds = new Set<String>(), usrLisdIds = new Set<String>(),
                    totLisdIds = new Set<String>(), sellerNums = new Set<String>(),
                    accntnums  = new Set<String>(), distchans  = new Set<String>(),
                    divisions  = new Set<String>(), salesorgs  = new Set<String>();
        List<SAP_Line_Item_Sales_Detail__c> lisds = new
        List<SAP_Line_Item_Sales_Detail__c>();
        Set<Id> shipToIds = Account_Partner_Functions.getShipToIds(acc.Id);
        if (shipToIds == null || shipToIds.isEmpty()) {shipToIds = new Set<Id>{acc.Id};}
        debug('shipToIds : ' + shipToIds);
        setAccountFldSets(shipToIds, accntnums, distchans, divisions, salesorgs);
        try {
            for (SAP_Line_Item_Sales_Detail__c s : [select Id, Deleted__c,
                     Multi_Level_Industry__c, Seller_Number__c
                from SAP_Line_Item_Sales_Detail__c
               where ShipTo_Number__c in :accntnums
                 and Sales_Org__c in :salesorgs
                 and Dist_Channel__c in :distchans
                 and Division__c in :divisions
               limit :MAX_RECS]) {
                if (!isNull(s.Deleted__c)) {continue;}
                lisds.add(s); totLisdIds.add(s.Id); sellerNums.add(s.Seller_Number__c);
            }
        } catch (Exception e) {debug(e.getMessage()); return;}
        SAP_Seller_Functions.setSellerMap(sellerNums, smap);
/*
        String accOwnerId = acc.OwnerId, userId = UserInfo.getUserId(), sellerId;
        Boolean b = (userId != accOwnerId); User seller;
        for (SAP_Line_Item_Sales_Detail__c s : lisds) {
            if (!isNull(s.Deleted__c) || isNull(s.Seller_Number__c)) {continue;}
            if (smap != null && smap.containsKey(s.Seller_Number__c)) {
                seller = smap.get(s.Seller_Number__c); sellerId = seller.Id;
                if (sellerId == userId) {usrLisdIds.add(s.Id);}
            }
        }
        if (!usrLisdIds.isEmpty()) {lisdIds.addAll(usrLisdIds);} else
*/
        lisdIds.addAll(totLisdIds);
        debug('accLisdIds : ' + accLisdIds);
        debug('usrLisdIds : ' + usrLisdIds);
        debug('totLisdIds : ' + totLisdIds);
        debug('lisdIds : ' + lisdIds);
    }

    public static Account getAccount(Id accountId) {
        Account acc = [select Id, Name, AccountNumber, Industry,
                              OwnerId, Owner.Name, Account_Number__c,
                              Inactive_Account__c, Multi_Level_Industry__c,
                              SAP_Customer_Group__c, SAP_Customer_Group_Desc__c,
                              SAP_DistChannel__c, SAP_DivisionCode__c,
                              SAP_SalesDistrict__c, SAP_Sales_District_Desc__c,
                              SAP_SalesGroup__c, SAP_Sales_Group_Desc__c,
                              SAP_Sales_Office__c, SAP_Sales_Office_Desc__c,
                              SAP_Sales_Org__c
                         from Account where Id = :accountId];
        debug('getAccount : acc = ' + acc);
        return acc;
    }

    public static User getUser(Id userId) {
        User usr = [select Id, Name from User where Id = :userId];
        debug('getUser : usr = ' + usr);
        return usr;
    }

    private static String getSellerKey(Account a, String industry, String endUseCust,
                                       String salesDst, String salesOfc, String salesGrp,
                                       String custGroup) {
        String s = a.SAP_Sales_Org__c + DELIM + a.SAP_DistChannel__c + DELIM +
                   a.SAP_DivisionCode__c + DELIM + industry + DELIM +
                   salesDst + DELIM + salesOfc + DELIM + salesGrp  + DELIM + custGroup;
        if (!isNull(endUseCust) && !NONE.equals(endUseCust)) {s += DELIM + endUseCust;}
        debug('getSellerKey 1: s = ' + s);
        return s;
    }

    private static String getSellerKey(SAP_Line_Item_Sales_Detail__c a) {
        String s = a.Sales_Org__c + DELIM + a.Dist_Channel__c + DELIM +
                   a.Division__c + DELIM + a.L1_Segment__c + DELIM +
                   a.Sales_District__c + DELIM + a.Sales_Office__c + DELIM +
                   a.Sales_Group__c + DELIM + a.Customer_Group__c;
        if (!isNull(a.EndUseCust_Number__c)) {s += DELIM + a.EndUseCust_Number__c;}
        debug('getSellerKey 2: s = ' + s);
        return s;
    }

    public static User getSeller(List<SAP_LISD> alist, Account acc,
                                 String industry, String endUseCust,
                                 String salesDst, String salesOfc,
                                 String salesGrp, String custGroup) {
        String t = getSellerKey(acc, industry, endUseCust, salesDst, salesOfc,
                                salesGrp, custGroup), selNum = null, s;
        SAP_Line_Item_Sales_Detail__c l;
        for (SAP_LISD a : alist) {l = a.lisd;
            s = getSellerKey(l);
            debug('getSeller : s = ' + s + ' : t = ' + t);
            if (s == t) {
                selNum = l.Seller_Number__c;
                if (l.ShipTo_Account__c == acc.Id) {
                    selNum = l.Seller_Number__c; break;
                }
            }
        }
        return getSeller(acc, selNum);
    }

    public static User getSeller(Account acc, String selNum) {
        String accOwnerId = acc.OwnerId, userId = UserInfo.getUserId();
        debug('getSeller : selNum = ' + selNum);
        debug('getSeller : accOwnerId = ' + accOwnerId);
        debug('getSeller : userId = ' + userId);
        User seller = SAP_Seller_Functions.getUser(selNum);
        if (seller == null) {seller = getUser(accOwnerId);}
        //if (accOwnerId == userId) {seller = getUser(userId);}
        //   else seller = getUser(accOwnerId);
        debug('getSeller : seller = ' + seller);
        return seller;
    }

    public static List<SAP_LISD> getAccountLisds(Id accountId) {
        debug('getAccountLisds : accountId = ' + accountId);
        Account acc = getAccount(accountId);
        Set<String> lisdIds = new Set<String>();
        Map<String, User> smap = new Map<String, User>();
        setSapLisdIds(acc, lisdIds, smap);
        List<SAP_LISD> lisds = new List<SAP_LISD>();
        if (lisdIds.isEmpty()) {return lisds;}
        SAP_LISD lisd;
        debug('smap : ' + smap);
        for(SAP_Line_Item_Sales_Detail__c s : getSapLisds(lisdIds)) {
            lisd = new SAP_LISD(s); lisds.add(lisd);
            if (smap != null && smap.containsKey(s.Seller_Number__c)) {
                lisd.seller = smap.get(s.Seller_Number__c);
                debug('getAccountLisds : lisd.seller : ' + lisd.seller);
            }
        }
        return lisds;
    }

    public static List<SAP_Line_Item_Sales_Detail__c> getAccountLisds(Account acc) {
        debug('getAccountLisds : acc = ' + acc);
        Set<String> lisdIds = new Set<String>();
        Map<String, User> smap = new Map<String, User>();
        setSapLisdIds(acc, lisdIds, smap);
        List<SAP_Line_Item_Sales_Detail__c> slist = new
        List<SAP_Line_Item_Sales_Detail__c>();
        if (!lisdIds.isEmpty()) {slist = getSapLisds(lisdIds);}
        return slist;
    }

    public static List<SAP_LISD> getSapLisds(Id accountId) {
        debug('getSapLisds : accountId = ' + accountId);
        List<SAP_LISD> lisds = new List<SAP_LISD>();
        Account acc = getAccount(accountId);
        if (!isMultiLevelIndustryAccount(acc)) {return lisds;}
        List<SAP_Line_Item_Sales_Detail__c> slist = getAccountLisds(acc);
        if (slist == null || slist.isEmpty()) {return lisds;}
        String dchan = acc.SAP_DistChannel__c, custGrp = acc.SAP_Customer_Group__c;
        Set<String> cgset = new Set<String>(),
                    euset = new Set<String>(),
                    l1set = new Set<String>(),
                    sdset = new Set<String>(),
                    sgset = new Set<String>(),
                    snset = new Set<String>(),
                    soset = new Set<String>();
        for (SAP_Line_Item_Sales_Detail__c s : slist) {
            cgset.add(s.Customer_Group__c);
            euset.add(s.EndUseCust_Number__c);
            l1set.add(s.L1_Segment__c);
            sdset.add(s.Sales_District__c);
            sgset.add(s.Sales_Group__c);
            snset.add(s.Seller_Number__c);
            soset.add(s.Sales_Office__c);
        }
        Map<String, SAP_Customer_Group__c> cgmap = getSapCustomerGroupMap(cgset);
        Map<String, Account>               eumap = getEndUseCustMap(euset);
        Map<String, SAP_L1_Segment__c>     l1map = getSapL1SegmentMap(dchan, l1set);
        Map<String, SAP_Sales_District__c> sdmap = getSapSalesDistrictMap(sdset);
        Map<String, SAP_Sales_Group__c>    sgmap = getSapSalesGroupMap(sgset);
        Map<String, User>                  snmap = SAP_Seller_Functions.getSellerMap(snset);
        Map<String, SAP_Sales_Office__c>   somap = getSapSalesOfficeMap(soset);
        SAP_LISD lisd; User usr;
        for (SAP_Line_Item_Sales_Detail__c s : slist) {
            lisd = new SAP_LISD(s); lisds.add(lisd); usr = null;
            if (cgmap.containsKey(s.Customer_Group__c)) {
                lisd.custGroup = getCustomerGroup(cgmap.get(s.Customer_Group__c));}

            if (eumap.containsKey(s.EndUseCust_Number__c)) {
                lisd.endUseCust = getEndUseCust(eumap.get(s.EndUseCust_Number__c));}

            if (l1map.containsKey(s.L1_Segment__c)) {
                lisd.industry = getL1Segment(l1map.get(s.L1_Segment__c));}

            if (sdmap.containsKey(s.Sales_District__c)) {
                lisd.salesDst = getSalesDistrict(sdmap.get(s.Sales_District__c));}

            if (sgmap.containsKey(s.Sales_Group__c)) {
                lisd.salesGrp = getSalesGroup(sgmap.get(s.Sales_Group__c));}

            if (snmap.containsKey(s.Seller_Number__c)) {usr = snmap.get(s.Seller_Number__c);}
            lisd.sellerOpt = getSellerOpt(s.Seller_Number__c, usr);

            if (somap.containsKey(s.Sales_Office__c)) {
                lisd.salesOfc = getSalesOffice(somap.get(s.Sales_Office__c));}
        }
        return lisds;
    }

    private static String getLisdKey2(SAP_Line_Item_Sales_Detail__c a) {
        String s = a.Sales_Org__c      + DELIM + a.Dist_Channel__c   + DELIM +
                   a.Division__c       + DELIM + a.ShipTo_Number__c  + DELIM +
                   a.L1_Segment__c     + DELIM + a.Sales_District__c + DELIM +
                   a.Sales_Office__c   + DELIM + a.Sales_Group__c    + DELIM +
                   a.Customer_Group__c + DELIM + a.Seller_Number__c;
        if (!isNull(a.EndUseCust_Number__c)) {s += DELIM + a.EndUseCust_Number__c;}
        debug('getLisdKey2 : s = ' + s);
        return s;
    }

    private static String getKeyPart2(String k, Integer n) {
        String s = null; String[] sa = k.split(DELIM); n--;
        if (sa != null && sa.size() > n) {s = sa[n];}
        return s;
    }

    private static String getL1Segment2(String k) {
        String s = getKeyPart2(k, 5);
        debug('getL1Segment2 : s = ' + s);
        return s;
    }

    private static String getSalesDst2(String k) {
        String s = getKeyPart2(k, 6);
        debug('getSalesDst2 : s = ' + s);
        return s;
    }

    private static String getSalesOfc2(String k) {
        String s = getKeyPart2(k, 7);
        debug('getSalesOfc2 : s = ' + s);
        return s;
    }

    private static String getSalesGrp2(String k) {
        String s = getKeyPart2(k, 8);
        debug('getSalesGrp2 : s = ' + s);
        return s;
    }

    private static String getCustGroup2(String k) {
        String s = getKeyPart2(k, 9);
        debug('getCustGroup2 : s = ' + s);
        return s;
    }

    private static String getSellerNum2(String k) {
        String s = getKeyPart2(k, 10);
        debug('getSellerNum2 : s = ' + s);
        return s;
    }

    private static String getEndUseCust2(String k) {
        String s = getKeyPart2(k, 11); if (s == null) {s = NONE;}
        debug('getEndUseCust2 : s = ' + s);
        return s;
    }

    public static Map<String, Id> getLisdMap(Id accountId) {
        return getLisdMap(getAccount(accountId));
    }

    public static Map<String, Id> getLisdMap(Account a) {
        Map<String, Id> m = new Map<String, Id>();
        if (!isMultiLevelIndustryAccount(a)) {return m;}
        List<SAP_Line_Item_Sales_Detail__c> lisds = getAccountLisds(a);
        for (SAP_Line_Item_Sales_Detail__c l : lisds) {m.put(getLisdKey2(l), l.Id);}
        debug('getLisdMap : m.size = ' + m.size());
        return m;
    }

    public static SelectOption getSellerIndustry(Map<String, Id> amap, List<SelectOption> alist) {
        SelectOption industry = (alist != null && !alist.isEmpty()) ? alist[0] : null;
        if (amap == null || amap.isEmpty()) {return industry;}
        Set<String> sellerNums = SAP_Seller_Functions.getSellerNumbers(); String sellerNum, l1segm;
        for (String k : amap.keySet()) {
            sellerNum = getSellerNum2(k);
            if (sellerNum != null && sellerNums.contains(sellerNum)) {
                l1segm = getL1Segment2(k); industry = getSelectOption(alist, l1segm); break;
            }
        }
        return industry;
    }

    public static List<SelectOption> getL1Segments(Map<String, Id> amap, Account acc) {
        String dchan = acc.SAP_DistChannel__c, custGrp = acc.SAP_Customer_Group__c;
        Set<String> cset = new Set<String>(); String val, lbl;
        for (String k : amap.keySet()) {cset.add(getL1Segment2(k));}
        List<SelectOption> slist = new List<SelectOption>();
        if (cset == null || cset.isEmpty()) {
            if (isNull(custGrp)) {
                slist.add(new SelectOption(NONE, NONE));
            } else {
                val = getL1Segment(dchan, custGrp);
                slist.add(new SelectOption(val, acc.SAP_Customer_Group_Desc__c));
            }
            debug('getL1Segments 1: slist = ' + slist);
            return slist;
        }
        List<SAP_L1_Segment__c> alist = getSapL1Segments(dchan, cset);
        if (alist == null || alist.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE));
            debug('getL1Segments 2: slist = ' + slist);
            return slist;
        }
        for (SAP_L1_Segment__c a : alist) {slist.add(getL1Segment(a));}
        debug('getL1Segments 3: slist = ' + slist);
        return slist;
    }

    private static SelectOption getL1Segment(SAP_L1_Segment__c a) {
        String val = a.L1_Segment__c, lbl = a.Industry_Name__c;
        return new SelectOption(val, lbl);
    }

    private static List<SAP_L1_Segment__c> getSapL1Segments(String dchan, Set<String> cset) {
        List<SAP_L1_Segment__c> alist = [
            select Customer_Group__c, Dist_Channel__c, Industry_Name__c, L1_Segment__c
              from SAP_L1_Segment__c
             where Dist_Channel__c =:dchan and L1_Segment__c in :cset
          order by Industry_Name__c];
        return alist;
    }

    private static Map<String, SAP_L1_Segment__c> getSapL1SegmentMap(String dchan, Set<String> cset) {
        Map<String, SAP_L1_Segment__c> amap = new Map<String, SAP_L1_Segment__c>();
        List<SAP_L1_Segment__c> alist = getSapL1Segments(dchan, cset);
        if (alist == null || alist.isEmpty()) {return amap;}
        for (SAP_L1_Segment__c a : alist) {amap.put(a.L1_Segment__c, a);}
        return amap;
    }

    private static List<SAP_L2_Segment__c> getSapL2Segments(String dchan, Set<String> cset) {
        List<SAP_L2_Segment__c> alist = [
            select Dist_Channel__c, L1_Segment__c, L2_Segment__c, Sub_Industry_Name__c
              from SAP_L2_Segment__c
             where Dist_Channel__c =:dchan and L2_Segment__c in :cset
          order by Sub_Industry_Name__c];
        return alist;
    }

    private static Map<String, SAP_L2_Segment__c> getSapL2SegmentMap(String dchan, Set<String> cset) {
        Map<String, SAP_L2_Segment__c> amap = new Map<String, SAP_L2_Segment__c>();
        List<SAP_L2_Segment__c> alist = getSapL2Segments(dchan, cset);
        if (alist == null || alist.isEmpty()) {return amap;}
        for (SAP_L2_Segment__c a : alist) {amap.put(a.L2_Segment__c, a);}
        return amap;
    }

// --------------------------------------------------------------------------------------------------------------

    public static List<SelectOption> getEndUseCusts(Map<String, Id> amap, String industry) {
        debug('getEndUseCusts 1:');
        Set<String> cset = new Set<String>(), kset = new Set<String>(); String s;
        if (amap != null) {kset = amap.keySet();}
        Boolean addNoneOption = false;
        for (String k : kset) {
            s = getL1Segment2(k);
            if (s != null && s.equalsIgnoreCase(industry)) {
                s = getEndUseCust2(k);
                if (!NONE.equals(s)) {cset.add(s);} else {addNoneOption = true;}
            }
        }
        return getEndUseCusts(cset, addNoneOption);
    }

    public static List<SelectOption> getEndUseCusts(Set<String> cset, Boolean addNoneOption) {
        debug('getEndUseCusts 2:');
        List<SelectOption> slist = new List<SelectOption>();
        if (cset == null || cset.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE)); return slist;
        }
        List<Account> alist = getEndUseCusts(cset);
        if (alist == null || alist.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE)); return slist;
        }
        if (addNoneOption) {slist.add(new SelectOption(NONE, NONE));}
        String val, lbl;
        for (Account a : alist) {slist.add(getEndUseCust(a));}
        return slist;
    }

    private static SelectOption getEndUseCust(Account a) {
        String val = a.AccountNumber;
        String lbl = a.Name + DELIM + String_Functions.removeLeadingZeros(val);
        return new SelectOption(val, lbl);
    }

    private static List<Account> getEndUseCusts(Set<String> cset) {
        debug('getEndUseCusts 3:');
        List<Account> alist = [
            select Id, AccountNumber, Name from Account
             where RecordTypeId = :KNA1_RT_ID and AccountNumber in :cset
          order by Name];
        return alist;
    }

    private static Map<String, Account> getEndUseCustMap(Set<String> cset) {
        Map<String, Account> amap = new Map<String, Account>();
        List<Account> alist = getEndUseCusts(cset);
        if (alist == null || alist.isEmpty()) {return amap;}
        for (Account a : alist) {amap.put(a.AccountNumber, a);}
        return amap;
    }

    public static Account getEndUseCust(String accNum) {
        debug('getEndUseCust :');
        if (String.isBlank(accNum)) {return null;}
        Set<String> cset = new Set<String>{accNum};
        List<Account> alist = getEndUseCusts(cset);
        if (alist == null || alist.isEmpty()) {return null;}
        return alist[0];
    }

    public static String getAccountNumber(String accId) {
        String s;
        List<Account> alist = [
            select Id, AccountNumber, Name from Account
             where Id = :accId];
        if (alist == null || alist.isEmpty()) {s = '';}
        else {s = alist[0].AccountNumber;}
        debug('getAccountNumber : s = ' + s);
        return s;
    }

// --------------------------------------------------------------------------------------------------------------

    public static List<SelectOption> getSalesDistricts(Map<String, Id> amap, Account acc,
        String industry, String endUseCust) {
        Set<String> cset = new Set<String>(); String s;
        for (String k : amap.keySet()) {
            s = getL1Segment2(k); if (s == null || !s.equalsIgnoreCase(industry)) {continue;}
            s = getEndUseCust2(k);
            if (s != null && s.equalsIgnoreCase(endUseCust)) {
                s = getSalesDst2(k); if (s != null) {cset.add(s);}
            }
        }
        if (cset.isEmpty() && !isNull(acc.SAP_SalesDistrict__c)) {
            cset.add(acc.SAP_SalesDistrict__c);
        }
        List<SelectOption> slist = getSalesDistricts(cset);
        if (isEmpty(slist) && !isNull(acc.SAP_SalesDistrict__c)) {
            cset = new Set<String>{acc.SAP_SalesDistrict__c};
            slist = getSalesDistricts(cset);
        }
        debug('getSalesDistricts 1: slist = ' + slist);
        return slist;
    }

    public static List<SelectOption> getSalesDistricts(Set<String> cset) {
        List<SelectOption> slist = new List<SelectOption>();
        if (cset == null || cset.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE));
            debug('getSalesDistricts 2: slist = ' + slist);
            return slist;
        }
        List<SAP_Sales_District__c> alist = getSapSalesDistricts(cset);
        if (alist == null || alist.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE));
            debug('getSalesDistricts 3: slist = ' + slist);
            return slist;
        }
        String val, lbl;
        for (SAP_Sales_District__c a : alist) {slist.add(getSalesDistrict(a));}
        debug('getSalesDistricts 4: slist = ' + slist);
        return slist;
    }

    private static SelectOption getSalesDistrict(SAP_Sales_District__c a) {
        String val = a.Sales_District_Code__c, lbl = a.Sales_District_Name__c;
        return new SelectOption(val, lbl + DELIM + val);
    }

    private static List<SAP_Sales_District__c> getSapSalesDistricts(Set<String> cset) {
        List<SAP_Sales_District__c> alist = [
            select Deleted__c, Sales_District_Code__c, Sales_District_Name__c
              from SAP_Sales_District__c
             where Deleted__c = false and Sales_District_Code__c in :cset
          order by Sales_District_Name__c, Sales_District_Code__c];
        return alist;
    }

    private static Map<String, SAP_Sales_District__c> getSapSalesDistrictMap(Set<String> cset) {
        Map<String, SAP_Sales_District__c> amap = new Map<String, SAP_Sales_District__c>();
        List<SAP_Sales_District__c> alist = getSapSalesDistricts(cset);
        if (alist == null || alist.isEmpty()) {return amap;}
        for (SAP_Sales_District__c a : alist) {amap.put(a.Sales_District_Code__c, a);}
        return amap;
    }

// --------------------------------------------------------------------------------------------------------------

    public static List<SelectOption> getSalesOffices(Map<String, Id> amap, Account acc,
        String industry, String endUseCust, String salesDst) {
        Set<String> cset = new Set<String>(); String s;
        for (String k : amap.keySet()) {
            s = getL1Segment2(k);  if (s == null || !s.equalsIgnoreCase(industry))   {continue;}
            s = getEndUseCust2(k); if (s == null || !s.equalsIgnoreCase(endUseCust)) {continue;}
            s = getSalesDst2(k);
            if (s != null && s.equalsIgnoreCase(salesDst)) {
                s = getSalesOfc2(k); if (s != null) {cset.add(s);}
            }
        }
        if (cset.isEmpty() && !isNull(acc.SAP_Sales_Office__c)) {
            cset.add(acc.SAP_Sales_Office__c);
        }
        List<SelectOption> slist = getSalesOffices(cset);
        if (isEmpty(slist) && !isNull(acc.SAP_Sales_Office__c)) {
            cset = new Set<String>{acc.SAP_Sales_Office__c};
            slist = getSalesOffices(cset);
        }
        debug('getSalesOffices 1: slist = ' + slist);
        return slist;
    }

    public static List<SelectOption> getSalesOffices(Set<String> cset) {
        List<SelectOption> slist = new List<SelectOption>();
        if (cset == null || cset.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE));
            debug('getSalesOffices 2: slist = ' + slist);
            return slist;
        }
        List<SAP_Sales_Office__c> alist = getSapSalesOffices(cset);
        if (alist == null || alist.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE));
            debug('getSalesOffices 3: slist = ' + slist);
            return slist;
        }
        String val, lbl;
        for (SAP_Sales_Office__c a : alist) {slist.add(getSalesOffice(a));}
        debug('getSalesOffices 4: slist = ' + slist);
        return slist;
    }

    private static SelectOption getSalesOffice(SAP_Sales_Office__c a) {
        String val = a.Sales_Office_Code__c, lbl = a.Sales_Office_Name__c;
        return new SelectOption(val, lbl + DELIM + val);
    }

    private static List<SAP_Sales_Office__c> getSapSalesOffices(Set<String> cset) {
        List<SAP_Sales_Office__c> alist = [
            select Deleted__c, Sales_Office_Code__c, Sales_Office_Name__c
              from SAP_Sales_Office__c
             where Deleted__c = false and Sales_Office_Code__c in :cset
          order by Sales_Office_Name__c, Sales_Office_Code__c];
        return alist;
    }

    private static Map<String, SAP_Sales_Office__c> getSapSalesOfficeMap(Set<String> cset) {
        Map<String, SAP_Sales_Office__c> amap = new Map<String, SAP_Sales_Office__c>();
        List<SAP_Sales_Office__c> alist = getSapSalesOffices(cset);
        if (alist == null || alist.isEmpty()) {return amap;}
        for (SAP_Sales_Office__c a : alist) {amap.put(a.Sales_Office_Code__c, a);}
        return amap;
    }

// --------------------------------------------------------------------------------------------------------------

    public static List<SelectOption> getSalesGroups(Map<String, Id> amap, Account acc,
        String industry, String endUseCust, String salesDst, String salesOfc) {
        Set<String> cset = new Set<String>(); String s;
        for (String k : amap.keySet()) {
            s = getL1Segment2(k);  if (s == null || !s.equalsIgnoreCase(industry))   {continue;}
            s = getEndUseCust2(k); if (s == null || !s.equalsIgnoreCase(endUseCust)) {continue;}
            s = getSalesDst2(k);   if (s == null || !s.equalsIgnoreCase(salesDst))   {continue;}
            s = getSalesOfc2(k);
            if (s != null && s.equalsIgnoreCase(salesOfc)) {
                s = getSalesGrp2(k); if (s != null) {cset.add(s);}
            }
        }
        if (cset.isEmpty() && !isNull(acc.SAP_SalesGroup__c)) {
            cset.add(acc.SAP_SalesGroup__c);
        }
        List<SelectOption> slist = getSalesGroups(cset);
        if (isEmpty(slist) && !isNull(acc.SAP_SalesGroup__c)) {
            cset = new Set<String>{acc.SAP_SalesGroup__c};
            slist = getSalesGroups(cset);
        }
        debug('getSalesGroups 1: slist = ' + slist);
        return slist;
    }

    public static List<SelectOption> getSalesGroups(Set<String> cset) {
        List<SelectOption> slist = new List<SelectOption>();
        if (cset == null || cset.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE));
            debug('getSalesGroups 2: slist = ' + slist);
            return slist;
        }
        List<SAP_Sales_Group__c> alist = getSapSalesGroups(cset);
        if (alist == null || alist.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE));
            debug('getSalesGroups 3: slist = ' + slist);
            return slist;
        }
        String val, lbl;
        for (SAP_Sales_Group__c a : alist) {slist.add(getSalesGroup(a));}
        debug('getSalesGroups 4: slist = ' + slist);
        return slist;
    }

    public static SelectOption getSalesGroup(SAP_Sales_Group__c a) {
        String val = a.Sales_Group_Code__c, lbl = a.Sales_Group_Name__c;
        return new SelectOption(val, lbl + DELIM + val);
    }

    private static List<SAP_Sales_Group__c> getSapSalesGroups(Set<String> cset) {
        List<SAP_Sales_Group__c> alist = [
            select Deleted__c, Sales_Group_Code__c, Sales_Group_Name__c
              from SAP_Sales_Group__c
             where Deleted__c = false and Sales_Group_Code__c in :cset
          order by Sales_Group_Name__c, Sales_Group_Code__c];
        return alist;
    }

    private static Map<String, SAP_Sales_Group__c> getSapSalesGroupMap(Set<String> cset) {
        Map<String, SAP_Sales_Group__c> amap = new Map<String, SAP_Sales_Group__c>();
        List<SAP_Sales_Group__c> alist = getSapSalesGroups(cset);
        if (alist == null || alist.isEmpty()) {return amap;}
        for (SAP_Sales_Group__c a : alist) {amap.put(a.Sales_Group_Code__c, a);}
        return amap;
    }

// --------------------------------------------------------------------------------------------------------------

    public static List<SelectOption> getCustomerGroups(Map<String, Id> amap, Account acc,
        String industry, String endUseCust, String salesDst, String salesOfc, String salesGrp) {
        Set<String> cset = new Set<String>(); String s;
        for (String k : amap.keySet()) {
            s = getL1Segment2(k);  if (s == null || !s.equalsIgnoreCase(industry))   {continue;}
            s = getEndUseCust2(k); if (s == null || !s.equalsIgnoreCase(endUseCust)) {continue;}
            s = getSalesDst2(k);   if (s == null || !s.equalsIgnoreCase(salesDst))   {continue;}
            s = getSalesOfc2(k);   if (s == null || !s.equalsIgnoreCase(salesOfc))   {continue;}
            s = getSalesGrp2(k);
            if (s != null && s.equalsIgnoreCase(salesGrp)) {
                s = getCustGroup2(k); if (s != null) {cset.add(s);}
            }
        }
        if (cset.isEmpty() && !isNull(acc.SAP_Customer_Group__c)) {
            cset.add(acc.SAP_Customer_Group__c);
        }
        List<SelectOption> slist = getCustomerGroups(cset);
        if (isEmpty(slist) && !isNull(acc.SAP_Customer_Group__c)) {
            cset = new Set<String>{acc.SAP_Customer_Group__c};
            slist = getCustomerGroups(cset);
        }
        debug('getCustomerGroups 1: slist = ' + slist);
        return slist;
    }

    public static List<SelectOption> getCustomerGroups(Set<String> cset) {
        List<SelectOption> slist = new List<SelectOption>();
        if (cset == null || cset.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE));
            debug('getCustomerGroups 2: slist = ' + slist);
            return slist;
        }
        List<SAP_Customer_Group__c> alist = getSapCustomerGroups(cset);
        if (alist == null || alist.isEmpty()) {
            slist.add(new SelectOption(NONE, NONE));
            debug('getCustomerGroups 3: slist = ' + slist);
            return slist;
        }
        String val, lbl;
        for (SAP_Customer_Group__c a : alist) {slist.add(getCustomerGroup(a));}
        debug('getCustomerGroups 4: slist = ' + slist);
        return slist;
    }

    private static SelectOption getCustomerGroup(SAP_Customer_Group__c a) {
        String val = a.Customer_Group_Code__c, lbl = a.Customer_Group_Name__c;
        return new SelectOption(val, lbl + DELIM + val);
    }

    private static List<SAP_Customer_Group__c> getSapCustomerGroups(Set<String> cset) {
        List<SAP_Customer_Group__c> alist = [
            select Deleted__c, Customer_Group_Code__c, Customer_Group_Name__c
              from SAP_Customer_Group__c
             where Deleted__c = false and Customer_Group_Code__c in :cset
          order by Customer_Group_Name__c, Customer_Group_Code__c];
        return alist;
    }

    private static Map<String, SAP_Customer_Group__c> getSapCustomerGroupMap(Set<String> cset) {
        Map<String, SAP_Customer_Group__c> amap = new Map<String, SAP_Customer_Group__c>();
        List<SAP_Customer_Group__c> alist = getSapCustomerGroups(cset);
        if (alist == null || alist.isEmpty()) {return amap;}
        for (SAP_Customer_Group__c a : alist) {amap.put(a.Customer_Group_Code__c, a);}
        return amap;
    }

// --------------------------------------------------------------------------------------------------------------

    public static SelectOpts getSellerOpts(Map<String, Id> amap, Account acc,
        String industry, String endUseCust, String salesDst, String salesOfc, String salesGrp, String custGrp) {
        Set<String> cset = new Set<String>(); String s;
        for (String k : amap.keySet()) {
            s = getL1Segment2(k);  if (s == null || !s.equalsIgnoreCase(industry))   {continue;}
            s = getEndUseCust2(k); if (s == null || !s.equalsIgnoreCase(endUseCust)) {continue;}
            s = getSalesDst2(k);   if (s == null || !s.equalsIgnoreCase(salesDst))   {continue;}
            s = getSalesOfc2(k);   if (s == null || !s.equalsIgnoreCase(salesOfc))   {continue;}
            s = getSalesGrp2(k);   if (s == null || !s.equalsIgnoreCase(salesGrp))   {continue;}
            s = getCustGroup2(k);
            if (s != null && s.equalsIgnoreCase(custGrp)) {
                s = getSellerNum2(k); if (s != null) {cset.add(s);}
            }
        }
        SelectOpts sopts = getSellerOpts(acc, cset);
        debug('getSellerOpts 1: sopts = ' + sopts);
        return sopts;
    }

    private static SelectOpts getSellerOpts(Account acc, Set<String> cset) {
        String accOwnerId = acc.OwnerId, userId = UserInfo.getUserId();
        //debug('getSellerOpts : accOwnerId = ' + accOwnerId); debug('getSellerOpts : userId = ' + userId);
        List<SelectOption> slist = new List<SelectOption>();
        User usr; String val, lbl; SelectOption opt;
        SelectOpts sopts = new SelectOpts();
        Map<String, User> smap = SAP_Seller_Functions.getSellerMap(cset);
        if (smap == null || smap.isEmpty()) {
            usr = getSeller(acc, ''); opt = getSellerOpt('', usr);
            slist.add(opt); sopts.so = opt; sopts.sos = slist;
            debug('getSellerOpts 2: sopts = ' + sopts);
            return sopts;
        }
        SelectOption accOpt = null, usrOpt = null, othOpt = null;
        for (String s : smap.keySet()) {
            usr = smap.get(s); opt = getSellerOpt(s, usr); 
            slist.add(opt); othOpt = opt;
            //debug('getSellerOpts : usr.Id = ' + usr.Id);
            if (usr.Id == accOwnerId) {accOpt = opt;} else
            if (usr.Id == userId)     {usrOpt = opt;}
        }
        //debug('getSellerOpts : accOpt = ' + accOpt); debug('getSellerOpts : usrOpt = ' + usrOpt);
        sopts.sos = slist;
        if (othOpt != null) {sopts.so = othOpt;}
        if (accOpt != null) {sopts.so = accOpt;}
        if (usrOpt != null) {sopts.so = usrOpt;}
        debug('getSellerOpts 3: sopts = ' + sopts);
        return sopts;
    }

    private static SelectOption getSellerOpt(String val, User usr) {
        String lbl = '';
        if (!isNull(val)) {lbl = DELIM + String_Functions.removeLeadingZeros(val);}
        if (usr != null) {lbl = usr.Name + lbl;}
        return new SelectOption(val, lbl);
    }

// --------------------------------------------------------------------------------------------------------------

    public static List<SelectOption> getL2Segments(String dchan, String indstry) {
        List<SelectOption> slist = new List<SelectOption>(); String q, q1, q2, q3;
        slist.add(new SelectOption(NONE, NONE));
        if (isNull(dchan)) {
            debug('getL2Segments 1: slist = ' + slist);
            return slist;
        }
        q1 = 'select L2_Segment__c, Sub_Industry_Name__c' +
             '  from SAP_L2_Segment__c where Dist_Channel__c = \'' + dchan + '\'';
        q2 = ' and L1_Segment__c = \'' + indstry + '\'';
        q3 = ' order by Sub_Industry_Name__c, L2_Segment__c limit 1000';
        q = q1; if (!isNull(indstry)) {q += q2;}
        q += q3; debug('getL2Segments 2: q = ' + q);
        List<SAP_L2_Segment__c> alist = Database.query(q);
        if (alist == null || alist.isEmpty()) {
            q = q1 + q3; debug('getL2Segments 3: q = ' + q);
            alist = Database.query(q);
            if (alist == null || alist.isEmpty()) {
                debug('getL2Segments 4: slist = ' + slist);
                return slist;
            }
        }
        String val, lbl; Set<String> aset = new Set<String>();
        for (SAP_L2_Segment__c a : alist) {
            val = a.L2_Segment__c; lbl = a.Sub_Industry_Name__c;
            if (!aset.contains(lbl)) {
                aset.add(lbl); slist.add(new SelectOption(val, lbl));
            }
        }
       debug('getL2Segments 5: slist = ' + slist);
        return slist;
    }

}