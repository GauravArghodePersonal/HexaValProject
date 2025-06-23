public class PricingConditionUpdateFunctions {

    public static final Integer MAX_PC_RECS = 10000;
    public static final Integer MAX_RECS    = 100000;
    public static final Integer BATCH_SIZE  = 10;

    public static final String DIST_CHANNEL_AHWT = '10';

    public static final String DELIM1 = '~';

    public static final String ACTIVE = 'Active';
    public static final String APPROVED = 'Approved,Not Yet Active';
    public static final String SUBMITTED = 'In Approval Process';

    public static final Set<String> RECSET = new Set<String>{ACTIVE, APPROVED};

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }

    public static List<SAP_Sales_Org__c> getSapSalesOrgs(String dchanCode,
                                                         Date effectFromDate) {

        List<SAP_Sales_Org__c> sapSalesOrgs = SAP_Queries.Query_SAP_Sales_Orgs();
        List<SAP_Sales_Org__c> sorgList = new List<SAP_Sales_Org__c>();
        Set<String> sorgCodes = getSalesOrgCodes(dchanCode, effectFromDate);
        for (SAP_Sales_Org__c s : sapSalesOrgs) {
            if (sorgCodes.contains(s.Sales_Org_Code__c)) {
                sorgList.add(s);
            }
        }
        return sorgList;
    }

    public static Set<String> getSalesOrgCodes(String dchanCode,
                                               Date effectFromDate) {
        Set<String> sorgCodes = new Set<String>();
        for (AggregateResult[] ars : [
            select SalesOrg_Code__c sorgCode
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
          group by SalesOrg_Code__c
             limit :MAX_RECS
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('sorgCode');
                if (s != null) {sorgCodes.add(s);}
            }
        }
        return sorgCodes;
    }

    public static Set<String> getSalesDistricts(String dchanCode,
                                                Date effectFromDate,
                                                Set<String> sorgCodes) {
        Set<String> salesDistricts = new Set<String>();
        for (AggregateResult[] ars : [
            select Account__r.SAP_Sales_District_Desc__c salesDistrict
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
               and SalesOrg_Code__c in :sorgCodes
          group by Account__r.SAP_Sales_District_Desc__c
             limit :MAX_RECS
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('salesDistrict');
                if (s != null) {salesDistricts.add(s);}
            }
        }
        return salesDistricts;
    }

    public static Set<String> getSalesOffices(String dchanCode,
                                              Date effectFromDate,
                                              Set<String> sorgCodes,
                                              Set<String> salesDsts) {
        Set<String> salesOffices = new Set<String>();
        for (AggregateResult[] ars : [
            select Account__r.SAP_Sales_Office_Desc__c salesOffice
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
               and SalesOrg_Code__c in :sorgCodes
               and Account__r.SAP_Sales_District_Desc__c in :salesDsts
          group by Account__r.SAP_Sales_Office_Desc__c
             limit :MAX_RECS
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('salesOffice');
                if (s != null) {salesOffices.add(s);}
            }
        }
        return salesOffices;
    }

    public static Set<String> getSalesGroups(String dchanCode,
                                             Date effectFromDate,
                                             Set<String> sorgCodes,
                                             Set<String> salesDsts,
                                             Set<String> salesOfcs) {
        Set<String> salesGroups = new Set<String>();
        for (AggregateResult[] ars : [
            select Account__r.SAP_Sales_Group_Desc__c salesGroup
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
               and SalesOrg_Code__c in :sorgCodes
               and Account__r.SAP_Sales_District_Desc__c in :salesDsts
               and Account__r.SAP_Sales_Office_Desc__c in :salesOfcs
          group by Account__r.SAP_Sales_Group_Desc__c
             limit :MAX_RECS
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('salesGroup');
                if (s != null) {salesGroups.add(s);}
            }
        }
        return salesGroups;
    }

    public static List<Account> getAccounts(String dchanCode,
                                            Date effectFromDate,
                                            Set<String> sorgCodes,
                                            Set<String> salesDsts,
                                            Set<String> salesOfcs,
                                            Set<String> salesGrps) {
        List<Account> accounts = new List<Account>();
        Set<String> accIds = getAccountIds(dchanCode, effectFromDate,
                                           sorgCodes, salesDsts, salesOfcs, salesGrps);
        if (isNotEmpty(accIds)) {
            accounts = [select Id, Name, AccountNumber from Account
                         where Id in :accIds order by Name];
        }
        return accounts;
    }

    public static Set<String> getAccountIds(String dchanCode,
                                            Date effectFromDate,
                                            Set<String> sorgCodes,
                                            Set<String> salesDsts,
                                            Set<String> salesOfcs,
                                            Set<String> salesGrps) {
        Set<String> accIds = new Set<String>();
        AggregateResult[] ars = [
            select Account__r.Id accId
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
               and SalesOrg_Code__c in :sorgCodes
               and Account__r.SAP_Sales_District_Desc__c in :salesDsts
               and Account__r.SAP_Sales_Office_Desc__c in :salesOfcs
               and Account__r.SAP_Sales_Group_Desc__c in :salesGrps
          group by Account__r.Id
             limit :MAX_RECS];
        if (ars != null && !ars.isEmpty()) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('accId');
                if (s != null) {accIds.add(s);}
            }
        }
        return accIds;
    }

    public static Set<String> getProductFamilies(String dchanCode,
                                                 Date effectFromDate,
                                                 Set<String> sorgCodes,
                                                 Set<String> salesDsts,
                                                 Set<String> salesOfcs,
                                                 Set<String> salesGrps,
                                                 Set<String> accountIds) {
        Set<String> ph5s = new Set<String>();
        for (AggregateResult[] ars : [
            select Product_Hierarchy__r.Product_Hierarchy2__r.Product_Hierarchy_Description__c ph5
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
               and SalesOrg_Code__c in :sorgCodes
               and Account__r.SAP_Sales_District_Desc__c in :salesDsts
               and Account__r.SAP_Sales_Office_Desc__c in :salesOfcs
               and Account__r.SAP_Sales_Group_Desc__c in :salesGrps
               and Account__r.Id in :accountIds
          group by Product_Hierarchy__r.Product_Hierarchy2__r.Product_Hierarchy_Description__c
             limit :MAX_RECS
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('ph5');
                if (s != null) {ph5s.add(s);}
            }
        }
        debug('getProductFamilies : ' + ph5s);
        return ph5s;
    }

    public static Set<String> getProductSegments(String dchanCode,
                                                 Date effectFromDate,
                                                 Set<String> sorgCodes,
                                                 Set<String> salesDsts,
                                                 Set<String> salesOfcs,
                                                 Set<String> salesGrps,
                                                 Set<String> accountIds,
                                                 Set<String> ph5Descs) {
        Set<String> ph6s = new Set<String>();
        debug('getProductSegments : ph5Descs = ' + ph5Descs);
        for (AggregateResult[] ars : [
            select Product_Hierarchy__r.Product_Hierarchy1__r.Product_Hierarchy_Description__c ph6
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
               and SalesOrg_Code__c in :sorgCodes
               and Account__r.SAP_Sales_District_Desc__c in :salesDsts
               and Account__r.SAP_Sales_Office_Desc__c in :salesOfcs
               and Account__r.SAP_Sales_Group_Desc__c in :salesGrps
               and Account__r.Id in :accountIds
               and Product_Hierarchy__r.Product_Hierarchy2__r.Product_Hierarchy_Description__c in :ph5Descs
          group by Product_Hierarchy__r.Product_Hierarchy1__r.Product_Hierarchy_Description__c
          //order by Product_Hierarchy__r.Product_Hierarchy6__r.Product_Hierarchy_Description__c
             limit :MAX_RECS
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('ph6');
                if (s != null) {ph6s.add(s);}
            }
        }
        debug('getProductSegments : ' + ph6s);
        return ph6s;
    }

    public static Set<String> getProductSubSegments(String dchanCode,
                                                    Date effectFromDate,
                                                    Set<String> sorgCodes,
                                                    Set<String> salesDsts,
                                                    Set<String> salesOfcs,
                                                    Set<String> salesGrps,
                                                    Set<String> accountIds,
                                                    Set<String> ph5Descs,
                                                    Set<String> ph6Descs) {
        Set<String> ph7s = new Set<String>();
        for (AggregateResult[] ars : [
            select Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c ph7
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
               and SalesOrg_Code__c in :sorgCodes
               and Account__r.SAP_Sales_District_Desc__c in :salesDsts
               and Account__r.SAP_Sales_Office_Desc__c in :salesOfcs
               and Account__r.SAP_Sales_Group_Desc__c in :salesGrps
               and Account__r.Id in :accountIds
               and Product_Hierarchy__r.Product_Hierarchy2__r.Product_Hierarchy_Description__c in :ph5Descs
               and Product_Hierarchy__r.Product_Hierarchy1__r.Product_Hierarchy_Description__c in :ph6Descs
          group by Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c
          //order by Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c
             limit :MAX_RECS
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('ph7');
                if (s != null) {ph7s.add(s);}
            }
        }
        debug('getProductSubSegments : ' + ph7s);
        return ph7s;
    }

    public static Set<String> getBaseCodes(String dchanCode,
                                           Date effectFromDate,
                                           Set<String> sorgCodes,
                                           Set<String> salesDsts,
                                           Set<String> salesOfcs,
                                           Set<String> salesGrps,
                                           Set<String> accountIds,
                                           Set<String> ph5Descs,
                                           Set<String> ph6Descs,
                                           Set<String> ph7Descs) {
        Set<String> bascds = new Set<String>();
        for (AggregateResult[] ars : [
            select Material2__r.Material_Base_Code_Desc__c bascd
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
               and SalesOrg_Code__c in :sorgCodes
               and Account__r.SAP_Sales_District_Desc__c in :salesDsts
               and Account__r.SAP_Sales_Office_Desc__c in :salesOfcs
               and Account__r.SAP_Sales_Group_Desc__c in :salesGrps
               and Account__r.Id in :accountIds
               and Product_Hierarchy__r.Product_Hierarchy2__r.Product_Hierarchy_Description__c in :ph5Descs
               and Product_Hierarchy__r.Product_Hierarchy1__r.Product_Hierarchy_Description__c in :ph6Descs
               and Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c in :ph7Descs
          group by Material2__r.Material_Base_Code_Desc__c
             limit :MAX_RECS
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('bascd');
                if (s != null) {bascds.add(s);}
            }
        }
        return bascds;
    }

    public static List<Material_Sales_Data2__c> getMaterials(String dchanCode,
                                                             Date effectFromDate,
                                                             Set<String> sorgCodes,
                                                             Set<String> salesDsts,
                                                             Set<String> salesOfcs,
                                                             Set<String> salesGrps,
                                                             Set<String> accountIds,
                                                             Set<String> ph5Descs,
                                                             Set<String> ph6Descs,
                                                             Set<String> ph7Descs,
                                                             Set<String> baseCodes) {
        Set<String> matids = getMaterialIds(dchanCode,
                                            effectFromDate,
                                            sorgCodes,
                                            salesDsts,
                                            salesOfcs,
                                            salesGrps,
                                            accountIds,
                                            ph5Descs,
                                            ph6Descs,
                                            ph7Descs,
                                            baseCodes);
        List<Material_Sales_Data2__c> materials = [
            select Id, Name from Material_Sales_Data2__c
             where Id in :matids order by Name];
        return materials;
    }

    public static Set<String> getMaterialIds(String dchanCode,
                                             Date effectFromDate,
                                             Set<String> sorgCodes,
                                             Set<String> salesDsts,
                                             Set<String> salesOfcs,
                                             Set<String> salesGrps,
                                             Set<String> accountIds,
                                             Set<String> ph5Descs,
                                             Set<String> ph6Descs,
                                             Set<String> ph7Descs,
                                             Set<String> baseCodes) {
        Set<String> matids = new Set<String>();
        for (AggregateResult[] ars : [
            select Material2__c matid
              from Pricing_Condition__c
             where DistChan_Code__c = :dchanCode
               and Record_Status__c in :RECSET
               and Valid_To_Date__c >= :effectFromDate
               and SalesOrg_Code__c in :sorgCodes
               and Account__r.SAP_Sales_District_Desc__c in :salesDsts
               and Account__r.SAP_Sales_Office_Desc__c in :salesOfcs
               and Account__r.SAP_Sales_Group_Desc__c in :salesGrps
               and Account__r.Id in :accountIds
               //and Product_Hierarchy__r.Product_Hierarchy5__r.Product_Hierarchy_Description__c in :ph5Descs
              // and Product_Hierarchy__r.Product_Hierarchy6__r.Product_Hierarchy_Description__c in :ph6Descs
               and Product_Hierarchy__r.Product_Hierarchy2__r.Product_Hierarchy_Description__c in :ph5Descs
               and Product_Hierarchy__r.Product_Hierarchy1__r.Product_Hierarchy_Description__c in :ph6Descs
               and Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c in :ph7Descs
               and Material2__r.Material_Base_Code_Desc__c in :baseCodes
          group by Material2__c
             limit :MAX_RECS
        ]) {
            String s;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('matid');
                if (s != null) {matids.add(s);}
            }
        }
        return matids;
    }

    public static List<String> getSearchNames(String userId) {
        List<String> alist = new List<String>();
        for (Pricing_Condition_Search_Criteria__c a : [
            select Search_Name__c
              from Pricing_Condition_Search_Criteria__c
             where User__c = :userId
          order by Search_Name__c]) {
            alist.add(a.Search_Name__c);
        }
        return alist;
    }

    public static Pricing_Condition_Search_Criteria__c getSearchCriteria(String userId, String searchName) {
        String key = userId + DELIM1 + searchName;
        List<Pricing_Condition_Search_Criteria__c> alist = [
            select Id, Name, Account_Ids__c, Distribution_Channel__c, Material_Ids__c,
                   Product_BaseCodes__c, Product_Families__c, Product_Segments__c,
                   Product_SubSegments__c, Record_Key__c, Sales_Districts__c, Sales_Groups__c,
                   Sales_Offices__c, Sales_Orgs__c, Search_Name__c, User__c
              from Pricing_Condition_Search_Criteria__c
             where Record_Key__c = :key limit 1];
        if (alist == null || alist.isEmpty()) {return null;}
        return alist[0];
    }

    private static String getSrchFld(Set<String> aset) {
        String s = ''; if (aset == null || aset.isEmpty()) {return s;}
        for (String a : aset) {s += DELIM1 + a;}
        return s.substring(1);
    }

    public static String saveSearchCriteria(String userId, String searchName, String dchanCode,
                                                        Set<String> sorgCodes,
                                                        Set<String> salesDsts,
                                                        Set<String> salesOfcs,
                                                        Set<String> salesGrps,
                                                        Set<String> accountIds,
                                                        Set<String> ph5Descs,
                                                        Set<String> ph6Descs,
                                                        Set<String> ph7Descs,
                                                        Set<String> baseCodes,
                                                        Set<String> materialIds) {
        String key = userId + DELIM1 + searchName;
        Pricing_Condition_Search_Criteria__c sc = new Pricing_Condition_Search_Criteria__c();
        sc.User__c = userId; sc.Search_Name__c = searchName;
        sc.Record_Key__c = key; sc.Distribution_Channel__c = dchanCode;
        sc.Sales_Orgs__c          = getSrchFld(sorgCodes);
        sc.Sales_Districts__c     = getSrchFld(salesDsts);
        sc.Sales_Offices__c       = getSrchFld(salesOfcs);
        sc.Sales_Groups__c        = getSrchFld(salesGrps);
        sc.Account_Ids__c         = getSrchFld(accountIds);
        sc.Product_Families__c    = getSrchFld(ph5Descs);
        sc.Product_Segments__c    = getSrchFld(ph6Descs);
        sc.Product_SubSegments__c = getSrchFld(ph7Descs);
        sc.Product_BaseCodes__c   = getSrchFld(baseCodes);
        sc.Material_Ids__c        = getSrchFld(materialIds);
        try {upsert sc Pricing_Condition_Search_Criteria__c.Fields.Record_Key__c;}
        catch(Exception e) {key = null; debug('Search Save Failed : ' + e.getMessage());}
        return key;
    }

    public static Database.Querylocator getQueryLocator(String dchanCode,
                                                        Date effectFromDate,
                                                        Date effectToDate,
                                                        Set<String> sorgCodes,
                                                        Set<String> salesDsts,
                                                        Set<String> salesOfcs,
                                                        Set<String> salesGrps,
                                                        Set<String> accountIds,
                                                        Set<String> ph5Descs,
                                                        Set<String> ph6Descs,
                                                        Set<String> ph7Descs,
                                                        Set<String> baseCodes,
                                                        Set<String> materialIds) {
/*
        dchanCode  = '10';
        sorgCodes  = new Set<String>{'1020'};
        salesOfcs  = new Set<String>{'SOUTH PACIFIC DIST'};
        salesGrps  = new Set<String>{'HPST SOUTH PACIFIC 1'};
        accountIds = new Set<String>{'0015000000Fv2XxAAJ'};
        ph5Descs   = new Set<String>{'WATER'};
        ph6Descs   = new Set<String>{'MICROBIOLOGICAL CONTROL'};
        ph7Descs   = new Set<String>{'NON-OXIDIZING'};
//*/
        debug('baseCodes : '+baseCodes);
        String q = PricingConditionFunctions.SELECT_QRY_1 +
             ' where DistChan_Code__c = :dchanCode' +
             '   and Record_Status__c in :RECSET ' +
             '   and Valid_To_Date__c >= :effectFromDate';
        if (isNotEmpty(sorgCodes)) {
          q += ' and SalesOrg_Code__c in :sorgCodes';}

        if (isNotEmpty(salesOfcs)) {
          q += ' and Account__r.SAP_Sales_District_Desc__c in :salesDsts';}

        if (isNotEmpty(salesOfcs)) {
          q += ' and Account__r.SAP_Sales_Office_Desc__c in :salesOfcs';}

        if (isNotEmpty(salesGrps)) {
          q += ' and Account__r.SAP_Sales_Group_Desc__c in :salesGrps';}

        if (isNotEmpty(accountIds)) {
          q += ' and Account__r.Id in :accountIds';}

        /*if (isNotEmpty(ph5Descs)) {
          q += ' and Product_Hierarchy__r.Product_Hierarchy5__r.Product_Hierarchy_Description__c in :ph5Descs';}

        if (isNotEmpty(ph6Descs)) {
          q += ' and Product_Hierarchy__r.Product_Hierarchy6__r.Product_Hierarchy_Description__c in :ph6Descs';}*/
          
        if (isNotEmpty(ph5Descs)) {
          q += ' and Product_Hierarchy__r.Product_Hierarchy2__r.Product_Hierarchy_Description__c in :ph5Descs';}

        if (isNotEmpty(ph6Descs)) {
          q += ' and Product_Hierarchy__r.Product_Hierarchy1__r.Product_Hierarchy_Description__c in :ph6Descs';}

        if (isNotEmpty(ph7Descs)) {
          q += ' and Product_Hierarchy__r.Product_Hierarchy7__r.Product_Hierarchy_Description__c in :ph7Descs';}

        if (isNotEmpty(baseCodes)) {
          q += ' and Material2__r.Material_Base_Code_Desc__c in :baseCodes';}

        if (isNotEmpty(materialIds)) {
          q += ' and Material2__c in :materialIds';}

        q += ' order by';
        q += ' Account__r.Name';
        q += ',Material2__r.Material_Desc__c';
        q += ' limit :MAX_PC_RECS';
        Database.Querylocator ql = Database.getQueryLocator(q);
        return ql;
    }

    private static Boolean isNotEmpty(Set<String> ss) {return (ss != null && !ss.isEmpty());}

    public static List<Pricing_Condition> getPricingConditions(List<Pricing_Condition__c> pcs,
                                                               Integer recordFrom,
                                                               Date effectToDate,
                                                               Double priceIncreaseAmount,
                                                               Double priceIncreasePercnt) {
        List<Pricing_Condition> pclist = new List<Pricing_Condition>();
        Double bp; Integer d1, n = recordFrom; Pricing_Condition pc;
        Boolean noChangeInPrice = (priceIncreaseAmount == 0.0 && priceIncreasePercnt == 0.0);
        String dt = Datetime.now().format(), un = UserInfo.getName();
        for (Pricing_Condition__c p : pcs) {
            bp = PricingConditionFunctions.getIncreasedBasePrice(p, priceIncreaseAmount, priceIncreasePercnt);
            pc = new Pricing_Condition(p, n++); pc.basePrice = bp;
            if (noChangeInPrice && effectToDate != null && noNeedToExtend(p, effectToDate)) {
                pc.comments = 'Above Pricing Condition will not be extended because ' +
                            'its Valid To Date is later than Effect To Date';
            }
            if (noChangeInPrice) {setPriceExtendFields(p, effectToDate, dt, un);}
            pclist.add(pc);
        }
        return pclist;
    }

    private static Boolean noNeedToExtend(Pricing_Condition__c p, Date effectToDate) {
        Integer d1 = effectToDate.daysBetween(p.Valid_To_Date__c);
        return (d1 >= 0); // effectToDate date is earlier than current to_date
    }

    private static String doubleToString(Double f) {
        String s = '';
        if (f != null) {
            Decimal d = Decimal.valueOf(f).stripTrailingZeros();
            Integer n = d.scale();
            s = d.setScale(n).toPlainString();
        }
        return s;
    }

    private static void setPriceExtendFields(Pricing_Condition__c p, Date effectToDate, String dt, String un) {
        // effectToDate date is earlier than current to_date
        if (effectToDate != null && noNeedToExtend(p, effectToDate)) {return;}
        Date fdate = p.Valid_To_Date__c.addDays(1);
        Integer n = PricingConditionFunctions.getMaxDaysToExtend(p);
        Date tdate = p.Valid_To_Date__c.addDays(n);
        p.Valid_From_Date__c = fdate; p.Valid_To_Date__c = tdate;
        if (effectToDate != null) {
            Integer d2 = effectToDate.daysBetween(tdate);
            if (d2 > 0) {p.Valid_To_Date__c = effectToDate;}
        }
        String c = p.Comments__c; if (c == null) {c = '';}
        p.Comments__c = dt + ' : ' + un + ' : Generated from ' + p.Name + ' by extending the Price\n' + c;
    }

    private static void setPriceUpdateFields(Pricing_Condition__c p,
                                             Double priceIncreaseAmount, String stramt,
                                             Double priceIncreasePercnt,
                                             Date effectFromDate,
                                             Date effectToDate, Date tdate, String dt, String un) {
        Integer d1 = tdate.daysBetween(effectFromDate);
        Integer d2 = effectFromDate.daysBetween(p.Valid_To_Date__c);
        // effectFromDate date is earlier than today or later than current to_date
        if (d1 < 0 || d2 < 0) {return;}
        Double bp = PricingConditionFunctions.getIncreasedBasePrice(p, priceIncreaseAmount, priceIncreasePercnt);
        p.Base_Price__c = bp;
        p.Valid_From_Date__c = effectFromDate;
        p.Generated_From_Increase__c = true;
        String c = p.Comments__c; if (c == null) {c = '';}
        String t = dt + ' : ' + un + ' : ' + 'Generated from ' + p.Name + ' by increasing the Price by ';
        if (priceIncreaseAmount != null && priceIncreaseAmount != 0.0) {
            p.Comments__c = t + stramt + '\n' + c;
        } else
        if (priceIncreasePercnt != null && priceIncreasePercnt != 0.0) {
            p.Comments__c = t + priceIncreasePercnt + '%\n' + c;
        }
        if (p.Dist_Channel_Code__c == DIST_CHANNEL_AHWT) {
            p.Request_Reason__c = '0010';
            p.Request_Reason_Desc__c = 'Existing Application with Price Increase';
        }
        PricingConditionFunctions.increasePriceScales(p, priceIncreaseAmount, priceIncreasePercnt);
    }

    public static void cloneAndSubmitForApproval(List<Pricing_Condition__c> plist,
                                                 Double priceIncreaseAmount,
                                                 Double priceIncreasePercnt,
                                                 Date effectFromDate,
                                                 Date effectToDate,
                                                 Boolean submitForApproval) {
        Date tdate = Date.today();
        List<Pricing_Condition__c> clist = PricingConditionFunctions.getClonedPricingConditions(plist);
        List<Pricing_Condition__c> ilist = new List<Pricing_Condition__c>();
        String dt = Datetime.now().format(), un = UserInfo.getName();
        String stramt = doubleToString(priceIncreaseAmount);
        Boolean noChangeInPrice = (priceIncreaseAmount == 0.0 && priceIncreasePercnt == 0.0);
        for (Pricing_Condition__c p : clist) {
            p.Record_Status__c = 'Draft'; p.Current_State__c = 'Draft'; p.Active__c = false;
            if (noChangeInPrice) {
                if (effectToDate != null && noNeedToExtend(p, effectToDate)) {continue;}
                setPriceExtendFields(p, effectToDate, dt, un);
            } else {
                setPriceUpdateFields(p, priceIncreaseAmount, stramt, priceIncreasePercnt,
                                    effectFromDate, effectToDate, tdate, dt, un);
            }
            ilist.add(p);
        }
        if (ilist.isEmpty()) {return;}
        //debug(''+ilist);
        if (submitForApproval) {PricingConditionFunctions.insertAndSubmitForApproval(ilist);}
        else {PricingConditionFunctions.insertPricingConditions(ilist);}
    }

// *********************************************************************************************

}