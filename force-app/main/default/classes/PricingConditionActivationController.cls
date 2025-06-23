public with sharing class PricingConditionActivationController {

    private static final Integer PAGE_SIZE = 200;
    private static final String ACTIVE = 'Active';
    private static final String APPROVED = 'Approved,Not Yet Active';
    private static final String CANCELLED = 'Cancelled';
    private static final String EXPIRED = 'Expired';
    PageReference ajpr = new PageReference('/apexpages/setup/listAsyncApexJobs.apexp');
    PageReference pcap1 = new PageReference('/apex/PricingConditionActivationPage1');

    public Integer resultSize {get; set;}

    public Integer lastPageNumber {get; set;}

    public Integer pageNumber;
    
    public Integer recordFrom {get; set;}
    
    public Integer recordTo {get; set;}
    
    public Boolean disableActivateButton {get; set;}
    
    public Boolean renderApprovedList {get; set;}
    
    public ApexPages.StandardSetController ssc {
        get {
            if (ssc == null) {
                setStandardSetController();
            }
            return ssc;
        }
        set;
    }
    
    public PricingConditionActivationController(ApexPages.StandardSetController c) {
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
        disableActivateButton = (resultSize < 1);
        renderApprovedList = (resultSize > 0);
    }
    
    private Database.Querylocator getQueryLocator() {
        Database.Querylocator ql;
        Date currentDate = Date.today();
        ql = Database.getQueryLocator([
                select Id, Active__c, Comments_Exist__c,
                       CPI_INCO_Term_to_be_Updated__c,
                       Material2__c,
                       Name,
                       Record_Status__c,
                       Send_Notification_1__c,
                       Valid_From_Date__c,
                       Valid_To_Date__c
                  from Pricing_Condition__c
                 where (Record_Status__c = :APPROVED and
                        Valid_To_Date__c >= :currentDate)
                    or (Record_Status__c = :ACTIVE and
                        Valid_To_Date__c < :currentDate)
                 order by Record_Status__c, Name
             ]);
        return ql;
    }
    
    private void setRecordNumbers() {
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
    
    public List<Pricing_Condition__c> getApprovedPricingConditions() {
        List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>) ssc.getRecords();
        renderApprovedList = (pcs.size() > 0);
        return pcs;
    }
    
    public PageReference activatePricingConditions() {
        List<Pricing_Condition__c> pcs = (List<Pricing_Condition__c>) ssc.getRecords();
        PricingConditionActivationFunctions.activatePricingConditions(pcs);
        setStandardSetController();
        return pcap1;
    }
    
    public PageReference submitActivationBatchJob() {
        disableActivateButton = true;
        PricingConditionActivationBatchable pcab = new PricingConditionActivationBatchable();
        Id processId;
        try {
            processId = Database.executeBatch(pcab);
            return ajpr;
        } catch(DmlException de) {
            System.debug(de.getMessage());
        }
        return null;
    }
}