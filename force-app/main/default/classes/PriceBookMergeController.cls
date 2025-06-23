public with sharing class PriceBookMergeController {

    private static final Integer PAGE_SIZE = 100;
    private static final Integer BATCH_SIZE = 10;
    private static final Integer SOPTS_SIZE = 1000;
    private static final String DCHAN_AHWT = '10';
    private static final String DIVSN_AHWT = '11';
    private static final String PBSTAT_ACTIVE = PriceBookMergeFunctions.PBSTAT_ACTIVE;
    private static final String PBSTAT_DRAFT = PriceBookMergeFunctions.PBSTAT_DRAFT;
    
    private static final String SPACE = ' ';
    private static final String NBSP = '&nbsp;';
    private static final String TAB_CGRP = 'tabCGrp';
    private static final String TAB_DCHAN = 'tabDChan';
    private static final String TAB_PH5 = 'tabPH5';
    private static final String TAB_PH6 = 'tabPH6';
    private static final String TAB_REGN = 'tabRegn';
    private static final String TAB_SORG = 'tabSOrg';
    
    public String activeTab               {get; set;}

    public Integer resultSize             {get; set;}
    public Integer lastPageNumber         {get; set;}
    public Integer pageBlockNumber        {get; set;}
    public Integer pageNumber;
    public Integer recordFrom             {get; set;}
    public Integer recordTo               {get; set;}
    
    public Boolean allowedToMergePBs      {get; set;}
    public Boolean allSelected            {get; set;}
    public Boolean disableUpdateBtn       {get; set;}
    public Boolean showPBSelectBtn        {get; set;}
    public Boolean showPBSelectCBs        {get; set;}
    public Boolean showPBMergeBtn         {get; set;}
    public Boolean submitForApproval      {get; set;}
    public String userLocale              {get; set;} 

    public String distChanCode {get; set;}
    public String divisionCode {get; set;}
    public List<String> pbStats {get; set;}
    
    Set<String> pbIds1, pbIds2, pbIds3, pbIds4, pbIds5, pbIds6;
    public List<Product_Hierarchy__c> productLines {get; private set;} 
    public List<Product_Hierarchy__c> productFamilies {get; private set;}
    public List<SAP_Country_Name__c> regions {get; private set;}
    public List<SAP_Customer_Group__c> customerGroups {get; private set;}
    
    Map<String, Set<String>> somap, plmap, pfmap, srmap, cgmap;
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    public PriceBookMergeController(ApexPages.StandardController c) {
        allowedToMergePBs = Pricing_Security__c.getInstance().Allowed_to_Merge_PriceBooks__c;
        init();
    }
    
    public void init() {
        activeTab = TAB_DCHAN;
        distChanCode = DCHAN_AHWT;
        divisionCode = DIVSN_AHWT;
        pageBlockNumber = 1;
        userLocale = UserInfo.getLocale();
        submitForApproval = false;
        disableUpdateBtn = false;
        showPBSelectBtn = false;
        showPBSelectCBs = false;
        showPBMergeBtn = false;
        pbStats = new List<String>{PBSTAT_ACTIVE, PBSTAT_DRAFT};
    }
    
    public PageReference gotoPageBlock1() {
        init();
        return null;
    }

    private void addLimitExceedsMsg() {
        ApexPages.Message msg;
        msg = new ApexPages.Message(
                  ApexPages.Severity.WARNING, 
                 'Search results exceeded maximum limit of 1000. Narrow your search criteria and try again.');
        ApexPages.addMessage(msg);
    }
    
    private void addPBStatReqdMsg() {
        ApexPages.Message msg;
        msg = new ApexPages.Message(
                  ApexPages.Severity.ERROR, 
                 'Select at least one PriceBook Status.');
        ApexPages.addMessage(msg);
    }
    
    private void addPBMergeFailureMsg() {
        ApexPages.Message msg;
        msg = new ApexPages.Message(
                  ApexPages.Severity.ERROR, 
                 'Failed to merge the PriceBooks.');
        ApexPages.addMessage(msg);
    }
    
    private Boolean validate1() {
        debug('pbStats : ' + pbStats);
        Boolean b = true;
        if (pbStats.size() < 1) {addPBStatReqdMsg();}
        b = b && pbStats.size() > 0;
        return b;
    }
    
    
// --------------------------------- Sales Orgs ----------------------------- 
    
    Map<String, SelectOption> sorgOptsMap1;
    Map<String, SelectOption> sorgOptsMap2;
    public List<String> salesOrgCodes = new List<String>();
    public Set<String> selectedSalesOrgCodes = new Set<String>();
    public String[] salesOrgs1 = new String[]{},
                    salesOrgs2 = new String[]{};
    
    public void getSapSalesOrgs() {
        if (!validate1()) {return;}
        sorgOptsMap1 = new Map<String, SelectOption>();
        sorgOptsMap2 = new Map<String, SelectOption>();
        salesOrgCodes = new List<String>();
        List<SAP_Sales_Org__c> sapSalesOrgs;
        pbIds1 = PriceBookMergeFunctions.getPriceBookIds(distChanCode, divisionCode, pbStats);
        somap = PriceBookSalesOrgFunctions.getPriceBookSalesOrgCodeMap(pbIds1);
        sapSalesOrgs = PriceBookMergeFunctions.getSapSalesOrgs(somap);
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
    
// --------------------------------- Product Lines (PH6) ----------------------------- 

    Map<String, SelectOption> ph6OptsMap1;
    Map<String, SelectOption> ph6OptsMap2;
    Map<String, String> ph6vnMap;
    List<String> ph6ns = new List<String>(), ph6vs = new List<String>();
    public Set<String> selectedPh6s = new Set<String>();
    public String[] ph6s1 = new String[]{},
                    ph6s2 = new String[]{};
    
    public void getProductLines() {
        if (!validate1()) {return;}
        ph6OptsMap1 = new Map<String, SelectOption>();
        ph6OptsMap2 = new Map<String, SelectOption>();
        ph6vnMap = new Map<String, String>();
        ph6ns = new List<String>(); ph6vs = new List<String>();
        if (sorgOptsMap2 != null && !sorgOptsMap2.isEmpty()) {getSelectedSalesOrgCodes();}
        pbIds2 = PriceBookMergeFunctions.getPriceBookIds(somap, selectedSalesOrgCodes);
        plmap = PriceBookProductLineFunctions.getPriceBookProductLineCodeMap(pbIds2);
        productLines = PriceBookMergeFunctions.getProductLines(plmap, distChanCode);
        Integer i = 0; SelectOption so; String n, v;
        for (Product_Hierarchy__c ph : productLines) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            v = ph.Product_Hierarchy_Code__c;
            n = ph.Product_Hierarchy_Description__c;
            n = n.replaceAll(SPACE, NBSP);
            so = new SelectOption(v, n);
            so.setEscapeItem(false);
            ph6OptsMap1.put(n, so);
            ph6vnMap.put(v, n);
            ph6ns.add(n); ph6vs.add(v);
        }
        if (ph6ns.size() == 1) {addAllPh6s2();}           
        else {ph6ns.sort();}
        activeTab = TAB_PH6;
    } 

    public List<SelectOption> getPh6Opts1() {return getPh6Opts(ph6OptsMap1);}
    public List<SelectOption> getPh6Opts2() {return getPh6Opts(ph6OptsMap2);}
    
    private List<SelectOption> getPh6Opts(Map<String, SelectOption> ph6OptsMap) {
        List<SelectOption> ph6Opts = new List<SelectOption>();
        Integer i = 0;
        for (String n : ph6ns) {
            if (ph6OptsMap.containsKey(n)) {
                if (++i > SOPTS_SIZE) {break;}
                ph6Opts.add(ph6OptsMap.get(n));
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
        String n;
        for (String v : ph6s) {
            n = ph6vnMap.get(v);
            if (ph6OptsMap1.containsKey(n)) {
                ph6OptsMap2.put(n, ph6OptsMap1.get(n));
                ph6OptsMap1.remove(n);
            }
        }
    } 
    
    public void addAllPh6s2() {
        addPh6s(ph6vs);
    } 
    
    public void addPh6s2() {
        addPh6s(ph6s1);
    } 
    
    public void removePh6s(String[] ph6s) {
        String n;
        for (String v : ph6s) {
            n = ph6vnMap.get(v);
            if (ph6OptsMap2.containsKey(n)) {
                ph6OptsMap1.put(n, ph6OptsMap2.get(n));
                ph6OptsMap2.remove(n);
            }
        }
    } 
    
    public void removeAllPh6s2() {
        removePh6s(ph6vs);
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
    
// --------------------------------- Product Families (PH5) ----------------------------- 

    Map<String, SelectOption> ph5OptsMap1;
    Map<String, SelectOption> ph5OptsMap2;
    Map<String, String> ph5vnMap;
    List<String> ph5ns = new List<String>(), ph5vs = new List<String>();
    public Set<String> selectedPh5s = new Set<String>();
    public String[] ph5s1 = new String[]{},
                    ph5s2 = new String[]{};
    
    public void getProductFamilies() {
        if (!validate1()) {return;}
        ph5OptsMap1 = new Map<String, SelectOption>();
        ph5OptsMap2 = new Map<String, SelectOption>();
        ph5vnMap = new Map<String, String>();
        ph5ns = new List<String>(); ph5vs = new List<String>();
        if (ph6OptsMap2 != null && !ph6OptsMap2.isEmpty()) {getSelectedPh6s();}
        pbIds3 = PriceBookMergeFunctions.getPriceBookIds(plmap, selectedPh6s);
        pfmap = PriceBookFamilyFunctions.getPriceBookFamilyCodeMap(pbIds3);
        productFamilies = PriceBookMergeFunctions.getProductFamilies(pfmap, distChanCode, selectedPh6s);
        Integer i = 0; SelectOption so; String n, v;
        for (Product_Hierarchy__c ph : productFamilies) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            v = ph.Product_Hierarchy_Code__c;
            n = ph.Product_Hierarchy_Description__c;
            n = n.replaceAll(SPACE, NBSP);
            so = new SelectOption(v, n);
            so.setEscapeItem(false);
            ph5OptsMap1.put(n, so);
            ph5vnMap.put(v, n);
            ph5ns.add(n); ph5vs.add(v);
        }
        if (ph5ns.size() == 1) {addAllPh5s2();}           
        else {ph5ns.sort();}
        activeTab = TAB_PH5;
    } 

    public List<SelectOption> getPh5Opts1() {return getPh5Opts(ph5OptsMap1);}
    public List<SelectOption> getPh5Opts2() {return getPh5Opts(ph5OptsMap2);}
    
    private List<SelectOption> getPh5Opts(Map<String, SelectOption> ph5OptsMap) {
        List<SelectOption> ph5Opts = new List<SelectOption>();
        Integer i = 0;
        for (String s : ph5ns) {
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
        String n;
        for (String v : ph5s) {
            n = ph5vnMap.get(v);
            if (ph5OptsMap1.containsKey(n)) {
                ph5OptsMap2.put(n, ph5OptsMap1.get(n));
                ph5OptsMap1.remove(n);
            }
        }
    } 
    
    public void addAllPh5s2() {
        addPh5s(ph5vs);
    } 
    
    public void addPh5s2() {
        addPh5s(ph5s1);
    } 
    
    private void removePh5s(String[] ph5s) {
        String n;
        for (String v : ph5s) {
            n = ph5vnMap.get(v);
            if (ph5OptsMap2.containsKey(n)) {
                ph5OptsMap1.put(n, ph5OptsMap2.get(n));
                ph5OptsMap2.remove(n);
            }
        }
    } 
    
    public void removeAllPh5s2() {
        removePh5s(ph5vs);
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
    
// --------------------------------- Regions ----------------------------- 

    Map<String, SelectOption> regionOptsMap1;
    Map<String, SelectOption> regionOptsMap2;
    Map<String, String> regionvnMap;
    List<String> regionns = new List<String>(), regionvs = new List<String>();
    public Set<String> selectedRegions = new Set<String>();
    public String[] regions1 = new String[]{},
                    regions2 = new String[]{};
    
    public void getRegions() {
        if (!validate1()) {return;}
        regionOptsMap1 = new Map<String, SelectOption>();
        regionOptsMap2 = new Map<String, SelectOption>();
        regionvnMap = new Map<String, String>();
        regionns = new List<String>(); regionvs = new List<String>();
        if (ph5OptsMap2 != null && !ph5OptsMap2.isEmpty()) {getSelectedPh5s();}
        pbIds4 = PriceBookMergeFunctions.getPriceBookIds(pfmap, selectedPh5s);
        srmap = PriceBookRegionFunctions.getPriceBookRegionCodeMap(pbIds4);
        regions = PriceBookMergeFunctions.getRegions(srmap);
        Integer i = 0; SelectOption so; String n, v;
        for (SAP_Country_Name__c r : regions) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            v = r.Country_Code__c;
            n = r.Country_Name__c;
            n = n.replaceAll(SPACE, NBSP);
            so = new SelectOption(v, n);
            so.setEscapeItem(false);
            regionOptsMap1.put(n, so);
            regionvnMap.put(v, n);
            regionns.add(n); regionvs.add(v);
        }
        if (regionns.size() == 1) {addAllRegions2();}           
        else {regionns.sort();}
        activeTab = TAB_REGN;
    } 

    public List<SelectOption> getRegionOpts1() {return getRegionOpts(regionOptsMap1);}
    public List<SelectOption> getRegionOpts2() {return getRegionOpts(regionOptsMap2);}
    
    private List<SelectOption> getRegionOpts(Map<String, SelectOption> regionOptsMap) {
        List<SelectOption> regionOpts = new List<SelectOption>();
        Integer i = 0;
        for (String s : regionns) {
            if (regionOptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                regionOpts.add(regionOptsMap.get(s));
            }
        }
        return regionOpts;
    }
    
    public String[] getRegions1() {return regions1;}
    
    public void setRegions1(String[] regions) {
        regions1 = regions;
    }
    
    public String[] getRegions2() {return regions2;}
    
    public void setRegions2(String[] regions) {
        regions2 = regions;
    }
    
    private void addRegions(String[] regions) {
        String n;
        for (String v : regions) {
            n = regionvnMap.get(v);
            if (regionOptsMap1.containsKey(n)) {
                regionOptsMap2.put(n, regionOptsMap1.get(n));
                regionOptsMap1.remove(n);
            }
        }
    } 
    
    public void addAllRegions2() {
        addRegions(regionvs);
    } 
    
    public void addRegions2() {
        addRegions(regions1);
    } 
    
    private void removeRegions(String[] regions) {
        String n;
        for (String v : regions) {
            n = regionvnMap.get(v);
            if (regionOptsMap2.containsKey(n)) {
                regionOptsMap1.put(n, regionOptsMap2.get(n));
                regionOptsMap2.remove(n);
            }
        }
    } 
    
    public void removeAllRegions2() {
        removeRegions(regionvs);
    } 
    
    public void removeRegions2() {
        removeRegions(regions2);
    }
    
    public void getSelectedRegions() {
        selectedRegions = new Set<String>();
        List<SelectOption> sos = getRegionOpts2();
        String s;
        for (SelectOption so : sos) {
            s = so.getValue();
            s = s.replaceAll(NBSP, SPACE);
            selectedRegions.add(s);
        }
    }
    
// --------------------------------- Customer Groups ----------------------------- 

    Map<String, SelectOption> custGrpOptsMap1;
    Map<String, SelectOption> custGrpOptsMap2;
    Map<String, String> custGrpvnMap;
    List<String> custGrpns = new List<String>(), custGrpvs = new List<String>();
    public Set<String> selectedCustGrps = new Set<String>();
    public String[] custGrps1 = new String[]{},
                    custGrps2 = new String[]{};
    
    public void getCustomerGroups() {
        if (!validate1()) {return;}
        custGrpOptsMap1 = new Map<String, SelectOption>();
        custGrpOptsMap2 = new Map<String, SelectOption>();
        custGrpvnMap = new Map<String, String>();
        custGrpns = new List<String>(); custGrpvs = new List<String>();
        if (regionOptsMap2 != null && !regionOptsMap2.isEmpty()) {getSelectedRegions();}
        pbIds5 = PriceBookMergeFunctions.getPriceBookIds(srmap, selectedRegions);
        cgmap = PriceBookCustGroupFunctions.getPriceBookCustomerGroupCodeMap(pbIds5);
        customerGroups = PriceBookMergeFunctions.getCustomerGroups(cgmap);
        Integer i = 0; SelectOption so; String n, v;
        for (SAP_Customer_Group__c cg : customerGroups) {
            if (++i > SOPTS_SIZE) {addLimitExceedsMsg(); return;}
            v = cg.Customer_Group_Code__c;
            n = cg.Customer_Group_Name__c;
            n = n.replaceAll(SPACE, NBSP);
            so = new SelectOption(v, n);
            so.setEscapeItem(false);
            custGrpOptsMap1.put(n, so);
            custGrpvnMap.put(v, n);
            custGrpns.add(n); custGrpvs.add(v);
        }
        if (custGrpns.size() == 1) {addAllCustGrps2();}           
        else {custGrpns.sort();}
        activeTab = TAB_CGRP;
    } 

    public List<SelectOption> getCustGrpOpts1() {return getCustGrpOpts(custGrpOptsMap1);}
    public List<SelectOption> getCustGrpOpts2() {return getCustGrpOpts(custGrpOptsMap2);}
    
    private List<SelectOption> getCustGrpOpts(Map<String, SelectOption> custGrpOptsMap) {
        List<SelectOption> custGrpOpts = new List<SelectOption>();
        Integer i = 0;
        for (String s : custGrpns) {
            if (custGrpOptsMap.containsKey(s)) {
                if (++i > SOPTS_SIZE) {break;}
                custGrpOpts.add(custGrpOptsMap.get(s));
            }
        }
        return custGrpOpts;
    }
    
    public String[] getCustGrps1() {return custGrps1;}
    
    public void setCustGrps1(String[] custGrps) {
        custGrps1 = custGrps;
    }
    
    public String[] getCustGrps2() {return custGrps2;}
    
    public void setCustGrps2(String[] custGrps) {
        custGrps2 = custGrps;
    }
    
    private void addCustGrps(String[] custGrps) {
        String n;
        for (String v : custGrps) {
            n = custGrpvnMap.get(v);
            if (custGrpOptsMap1.containsKey(n)) {
                custGrpOptsMap2.put(n, custGrpOptsMap1.get(n));
                custGrpOptsMap1.remove(n);
            }
        }
    } 
    
    public void addAllCustGrps2() {
        addCustGrps(custGrpvs);
    } 
    
    public void addCustGrps2() {
        addCustGrps(custGrps1);
    } 
    
    private void removeCustGrps(String[] custGrps) {
        String n;
        for (String v : custGrps) {
            n = custGrpvnMap.get(v);
            if (custGrpOptsMap2.containsKey(n)) {
                custGrpOptsMap1.put(n, custGrpOptsMap2.get(n));
                custGrpOptsMap2.remove(n);
            }
        }
    } 
    
    public void removeAllCustGrps2() {
        removeCustGrps(custGrpvs);
    } 
    
    public void removeCustGrps2() {
        removeCustGrps(custGrps2);
    }
    
    public void getSelectedCustGrps() {
        selectedCustGrps = new Set<String>();
        List<SelectOption> sos = getCustGrpOpts2();
        String s;
        for (SelectOption so : sos) {
            s = so.getValue();
            s = s.replaceAll(NBSP, SPACE);
            selectedCustGrps.add(s);
        }
    }
    
// --------------------------------- Price Books ----------------------------- 

    private static final String BR = '<br/>';
    private static final String CRNL = '\r\n';

    private static Map<String, List<Price_Book_Customer_Group__c>> pbCustomerGroupMap;
    private static Map<String, List<Price_Book_Family__c>> pbFamilyMap;
    private static Map<String, List<Price_Book_Product_Line__c>> pbProductLineMap;
    private static Map<String, List<Price_Book_Region__c>> pbRegionMap;
    private static Map<String, List<Price_Book_Sales_Org__c>> pbSalesOrgMap;
    
    private static String getFamilyString(String pbid) {
        String s = '';
        if (pbFamilyMap.containsKey(pbid)) {
            List<Price_Book_Family__c> alist = pbFamilyMap.get(pbid);
            s = PriceBookFamilyFunctions.getFamilyString(alist, BR);
        }
        return s;
    }
    
    private static String getProductLineString(String pbid) {
        String s = '';
        if (pbProductLineMap.containsKey(pbid)) {
            List<Price_Book_Product_Line__c> alist = pbProductLineMap.get(pbid);
            s = PriceBookProductLineFunctions.getProductLineString(alist, BR);
        }
        return s;
    }
    
    private static String getRegionString(String pbid) {
        String s = '';
        if (pbRegionMap.containsKey(pbid)) {
            List<Price_Book_Region__c> alist = pbRegionMap.get(pbid);
            s = PriceBookRegionFunctions.getRegionString(alist, BR);
        }
        return s;
    }
    
    private static String getSalesOrgString(String pbid) {
        String s = '';
        if (pbSalesOrgMap.containsKey(pbid)) {
            List<Price_Book_Sales_Org__c> alist = pbSalesOrgMap.get(pbid);
            s = PriceBookSalesOrgFunctions.getSalesOrgString(alist, BR);
        }
        return s;
    }
    
    private static String getCustomerGroupString(String pbid) {
        String s = '';
        if (pbCustomerGroupMap.containsKey(pbid)) {
            List<Price_Book_Customer_Group__c> alist = pbCustomerGroupMap.get(pbid);
            s = PriceBookCustGroupFunctions.getCustomerGroupString(alist, BR);
        }
        return s;
    }

    public class Price_Book {
        public Price_Book__c priceBook {get; set;}
        public Boolean selected        {get; set;}
        public String customerGroups   {get; set;}
        public String families         {get; set;}
        public String productLines     {get; set;}
        public String regions          {get; set;}
        public String salesOrgs        {get; set;}
        public Price_Book(Price_Book__c p) {
            priceBook = p;
            selected = false;
            customerGroups = getCustomerGroupString(priceBook.Id);
            families = getFamilyString(priceBook.Id);
            productLines = getProductLineString(priceBook.Id);
            regions = getRegionString(priceBook.Id);
            salesOrgs = getSalesOrgString(priceBook.Id);
        }
    }   

    public List<Price_Book> pblist {get; set;}
    
    public void getPriceBooks() {
        pblist = new List<Price_Book>();
        pageBlockNumber = 2;
        if (custGrpOptsMap2 != null && !custGrpOptsMap2.isEmpty()) {getSelectedCustGrps();}
        pbIds6 = PriceBookMergeFunctions.getPriceBookIds(cgmap, selectedCustGrps);
        //pbIds6 = new Set<String>{'a42500000008VdP', 'a42500000008Vff'};
        List<Price_Book__c> pbs = PriceBookFunctions.getPriceBooks(pbIds6);
        if (pbs == null || pbs.isEmpty()) {return;}
        pbCustomerGroupMap = PriceBookCustGroupFunctions.getPriceBookCustomerGroupMap(pbids6);
        pbFamilyMap = PriceBookFamilyFunctions.getPriceBookFamilyMap(pbids6);
        pbProductLineMap = PriceBookProductLineFunctions.getPriceBookProductLineMap(pbids6);
        pbRegionMap = PriceBookRegionFunctions.getPriceBookRegionMap(pbids6);
        pbSalesOrgMap = PriceBookSalesOrgFunctions.getPriceBookSalesOrgMap(pbids6);
        for (Price_Book__c pb : pbs) {
            pblist.add(new Price_Book(pb));
        }
        if (!pblist.isEmpty()) {showPBSelectBtn = true; showPBSelectCBs = true;}
    }
    
    public String pbDescription {get; set;}
    
    public void selectPriceBooks() {
        List<Price_Book> alist = new List<Price_Book>();
        for (Price_Book pb : pblist) {if (pb.selected) {alist.add(pb);}}
        if (alist.size() < 2) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Select at least two Price Books to merge'));
            return;
        }
        pblist = alist;
        showPBSelectBtn = false; showPBSelectCBs = false; showPBMergeBtn = allowedToMergePBs;
        pbDescription = pblist[0].priceBook.Description__c;
    }
    
    public PageReference mergePriceBooks() {
        showPBMergeBtn = false;
        List<Price_Book__c> alist = new List<Price_Book__c>();
        for (Price_Book pb : pblist) {alist.add(pb.priceBook);}
        Integer dmlRowsLimit = Limits.getLimitDMLRows();
        Integer n = PriceBookFunctions.getRelatedRecordsCount(alist);
        if (n >= dmlRowsLimit) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Expected number of records to be created (' + n + 
                                ') exceeds the max limit of ' + dmlRowsLimit));
            return null;
        }
        Price_Book__c npb = PriceBookMergeFunctions.mergePriceBooks(alist, pbDescription);
        if (npb == null) {addPBMergeFailureMsg(); return null;}
        PageReference pr = new PageReference('/'+npb.Id);
        pr.setRedirect(true);
        return pr; 
    }
    
}