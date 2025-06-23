public class PricingConditionUpdateController {

    private static final Integer PAGE_SIZE = 60;
    private static final Integer BATCH_SIZE = 10;
    private static final Integer SOPTS_SIZE = 1000;
    private static final String DCHAN_AHWT = '10';

    private static final String SPACE = ' ';
    private static final String NBSP = '&nbsp;';
    private static final String TAB_DCHAN = 'tabDChan';
    private static final String TAB_SORG = 'tabSOrg';
    private static final String TAB_SDST = 'tabSDst';
    private static final String TAB_SOFC = 'tabSOfc';
    private static final String TAB_SGRP = 'tabSGrp';
    private static final String TAB_ACC = 'tabAcc';
    private static final String TAB_PH5 = 'tabPH5';
    private static final String TAB_PH6 = 'tabPH6';
    private static final String TAB_PH7 = 'tabPH7';
    private static final String TAB_BCD = 'tabBcd';
    private static final String TAB_MAT = 'tabMat';

    private static final String DELIM3 = '#~#';
    private static final String NONE = '-- None --';

    private static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    private static final ApexPages.Severity INFO = ApexPages.Severity.INFO;

    public Integer maxDaysToExtend        {get; set;}
    public Integer pageBlockNumber        {get; set;}
    public String  activeTab              {get; set;}

    public Account acc                    {get; set;}
    public Pricing_Condition__c pc        {get; set;}
    public String accountId               {get; set;}
    public String dchanCode               {get; set;}
    public Double priceIncreaseAmount     {get; set;}
    public Double priceIncreasePercnt     {get; set;}
    public String strPriceIncreaseAmount  {get; set;}
    public String strPriceIncreasePercnt  {get; set;}
    public Date effectFromDate            {get; set;}
    public Date effectToDate              {get; set;}
    public Boolean allSelected            {get; set;}
    public Boolean disableUpdateBtn       {get; set;}
    public Boolean submitForApproval      {get; set;}
    public String userLocale              {get; set;}

    public Boolean renderAccOpts          {get; set;}

    private Pricing_Condition_Search_Criteria__c pcsc;
    private Set<String> searchNameSet;
    public List<SelectOption> searchNames {get; set;}
    public String searchName              {get; set;}
    public String newSearch               {get; set;}

    public PaginationController pc1       {get; private set;}
    public Integer pageSize1              {get; private set;}

    transient public List<Pricing_Condition> pclist {get; private set;}

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }

    private void addErrMsg(String s) {addMsg(ERROR, s);}

    private void addInfoMsg(String s) {addMsg(INFO, s);}

    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }

    public PricingConditionUpdateController(ApexPages.StandardController c) {
        init();
    }

    public void init() {
        activeTab = TAB_DCHAN; dchanCode = DCHAN_AHWT; pageSize1 = PAGE_SIZE;
        pageBlockNumber = 1; setMaxDaysToExtend();
        pc = new Pricing_Condition__c();
        pc.Valid_From_Date__c = Date.today(); // for date type input field
        userLocale = UserInfo.getLocale();
        submitForApproval = false; disableUpdateBtn = false; renderAccOpts = true;
        accountId = ApexPages.currentPage().getParameters().get('ac');
        if (accountId != null) {initAccount();}
        strPriceIncreaseAmount = '0.0000'; strPriceIncreasePercnt = '0.00';
        priceIncreaseAmount = 0.0; priceIncreasePercnt = 0.0;
        searchName = ''; newSearch = ''; pcsc = null;
        initSearchNames();
    }

    private void initAccount() {
        acc = [select Id, Name, AccountNumber, RecordTypeId, SAP_DistChannel__c,
                      SAP_Sales_District_Desc__c, SAP_Sales_Group_Desc__c,
                      SAP_Sales_Office_Desc__c, SAP_Sales_Org__c
                from Account where Id = :accountId];
        dchanCode = acc.SAP_DistChannel__c; setMaxDaysToExtend();
        selectedAccountIds = new Set<String>{acc.Id};
        selectedSalesDistricts = new Set<String>{acc.SAP_Sales_District_Desc__c};
        selectedSalesGroups = new Set<String>{acc.SAP_Sales_Group_Desc__c};
        selectedSalesOffices = new Set<String>{acc.SAP_Sales_Office_Desc__c};
        selectedSalesOrgCodes = new Set<String>{acc.SAP_Sales_Org__c};
        renderAccOpts = false;
    }

    private void initSearchNames() {
        searchNames = new List<SelectOption>();
        searchNames.add(new SelectOption('', ''));
        String userId = UserInfo.getUserId();
        List<String> slist = PricingConditionUpdateFunctions.getSearchNames(userId);
        searchNameSet = new Set<String>();
        for (String s : slist) {
            searchNameSet.add(s); searchNames.add(new SelectOption(s, s));
        }
    }

    private void setMaxDaysToExtend() {
        maxDaysToExtend = PricingConditionFunctions.getMaxDaysToExtend(dchanCode);
    }

    public void changeDchan() {
        setMaxDaysToExtend();
    }

    public List<SelectOption> getPriceIncreasePercnts() {
        List<SelectOption> opts = new List<SelectOption>();
        String v, l;
        for (Integer i = -10; i <= 30; i++) {
            v = ''+i; l = i+' % ';
            opts.add(new SelectOption(v, l));
        }
        return opts;
    }

    private Boolean validate1() {
        Boolean b = true; priceIncreaseAmount = 0.0;
        try {
            effectFromDate = pc.Valid_From_Date__c;
            effectToDate = pc.Valid_To_Date__c;
            priceIncreaseAmount = Double.valueOf(strPriceIncreaseAmount);
            priceIncreasePercnt = Double.valueOf(strPriceIncreasePercnt);
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                'Invalid Input Values'));
            b = false;
        }
        if (priceIncreasePercnt != null && (priceIncreasePercnt < -10.0 || priceIncreasePercnt > 30.0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                'Valid Price Increase Percent Range : from -10.00 to +30.00'));
            b = false;
        }
        if (effectToDate != null && effectFromDate.daysBetween(effectToDate) < 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                'Effective To Date is before From Date'));
            b = false;
        }
        //debug('priceIncreasePercnt : '+priceIncreasePercnt);
        //debug('effectFromDate : '+effectFromDate);
        debug('effectToDate : '+effectToDate);
        return b;
    }

// --------------------------------- Sales Orgs -----------------------------

    Map<String, SelectOption> sorgOptsMap1;
    Map<String, SelectOption> sorgOptsMap2;
    public List<String> salesOrgCodes = new List<String>();
    public Set<String> selectedSalesOrgCodes;
    public String[] salesOrgs1 = new String[]{},
                    salesOrgs2 = new String[]{};

    public void getSapSalesOrgs() {
        if (!validate1()) {return;}
        sorgOptsMap1 = new Map<String, SelectOption>();
        sorgOptsMap2 = new Map<String, SelectOption>();
        salesOrgCodes = new List<String>();
        List<SAP_Sales_Org__c> sapSalesOrgs;
        sapSalesOrgs = PricingConditionUpdateFunctions.getSapSalesOrgs(dchanCode,
                                                                       effectFromDate);
        String v, n; Integer i = 0;
        for (SAP_Sales_Org__c s : sapSalesOrgs) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            v = s.Sales_Org_Code__c;
            n = v + ' - ' + s.Sales_Org_Description__c;
            sorgOptsMap1.put(v, new SelectOption(v, n));
            salesOrgCodes.add(v);
        }
        if (salesOrgCodes.size() == 1){addAllSalesOrgs2();}
        else {salesOrgCodes.sort();}
        activeTab = TAB_SORG;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Sales_Orgs__c);
        removeAllSalesOrgs2(); addSalesOrgs(slist);
    }

    public List<SelectOption> getSorgOpts1() {return getSorgOpts(sorgOptsMap1);}
    public List<SelectOption> getSorgOpts2() {return getSorgOpts(sorgOptsMap2);}

    private List<SelectOption> getSorgOpts(Map<String, SelectOption> sorgOptsMap) {
        List<SelectOption> sorgOpts = new List<SelectOption>();
        Integer i = 0;
        for (String s : salesOrgCodes) {
            if (sorgOptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                sorgOpts.add(sorgOptsMap.get(s));
            }
        }
        return sorgOpts;
    }

    public String[] getSalesOrgs1() {return salesOrgs1;}

    public void setSalesOrgs1(String[] sorgs) {
        salesOrgs1 = sorgs;
    }

    public String[] getSalesOrgs2() {return salesOrgs2;}

    public void setSalesOrgs2(String[] sorgs) {
        salesOrgs2 = sorgs;
    }

    private void addSalesOrgs(String[] salesOrgs) {
        for (String s : salesOrgs) {
            if (sorgOptsMap1.containsKey(s)) {
                sorgOptsMap2.put(s, sorgOptsMap1.get(s));
                sorgOptsMap1.remove(s);
            }
        }
    }

    public void addAllSalesOrgs2() {
        addSalesOrgs(salesOrgCodes);
    }

    public void addSalesOrgs2() {
        addSalesOrgs(salesOrgs1);
    }

    private void removeSalesOrgs(String[] salesOrgs) {
        for (String s : salesOrgs) {
            if (sorgOptsMap2.containsKey(s)) {
                sorgOptsMap1.put(s, sorgOptsMap2.get(s));
                sorgOptsMap2.remove(s);
            }
        }
    }

    public void removeAllSalesOrgs2() {
        removeSalesOrgs(salesOrgCodes);
    }

    public void removeSalesOrgs2() {
        removeSalesOrgs(salesOrgs2);
    }

    public void getSelectedSalesOrgCodes() {
        selectedSalesOrgCodes = new Set<String>();
        List<SelectOption> sos = getSorgOpts2();
        for (SelectOption so : sos) {
            selectedSalesOrgCodes.add(so.getValue());
        }
    }

// --------------------------------- Sales Districts -----------------------------

    Map<String, SelectOption> sdstOptsMap1;
    Map<String, SelectOption> sdstOptsMap2;
    public List<String> salesDistricts = new List<String>();
    public Set<String> selectedSalesDistricts;
    public String[] salesDsts1 = new String[]{},
                    salesDsts2 = new String[]{};

    public void getSalesDistricts() {
        if (!validate1()) {return;}
        sdstOptsMap1 = new Map<String, SelectOption>();
        sdstOptsMap2 = new Map<String, SelectOption>();
        salesDistricts = new List<String>();
        if (sorgOptsMap2 != null && !sorgOptsMap2.isEmpty()) {getSelectedSalesOrgCodes();}
        Set<String> ss = PricingConditionUpdateFunctions.getSalesDistricts(dchanCode,
                                                                           effectFromDate,
                                                                           selectedSalesOrgCodes);
        Integer i = 0; SelectOption so;
        for (String s : ss) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            s = s.replaceAll(SPACE, NBSP);
            so = new SelectOption(s, s);
            so.setEscapeItem(false);
            sdstOptsMap1.put(s, so);
            salesDistricts.add(s);
        }
        if (salesDistricts.size() == 1) {addAllSalesDsts2();}
        else {salesDistricts.sort();}
        activeTab = TAB_SDST;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Sales_Districts__c);
        debug('getSalesDistricts : slist = ' + slist);
        removeAllSalesDsts2(); addSalesDsts(slist);
    }

    public List<SelectOption> getSdstOpts1() {return getSdstOpts(sdstOptsMap1);}
    public List<SelectOption> getSdstOpts2() {return getSdstOpts(sdstOptsMap2);}

    private List<SelectOption> getSdstOpts(Map<String, SelectOption> sdstOptsMap) {
        List<SelectOption> sdstOpts = new List<SelectOption>();
        Integer i = 0;
        for (String s : salesDistricts) {
            if (sdstOptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                sdstOpts.add(sdstOptsMap.get(s));
            }
        }
        return sdstOpts;
    }

    public String[] getSalesDsts1() {return salesDsts1;}

    public void setSalesDsts1(String[] sdsts) {
        salesDsts1 = sdsts;
    }

    public String[] getSalesDsts2() {return salesDsts2;}

    public void setSalesDsts2(String[] sdsts) {
        salesDsts2 = sdsts;
    }

    private void addSalesDsts(String[] salesDsts) {
        for (String s : salesDsts) {
            if (sdstOptsMap1.containsKey(s)) {
                sdstOptsMap2.put(s, sdstOptsMap1.get(s));
                sdstOptsMap1.remove(s);
            }
        }
    }

    public void addAllSalesDsts2() {
        addSalesDsts(salesDistricts);
    }

    public void addSalesDsts2() {
        addSalesDsts(salesDsts1);
    }

    private void removeSalesDsts(String[] salesDsts) {
        for (String s : salesDsts) {
            if (sdstOptsMap2.containsKey(s)) {
                sdstOptsMap1.put(s, sdstOptsMap2.get(s));
                sdstOptsMap2.remove(s);
            }
        }
    }

    public void removeAllSalesDsts2() {
        removeSalesDsts(salesDistricts);
    }

    public void removeSalesDsts2() {
        removeSalesDsts(salesDsts2);
    }

    public void getSelectedSalesDistricts() {
        selectedSalesDistricts = new Set<String>();
        List<SelectOption> sos = getSdstOpts2();
        String s;
        for (SelectOption so : sos) {
            s = so.getValue();
            s = s.replaceAll(NBSP, SPACE);
            selectedSalesDistricts.add(s);
        }
    }

// --------------------------------- Sales Offices -----------------------------

    Map<String, SelectOption> sofcOptsMap1;
    Map<String, SelectOption> sofcOptsMap2;
    public List<String> salesOffices = new List<String>();
    public Set<String> selectedSalesOffices;
    public String[] salesOfcs1 = new String[]{},
                    salesOfcs2 = new String[]{};

    public void getSalesOffices() {
        if (!validate1()) {return;}
        sofcOptsMap1 = new Map<String, SelectOption>();
        sofcOptsMap2 = new Map<String, SelectOption>();
        salesOffices = new List<String>();
        if (sdstOptsMap2 != null && !sdstOptsMap2.isEmpty()) {getSelectedSalesDistricts();}
        Set<String> ss = PricingConditionUpdateFunctions.getSalesOffices(dchanCode,
                                                                         effectFromDate,
                                                                         selectedSalesOrgCodes,
                                                                         selectedSalesDistricts);
        Integer i = 0; SelectOption so;
        for (String s : ss) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            s = s.replaceAll(SPACE, NBSP);
            so = new SelectOption(s, s);
            so.setEscapeItem(false);
            sofcOptsMap1.put(s, so);
            salesOffices.add(s);
        }
        if (salesOffices.size() == 1) {addAllSalesOfcs2();}
        else {salesOffices.sort();}
        activeTab = TAB_SOFC;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Sales_Offices__c);
        debug('getSalesOffices : slist = ' + slist);
        removeAllSalesOfcs2(); addSalesOfcs(slist);
    }

    public List<SelectOption> getSofcOpts1() {return getSofcOpts(sofcOptsMap1);}
    public List<SelectOption> getSofcOpts2() {return getSofcOpts(sofcOptsMap2);}

    private List<SelectOption> getSofcOpts(Map<String, SelectOption> sofcOptsMap) {
        List<SelectOption> sofcOpts = new List<SelectOption>();
        Integer i = 0;
        for (String s : salesOffices) {
            if (sofcOptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                sofcOpts.add(sofcOptsMap.get(s));
            }
        }
        return sofcOpts;
    }

    public String[] getSalesOfcs1() {return salesOfcs1;}

    public void setSalesOfcs1(String[] sofcs) {
        salesOfcs1 = sofcs;
    }

    public String[] getSalesOfcs2() {return salesOfcs2;}

    public void setSalesOfcs2(String[] sofcs) {
        salesOfcs2 = sofcs;
    }

    private void addSalesOfcs(String[] salesOfcs) {
        for (String s : salesOfcs) {
            if (sofcOptsMap1.containsKey(s)) {
                sofcOptsMap2.put(s, sofcOptsMap1.get(s));
                sofcOptsMap1.remove(s);
            }
        }
    }

    public void addAllSalesOfcs2() {
        addSalesOfcs(salesOffices);
    }

    public void addSalesOfcs2() {
        addSalesOfcs(salesOfcs1);
    }

    private void removeSalesOfcs(String[] salesOfcs) {
        for (String s : salesOfcs) {
            if (sofcOptsMap2.containsKey(s)) {
                sofcOptsMap1.put(s, sofcOptsMap2.get(s));
                sofcOptsMap2.remove(s);
            }
        }
    }

    public void removeAllSalesOfcs2() {
        removeSalesOfcs(salesOffices);
    }

    public void removeSalesOfcs2() {
        removeSalesOfcs(salesOfcs2);
    }

    public void getSelectedSalesOffices() {
        selectedSalesOffices = new Set<String>();
        List<SelectOption> sos = getSofcOpts2();
        String s;
        for (SelectOption so : sos) {
            s = so.getValue();
            s = s.replaceAll(NBSP, SPACE);
            selectedSalesOffices.add(s);
        }
    }

// --------------------------------- Sales Groups -----------------------------

    Map<String, SelectOption> sgrpOptsMap1;
    Map<String, SelectOption> sgrpOptsMap2;
    public List<String> salesGroups = new List<String>();
    public Set<String> selectedSalesGroups;
    public String[] salesGrps1 = new String[]{},
                    salesGrps2 = new String[]{};

    public void getSalesGroups() {
        if (!validate1()) {return;}
        sgrpOptsMap1 = new Map<String, SelectOption>();
        sgrpOptsMap2 = new Map<String, SelectOption>();
        salesGroups = new List<String>();
        if (sofcOptsMap2 != null && !sofcOptsMap2.isEmpty()) {getSelectedSalesOffices();}
        Set<String> ss = PricingConditionUpdateFunctions.getSalesGroups(dchanCode,
                                                                        effectFromDate,
                                                                        selectedSalesOrgCodes,
                                                                        selectedSalesDistricts,
                                                                        selectedSalesOffices);
        Integer i = 0; SelectOption so;
        for (String s : ss) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            s = s.replaceAll(SPACE, NBSP);
            so = new SelectOption(s, s);
            so.setEscapeItem(false);
            sgrpOptsMap1.put(s, so);
            salesGroups.add(s);
        }
        if (salesGroups.size() == 1) {addAllSalesGrps2();}
        else {salesGroups.sort();}
        activeTab = TAB_SGRP;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Sales_Groups__c);
        removeAllSalesGrps2(); addSalesGrps(slist);
    }

    public List<SelectOption> getSgrpOpts1() {return getSgrpOpts(sgrpOptsMap1);}
    public List<SelectOption> getSgrpOpts2() {return getSgrpOpts(sgrpOptsMap2);}

    private List<SelectOption> getSgrpOpts(Map<String, SelectOption> sgrpOptsMap) {
        List<SelectOption> sgrpOpts = new List<SelectOption>();
        Integer i = 0;
        for (String s : salesGroups) {
            if (sgrpOptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                sgrpOpts.add(sgrpOptsMap.get(s));
            }
        }
        return sgrpOpts;
    }

    public String[] getSalesGrps1() {return salesGrps1;}

    public void setSalesGrps1(String[] sgrps) {
        salesGrps1 = sgrps;
    }

    public String[] getSalesGrps2() {return salesGrps2;}

    public void setSalesGrps2(String[] sgrps) {
        salesGrps2 = sgrps;
    }

    private void addSalesGrps(String[] salesGrps) {
        for (String s : salesGrps) {
            if (sgrpOptsMap1.containsKey(s)) {
                sgrpOptsMap2.put(s, sgrpOptsMap1.get(s));
                sgrpOptsMap1.remove(s);
            }
        }
    }

    public void addAllSalesGrps2() {
        addSalesGrps(salesGroups);
    }

    public void addSalesGrps2() {
        addSalesGrps(salesGrps1);
    }

    private void removeSalesGrps(String[] salesGrps) {
        for (String s : salesGrps) {
            if (sgrpOptsMap2.containsKey(s)) {
                sgrpOptsMap1.put(s, sgrpOptsMap2.get(s));
                sgrpOptsMap2.remove(s);
            }
        }
    }

    public void removeAllSalesGrps2() {
        removeSalesGrps(salesGroups);
    }

    public void removeSalesGrps2() {
        removeSalesGrps(salesGrps2);
    }

    public void getSelectedSalesGroups() {
        selectedSalesGroups = new Set<String>();
        List<SelectOption> sos = getSgrpOpts2();
        String s;
        for (SelectOption so : sos) {
            s = so.getValue();
            s = s.replaceAll(NBSP, SPACE);
            selectedSalesGroups.add(s);
        }
    }

// --------------------------------- Accounts -----------------------------

    Map<String, SelectOption> accOptsMap1;
    Map<String, SelectOption> accOptsMap2;
    public List<String> accountIds = new List<String>();
    public Set<String> selectedAccountIds;
    public String[] accountIds1 = new String[]{},
                    accountIds2 = new String[]{};

    public void getAccounts() {
        if (!validate1()) {return;}
        accOptsMap1 = new Map<String, SelectOption>();
        accOptsMap2 = new Map<String, SelectOption>();
        accountIds = new List<String>();
        if (sgrpOptsMap2 != null && !sgrpOptsMap2.isEmpty()) {getSelectedSalesGroups();}
        List<Account> accounts;
        accounts = PricingConditionUpdateFunctions.getAccounts(dchanCode,
                                                               effectFromDate,
                                                               selectedSalesOrgCodes,
                                                               selectedSalesDistricts,
                                                               selectedSalesOffices,
                                                               selectedSalesGroups);
        String v, l, accnum;
        Integer i = 0; SelectOption so;
        for (Account a : accounts) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            accnum = String_Functions.removeLeadingZeros(a.AccountNumber);
            l = a.Name + ' - ' + accnum;
            l = l.replaceAll(SPACE, NBSP);
            //v = l+DELIM3+a.Id;
            v = a.Id;
            so = new SelectOption(v, l);
            so.setEscapeItem(false);
            accOptsMap1.put(v, so);
            accountIds.add(v);
        }
        if (accountIds.size() == 1) {addAllAccountIds2();}
        //else {accountIds.sort();}
        activeTab = TAB_ACC;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Account_Ids__c);
        removeAllAccountIds2(); addAccountIds(slist);
    }

    public List<SelectOption> getAccOpts1() {return getAccOpts(accOptsMap1);}
    public List<SelectOption> getAccOpts2() {return getAccOpts(accOptsMap2);}

    private List<SelectOption> getAccOpts(Map<String, SelectOption> accOptsMap) {
        List<SelectOption> accOpts = new List<SelectOption>();
        Integer i = 0;
        for (String s : accountIds) {
            if (accOptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                accOpts.add(accOptsMap.get(s));
            }
        }
        //debug('accOpts.size = '+accOpts.size());
        return accOpts;
    }

    public String[] getAccountIds1() {return accountIds1;}

    public void setAccountIds1(String[] accIds) {
        accountIds1 = accIds;
    }

    public String[] getAccountIds2() {return accountIds2;}

    public void setAccountIds2(String[] accIds) {
        accountIds2 = accIds;
    }

    private void addAccountIds(String[] accIds) {
        for (String s : accIds) {
            if (accOptsMap1.containsKey(s)) {
                accOptsMap2.put(s, accOptsMap1.get(s));
                accOptsMap1.remove(s);
            }
        }
    }

    public void addAllAccountIds2() {
        addAccountIds(accountIds);
    }

    public void addAccountIds2() {
        addAccountIds(accountIds1);
    }

    private void removeAccountIds(String[] accIds) {
        for (String s : accIds) {
            if (accOptsMap2.containsKey(s)) {
                accOptsMap1.put(s, accOptsMap2.get(s));
                accOptsMap2.remove(s);
            }
        }
    }

    public void removeAllAccountIds2() {
        removeAccountIds(accountIds);
    }

    public void removeAccountIds2() {
        removeAccountIds(accountIds2);
    }

    public void getSelectedAccountIds() {
        selectedAccountIds = new Set<String>();
        List<SelectOption> sos = getAccOpts2();
        String v; String[] sa;
        for (SelectOption so : sos) {
            v = so.getValue();
            v = v.replaceAll(NBSP, SPACE);
            //sa = v.split(DELIM3);
            //if(sa.size() > 1){selectedAccountIds.add(sa[1]);}
            selectedAccountIds.add(v);
        }
        //debug('selectedAccountIds.size = ' + selectedAccountIds.size());
    }

// --------------------------------- Product Families (PH5) -----------------------------

    Map<String, SelectOption> ph5OptsMap1;
    Map<String, SelectOption> ph5OptsMap2;
    public List<String> ph5list = new List<String>();
    public Set<String> selectedPh5s;
    public String[] ph5s1 = new String[]{},
                    ph5s2 = new String[]{};

    public void getProductFamilies() {
        if (!validate1()) {return;}
        ph5OptsMap1 = new Map<String, SelectOption>();
        ph5OptsMap2 = new Map<String, SelectOption>();
        ph5list = new List<String>();
        if (accOptsMap2 != null && !accOptsMap2.isEmpty()) {getSelectedAccountIds();}
        Set<String> ss = PricingConditionUpdateFunctions.getProductFamilies(dchanCode,
                                                                            effectFromDate,
                                                                            selectedSalesOrgCodes,
                                                                            selectedSalesDistricts,
                                                                            selectedSalesOffices,
                                                                            selectedSalesGroups,
                                                                            selectedAccountIds);
        Integer i = 0; SelectOption so;
        for (String s : ss) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            s = s.replaceAll(SPACE, NBSP);
            so = new SelectOption(s, s);
            so.setEscapeItem(false);
            ph5OptsMap1.put(s, so);
            ph5list.add(s);
        }
        if (ph5list.size() == 1) {addAllPh5s2();}
        else {ph5list.sort();}
        activeTab = TAB_PH5;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Product_Families__c);
        removeAllPh5s2(); addPh5s(slist);
    }

    public List<SelectOption> getPh5Opts1() {return getPh5Opts(ph5OptsMap1);}
    public List<SelectOption> getPh5Opts2() {return getPh5Opts(ph5OptsMap2);}

    private List<SelectOption> getPh5Opts(Map<String, SelectOption> ph5OptsMap) {
        List<SelectOption> ph5Opts = new List<SelectOption>();
        Integer i = 0;
        for (String s : ph5list) {
            if (ph5OptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                ph5Opts.add(ph5OptsMap.get(s));
            }
        }
        return ph5Opts;
    }

    public String[] getPh5s1() {return ph5s1;}

    public void setPh5s1(String[] ph5s) {
        ph5s1 = ph5s;
    }

    public String[] getPh5s2() {return ph5s2;}

    public void setPh5s2(String[] ph5s) {
        ph5s2 = ph5s;
    }

    private void addPh5s(String[] ph5s) {
        for (String s : ph5s) {
            if (ph5OptsMap1.containsKey(s)) {
                ph5OptsMap2.put(s, ph5OptsMap1.get(s));
                ph5OptsMap1.remove(s);
            }
        }
    }

    public void addAllPh5s2() {
        addPh5s(ph5list);
    }

    public void addPh5s2() {
        addPh5s(ph5s1);
    }

    private void removePh5s(String[] ph5s) {
        for (String s : ph5s) {
            if (ph5OptsMap2.containsKey(s)) {
                ph5OptsMap1.put(s, ph5OptsMap2.get(s));
                ph5OptsMap2.remove(s);
            }
        }
    }

    public void removeAllPh5s2() {
        removePh5s(ph5list);
    }

    public void removePh5s2() {
        removePh5s(ph5s2);
    }

    public void getSelectedPh5s() {
        selectedPh5s = new Set<String>();
        List<SelectOption> sos = getPh5Opts2();
        String s;
        for (SelectOption so : sos) {
            s = so.getValue();
            s = s.replaceAll(NBSP, SPACE);
            selectedPh5s.add(s);
        }
    }

// --------------------------------- Product Segments (PH6) -----------------------------

    Map<String, SelectOption> ph6OptsMap1;
    Map<String, SelectOption> ph6OptsMap2;
    public List<String> ph6list = new List<String>();
    public Set<String> selectedPh6s;
    public String[] ph6s1 = new String[]{},
                    ph6s2 = new String[]{};

    public void getProductSegments() {
        if (!validate1()) {return;}
        ph6OptsMap1 = new Map<String, SelectOption>();
        ph6OptsMap2 = new Map<String, SelectOption>();
        ph6list = new List<String>();
        getSelectedPh5s();
        Set<String> ss = PricingConditionUpdateFunctions.getProductSegments(dchanCode,
                                                                            effectFromDate,
                                                                            selectedSalesOrgCodes,
                                                                            selectedSalesDistricts,
                                                                            selectedSalesOffices,
                                                                            selectedSalesGroups,
                                                                            selectedAccountIds,
                                                                            selectedPh5s);
        Integer i = 0; SelectOption so;
        for (String s : ss) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            s = s.replaceAll(SPACE, NBSP);
            so = new SelectOption(s, s);
            so.setEscapeItem(false);
            ph6OptsMap1.put(s, so);
            ph6list.add(s);
        }
        if (ph6list.size() == 1) {addAllPh6s2();}
        else {ph6list.sort();}
        activeTab = TAB_PH6;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Product_Segments__c);
        removeAllPh6s2(); addPh6s(slist);
    }

    public List<SelectOption> getPh6Opts1() {return getPh6Opts(ph6OptsMap1);}
    public List<SelectOption> getPh6Opts2() {return getPh6Opts(ph6OptsMap2);}

    private List<SelectOption> getPh6Opts(Map<String, SelectOption> ph6OptsMap) {
        List<SelectOption> ph6Opts = new List<SelectOption>();
        Integer i = 0;
        for (String s : ph6list) {
            if (ph6OptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                ph6Opts.add(ph6OptsMap.get(s));
            }
        }
        return ph6Opts;
    }

    public String[] getPh6s1() {return ph6s1;}

    public void setPh6s1(String[] ph6s) {
        ph6s1 = ph6s;
    }

    public String[] getPh6s2() {return ph6s2;}

    public void setPh6s2(String[] ph6s) {
        ph6s2 = ph6s;
    }

    private void addPh6s(String[] ph6s) {
        for (String s : ph6s) {
            if (ph6OptsMap1.containsKey(s)) {
                ph6OptsMap2.put(s, ph6OptsMap1.get(s));
                ph6OptsMap1.remove(s);
            }
        }
    }

    public void addAllPh6s2() {
        addPh6s(ph6list);
    }

    public void addPh6s2() {
        addPh6s(ph6s1);
    }

    public void removePh6s(String[] ph6s) {
        for (String s : ph6s) {
            if (ph6OptsMap2.containsKey(s)) {
                ph6OptsMap1.put(s, ph6OptsMap2.get(s));
                ph6OptsMap2.remove(s);
            }
        }
    }

    public void removeAllPh6s2() {
        removePh6s(ph6list);
    }

    public void removePh6s2() {
        removePh6s(ph6s2);
    }

    public void getSelectedPh6s() {
        selectedPh6s = new Set<String>();
        List<SelectOption> sos = getPh6Opts2();
        String s;
        for (SelectOption so : sos) {
            s = so.getValue();
            s = s.replaceAll(NBSP, SPACE);
            selectedPh6s.add(s);
        }
    }


// --------------------------------- Product SubSegments (PH7) -----------------------------

    Map<String, SelectOption> ph7OptsMap1;
    Map<String, SelectOption> ph7OptsMap2;
    public List<String> ph7list = new List<String>();
    public Set<String> selectedPh7s;
    public String[] ph7s1 = new String[]{},
                    ph7s2 = new String[]{};

    public void getProductSubSegments() {
        if (!validate1()) {return;}
        ph7OptsMap1 = new Map<String, SelectOption>();
        ph7OptsMap2 = new Map<String, SelectOption>();
        ph7list = new List<String>();
        getSelectedPh6s();
        Set<String> ss = PricingConditionUpdateFunctions.getProductSubSegments(dchanCode,
                                                                               effectFromDate,
                                                                               selectedSalesOrgCodes,
                                                                               selectedSalesDistricts,
                                                                               selectedSalesOffices,
                                                                               selectedSalesGroups,
                                                                               selectedAccountIds,
                                                                               selectedPh5s,
                                                                               selectedPh6s);
        Integer i = 0; SelectOption so;
        for (String s : ss) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            s = s.replaceAll(SPACE, NBSP);
            so = new SelectOption(s, s);
            so.setEscapeItem(false);
            ph7OptsMap1.put(s, so);
            ph7list.add(s);
        }
        if (ph7list.size() == 1) {addAllPh7s2();}
        else {ph7list.sort();}
        activeTab = TAB_PH7;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Product_SubSegments__c);
        removeAllPh7s2(); addPh7s(slist);
    }

    public List<SelectOption> getPh7Opts1() {return getPh7Opts(ph7OptsMap1);}
    public List<SelectOption> getPh7Opts2() {return getPh7Opts(ph7OptsMap2);}

    private List<SelectOption> getPh7Opts(Map<String, SelectOption> ph7OptsMap) {
        List<SelectOption> ph7Opts = new List<SelectOption>();
        Integer i = 0;
        for (String s : ph7list) {
            if (ph7OptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                ph7Opts.add(ph7OptsMap.get(s));
            }
        }
        return ph7Opts;
    }

    public String[] getPh7s1() {return ph7s1;}

    public void setPh7s1(String[] ph7s) {
        ph7s1 = ph7s;
    }

    public String[] getPh7s2() {return ph7s2;}

    public void setPh7s2(String[] ph7s) {
        ph7s2 = ph7s;
    }

    private void addPh7s(String[] ph7s) {
        for (String s : ph7s) {
            if (ph7OptsMap1.containsKey(s)) {
                ph7OptsMap2.put(s, ph7OptsMap1.get(s));
                ph7OptsMap1.remove(s);
            }
        }
    }

    public void addAllPh7s2() {
        addPh7s(ph7list);
    }

    public void addPh7s2() {
        addPh7s(ph7s1);
    }

    private void removePh7s(String[] ph7s) {
        for (String s : ph7s) {
            if (ph7OptsMap2.containsKey(s)) {
                ph7OptsMap1.put(s, ph7OptsMap2.get(s));
                ph7OptsMap2.remove(s);
            }
        }
    }

    public void removeAllPh7s2() {
        removePh7s(ph7list);
    }

    public void removePh7s2() {
        removePh7s(ph7s2);
    }

    public void getSelectedPh7s() {
        selectedPh7s = new Set<String>();
        List<SelectOption> sos = getPh7Opts2();
        String s;
        for (SelectOption so : sos) {
            s = so.getValue();
            s = s.replaceAll(NBSP, SPACE);
            selectedPh7s.add(s);
        }
    }

// --------------------------------- BaseCodes -----------------------------

    Map<String, SelectOption> bcdOptsMap1;
    Map<String, SelectOption> bcdOptsMap2;
    public List<String> baseCodes = new List<String>();
    public Set<String> selectedBaseCodes;
    public String[] baseCodes1 = new String[]{},
                    baseCodes2 = new String[]{};

    public void getBaseCodes() {
        if (!validate1()) {return;}
        bcdOptsMap1 = new Map<String, SelectOption>();
        bcdOptsMap2 = new Map<String, SelectOption>();
        baseCodes = new List<String>();
        getSelectedPh7s();
        Set<String> ss = PricingConditionUpdateFunctions.getBaseCodes(dchanCode,
                                                                      effectFromDate,
                                                                      selectedSalesOrgCodes,
                                                                      selectedSalesDistricts,
                                                                      selectedSalesOffices,
                                                                      selectedSalesGroups,
                                                                      selectedAccountIds,
                                                                      selectedPh5s,
                                                                      selectedPh6s,
                                                                      selectedPh7s);
        Integer i = 0; SelectOption so;
        for (String s : ss) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            s = s.replaceAll(SPACE, NBSP);
            so = new SelectOption(s, s);
            so.setEscapeItem(false);
            bcdOptsMap1.put(s, so);
            baseCodes.add(s);
        }
        if (baseCodes.size() == 1) {addAllBaseCodes2();}
        else {baseCodes.sort();}
        activeTab = TAB_BCD;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Product_BaseCodes__c);
        removeAllBaseCodes2(); addBaseCodes(slist);
    }

    public List<SelectOption> getBcdOpts1() {return getBcdOpts(bcdOptsMap1);}
    public List<SelectOption> getBcdOpts2() {return getBcdOpts(bcdOptsMap2);}

    private List<SelectOption> getBcdOpts(Map<String, SelectOption> bcdOptsMap) {
        List<SelectOption> bcdOpts = new List<SelectOption>();
        Integer i = 0;
        for (String s : baseCodes) {
            if (bcdOptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                bcdOpts.add(bcdOptsMap.get(s));
            }
        }
        return bcdOpts;
    }

    public String[] getBaseCodes1() {return baseCodes1;}

    public void setBaseCodes1(String[] bcds) {
        baseCodes1 = bcds;
    }

    public String[] getBaseCodes2() {return baseCodes2;}

    public void setBaseCodes2(String[] bcds) {
        baseCodes2 = bcds;
    }

    private void addBaseCodes(String[] bcds) {
        for (String s : bcds) {
            if (bcdOptsMap1.containsKey(s)) {
                bcdOptsMap2.put(s, bcdOptsMap1.get(s));
                bcdOptsMap1.remove(s);
            }
        }
    }

    public void addAllBaseCodes2() {
        addBaseCodes(baseCodes);
    }

    public void addBaseCodes2() {
        addBaseCodes(baseCodes1);
    }

    private void removeBaseCodes(String[] bcds) {
        for (String s : bcds) {
            if (bcdOptsMap2.containsKey(s)) {
                bcdOptsMap1.put(s, bcdOptsMap2.get(s));
                bcdOptsMap2.remove(s);
            }
        }
    }

    public void removeAllBaseCodes2() {
        removeBaseCodes(baseCodes);
    }

    public void removeBaseCodes2() {
        removeBaseCodes(baseCodes2);
    }

    public void getSelectedBaseCodes() {
        selectedBaseCodes = new Set<String>();
        List<SelectOption> sos = getBcdOpts2();
        String s;
        for (SelectOption so : sos) {
            s = so.getValue();
            s = s.replaceAll(NBSP, SPACE);
            selectedBaseCodes.add(s);
        }
    }

// --------------------------------- Materials -----------------------------

    Map<String, SelectOption> matOptsMap1;
    Map<String, SelectOption> matOptsMap2;
    public List<String> materialIds = new List<String>();
    public Set<String> selectedMaterialIds;
    public String[] materialIds1 = new String[]{},
                    materialIds2 = new String[]{};

    public void getMaterials() {
        if (!validate1()) {return;}
        matOptsMap1 = new Map<String, SelectOption>();
        matOptsMap2 = new Map<String, SelectOption>();
        materialIds = new List<String>();
        getSelectedBaseCodes();
        List<Material_Sales_Data2__c> materials;
        materials = PricingConditionUpdateFunctions.getMaterials(dchanCode,
                                                                 effectFromDate,
                                                                 selectedSalesOrgCodes,
                                                                 selectedSalesDistricts,
                                                                 selectedSalesOffices,
                                                                 selectedSalesGroups,
                                                                 selectedAccountIds,
                                                                 selectedPh5s,
                                                                 selectedPh6s,
                                                                 selectedPh7s,
                                                                 selectedBaseCodes);
        String v, l, matnum; Integer i = 0; SelectOption so;
        for (Material_Sales_Data2__c m : materials) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            l = m.Name;
            l = l.replaceAll(SPACE, NBSP);
            //v = l+DELIM3+m.Id;
            v = m.Id;
            so = new SelectOption(v, l);
            so.setEscapeItem(false);
            matOptsMap1.put(v, so);
            materialIds.add(v);
        }
        if (materialIds.size() == 1) {addAllMaterialIds2();}
        //else {materialIds.sort();}
        activeTab = TAB_MAT;
        if (pcsc == null) {return;}
        List<String> slist = getSrchFldList(pcsc.Material_Ids__c);
        removeAllMaterialIds2(); addMaterialIds(slist);
    }

    public List<SelectOption> getMatOpts1() {return getMatOpts(matOptsMap1);}
    public List<SelectOption> getMatOpts2() {return getMatOpts(matOptsMap2);}

    private List<SelectOption> getMatOpts(Map<String, SelectOption> matOptsMap) {
        List<SelectOption> matOpts = new List<SelectOption>();
        Integer i = 0;
        for (String s : materialIds) {
            if (matOptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                matOpts.add(matOptsMap.get(s));
            }
        }
        return matOpts;
    }

    public String[] getMaterialIds1() {return materialIds1;}

    public void setMaterialIds1(String[] matIds) {
        materialIds1 = matIds;
    }

    public String[] getMaterialIds2() {return materialIds2;}

    public void setMaterialIds2(String[] matIds) {
        materialIds2 = matIds;
    }

    private void addMaterialIds(String[] matIds) {
        for (String s : matIds) {
            if (matOptsMap1.containsKey(s)) {
                matOptsMap2.put(s, matOptsMap1.get(s));
                matOptsMap1.remove(s);
            }
        }
    }

    public void addAllMaterialIds2() {
        addMaterialIds(materialIds);
    }

    public void addMaterialIds2() {
        addMaterialIds(materialIds1);
    }

    private void removeMaterialIds(String[] matIds) {
        for (String s : matIds) {
            if (matOptsMap2.containsKey(s)) {
                matOptsMap1.put(s, matOptsMap2.get(s));
                matOptsMap2.remove(s);
            }
        }
    }

    public void removeAllMaterialIds2() {
        removeMaterialIds(materialIds);
    }

    public void removeMaterialIds2() {
        removeMaterialIds(materialIds2);
    }

    public void getSelectedMaterialIds() {
        selectedMaterialIds = new Set<String>();
        List<SelectOption> sos = getMatOpts2();
        String v; String[] sa;
        for (SelectOption so : sos) {
            v = so.getValue();
            v = v.replaceAll(NBSP, SPACE);
            //sa = v.split(DELIM3);
            //if(sa.size() > 1){selectedMaterialIds.add(sa[1]);}
            selectedMaterialIds.add(v);
        }
    }

// ----------------------------------------------------------------------------------------

    private List<String> getSrchFldList(String s) {
        List<String> alist = new List<String>(), blist;
        if (String.isBlank(s)) {return alist;}
        blist = s.split(PricingConditionUpdateFunctions.DELIM1);
        for (String b : blist) {alist.add(b.replaceAll(SPACE, NBSP));}
        return alist;
    }

    private Set<String> getSrchFldSet(String s) {
        Set<String> aset = new Set<String>();
        if (String.isBlank(s)) {return aset;}
        List<String> blist = s.split(PricingConditionUpdateFunctions.DELIM1);
        for (String b : blist) {aset.add(b);}
        return aset;
    }

    public void getSavedSearchFlds() {
        if (String.isBlank(searchName)) {return;}
        String userId = UserInfo.getUserId();
        pcsc = PricingConditionUpdateFunctions.getSearchCriteria(userId, searchName);
        if (pcsc == null) {return;}
        dchanCode = pcsc.Distribution_Channel__c;
        selectedSalesOrgCodes  = getSrchFldSet(pcsc.Sales_Orgs__c);
        selectedSalesDistricts = getSrchFldSet(pcsc.Sales_Districts__c);
        selectedSalesOffices   = getSrchFldSet(pcsc.Sales_Offices__c);
        selectedSalesGroups    = getSrchFldSet(pcsc.Sales_Groups__c);
        selectedAccountIds     = getSrchFldSet(pcsc.Account_Ids__c);
        selectedPh5s           = getSrchFldSet(pcsc.Product_Families__c);
        selectedPh6s           = getSrchFldSet(pcsc.Product_Segments__c);
        selectedPh7s           = getSrchFldSet(pcsc.Product_SubSegments__c);
        selectedBaseCodes      = getSrchFldSet(pcsc.Product_BaseCodes__c);
        selectedMaterialIds    = getSrchFldSet(pcsc.Material_Ids__c);
    }

    public void saveSearchCriteria() {
        if (String.isBlank(searchName) && String.isBlank(newSearch)) {
            addErrMsg('Enter a new Search Name or Select an existing Search to update');
            return;
        }
        if (!String.isBlank(newSearch)) {searchName = newSearch;}
        String userId = UserInfo.getUserId();
        String key = PricingConditionUpdateFunctions.saveSearchCriteria(userId, searchName, dchanCode,
                                       selectedSalesOrgCodes,
                                       selectedSalesDistricts,
                                       selectedSalesOffices,
                                       selectedSalesGroups,
                                       selectedAccountIds,
                                       selectedPh5s,
                                       selectedPh6s,
                                       selectedPh7s,
                                       selectedBasecodes,
                                       selectedMaterialIds);
        if (key == null) {
            addErrMsg('Failed to Save the Search Criteria');
        } else {
            initSearchNames();
            addInfoMsg('Saved the Search Criteria as : ' + searchName);
        }
    }

// ----------------------------------------------------------------------------------------

    public void getPricingConditions1() {
        if (!validate1()) {return;}
        setStandardSetController();
    }

    public void getPricingConditions2() {
        if (!validate1()) {return;}
        getSelectedMaterialIds();
        setStandardSetController();
    }

    private void setStandardSetController() {
        if (!validate1()) {return;}
        Database.Querylocator ql = PricingConditionUpdateFunctions.getQueryLocator(
                                       dchanCode,
                                       effectFromDate,
                                       effectToDate,
                                       selectedSalesOrgCodes,
                                       selectedSalesDistricts,
                                       selectedSalesOffices,
                                       selectedSalesGroups,
                                       selectedAccountIds,
                                       selectedPh5s,
                                       selectedPh6s,
                                       selectedPh7s,
                                       selectedBasecodes,
                                       selectedMaterialIds);
        pc1 = new PaginationController(ql, pageSize1); setPclist();
    }

    public void pc1Size() {setPclist(null);}
    public void pc1Frst() {setPclist(PaginationController.Page.FIRST);}
    public void pc1Prev() {setPclist(PaginationController.Page.PREV);}
    public void pc1Next() {setPclist(PaginationController.Page.NEXT);}
    public void pc1Last() {setPclist(PaginationController.Page.LAST);}

    private void setPclist() {setPclist(null);}

    private void setPclist(PaginationController.Page p) {
        List<Pricing_Condition__c> pcs = null; pclist = new List<Pricing_Condition>();
        Integer n = 0; pageBlockNumber = 1;
        if (pc1 != null) {
            pc1.gotoPage(p); n = pc1.recordFrom;
            pcs = pc1.getRecords().deepClone(true, true, true);
            if (pc1.resultSize > 0) {pageBlockNumber = 2;}
        }
        if (pcs == null || pcs.isEmpty()) {return;}
        priceIncreaseAmount = PricingConditionFunctions.getRoundedValue(priceIncreaseAmount, 4);
        priceIncreasePercnt = PricingConditionFunctions.getRoundedValue(priceIncreasePercnt, 2);
        pclist = PricingConditionUpdateFunctions.getPricingConditions(pcs, n,
                            effectToDate, priceIncreaseAmount, priceIncreasePercnt);
        pcs = null;
    }

    public PageReference gotoPageBlock1() {
        pageBlockNumber = 1;
        activeTab = TAB_DCHAN;
        disableUpdateBtn = false;
        return null;
    }
/*
    public void cloneAndSubmitForApproval() {
        if (pc1 == null) {return;}
        List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>)pc1.getRecords();
        PricingConditionUpdateFunctions.cloneAndSubmitForApproval(
            pcs, priceIncreaseAmount, priceIncreasePercnt, effectFromDate, effectToDate, submitForApproval);
        pageBlockNumber = 3;
    }
*/
    public PageReference submitBatchJob() {
        PricingConditionUpdateBatchable b = new PricingConditionUpdateBatchable();
        b.accountIds = selectedAccountIds;
        b.basecodes = selectedBasecodes;
        b.dchanCode = dchanCode;
        b.effectFromDate = effectFromDate;
        b.effectToDate = effectToDate;
        b.materialIds = selectedMaterialIds;
        b.ph5Descs = selectedPh5s;
        b.ph6Descs = selectedPh6s;
        b.ph7Descs = selectedPh7s;
        b.priceIncreaseAmount = priceIncreaseAmount;
        b.priceIncreasePercnt = priceIncreasePercnt;
        b.salesDsts = selectedSalesDistricts;
        b.salesGrps = selectedSalesGroups;
        b.salesOfcs = selectedSalesOffices;
        b.sorgCodes = selectedSalesOrgCodes;
        b.submitForApproval = submitForApproval;
        ApexPages.Message msg; String jobId;
        try {
            jobId = Database.executeBatch(b, BATCH_SIZE);
            msg = new ApexPages.Message(
                    ApexPages.Severity.INFO,
                    'Your request is in progress. You will be notified by email when it completes.');
        } catch(Exception e) {
            msg = new ApexPages.Message(
                      ApexPages.Severity.ERROR, e.getMessage());
            debug(e.getMessage());
        }
        ApexPages.addMessage(msg);
        //pageBlockNumber = 3;
        setStandardSetController();
        disableUpdateBtn = true;
        return null;
    }

    private void addLimitExceedsMsg() {
        ApexPages.Message msg;
        msg = new ApexPages.Message(
                  ApexPages.Severity.WARNING,
                 'Search results exceeded maximum limit of 1000. Narrow your search criteria and try again.');
        ApexPages.addMessage(msg);
    }

}