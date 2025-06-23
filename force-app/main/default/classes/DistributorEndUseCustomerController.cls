public class DistributorEndUseCustomerController {

    private static final String PIPE = '|';
    private static final String COMMA = ',';
    
    private static final Map<String, String> groupNames = new Map<String, String>{
    	'50' => 'AQ Dist Mgt Group'
    };
    
    public Boolean fromDistPage   {get; private set;}
    public Boolean fromListPage   {get; private set;}
    
    public String publicGroupName {get; set;}
    public String endUseCustomers {get; set;}
    public String distId          {get; private set;}
    public String distName        {get; private set;}
    
    private Id publicGroupId;
    private List<DistributorEndUseCustomer__c> distEndUseCusts;
    private List<AccountShare> accountShares;
    private Account distributor;
    
    private void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }
    
    public void initAction() {
    	fromDistPage = false;
    	distId = ApexPages.currentPage().getParameters().get('distId');
    	if (distId != null) {distributor = getAccount(distId);}
    	if (distributor != null) {fromDistPage = true;
    		publicGroupName = groupNames.get(distributor.SAP_DistChannel__c);
    		distName = distributor.Name + ' - ' + 
    		           String_Functions.removeLeadingZeros(distributor.AccountNumber) + 
    		           ' - ' + distributor.SAP_Sales_Org__c; 
    	}
    	fromListPage = !fromDistPage;
    }
    
    private static String getZeroFilled(String s, Integer n) {
    	String r = s.trim(); Integer m = r.length();
    	while (m++ < n) {r = '0' + r;}
    	return r;
    }
    
    public class DistEndUseCust {
    	String endUseCust,soldTo,salesOrg,distChan,divsn,soldToNum;
    	DistributorEndUseCustomer__c deuc;
    	
    	public DistEndUseCust(String[] sa) {
    		if (sa.size() > 4) {
    			endUseCust = getZeroFilled(sa[0],10);
    			soldTo     = getZeroFilled(sa[1],10);
    			salesOrg   = getZeroFilled(sa[2],4);
    			distChan   = sa[3];
    			divsn      = sa[4];
                soldToNum  = soldTo + salesOrg + distChan + divsn;
    		}
            init();
    	}
    	
        public DistEndUseCust(Account acc, String euc) {
            endUseCust = getZeroFilled(euc,10);
            soldToNum  = acc.Account_Number__c;
            init();
        }
        
        public DistEndUseCust(String euc, String stn) {
            endUseCust = euc; soldToNum  = stn; init();
        }
        
        private void init() {
            deuc = new DistributorEndUseCustomer__c();
            deuc.Record_Key__c = soldToNum + '-' + endUseCust;
        }
        
    }
    
    public PageReference insertEndUseCustomers() {
    	debug(publicGroupName);
    	publicGroupId = Public_Group_Functions.LookupPublicGroupId(publicGroupName);
    	if (publicGroupId == null) {return null;}
    	setDistEndUseCusts();
    	setAccountShares();
        if (distEndUseCusts == null || distEndUseCusts.isEmpty()) {
            addMsg('Either these EndUseCustomers are already loaded or none found');
            return null;
        }
    	SavePoint sp = Database.setSavepoint();
    	try {
			insert distEndUseCusts;
            if (accountShares != null && !accountShares.isEmpty()) {
                insert accountShares;
            }
    		addMsg('Loaded EndUseCustomers Successfully');
    	} catch(Exception e) {
    		Database.rollback(sp);
    		debug(e.getMessage());
    	}
    	return null;
    }
    
    private void setDistEndUseCusts() {
    	List<String> sa = endUseCustomers.split('\r\n');
    	List<String> sb; DistEndUseCust deuc;
        distEndUseCusts = new List<DistributorEndUseCustomer__c>();
        List<DistEndUseCust> deucs1 = new List<DistEndUseCust>();
        List<DistEndUseCust> deucs2 = new List<DistEndUseCust>(); // Valid Accounts
        List<DistEndUseCust> deucs3 = new List<DistEndUseCust>(); // SalesOrg = 0000
        Set<String> accNums = new Set<String>();
        Set<String> recKeys = new Set<String>();
    	for (String s : sa) {
    		s = s.replace(PIPE, COMMA);
    		sb = s.split(COMMA);
    		if (distributor != null && sb != null && sb.size() > 0) {
    			deuc = new DistEndUseCust(distributor, sb[0]);
    		} else {deuc = new DistEndUseCust(sb);}
    		accNums.add(deuc.endUseCust);
    		if (deuc.salesOrg == '0000') {
                deucs3.add(deuc);
    		} else {
                accNums.add(deuc.soldtoNum);
                deucs1.add(deuc);
    		}
    	}
    	if (!deucs3.isEmpty()) {getDistributors(accNums, deucs1, deucs3);}
    	Map<String, Id> amap = getAccountIdMap(accNums); Boolean b1, b2;
    	for (DistEndUseCust d : deucs1) {
    		b1 = amap.containsKey(d.endUseCust);
    		if (!b1) {addMsg('Account Not found : ' + d.endUseCust);}
    		else {d.deuc.End_Use_Customer__c = amap.get(d.endUseCust);}
    		b2 = amap.containsKey(d.soldtoNum);
            if (!b2) {addMsg('Account Not found : ' + d.soldtoNum);}
            else {d.deuc.Distributor_Sold_To__c = amap.get(d.soldtoNum);}
            if (b1 && b2) {deucs2.add(d); recKeys.add(d.deuc.Record_Key__c);}
    	}
        Map<String, Id> emap = getDistEndUseCustIdMap(recKeys);
        for (DistEndUseCust d2 : deucs2) {
        	if (!emap.containsKey(d2.deuc.Record_Key__c)) {
        		distEndUseCusts.add(d2.deuc);
        	}
        }
        debug(''+distEndUseCusts);
    }
    
    private void getDistributors(Set<String> accNums, 
                                 List<DistEndUseCust> deucs1, 
                                 List<DistEndUseCust> deucs3) {
    	Set<String> sos = new Set<String>();
        Set<String> dcs = new Set<String>();
        for (DistEndUseCust d : deucs3) {
        	sos.add(d.soldTo); dcs.add(d.distChan);
        }
        Map<String, Set<String>> amap = new Map<String, Set<String>>();
        String k; Set<String> aset;
        for (Account a : [select AccountNumber, Account_Number__c,
                                 SAP_DistChannel__c, SAP_DivisionCode__c 
                            from Account 
                           where AccountNumber in :sos
                             and SAP_DistChannel__c in :dcs]) {
            k = a.AccountNumber + a.SAP_DistChannel__c + a.SAP_DivisionCode__c;
            if (!amap.containsKey(k)) {aset = new Set<String>(); amap.put(k, aset);}
            aset = amap.get(k); aset.add(a.Account_Number__c); amap.put(k, aset);
            //debug(k);
        }
        DistEndUseCust d2;
        for (DistEndUseCust d : deucs3) {
        	k = d.soldTo + d.distChan + d.divsn;
            //debug(k);
        	if (amap.containsKey(k)) {
        		aset = amap.get(k);
        		for (String s : aset) {
        			d2 = new DistEndUseCust(d.endUseCust, s);
        			deucs1.add(d2);
        			accNums.add(s);
        			//debug(s); 
        		}
        	}
        }
    }
    
    private void setAccountShares() {
    	Set<String> accShareSet = new Set<String>();
    	Set<Id> accIds = new Set<Id>();
    	for (DistributorEndUseCustomer__c d : distEndUseCusts) {
    		accIds.add(d.End_Use_Customer__c);
    	}
    	Set<String> accShareKeys = new Set<String>();
    	List<AccountShare> alist = [
            select AccountId, UserOrGroupId
              from AccountShare
             where AccountId in :accIds
               and UserOrGroupId = :publicGroupId];
        String k;
        if (alist != null && !alist.isEmpty()) {
        	for (AccountShare a : alist) {
        		k = a.AccountId + '-' + a.UserOrGroupId;
                accShareKeys.add(k);
        	}
        }
        accountShares = new List<AccountShare>();
        for (DistributorEndUseCustomer__c d : distEndUseCusts) {
            k = d.End_Use_Customer__c + '-' + publicGroupId;
            if (!accShareKeys.contains(k)) {
            	accountShares.add(getAccountShare(d.End_Use_Customer__c));
            }
        }
        debug(''+accountShares);
    }
    
    private AccountShare getAccountShare(String accId) {
    	AccountShare a = new AccountShare();
    	a.AccountAccessLevel = 'Read';
    	a.AccountId = accId;
    	a.CaseAccessLevel = 'Read';
    	a.OpportunityAccessLevel = 'Read';
    	a.UserOrGroupId = publicGroupId;
    	return a;
    }
    
    private void addMsg(String s) {
        ApexPages.Message msg = new ApexPages.Message(
                                    ApexPages.Severity.INFO, s);
        ApexPages.addMessage(msg);
    }
    
    private Account getAccount(String accId) {
        if (accId == null) {return null;}
        List<Account> accs = [
            select Id, Name, AccountNumber, Account_Number__c, 
                   SAP_DistChannel__c, SAP_Sales_Org__c
              from Account where Id = :accId
        ];
        if (accs != null && !accs.isEmpty()) {return accs[0];}
        return null;
    }
    
    private Map<String, Id> getAccountIdMap(Set<String> accNums) {
    	Map<String, Id> amap = new Map<String, Id>();
    	for (Account a : [select Account_Number__c, Id 
    	                    from Account 
    	                   where Account_Number__c in :accNums]) {
            amap.put(a.Account_Number__c, a.Id);
        }
    	return amap;
    }
    
    private Map<String, Id> getDistEndUseCustIdMap(Set<String> recKeys) {
        Map<String, Id> amap = new Map<String, Id>();
        for (DistributorEndUseCustomer__c a : [
            select Record_Key__c, Id 
              from DistributorEndUseCustomer__c 
             where Record_Key__c in :recKeys]) {
            amap.put(a.Record_Key__c, a.Id);
        }
        return amap;
    }
    
}