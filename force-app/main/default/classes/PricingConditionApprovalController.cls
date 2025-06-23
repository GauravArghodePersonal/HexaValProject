public class PricingConditionApprovalController {

    private static final Integer PAGE_SIZE = 50;
    private static final String ALL = PricingConditionApprovalFunctions.ALL;
    private static final String NONE = PricingConditionApprovalFunctions.NONE;
    
    //private static final Set<String> ACC_REC_TYPES_AAFI = new Set<String>{'Aqualon Customer', 'Aqualon Prospect'};
    //private static final Set<String> ACC_REC_TYPES_AHWT = new Set<String>{'Drew Customer', 'Water Prospect'};
    
    List<Pricing_Condition> plist;
    List<Pricing_Condition> tlist;
    List<Pricing_Condition__c> slist;
    Account acc; Pricing_Condition__c pricingCondition;

    public Boolean allSelected           {get; set;}
    public Boolean isEditable            {get; private set;}
    public Boolean renderAccountOptions  {get; private set;}
    public Boolean renderApproveButton   {get; private set;}
    public Boolean renderCancelButton    {get; private set;}
    public Boolean renderEditButton      {get; private set;}
    public Boolean renderLeadTime        {get; private set;}
    public Boolean renderPaginationBtns  {get; private set;}
    public Boolean renderRejectButton    {get; private set;}
    public Boolean renderReviewComments  {get; private set;}
    public Boolean renderSaveButton      {get; private set;}
    public Boolean renderSortOptions     {get; private set;}
    public Boolean refreshPlist          {get; private set;}

    public Integer pageNumber            {get; set;}
    public Integer pageSize              {get; set;}
    public List<SelectOption> accSelOpts {get; private set;}
    public PageReference returnPage      {get; private set;}
    public PaginationController pgntr    {get; private set;}

    public String accountId              {get; set;}
    //public String accountRecordType      {get; private set;}
    public String title                  {get; private set;}
    public String userComments           {get; set;} 
    public String userLocale             {get; private set;} 

    public String orderByVal             {get; set;}
    public String orderByLbl1            {get {return 'Account Name + Material Name : A to Z';}}
    public String orderByVal1            {get {return 'Account__r.Name, Material2__r.Material_Desc__c, Valid_From_Date__c';}}
    public String orderByLbl2            {get {return 'Created Date : Old to New';}}
    public String orderByVal2            {get {return 'Created_Date__c';}}
    public String orderByLbl3            {get {return 'Gross Profit Percent : High to Low';}}
    public String orderByVal3            {get {return 'Gross_Profit_Percent__c desc';}}

    public PricingConditionApprovalController() {}
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, 'PCApprovalController : ' + s);
    }
    
    public void initAction() {
        accountId = ALL; orderByVal = null; pageSize = PAGE_SIZE;
        title = 'Pricing Conditions to be Approved';
        userLocale = UserInfo.getLocale();
        init2();
    }
    
    public void init2() {
        slist = new List<Pricing_Condition__c>();
        userComments = ''; allSelected = false;
        returnPage = null; renderCancelButton = false; renderSaveButton = false;
        isEditable = false; renderLeadTime = false; renderApproveButton = true;
        renderRejectButton = true; renderAccountOptions = true;
        renderReviewComments = true; renderPaginationBtns = true;
        renderSortOptions = true; renderEditButton = false;
        if (Pricing_Security__c.getInstance() != null) {
            renderEditButton = Pricing_Security__c.getInstance().Allowed_to_edit_PricingConditions__c;
        }
        Set<String> pcids = PricingConditionApprovalFunctions.getPCIdsPendingApproval(null);
        if (pcids == null || pcids.isEmpty()) {
            plist = new List<Pricing_Condition>();
            returnPage = Page.PendingApprovals;
            return;
        }
        init3(pcids);
    }
    
    public void init3(Set<String> pcids) {
        setPricingCondition(pcids);
        if (orderByVal == null) {
            orderByVal = orderByVal1; if (isAhwtLayout) {orderByVal = orderByVal3;}
        }
        pgntr = PricingConditionApprovalFunctions.getPaginationController(pcids, orderByVal, pageSize, accountId);
        setPlist();
        plist = PricingConditionApprovalFunctions.getPricingConditions(pgntr);
        //accountRecordType = PricingConditionFunctions.getAccountRecordType(plist[0].pricingCondition);
        Set<String> accIds = PricingConditionApprovalFunctions.getAccountIds(pcids);
        accSelOpts = PricingConditionApprovalFunctions.getAccSelOpts(accIds);
    }
    
    private void setPricingCondition(Set<String> pcids) {
        pricingCondition = PricingConditionApprovalFunctions.getPricingCondition(pcids);
        if (pricingCondition != null) {acc = pricingCondition.Account__r;}
        if (acc != null) {renderLeadTime = SAP_Queries_Functions.isAHWT_EMEA(acc) && 
        	                               SAP_Queries_Functions.isStreamLink(acc);}
    }
    
    public List<Pricing_Condition> getPricingConditions() {return plist;}
    
    private void setPlist() {
    	pageNumber = pgntr.getPageNumber();
        plist = PricingConditionApprovalFunctions.getPricingConditions(pgntr);
        if (plist != null && !plist.isEmpty()) {pricingCondition = plist[0].pricingCondition;}
    }
    
    public void changePageSize() {pgntr.setPageSize(pageSize); setPlist();}
    public void gotoFirstPage() {pgntr.first(); setPlist();}
    public void gotoPrevPage() {pgntr.previous(); setPlist();}
    public void gotoNextPage() {pgntr.next(); setPlist();}
    public void gotoLastPage() {pgntr.last(); setPlist();}
    public void gotoPage() {pgntr.setPageNumber(pageNumber); setPlist();}
    
    private Set<String> getSelectedObjectIds() {
        Set<String> ss = new Set<String>();
        for (Pricing_Condition pc : plist) {
            if (pc.selected) {
                ss.add(pc.pricingCondition.id);
            }
        }
        return ss;
    }
    
    public PageReference editPricingConditions() {
    	Set<id> msd2Ids = new Set<id>(); tlist = new List<Pricing_Condition>();
        Pricing_Condition__c pcc;
        for (Pricing_Condition pc : plist) {
        	if (pc.selected) {
        		pcc = pc.pricingCondition;
        		msd2Ids.add(pcc.Material2__c);
        		pc.plantId = pcc.SAP_Plant__c;
        		if (isNull(pc.plantId)) {pc.plantId = NONE;}
        		pc.freightCost = pcc.Freight_Cost__c;
        		pc.freightMarkup = pcc.Freight_Mark_Up__c;
        		tlist.add(pc);
        	}
        }
        if (tlist.isEmpty()) {addErrorMessage('None selected to edit.'); return null;}
        plist = tlist;
        Map<Id, List<Material_Plant2__c>> mp2map = Material_Sales_Data_Functions.getMaterialPlantMap(msd2Ids);
        //debug('mp2map : ' + mp2map);
        Map<Id, List<SelectOption>> psomap = getPlantSelectOptions(mp2map);
        for (Pricing_Condition pc : plist) {
            if (pc.selected) {pc.selOpts1 = psomap.get(pc.pricingCondition.Material2__c);}
        }
        isEditable = true;
        renderEditButton = false;
        renderCancelButton = true;
        renderSaveButton = true;
        renderApproveButton = false;
        renderRejectButton = false;
        renderAccountOptions = false;
        renderReviewComments = true;
        renderPaginationBtns = false;
        renderSortOptions = false;
        returnPage = Page.PricingConditionApprovals;
        return null;
    }
    
    // Map<Material_Sales_Data2__c, List<SelectOption>>
    private Map<Id, List<SelectOption>> getPlantSelectOptions(Map<Id, List<Material_Plant2__c>> mp2map) {
    	Map<Id, List<SelectOption>> amap = new Map<Id, List<SelectOption>>();
    	if (mp2map == null || mp2map.isEmpty()) {return amap;}
    	List<Material_Plant2__c> mp2s; List<SelectOption> sos;
    	List<String> sa1, sa2; String d = '!@#';
    	for (Id i : mp2map.keySet()) {
    		mp2s = mp2map.get(i);
    		sa1 = new List<String>();
    		for (Material_Plant2__c mp2 : mp2s) {
    			if (mp2.Deletion_Flag__c != 'X') {
	                //debug(mp2.Plant_Name__c + d + mp2.Plant_Code__c + d + mp2.SAP_Plant__c);
	    			sa1.add(mp2.Plant_Name__c + d + mp2.Plant_Code__c + d + mp2.SAP_Plant__c);
    			}
    		}
    		sos = new List<SelectOption>();
    		sos.add(new SelectOption(NONE, NONE));
    		if (!sa1.isEmpty()) {
	    		sa1.sort();
	    		for (String s : sa1) {
	    			sa2 = s.split(d);
	    			sos.add(new SelectOption(sa2[2], sa2[0]+' - '+sa2[1]));
	    		}
    		}
    		amap.put(i, sos);
    	}
    	return amap;
    }
    
    private Boolean validatePricingCondition(Pricing_Condition pc) {
    	Boolean b = true; pc.comments = '';
    	Date d1 = pc.pricingCondition.Valid_From_Date__c, 
    	     d2 = pc.pricingCondition.Valid_To_Date__c, 
    	     d3 = pc.validToDate, d4 = d1.addYears(1);
    	if (d2 != d3) {
    		Integer n1 = d1.daysBetween(d2), n2 = d2.daysBetween(d4);
    		if (n1 < 0 || n2 < 0) {b = false;
    			pc.comments = 'Valid-To-Date should be between ' + 
    			              d1.format() + ' and ' + d4.format();
    		}
    	} 
    	if (!b) {addErrorMessage('Error in Row # : ' + pc.recordNumber);}
    	return b;
    }
    
    private Boolean savePricingConditions() {
        Pricing_Condition__c pcc;
        List<Pricing_Condition__c> pccs = new List<Pricing_Condition__c>();
        Boolean b; Integer invalidCount = 0;
        for (Pricing_Condition pc : plist) {
            if (pc.selected) {
            	if (!validatePricingCondition(pc)) {
            		invalidCount++; continue;
            	}
            	pcc = pc.pricingCondition; b = false;
            	if (pcc.Valid_To_Date__c != pc.validToDate) {
            		b = true; pcc.Revised_by_Approver__c = true;
                    pcc.Revision_Comments__c = 'Revised Valid-To-Date';
            	}
                if (pcc.SAP_Plant__c != null && pc.plantId == NONE) {
                    pcc.SAP_Plant__c = null; b = true;
                } else if (pc.plantId != NONE && pc.plantId != pcc.SAP_Plant__c){
                    pcc.SAP_Plant__c = pc.plantId; b = true;
                }
                if (pcc.Freight_Cost__c != pc.freightCost) {b = true;}
                if (pcc.Freight_Mark_Up__c != pc.freightMarkup) {b = true;}
                if (b) {pccs.add(pcc);}
            }
        }
        if (invalidCount > 0) {return false;}
        if (!pccs.isEmpty()) {
        	//PricingConditionFunctions.setPriceBookEntries(pccs);
            try {update pccs;} catch(Exception e) {
            	debug('savePricingConditions : ' + e);
            }
        }
        return true;
    }
    
    private Boolean approvePricingConditions() {
        Set<String> oids = getSelectedObjectIds();
        if (oids.isEmpty()) {addErrorMessage('None selected to approve.'); return false;}
        updateApproverComments();
        Custom_Approval_Functions.approveObjects(oids, userComments);
        return true;
    }
    
    public PageReference saveChanges() {
    	Boolean b = savePricingConditions(); 
        if (!b) {return null;}
    	return cancel();
    }
    
    public PageReference saveChangesAndApprove() {
        Boolean b = savePricingConditions();
        if (!b) {return null;}
        b = approvePricingConditions();
        if (b) {init2();}
        return returnPage;
    }
    
    public PageReference cancel() {
        Integer currentPage = pageNumber;
        init2();
        pageNumber = currentPage; gotoPage(); 
        return returnPage;
    }
    
    public PageReference approveSelectedList() {
    	Boolean b = approvePricingConditions();
        if (b) {init2();}
        return returnPage;
    }
    
    public PageReference rejectSelectedList() {
        Set<String> oids = getSelectedObjectIds();
        Boolean b1 = oids.isEmpty(); 
        if (b1) {addErrorMessage('None selected to reject.');}
        Boolean b2 = isNull(userComments);
        if (b2) {addErrorMessage('Reject Comments are required.');}
        if (b1 || b2) {return null;}
        updateApproverComments();
        Custom_Approval_Functions.rejectObjects(oids, userComments);
        init2();
        return returnPage;
    }
    
    private void addErrorMessage(String s) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, s));
    }
    
    private void updateApproverComments() {
        if (isNull(userComments)) {return;}
        String dt = Datetime.now().format();
        String un = UserInfo.getName();
        String cs = dt + ' : ' + un + ' : ' + userComments + '\n';
        Pricing_Condition__c pcc;
        List<Pricing_Condition__c> pccs = new List<Pricing_Condition__c>();
        String ac;
        for (Pricing_Condition pc : plist) {
            if (pc.selected) {
                pcc = pc.pricingCondition;
                ac = pcc.Approver_Comments__c;
                if (isNull(ac)) {ac = '';}
                ac = cs + ac;
                pcc.Approver_Comments__c = ac;
                pccs.add(pcc);
            }
        }
        if (!pccs.isEmpty()) {
            try {update pccs;} catch(Exception e) {}
        }
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }

    public Boolean isDefaultLayout {
        get {
            return (!isAafiLayout && !isAhwtLayout);
        }
    }
    
    public Boolean isAafiLayout {
        get {return acc != null && SAP_Queries_Functions.isAAFI(acc);}
    }
    
    public Boolean isAhwtLayout {
        get {return acc != null && SAP_Queries_Functions.isAHWT(acc);}
    }
    
/*
 **********************************************************
 Test Methods are in PricingConditionFunctions_Test class
 ********************************************************** 
 */    

}