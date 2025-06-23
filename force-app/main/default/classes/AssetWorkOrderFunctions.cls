public class AssetWorkOrderFunctions {
	
    private static final Integer MAX_RECS = 50000;
    
	private static final String  ASSETS_SORT_BY = ' order by Equipment_Name__c, Asset_Number__c';
    private static final String  SEMI_COLON = ';';
    private static final String  DELIM = ' - ';
    private static final String  APPROVED = 'Approved';
    private static final String  CANCELLED = 'Cancelled';
    private static final String  COMPLETED = 'Completed';
	
    public static void debug(String s) {
    	DebugLog_Functions.info('AssetWorkOrderFunctions : ' + s);
    }
    
    public static void doBeforeUpsert(List<Asset_Work_Order__c> alist) {
    	for (Asset_Work_Order__c a : alist) {
    		if (isCompleted(a)) {a.Status__c = COMPLETED;}
    	}
    	setWorkOrderKeys(alist);
    }
    
    private static void setWorkOrderKeys(List<Asset_Work_Order__c> alist) {
        Set<Id> accIds = new Set<Id>(); Account acc;
        for (Asset_Work_Order__c a : alist) {
            if (a.Id != null) {accIds.add(a.Account__c);}
        }
        if (accIds.isEmpty()) {return;}
        Map<Id, Account> accMap = getAccountMap(accIds); 
        for (Asset_Work_Order__c a : alist) {
            if (a.Id == null || !accMap.containsKey(a.Account__c)) {continue;}
            acc = accMap.get(a.Account__c);
            setWorkOrderKey(acc, a);
        }
    }
    
    private static void setWorkOrderKey(Account acc, Asset_Work_Order__c wo) {
        wo.Key__c = acc.SAP_Sales_Group_Desc__c + DELIM + acc.SAP_SalesGroup__c + DELIM +
                    wo.Status__c;
    }
    
    public static Boolean isApproved(Asset_Work_Order__c a) {
    	return (a.Status__c != null && a.Status__c == APPROVED);
    }
    
    public static Boolean isCompleted(Asset_Work_Order__c a) {
        return (isApproved(a) && a.Actual_Completion_Date__c != null && a.Status__c != COMPLETED);
    }
    
	public static Account getAccount(String accountId) {
		Set<Id> accIds = new Set<Id>{accountId};
		Map<Id, Account> accMap = getAccountMap(accIds);
		debug('accMap : ' + accMap); debug('accountId : ' + accountId); 
		Account acc = accMap.get(accountId);
        return acc;
	}
	
	private static Map<Id, Account> getAccountMap(Set<Id> accIds) {
		Map<Id, Account> accMap = new Map<Id, Account>();
        for (Account acc : [select Id, Name, AccountNumber, 
            BillingCity, BillingCountry, BillingPostalCode, 
            BillingState, BillingStreet, Owner.Name, Owner.MobilePhone, Phone, 
            SAP_SalesGroup__c, SAP_Sales_Group_Desc__c 
            from Account where Id in :accIds]) {accMap.put(acc.Id, acc);}
        return accMap;
	}
	
	public static Asset_Work_Order__c getWorkOrder(String workOrderId) {
		Asset_Work_Order__c wo = [select Id, Name, Account__c, Actual_Completion_Date__c,
		    Approval_Email1__c, Approval_Email2__c, Approver1__c, Approver2__c, 
            Bill_to_Customer__c, Contact_Name__c, Contact_Phone__c, CreatedDate,
            Description_of_Service__c, Final_Approver__c, High_Priority__c, Key__c, 
            Requested_Completion_Date__c, Special_Instructions__c, Status__c, 
            Tax_Amount__c, Tax_Rate__c, Total_Charges__c, Total_Labor_Charges__c, 
            Total_Material_Charges__c, Type_of_Service__c,  
            (select Id, Name, Asset__c from Asset_Work_Order_Details__r)
            from Asset_Work_Order__c where Id = :workOrderId];
        return wo;
	}
	
	public static List<Asset> getAssets(Set<String> assetIds) {
        String qry = AssetManagementFunctions.ASSET_QRY1;
        qry += ' where Id in :assetIds'; 
        qry += ASSETS_SORT_BY;
        List<Asset> alist = Database.query(qry);
        return alist;
	}
	
	public static PaginationController getAssetsPC(String accountId, Integer pageSize) {
        String qry = AssetManagementFunctions.ASSET_QRY1;
        qry += ' where Assigned_Account__c = \'' + accountId + '\''; 
        qry += ASSETS_SORT_BY;
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getAssetsPC : ' + e.getMessage());}
        return pc;
	}
	
    public static PaginationController getWorkOrdersPC(String salesGroup, String status, Integer pageSize) {
        String qry = '', key = salesGroup + DELIM + status;
        qry += 'select Id, Name, CreatedDate, Account__r.Name, Account__r.AccountNumber, Actual_Completion_Date__c,';
        qry += '       Contact_Name__c, Contact_Phone__c, Requested_Completion_Date__c, Type_of_Service__c';
        qry += '  from Asset_Work_Order__c'; 
        //qry += ' where Account__r.SAP_SalesGroup__c = \'' + salesGroup + '\''; 
        //qry += '   and Status__c = \'' + status + '\''; 
        qry += ' where Key__c = \'' + key + '\''; 
        qry += ' order by Name';
        Database.Querylocator ql; PaginationController pc = null;
        try {
            ql = Database.getQueryLocator(qry);
            pc = new PaginationController(ql, pageSize);
        } catch(Exception e) {debug('getWorkOrdersPC : ' + e.getMessage());}
        return pc;
    }
    
	public static Set<String> getAssetIds(Asset_Work_Order__c wo) {
		Set<String> assetIds = new Set<String>();
        if (wo.Asset_Work_Order_Details__r != null) {
	        for (Asset_Work_Order_Detail__c d : wo.Asset_Work_Order_Details__r) {
	            assetIds.add(d.Asset__c);
	        }
        }
        return assetIds;
	}
	
    private static Set<String> getAssetIdsToAdd(Asset_Work_Order__c wo, Set<String> assetIds) {
    	Set<String> aset = new Set<String>();
    	Set<String> cset = getAssetIds(wo);
    	for (String s : assetIds) {
    		if (!cset.contains(s)) {aset.add(s);}
    	}
    	return aset;
    }
    
    private static List<Asset_Work_Order_Detail__c> getDetailsToDelete(Asset_Work_Order__c wo, Set<String> assetIds) {
        List<Asset_Work_Order_Detail__c> dlist = new List<Asset_Work_Order_Detail__c>();
        if (wo.Asset_Work_Order_Details__r != null) {
            for (Asset_Work_Order_Detail__c d : wo.Asset_Work_Order_Details__r) {
                if (!assetIds.contains(d.Asset__c)) {dlist.add(d);}
            }
        }
        return dlist;
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private static Boolean compare1(String s, String t) {
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
    
    public static void setWorkOrderApprovalInfo(Account acc, Asset_Work_Order__c wo) {
    	List<Asset_Work_Order_Config__c> alist = [select Approval_Email1__c, Approval_Email2__c,
            Approver1__c, Approver1__r.Name, Approver2__c, Approver2__r.Name, Key__c, Sales_Groups__c 
            from Asset_Work_Order_Config__c order by Key__c];
        if (alist == null || alist.isEmpty()) {return;}
        Boolean b1;
        for (Asset_Work_Order_Config__c a : alist) {
        	b1 = compare2(a.Sales_Groups__c, acc.SAP_SalesGroup__c);
        	if (b1) {
        		wo.Approval_Email1__c = a.Approval_Email1__c;
                wo.Approval_Email2__c = a.Approval_Email2__c;
                wo.Approver1__c = a.Approver1__c;
                wo.Approver2__c = a.Approver2__c;
        		wo.Approver1__r = a.Approver1__r;
        		wo.Approver2__r = a.Approver2__r;
        		break;
        	}
        }
    }
    
    public static void cancelWorkOrder(Asset_Work_Order__c wo) {
        String msg = 'WorkOrder Cancelled';
        if (wo.Id == null || wo.Status__c == CANCELLED ||
                             wo.Status__c == COMPLETED) {return;}
        try {
        	wo.Status__c = CANCELLED; update wo;
        } catch(Exception e) {
            throw new CustomException(e.getMessage());
        }
    }
    
	public static void saveWorkOrder(Account acc, Asset_Work_Order__c wo, Set<String> assetIds) {
        debug('saveWorkOrder1 : wo : ' + wo);
		String msg = 'WorkOrder Saved';
		try {
			if (wo.Id == null) {createWorkOrder(acc, wo, assetIds);} 
			else {updateWorkOrder(wo, assetIds);}
        } catch(Exception e) {
            throw new CustomException(e.getMessage());
        }
        debug('saveWorkOrder2 : wo : ' + wo);
	}
	
    public static void submitWorkOrder(Account acc, Asset_Work_Order__c wo, Set<String> assetIds) {
        String msg = 'WorkOrder Submitted';
        saveWorkOrder(acc, wo, assetIds);
        Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
        psr.setComments('Submitting Asset Work Order for Approval.');
        psr.setObjectId(wo.Id);
        Approval.ProcessResult pr = Approval.process(psr);  
        if (!pr.isSuccess()) {throw new CustomException('WorkOrder Submit Failed');}
    }
    
	private static void createWorkOrder(Account acc, Asset_Work_Order__c wo, Set<String> assetIds) {
        String msg = 'WorkOrder Created';
        setWorkOrderKey(acc, wo);
		savepoint sp = Database.setSavepoint();
		try {insert wo; createWorkOrderDetails(wo.Id, assetIds);} 
		catch(Exception e) {Database.rollback(sp);
            throw new CustomException(e.getMessage());
		}
	}
	
	private static void createWorkOrderDetails(String workOrderId, Set<String> assetIds) {
		if (workOrderId == null || assetIds == null || assetIds.isEmpty()) {return;}
		List<Asset_Work_Order_Detail__c> alist = new List<Asset_Work_Order_Detail__c>();
		for (String s : assetIds) {alist.add(new Asset_Work_Order_Detail__c(
			Asset__c = s, Asset_Work_Order__c = workOrderId
		));}
		try {insert alist;} catch(Exception e) {
			debug('createWorkOrderDetails : ' + e.getMessage());}
	}

    private static void updateWorkOrder(Asset_Work_Order__c wo, Set<String> assetIds) {
        String msg = 'WorkOrder Updated';
        Set<String> aset = getAssetIdsToAdd(wo, assetIds);
        List<Asset_Work_Order_Detail__c> dlist = getDetailsToDelete(wo, assetIds);
        savepoint sp = Database.setSavepoint();
        try {
            update wo;
            if (!aset.isEmpty()) {createWorkOrderDetails(wo.Id, aset);}
            if (!dlist.isEmpty()) {delete dlist;}
        } catch(Exception e) {Database.rollback(sp);
        	throw new CustomException(e.getMessage());
        }
    }

    public static List<SelectOption> getSalesGroupOptions() {
        List<SelectOption> salesGroups = new List<SelectOption>();
        for (AggregateResult[] ars : [
            select Account__r.SAP_SalesGroup__c sgcode, 
                   Account__r.SAP_Sales_Group_Desc__c sgdesc
              from Asset_Work_Order__c 
          group by Account__r.SAP_SalesGroup__c, 
                   Account__r.SAP_Sales_Group_Desc__c 
             limit :MAX_RECS 
        ]) {
            String c, d, s; SelectOption so;
            for (AggregateResult ar : ars) {
                c = (String)ar.get('sgcode'); d = (String)ar.get('sgdesc');
                s = d + DELIM + c;
                if (c != null && d != null) {
                	//so = new SelectOption(c, d + DELIM + c);
                    so = new SelectOption(s, s);
                	salesGroups.add(so);
                }
            }
        }
        return salesGroups;
    }
    
    public static List<SelectOption> getStatusOptions() {
        List<SelectOption> statusOptions = new List<SelectOption>();
        for (AggregateResult[] ars : [
            select Status__c status
              from Asset_Work_Order__c 
          group by Status__c 
             limit :MAX_RECS 
        ]) {
            String s; SelectOption so;
            for (AggregateResult ar : ars) {
                s = (String)ar.get('status');
                if (s != null) {
                    so = new SelectOption(s, s);
                    statusOptions.add(so);
                }
            }
        }
        return statusOptions;
    }
    
    
}