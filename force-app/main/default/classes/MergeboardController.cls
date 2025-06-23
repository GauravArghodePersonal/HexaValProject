public with sharing class MergeboardController {

    

    public List<MergeboardAccountItem> mergeboardAccountItems {get;set;}
    public Boolean showValidationMessage {get;set;}
    public Boolean selectionValid {get;set;}
    public String validationSummary {get;set;}
    public String validationSeverity {get;set;}
    public Integer validationStrength {get;set;}
    public Integer idSelectionCount {get;set;}
    public Boolean mergeboardEnabled {
        get {
            return MergeboardMethods.mergeboardEnabled();
        }
        private set;
    }

    public Id mergeboardAccountItemId {get;set;}
    public Boolean selected {get;set;}
   
    private final Integer MIN_NUMBER_OF_ACCOUNTS = 2;
    private final Integer MAX_NUMBER_OF_ACCOUNTS = 3;
   
    private String runAsAdmin = '';
    private String ignoreMaxLimit = '';
   
    public MergeboardController() {
        init();     
    }
    
    public void init() {
        selectAllCheckboxValue = false;
        selectionValid = false;
        showValidationMessage = false;
        validationSummary = '';
        validationSeverity = 'info';
        validationStrength = 1;
        idSelectionCount = 0;
        itemsExist = false;
        
        runAsAdmin = ApexPages.currentPage().getParameters().get('runAsAdmin');
        ignoreMaxLimit = ApexPages.currentPage().getParameters().get('ignoreMaxLimit');

        refresh();
    }
    
    public void refresh() {
        mergeboardAccountItems = MergeboardMethods.retrieveAccountItems();
        if (mergeboardAccountItems.size() > 0) {itemsExist = true;} else {itemsExist = false;}
        validateSelection();
    }
   
   public boolean itemsExist {get;set;}
   
    public void removeMergeboardAccountItem() {
        if (mergeboardAccountItemId != null) {
            MergeboardMethods.removeAccountFromMergeboard(mergeboardAccountItemId);
            refresh();  
        }
    }
   
    public void clearMergeboard() {
        List<Mergeboard_Account_Item__c> itemsToDelete = new List<Mergeboard_Account_Item__c>(); 
        refresh();
        for (MergeboardAccountItem item : mergeboardAccountItems) {
            itemsToDelete.add(item.sourceRec);
        }
        delete itemsToDelete;
        refresh();  
    }
    
    public void doNothing() {}
    
    public void selectItem() {
        for (MergeboardAccountItem item : mergeboardAccountItems) {
            if (item.mergeboardAccountItemId == mergeboardAccountItemId) {item.selected = selected;}
        }
        validateSelection();
    }
    
    public Boolean selectAllCheckboxValue {get;set;}

    public void selectAll() {
        for (MergeboardAccountItem item : mergeboardAccountItems) {
            item.selected = selectAllCheckboxValue;
        }
        validateSelection();
    }
    
    public String mergeStep2URL {
        get {
            String url = '/merge/accmergewizard.jsp?goNext=+Next+';
            for (MergeboardAccountItem item : mergeboardAccountItems) {if (item.selected) {url += '&cid=' + item.accountId;}}
            url+= '&retURL=%2Fapex%2FMergeboard';
            url+= '&canURL=%2Fapex%2FMergeboard';
            return url;
        }
    }
   
    public Boolean isAdmin { 
        get {
            Boolean result = false;
            
            if (String.isNotEmpty(runAsAdmin)) {
                if (runAsAdmin == 'true') {result = true;}
                if (runAsAdmin == 'false') {result = false;}
            }
            //else {
            //  result = (User_Functions.isSysAdmin() || User_Functions.isSupport());               
            //}
            
            return result;
        }
    }
   
    public void validateSelection() {
        Integer idCount = 0;

        for (MergeboardAccountItem item : mergeboardAccountItems) {
            if (item.selected) {idCount++;}
        }

        selectionValid = false;
        showValidationMessage = false;
        validationSummary = '';
        validationSeverity = '';
        validationStrength = 0;
        
        if ((idCount >= MIN_NUMBER_OF_ACCOUNTS) && (idCount <= MAX_NUMBER_OF_ACCOUNTS || ignoreMaxLimit == 'true')) {
            selectionValid = true;
        }
        else {
            if (idCount < MIN_NUMBER_OF_ACCOUNTS) {
                showValidationMessage = false;
                validationSummary = 'Error: At least ' + MIN_NUMBER_OF_ACCOUNTS + ' accounts need to be selected 2 merge.  Please select at least ' + MIN_NUMBER_OF_ACCOUNTS + ' items.';
                validationSeverity = 'error';
                validationStrength = 3;
            }
            else {
                if (idCount > MAX_NUMBER_OF_ACCOUNTS && ignoreMaxLimit != 'true') {
                    showValidationMessage = true;
                    validationSummary = 'Error: A maximum of ' + MAX_NUMBER_OF_ACCOUNTS + ' accounts can be merged at a time.  Please lower your selection to ' + MAX_NUMBER_OF_ACCOUNTS + ' items.';
                    validationSeverity = 'error';
                    validationStrength = 3;
                }
            }
        }
        
        idSelectionCount = idCount;
    }
    
    public void addTestData() {
        MergeboardMethods.AddAccountToMergeboardResult result1 = MergeboardMethods.addAccountToMergeboard('0015000000QI1hw'); //Keeneland
        MergeboardMethods.AddAccountToMergeboardResult result2 = MergeboardMethods.addAccountToMergeboard('0015000000QHl1g'); //Keener Sand And Clay
        MergeboardMethods.AddAccountToMergeboardResult result3 = MergeboardMethods.addAccountToMergeboard('0015000000QH7ag'); //Keener Test Distribution
        refresh();  
    }
}