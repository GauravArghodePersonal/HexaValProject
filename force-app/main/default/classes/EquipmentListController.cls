public with sharing class EquipmentListController {

    private static final Integer PAGE_SIZE = 200;
    
    private static final String RPT1 = EquipmentListFunctions.REPORT1;
    private static final Id equipRecTypeId = EquipmentListFunctions.getEquipmentRecordTypeId();
    
    // Submit Button Values
    private static final String DELETE_EQUIPS = 'Delete Selected Equipments';
    private static final String DEACTIVATE_EQUIPS = 'Deactivate Selected Equipments';
    
    public class Equipment {
        public Product2 p         {get; set;}
        public Integer  recNum    {get; set;}
        public Boolean  selected  {get; set;}

        public Equipment() {}      
        public Equipment(Product2 p) {this(p, 1);}
        public Equipment(Product2 p, Integer n) {
            this.p = p; recNum = n; selected = false;
        }
    }
    
    public Boolean allSelected             {get; set;}
    public Boolean allowedToCreate         {get; private set;}
    public Boolean allowedToDelete         {get; private set;}
    public Boolean renderMsgs              {get; private set;}
    public Boolean renderCreateForm        {get; private set;}
    public Boolean renderEquipsList        {get; private set;}
    public Boolean renderCancelBtn         {get; private set;}
    public Boolean renderCreateBtn         {get; private set;}
    public Boolean renderDeactivateBtn     {get; private set;}
    public Boolean renderDeleteBtn         {get; private set;}
    public Boolean renderSearchBtn         {get; private set;}
    public Boolean renderSelectCBs         {get; private set;}
    public Boolean renderSubmitBtn         {get; private set;}
    public Boolean renderPaginationBtns    {get; private set;}
    
    public Equipment newEquip              {get; set;}
    public List<Equipment> newEquips       {get; private set;}
    public List<Equipment> equipList, selectedEquips;
    public List<Product2> equips           {get; private set;}
    public List<String> msgs               {get; private set;}
    
    public String assetReportId            {get; private set;}
    public String submitBtnValue           {get; private set;}
    
    private ApexPages.StandardSetController ssc;
    
    private Set<Id> newEquipIds;
    
    public PaginationController pc         {get; private set;}
    
    private void debug(String msg) {DebugLog_Functions.info(msg);}
    
    public EquipmentListController() {init();}
    
    private void init() {
        allowedToCreate = (Assets_Config__c.getInstance() != null &&
                           Assets_Config__c.getInstance().Allowed_to_Create_Equipments__c);
        allowedToDelete = (Assets_Config__c.getInstance() != null &&
                           Assets_Config__c.getInstance().Allowed_to_Delete_Equipments__c);
        assetReportId = EquipmentListFunctions.getReportId(RPT1);
        newEquip = new Equipment(new Product2());
        newEquip.p.RecordTypeId = equipRecTypeId;
        initCreateForm();
        newEquips = new List<Equipment>();
        equipList = new List<Equipment>();
        newEquipIds = new Set<Id>();
        initNewEquip();
    }
    
    public void initCreateForm() {
        equipList = new List<Equipment>(); pc = null;
        newEquipIds = new Set<Id>();
        renderCreateForm = true; renderPaginationBtns = false;
        renderCancelBtn = true; renderCreateBtn = false;
        renderSearchBtn = false; renderSelectCBs = false;
        renderDeleteBtn = false; renderDeactivateBtn = false; 
    }
    
    private void initNewEquip() {
    }
    
    private Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public void createEquipment() {
        Product2 p = newEquip.p.clone();
        p.IsActive = true;
        p.RecordTypeId = equipRecTypeId;
        p.Key__c = EquipmentListFunctions.getEquipmentKey(p);
        initNewEquip();
        List<Equipment> acs = new List<Equipment>(); 
        Integer n = equipList.size() + 1;
        upsertEquipment(p);
        if (!newEquipIds.contains(p.Id)) {
        	newEquipIds.add(p.Id); acs.add(new Equipment(p, n));
        } else {
            List<Equipment> es = new List<Equipment>(); 
        	for (Equipment e : equipList) {
        		if (e.p.Key__c.equals(p.Key__c)) {
        			e = new Equipment(p, e.recNum);
        		}
                es.add(e);
        	}
        	equipList = es;
        }
        acs.addAll(equipList); equipList = acs;
        renderEquipsList = !equipList.isEmpty();
    }
    
    private void upsertEquipment(Product2 p) {
        try {insert p;} catch(Exception e1) {
            addInfoMsg(p.Key__c + ' already exists and updated it');
            try {upsert p Key__c;} catch(Exception e2) {addErrorMsg(e2.getMessage());}
	        String pid = p.Id; String q = EquipmentListFunctions.QRY1 + ' where Id = :pid';
	        List<Product2> ps = Database.query(q); if (!ps.isEmpty()) {p = ps[0];}
        }
    }
    
    private void addErrorMsg(String s) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(msg);
    }
    
    private void addInfoMsg(String s) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, s);
        ApexPages.addMessage(msg);
    }
    
    public void initEquipList() {
        newEquip = new Equipment(new Product2());
        newEquip.p.RecordTypeId = equipRecTypeId;
        searchEquips(); allSelected = false;
        renderCreateForm = false;
        renderCancelBtn = false;
        renderCreateBtn = allowedToCreate; renderDeactivateBtn = allowedToCreate;
        renderSearchBtn = true; renderSelectCBs = true;
        renderSubmitBtn = false;
        renderDeleteBtn = allowedToDelete; 
    }
    
    public void setEquipList() {
        renderEquipsList = false; renderPaginationBtns = false;
        if (pc == null) {return;}
        equipList = new List<Equipment>();
        List<Product2> alist = (List<Product2>) pc.getRecords();
        if (alist == null || alist.isEmpty()) {return;}
        Integer n = pc.recordFrom;
        for (Product2 a : alist) {equipList.add(new Equipment(a, n++));}
        renderPaginationBtns = true; renderCancelBtn = false;
        renderEquipsList = !equipList.isEmpty(); 
    }
    
    public void searchEquips() {
        String sorts = ' order by Key__c';
        pc = EquipmentListFunctions.getEquipmentPC(PAGE_SIZE, sorts, newEquip.p);
        setEquipList();
    }
    
    public List<Equipment> getEquipList() {
        setEquipList(); return equipList;
    }
    
    private void selectEquips() {
        selectedEquips = new List<Equipment>(); 
        for (Equipment a : equipList) {
            if (a.selected) {selectedEquips.add(a);}
        }
        if (selectedEquips.isEmpty()) {addErrorMsg('No Equipment Selected'); return;}
        pc = null; renderPaginationBtns = false;
        renderCancelBtn = true; renderCreateBtn = false;
        renderSearchBtn = false; renderSelectCBs = false;
        renderDeleteBtn = false; renderDeactivateBtn = false;
    }
    
    public void getEquipsToDeactivate() {
        selectEquips(); if (selectedEquips.isEmpty()) {return;}
        equipList = new List<Equipment>();
        for (Equipment ac : selectedEquips) {equipList.add(ac);}
        if (equipList.isEmpty()) {addErrorMsg('No Equipment found to Deactivate'); return;}
        submitBtnValue = DEACTIVATE_EQUIPS; renderSubmitBtn = true;
    }
    
    public void getEquipsToDelete() {
        selectEquips(); if (selectedEquips.isEmpty()) {return;}
        equipList = new List<Equipment>();
        for (Equipment ac : selectedEquips) {equipList.add(ac);}
        if (equipList.isEmpty()) {addErrorMsg('No Equipment found to Delete'); return;}
        submitBtnValue = DELETE_EQUIPS; renderSubmitBtn = true;
    }
    
    public void updateEquips() {
        List<Product2> plist = new List<Product2>(); Product2 p; Boolean b;
        Boolean b1 = (DEACTIVATE_EQUIPS.equals(submitBtnValue));
        Boolean b2 = (DELETE_EQUIPS.equals(submitBtnValue));
        for (Equipment e : equipList) {
        	p = e.p; b = false;
            if (b1) {p.IsActive = false; b = true; 
            } else 
            if (b2) {b = true;}
            if (b) {plist.add(p);}
        }
        if (!plist.isEmpty()) {
        	try {
        		if (b2) {delete plist;} else {update plist;}
        	} catch(Exception e) {}
        }
        initEquipList();
    }
    
}