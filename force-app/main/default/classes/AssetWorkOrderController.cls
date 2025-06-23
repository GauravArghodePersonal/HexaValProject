public class AssetWorkOrderController {

    private static final Integer PAGE_SIZE = 200;
    private static final String DELIM = ':';
    private static final String APPROVED = 'Approved';
    private static final String CANCELLED = 'Cancelled';
    private static final String COMPLETED = 'Completed';
    private static final String DRAFT = 'Draft';
    private static final String SUBMITTED = 'Submitted';
    private static final String CONFIRM_TO = 'Please confirm to ';
    private static final String CANCEL_ACTION = 'Cancel the Work Order';
    private static final String SUBMIT_ACTION = 'Submit the Work Order';
    private static final Set<String> EDIT_SET1 = new Set<String>{DRAFT}; 
    private static final Set<String> EDIT_SET2 = new Set<String>{DRAFT, SUBMITTED}; 
    private static final Set<String> EDIT_SET3 = new Set<String>{DRAFT, SUBMITTED, APPROVED}; 
    private static final Set<String> EDIT_SET4 = new Set<String>{CANCELLED, COMPLETED}; 

    public class AssetClass {
        public Asset   a        {get; set;}
        public Integer recNum   {get; set;}
        public Boolean selected {get; set;}
        public String  key      {get; set;}

        public AssetClass() {}      
        public AssetClass(Asset a) {this(a, 1);}
        public AssetClass(Asset a, Integer n) {
            this.a = a; recNum = n; selected = false;
            key = a.Equipment_Name__c + DELIM + a.Asset_Number__c + DELIM + a.Id;
        }
    }
    
    public class WorkOrderClass {
    	public Asset_Work_Order__c wo {get; set;}
        public Boolean selected       {get; set;}
        public Integer recNum         {get; set;}
        public String accountNumber   {get; set;}
        public Date aCompletionDate   {get; set;}
    	
        public WorkOrderClass() {}      
        public WorkOrderClass(Asset_Work_Order__c wo) {this(wo, 1);}
        public WorkOrderClass(Asset_Work_Order__c wo, Integer n) {
            this.wo = wo; recNum = n; selected = false;
            accountNumber = String_Functions.removeLeadingZeros(wo.Account__r.AccountNumber);
            aCompletionDate = wo.Actual_Completion_Date__c;
        }
    }
    
    public Account acc                    {get; private set;}
    public Asset_Work_Order__c wo         {get; private set;}
    
    public String accountId               {get; private set;}
    public String accountNumber           {get; private set;}
    public String actionValue             {get; private set;}
    public String billToCustomer          {get; private set;}
    public String highPriorityJob         {get; private set;}
    public String msg                     {get; private set;}
    public String salesGroup              {get; private set;}
    public String salesGroupCode          {get; set;}
    public String workOrderId             {get; set;}
    public String workOrderStatus         {get; set;}
    public Double taxAmount               {get; private set;}
    public Double totalCharges            {get; private set;}
    
    public Boolean allSelected            {get; set;}
    public Boolean isEditable             {get; private set;}
    public Boolean isEditabl2             {get; private set;}
    public Boolean isEditabl3             {get; private set;}
    public Boolean isPurchaseOrder        {get; private set;}
    public Boolean renderApprovalHistory  {get; private set;}
    public Boolean renderLoanedAssets     {get; private set;}
    public Boolean renderMsgBlock         {get; private set;}
    public Boolean renderCancelBtn        {get; private set;}
    public Boolean renderEditBtn          {get; private set;}
    public Boolean renderConfirmBtn       {get; private set;}
    public Boolean renderCreatePdfBtn     {get; private set;}
    public Boolean renderSaveBtn          {get; private set;}
    public Boolean renderSelectedAssets   {get; private set;}
    public Boolean renderWorkOrder        {get; private set;}
    public Integer pageSize               {get; set;}
    public PaginationController pc        {get; private set;}
    public PaginationController pc2       {get; private set;}
    
    public List<AssetClass> loanedAssets   = new List<AssetClass>(), 
                            selectedAssets = new List<AssetClass>();
    
    public List<SelectOption> salesGroups {get; private set;}
    public List<SelectOption> statusList  {get; private set;}
    
    public List<WorkOrderClass> workOrders;
    
    private Set<String> selectedAssetIds;

    private Asset_Work_Order_Detail__c wod;

    private void debug(String s) {DebugLog_Functions.info('>>>>>>>> ' + s);}
    
    public AssetWorkOrderController() {
    	try {init(new Asset_Work_Order__c());}
    	catch(Exception e) {debug(e.getMessage());}
    }
    
    public AssetWorkOrderController(ApexPages.StandardController sc) {
        init(sc.getRecord());
    }
    
    private void init(SObject sobj) {
        debug('sobj : ' + sobj);
        wo = new Asset_Work_Order__c();
    	if (sobj != null) {
            if (sobj.getSObjectType() == Asset_Work_Order__c.sObjectType) {
                wo = (Asset_Work_Order__c)sobj;
            } else 
            if (sobj.getSObjectType() == Asset_Work_Order_Detail__c.sObjectType) {
                wod = (Asset_Work_Order_Detail__c)sobj;
            } 
    	}
    	PageReference cp = ApexPages.currentPage();
    	if (cp != null) {
	        accountId = cp.getParameters().get('accountId');
	        workOrderId = cp.getParameters().get('id');
    	}
    	if (wo.Id != null) {workOrderId = wo.Id;}
        if (wo == null) {wo = new Asset_Work_Order__c();}
        if (workOrderId != null) {
            wo = AssetWorkOrderFunctions.getWorkOrder(workOrderId);
            accountId = wo.Account__c; setTaxAmount();
        }
        debug('wo : ' + wo);
        if (wo.Status__c == null) {wo.Status__c = DRAFT;} 
        init(); renderWorkOrder = true; 
        acc = null; pageSize = PAGE_SIZE;
        if (accountId != null) {
            acc = AssetWorkOrderFunctions.getAccount(accountId);
            if (acc != null) {
                wo.Account__c = accountId;
                wo.Contact_Phone__c = acc.Phone;
                accountNumber = String_Functions.removeLeadingZeros(acc.AccountNumber);
                salesGroup = acc.SAP_Sales_Group_Desc__c + ' - ' + acc.SAP_SalesGroup__c;
                AssetWorkOrderFunctions.setWorkOrderApprovalInfo(acc, wo);
            }
        }
        selectedAssetIds = AssetWorkOrderFunctions.getAssetIds(wo); setSelectedAssets(); 
        renderSelectedAssets = renderWorkOrder && !selectedAssets.isEmpty();
        billToCustomer = wo.Bill_to_Customer__c ? 'Yes' : 'No';
        highPriorityJob = wo.High_Priority__c ? 'Yes' : 'No';
        debug('init : pageSize : ' + pageSize);
    }
    
    private void init() {
        renderWorkOrder = false; renderLoanedAssets = false;
        renderSelectedAssets = false; renderMsgBlock = false;
        allSelected = false; isPurchaseOrder = false; msg = '';
        isEditable = EDIT_SET1.contains(wo.Status__c);
        isEditabl2 = EDIT_SET2.contains(wo.Status__c);
        isEditabl3 = EDIT_SET3.contains(wo.Status__c);
        renderSaveBtn = isEditabl3; 
        renderEditBtn = !renderSaveBtn && !EDIT_SET4.contains(wo.Status__c);
        renderCancelBtn = workOrderId != null && !EDIT_SET4.contains(wo.Status__c);
        renderCreatePdfBtn = (APPROVED.equals(wo.Status__c));
        renderConfirmBtn = false;
        renderApprovalHistory = (Assets_Config__c.getInstance() != null &&
                                 Assets_Config__c.getInstance().WorkOrder_Approval_History__c);
    }
    
    public void initAction1() {
        if (acc == null) {addInfoMsg('Account unknown'); renderWorkOrder = false; return;}
    }
    
    public void initAction2() {
    	salesGroups = AssetWorkOrderFunctions.getSalesGroupOptions();
    	if (!salesGroups.isEmpty()) {salesGroupCode = salesGroups[0].getValue();}
    	statusList = AssetWorkOrderFunctions.getStatusOptions();
        if (!statusList.isEmpty()) {workOrderStatus = statusList[0].getValue();}
        isEditabl3 = EDIT_SET3.contains(workOrderStatus);
        debug('initAction2 : pageSize : ' + pageSize);
    }
    
    public void editWorkOrder() {
        init(); renderWorkOrder = true; 
        renderSelectedAssets = !selectedAssets.isEmpty();
    }
    
    private void addInfoMsg(String s) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, s);
        ApexPages.addMessage(msg);
    }
    
    private void addErrMsg(String s) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(msg);
    }
    
    public void onServiceTypeChange() {
    	init();
    	if (wo.Type_of_Service__c == null) {return;}
    	
    	isPurchaseOrder     = (wo.Type_of_Service__c == 'Equipment Purchase' ||
    	                       wo.Type_of_Service__c == 'Equipment Purchase / IIF Funds') && isEditabl2;

        renderLoanedAssets  = (wo.Type_of_Service__c == 'Pick up Loaned Equipment' ||
                               wo.Type_of_Service__c == 'Service Call - Valvoline Owned');
                               
        renderWorkOrder = !renderLoanedAssets;
        renderSelectedAssets = renderWorkOrder && !selectedAssets.isEmpty();
        if (renderLoanedAssets) {getAssignedAssets();}
    }

    public void setTaxAmount() {
    	taxAmount = 0; double mc = 0.0, tr = 0.0, lc = 0.0;
        if (wo.Total_Labor_Charges__c != null) {lc = wo.Total_Labor_Charges__c;}
        if (wo.Total_Material_Charges__c != null) {mc = wo.Total_Material_Charges__c;}
        if (wo.Tax_Rate__c != null) {tr = wo.Tax_Rate__c;}
        taxAmount = (mc * tr / 100); totalCharges = mc + taxAmount + lc;
    }
    
    public void gotoWorkOrderPage() {
    	debug('gotoWorkOrderPage');
    	init(); renderWorkOrder = true; renderSelectedAssets = !selectedAssets.isEmpty();
    }
    
    private void setSelectedAssets() {
        Integer n = 1; AssetClass ac;
        List<Asset> alist = AssetWorkOrderFunctions.getAssets(selectedAssetIds); 
        selectedAssets = new List<AssetClass>();
        for (Asset a : alist) {
            ac = new AssetClass(a, n++);
            selectedAssets.add(ac);
        }
    }
    
    public void addSelectedAssets() {
    	allSelected = false;
    	for (AssetClass ac : loanedAssets) {
    		if (ac.selected && !selectedAssetIds.contains(ac.a.Id)) {
        		selectedAssets.add(ac); selectedAssetIds.add(ac.a.Id);
    		}
    	}
    	sortSelectedAssets();
    }

    public void addAndGoback() {
    	addSelectedAssets(); gotoWorkOrderPage();
    }
    
    private void sortSelectedAssets() {
    	if (selectedAssets.isEmpty()) {return;}
    	Map<String, AssetClass> amap = new Map<String, AssetClass>();
    	List<String> slist = new List<String>();
        List<AssetClass> tlist = new List<AssetClass>(); 
    	for (AssetClass ac : selectedAssets) {
    		amap.put(ac.key, ac); slist.add(ac.key);
    	}
    	slist.sort();
    	for (String s : slist) {tlist.add(amap.get(s));}
    	selectedAssets = tlist;
    }
    
    public void deleteSelectedAssets() {
        allSelected = false; renderLoanedAssets = false; 
        List<AssetClass> tlist = new List<AssetClass>(); 
        for (AssetClass ac : selectedAssets) {
            if (ac.selected) {
            	selectedAssetIds.remove(ac.a.Id);
            } else {
                tlist.add(ac);
            }
            ac.selected = false;
        }
        selectedAssets = tlist;
        renderSelectedAssets = renderWorkOrder && !selectedAssets.isEmpty();
    }

    public void getAssignedAssets() {
        debug('getAssignedAssets : accountId = ' + accountId);
        pc = AssetWorkOrderFunctions.getAssetsPC(accountId, pageSize);
        setLoanedAssets(null);
    }
    
    public void pcSize() {if (pc != null) {pc.setPageSize(pageSize);} setLoanedAssets(null);}
    public void pcFrst() {setLoanedAssets(PaginationController.Page.FIRST);}
    public void pcPrev() {setLoanedAssets(PaginationController.Page.PREV);}
    public void pcNext() {setLoanedAssets(PaginationController.Page.NEXT);}
    public void pcLast() {setLoanedAssets(PaginationController.Page.LAST);}

    private void setLoanedAssets(PaginationController.Page p) {
        debug('setLoanedAssets');
        init(); renderMsgBlock = true;
        msg = 'No Loaned Equipment found'; 
        if (pc == null) {return;}
        loanedAssets = new List<AssetClass>();List<Asset> alist = null;
        pc.gotoPage(p);
        try {alist = (List<Asset>) pc.getRecords();} catch(Exception e) {
        	msg = e.getMessage(); debug('setLoanedAssets : ' + msg);
        }
        if (alist == null || alist.isEmpty()) {return;}
        Integer n = pc.recordFrom; AssetClass ac;
        for (Asset a : alist) {
        	ac = new AssetClass(a, n++);
            ac.selected = (selectedAssetIds.contains(a.Id));
            loanedAssets.add(ac);
        }
        if (!loanedAssets.isEmpty()) {
            renderLoanedAssets = true; renderMsgBlock = false;
        }
    }
    
    public List<AssetClass> getLoanedAssets() {
        debug('getLoanedAssets');
        for (AssetClass ac : loanedAssets) {
            ac.selected = selectedAssetIds.contains(ac.a.Id);
        }
    	return loanedAssets;
    }
    
    public void selectLoanedAssets() {
        for (AssetClass ac : loanedAssets) {ac.selected = true;}
    }
    
    public List<AssetClass> getSelectedAssets() {
        debug('getSelectedAssets');
        for (AssetClass ac : loanedAssets) {ac.selected = false;}
        return selectedAssets;
    }
    
    public void confirmCancelWorkOrder() {
    	init(); renderMsgBlock = true; renderConfirmBtn = true;
    	msg = CONFIRM_TO + CANCEL_ACTION; actionValue = CANCEL_ACTION;
    }
    
    public void confirmSubmitWorkOrder() {
        init(); renderMsgBlock = true; renderConfirmBtn = true;
        msg = CONFIRM_TO + SUBMIT_ACTION; actionValue = SUBMIT_ACTION;
    }
    
    public PageReference cancelWorkOrder() {
        PageReference pr = null;
        try {
            AssetWorkOrderFunctions.cancelWorkOrder(wo); 
            pr = new PageReference('/' + wo.Id);
        } catch(Exception e) {renderMsgBlock = true; msg = e.getMessage();}
        return pr;
    }
    
    public PageReference createPdf() {
        PageReference pr = new PageReference('/apex/AssetWorkOrderPdf?id=' + wo.Id);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference saveWorkOrder() {
        init(); PageReference pr = null;
        try {
            AssetWorkOrderFunctions.saveWorkOrder(acc, wo, selectedAssetIds);
            pr = new PageReference('/' + wo.Id);
        } catch(Exception e) {renderMsgBlock = true; msg = e.getMessage();}
        return pr;
    }
    
    public PageReference submitWorkOrder() {
        init(); PageReference pr = null;
        try {
            AssetWorkOrderFunctions.submitWorkOrder(acc, wo, selectedAssetIds);
            pr = new PageReference('/' + wo.Id);
        } catch(Exception e) {renderMsgBlock = true; msg = e.getMessage();}
        return pr;
    }
    
    public PageReference confirmAction() {
    	if (actionValue == CANCEL_ACTION) {return cancelWorkOrder();} else
        if (actionValue == SUBMIT_ACTION) {return submitWorkOrder();}
        return null;
    }
    
    public PageReference gotoAssetWorkOrderPage() {
        PageReference pr = null;
        if (wod != null && wod.Id != null) {
            wod = [select Asset_Work_Order__c from Asset_Work_Order_Detail__c where Id = :wod.Id];
            pr = new PageReference('/apex/AssetWorkOrderPage1?id='+wod.Asset_Work_Order__c);
        }
        return pr;
    }
    
    public List<WorkOrderClass> getWorkOrders() {return workOrders;}

    public void searchWorkOrders() {
    	debug('searchWorkOrders : pageSize : ' + pageSize);
    	pc2 = AssetWorkOrderFunctions.getWorkOrdersPC(salesGroupCode, workOrderStatus, pageSize);
    	setWorkOrders(null); isEditabl3 = EDIT_SET3.contains(workOrderStatus);
    } 

    public void pc2Size() {if (pc2 != null) {pc2.setPageSize(pageSize);} setWorkOrders(null);}
    public void pc2Frst() {setWorkOrders(PaginationController.Page.FIRST);}
    public void pc2Prev() {setWorkOrders(PaginationController.Page.PREV);}
    public void pc2Next() {setWorkOrders(PaginationController.Page.NEXT);}
    public void pc2Last() {setWorkOrders(PaginationController.Page.LAST);}

    private void setWorkOrders(PaginationController.Page p) {
        if (pc2 == null) {return;}
        workOrders = new List<WorkOrderClass>();
        List<Asset_Work_Order__c> alist = null;
        pc2.gotoPage(p);
        try {alist = (List<Asset_Work_Order__c>) pc2.getRecords();} 
        catch(Exception e) {msg = e.getMessage(); debug('setWorkOrders : ' + msg);}
        if (alist == null || alist.isEmpty()) {return;}
        Integer n = pc2.recordFrom; WorkOrderClass woc;
        for (Asset_Work_Order__c a : alist) {
            woc = new WorkOrderClass(a, n++);
            workOrders.add(woc);
        }
    }
    
    private Boolean compareDates(Date d1, Date d2) {
    	return (d1 == null && d2 != null) ||
    	       (d1 != null && d2 == null) ||
    	       (d1 != d2);
    }
    
    private Boolean isWorkOrderChanged(WorkOrderClass woc) {
    	Boolean b1 = false;
    	b1 = compareDates(woc.aCompletionDate, woc.wo.Actual_Completion_Date__c);
    	return b1;
    }
    
    public void saveWorkOrders() {
    	List<Asset_Work_Order__c> alist = new List<Asset_Work_Order__c>();
    	for (WorkOrderClass woc : workOrders) {
    		if (isWorkOrderChanged(woc)) {alist.add(woc.wo);}
    	}
    	if (alist.isEmpty()) {return;}
		try {update alist; searchWorkOrders(); addInfoMsg('Saved the Changes');}
		catch (Exception e) {addErrMsg(e.getMessage());}
    }
    
}