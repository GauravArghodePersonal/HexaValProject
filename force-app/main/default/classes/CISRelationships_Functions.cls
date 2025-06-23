public class CISRelationships_Functions {

    private static final String CLAZZ = 'CISRelationships_Functions';
    
    public static final String PRSPCT = 'Prospect';
    public static final String BILLTO = 'Bill To';
    public static final String PAYER  = 'Payer';
    public static final String SHIPTO = 'Ship To';
    public static final String SOLDTO = 'Sold To';
    public static final String CHERKY = 'Corp Acct';
    public static final String DEF_PT = 'Z030'; // default payment term code
    public static final String DELIM = ':';
    public static final String NEXEO_DC = '30';
    public static final String NEXEO_G2 = 'G2';
    public static final List<String> ACCOUNT_TYPES = new List<String>{CHERKY, SOLDTO, SHIPTO, BILLTO, PAYER};
    public static final String KNA1_RTID = RecordType_Functions.lookupRecordTypeId('KNA1', 'Account');
    
    private static final Integer MAX_RECS = 1000;
    
    private static void debug(String s) {
        DebugLog_Functions.info(CLAZZ + ' : ' + s);
    }
    
    private static Boolean isNull(String s) {
    	return (s == null || s.trim().length() == 0);
    }
    
    private static Boolean isProspect(Account acc) {
    	return (acc != null && acc.AccountNumber != null && 
    	        acc.AccountNumber.startsWith('P'));
    }
    
    public static String getPaymentTermCode(Id accountId) {
    	String ptc = null;
    	Account acc = getAccount(accountId);
    	if (acc == null || isProspect(acc)) {return DEF_PT;}
    	ptc = acc.SAP_Payment_Terms__c;
    	if (isNull(ptc)) {
    		acc = getSoldTo(accountId);
    		if (acc == null) {return DEF_PT;}
            ptc = acc.SAP_Payment_Terms__c;
            if (isNull(ptc)) {return DEF_PT;}
    	}
    	return ptc;
    }
    
    // Map<Id, Map<PartnerType, List<Id>>>
    public static Map<Id, Map<String, List<Id>>> getPartnerIds(Set<Id> accountIds) {
        Map<Id, Map<String, List<Id>>> amap = getCHerkyPartnerIds(accountIds);
        if (amap == null || amap.isEmpty()) {amap = getPartnerIdMap(accountIds);}
        return amap;
    }
    
    private static Map<Id, Map<String, List<Id>>> getCHerkyPartnerIds(Set<Id> cherkyIds) {
        Map<Id, Map<String, List<Id>>> amap = new Map<Id, Map<String, List<Id>>>();
    	Set<Id> accountIds = new Set<Id>();
    	try {
        	for (Account a : [select Id, AccountNumber from Account where ParentId in :cherkyIds]) {
        		if (a.AccountNumber != null && !a.AccountNumber.startswith('P')) {accountIds.add(a.Id);}
        	}
        	if (!accountIds.isEmpty()) {amap = getPartnerIdMap(accountIds);}
    	} catch(Exception e) {}
    	return amap;
    }

    // Map<Id, Map<PartnerType, List<Id>>>
    private static Map<Id, Map<String, List<Id>>> getPartnerIdMap(Set<Id> accountIds) {
        Map<Id, Map<String, List<Id>>> amap = new Map<Id, Map<String, List<Id>>>();
        if (accountIds == null || accountIds.isEmpty()) {return amap;}
        Map<String, List<Id>> smap = new Map<String, List<Id>>();
        Map<String, List<Id>> tmap = new Map<String, List<Id>>();
        Map<Id, Map<String, Set<String>>> pnmap = new Map<Id, Map<String, Set<String>>>();
        Map<String, Set<String>> ptmap = new Map<String, Set<String>>();
        Set<String> cnset = new Set<String>();
        debug('getPartnerIdMap : ' + accountIds);
        for (CISRelationships__c cr : [select Customer_Number__c,
                                              Customer_Type__c,
                                              Ext_Unique_ID_c__c,
                                              Source_Customer__c,
                                              Source_Customer_AccountNumber__c,
                                              Source_Customer_ParentId__c,
                                              Source_Customer_SAP_Dist_Channel__c,
                                              Source_Customer_SAP_Division_Code__c,
                                              Source_Customer_SAP_Partner_Functions__c,
                                              Source_Customer_SAP_Sales_Org__c,
                                              Target_Customer__c,
                                              Target_Customer_AccountNumber__c,
                                              Target_Customer_ParentId__c,
                                              Target_Customer_SAP_Dist_Channel__c,
                                              Target_Customer_SAP_Division_Code__c,
                                              Target_Customer_SAP_Sales_Org__c
                                         from CISRelationships__c
                                        where Customer_Type__c in :ACCOUNT_TYPES
                                          //and Target_Customer__c != null
                                          and (Source_Customer__c in :accountIds or
                                               Target_Customer__c in :accountIds)
                                     order by Source_Customer_AccountNumber__c,
                                              Target_Customer_AccountNumber__c
                                      ]) {
            debug(getCISRelationshipString(cr));

            setPartnerNums(cr, cnset, pnmap);
        }
        amap = getPartnerIdMap2(cnset, pnmap);
        // Prospects
        Set<Id> pset = getProspectIds(accountIds);
        for (Id accId : accountIds) {
            if (!amap.containsKey(accId) && pset.contains(accId)) {
                smap = new Map<String, List<Id>>();
                setPartnerId(PRSPCT, accId, smap);
                amap.put(accId, smap);
            }
        }
        return amap;
    }
    
    private static String getCISRelationshipString(CISRelationships__c cr) {
    	return  
        ' : RecKey = ' + cr.Ext_Unique_ID_c__c +
    	' : Source = ' + cr.Source_Customer_AccountNumber__c + '-' + cr.Source_Customer__c + 
        ' : AccNum = ' + cr.Customer_Number__c + '-' + cr.Customer_Type__c +
    	' : Target = ' + cr.Target_Customer_AccountNumber__c + '-' + cr.Target_Customer__c +
    	' : Source_Customer_SAP_Partner_Functions__c = ' + cr.Source_Customer_SAP_Partner_Functions__c;
    }
    
    private static Set<Id> getProspectIds(Set<Id> accountIds) {
    	Set<Id> pset = new Set<Id>();
    	try {
	    	for (Account a : [select Id, AccountNumber 
	    	                    from Account where Id in :accountIds]) {
	    		if (isProspect(a)) {pset.add(a.Id);}
	    	}
    	} catch(Exception e) {}
    	return pset;
    }

    private static void setPartnerId(String ptype, Id pid, Map<String, List<Id>> pmap) {
        Set<Id> pset = new Set<Id>();
        if (pmap.containsKey(ptype)) {pset.addAll(pmap.get(ptype));}
        pset.add(pid);
        List<Id> plist = new List<Id>();
        plist.addAll(pset);
        debug('setPartnerId : ' + ptype + ':' + pid);
        pmap.put(ptype, plist);
    }

    private static void setPartnerNums(CISRelationships__c cr,
                                       Set<String> cnset,
                                       Map<Id, Map<String, Set<String>>> pnmap) {
        String sid = cr.Source_Customer__c, tid = cr.Target_Customer__c;
        Map<String, Set<String>> ptmap;  
        if (pnmap.containsKey(sid)) {ptmap = pnmap.get(sid);} 
        else {ptmap = new Map<String, Set<String>>(); pnmap.put(sid, ptmap);}
        Set<String> pnset; String ptype = cr.Customer_Type__c;
        
        if (ptmap.containsKey(ptype)) {pnset = ptmap.get(ptype);}
        else {pnset = new Set<String>(); ptmap.put(ptype, pnset);}
        String s = getCustomerNumber(cr, tid);
        cnset.add(s); pnset.add(s);
        
        debug('setPartnerNums1 : SourceId = ' + sid + ' : PartnerType = ' + ptype + ' : PartnerNum = ' + s);
        
        //*
        if (tid != null && tid.equals(sid) && ptype.equals(SHIPTO) &&
            cr.Source_Customer_SAP_Partner_Functions__c != null &&
            cr.Source_Customer_SAP_Partner_Functions__c.contains(SOLDTO)) {
            ptype = SOLDTO;
	        if (ptmap.containsKey(ptype)) {pnset = ptmap.get(ptype);}
	        else {pnset = new Set<String>(); ptmap.put(ptype, pnset);}
	        pnset.add(s);
            debug('setPartnerNums2 : SourceId = ' + sid + ' : PartnerType = ' + ptype + ' : PartnerNum = ' + s);
        }
        //*/  
    }
    
    private static String getCustomerNumber(CISRelationships__c cr, String pid) {
    	String cn = cr.Customer_Number__c, so, dc, dv;
        //if (cr.Source_Customer__c != null && cr.Source_Customer__c == pid) {
            so = cr.Source_Customer_SAP_Sales_Org__c; 
            dc = cr.Source_Customer_SAP_Dist_Channel__c; 
            dv = cr.Source_Customer_SAP_Division_Code__c;
        //} else
        if (cr.Target_Customer__c != null && cr.Target_Customer__c == pid) {
            so = cr.Target_Customer_SAP_Sales_Org__c; 
            dc = cr.Target_Customer_SAP_Dist_Channel__c; 
            dv = cr.Target_Customer_SAP_Division_Code__c;
        }
    	String s = cn; Integer n;
    	if (s != null && s.endsWith(NEXEO_G2)) {n = s.length(); s = s.substring(0, n-2);}
    	if (so != null) {s += so;}
        if (dc != null) {s += dc;}
        if (dv != null) {s += dv;}
        if (dc == NEXEO_DC) {s += NEXEO_G2;}
        //debug('getCustomerNumber : ' + s);
    	return s;
    }
    
    private static Map<Id, Map<String, List<Id>>> getPartnerIdMap2(
                                    Set<String> cnset,
                                    Map<Id, Map<String, Set<String>>> pnmap) {
        Map<Id, Map<String, List<Id>>> pimap = new Map<Id, Map<String, List<Id>>>();
        debug('cnset : ' + cnset);
        if (pnmap.isEmpty() || cnset.isEmpty()) {return pimap;}
        Map<Id, String> aimap = new Map<Id, String>(); // id, account number
        Map<String, Id> anmap = new Map<String, Id>(); // account number, id
        Map<String, Id> apmap = new Map<String, Id>(); // account number, parentId
        setAccountNumberIdMaps(cnset, aimap, anmap, apmap);
        Map<String, Set<String>> ptnmap;
        Map<String, List<Id>> ptimap; String s, an;
        Set<String> pnset; List<Id> plist, pilist; Set<Id> piset; Id acId, chId;
        Set<String> aset = new Set<String>(); String[] sa;
        for (Id pid : pnmap.keySet()) {
        	an = aimap.get(pid); chId = null;
        	if (apmap.containsKey(an)) {chId = apmap.get(an);}
        	ptnmap = pnmap.get(pid);
        	ptimap = new Map<String, List<Id>>();
        	piset = new Set<Id>();
            pilist = new List<Id>();
        	for (String pt : ptnmap.keySet()) {
        		pnset = ptnmap.get(pt);
        		plist = new List<Id>();
        		for (String pn : pnset) {
        			if (anmap.containsKey(pn)) {
        				sa = new String[]{'','',''}; //ch, so, sh
        				acId = anmap.get(pn);
        				plist.add(acId);
        				if (pt.equals(SHIPTO)) {sa[1] = pid; sa[2] = acId;} else
        				if (pt.equals(SOLDTO)) {sa[1] = acId; sa[2] = pid;}
                        if (apmap.containsKey(pn)) {chId = apmap.get(pn);}
                        if (chId != null) {piset.add(chId);	sa[0] = chId;}
                        s = sa[0]+':'+sa[1]+':'+sa[2]; aset.add(s);
                        debug('getPartnerIdMap2:'+pid+':'+s);
        			}
        		}
        		if (!plist.isEmpty()) {ptimap.put(pt, plist);}
                debug('getPartnerIdMap2:'+pt+':'+plist);
        	}

        	if (!piset.isEmpty()) {
        		pilist.addAll(piset);
        		ptimap.put(CHERKY, pilist);
        	}

        	if (!ptimap.isEmpty()) {pimap.put(pid, ptimap);}
        }
        return pimap;
    }
    
    private static void setAccountNumberIdMaps(Set<String> cnset,
                                               Map<Id, String> aimap,
                                               Map<String, Id> anmap,
                                               Map<String, Id> apmap) {
    	if (cnset == null || cnset.isEmpty()) {return;}
    	for (Account a : [select Id, ParentId, Account_Number__c 
    	                    from Account
    	                   where Account_Number__c in :cnset
    	                     and RecordTypeId != :KNA1_RTID]) {
    	    debug('setAccountNumberIdMaps : AccNum = ' + a.Account_Number__c + ' : Id = ' + a.Id + ' : ParentId = ' + a.ParentId);
            aimap.put(a.Id, a.Account_Number__c);
    		anmap.put(a.Account_Number__c, a.Id);
    		if (a.ParentId != null) {apmap.put(a.Account_Number__c, a.ParentId);}
    	}
    }
    
    public static Map<String, List<Id>> getPartnerIds(Id accountId) {
        Set<Id> accountIds = new Set<Id>{accountId};
        Map<Id, Map<String, List<Id>>> partnerIds = getPartnerIds(accountIds);
        if (partnerIds.containsKey(accountId)) {
            return partnerIds.get(accountId);
        }
        return null;
    }
    
    public static String getAccountType(Id accountId) {
        return '';
    }
    
    public static Id getSoldToId(Id accountId) {
    	Account acc = getSoldTo(accountId);
    	if (acc != null) {return acc.Id;}
    	return null;
    }
    
    public static Map<Id, Account> getAccountsMap(Map<String, List<Id>> partnerIds) {
    	Map<Id, Account> amap = new Map<Id, Account>();
        Set<Id> accountIds = new Set<Id>();
    	if (partnerIds != null) {
	        for (List<Id> s : partnerIds.values()) {accountIds.addAll(s);}
	        amap = getAccountsMap(accountIds);
    	}
    	return amap;
    }

    public static Map<Id, Account> getAccountsMap(Map<Id, Map<String, List<Id>>> partnerIds) {
        Set<Id> accountIds = new Set<Id>();
        for (Map<String, List<Id>> m : partnerIds.values()) {
            for (List<Id> s : m.values()) {
                accountIds.addAll(s);
            }
        }
        return getAccountsMap(accountIds);
    }

    public static Map<Id, Account> getAccountsMap(Set<Id> accountIds) {
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
                       SAP_Sales_Org_Desc__c
                  from Account
                 where Id in :accountIds]) {
                amap.put(a.Id, a);
            }
        }
        debug('getAccountsMap : amap = '+amap);
        return amap;
    }

    public static Account getAccount(Id accountId) {
        Map<Id, Account> amap = getAccountsMap(new Set<Id>{accountId});
        return amap.get(accountId);
    }
    
    public static Account getPayer(Id accountId) {
    	Account payerAcc = getPartnerAccount(accountId, PAYER);
    	if (payerAcc == null) {
    		Account soldtoAcc = getSoldTo(accountId);
    		if (soldtoAcc != null && soldtoAcc.Id != accountId) {
    			payerAcc = getPartnerAccount(soldtoAcc.Id, PAYER);
    		}
    	}
        return payerAcc;
    }

    public static Boolean isSoldTo(Id accountId) {
    	Account acc = getSoldTo(accountId);
    	return (acc != null && acc.Id == accountId);
    }
    
    public static Account getSoldTo(Id accountId) {
        return getPartnerAccount(accountId, SOLDTO);
    }

    public static Account getSoldTo(Map<String, List<Id>> pmap, Map<Id, Account> amap) {
        return getPartnerAccount(pmap, amap, SOLDTO);
    }
    
    public static Set<Id> getShipToIds(Id accountId) {
        return getPartnerIds(accountId, SHIPTO);
    }
    
    private static Set<Id> getPartnerIds(Id accountId, String partnerType) {
        Map<String, List<Id>> pmap = getPartnerIds(accountId);
        if (pmap == null || pmap.isEmpty() || !pmap.containsKey(partnerType)) {return null;}
        Set<Id> partnerIds = new Set<Id>(); partnerIds.addAll(pmap.get(partnerType));
    	return partnerIds;
    }

    public static Account getPartnerAccount(Id accountId, String partnerType) {
        Map<String, List<Id>> pmap = getPartnerIds(accountId);
        Map<Id, Account> amap = getAccountsMap(pmap);
        return getPartnerAccount(pmap, amap, partnerType);
    }

    public static Account getPartnerAccount(Map<String, List<Id>> pmap, 
                                            Map<Id, Account> amap, String partnerType) {
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
        Id partnerId = accid;
        Map<String, List<Id>> partnerIds = partnerMap.get(accid);
        if (partnerIds.containsKey(accType)) {
            List<Id> ilist = partnerIds.get(accType);
            if (!ilist.isEmpty()) {
                partnerId = ilist[0];
            }
        }
        return partnerId;
    }
    
    public static Map<Id, Account> getSoldTos(Set<Id> accountIds) {
    	Map<Id, Account> smap1 = new Map<Id, Account>();
        if (accountIds == null || accountIds.isEmpty()) {return smap1;}
    	Map<Id, Map<String, List<Id>>> pmap1 = getPartnerIds(accountIds);
    	Map<String, List<Id>> pmap2; Map<Id, Id> smap2 = new Map<Id, Id>();
    	Set<Id> soldToIds = new Set<Id>(); Id soldToId;
    	for (Id accId : accountIds) {
    		if (!pmap1.containsKey(accId)) {continue;}
    		pmap2 = pmap1.get(accId);
	        if (pmap2.containsKey(SOLDTO) && !pmap2.get(SOLDTO).isEmpty()) {
	        	soldToId = pmap2.get(SOLDTO)[0];
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
    
}