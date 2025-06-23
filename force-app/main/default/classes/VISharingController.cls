public class VISharingController {

    public static final Integer PAGE_SIZE = 200;

    public static final ApexPages.Severity ERROR = ApexPages.Severity.ERROR;
    public static final ApexPages.Severity INFO  = ApexPages.Severity.INFO;
    
    public static final String SORT_DESC = ' desc nulls last';
    
    public static final List<SelectOption> SORT_FLDS = new List<SelectOption>{
        new SelectOption('Name',                      'Account Name')                  
       ,new SelectOption('AccountNumber',             'Account Number')                	
       ,new SelectOption('VI_Account_Type__c',        'Account Type')                 
       ,new SelectOption('Parent.Name',               'Parent Name')                  
       ,new SelectOption('Parent.AccountNumber',      'Parent Number')                    
       ,new SelectOption('Parent.VI_Account_Type__c', 'Parent Type')                 
    };
    
    public static final String QRY_1 = ''
        + 'select Id, Name, AccountNumber, Active_Account__c,'
        + '       Inactive_Account__c, VI_Account_Type__c,'
        + '       Parent.Id, Parent.Name, Parent.AccountNumber,'
        + '       Parent.Active_Account__c, Parent.Inactive_Account__c,' 
        + '       Parent.VI_Account_Type__c'
        + '  from Account ';
        
    public static final String ACC_LIST_TYPE_CHILD = 'CHILD';
    public static final String ACC_LIST_TYPE_ADDED = 'ADDED';
    public static final String ACC_LIST_TYPE_TOADD = 'TOADD';
    public static final String ACC_LIST_TYPE_TODEL = 'TODEL';
    
    public static final Map<String, String> ACC_LIST_TITLES = new Map<String, String>{
    	ACC_LIST_TYPE_CHILD => 'Child Accounts'
       ,ACC_LIST_TYPE_ADDED => 'Current Account Shares'
       ,ACC_LIST_TYPE_TOADD => 'Account Shares to Add'
       ,ACC_LIST_TYPE_TODEL => 'Account Shares to Delete'
    };
    
    public static Boolean isInactive(Account a) {
    	if (a == null) {return false;}
        return (a.Inactive_Account__c || 'No'.equalsIgnoreCase(a.Active_Account__c));
    }
    
    public class AccSharing {
        public Account        acc {get; set;}
        public Account     parent {get; set;}
        public UserRole     urole {get; set;}
        public Integer  accsAdded {get; set;}
        public Integer  accsToAdd {get; set;}
        public Integer  accsToDel {get; set;}
        public Integer  recordNum {get; set;}
        public Boolean   selected {get; set;}
        public Boolean  inactiveA {get; set;}
        public Boolean  inactiveP {get; set;}

        public AccSharing(Account a, Integer n) {
        	acc = a; parent = a.Parent; recordNum = n;
        	inactiveA = isInactive(acc); inactiveP = isInactive(parent);
        }
        public AccSharing(UserRole r, Integer n) {urole = r; recordNum = n;}
    }
    
    public Boolean   allAccs {get; set;}
    public Boolean  sortDesc {get; set;}
    public String    sortFld {get; set;}
    public String userRoleId {get; set;}
    
    public Account       acc {get; private set;}
    public String      accId {get; private set;}
    public String  accsTitle {get; private set;}

    public Boolean renderAddLink {get; private set;}
    public Boolean renderDelLink {get; private set;}
    
    public List<AccSharing>   accounts {get; private set;}
    public List<AccSharing>  userRoles {get; private set;}
    public PaginationController     pc {get; private set;}
    
    Boolean isAdmin;
    Integer pageSize = PAGE_SIZE;
    String  accListType;
    
    List<AccountShare> accountShares = new List<AccountShare>();
    List<UserRole>      userRoleList = new List<UserRole>();
    Map<Id, Id>           groupIdMap = new Map<Id, Id>();
    Map<Id, String>      userRoleMap = new Map<Id, String>();

    Set<Id> accIdsAdded = new Set<Id>(), 
            accIdsToAdd = new Set<Id>(),
            accIdsToDel = new Set<Id>(),
            childAccIds = new Set<Id>();
    
    VI_Portal_Settings__c vips = VI_Portal_Settings__c.getInstance();
    
    public VISharingController() {this(null);}

    public VISharingController(ApexPages.StandardController sc) {
        Map<String, String> pmap = ApexPages.currentPage().getParameters();
        SObject sobj = null; acc = null;
        if (sc != null) {sobj = sc.getRecord();}
        if (sobj != null) {acc = (Account)sobj; accId = acc.Id;} 
        else {accId = pmap.get('id');}
        init1();
    }
    
    private void debug(String s) {System.debug(LoggingLevel.INFO, 'VISharingController : ' + s);}
    
    private void addErrMsg(String s) {addMsg(ERROR, s);}
    
    private void addInfoMsg(String s) {addMsg(INFO, s);}
    
    private void addMsg(ApexPages.Severity mtype, String s) {
        ApexPages.Message msg = new ApexPages.Message(mtype, s);
        ApexPages.addMessage(msg);
    }
    
    private void init1() {
    	isAdmin = (vips != null && vips.Account_Sharing_Admin__c);
    	sortDesc = false; sortFld = 'Name'; accListType = ''; 
    	renderAddLink = false; renderDelLink = false;
        childAccIds = new Set<Id>(); groupIdMap = new Map<Id, Id>(); 
        userRoles = new List<AccSharing>();
        if (String.isBlank(accId)) {return;}
        acc = [select Id, Name, AccountNumber from Account where Id = :accId]; 
        userRoleList = [select Id, Name, PortalRole, PortalType 
                          from UserRole where PortalAccountId = :accId 
                      order by Name, PortalRole];
    	if (userRoleList == null || userRoleList.isEmpty()) {return;}
        for (Account a : [select Id, Active_Account__c, Inactive_Account__c 
                            from Account where ParentId = :accId 
                                     or Parent.ParentId = :accId]) {
            if (!isInactive(a)) {childAccIds.add(a.Id);}
        }
        Set<Id> aset = new Set<Id>(); 
    	for (UserRole r : userRoleList) {aset.add(r.Id); userRoleMap.put(r.Id, r.Name);}
    	for (Group g : [select Id, RelatedId from Group 
    	                 where RelatedId in :aset and Type = 'RoleAndSubordinates']) {
            groupIdMap.put(g.RelatedId, g.Id);
        }
        setUserRoles();
    }
    
    private void setUserRoles() {
    	Integer n = 0; userRoles = new List<AccSharing>();
        for (UserRole r : userRoleList) {userRoles.add(getAccSharing(r, ++n));}
    }
    
    private AccSharing getAccSharing(UserRole r, Integer n) {
    	AccSharing ur = new AccSharing(r, n); userRoleId = r.Id; 
    	setAccIdsAdded(); setAccIdsToAdd(); setAccIdsToDel();
    	ur.accsAdded = accIdsAdded.size();
    	ur.accsToAdd = accIdsToAdd.size();
    	ur.accsToDel = accIdsToDel.size();
    	debug('getAccSharing : ur = ' + ur);
    	return ur;
    }
    
    public List<SelectOption> getSortFlds() {return SORT_FLDS;}
    
    private void setAccIdsAdded() {
    	accIdsAdded = new Set<Id>();
    	if (String.isBlank(userRoleId) || !groupIdMap.containsKey(userRoleId)) {return;}
    	Id groupId = groupIdMap.get(userRoleId);
    	for (AccountShare a : [
        	Select AccountId from AccountShare  
    	     where UserOrGroupId = :groupId]) {
    	    if (a.AccountId != accId) {accIdsAdded.add(a.AccountId);}
    	}
    }
    
    private void setAccIdsToAdd() {
    	accIdsToAdd = new Set<Id>();
    	for (Id i : childAccIds) {
    		if (!accIdsAdded.contains(i)){accIdsToAdd.add(i);}
    	}
    }
    
    private void setAccIdsToDel() {
        accIdsToDel = new Set<Id>();
        for (Id i : accIdsAdded) {
            if (!childAccIds.contains(i)){accIdsToDel.add(i);}
        }
    }

    public Integer getChildAccsCount() {return childAccIds.size();}

    private void setAccsTitle() {setAccsTitle(true);}

    private void setAccsTitle(Boolean b) {
    	accsTitle = ''; if (b) {accsTitle = userRoleMap.get(userRoleId) + '<br/>';}
        accsTitle += ACC_LIST_TITLES.get(accListType);
    }
        
    public void getChildAccounts() {
    	accListType = ACC_LIST_TYPE_CHILD; setAccsTitle(false);
        setAccounts(childAccIds);
    }
    
    public void getSharingsAdded() {
        accListType = ACC_LIST_TYPE_ADDED; setAccsTitle();
    	setAccIdsAdded(); setAccounts(accIdsAdded);
        renderDelLink = isAdmin && !accIdsAdded.isEmpty();
    }
    
    public void getSharingsToAdd() {
        accListType = ACC_LIST_TYPE_TOADD; setAccsTitle();
        setAccIdsAdded(); setAccIdsToAdd(); setAccounts(accIdsToAdd);
        renderAddLink = isAdmin && !accIdsToAdd.isEmpty();
    }
    
    public void getSharingsToDel() {
        accListType = ACC_LIST_TYPE_TODEL; setAccsTitle();
        setAccIdsAdded(); setAccIdsToDel(); setAccounts(accIdsToDel);
        renderDelLink = isAdmin && !accIdsToDel.isEmpty();
    }
    
    public void setAccounts() {
    	if (String.isBlank(accListType)) {return;}
    	if (accListType == ACC_LIST_TYPE_CHILD) {getChildAccounts();} else
        if (accListType == ACC_LIST_TYPE_ADDED) {getSharingsAdded();} else
        if (accListType == ACC_LIST_TYPE_TOADD) {getSharingsToAdd();} else
        if (accListType == ACC_LIST_TYPE_TODEL) {getSharingsToDel();}
    }
    
    private void setAccounts(Set<Id> accIds) {
        debug('setAccounts : userRoleId = ' + userRoleId + ': accListType = ' + accListType);
        accounts = new List<AccSharing>(); allAccs = false; 
        renderAddLink = false; renderDelLink = false;
        if (accIds == null || accIds.isEmpty()) {return;}
        Database.Querylocator ql; pc = null;
        String qry = QRY_1 + ' where Id in :accIds order by ' + sortFld;
        if (sortDesc) {qry += SORT_DESC;}
        debug('setAccounts : qry = ' + qry);
        try {ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('setAccounts : ' + e.getMessage());}
        setAccs();
    }

    public void pcSize() {setAccs(null);}
    public void pcFrst() {setAccs(PaginationController.Page.FIRST);}
    public void pcPrev() {setAccs(PaginationController.Page.PREV);}
    public void pcNext() {setAccs(PaginationController.Page.NEXT);}
    public void pcLast() {setAccs(PaginationController.Page.LAST);}
    
    private void setAccs() {setAccs(null);}
        
    private void setAccs(PaginationController.Page p) {
        accounts = new List<AccSharing>(); 
        List<Account> alist = null; Integer n = 0;
        if (pc != null) {
            pc.gotoPage(p); n = pc.recordFrom; 
            alist = pc.getRecords(); pageSize = pc.getPageSize();
        }
        if (alist == null || alist.isEmpty()) {return;}
        AccSharing accShr;
        for (Account a : alist) {
            accShr = new AccSharing(a, n++); accounts.add(accShr);
        }
    }
    
    public void selectAllAccs() {
        for (AccSharing a : accounts) {a.selected = true;}
    }
    
    public void setAdmin(Boolean b) {isAdmin = b;}
    
    public void setRoleIdToAdd() {
    	for (AccSharing u : userRoles) {
    		if (u.accsToAdd > 0) {userRoleId = u.urole.Id; break;}
    	}
    }
    
    private void getAccountSharesToAdd() {
    	accountShares = new List<AccountShare>(); AccountShare s;
        if (String.isBlank(userRoleId) || !groupIdMap.containsKey(userRoleId)) {return;}
    	Id groupId = groupIdMap.get(userRoleId);
    	for (AccSharing a : accounts) {
    		if (!a.selected) {continue;}
    		s = new AccountShare(AccountId = a.acc.Id,
                             UserOrGroupId = groupId,
                        AccountAccessLevel = 'Edit',
                    OpportunityAccessLevel = 'None',
                           CaseAccessLevel = 'None');
    		accountShares.add(s);
    	}
    }
    
    public void addAccountShares() {
    	if (!isAdmin) {return;}
    	getAccountSharesToAdd(); if (accountShares.isEmpty()) {return;}
    	try {insert accountShares;} catch(Exception e) {
    		addErrMsg(e.getMessage()); return;
    	}
    	String temp = userRoleId; setUserRoles(); 
    	userRoleId = temp; getSharingsToAdd();
    }
    
    private void getAccountSharesToDelete() {
        accountShares = new List<AccountShare>(); AccountShare s;
        if (String.isBlank(userRoleId) || !groupIdMap.containsKey(userRoleId)) {return;}
        Set<Id> accIds = new Set<Id>();
        for (AccSharing a : accounts) {
            if (a.selected) {accIds.add(a.acc.Id);}
        }
        if (accIds.isEmpty()) {return;}
        Id groupId = groupIdMap.get(userRoleId);
        accountShares = [Select Id from AccountShare  
                          where UserOrGroupId = :groupId
                            and AccountId in :accIds];
    }
    
    public void deleteAccountShares() {
        if (!isAdmin) {return;}
        getAccountSharesToDelete(); if (accountShares.isEmpty()) {return;}
        try {delete accountShares;} catch(Exception e) {
            addErrMsg(e.getMessage()); return;
        }
        String temp = userRoleId; setUserRoles(); 
        userRoleId = temp; getSharingsToDel();
    }
}