//Last Modified by Srinivasan Muthu-TechM for CR-Request-0629

public class Pricing_Rebate_Functions {
    
    public static final String APPROVED = 'Approved';
    public static final String DRAFT = 'Draft';
    public static final String EXPIRED = 'Expired';
    public static final String SUBMITTED = 'In Approval Process';
    public static final Set<String> STATUS_SET1 = new Set<String>{SUBMITTED, APPROVED, EXPIRED};
    public static final String COLON = ':';
    public static final String SEMI_COLON = ';';
    public static final String SOLDTO = Account_Partner_Functions.ACC_TYPE_SOLDTO;
    public static final Integer MAX_LIMIT = 10000;
    public static final Integer PAGE_SIZE = 100;
    
    public class Parameter {
        public Id     accId {get; set;}
        public Id     matId {get; set;}
        public Date   fdate {get; set;}
        public Date   tdate {get; set;}
        public String key   {get; set;}

        public Parameter(Id accId, Id matId, Date fdate, Date tdate) {this(accId, matId, fdate, tdate, 'key');}
        public Parameter(Id accId, Id matId, Date fdate, Date tdate, String key) {
            this.accId = accId; this.matId = matId; this.fdate = fdate; this.tdate = tdate; this.key = key;
        }
    }
    
    public static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Pricing_Rebate_Functions : ' + s);
    }

    public static void processBeforeInsert(List<Pricing_Rebate__c> prs) {
        setRebateApprovers(prs);
    }
    
    public static void processBeforeUpdate(List<Pricing_Rebate__c> prs) {
        setRebateApprovers(prs);
        Set<String> clonedFromIds = new Set<String>();
        List<Pricing_Rebate__c> alist = new List<Pricing_Rebate__c>();
        for (Pricing_Rebate__c pr : prs) {
            if (isApproved(pr) && pr.Cloned_from_Pricing_Rebate__c != null) {
                clonedFromIds.add(pr.Cloned_from_Pricing_Rebate__c); alist.add(pr);
            }
        }
        expireClonedFromRebates(alist, clonedFromIds);
    }
    
    public static void processBeforeUpsert(List<Pricing_Rebate_Account__c> alist) {
        for (Pricing_Rebate_Account__c a : alist) {a.Key__c = a.Rebate__c + COLON + a.Account__c;}
    }
    
    public static void processBeforeUpsert(List<Pricing_Rebate_Material__c> alist) {
        for (Pricing_Rebate_Material__c a : alist) {a.Key__c = a.Rebate__c + COLON + a.Material__c;}
    }
    
    private static Map<Id, Account> getAccountMap(Set<Id> accIds) {
        Map<Id, Account> amap = new Map<Id, Account>();
        for (Account a : [select Id, Name, RecordTypeId, 
                                 SAP_Customer_Group__c, SAP_Customer_Group_1__c,
                                 SAP_DistChannel__c,
                                 SAP_SalesDistrict__c, SAP_SalesGroup__c, 
                                 SAP_Sales_Office__c, SAP_Sales_Org__c 
                            from Account where Id in :accIds]) {amap.put(a.Id, a);}
        return amap;
    }
    
    private static void setRebateApprovers(List<Pricing_Rebate__c> prs) {
        List<Pricing_Rebate_Approvers__c> alist = getApproversList();
        Map<Id, String> artmap = Schema_Functions.getRecordTypeIdMap('Account');
        Set<Id> accIds = new Set<Id>(); 
        for (Pricing_Rebate__c pr : prs) {accIds.add(pr.Rebate_Recipient__c);}
        Map<Id, Account> accmap = getAccountMap(accIds);
        Account acc; String art; Pricing_Rebate_Approvers__c pra; SAP_LISD lisd;
        for (Pricing_Rebate__c pr : prs) {
            acc = accmap.get(pr.Rebate_Recipient__c); art = '';
            if (acc == null) {continue;} lisd = getLisd(acc, pr);
            if (artmap.containsKey(acc.RecordTypeId)) {art = artmap.get(acc.RecordTypeId);}
            pra = getRebateApprovers(alist, acc, art, lisd);
            if (pra != null) {
                pr.Rebate_Approvers__c = pra.Id;
                pr.Approver_1__c  = pra.Approver_1__c;
                pr.Approver_2__c  = pra.Approver_2__c;
                pr.Approver_3__c  = pra.Approver_3__c;
                pr.Approver_3a__c = pra.Approver_3a__c != null ? pra.Approver_3a__c : pra.Approver_3__c;
                pr.Approver_3b__c = pra.Approver_3b__c != null ? pra.Approver_3b__c : pra.Approver_3__c;
                pr.Final_Approval_Email__c = pra.Final_Approval_Email__c;
            }
        }
    }
    
    private static SAP_LISD getLisd(Account acc, Pricing_Rebate__c pr) {
        SAP_LISD lisd = new SAP_LISD(acc);
        if (!String.isBlank(pr.Customer_Group__c)) {lisd.custGroupValue = pr.Customer_Group__c;}
        if (!String.isBlank(pr.Sales_District__c)) {lisd.salesDstValue  = pr.Sales_District__c;}
        if (!String.isBlank(pr.Sales_Office__c))   {lisd.salesOfcValue  = pr.Sales_Office__c;}
        if (!String.isBlank(pr.Sales_Group__c))    {lisd.salesGrpValue  = pr.Sales_Group__c;}
        return lisd;
    }
    
    private static List<Pricing_Rebate_Approvers__c> getApproversList() {
        List<Pricing_Rebate_Approvers__c> alist = [
            select Id, Name, Approver_1__c, Approver_2__c, Approver_3__c, 
                   Approver_3a__c, Approver_3b__c,
                   Customer_Group__c, Customer_Group1__c, Final_Approval_Email__c, 
                   Recipient_Record_Type__c, Sales_District__c, Sales_Group__c,
                   Sales_Office__c, Sales_Orgs__c
              from Pricing_Rebate_Approvers__c
          order by Process_Order__c];
        return alist;
    }
    
    private static Pricing_Rebate_Approvers__c getRebateApprovers(List<Pricing_Rebate_Approvers__c> alist, 
                                                                  Account acc, String accRectype,
                                                                  SAP_LISD lisd) {
        Boolean b1, b2, b3, b4, b5, b6, b7; 
        for (Pricing_Rebate_Approvers__c a : alist) {
            b1 = compare(a.Recipient_Record_Type__c, accRectype);
            b2 = compare(a.Sales_District__c,        lisd.salesDstValue);
            b3 = compare(a.Sales_Office__c,          lisd.salesOfcValue);
            b4 = compare(a.Sales_Group__c,           lisd.salesGrpValue);
            b5 = compare(a.Customer_Group__c,        lisd.custGroupValue);
            b6 = compare(a.Customer_Group1__c,       acc.SAP_Customer_Group_1__c);
            b7 = compare2(a.Sales_Orgs__c,           acc.SAP_Sales_Org__c);
            if (b1 && b2 && b3 && b4 && b5 && b6 && b7) {return a;}
        }
        return null;
    }
    
    private static Boolean compare(String s, String t) {
        return (isNull(s) || (!isNull(t) && s.trim().equalsIgnoreCase(t.trim())));
    }
    
    private static Boolean compare2(String s, String t) {
        if (isNull(s)) {return true;}
        List<String> alist = s.split(SEMI_COLON);
        if (alist == null || alist.isEmpty()) {return true;}
        Set<String> aset = new Set<String>();
        for (String a : alist) {aset.add(a.trim());}
        return ((!isNull(t) && aset.contains(t.trim())));
    }
    
    public static Pricing_Rebate_Approvers__c getRebateApprovers(Account acc) {
        return getRebateApprovers(acc, new SAP_LISD(acc));
    }
    
    public static Pricing_Rebate_Approvers__c getRebateApprovers(Account acc, SAP_LISD lisd) {
        List<Pricing_Rebate_Approvers__c> alist = getApproversList();
        Map<Id, String> artmap = Schema_Functions.getRecordTypeIdMap('Account');
        String art = ''; Pricing_Rebate_Approvers__c pra;
        if (artmap.containsKey(acc.RecordTypeId)) {art = artmap.get(acc.RecordTypeId);}
        pra = getRebateApprovers(alist, acc, art, lisd);
        if (pra != null) {
            pra = [select Id, Name, Approver_1__r.Name, 
                          Approver_2__r.Name, Approver_3__r.Name, 
                          Approver_3a__r.Name, Approver_3b__r.Name 
                     from Pricing_Rebate_Approvers__c
                    where Id = :pra.Id];
        } else {
            pra = new Pricing_Rebate_Approvers__c();
        }
        return pra;
    }

    
    // Added for Pricing_Rebate_Batchable class by TechM
    public static void expirePricingRebates(List<Pricing_Rebate__c> prs) { 
        expirePricingRebates(prs, true); 
    } 

    //Line Updated 166 and 169 for the CR-Request-0629 By TechM
    public static void expirePricingRebate(Pricing_Rebate__c pr,boolean rebatenotify) {
        
        List<Pricing_Rebate__c> prs = new List<Pricing_Rebate__c>{pr};
        expirePricingRebates(prs,rebatenotify); 
        
    }
    
    //Line Updated from 174 to 188 for the CR-Request-0629 By TechM
    public static void expirePricingRebates(List<Pricing_Rebate__c> prs,boolean rebatenotify) {
        List<Pricing_Rebate__c> prs2 = new List<Pricing_Rebate__c>();
        Date tdate = Date.today(), edate;
        for (Pricing_Rebate__c pr : prs) {
            edate = pr.Rebate_End_Date__c;
            if (isApproved(pr)) {
                pr.Status__c = EXPIRED;
                
                if(rebatenotify==true){
                    
                    pr.Notify_to_MD__c = true;
                }
                else{
                    pr.Notify_to_MD__c = false;
                }
                
                if (tdate.daysBetween(edate) > 0) {pr.Rebate_End_Date__c = tdate;}
                prs2.add(pr);
                system.debug('prs2'+prs2);
            }
        }
        if (!prs2.isEmpty()) {update prs2;}
    }
    
    public static Boolean isApproved(Pricing_Rebate__c pr) {
        return (pr != null && pr.Status__c != null && pr.Status__c.equals(APPROVED));
    }
    
    public static Boolean isDraft(Pricing_Rebate__c pr) {
        return (pr != null && pr.Status__c != null && pr.Status__c.equals(DRAFT));
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private static void expireClonedFromRebates(List<Pricing_Rebate__c> alist, Set<String> clonedFromIds) {
        if (alist.isEmpty() || clonedFromIds.isEmpty()) {return;}
        Map<String, Pricing_Rebate__c> emap = new Map<String, Pricing_Rebate__c>();
        for (Pricing_Rebate__c pr : [select Id, Expired_By__c, Rebate_End_Date__c, Status__c
                                       from Pricing_Rebate__c where Id in :clonedFromIds]) {
            emap.put(pr.Id, pr);
        }
        List<Pricing_Rebate__c> elist = new List<Pricing_Rebate__c>();
        for (Pricing_Rebate__c a : alist) {
            if (emap.containsKey(a.Cloned_from_Pricing_Rebate__c)) {
                Pricing_Rebate__c e = emap.get(a.Cloned_from_Pricing_Rebate__c);
                if (isRebateToBeExpired(e, a)) {
                    e.Expired_By__c = a.Id; e.Status__c = EXPIRED; elist.add(e);
                }
            }
        }
        if (elist.isEmpty()) {return;}
        try {update elist;} catch(Exception e) {}
    }
    
    private static Boolean isRebateToBeExpired(Pricing_Rebate__c e, Pricing_Rebate__c a) {
        if (e == null || e.Rebate_End_Date__c == null ||
            a == null || a.Rebate_Start_Date__c == null) {return false;}
        Date d1 = e.Rebate_End_Date__c;
        Date d2 = a.Rebate_Start_Date__c;
        Integer n1 = d1.daysBetween(d2);
        return (n1 <= 0);
    }
    
    public static Map<String, Pricing_Rebate_Detail__c> getRebateDetailMap(
        List<Parameter> plist, Map<Id, Map<String, List<Id>>> partnerMap) {
        Set<String> prdkeys = new Set<String>(); String prdkey;
        Map<String, Parameter> paramMap = new Map<String, Parameter>();
        debug('plist : ' + plist);
        for (Parameter p : plist) {
            debug('Parameter : ' + p);
            prdkey = p.accId + COLON + p.matId;
            prdkeys.add(prdkey); paramMap.put(prdkey, p);
            prdkey = p.accId + COLON + null;
            prdkeys.add(prdkey); paramMap.put(prdkey, p);
            if (partnerMap.containsKey(p.accId)) {
                Id soldtoId = Account_Partner_Functions.getPartnerId(partnerMap, p.accId, SOLDTO);
                if (soldtoId != null) {
                    prdkey = soldtoId + COLON + p.matId;
                    prdkeys.add(prdkey); paramMap.put(prdkey, p);
                    prdkey = soldtoId + COLON + null;
                    prdkeys.add(prdkey); paramMap.put(prdkey, p);
                }
            }
        }
        Map<String, Pricing_Rebate_Detail__c> prdmap = getRebateDetailMap(prdkeys, paramMap);
        for (Parameter p : plist) {
            Pricing_Rebate_Detail__c prd = getRebateDetail(p.accId, p.matId, prdmap);
            if (prd == null && partnerMap.containsKey(p.accId)) {
                Id soldtoId = Account_Partner_Functions.getPartnerId(partnerMap, p.accId, SOLDTO);
                if (soldtoId != null) {prd = getRebateDetail(soldtoId, p.matId, prdmap);}
            }
            debug('prd : ' + prd);
            if (prd != null) {prdmap.put(p.key, prd);}
        }
        debug('prdmap : ' + prdmap);
        return prdmap;
    }
    
    private static Pricing_Rebate_Detail__c getRebateDetail(Id accId, Id matId, Map<String, Pricing_Rebate_Detail__c> prdmap) {
        Pricing_Rebate_Detail__c prd = null; String prdkey;
        prdkey = accId + COLON + matId;
        if (prdmap.containsKey(prdkey)) {prd = prdmap.get(prdkey);} else {
            prdkey = accId + COLON + null;
            if (prdmap.containsKey(prdkey)) {prd = prdmap.get(prdkey);}
        }
        return prd;
    }
    
    private static Boolean isValidRebate(Pricing_Rebate_Detail__c prd, Parameter p) {
        if (prd == null || prd.Pricing_Rebate__r == null ||
            prd.Pricing_Rebate__r.Rebate_Start_Date__c == null) {return false;}
        Date d1 = prd.Pricing_Rebate__r.Rebate_Start_Date__c;
        Date d2 = prd.Pricing_Rebate__r.Rebate_End_Date__c;
        Integer n1 = d1.daysBetween(p.tdate); // rebate start date <= pc end date
        Integer n2 = p.fdate.daysBetween(d2); // rebate end date >= pc from date
        return (n1 >= 0 && n2 >= 0);
    }

    public static Map<String, Pricing_Rebate_Detail__c> getRebateDetailMap(Set<String> ks, Map<String, Parameter> paramMap) {
        debug('ks : ' + ks);
        Map<String, Pricing_Rebate_Detail__c> prdmap = new Map<String, Pricing_Rebate_Detail__c>();
        List<Pricing_Rebate_Detail__c> plist = [select Id, Name, Account__c, Accrual__c, Key__c,
                   Material_Sales_Data2__c, Pricing_Rebate__c, 
                   Pricing_Rebate__r.Condition_Type__c, 
                   Pricing_Rebate__r.Rebate_Start_Date__c, 
                   Pricing_Rebate__r.Rebate_End_Date__c,
                   Unit__c, UoM__c
              from Pricing_Rebate_Detail__c where Key__c in :ks and MFD__c = false
               and Pricing_Rebate__r.Status__c = :APPROVED
          order by Key__c, Pricing_Rebate__r.Rebate_Start_Date__c];
        if (plist.isEmpty()) {return prdmap;}
        for (Pricing_Rebate_Detail__c prd : plist) {
            if (!paramMap.containsKey(prd.Key__c)) {continue;}
            Parameter p = paramMap.get(prd.Key__c);
            if (!prdmap.containsKey(prd.Key__c) && isValidRebate(prd, p)) {
                prdmap.put(prd.Key__c, prd);
            }
        }
        debug('prdmap : ' + prdmap);
        return prdmap;          
    }
    
    public static Pricing_Rebate_Detail__c getRebateDetail(Id accId, Id matId, Date fdate, Date tdate) {
        Pricing_Rebate_Detail__c prd;
        Parameter p = new Parameter(accId, matId, fdate, tdate);
        List<Parameter> plist = new List<Parameter>{p};
        Set<Id> accIds = new Set<Id>{accId};
        Map<Id, Map<String, List<Id>>> partnerMap = Account_Partner_Functions.getPartnerIds(accIds);
        Map<String, Pricing_Rebate_Detail__c> prdmap = getRebateDetailMap(plist, partnerMap);
        if (prdmap.containsKey(p.key)) {prd = prdmap.get(p.key);}
        return prd;
    }
    
    public static Boolean isPercentageType(Pricing_Rebate__c pr) {
        if (pr == null) {return false;}
        String conditionType = pr.Condition_Type__c;
        return conditionType.contains('%');
    }    
    
    public static Double getRebateAmount(Id accId, Id matId, Date fdate, Date tdate, Double invoicePrice, 
                                         String currencyCode, String uomCode) {
        Pricing_Rebate_Detail__c prd = getRebateDetail(accId, matId, fdate, tdate);
        if (prd == null) {return 0.0;} 
        Double rebateAmount = 0.0, uomConvFac = 1.0, currConvFac = 1.0;
        Pricing_Rebate__c pr = prd.Pricing_Rebate__r;
        if (isPercentageType(pr)) {
            rebateAmount = prd.Accrual__c * invoicePrice / 100;
            return rebateAmount;
        }
        String prdCurrency = prd.Unit__c, prdUomCode = prd.UoM__c;
        if (prdCurrency != null && !prdCurrency.equals(currencyCode)) {
            Map<String, Double> ccrmap = CurrencyConverter.getConversionRateMap();
            currConvFac = CurrencyConverter.getCurrencyConversionFactor(
                              ccrmap, prdCurrency, currencyCode);
        }
        if (prdUomCode != null && !prdUomCode.equals(uomCode)) {
            uomConvFac = Material_UOM_Functions.getUomConversionFactor(matId, prdUomCode, uomCode);
        }
        if (uomConvFac == null || uomConvFac == 0) {uomConvFac = 1.0;}
        rebateAmount = prd.Accrual__c * currConvFac / uomConvFac;
        return rebateAmount;
    }    
    
    public static Account getAccount(Id accId){
        return [Select Id, Name, AccountNumber, BillingCity, RecordTypeId, SAP_Currency__c, 
                       SAP_DistChannel__c, SAP_Dist_Channel_Desc__c, 
                       SAP_DivisionCode__c, SAP_Division_Desc__c,
                       SAP_SalesDistrict__c, SAP_Sales_Office__c, SAP_SalesGroup__c, 
                       SAP_Customer_Group__c, SAP_Customer_Group_1__c,
                       SAP_Sales_Org__c, SAP_Sales_Org_Desc__c
                  From Account Where Id =: accId];
    }
    
    public static Set<String> getSalesOrgCodes() {
        Set<String> aset = new Set<String>();
        for (AggregateResult[] ars : [select Sales_Org__c a 
            from Pricing_Rebate_Configuration__c group by Sales_Org__c]) {
            for (AggregateResult ar : ars) {
                String s = (String)ar.get('a'); if (s != null) {aset.add(s);}
            }
        }
        return aset;
    }
    
    public static Set<String> getDistChanCodes() {
        Set<String> aset = new Set<String>();
        for (AggregateResult[] ars : [select Dist_Channel__c a 
            from Pricing_Rebate_Configuration__c group by Dist_Channel__c]) {
            for (AggregateResult ar : ars) {
                String s = (String)ar.get('a'); if (s != null) {aset.add(s);}
            }
        }
        return aset;
    }
    
    private static String getAccountsQry(Pricing_RebateCustomerSelectorSearch sp) {
        debug('sp : ' + sp);
        if(isNull(sp.distChannel)){return null;}
        String query = 'Select SAP_Sales_Org__c, SAP_DistChannel__c, SAP_DivisionCode__c, ' +
                     + 'AccountNumber, Name, BillingStreet, BillingCity, BillingState, ' +
                     + 'SAP_Partner_Functions__c From Account ';
        query += 'Where Active_Account__c = \'Yes\' and AccountNumber like \'0%\'';
        Set<String> salesOrgs = sp.salesOrgCodes, distChans = sp.distChanCodes;
        String code = null;
        if(!isNull(sp.salesOrg)){
            String[] codeAndDesc = sp.salesOrg.split('-');
            if(codeAndDesc != null && codeAndDesc.size() >= 1){
                code = codeAndDesc.get(0).trim();
            }
            query += ' AND SAP_Sales_Org__c = \'' + String.escapeSingleQuotes(code) + '\'';
        } else { 
            if (!salesOrgs.isEmpty()) {query += ' and SAP_Sales_Org__c in :salesOrgs';}
        }
        if(!isNull(sp.distChannel)){
            String[] codeAndDesc = sp.distChannel.split('-');
            if(codeAndDesc != null && codeAndDesc.size() >= 1){
                code = codeAndDesc.get(0).trim();
            }
            query += ' AND SAP_DistChannel__c = \'' + String.escapeSingleQuotes(code) + '\'';
        } else {    
            if (!distChans.isEmpty()) {query += ' and SAP_DistChannel__c in :distChans';}
        }
        if(!isNull(sp.division)){
            String[] codeAndDesc = sp.division.split('-');
            if(codeAndDesc != null && codeAndDesc.size() >= 1){
                code = codeAndDesc.get(0).trim();
            }
            query += ' AND SAP_DivisionCode__c = \'' +  String.escapeSingleQuotes(code) + '\'';
        }
        Boolean b1, b2, b3, b4;
        b1 = isNull(sp.accNumber); b2 = isNull(sp.accName); b3 = isNull(sp.accCity);
        if (!b1)
            query += ' AND AccountNumber LIKE \'%' + String.escapeSingleQuotes(sp.accNumber) + '%\''; 
        if (!b2)
            query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(sp.accName) + '%\'';
        if (!b3)
            query += ' AND BillingCity LIKE \'%' + String.escapeSingleQuotes(sp.accCity) + '%\'';
        if (sp.isSoldTo != null && sp.isSoldTo && sp.isShipTo != null && sp.isShipTo) {
            query += ' AND (SAP_Partner_Functions__c like \'%Sold To%\'';
            query += '  OR  SAP_Partner_Functions__c like \'%Ship To%\')';} else 
        if (sp.isSoldTo != null && sp.isSoldTo) {
            query += ' AND SAP_Partner_Functions__c like \'%Sold To%\'';} else 
        if (sp.isShipTo != null && sp.isShipTo) {
            query += ' AND SAP_Partner_Functions__c like \'%Ship To%\'';
        }
        query += ' order by Name LIMIT ';   
        if (Test.isRunningTest()) {query += '100';} else {query += MAX_LIMIT;}   
        if (b1 && b2 && b3) {return null;}
        return query;
    }
    
    private static PaginationController getPaginationController(String query){
        debug('*********** QUERY : ' + query);
        if (query == null) {return null;}
        Database.Querylocator ql = Database.getQueryLocator(query);
        return new PaginationController(ql, PAGE_SIZE);
    }
    
    public static PaginationController getAccountsPC(Pricing_RebateCustomerSelectorSearch sp){
        String query = getAccountsQry(sp); return getPaginationController(query);
    }
    
    private static String getMaterialsQry(Pricing_RebateMaterialSelectorSearch sp) {
        debug(''+sp);
        String query = 'Select Name, Material_Number__c, Material_Desc__c, Sales_Org_Code__c, ' +
                       'PH1__c, PH2__c From Material_Sales_Data2__c ';
        String ph5Code, ph6Code;
        if (!isNull(sp.prodHierarchy5)){
            String[] ph5 = sp.prodHierarchy5.split('-');
            if (ph5 != null && ph5.size() >= 1){ph5Code = ph5.get(0).trim();}
        }       
        if (!isNull(sp.prodHierarchy6)){
            String[] ph6 = sp.prodHierarchy6.split('-');
            if (ph6 != null && ph6.size() >= 1){ph6Code = ph6.get(0).trim();}
        }       
        if (!isNull(sp.salesOrg) && !isNull(sp.distChannel)){
            query += 'where Sales_Org_Code__c = \'' + String.escapeSingleQuotes(sp.salesOrg) + 
                     '\' AND Dist_Channel_Code__c = \'' + 
                     String.escapeSingleQuotes(sp.distChannel) + '\'';
        } else {return null;}
        Boolean b1, b2, b3, b4;
        b1 = isNull(sp.materialNumber); b2 = isNull(sp.materialDesc);
        b3 = isNull(ph5Code); b4 = isNull(ph6Code);
        if(!b1)
            query += ' AND Material_Number__c LIKE \'%' + 
                     String.escapeSingleQuotes(sp.materialNumber) + '%\''; 
        if(!b2)
            query += ' AND Material_Desc__c LIKE \'%' + 
                     String.escapeSingleQuotes(sp.materialDesc) + '%\'';
        if(!b3)
            query += ' AND PH1__c = \'' + 
                     String.escapeSingleQuotes(ph5Code) + '\'';
        if(!b4)
            query += ' AND PH2__c = \'' + 
                     String.escapeSingleQuotes(ph6Code) + '\'';
        query += ' order by Name LIMIT ';   
        if (Test.isRunningTest()) {query += '100';} else {query += MAX_LIMIT;}   
        if (b1 && b2 && b3 && b4) {return null;}
        return query;
    }
    
     /*private static String getMaterialsQry(Pricing_RebateMaterialSelectorSearch sp) {
        debug(''+sp);
        String query = 'Select Name, Material_Number__c, Material_Desc__c, Sales_Org_Code__c, ' +
                       'PH5_Family__c, PH6_Segment__c From Material_Sales_Data2__c ';
        String ph5Code, ph6Code;
        if (!isNull(sp.prodHierarchy5)){
            String[] ph5 = sp.prodHierarchy5.split('-');
            if (ph5 != null && ph5.size() >= 1){ph5Code = ph5.get(0).trim();}
        }       
        if (!isNull(sp.prodHierarchy6)){
            String[] ph6 = sp.prodHierarchy6.split('-');
            if (ph6 != null && ph6.size() >= 1){ph6Code = ph6.get(0).trim();}
        }       
        if (!isNull(sp.salesOrg) && !isNull(sp.distChannel)){
            query += 'where Sales_Org_Code__c = \'' + String.escapeSingleQuotes(sp.salesOrg) + 
                     '\' AND Dist_Channel_Code__c = \'' + 
                     String.escapeSingleQuotes(sp.distChannel) + '\'';
        } else {return null;}
        Boolean b1, b2, b3, b4;
        b1 = isNull(sp.materialNumber); b2 = isNull(sp.materialDesc);
        b3 = isNull(ph5Code); b4 = isNull(ph6Code);
        if(!b1)
            query += ' AND Material_Number__c LIKE \'%' + 
                     String.escapeSingleQuotes(sp.materialNumber) + '%\''; 
        if(!b2)
            query += ' AND Material_Desc__c LIKE \'%' + 
                     String.escapeSingleQuotes(sp.materialDesc) + '%\'';
        if(!b3)
            query += ' AND PH5_Family_Code__c = \'' + 
                     String.escapeSingleQuotes(ph5Code) + '\'';
        if(!b4)
            query += ' AND PH6_Segment_Code__c = \'' + 
                     String.escapeSingleQuotes(ph6Code) + '\'';
        query += ' order by Name LIMIT ';   
        if (Test.isRunningTest()) {query += '100';} else {query += MAX_LIMIT;}   
        if (b1 && b2 && b3 && b4) {return null;}
        return query;
    }*/
   
    
    public static PaginationController getMaterialsPC(Pricing_RebateMaterialSelectorSearch sp){
        String query = getMaterialsQry(sp); return getPaginationController(query);
    }
    
    public static void createRebateAccMats(Set<String> rebateIds) {
        List<Pricing_Rebate_Detail__c> prds = [
            select Id, Account__c, Material_Sales_Data2__c, Pricing_Rebate__c
              from Pricing_Rebate_Detail__c where Pricing_Rebate__c in :rebateIds];
        if (prds == null || prds.isEmpty()) {return;}
        List<Pricing_Rebate_Account__c>  pras = new List<Pricing_Rebate_Account__c>(),
                                         del1 = new List<Pricing_Rebate_Account__c>(),
                                         ins1 = new List<Pricing_Rebate_Account__c>();
                                         
        List<Pricing_Rebate_Material__c> prms = new List<Pricing_Rebate_Material__c>(),
                                         del2 = new List<Pricing_Rebate_Material__c>(),
                                         ins2 = new List<Pricing_Rebate_Material__c>();
        Set<String> set1 = new Set<String>(); String s1;
        Set<String> set2 = new Set<String>(); String s2;
        Set<String> rds1 = new Set<String>(), rds2 = new Set<String>();
        pras = [select Id, Key__c from Pricing_Rebate_Account__c  where Rebate__c in :rebateIds];
        prms = [select Id, Key__c from Pricing_Rebate_Material__c where Rebate__c in :rebateIds];
        for (Pricing_Rebate_Account__c a : pras)  {set1.add(a.Key__c);}
        for (Pricing_Rebate_Material__c a : prms) {set2.add(a.Key__c);}
        for (Pricing_Rebate_Detail__c d : prds) {
            s1 = d.Pricing_Rebate__c + COLON + d.Account__c; rds1.add(s1); s2 = null;
            if (d.Material_Sales_Data2__c != null) {
                s2 = d.Pricing_Rebate__c + COLON + d.Material_Sales_Data2__c; rds2.add(s2);
            }
            if (s1 != null && !set1.contains(s1)) {
                set1.add(s1);
                ins1.add(new Pricing_Rebate_Account__c(
                    Account__c = d.Account__c,
                    Rebate__c = d.Pricing_Rebate__c,
                    Rebate_Detail__c = d.Id));
            }
            if (s2 != null && !set2.contains(s2)) {
                set2.add(s2);
                ins2.add(new Pricing_Rebate_Material__c(
                    Material__c = d.Material_Sales_Data2__c,
                    Rebate__c = d.Pricing_Rebate__c,
                    Rebate_Detail__c = d.Id));
            }
        }
        for (Pricing_Rebate_Account__c a : pras) {
            if (!rds1.contains(a.Key__c)) {del1.add(a);}
        }
        for (Pricing_Rebate_Material__c a : prms) {
            if (!rds2.contains(a.Key__c)) {del2.add(a);}
        }
        if (!del1.isEmpty()) {delete del1;} 
        if (!del2.isEmpty()) {delete del2;} 
        if (!ins1.isEmpty()) {insert ins1;} 
        if (!ins2.isEmpty()) {insert ins2;} 
    }

    public static void deleteRebateTemps(String rebateId) {
        deleteRebateTemps(new Set<String>{rebateId});
    }
        
    public static void deleteRebateTemps(Set<String> rebateIds) {
        for (List<Pricing_Rebate_Temp__c> alist : [
            select Id from Pricing_Rebate_Temp__c where Rebate__c in :rebateIds]) {
            delete alist;
        }
    }
    
    public static void createRebateTemps(String r1, String r2) {
        deleteRebateTemps(r2);
        List<Pricing_Rebate_Material__c> mlist1 = [
            select Id, Material__c, Material_Number__c, Rebate__c, Rebate_Detail__c 
              from Pricing_Rebate_Material__c where Rebate__c = :r1];
        if (mlist1 == null || mlist1.isEmpty()) {return;}
        
        List<Pricing_Rebate_Account__c> alist2 = [
            select Id, Account__c, DistChan__c, Rebate__c, SalesOrg__c 
              from Pricing_Rebate_Account__c where Rebate__c = :r2];
        if (alist2 == null || alist2.isEmpty()) {return;}

        Set<String> dset2 = new Set<String>(); String tkey;
        for (Pricing_Rebate_Detail__c d : [
            select Id, Account__c, Material_Sales_Data2__c, Pricing_Rebate__c
              from Pricing_Rebate_Detail__c where Pricing_Rebate__c = :r2]) {
            tkey = r2 + COLON + d.Account__c + COLON + d.Material_Sales_Data2__c;
            dset2.add(tkey);
        }
        
        Set<String> mkeys = new Set<String>(); String mkey;
        for (Pricing_Rebate_Material__c m : mlist1) {
            for (Pricing_Rebate_Account__c a : alist2) {
                mkey = m.Material_Number__c + a.SalesOrg__c + a.DistChan__c;
                mkeys.add(mkey);
            }
        }
        
        Map<String, Id> mmap = new Map<String, Id>();
        for (Material_Sales_Data2__c m : [
            select Id, Record_Key__c from Material_Sales_Data2__c 
             where Record_Key__c in :mkeys]) {mmap.put(m.Record_Key__c, m.Id);}

        List<Pricing_Rebate_Temp__c> tlist = new List<Pricing_Rebate_Temp__c>();
        Pricing_Rebate_Temp__c t; Id matId; Integer n = 0, batchSize = 100; String k;
        for (Pricing_Rebate_Material__c m : mlist1) {
            for (Pricing_Rebate_Account__c a : alist2) {
                mkey = m.Material_Number__c + a.SalesOrg__c + a.DistChan__c;
                if (!mmap.containsKey(mkey)) {continue;}
                matId = mmap.get(mkey); tkey = r2 + COLON + a.Account__c + COLON + matId;
                if (dset2.contains(tkey)) {continue;}
                t = getRebateTemp(a, m, matId, tkey); tlist.add(t); n++;
                if (n == batchSize) {
                    upsert tlist Pricing_Rebate_Temp__c.Fields.Key__c;
                    n = 0; tlist = new List<Pricing_Rebate_Temp__c>();
                }
            }
        }
        if (n > 0) {upsert tlist Pricing_Rebate_Temp__c.Fields.Key__c;}
    }
    
    private static Pricing_Rebate_Temp__c getRebateTemp(Pricing_Rebate_Account__c a, 
        Pricing_Rebate_Material__c m, Id matId, String tkey) {
        Pricing_Rebate_Temp__c t = new Pricing_Rebate_Temp__c();
        t.Account__c = a.Account__c; t.Key__c = tkey; t.Material__c = matId; 
        t.Rebate__c = a.Rebate__c; t.Rebate_Detail__c = m.Rebate_Detail__c;
        return t;
    }
    
    public static void createRebateDetails(String rebateId) {
        createRebateDetails(new Set<String>{rebateId});
    }
        
    public static void createRebateDetails(Set<String> rebateIds) {
        for (List<Pricing_Rebate_Temp__c> alist : [
            select Account__c, Rebate__c, Material__c, 
                   Rebate_Detail__r.Accrual__c, 
                   Rebate_Detail__r.Amount__c, 
                   Rebate_Detail__r.CurrencyIsoCode, 
                   Rebate_Detail__r.OwnerId, 
                   Rebate_Detail__r.Per__c, 
                   Rebate_Detail__r.Table__c, 
                   Rebate_Detail__r.Unit__c, 
                   Rebate_Detail__r.Uom__c 
              from Pricing_Rebate_Temp__c 
             where Rebate__c in :rebateIds]) {
            createRebateDetails(alist);
        }
    }
    
    private static void createRebateDetails(List<Pricing_Rebate_Temp__c> alist) {
        List<Pricing_Rebate_Detail__c> dlist = new List<Pricing_Rebate_Detail__c>();
        for (Pricing_Rebate_Temp__c a : alist) {dlist.add(getRebateDetail(a));}
        insert dlist;
    }
    
    private static Pricing_Rebate_Detail__c getRebateDetail(Pricing_Rebate_Temp__c a) {
        Pricing_Rebate_Detail__c d = new Pricing_Rebate_Detail__c();
                      d.Account__c = a.Account__c;
                      d.Accrual__c = a.Rebate_Detail__r.Accrual__c;
                       d.Amount__c = a.Rebate_Detail__r.Amount__c;
                 d.CurrencyIsoCode = a.Rebate_Detail__r.CurrencyIsoCode;
         d.Material_Sales_Data2__c = a.Material__c;
                         d.OwnerId = a.Rebate_Detail__r.OwnerId;
                          d.Per__c = a.Rebate_Detail__r.Per__c;
               d.Pricing_Rebate__c = a.Rebate__c;
                        d.Table__c = a.Rebate_Detail__r.Table__c;
                         d.Unit__c = a.Rebate_Detail__r.Unit__c;
                          d.UoM__c = a.Rebate_Detail__r.Uom__c;
        return d;
    }
    
    public static void copyRebateDetails(String rebateId1, String rebateId2) {
        Set<String> rebateIds = new Set<String>{rebateId1, rebateId2};
        createRebateAccMats(rebateIds);
        createRebateTemps(rebateId1, rebateId2);
        createRebateDetails(rebateId2);
    }
}