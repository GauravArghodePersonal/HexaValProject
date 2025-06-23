global without sharing class Account_Partner_Functions {

    public static final String DELIM = ':';
    public static final String ACC_TYPE_BILLTO = 'Bill To';
    public static final String ACC_TYPE_PAYER  = 'Payer';
    public static final String ACC_TYPE_SHIPTO = 'Ship To';
    public static final String ACC_TYPE_SOLDTO = 'Sold To';
    public static final String ACC_TYPE_CHERKY = 'Corp Acct';
    public static final String ACC_TYPE_SUPACC = 'Ultimate Parent';
    public static final String ACC_TYPE_PRSPCT = 'Prospect';
    public static final String DEF_PMT_TERM = 'Z030';
    public static final String NO = 'No';
    public static final String XX = 'X';
    public static final String ZZ = 'ZZ';

    public static final String XML_ROOT_ELEMNT = 'AccountHierarchy';
    public static final String XML_ROOT_BEGIN = '<'+XML_ROOT_ELEMNT+'>';
    public static final String XML_ROOT_END = '</'+XML_ROOT_ELEMNT+'>';

    public static final String SEC_QRY1 = ''
        + 'select  Ship_Sup_Number__c, Ship_Sup_Account__c,'
        + '        Ship_Sup_Account__r.Active_Account__c,'
        + '        Ship_Sup_Account__r.Inactive_Account__c,'
        + '        Hier_Account__c, Hier__c,'
        + '        Hier__r.Active_Account__c,'
        + '        Hier__r.Inactive_Account__c,'
        + '        Payer_Account__c, Payer__c,'
        + '        Sold_Account__c, Sold_To__c,'
        + '        Sold_To__r.Active_Account__c,'
        + '        Sold_To__r.Inactive_Account__c,'
        + '        Ship_Account__c, Ship_To__c,'
        + '        Ship_To__r.Active_Account__c,'
        + '        Ship_To__r.Inactive_Account__c'
        + '  from  SAP_ECOM_Customer__c'
        + ' where (Ship_Sup_Account__c  = :accountId'
        + '    or              Hier__c  = :accountId'
        + '    or           Sold_To__c  = :accountId'
        + '    or           Ship_To__c  = :accountId)'
        + '   and          Del_Flag__c != :XX';

    public static final String SEC_QRY2 = ''
        + ' and Ship_Sup_Account__r.Active_Account__c  != :NO'
        + ' and Ship_Sup_Account__r.Inactive_Account__c = false'
        + ' and Hier__r.Active_Account__c  != :NO'
        + ' and Hier__r.Inactive_Account__c = false'
        + ' and Sold_To__r.Active_Account__c  != :NO'
        + ' and Sold_To__r.Inactive_Account__c = false'
        + ' and Ship_To__r.Active_Account__c  != :NO'
        + ' and Ship_To__r.Inactive_Account__c = false';

    public static final String SEC_QRY3 = ' limit 2000';

    public static final Set<String> XML_ACC_TYPES = new Set<String>{
        ACC_TYPE_SUPACC, ACC_TYPE_CHERKY, ACC_TYPE_SOLDTO, ACC_TYPE_SHIPTO};

    public static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'AP_Functions : ' + s);
    }

    private static Boolean tooManyScriptStatements() {
        return (Limits.getScriptStatements() > (Limits.getLimitScriptStatements()-200));
    }

    global class ReturnClass {
        webservice Account1 accountHierarchy;
        webservice String accountHierarchyXml;
        webservice String returnMessage = '';
    }

    global class AccountClass {
        webservice String sourceAccId;
        webservice Boolean isSourceAcc;
        webservice Boolean isViewngAcc;
        webservice String accountId;
        webservice String accountName;
        webservice String accountNumber;
        webservice String accountType;

        public AccountClass(String srcAccId, String accId){
            sourceAccId = srcAccId; 
            accountId = accId;
            isSourceAcc = (accId != null && accId.equals(srcAccId));
            isViewngAcc = isSourceAcc;
        }
    }

    global class Account1 {
        webservice AccountClass acc;
        webservice List<Account2> a2s;
        webservice List<Account3> a3s;
        public String xmlString;
        
        public Account1() {
            this(null, null);
        }

        public Account1(String srcAccId, String accountId) {
            init(srcAccId, accountId);
        }
        
        private void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            a2s = new List<Account2>();
            a3s = new List<Account3>();
            //debug('Account1 : '+acc);
        }
    }

    global class Account2 {
        webservice AccountClass acc;
        webservice List<Account3> a3s;
        public String xmlString;
        public Account2() {
            this(null, null);
        }

        public Account2(String srcAccId, String accountId) {
            init(srcAccId, accountId);
        }

        private void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            a3s = new List<Account3>();
            //debug('CH_Account : '+acc);
        }
    }

    global class Account3 {
        webservice AccountClass acc;
        webservice List<Account4> a4s;
        public Account3() {
            this(null, null);
        }

        public Account3(String srcAccId, String accountId) {
            init(srcAccId, accountId);
        }

        private void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            a4s = new List<Account4>();
            //debug('Account3 : '+acc);
        }
    }

    global class Account4 {
        webservice AccountClass acc;
        public Account4() {
            this(null, null);
        }
        
        public Account4(String srcAccId, String accountId) {
            init(srcAccId, accountId);
        }
        
        private void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            //debug('Account4 : '+acc);
        }
    }

    public static Id getUltimateParentId(Id accountId) {        
        debug('getUltimateParentId : accountId = ' + accountId);
        List<Account> alist = [select AccountNumber, ParentId
                                from Account where Id = :accountId];
        if (alist == null || alist.isEmpty()) {return accountId;}
        debug('accountNumber = ' + alist[0].AccountNumber);
        Id parentId = alist[0].ParentId;
        if (parentId == null) {return accountId;}
        parentId = getUltimateParentId(parentId);
        debug('parentId = ' + parentId);
        return parentId;
    }

    public static void getParentIds(List<Id> accIds) {
        debug('getParentIds');
        Integer n = accIds.size()-1;
        if (n < 0 || n > 9) {return;}
        Id accountId = accIds[n];
        debug('accountId = ' + accountId);
        List<Account> alist = [select AccountNumber, ParentId
                                 from Account where Id = :accountId];
        if (alist == null || alist.isEmpty()) {return;}
        debug('accountNumber = ' + alist[0].AccountNumber);
        Id parentId = alist[0].ParentId;
        if (parentId == null) {return;}
        accIds.add(parentId); getParentIds(accIds);
    }

    public static void getParentIds(Id accId) {
        debug('getParentIds : accId = ' + accId);
        List<Id> accIds = new List<Id>{accId};
        getParentIds(accIds); Integer n = accIds.size()-1;
        for (Integer i = n; i >=0; i--) {
            debug('accIds['+i+'] = ' + accIds[i]);
        }
    }

    public static Set<Id> getShipToIds(Id accountId) {
        debug('getShipToIds : accountId = ' + accountId);
        Set<Id> aset = new Set<Id>(); List<SAP_ECOM_Customer__c> alist;
        alist = [select Ship_To__c from SAP_ECOM_Customer__c
                  where  Sold_To__c  = :accountId
                    and Del_Flag__c != :XX];
        if (alist == null || alist.isEmpty()) {
            alist = [select Id from SAP_ECOM_Customer__c
                      where  Ship_To__c  = :accountId
                        and Del_Flag__c != :XX limit 1];
            if (alist != null && !alist.isEmpty()) {aset.add(accountId);}
        } else {
            for (SAP_ECOM_Customer__c a : alist) {aset.add(a.Ship_To__c);}
        }
        return aset;
    }

    public static Boolean isSoldTo(String accId) {
        return isSoldTo(accId, true);
    }

    public static Boolean isSoldTo(String accId, Boolean excludeInactiveAccounts) {
        debug('isSoldTo : ' + accId + ' : ' + excludeInactiveAccounts);
        Id accountId = accId;
        Map<String, Set<Id>> amap = getPartnerTypes(accountId, excludeInactiveAccounts);
        return isSoldTo(accountId, amap);
    }

    public static String getAccountType(Id accountId) {
        debug('getAccountType : accountId = ' + accountId);
        Map<String, Set<Id>> amap = getPartnerTypes(accountId);
        if (isCHerky(accountId, amap)) {return ACC_TYPE_CHERKY;}
        if (isSoldTo(accountId, amap)) {return ACC_TYPE_SOLDTO;}
        if (isShipTo(accountId, amap)) {return ACC_TYPE_SHIPTO;}
        return null;
    }

    public static Map<Id, Account> getParentAccounts(Id accountId) {
        debug('getParentAccounts : accountId = ' + accountId);
        Set<Id> aset = new Set<Id>{accountId};
        Map<String, Set<Id>> amap = getPartnerTypes(accountId);
        if (isShipTo(accountId, amap)) {
            aset.add(getPartnerId(amap, accountId, ACC_TYPE_SOLDTO));
            aset.add(getPartnerId(amap, accountId, ACC_TYPE_CHERKY));
        } else
        if (isSoldTo(accountId, amap)) {
            aset.add(getPartnerId(amap, accountId, ACC_TYPE_CHERKY));
        }
        return getAccountsMap(aset);
    }

    public static Boolean isCHerky(Id accountId, Map<String, Set<Id>> amap) {
        debug('isCHerky : accountId = ' + accountId);
        return isAccType(accountId, amap, ACC_TYPE_CHERKY);
    }

    public static Boolean isSoldTo(Id accountId, Map<String, Set<Id>> amap) {
        debug('isSoldTo : accountId = ' + accountId);
        return isAccType(accountId, amap, ACC_TYPE_SOLDTO);
    }

    public static Boolean isShipTo(Id accountId, Map<String, Set<Id>> amap) {
        debug('isShipTo : accountId = ' + accountId);
        return isAccType(accountId, amap, ACC_TYPE_SHIPTO);
    }

    private static Boolean isAccType(Id accountId, Map<String, Set<Id>> amap, String accType) {
        debug('isAccType : accountId = ' + accountId);
        if (!amap.containsKey(accType)) {return false;}
        Set<Id> aset = amap.get(accType);
        return aset.contains(accountId);
    }

    private static void addPartnerId(Map<String, Set<Id>> pmap, String pt, Id pid) {
        debug('addPartnerId : pt = ' + pt + ' : pid = ' + pid);
        
        if (pid == null) {return;} 
        Set<Id> aset;
        
        if (pmap.containsKey(pt)) {
            aset = pmap.get(pt);
        } else {
            aset = new Set<Id>();
        }
        
        aset.add(pid); 
        pmap.put(pt, aset);
    }

    public static Map<String, Set<Id>> getPartnerTypes(Id accountId) {
        debug('getPartnerTypes : accountId = ' + accountId);
        Boolean excludeInactiveAccounts = true;
        return getPartnerTypes(accountId, excludeInactiveAccounts);
    }

    private static Map<String, Set<Id>> getPartnerTypes(Id accountId,
        Boolean excludeInactiveAccounts) {
        debug('getPartnerTypes : accountId = ' + accountId + ' : ' + excludeInactiveAccounts);
        List<String> slist = new List<String>(); Set<Id> aset = new Set<Id>();
        Map<String, Set<Id>> pmap = new Map<String, Set<Id>>();
        setAccountPartners(accountId, slist, pmap, aset, excludeInactiveAccounts);
        return pmap;
    }

    private static List<String> getPartnerList(String accountId, Set<Id> aset,
                                               Boolean excludeInactiveAccounts) {
        debug('getPartnerList : accountId = ' + accountId + ' : ' + excludeInactiveAccounts);
        List<String> slist = new List<String>();
        Map<String, Set<Id>> pmap = new Map<String, Set<Id>>();
        setAccountPartners(accountId, slist, pmap, aset, excludeInactiveAccounts);
        return slist;
    }

    private static void setAccountPartners(String accountId, List<String> slist,
                                           Map<String, Set<Id>> pmap, Set<Id> aset,
                                           Boolean excludeInactiveAccounts) {
        debug('setAccountPartners : accountId = ' + accountId + ' : ' + excludeInactiveAccounts);
        Id tempId = accountId; accountId = tempId;
        String s, sh; 
        Set<String> sset = new Set<String>();
        String q = SEC_QRY1; 
        if (excludeInactiveAccounts) {q += SEC_QRY2;}
        q += SEC_QRY3;
        debug('accId = ' + accountId + ' : q = ' + q);
        List<SAP_ECOM_Customer__c> alist = Database.query(q);
        if (alist == null || alist.isEmpty()) {return;}
        Map<String, String> sh2soIds = new Map<String, String>();
        Map<String, String> sh2soNms = new Map<String, String>();
        Map<String, String> sh2chIds = new Map<String, String>();
        Map<String, String> sh2chNms = new Map<String, String>();
        Map<String, String> sh2upIds = new Map<String, String>();
        Map<String, String> sh2upNms = new Map<String, String>();

        for (SAP_ECOM_Customer__c a : alist) {
            debug('asetSize: ' + aset.size());
            sh = a.Ship_To__c; 
            
            if (sh == null) {continue;}

            aset.add(sh); 
            addPartnerId(pmap, ACC_TYPE_SHIPTO, sh);
            
            if (a.Sold_To__c != null) {
                debug('a : ' + a);
                aset.add(a.Sold_To__c);
                addPartnerId(pmap, ACC_TYPE_SOLDTO, a.Sold_To__c);
                if (!sh2soIds.containsKey(sh) ||
                    (sh2soIds.containsKey(sh) && sh != a.Sold_To__c)) {
                    sh2soIds.put(sh, a.Sold_To__c);
                    sh2soNms.put(sh, a.Sold_Account__c);
                }
            }
            if (a.Hier__c != null) {
                aset.add(a.Hier__c);
                addPartnerId(pmap, ACC_TYPE_CHERKY, a.Hier__c);
                sh2chIds.put(sh, a.Hier__c);
                sh2chNms.put(sh, a.Hier_Account__c);
            }
            if (a.Payer__c != null) {
                aset.add(a.Payer__c);
                addPartnerId(pmap, ACC_TYPE_PAYER, a.Payer__c);
            }
            if (a.Ship_Sup_Account__c != null) {
                aset.add(a.Ship_Sup_Account__c);
                addPartnerId(pmap, ACC_TYPE_SUPACC, a.Ship_Sup_Account__c);
                sh2upIds.put(sh, a.Ship_Sup_Account__c);
                sh2upNms.put(sh, a.Ship_Sup_Number__c);
            }
        }
        String k1, k2, k3, k4, i1, i2, i3;
        for (SAP_ECOM_Customer__c a : alist) {
            debug('a : ' + a);
            sh = a.Ship_To__c; if (sh == null) {continue;}
            i1 = s1(sh, sh2upIds); 
            i2 = s1(sh, sh2chIds); 
            i3 = s1(sh, sh2soIds);
            
            k1 = (i1 == accountId) ? '1' : '2'; 
            k2 = (i2 == accountId) ? '1' : '2';
            k3 = (i3 == accountId) ? '1' : '2'; 
            k4 = (sh == accountId) ? '1' : '2';
            
            s  = k1 + DELIM + s1(sh, sh2upNms) + DELIM + i1 + DELIM;
            s += k2 + DELIM + s1(sh, sh2chNms) + DELIM + i2 + DELIM;
            s += k3 + DELIM + s1(sh, sh2soNms) + DELIM + i3 + DELIM;
            s += k4 + DELIM + s1(a.Ship_Account__c) + DELIM + sh;
            
            sset.add(s); debug('s : ' + s);
        }

        slist.addAll(sset); 
        slist.sort(); debug('slist : ' + slist);
    }

    private static String s1(String k, Map<String, String> m) {
        return m.containsKey(k) ? m.get(k) : ZZ;
    }

    private static String s1(String s) {return String.isBlank(s) ? ZZ : s;}

    private static Boolean exclude(String accountId, Map<Id, Account> accountMap,
                                   Boolean excludeInactiveAccounts) {
        if (accountId == null || !accountMap.containsKey(accountId)) {return true;}
        Account a = accountMap.get(accountId); 
        Boolean b = isInactiveAccount(a);
        return (excludeInactiveAccounts && b);
    }

    private static List<Account1> getAccount1List(String accountId,
                                                  List<String> slist,
                                                  Map<Id, Account> accountMap,
                                                  Boolean excludeInactiveAccounts) {
        debug('getAccount1List : accountId = ' + accountId + ' : ' + excludeInactiveAccounts);
        List<Account1> a1s = new List<Account1>();
        setAccount1List(accountId, a1s, slist, accountMap, excludeInactiveAccounts);
        return a1s;
    }

    private static void setAccount1List(String accountId, List<Account1> a1s,
                                        List<String> slist,
                                        Map<Id, Account> accountMap,
                                        Boolean excludeInactiveAccounts) {
        debug('setAccount1List : accountId = ' + accountId + ' : ' + excludeInactiveAccounts);
        
        Id tempId = accountId; 
        accountId = tempId;
        
        List<String> sa; 
        Boolean b1, b2, b3, b4;
        
        String s1 = '', s2 = '', s3 = '', s4 = '';
        
        String t1 = '', t2 = '', t3 = '', t4 = '';
        
        Account1 a1; 
        Account2 a2; 
        Account3 a3; 
        Account4 a4;
        
        for (String s : slist) {
            sa = s.split(DELIM); 
            if (sa.isEmpty()) { continue; }

            s1 = sa[2]  == ZZ ? null : sa[2];  
            b1 = exclude(s1, accountMap, excludeInactiveAccounts);
            
            s2 = sa[5]  == ZZ ? null : sa[5];  
            b2 = exclude(s2, accountMap, excludeInactiveAccounts);
            
            s3 = sa[8]  == ZZ ? null : sa[8];  
            b3 = exclude(s3, accountMap, excludeInactiveAccounts);
            
            s4 = sa[11] == ZZ ? null : sa[11]; 
            b4 = exclude(s4, accountMap, excludeInactiveAccounts);

            /*
            debug('getAccountList : s1 = ' + s1 + ' : b1 = ' + b1 +
                                ' : s2 = ' + s2 + ' : b2 = ' + b2 +
                                ' : s3 = ' + s3 + ' : b3 = ' + b3 +
                                ' : s4 = ' + s4 + ' : b4 = ' + b4);
            */

            if (!b1 && !s1.equals(t1)) {
                t1 = s1; 
                t2 = ''; //if (b2) {continue;}
                a1 = new Account1(accountId, s1); 
                a1s.add(a1);
                debug('getAccountList 1 : s = ' + s);
            }

            if (!b2 && !s2.equals(t2)) {
                t2 = s2; 
                t3 = ''; //if (b3) {continue;}
                if (s1 == null || a1 == null) {
                    a1 = new Account1(); 
                    a1s.add(a1);
                }

                a2 = new Account2(accountId, s2);

                if(a2.acc.isSourceAcc) {
                    a1.acc.isSourceAcc = false;
                }

                a1.a2s.add(a2);
                debug('getAccountList 2 : s = ' + s);
            }
            if (!b3 && !s3.equals(t3)) {
                t3 = s3; 
                t4 = ''; //if (b4) {continue;}
                if (s1 == null || a1 == null) {
                    a1 = new Account1(); 
                    a1s.add(a1);
                }
                
                a3 = new Account3(accountId, s3);
                
                if (s2 == null || a2 == null) {
                    if(a3.acc.isSourceAcc) {
                        a1.acc.isSourceAcc = false;
                    }
                    a1.a3s.add(a3);
                } else {
                    if(a3.acc.isSourceAcc) {
                        a2.acc.isSourceAcc = false;
                    }
                    a2.a3s.add(a3);
                }
                debug('getAccountList 3 : s = ' + s);
            }
            if (!b4 && !s4.equals(t4)) {
                t4 = s4;

                if (s3 == null || a3 == null) {
                    a3 = new Account3();
                    if (s1 == null || a1 == null) {
                        a1 = new Account1(); 
                        a1s.add(a1);
                    }
                    if (s2 == null || a2 == null) {
                        if(a3.acc.isSourceAcc) {
                            a1.acc.isSourceAcc = false;
                        }
                        a1.a3s.add(a3);
                    } else {
                        if(a3.acc.isSourceAcc) {
                            a2.acc.isSourceAcc = false;
                        }
                        a2.a3s.add(a3);
                    }
                }

                a4 = new Account4(accountId, s4);
                if(a4.acc.isSourceAcc) {
                    a3.acc.isSourceAcc = false;
                }
                a3.a4s.add(a4);
                debug('getAccountList 4 : s = ' + s);
            }
        }
        debug('a1s : ' + a1s);
    }

    // Map<Id, Map<PartnerType, List<Id>>>
    public static Map<Id, Map<String, List<Id>>> getPartnerIds(Set<Id> accountIds) {
        Boolean excludeInactiveAccounts = false;
        return getPartnerIds(accountIds, excludeInactiveAccounts);
    }

    // Map<Id, Map<PartnerType, List<Id>>>
    public static Map<Id, Map<String, List<Id>>> getPartnerIds(Set<Id> accountIds, Boolean excludeInactiveAccounts) {
        debug('getPartnerIds');
        Map<Id, Map<String, List<Id>>> amap = new Map<Id, Map<String, List<Id>>>();
        Map<String, Set<Id>> smap; Map<String, List<Id>> lmap; List<Id> alist;
        for (Id accId : accountIds) {
            lmap = new Map<String, List<Id>>();
            smap = getPartnerTypes(accId, excludeInactiveAccounts);
            for (String s : smap.keySet()) {
                alist = new List<Id>(); alist.addAll(smap.get(s)); lmap.put(s, alist);
            }
            amap.put(accId, lmap);
        }
        setProspects(accountIds, amap);
        return amap;
    }

    private static void setProspects(Set<Id> accountIds, Map<Id, Map<String, List<Id>>> amap) {
        debug('setProspects');
        Map<String, List<Id>> smap = new Map<String, List<Id>>();
        Set<Id> pset = getProspectIds(accountIds);
        for (Id accId : accountIds) {
            if (!amap.containsKey(accId) && pset.contains(accId)) {
                smap = new Map<String, List<Id>>();
                setPartnerId(ACC_TYPE_PRSPCT, accId, smap);
                amap.put(accId, smap);
            }
        }
    }

    private static Set<Id> getProspectIds(Set<Id> accountIds) {
        debug('getProspectIds');
        Set<Id> pset = new Set<Id>();
        try {
            for (Account a : [select Id, AccountNumber
                                from Account where Id in :accountIds]) {
                if (isProspect(a)) {pset.add(a.Id);}
            }
        } catch(Exception e) {}
        return pset;
    }

    private static Boolean isProspect(Account acc) {
        return (acc != null && acc.AccountNumber != null &&
                acc.AccountNumber.startsWith('P'));
    }

    private static void setPartnerId(String ptype, Id pid, Map<String, List<Id>> pmap) {
        debug('setPartnerId : ptype = ' + ptype + ' : pid = ' + pid);
        Set<Id> pset = new Set<Id>();
        if (pmap.containsKey(ptype)) {pset.addAll(pmap.get(ptype));}
        pset.add(pid);
        List<Id> plist = new List<Id>();
        plist.addAll(pset);
        debug('setPartnerId : ' + ptype + ':' + pid);
        pmap.put(ptype, plist);
    }

    public static Map<String, List<Id>> getPartnerIds(Id accountId) {
        debug('getPartnerIds : accountId = ' + accountId);
        Set<Id> accountIds = new Set<Id>{accountId};
        Map<Id, Map<String, List<Id>>> partnerIds = getPartnerIds(accountIds);
        if (partnerIds.containsKey(accountId)) {
            return partnerIds.get(accountId);
        }
        return null;
    }

    public static Map<Id, Account> getAccountsMap(Map<String, List<Id>> partnerIds) {
        debug('getAccountsMap(Map<Str, List<Id>>)');
        Map<Id, Account> amap = new Map<Id, Account>();
        Set<Id> accountIds = new Set<Id>();
        if (partnerIds != null) {
            for (List<Id> s : partnerIds.values()) {accountIds.addAll(s);}
            amap = getAccountsMap(accountIds);
        }
        return amap;
    }

    public static Map<Id, Account> getAccountsMap(
        Map<Id, Map<String, List<Id>>> partnerIds) {
        debug('getAccountsMap(Map<Id, Map<>>)');
        Set<Id> accountIds = new Set<Id>();
        for (Map<String, List<Id>> m : partnerIds.values()) {
            for (List<Id> s : m.values()) {
                accountIds.addAll(s);
            }
        }
        return getAccountsMap(accountIds);
    }

    public static Map<Id, Account> getAccountsMap(
        Map<Id, Map<String, List<Id>>> partnerIds, Set<Id> accIds) {
        debug('getAccountsMap(Map<Id, Map<>>, Set<Id>)');
        Set<Id> accountIds = new Set<Id>(); accountIds.addAll(accIds);
        for (Map<String, List<Id>> m : partnerIds.values()) {
            for (List<Id> s : m.values()) {
                accountIds.addAll(s);
            }
        }
        return getAccountsMap(accountIds);
    }

    public static Map<Id, Account> getAccountsMap(Set<Id> accountIds) {
        debug('getAccountsMap(set<Id>)');
        debug('accountsIds: ' + accountIds);
        Map<Id, Account> amap = new Map<Id, Account>();
        if (accountIds != null && !accountIds.isEmpty()) {
            for (Account a : [
                select Id, Name, NameLocal, AccountNumber, Active_Account__c,
                       BillingCity, BillingCountry, BillingPostalCode,
                       BillingState, BillingStreet, Inactive_Account__c,
                       Owner.Id, Owner.Name, ParentId,
                       SAP_Account_Name_2__c, SAP_Country__c,
                       SAP_CSR__c, SAP_CSR_Email__c, SAP_CSR_Fax__c, SAP_CSR_Phone__c,
                       SAP_Customer_Group_1_Desc__c, SAP_Customer_Group__c,
                       SAP_Customer_Group_Desc__c, SAP_Customer_Number__c,
                       SAP_DistChannel__c, SAP_Dist_Channel_Desc__c,
                       SAP_DivisionCode__c, SAP_Division_Desc__c,
                       SAP_Partner_Functions__c, SAP_Payment_Terms__c,
                       SAP_Sales_District_Desc__c, SAP_Sales_Group_Desc__c,
                       SAP_Sales_Office_Desc__c, SAP_Sales_Org__c,
                       SAP_Sales_Org_Desc__c,SAP_Customer_Price_Group_Desc__c,Prospect_Customer_Price_Group_Desc__c
                  from Account
                 where Id in :accountIds]) {
                amap.put(a.Id, a);
                system.debug('amap===='+amap);
            }
        }
        debug('getAccountsMap : amap = '+amap);
        return amap;
    }

    public static Account getAccount(Id accountId) {
        debug('getAccount : accountId = ' + accountId);
        Map<Id, Account> amap = getAccountsMap(new Set<Id>{accountId});
        return amap.get(accountId);
    }
    
    public static Account getPayer(Id accountId) {
        debug('getPayer : accountId = ' + accountId);
        Account payerAcc = getPartnerAccount(accountId, ACC_TYPE_PAYER);
        debug('getPayer : payerAcc = ' + payerAcc);
        if (payerAcc == null) {
            Account soldtoAcc = getSoldTo(accountId);
            debug('getPayer : soldtoAcc = ' + soldtoAcc);
            if (soldtoAcc != null && soldtoAcc.Id != accountId) {
                payerAcc = getPartnerAccount(soldtoAcc.Id, ACC_TYPE_PAYER);
            }
        }
        debug('getPayer : payerAcc = ' + payerAcc);
        return payerAcc;
    }

    public static Boolean isSoldTo(Id accountId) {
        debug('isSoldTo : accountId = ' + accountId);
        Account acc = getSoldTo(accountId);
        return (acc != null && acc.Id == accountId);
    }
    @AuraEnabled
    public static Id getSoldToId(Id accountId) {
        debug('getSoldToId : accountId = ' + accountId);
        Account acc = getSoldTo(accountId);
        system.debug('<<<<acc.Id>>>>'+acc.Id);
        if (acc != null) {return acc.Id;}
        return null;
    }

    public static Account getSoldTo(Id accountId) {
        debug('getSoldTo : accountId = ' + accountId);
        return getPartnerAccount(accountId, ACC_TYPE_SOLDTO);
    }

    public static Account getSoldTo(Map<String, List<Id>> pmap, Map<Id, Account> amap) {
        debug('getSoldTo');
        return getPartnerAccount(pmap, amap, ACC_TYPE_SOLDTO);
    }

    private static Set<Id> getPartnerIds(Id accountId, String partnerType) {
        debug('getPartnerIds : accountId = ' + accountId + ' : ' + partnerType);
        Map<String, List<Id>> pmap = getPartnerIds(accountId);
        if (pmap == null || pmap.isEmpty() || !pmap.containsKey(partnerType)) {return null;}
        Set<Id> partnerIds = new Set<Id>(); partnerIds.addAll(pmap.get(partnerType));
        return partnerIds;
    }

    public static Account getPartnerAccount(Id accountId, String partnerType) {
        debug('getPartnerAccount : accountId = ' + accountId + ' : ' + partnerType);
        Map<String, List<Id>> pmap = getPartnerIds(accountId);
        Map<Id, Account> amap = getAccountsMap(pmap);
        return getPartnerAccount(pmap, amap, partnerType);
    }

    public static Account getPartnerAccount(Map<String, List<Id>> pmap,
                                            Map<Id, Account> amap, String partnerType) {
        debug('getPartnerAccount');
        if (pmap == null || pmap.isEmpty() ||
            amap == null || amap.isEmpty()) {return null;}
        if (pmap.containsKey(partnerType)) {
            for (Id accId : pmap.get(partnerType)) {
                if (amap.containsKey(accId)) {return amap.get(accId);}
            }
        }
        return null;
    }

    public static Id getPartnerId(Map<Id, Map<String, List<Id>>> partnerMap,
                                  Id accid, String accType) {
        debug('getPartnerId : accountId = ' + accid + ' : ' + accType);
        Id partnerId = accid;
        Map<String, List<Id>> partnerIds = partnerMap.get(accid);
        if (partnerIds.containsKey(accType)) {
            List<Id> ilist = partnerIds.get(accType);
            //if (!ilist.isEmpty()) {partnerId = ilist[0];}
            for (Id i : ilist) {
                if (i != accId){partnerId = i; break;}
            }
        }
        return partnerId;
    }

    public static Id getPartnerId(Map<String, Set<Id>> partnerIds,
                                  Id accid, String accType) {
        debug('getPartnerId : accountId = ' + accid + ' : ' + accType);
        Id partnerId = accid; List<Id> ilist = new List<Id>();
        if (partnerIds.containsKey(accType)) {
            ilist.addAll(partnerIds.get(accType));
            for (Id i : ilist) {
                if (i != accId){partnerId = i; break;}
            }
        }
        return partnerId;
    }

    public static Map<Id, Account> getSoldTos(Set<Id> accountIds) {
        debug('getSoldTos');
        Map<Id, Account> smap1 = new Map<Id, Account>();
        if (accountIds == null || accountIds.isEmpty()) {return smap1;}
        Map<Id, Map<String, List<Id>>> pmap1 = getPartnerIds(accountIds);
        Map<String, List<Id>> pmap2; Map<Id, Id> smap2 = new Map<Id, Id>();
        Set<Id> soldToIds = new Set<Id>(); Id soldToId;
        for (Id accId : accountIds) {
            if (!pmap1.containsKey(accId)) {continue;}
            pmap2 = pmap1.get(accId);
            if (pmap2.containsKey(ACC_TYPE_SOLDTO) &&
               !pmap2.get(ACC_TYPE_SOLDTO).isEmpty()) {
                soldToId = pmap2.get(ACC_TYPE_SOLDTO)[0];
                smap2.put(accId, soldToId);
                soldToIds.add(soldToId);
            }
        }
        if (soldToIds.isEmpty()) {return smap1;}
        Map<Id, Account> smap3 = getAccountsMap(soldToIds);
        for (Id accId : accountIds) {
            if (smap2.containsKey(accId)) {
                soldToId = smap2.get(accId);
                if (smap3.containsKey(soldToId)) {
                    smap1.put(accId, smap3.get(soldToId));
                }
            }
        }
        return smap1;
    }

    public static String getPaymentTermCode(Id accountId) {
        debug('getPaymentTermCode : accountId = ' + accountId);
        String ptc = null;
        Account acc = getAccount(accountId);
        if (acc == null || isProspect(acc)) {return DEF_PMT_TERM;}
        ptc = acc.SAP_Payment_Terms__c;
        if (String.isBlank(ptc)) {
            acc = getSoldTo(accountId);
            if (acc == null) {return DEF_PMT_TERM;}
            ptc = acc.SAP_Payment_Terms__c;
            if (String.isBlank(ptc)) {return DEF_PMT_TERM;}
        }
        return ptc;
    }

// ---------------------------------------------------------------------------------
    public static String getAccountHierarchyXml(String accountId) {
        debug('getAccountHierarchyXml : accountId = ' + accountId);
        return getAccountHierarchyXml(accountId, true);
    }

    public static String getAccountHierarchyXml(String accountId,
                                                Boolean excludeInactiveAccounts) {
        debug('getAccountHierarchyXml : accountId = ' + accountId + ' : ' + excludeInactiveAccounts);
        Id tempId = accountId; accountId = tempId;
        String xml = XML_ROOT_BEGIN + XML_ROOT_END;
        //Account a = [select Id, ParentId from Account where Id = :accountId];
        //if (a == null) {return xml;}
        Set<Id> aset = new Set<Id>();
        List<String> alist = getPartnerList(accountId, aset, excludeInactiveAccounts);
        Map<Id, Account> amap = getAccountsMap(aset);
        List<Account1> a1s = getAccount1List(accountId, alist, amap, excludeInactiveAccounts);

        if (a1s != null && !a1s.isEmpty()) {
            xml = XML_ROOT_BEGIN;
            for (Account1 a1 : a1s) {
                if (tooManyScriptStatements()) {break;}
                setAccountsInfo(a1, amap);
                xml += a1.xmlString;
            }
            xml += XML_ROOT_END;
        }
        
        debug('xml : ' + xml);
        return xml;
    }

    private static void setAccountsInfo(Account1 a1, Map<Id, Account> amap) {
        debug('setAccountsInfo');
        if (amap == null || amap.isEmpty()) {return;}
        XmlStreamWriter xsw = new XmlStreamWriter();
        if (a1.acc.accountId != null) {
            writeStartElement(xsw, 'UltParnt');
            setAccountInfo(ACC_TYPE_SUPACC, a1.acc, amap, xsw);
        }
        if (a1.a2s != null && !a1.a2s.isEmpty()) {setAccount2Info(a1.a2s, amap, xsw);}
        if (a1.a3s != null && !a1.a3s.isEmpty()) {setAccount3Info(a1.a3s, amap, xsw);}
        if (a1.acc.accountId != null) {xsw.writeEndElement();}
        a1.xmlString = xsw.getXmlString();
        xsw.close();
    }

    private static void setAccount2Info(List<Account2> a2s, Map<Id, Account> amap,
                                        XmlStreamWriter xsw) {
        debug('setAccounts2Info');
        for (Account2 a2 : a2s) {
            if (tooManyScriptStatements()) {break;}
            if (a2.acc.accountId != null) {
                writeStartElement(xsw, 'CorpAcct');
                setAccountInfo(ACC_TYPE_CHERKY, a2.acc, amap, xsw);
            }
            if (a2.a3s != null && !a2.a3s.isEmpty()) {setAccount3Info(a2.a3s, amap, xsw);}
            if (a2.acc.accountId != null) {xsw.writeEndElement();}
        }
    }

    private static void setAccount3Info(List<Account3> a3s, Map<Id, Account> amap,
                                        XmlStreamWriter xsw) {
        debug('setAccounts3Info');
        for (Account3 a3 : a3s) {
            if (tooManyScriptStatements()) {break;}
            if (a3.acc.accountId != null) {
                writeStartElement(xsw, 'SoldTo');
                setAccountInfo(ACC_TYPE_SOLDTO, a3.acc, amap, xsw);
            }
            for (Account4 a4 : a3.a4s) {
                if (tooManyScriptStatements()) {break;}
                if (a4.acc.accountId != null) {
                    writeStartElement(xsw, 'ShipTo');
                    setAccountInfo(ACC_TYPE_SHIPTO, a4.acc, amap, xsw);
                    xsw.writeEndElement();
                }
            }
            if (a3.acc.accountId != null) {xsw.writeEndElement();}
        }
    }

    private static Boolean isInactiveAccount(Account a) {
        return ('No'.equals(a.Active_Account__c) || a.Inactive_Account__c);
    }

    private static void setAccountInfo(String accountType,
                                       AccountClass ac,
                                       Map<Id, Account> amap,
                                       XmlStreamWriter xsw) {
        Boolean isInactive = false;
        String accountNumber = '', billingStreet = '';
        debug('setAccountInfo : ' + ac);
        if (ac != null && amap.containsKey(ac.accountId)) {
            Account a = amap.get(ac.accountId);
            ac.accountName = a.Name;
            ac.accountNumber = a.AccountNumber;
            ac.accountType = accountType;
            isInactive = isInactiveAccount(a);
            //debug(''+ac);
            accountNumber = String_Functions.removeLeadingZeros(a.AccountNumber);
            if (a.BillingStreet != null) {
                billingStreet = a.BillingStreet.replaceAll('\n', ', ');
            }
            writeAttribute(xsw, 'SourceAccountId', ac.SourceAccId);
            writeAttribute(xsw, 'isInactive', getString(isInactive));
            writeAttribute(xsw, 'isSourceAcc', getString(ac.isSourceAcc));
            writeAttribute(xsw, 'isViewngAcc', getString(ac.isViewngAcc));
            writeAttribute(xsw, 'AccountId', a.Id);
            writeAttribute(xsw, 'AccountName', getAccountName(a));
            writeAttribute(xsw, 'AccountName2', getString(a.SAP_Account_Name_2__c));
            writeAttribute(xsw, 'AccountNumber', getString(accountNumber));
            writeAttribute(xsw, 'AccountType', getString(accountType));
            writeAttribute(xsw, 'BillingCity', getString(a.BillingCity));
            writeAttribute(xsw, 'BillingCountry', getString(a.BillingCountry));
            writeAttribute(xsw, 'BillingPostalCode', getString(a.BillingPostalCode));
            writeAttribute(xsw, 'BillingState', getString(a.BillingState));
            writeAttribute(xsw, 'BillingStreet', getString(billingStreet));
            writeAttribute(xsw, 'CustGroup1', getString(a.SAP_Customer_Group_1_Desc__c));
            writeAttribute(xsw, 'CustGroup', getString(a.SAP_Customer_Group_Desc__c));
            writeAttribute(xsw, 'DistChanCode', getString(a.SAP_DistChannel__c));
            writeAttribute(xsw, 'DistChanDesc', getString(a.SAP_Dist_Channel_Desc__c));
            writeAttribute(xsw, 'DivisionCode', getString(a.SAP_DivisionCode__c));
            writeAttribute(xsw, 'DivisionDesc', getString(a.SAP_Division_Desc__c));
            writeAttribute(xsw, 'OwnerName', getString(a.Owner.Name));
            writeAttribute(xsw, 'SalesDstDesc', getString(a.SAP_Sales_District_Desc__c));
            writeAttribute(xsw, 'SalesGrpDesc', getString(a.SAP_Sales_Group_Desc__c));
            writeAttribute(xsw, 'SalesOfcDesc', getString(a.SAP_Sales_Office_Desc__c));
            writeAttribute(xsw, 'SalesorgCode', getString(a.SAP_Sales_Org__c));
            writeAttribute(xsw, 'SalesorgDesc', getString(a.SAP_Sales_Org_Desc__c));
        }
    }

    private static String getAccountName(Account a) {
        String s = a.Name;
        if (isNotNull(a.NameLocal)) {s += ' (' + a.NameLocal + ')';}
        return s;
    }

    private static String getString(Object o) {
        String s = ''; if (o != null) {s = '' + o;} return s;
    }

    private static Boolean isNotNull(String s) {
        return (s != null && s.trim().length() > 0);
    }

    private static void writeAttribute(XmlStreamWriter xsw, String n, String v) {
        xsw.writeAttribute(null, null, n, v);
    }

    private static void writeElement(XmlStreamWriter xsw, String e, String c) {
        writeStartElement(xsw, e);
        if (isNotNull(c)) {xsw.writeCharacters(c.trim());}
        xsw.writeEndElement();
    }

    private static void writeStartElement(XmlStreamWriter xsw, String s) {
        xsw.writeStartElement(null, s, null);
    }

    private static void writeEmptyElement(XmlStreamWriter xsw, String s) {
        xsw.writeEmptyElement(null, s, null);
    }

    webservice static ReturnClass getAccountHierarchy(String accountId,
                                                      Boolean excludeInactiveAccounts) {
        ReturnClass rc = new ReturnClass();
        if (excludeInactiveAccounts == null) {excludeInactiveAccounts = true;}
        rc.accountHierarchyXml = getAccountHierarchyXml(accountId, excludeInactiveAccounts);
        return rc;
    }

}