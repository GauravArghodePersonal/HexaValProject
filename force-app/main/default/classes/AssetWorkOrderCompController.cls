public class AssetWorkOrderCompController {

    private static final String DELIM = ':';

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
    
    public Account acc                    {get; private set;}
    public Asset_Work_Order__c wo         {get; private set;}
    
    public String accountId               {get; private set;}
    public String accountNumber           {get; private set;}
    public String billToCustomer          {get; private set;}
    public String highPriorityJob         {get; private set;}
    public String salesGroup              {get; private set;}
    
    public Boolean renderSelectedAssets   {get; private set;}
    public Boolean renderWorkOrder        {get; private set;}
    
    public List<AssetClass> selectedAssets = new List<AssetClass>();
    
    private Set<String> selectedAssetIds;

    private void debug(String s) {DebugLog_Functions.info('>>>>>>>> ' + s);}
    
    private String workOrderId;
    
    public String getWorkOrderId() {return workOrderId;}
    
    public void setWorkOrderId(String woId) {workOrderId = woId; init();}
    
    private void init() {
        renderWorkOrder = (workOrderId != null); renderSelectedAssets = false;
    	if (!renderWorkOrder) {return;}
        wo = AssetWorkOrderFunctions.getWorkOrder(workOrderId);
        accountId = wo.Account__c; acc = null;
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
        renderSelectedAssets = !selectedAssets.isEmpty();
        billToCustomer = wo.Bill_to_Customer__c ? 'Yes' : 'No';
        highPriorityJob = wo.High_Priority__c ? 'Yes' : 'No';
    }
    
    public List<AssetClass> getSelectedAssets() {return selectedAssets;}
    
    private void setSelectedAssets() {
        Integer n = 1; AssetClass ac;
        List<Asset> alist = AssetWorkOrderFunctions.getAssets(selectedAssetIds); 
        selectedAssets = new List<AssetClass>();
        for (Asset a : alist) {
            ac = new AssetClass(a, n++);
            selectedAssets.add(ac);
        }
        sortSelectedAssets();
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
    
}