global class Account_Hierarchy_Functions {

    private static final String CLAZZ = 'Account_Hierarchy_Functions';
    
    public static final String DELIM = CISRelationships_Functions.DELIM;
    public static final String ACC_TYPE_BILLTO = CISRelationships_Functions.BILLTO;
    public static final String ACC_TYPE_PAYER  = CISRelationships_Functions.PAYER;
    public static final String ACC_TYPE_SHIPTO = CISRelationships_Functions.SHIPTO;
    public static final String ACC_TYPE_SOLDTO = CISRelationships_Functions.SOLDTO;
    public static final String ACC_TYPE_CHERKY = CISRelationships_Functions.CHERKY;
    public static final String XML_ROOT_ELEMNT = 'AccountHierarchy';
    public static final String XML_ROOT_BEGIN = '<'+XML_ROOT_ELEMNT+'>';
    public static final String XML_ROOT_END = '</'+XML_ROOT_ELEMNT+'>';
    public static final Integer MAX_SIZE = 400;

    public static final Set<String> XML_ACC_TYPES = new Set<String>{ACC_TYPE_SOLDTO, ACC_TYPE_SHIPTO};

    global class ReturnClass {
    
        webservice CHerkyAccount accountHierarchy;
        webservice String accountHierarchyXml;
        webservice String returnMessage = '';
    }

    private static void debug(String s) {
    	DebugLog_Functions.info(CLAZZ + ' : ' + s);
    }
    
    private static Boolean notNull(String s) {
        return (s != null && s.trim().length() > 0);
    }
    
    private static Boolean tooManyScriptStatements() {
    	return (Limits.getScriptStatements() > (Limits.getLimitScriptStatements()-200));
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
            sourceAccId = srcAccId; accountId = accId; 
            isSourceAcc = (accId != null && accId.equals(srcAccId));
            isViewngAcc = isSourceAcc;
        }
    }
    
    global class CHerkyAccount {
        webservice AccountClass acc;
        webservice List<SoldToAccount> soldToAccounts;
        public String xmlString;
        public CHerkyAccount() {this(null, null);}
        public CHerkyAccount(String srcAccId, String accountId) {init(srcAccId, accountId);}
        private void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            soldToAccounts = new List<SoldToAccount>();
            //debug('CHerkyAccount : '+acc);
        }
    }
    
    global class SoldToAccount {
        webservice AccountClass acc;
        webservice List<ShipToAccount> shipToAccounts;
        public SoldToAccount() {this(null, null);}
        public SoldToAccount(String srcAccId, String accountId) {init(srcAccId, accountId);}
        private void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            shipToAccounts = new List<ShipToAccount>();
            //debug('SoldToAccount : '+acc);
        }
    }
    
    global class ShipToAccount {
        webservice AccountClass acc;
        public ShipToAccount() {this(null, null);}
        public ShipToAccount(String srcAccId, String accountId) {init(srcAccId, accountId);}
        private void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            //debug('ShipToAccount : '+acc);
        }
    }

    public static String getAccountHierarchyXml(String accountId) {
        return getAccountHierarchyXml(accountId, false);
    }
    
    public static String getAccountHierarchyXml(String accountId,
                                                Boolean excludeInactiveAccounts) {
        debug('accountId = ' + accountId + ' : excludeInactiveAccounts = ' + excludeInactiveAccounts);
        Id tempId = accountId; accountId = tempId;
        String xml = XML_ROOT_BEGIN + XML_ROOT_END;
        List<String> alist = new List<String>();
        Account a = [select Id, ParentId from Account where Id = :accountId];
        if (a == null) {return xml;}
        Set<Id> accountIds = new Set<Id>();
        if (a.ParentId != null) {accountIds.add(a.ParentId);} else {accountIds.add(accountId);}
        Map<Id, Map<String, List<Id>>> pmap;
        pmap = CISRelationships_Functions.getPartnerIds(accountIds);
        if (pmap == null || pmap.isEmpty()) {
        	//return xml;
            pmap = new Map<Id, Map<String, List<Id>>>();
            setPartnerIdMap(pmap, accountId, ACC_TYPE_BILLTO);
        }
        Map<Id, Account> amap = CISRelationships_Functions.getAccountsMap(pmap);
        Set<String> aset = new Set<String>(); Map<String, List<Id>> tmap;
        for (String k : pmap.keySet()) {
        	tmap = pmap.get(k);
        	aset.addAll(getAccountSet(k, tmap, amap, excludeInactiveAccounts));
        }
        alist = getAccountList(accountId, aset);
        List<CHerkyAccount> chs = getCHerkyAccounts(accountId, alist);
        if (chs != null && !chs.isEmpty()) {
        	xml = XML_ROOT_BEGIN;
        	for (CHerkyAccount cha : chs) {
                if (tooManyScriptStatements()) {break;}
                setAccountsInfo(cha, amap);
                xml += cha.xmlString;
        	}
        	xml += XML_ROOT_END;
        }
        return xml;
    }
    
    private static void setPartnerIdMap(Map<Id, Map<String, List<Id>>> pmap, String accountId, String accType) {
    	Id accId = accountId;
    	Map<String, List<Id>> amap = new Map<String, List<Id>>();
    	List<Id> ids = new List<Id>{accId};
    	amap.put(accType, ids); pmap.put(accId, amap);
    }

    public static void setCustomerHierarchyIds(List<Account> accs) {
    	setCustomerHierarchyIds(accs, false);
    }
    
    public static void setCustomerHierarchyIds(List<Account> accs,
                                               Boolean updateAccs) {
        List<String> alist;
        List<CHerkyAccount> chs;
        Map<Id, Map<String, List<Id>>> pmap;
        Map<String, Account> accMap1 = new Map<String, Account>(), 
                             accMap2 = new Map<String, Account>();  
        Set<String> aset = new Set<String>();
        Set<Id> accIds = new Set<Id>();
        for (Account a : accs) {accIds.add(a.Id); accMap1.put(a.Id, a);}
        List<Account> alist1 = [select ParentId from Account where Id in :accIds];
        accIds = new Set<Id>();
        for (Account a : alist1) {
        	if (a.ParentId != null) accIds.add(a.ParentId); else accIds.add(a.Id);
        }
        if (accIds.isEmpty()) {return;}
        pmap = CISRelationships_Functions.getPartnerIds(accIds);
        if (pmap == null || pmap.isEmpty()) {return;}
        Map<Id, Account> amap = CISRelationships_Functions.getAccountsMap(pmap);
        Map<String, List<Id>> tmap; Boolean excludeInactiveAccounts = false;
        for (String k : pmap.keySet()) {
            tmap = pmap.get(k);
        	aset.addAll(getAccountSet(k, tmap, amap, excludeInactiveAccounts));
        }
        for (String accId : accIds) {
	        alist = getAccountList(accId, aset);
	        chs = getCHerkyAccounts(accId, alist);
	        if (chs == null || chs.isEmpty()) {continue;}
            for (CHerkyAccount cha : chs) {
		        for (SoldToAccount soa : cha.soldToAccounts) {
		            setCustomerHierarchyId(soa.acc, cha, accMap1, accMap2);
		            for (ShipToAccount sha : soa.shipToAccounts) {
                        setCustomerHierarchyId(sha.acc, cha, accMap1, accMap2);
		            }
		        }
            }
        }
        debug('setCustomerHierarchyIds : ' + accMap2.size());
        if (updateAccs && !accMap2.isEmpty()) {
        	try {update accMap2.values();} catch(Exception e) {debug(e.getMessage());}
        }
    }
    
    private static void setCustomerHierarchyId(AccountClass acc,
                                               CHerkyAccount cha, 
                                               Map<String, Account> accMap1,
                                               Map<String, Account> accMap2) {
        String accId = acc.accountId, chaId = cha.acc.accountId;
    	if (accId != null && chaId != null) { 
            Account a;
    	    if (accMap1.containsKey(accId)) {
	    		a = accMap1.get(accId);
	    		a.Customer_Hierarchy_Account__c = chaId;
    	    } else {
    	    	a = new Account(Id = accId, Customer_Hierarchy_Account__c = chaId);
                accMap2.put(accId, a);
    	    }
    		debug('setCustomerHierarchyId : ' + a);
    	}
    }
    
    private static List<String> getAccountList(String accountId, Set<String> aset) {
        List<String> alist = new List<String>(); List<String> sa;
        List<String> blist = new List<String>(); 
        blist.addAll(aset); blist.sort();
        for (String s : blist) {
            sa = s.split(DELIM); if (sa.isEmpty()) {continue;}
            String ch, so, sh, bt, k1 = '2', k2 = '2', k3 = '2', k4 = '2';
            if (sa.size() > 7 && notNull(sa[7])) {
                bt = sa[7]; sh = sa[5]; so = sa[3]; ch = sa[1];
                if ((bt != null && bt == accountId) ||
                    (sh != null && sh == accountId) || 
                    (so != null && so == accountId) ||
                    (ch != null && ch == accountId)) {
                    if (ch != null && ch == accountId) {k1 = '1';}
                    if (so != null && so == accountId) {k2 = '1';}
                    if (sh != null && sh == accountId) {k3 = '1';}
                    if (bt != null && bt == accountId) {k4 = '1';}
                    alist.add(k1 + DELIM + sa[0] + DELIM + sa[1] + DELIM +
                              k2 + DELIM + sa[2] + DELIM + sa[3] + DELIM +
                              k3 + DELIM + sa[4] + DELIM + sa[5] + DELIM +
                              k4 + DELIM + sa[6] + DELIM + sa[7]);
                }
            } else
            if (sa.size() > 5 && notNull(sa[5])) {
            	sh = sa[5]; so = sa[3]; ch = sa[1];
            	if ((sh != null && sh == accountId) || 
            	    (so != null && so == accountId) ||
            	    (ch != null && ch == accountId)) {
            	    if (ch != null && ch == accountId) {k1 = '1';}
                    if (so != null && so == accountId) {k2 = '1';}
                    if (sh != null && sh == accountId) {k3 = '1';}
            	    alist.add(k1 + DELIM + sa[0] + DELIM + sa[1] + DELIM +
            	              k2 + DELIM + sa[2] + DELIM + sa[3] + DELIM +
            	              k3 + DELIM + sa[4] + DELIM + sa[5]);
                }
            } else
            if (sa.size() > 3 && notNull(sa[3])) {
            	so = sa[3]; ch = sa[1];
                if ((so != null && so == accountId) ||
                    (ch != null && ch == accountId)) {
                    if (ch != null && ch == accountId) {k1 = '1';}
                    if (so != null && so == accountId) {k2 = '1';}
                    alist.add(k1 + DELIM + sa[0] + DELIM + sa[1] + DELIM +
                              k2 + DELIM + sa[2] + DELIM + sa[3]);
                }
            } else 
            if (sa.size() > 1 && notNull(sa[1])) {
            	ch = sa[1];
                if (ch != null && ch == accountId) {k1 = '1';
                    alist.add(k1 + DELIM + sa[0] + DELIM + sa[1]);
                }
            } 
        }
        alist.sort();
        for (String s : alist) {debug('getAccountList : ' + s);}
        return alist;
    }

    private static Set<String> getAccountSet(String accountId, 
                                             Map<String, List<Id>> partnerIdMap, 
                                             Map<Id, Account> accountMap,
                                             Boolean excludeInactiveAccounts) {
        Set<String> accountSet = new Set<String>(); List<Id> partnerIds;
        debug('getAccountSet:accountId=' + accountId);
        Account acc = accountMap.get(accountId), partner;
        if (acc == null || partnerIdMap == null || 
           (excludeInactiveAccounts && isInactiveAccount(acc))) {return accountSet;}
        String cherkyId = acc.ParentId, soldtoId, shiptoId, s;
        for (String partnerType : partnerIdMap.keySet()) {
            debug('getAccountSet:partnerType=' + partnerType);
        	if (!XML_ACC_TYPES.contains(partnerType)) {continue;}
        	partnerIds = partnerIdMap.get(partnerType);
            for (String partnerId : partnerIds) {
                debug('getAccountSet:partnerId=' + partnerId);
                if (!accountMap.containsKey(partnerId)) {continue;}
                partner = accountMap.get(partnerId);
                if (partner.ParentId != null) {cherkyId = partner.ParentId;}
                debug('getAccountSet1:partnerType='+partnerType+
                      ':partnerNumId='+getAccountKeyId(partnerId, accountMap)+
                      ':accountId='+accountId+':partnerIds.size='+partnerIds.size()+
                      ':partnerIdMap.size='+partnerIdMap.size());
                soldtoId = null; shiptoId = null;
                if (partnerType.equals(ACC_TYPE_SHIPTO)) {
                    if (excludeInactiveAccounts && isInactiveAccount(partner)) {continue;}
                	shiptoId = partnerId;
                	if (partnerIds.size() > 1) {soldtoId = accountId;} 
                	debug('getAccountSet2:soldtoId=' + soldtoId + ':shiptoId='+shiptoId);
                } else
                if (partnerType.equals(ACC_TYPE_SOLDTO)) {
                    if (excludeInactiveAccounts && isInactiveAccount(acc)) {continue;}
                	soldtoId = partnerId;
                	shiptoId = accountId; 
                    debug('getAccountSet3:soldtoId=' + soldtoId + ':shiptoId='+shiptoId);
                }
                //if (soldtoId == null) {continue;}
                s = getAccountKeyId(cherkyId, accountMap) + DELIM +
                    getAccountKeyId(soldtoId, accountMap) + DELIM +
                    getAccountKeyId(shiptoId, accountMap);
                if (partnerType.equals(ACC_TYPE_BILLTO)) {
                	s += DELIM + getAccountKeyId(accountId, accountMap);
                }
                if (!accountSet.contains(s)) {
	                debug('getAccountSet4:'+accountId+':'+s);
	                accountSet.add(s);
                }
                debug('');
            }
        }
        return accountSet;
    }

    private static String getAccountKeyId(Id accountId, Map<Id, Account> amap) {
        String s = DELIM;
        if (accountId != null && amap.containsKey(accountId)) {
            Account a = amap.get(accountId); 
            s = a.AccountNumber + DELIM + accountId;
        }
        //debug('getAccountKeyId : ' + s);
        return s;
    }
    
    private static List<CHerkyAccount> getCHerkyAccounts(String accountId, 
                                                         List<String> plist) {
        Id tempId = accountId; accountId = tempId;
        List<String> sa; String och = '', oso = '', osh = '', obt = '';
        CHerkyAccount cha; SoldToAccount soa; ShipToAccount sha;
        List<CHerkyAccount> chs = new List<CHerkyAccount>();
        for (String s : plist) {
            sa = s.split(DELIM); if (sa.isEmpty()) {continue;}
            String ch, so, sh, bt;
            if (sa.size() > 2 && notNull(sa[2])) {ch = sa[2];} 
            if (sa.size() > 5 && notNull(sa[5])) {so = sa[5];} 
            if (sa.size() > 8 && notNull(sa[8])) {sh = sa[8];}
            if (sa.size() > 11 && notNull(sa[11])) {bt = sa[11];}
            debug('getCHerkyAccounts:ch='+ch+':so='+so+':sh='+sh+':bt='+bt);
            if (bt != null && !bt.equals(obt)) {
                obt = bt; cha = new CHerkyAccount(accountId, bt); 
                cha.acc.accountType = ACC_TYPE_BILLTO; chs.add(cha);
            } 
            if (ch != null && !ch.equals(och)) {
                och = ch; oso = '';
                cha = new CHerkyAccount(accountId, ch);
                chs.add(cha);
            } 
            if (so != null && !so.equals(oso)) {
                oso = so; osh = '';
                soa = new SoldToAccount(accountId, so);
                if (ch == null || cha == null) {cha = new CHerkyAccount(); chs.add(cha);}
                if(soa.acc.isSourceAcc) {cha.acc.isSourceAcc = false;}
                cha.soldToAccounts.add(soa);
            } 
            if (sh != null && !sh.equals(osh)) {
                osh = sh;
                sha = new ShipToAccount(accountId, sh);
                if (so == null || soa == null) {
                    soa = new SoldToAccount();
                    if (ch == null || cha == null) {cha = new CHerkyAccount(); chs.add(cha);}
                    cha.soldToAccounts.add(soa);
                }
                if(sha.acc.isSourceAcc) {soa.acc.isSourceAcc = false;}
                soa.shipToAccounts.add(sha);
            } 
        }
        return chs;
    }

    private static void setAccountsInfo(CHerkyAccount cha, 
                                        Map<Id, Account> amap) {
        if (amap == null || amap.isEmpty()) {return;}
        XmlStreamWriter xsw = new XmlStreamWriter();
        if (cha.acc.accountId != null) {
        	if (cha.acc.accountType != null && 
        	    cha.acc.accountType.equals(ACC_TYPE_BILLTO)) {
                writeStartElement(xsw, 'BillTo');
                setAccountInfo(ACC_TYPE_BILLTO, cha.acc, amap, xsw);
        	} else {
	            writeStartElement(xsw, 'CorpAcct');
	            setAccountInfo(ACC_TYPE_CHERKY, cha.acc, amap, xsw);
        	}
        }
        for (SoldToAccount soa : cha.soldToAccounts) {
            if (tooManyScriptStatements()) {break;}
            if (soa.acc.accountId != null) {
                writeStartElement(xsw, 'SoldTo');
                setAccountInfo(ACC_TYPE_SOLDTO, soa.acc, amap, xsw);
            }
            for (ShipToAccount sha : soa.shipToAccounts) {
                if (tooManyScriptStatements()) {break;}
                if (sha.acc.accountId != null) {
                    writeStartElement(xsw, 'ShipTo');
                    setAccountInfo(ACC_TYPE_SHIPTO, sha.acc, amap, xsw);
                    xsw.writeEndElement();
                }
            }
            if (soa.acc.accountId != null) {xsw.writeEndElement();}
        }
        if (cha.acc.accountId != null) {xsw.writeEndElement();}
        cha.xmlString = xsw.getXmlString();
        xsw.close();
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
            writeAttribute(xsw, 'AccountNumber', accountNumber);
            writeAttribute(xsw, 'AccountType', accountType);
            writeAttribute(xsw, 'BillingCity', getString(a.BillingCity));
            writeAttribute(xsw, 'BillingCountry', getString(a.BillingCountry));
            writeAttribute(xsw, 'BillingPostalCode', getString(a.BillingPostalCode));
            writeAttribute(xsw, 'BillingState', getString(a.BillingState));
            writeAttribute(xsw, 'BillingStreet', billingStreet);
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
        if (excludeInactiveAccounts == null) {excludeInactiveAccounts = false;}
        rc.accountHierarchyXml = getAccountHierarchyXml(accountId, excludeInactiveAccounts);
        return rc;
    }

}