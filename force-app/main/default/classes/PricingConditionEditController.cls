public with sharing class PricingConditionEditController {

    private static final Integer PAGE_SIZE = 200;
    private static final String COMMA    = ',';
    private static PageReference PAGE2 = Page.PricingConditionEditPage2;
    
    private static final String ACTIVE    = 'Active';
    private static final String ALL       = 'All';
    private static final String APPROVED  = 'Approved,Not Yet Active';
    private static final String CANCELLED = 'Cancelled';
    private static final String DRAFT     = 'Draft';
    private static final String EXPIRED   = 'Expired';
    private static final String REJECTED  = 'Rejected';
    private static final String SUBMITTED = 'In Approval Process';
    
    private static final Map<String, Set<String>> RECS_MAP = new Map<String, Set<String>>{
        ACTIVE    => new Set<String>{ACTIVE},
        APPROVED  => new Set<String>{APPROVED},
        CANCELLED => new Set<String>{CANCELLED},
        DRAFT     => new Set<String>{DRAFT},
        EXPIRED   => new Set<String>{EXPIRED},
        REJECTED  => new Set<String>{REJECTED},
        SUBMITTED => new Set<String>{SUBMITTED},
        ALL       => new Set<String>{ACTIVE, APPROVED, DRAFT, REJECTED, SUBMITTED}
    };
    
    // value, label
    private static final List<SelectOption> recordStatusList = new List<SelectOption>{
            new SelectOption(SUBMITTED, SUBMITTED),
            new SelectOption(REJECTED,  REJECTED),
            new SelectOption(CANCELLED, CANCELLED),
            new SelectOption(DRAFT,     DRAFT),
            new SelectOption(EXPIRED,   EXPIRED),
            new SelectOption(APPROVED,  APPROVED),
            new SelectOption(ACTIVE,    ACTIVE)
//            new SelectOption(ALL,       'All Conditions')
    };

    private static final Set<String> ACC_REC_TYPES_AAFI = new Set<String>{'Aqualon Customer', 'Aqualon Prospect'};
    private static final Set<String> ACC_REC_TYPES_AHWT = new Set<String>{'Drew Customer', 'Water Prospect'};
    private static final Map<Id,String> ACCOUNT_RECTYPES = RecordType_Functions.RetrieveRecordTypeIdMap('Account');
    
    public String accountId {get; set;}
    
    public final Account acc {get; set;}
    
    public String accountNumber {get; set;}

    public String accountRecordType {get; set;}
    
    public Boolean renderPcs {get; set;}
    
    public String recordStatus {get; set;}
    private Set<String> recordStatusSet;

    public List<Pricing_Condition> pcList; 
    public List<Pricing_Condition__c> pcs {get; set;} 

    public Boolean allSelected {get; set;}
    public String selectedIds {get; set;}
    
    public PageReference returnPage {get; set;}

    public Integer lastPageNumber {get; set;}
    public Integer pageNumber;
    public Integer recordFrom {get; set;}
    public Integer recordTo {get; set;}
    public Integer resultSize {get; set;}    

    public ApexPages.StandardSetController ssc {
        get {
            if (ssc == null) {
                setStandardSetController();
            }
            return ssc;
        }
        set;
    }
    
    public PricingConditionEditController(ApexPages.StandardSetController c) {
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        acc = [select Id, Name, AccountNumber, RecordTypeId,
                      SAP_Customer_Group_1_Desc__c 
                 from Account 
                where Id = :accountId];
        accountNumber = String_Functions.removeLeadingZeros(acc.AccountNumber);
        accountRecordType = ACCOUNT_RECTYPES.get(acc.RecordTypeId);
        recordStatus = SUBMITTED;
        recordStatusSet = RECS_MAP.get(recordStatus);
    }
    
    private void setStandardSetController() {
        pageNumber = 0;
        recordFrom = 0;
        recordTo = 0;
        lastPageNumber = 0;
        Database.Querylocator ql = getQueryLocator();
        ssc = new ApexPages.StandardSetController(ql);
        resultSize = ssc.getResultSize();
        setPageSize(PAGE_SIZE);
        renderPcs = (resultSize > 0);
    }
    
    private Database.Querylocator getQueryLocator() {
        Database.Querylocator ql;
        Date currentDate = Date.today();
        ql = Database.getQueryLocator([
                 select Id, Name, Account__r.RecordTypeId,
                        Account__r.Name, Account__r.AccountNumber,
                        Account__r.SAP_Customer_Group_1_Desc__c,
                        Account__r.SAP_Seller_Name__c, Account__r.SAP_Seller__c,
                        Account_Owner__r.Id, Account_Owner__r.Name, 
                        Account_Owner__r.SAP_Cust_Num__c,
                        Payment_Terms__c, Account_Type__c,
                        Active__c,
                        Customer_Group1_Desc__c, Dist_Channel_Code__c, 
                        Gross_Profit__c, INCO_Term_Code__c, INCO_Term_Name__c, 
                        Invoice_Price__c, Selling_UOM__c,
                        Material2__r.Id, Material2__r.Material_Number__c,
                        Material2__r.Material_Desc__c,
                        Valid_From_Date__c, Valid_To_Date__c,
                        Forecasted_Annual_Volume__c, Volume_UOM__c,
                        Plant_Address__c, Plant_Code__c, Plant_Name__c, 
                        Freight_Up_Charge__c, Has_On_Invoice_Discount__c,
                        Record_Status__c, SAP_Pricing_Table__c, 
                        Used_Scaled_Pricing__c, Comments__c                  
                   from Pricing_Condition__c
                  where Account__c = :accountId
                    and Record_Status__c in :recordStatusSet
               order by Material2__r.Material_Desc__c,
                        Valid_From_Date__c
             ]);
        return ql;
    }
    
    public List<SelectOption> getRecordStatusList() {
        return recordStatusList;
    }

    public void changeRecordStatus() {
        recordStatusSet = RECS_MAP.get(recordStatus);
        setStandardSetController();
    }
    
    public List<Pricing_Condition__c> getPricingConditions() {
        pcs = (List<Pricing_Condition__c>) ssc.getRecords();
        renderPcs = (pcs.size() > 0);
        return pcs;
    }
    
    public List<Pricing_Condition> getPricingConditionList() {
    	setPricingConditionList(pcs);
    	return pcList;
    }
    
    private void setPricingConditionList(List<Pricing_Condition__c> pcs) {
        pcList = new List<Pricing_Condition>();
        for (Pricing_Condition__c pc : pcs) {
            Pricing_Condition p = new Pricing_Condition(pc);
            pcList.add(p);
        }
    }
    
    private Set<String> getSelectedObjectIds() {
        Set<String> ss = new Set<String>();
        selectedIds = '';
        Integer i = 0;
        for (Pricing_Condition pc : pcList) {
            if (pc.selected) {
                ss.add(pc.pricingCondition.id);
                i++;
                if (i > 1) {selectedIds += COMMA;}
                selectedIds += pc.pricingCondition.id;
            }
        }
        return ss;
    }
    
    public PageReference editSelectedList() {
        Set<String> oids = getSelectedObjectIds();
        System.debug(selectedIds);
        return PAGE2;
    }
    
    public Boolean isEditable {
    	get {
    		return (recordStatus == ACTIVE ||
    		        recordStatus == DRAFT ||
    		        recordStatus == REJECTED
    		       );
    	}
    }
    
    public Boolean isDefaultLayout {
        get {
            return (!isAafiLayout && !isAhwtLayout);
            //return false; // for testing only
        }
    }
    
    public Boolean isAafiLayout {
        get {
            return ACC_REC_TYPES_AAFI.contains(accountRecordType);
            //return true; // for testing only
        }
    }
    
    public Boolean isAhwtLayout {
        get {
            return ACC_REC_TYPES_AHWT.contains(accountRecordType);
            //return false; // for testing only
        }
    }
    
    private void setRecordNumbers() {
        allSelected = false;
        Integer n = getPageSize();
        recordFrom = (pageNumber - 1) * n + 1;
        if (recordFrom < 1) {
            recordFrom = 1;
        }
        recordTo = recordFrom + n - 1;
        if (recordTo > resultSize) {
            recordTo = resultSize;
        }
        System.debug(pageNumber + ':' + recordFrom + '-' + recordTo);
    }
    
    public void first() {
        ssc.first();
        resetPageNumbers();
    }
    
    private void resetPageNumbers() {
        pageNumber = 1;
        recordFrom = 1;
        Decimal d = 1.0 * resultSize / getPageSize();
        lastPageNumber = d.round(System.RoundingMode.UP).intValue();  
        setRecordNumbers();
    }
    
    public void last() {
        ssc.last();
        pageNumber = lastPageNumber;
        setRecordNumbers();
    }
    
    public void next() {
        ssc.next();
        pageNumber = ssc.getPageNumber();
        setRecordNumbers();
    }
    
    public void previous() {
        ssc.previous();
        pageNumber = ssc.getPageNumber();
        setRecordNumbers();
    }
    
    public Integer getPageSize() {
        return ssc.getPageSize();
    }
    
    public void setPageSize(Integer n) {
        ssc.setPageSize(n);
        if (resultSize > 0) {
            resetPageNumbers();
        }
    }
    
    public Integer getPageNumber() {
        return pageNumber;
    }
    
    public void setPageNumber(Integer n) {
        pageNumber = n;
        ssc.setPageNumber(pageNumber);
        setRecordNumbers();
    }

/*
 **********************************************************
 Test Methods are in PricingConditionFunctions_Test class
 ********************************************************** 
 */    

}