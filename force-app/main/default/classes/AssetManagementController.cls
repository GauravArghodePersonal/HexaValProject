public class AssetManagementController {
	
    private static final Integer PAGE_SIZE = 200;
    private static final String COMMA = ',', CPER = ')', OPER = '(', QUOTE = '\'';
    
    // Asset Status Values
    private static final String AS_ASSIGNED = AssetManagementFunctions.AS_ASSIGNED;
    private static final String AS_NEW      = AssetManagementFunctions.AS_NEW;
    private static final String AS_RETIRED  = AssetManagementFunctions.AS_RETIRED;
    private static final String AS_RETURNED = AssetManagementFunctions.AS_RETURNED;
    private static final String AS_SOLD     = AssetManagementFunctions.AS_SOLD;
    private static final String AS_TRANSFER = AssetManagementFunctions.AS_TRANSFER;
    private static final String ALL         = 'All';
    private static final String ATPLANT     = 'ATPLANT';

    // Sort By Values
    private static final String SK_EQUPMNT  = 'Equipment_Name__c, Asset_Number__c';
    private static final String SK_ACCOUNT  = 'Assigned_Account__r.Name, Assigned_Account__r.AccountNumber';
    private static final String SK_ASETNUM  = 'Asset_Number__c';

    private static final Set<String> ATPLANT_SET = new Set<String>{
    	AS_NEW, AS_RETURNED, AS_TRANSFER
    };

    private static final String ATPLANT_STR = OPER +
        QUOTE + AS_NEW + QUOTE + COMMA +
        QUOTE + AS_RETURNED + QUOTE + COMMA +
        QUOTE + AS_TRANSFER + QUOTE + CPER;

    // Asset Status - value, label
    private static final List<SelectOption> statSelOps = new List<SelectOption>{
        new SelectOption(ALL,         'All Assets'),
        new SelectOption(AS_ASSIGNED, 'Assigned to Account'),
        new SelectOption(ATPLANT,     'Available at Plant'),
        new SelectOption(AS_NEW,      'New Assets'),
        new SelectOption(AS_RETIRED,  'Retired'),
        new SelectOption(AS_SOLD,     'Retired Sold'),
        new SelectOption(AS_RETURNED, 'Returned from Account'),
        new SelectOption(AS_TRANSFER, 'Transferred from another Plant')
    };
    
    // Asset Sort Keys - value, label
    private static final List<SelectOption> sortSelOps = new List<SelectOption>{
        new SelectOption(SK_ACCOUNT + COMMA + SK_EQUPMNT, 'Assigned Account'),
        new SelectOption(SK_EQUPMNT + COMMA + SK_ACCOUNT, 'Equipment Name'),
        new SelectOption(SK_ASETNUM, 'Asset Number')
    };
    
    // Submit Button Values
    private static final String ASSIGN_TO_ACCOUNT = 'Assign Selected Assets to Account';
    private static final String DELETE_ASSETS     = 'Delete Selected Assets';
    private static final String RETIRE_ASSETS     = 'Retire Selected Assets';
    private static final String UPDATE_ASSETS     = 'Save Changes';
    private static final String RETURN_TO_PLANT   = 'Return Selected Assets to Plant';
    private static final String TRANSFER_TO_PLANT = 'Transfer Selected Assets to Plant';

	public class AssetClass {
		public Asset   a               {get; set;}
        public String  assetNum        {get; set;}
        public String  assignedAccId   {get; set;}
        public String  assignedAccName {get; set;}
        public String  assignedAccNum  {get; set;}
        public String  equipmentId     {get; set;}
	    public String  equipmentName   {get; set;}
        public String  plantId         {get; set;}
        public String  plantName       {get; set;}
        public String  plantNum        {get; set;}
        public Integer quantity        {get; set;}
        public Integer recNum          {get; set;}
        public Boolean selected        {get; set;}

        public AssetClass() {}		
        public AssetClass(Asset a) {this(a, 1);}
		public AssetClass(Asset a, Integer n) {
			this.a = a; recNum = n; selected = false;
			assignedAccName = '';
			if (a.Assigned_Account__r != null) {
				assignedAccName = a.Assigned_Account__r.Name + ' - ' +
				String_Functions.removeLeadingZeros(a.Assigned_Account__r.AccountNumber);
			}
		}
	}
	
    public Account location1   {get; private set;}
    public Account plant1      {get; private set;}
    public Account plant2      {get; private set;}
	public Asset asset1        {get; private set;}
    public Product2 equipment1 {get; private set;}

    public Boolean allSelected             {get; set;}
    public Boolean allowedToCreateAssets   {get; private set;}
    public Boolean allowedToDeleteAssets   {get; private set;}
    public Boolean allowedToUpdateAssets   {get; private set;}
    public Boolean renderMsgs              {get; private set;}
    public Boolean renderAccountLkup       {get; private set;}
    public Boolean renderCreateAssetsForm  {get; private set;}
    public Boolean renderAssetsList        {get; private set;}
    public Boolean renderAssignBtn         {get; private set;}
    public Boolean renderCancelBtn         {get; private set;}
    public Boolean renderCreateBtn         {get; private set;}
    public Boolean renderDeleteBtn         {get; private set;}
    public Boolean renderInputFlds         {get; private set;}
    public Boolean renderUpdateBtn         {get; private set;}
    public Boolean renderPlantLkup         {get; private set;}
    public Boolean renderRetireBtn         {get; private set;}
    public Boolean renderReturnBtn         {get; private set;}
    public Boolean renderRevenueTxtBox     {get; private set;}
    public Boolean renderSearchBtn         {get; private set;}
    public Boolean renderSelectCBs         {get; private set;}
    public Boolean renderSubmitBtn         {get; private set;}
    public Boolean renderTrnsfrBtn         {get; private set;}
    public Boolean renderPaginationBtns    {get; private set;}
    public Boolean isAutoNation            {get; private set;}
    
    public AssetClass newAsset {get; set;}
    public List<AssetClass> newAssets {get; private set;}
    public List<AssetClass> assetList, selectedAssets;
    public List<Account> accounts     {get; private set;}
    public List<Account> plants       {get; private set;}
    public List<Product2> equipments  {get; private set;}
    public List<String> msgs          {get; private set;}
    
    public String assetId {get; private set;}
    public String submitBtnValue {get; private set;}
    public String sortBy {get; set;}
    
    public List<SelectOption> qtysops {get; private set;}
    
    public PaginationController pc {get; private set;}
    
    private void debug(String msg) {DebugLog_Functions.info('>>>>>>>>>>>>>>> ' + msg);}
    
    public AssetManagementController() {initPlant();}
    
    public AssetManagementController(ApexPages.StandardController sc) {
        init(sc.getRecord());
    }
    
    private void init(SObject sobj) {
        debug('sobj : ' + sobj);
        if (sobj != null) {
            if (sobj.getSObjectType() == Asset.sObjectType) {
                asset1 = (Asset)sobj;
                if (asset1.Id != null) {
                	assetId = asset1.Id;
                	asset1 = AssetManagementFunctions.getAsset(assetId);
                }
                if (asset1.AccountId != null) {
                    ApexPages.currentPage().getParameters().put('pid', asset1.AccountId);
                }
            } 
        }
        initPlant(); 
    }
    
    private void initPlant() {
    	//renderCreateAssetsForm = false; renderAssetsList = false;
    	isAutoNation = false;
        String pid = ApexPages.currentPage().getParameters().get('pid');
        if (isNull(pid)) {
        	addErrorMsg('Plant Info not known. Click on Assets button from the Plant Account page.'); return;
        } else {
        	try {plant1 = [select AccountNumber, Id, Name, SAP_DistChannel__c, 
        		                  SAP_DivisionCode__c, SAP_SalesGroup__c, 
        		                  SAP_Sales_Org__c 
        		             from Account where Id = :pid];}
        	catch(Exception e) {addErrorMsg('Plant not found'); return;}
        }
        allowedToCreateAssets = AssetManagementFunctions.isAssetCreatable();
        allowedToDeleteAssets = (Assets_Config__c.getInstance() != null &&
                                 Assets_Config__c.getInstance().Allowed_to_Delete_Assets__c);
        allowedToUpdateAssets = (Assets_Config__c.getInstance() != null &&
                                 Assets_Config__c.getInstance().Allowed_to_Update_Assets__c);
        isAutoNation = plant1 != null && plant1.Name.equals('AutoNation Equipment');
        initCreateForm();
        newAssets = new List<AssetClass>();
        assetList = new List<AssetClass>();
        setQtySops(); initNewAsset();
        plant2 = new Account();
        //newAssets = getTestAssets();
    }
    
    public void initCreateForm() {
    	//if (!allowedToCreateAssets) {return;}
        asset1 = new Asset();
        asset1.New_Used__c = AS_NEW;
        asset1.PurchaseDate = Date.today();
        asset1.Transaction_Date__c = Date.today();
        newAsset = new AssetClass(asset1);
        newAsset.plantId = plant1.Id;
        assetList = new List<AssetClass>(); pc = null;
        renderCreateAssetsForm = allowedToCreateAssets; renderPaginationBtns = false;
        renderCancelBtn = true; renderTrnsfrBtn = false;
        renderCreateBtn = false; renderAssignBtn = false;
        renderRetireBtn = false; renderReturnBtn = false;
        renderSearchBtn = false; renderSelectCBs = false;
        renderRevenueTxtBox = false; renderDeleteBtn = false;
        renderUpdateBtn = false; renderInputFlds = false; 
    }
    
    private void initNewAsset() {
        newAsset.assetNum = '';
    	newAsset.assignedAccId = null;
    	newAsset.assignedAccName = null;
    	newAsset.equipmentId = null;
    	newAsset.equipmentName = null;
        newAsset.plantId = plant1.Id;
        newAsset.plantName = plant1.Name;
    	newAsset.quantity = null;
    	newAsset.a.Market_Value__c = null;
    	newAsset.a.PurchaseDate = Date.today();
        newAsset.a.Transaction_Date__c = Date.today();
        newAsset.a.Price = null;
        newAsset.a.Name = ''; 
        newAsset.a.Status = ALL;
    }
    
    private Boolean isNull(String s) {
    	return (s == null || s.trim().length() == 0);
    }
    
    private void setQtySops() {
    	qtysops = new List<SelectOption>(); String v, l;
    	for (Integer i = 1; i <= 100; i++) {
            v = ''+i; l = ''+i;
    		qtysops.add(new SelectOption(v, l));
    	}
    }
    
    public List<SelectOption> getSortSelOps() {return sortSelOps;}
    public List<SelectOption> getStatSelOps() {return statSelOps;}
    
    public void setEquipments() {
    	msgs = new List<String>();
    	equipments = AssetManagementFunctions.getEquipments(newAsset.equipmentName, msgs);
    	renderMsgs = !msgs.isEmpty();
    }
    
    public void setAccounts() {
        msgs = new List<String>();
        accounts = AssetManagementFunctions.getAccounts(plant1, newAsset.assignedAccName, newAsset.assignedAccNum, msgs);
        renderMsgs = !msgs.isEmpty();
    }
    
    public void setPlants() {
        msgs = new List<String>();
        plants = AssetManagementFunctions.getPlants(plant1, plant2.Name, plant2.AccountNumber, msgs);
        renderMsgs = !msgs.isEmpty();
    }
    
    private Boolean validateCreate() {
    	Boolean b = true;
    	b &= !isNull(newAsset.equipmentId);
    	if (!b) {addErrorMsg('Invalid Equipment');}
    	return b;
    }
    
    public void createAssets() {
        renderAssetsList = !assetList.isEmpty();
    	if (!validateCreate()) {return;}
        Integer n = newAsset.quantity;
        List<Asset> alist = new List<Asset>();
        Asset a1 = newAsset.a, a2;
        for (Integer i = 0; i < n; i++) {
            a2 = a1.clone();
            a2.Status = AS_NEW;
        	a2.AccountId = newAsset.plantId;
        	a2.Product2Id = newAsset.equipmentId;
        	a2.Name = newAsset.equipmentName;
        	if (!isNull(newAsset.assignedAccId)) {
	        	a2.Assigned_Account__c = newAsset.assignedAccId;
	        	a2.Status = AS_ASSIGNED;
        	}
        	if (a2.Transaction_Date__c == null) {a2.Transaction_Date__c = a2.PurchaseDate;}
        	alist.add(a2);
        }
        initNewAsset();
        debug(''+alist);
        List<AssetClass> acs = new List<AssetClass>(); 
        n = assetList.size() + alist.size();
        try {
        	insert alist;
	        Set<String> assetIds = new Set<String>();
	        for (Asset a : alist) {assetIds.add(a.Id);}
	        alist = AssetManagementFunctions.getAssets(assetIds, 'order by Asset_Number__c desc');
	        for (Asset a : alist) {acs.add(new AssetClass(a, n--));}
        } catch(Exception e) {addErrorMsg('Error in creating Assets : ' + e.getMessage());}
        acs.addAll(assetList); assetList = acs;
        renderAssetsList = !assetList.isEmpty();
    }
    
    private void addErrorMsg(String s) {
	    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
	    ApexPages.addMessage(msg);
    }
    
    public void initAssetList() {
    	if (newAsset == null) {return;}
    	initNewAsset(); sortBy = SK_ACCOUNT + COMMA + SK_EQUPMNT;
        /*
        String qry = AssetManagementFunctions.ASSET_QRY1;
        qry += ' where AccountId = \'' + plant1.Id + '\'';
        if (assetId != null) {
            qry += ' and Id = \'' + assetId + '\'';
        }
        setAssetList(qry);
        */
        goBack(); 
    }
    
    public void goBack() {
        if (newAsset == null) {return;}
        searchAssets(); initFlags(); 
    }
    
    private void initFlags() {
        allSelected = false; renderCreateAssetsForm = false;
        renderAccountLkup = false; renderPlantLkup = false; 
        renderCancelBtn = false; renderTrnsfrBtn = allowedToCreateAssets;
        renderCreateBtn = allowedToCreateAssets; renderAssignBtn = allowedToCreateAssets;
        renderRetireBtn = allowedToCreateAssets; renderReturnBtn = allowedToCreateAssets;
        renderSearchBtn = true; renderSelectCBs = allowedToCreateAssets;
        renderSubmitBtn = false; renderRevenueTxtBox = false; renderInputFlds = false;
        renderDeleteBtn = allowedToDeleteAssets; renderUpdateBtn = allowedToUpdateAssets;
    }
    
    public void searchAssets() {
        String qry = AssetManagementFunctions.ASSET_QRY1;
        qry += ' where AccountId = \'' + plant1.Id + '\''; 
        if (!isNull(assetId)) {
            qry += ' and Id = \'' + assetId + '\'';
        } 
        if (!isNull(newAsset.assetNum)) {
            qry += ' and Asset_Number__c like \'%' + 
                   String.escapeSingleQuotes(newAsset.assetNum.trim()) +'%\'';
        }
        if (!isNull(newAsset.equipmentName)) {
            qry += ' and Equipment_Name__c like \'%' + 
                   String.escapeSingleQuotes(newAsset.equipmentName.trim()) +'%\'';
        }
        if (!isNull(newAsset.assignedAccName)) {
        	qry += ' and Assigned_Account__r.Name like \'%' + 
        	       String.escapeSingleQuotes(newAsset.assignedAccName.trim()) +'%\'';
        }
        if (!ALL.equals(newAsset.a.Status)) {
        	if (ATPLANT.equals(newAsset.a.Status)) {
                qry += ' and Status in ' + ATPLANT_STR;
        	} else {
                qry += ' and Status = \'' + newAsset.a.Status + '\'';
        	}
        } 
        setAssetList(qry);
    }
    
    private void setAssetList(String qry) {
        Database.Querylocator ql;
        qry += ' order by ' + sortBy;
        try {
	        ql = Database.getQueryLocator(qry);
	        pc = new PaginationController(ql, PAGE_SIZE);
	        setAssetList();
        } catch(Exception e) {debug('setAssetList : ' + e.getMessage());}
    }
    
    private void setAssetList() {
    	if (renderInputFlds) {return;}
    	renderAssetsList = false; renderPaginationBtns = false;
    	if (pc == null) {return;}
        assetList = new List<AssetClass>();
    	List<Asset> alist = (List<Asset>) pc.getRecords();
    	if (alist == null || alist.isEmpty()) {return;}
    	Integer n = pc.recordFrom;
    	for (Asset a : alist) {assetList.add(new AssetClass(a, n++));}
        renderPaginationBtns = true; renderCancelBtn = false;
        renderAssetsList = !assetList.isEmpty(); 
    }
    
    public List<AssetClass> getAssetList() {
    	setAssetList(); return assetList;
    }
    
    private void selectAssets() {
    	selectedAssets = new List<AssetClass>(); 
    	for (AssetClass a : assetList) {
    		if (a.selected) {selectedAssets.add(a);}
    	}
        if (selectedAssets.isEmpty()) {addErrorMsg('No Asset Selected'); return;}
    	pc = null; renderPaginationBtns = false;
    	renderCancelBtn = true; renderTrnsfrBtn = false;
    	renderCreateBtn = false; renderAssignBtn = false;
        renderRetireBtn = false; renderReturnBtn = false;
        renderSearchBtn = false; renderSelectCBs = false;
        renderDeleteBtn = false; renderUpdateBtn = false;
    }
    
    public void getAssetsToAssign() {
    	selectAssets(); if (selectedAssets.isEmpty()) {return;}
    	assetList = new List<AssetClass>();
        for (AssetClass ac : selectedAssets) {
            if (ATPLANT_SET.contains(ac.a.Status)) {assetList.add(ac);}
        }
        if (assetList.isEmpty()) {addErrorMsg('No Asset found to Assign to Account'); return;}
        //newAsset.assignedAccId = null;
        submitBtnValue = ASSIGN_TO_ACCOUNT;
    	renderAccountLkup = allowedToCreateAssets; renderSubmitBtn = allowedToCreateAssets;
    }
    
    public void getAssetsToReturn() {
        selectAssets(); if (selectedAssets.isEmpty()) {return;}
        assetList = new List<AssetClass>();
        for (AssetClass ac : selectedAssets) {
            if (AS_ASSIGNED.equals(ac.a.Status)) {assetList.add(ac);}
        }
        if (assetList.isEmpty()) {addErrorMsg('No Asset found to Return to Plant'); return;}
        submitBtnValue = RETURN_TO_PLANT;
        renderSubmitBtn = allowedToCreateAssets;
    }
    
    public void getAssetsToTransfer() {
        selectAssets(); if (selectedAssets.isEmpty()) {return;}
        assetList = new List<AssetClass>();
        for (AssetClass ac : selectedAssets) {
            if (AS_ASSIGNED.equals(ac.a.Status) ||
                ATPLANT_SET.contains(ac.a.Status)) {assetList.add(ac);}
        }
        if (assetList.isEmpty()) {addErrorMsg('No Asset found to Transfer'); return;}
        plant2 = new Account();
        submitBtnValue = TRANSFER_TO_PLANT;
        renderPlantLkup = allowedToCreateAssets; renderSubmitBtn = allowedToCreateAssets;
    }
    
    public void getAssetsToRetire() {
        selectAssets(); if (selectedAssets.isEmpty()) {return;}
        assetList = new List<AssetClass>();
        for (AssetClass ac : selectedAssets) {
            if (AS_ASSIGNED.equals(ac.a.Status) ||
                ATPLANT_SET.contains(ac.a.Status)) {assetList.add(ac);}
        }
        if (assetList.isEmpty()) {addErrorMsg('No Asset found to Retire'); return;}
        submitBtnValue = RETIRE_ASSETS;
        renderSubmitBtn = allowedToCreateAssets; renderRevenueTxtBox = allowedToCreateAssets;
    }
    
    public void getAssetsToDelete() {
        selectAssets(); if (selectedAssets.isEmpty()) {return;}
        assetList = new List<AssetClass>();
        for (AssetClass ac : selectedAssets) {assetList.add(ac);}
        if (assetList.isEmpty()) {addErrorMsg('No Asset found to Delete'); return;}
        submitBtnValue = DELETE_ASSETS; renderSubmitBtn = allowedToCreateAssets;
    }
    
    public void getAssetsToUpdate() {
        selectAssets(); if (selectedAssets.isEmpty()) {return;}
        assetList = new List<AssetClass>();
        for (AssetClass ac : selectedAssets) {assetList.add(ac);}
        if (assetList.isEmpty()) {addErrorMsg('No Asset found to Update'); return;}
        submitBtnValue = UPDATE_ASSETS; renderSubmitBtn = allowedToUpdateAssets; renderInputFlds = true;
    }
    
    public void copyChangesToAll() {
        renderAssetsList = !assetList.isEmpty(); if (!renderAssetsList) {return;}
        String newUsed = assetList[0].a.New_Used__c;
        Decimal price  = assetList[0].a.Price;
        Decimal mktval = assetList[0].a.Market_Value__c;
        for (AssetClass ac : assetList) {
        	ac.a.New_Used__c     = newUsed;
            ac.a.Price           = price;
            ac.a.Market_Value__c = mktval;
        }
    }
    
    private Boolean validateUpdate() {
        Boolean b = true;
        if (ASSIGN_TO_ACCOUNT.equals(submitBtnValue) &&
            isNull(newAsset.assignedAccId)) {
            addErrorMsg('Invalid Account'); b &= false;
        }
        if (TRANSFER_TO_PLANT.equals(submitBtnValue) &&
            isNull(newAsset.plantId)) {
            addErrorMsg('Invalid Plant'); b &= false;
        }
        if (newAsset.a.Transaction_Date__c == null) {
            addErrorMsg('Invalid Start Date'); b &= false;
        }
        return b;
    }
    
    public void updateAssets() {
        renderAssetsList = !assetList.isEmpty(); 
    	if (!validateUpdate()) {return;}
    	List<Asset> alist = new List<Asset>(); Asset a;
    	Boolean b1 = (ASSIGN_TO_ACCOUNT.equals(submitBtnValue) &&
                     !isNull(newAsset.assignedAccId));
        Boolean b2 = (RETURN_TO_PLANT.equals(submitBtnValue));
        Boolean b3 = (TRANSFER_TO_PLANT.equals(submitBtnValue) &&
                     !isNull(plant2.Id));
        Boolean b4 = (RETIRE_ASSETS.equals(submitBtnValue));
        Boolean b5 = (newAsset.a.Revenue_from_Sale__c != null &&
                      newAsset.a.Revenue_from_Sale__c > 0);
        Boolean b6 = (DELETE_ASSETS.equals(submitBtnValue));
        Boolean b7 = (UPDATE_ASSETS.equals(submitBtnValue));
        Boolean b;
        for (AssetClass ac : assetList) {
        	a = ac.a; b = false;
            if (b1 && a.Assigned_Account__c != newAsset.assignedAccId) {
            	a.Assigned_Account__c = newAsset.assignedAccId;
                a.Transaction_Date__c = newAsset.a.Transaction_Date__c;
            	a.Start_Date__c = a.Transaction_Date__c;
            	a.Status = AS_ASSIGNED; b = true;
            } else
            if (b2) {
            	a.Assigned_Account__c = null;
                a.Transaction_Date__c = newAsset.a.Transaction_Date__c;
                a.Status = AS_RETURNED; b = true;
            } else
            if (b3 && a.AccountId != plant2.Id) {
                a.AccountId = plant2.Id;
                a.Transaction_Date__c = newAsset.a.Transaction_Date__c;
                a.Status = AS_TRANSFER; b = true;
            } else
            if (b4) {
                a.Assigned_Account__c = null;
                a.Transaction_Date__c = newAsset.a.Transaction_Date__c;
                a.Status = AS_RETIRED; b = true;
                if (b5) {
                    a.Revenue_from_Sale__c = newAsset.a.Revenue_from_Sale__c;
                    a.Status = AS_SOLD;
                }
            } else
            if (b6 || b7) {b = true;}
            if (b) {alist.add(a);}
        }
        if (!alist.isEmpty()) {
        	try {
        		if (b6) {delete alist;} else {update alist;}
            } catch(Exception e) {addErrorMsg('Error in updating Assets : ' + e.getMessage());}
        }
        initAssetList();
    }
    
}